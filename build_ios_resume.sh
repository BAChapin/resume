#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/build_resume_common.sh"

DEFAULT_INPUT="resume-ios.md"
DEFAULT_OUTPUT_BASE="Brett_Chapin_Resume_iOS"
input="$DEFAULT_INPUT"
output_base="$DEFAULT_OUTPUT_BASE"
font_family="${RESUME_FONT_FAMILY:-standard}"
positionals=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --sf)
      font_family="sf"
      shift
      ;;
    --font-family)
      if [[ $# -lt 2 ]]; then
        echo "Missing value for --font-family" >&2
        exit 1
      fi
      font_family="$2"
      shift 2
      ;;
    --help|-h)
      echo "Usage:"
      echo "  ./build_ios_resume.sh [--sf] [--font-family <family>]"
      echo "  ./build_ios_resume.sh [--sf] [--font-family <family>] <output-base-or-file>"
      echo "  ./build_ios_resume.sh [--sf] [--font-family <family>] <input.md> <output-base-or-file>"
      exit 0
      ;;
    *)
      positionals+=("$1")
      shift
      ;;
  esac
done

if [[ ${#positionals[@]} -eq 1 ]]; then
  output_base="$(strip_resume_output_extension "${positionals[0]}")"
elif [[ ${#positionals[@]} -eq 2 ]]; then
  input="${positionals[0]}"
  output_base="$(strip_resume_output_extension "${positionals[1]}")"
elif [[ ${#positionals[@]} -gt 2 ]]; then
  echo "Usage:"
  echo "  ./build_ios_resume.sh [--sf] [--font-family <family>]"
  echo "  ./build_ios_resume.sh [--sf] [--font-family <family>] <output-base-or-file>"
  echo "  ./build_ios_resume.sh [--sf] [--font-family <family>] <input.md> <output-base-or-file>"
  exit 1
fi

RESUME_FONT_FAMILY="$font_family" build_pair "$input" "$output_base"
