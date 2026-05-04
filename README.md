# Resume

This repository contains Markdown source files and generated exports for Brett Chapin's resume variants.

## Resume Sources

- `resume-ios.md` - iOS-focused resume source.
- `resume-fullstack.md` - Full Stack-focused resume source.

The Markdown files are the source of truth. PDF and DOCX files are generated from them for sharing and ATS submission.

## Generated Outputs

Resume exports should use this naming convention:

```text
YYYY.mm.dd - Resume (<Resume Type>)
```

Where `<Resume Type>` is either:

- `iOS`
- `Full Stack`

Examples:

```text
2026.05.04 - Resume (iOS).pdf
2026.05.04 - Resume (iOS).docx
2026.05.04 - Resume (Full Stack).pdf
2026.05.04 - Resume (Full Stack).docx
```

## Build Notes

The local build system uses Pandoc to generate both PDF and DOCX outputs. Supporting scripts, LaTeX styling files, templates, and raw source notes are intentionally ignored by Git so the repository stays focused on the resume sources and published outputs.
