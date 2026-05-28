#!/usr/bin/env bash
set -euo pipefail

HEADER_FILE="${HEADER_FILE:-faang-resume-header.tex}"
SF_FONT_HEADER_FILE="${SF_FONT_HEADER_FILE:-sf-resume-fonts.tex}"
REFERENCE_DOCX="${REFERENCE_DOCX:-reference.docx}"
RESUME_SPACING_FILTER="${RESUME_SPACING_FILTER:-resume-spacing.lua}"
PDF_ENGINE="${PDF_ENGINE:-}"
MAIN_FONT="${MAIN_FONT:-}"
SANS_FONT="${SANS_FONT:-}"
MONO_FONT="${MONO_FONT:-}"
RESUME_FONT_FAMILY="${RESUME_FONT_FAMILY:-standard}"

select_pdf_engine() {
  if [[ -n "$PDF_ENGINE" ]]; then
    echo "$PDF_ENGINE"
    return 0
  fi

  local candidate
  for candidate in xelatex lualatex pdflatex tectonic; do
    if command -v "$candidate" >/dev/null 2>&1; then
      echo "$candidate"
      return 0
    fi
  done

  return 1
}

resolve_header_path() {
  local header="$1"
  if [[ "$header" = /* ]]; then
    echo "$header"
  else
    echo "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$header"
  fi
}

resolve_optional_path() {
  local path="$1"
  if [[ "$path" = /* ]]; then
    echo "$path"
  else
    echo "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$path"
  fi
}

prepare_fontconfig_cache() {
  local cache_root
  cache_root="${XDG_CACHE_HOME:-/tmp/codex-fontconfig-cache}"
  mkdir -p "$cache_root/fontconfig"
  export XDG_CACHE_HOME="$cache_root"
}

sf_fonts_available() {
  [[ -f /Library/Fonts/SF-Pro-Text-Regular.otf ]] &&
    [[ -f /Library/Fonts/SF-Pro-Text-Bold.otf ]] &&
    [[ -f /Library/Fonts/SF-Pro-Text-RegularItalic.otf ]] &&
    [[ -f /Library/Fonts/SF-Pro-Text-BoldItalic.otf ]] &&
    [[ -f /Library/Fonts/SF-Pro-Display-Regular.otf ]] &&
    [[ -f /Library/Fonts/SF-Pro-Display-Bold.otf ]] &&
    [[ -f /Library/Fonts/SF-Pro-Display-RegularItalic.otf ]] &&
    [[ -f /Library/Fonts/SF-Pro-Display-BoldItalic.otf ]] &&
    [[ -f /Library/Fonts/SF-Mono-Regular.otf ]] &&
    [[ -f /Library/Fonts/SF-Mono-Bold.otf ]] &&
    [[ -f /Library/Fonts/SF-Mono-RegularItalic.otf ]] &&
    [[ -f /Library/Fonts/SF-Mono-BoldItalic.otf ]]
}

font_installed() {
  local font_name="$1"
  local match
  match="$(fc-match "$font_name" 2>/dev/null || true)"
  [[ -n "$match" && "$match" == *"$font_name"* ]]
}

select_main_font() {
  if [[ -n "$MAIN_FONT" ]]; then
    echo "$MAIN_FONT"
    return 0
  fi

  local candidate
  for candidate in "Aptos" "Helvetica" "Avenir" "Avenir Next" "SF Pro Text" "SF Pro"; do
    if font_installed "$candidate"; then
      echo "$candidate"
      return 0
    fi
  done

  return 1
}

select_sans_font() {
  if [[ -n "$SANS_FONT" ]]; then
    echo "$SANS_FONT"
    return 0
  fi

  select_main_font
}

select_mono_font() {
  if [[ -n "$MONO_FONT" ]]; then
    echo "$MONO_FONT"
    return 0
  fi

  local candidate
  for candidate in "Menlo" "SF Mono" "Monaco" "Courier"; do
    if font_installed "$candidate"; then
      echo "$candidate"
      return 0
    fi
  done

  return 1
}

build_pdf() {
  local input="$1"
  local output="$2"
  local pdf_engine
  local main_font
  local sans_font
  local mono_font
  local header_path
  local sf_font_header_path
  local spacing_filter_path
  local -a pandoc_args

  if ! pdf_engine="$(select_pdf_engine)"; then
    echo "No supported PDF engine found. Install one of: xelatex, lualatex, pdflatex, tectonic." >&2
    exit 1
  fi

  prepare_fontconfig_cache
  header_path="$(resolve_header_path "$HEADER_FILE")"
  sf_font_header_path="$(resolve_header_path "$SF_FONT_HEADER_FILE")"
  spacing_filter_path="$(resolve_optional_path "$RESUME_SPACING_FILTER")"

  pandoc_args=(
    "$input"
    --from markdown+smart
    --pdf-engine="$pdf_engine"
    --standalone
    --include-in-header="$header_path"
    -V documentclass=article
    -V colorlinks=true
    -V urlcolor=blue
    -V fontsize=11pt
  )

  if [[ "$RESUME_FONT_FAMILY" == "sf" ]]; then
    if ! sf_fonts_available; then
      echo "SF font mode requested, but the required SF font files were not found in /Library/Fonts." >&2
      exit 1
    fi
    pandoc_args+=(--include-in-header="$sf_font_header_path")
  else
    if ! main_font="$(select_main_font)"; then
      echo "No supported main font found. Install one of: Aptos, Helvetica, Avenir, Avenir Next, SF Pro Text, SF Pro." >&2
      exit 1
    fi

    if ! sans_font="$(select_sans_font)"; then
      sans_font="$main_font"
    fi

    if ! mono_font="$(select_mono_font)"; then
      mono_font="Courier"
    fi

    pandoc_args+=(
      -V mainfont="$main_font"
      -V sansfont="$sans_font"
      -V monofont="$mono_font"
    )
  fi

  if [[ -f "$spacing_filter_path" ]]; then
    pandoc_args+=(--lua-filter="$spacing_filter_path")
  fi

  pandoc "${pandoc_args[@]}" -o "$output"
}

build_docx() {
  local input="$1"
  local output="$2"
  local spacing_filter_path
  local -a pandoc_args

  spacing_filter_path="$(resolve_optional_path "$RESUME_SPACING_FILTER")"

  pandoc_args=(
    "$input"
    --from markdown+smart
    --reference-doc="$REFERENCE_DOCX"
  )

  if [[ -f "$spacing_filter_path" ]]; then
    pandoc_args+=(--lua-filter="$spacing_filter_path")
  fi

  pandoc "${pandoc_args[@]}" -o "$output"
}

strip_resume_output_extension() {
  local output="$1"

  case "$output" in
    *.pdf)
      echo "${output%.pdf}"
      ;;
    *.docx)
      echo "${output%.docx}"
      ;;
    *)
      echo "$output"
      ;;
  esac
}

build_pair() {
  local input="$1"
  local output_base="$2"

  build_pdf "$input" "${output_base}.pdf"
  build_docx "$input" "${output_base}.docx"
}
