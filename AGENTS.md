# AGENTS.md — Resume Build System

## 📄 Overview

This directory contains Markdown-based resumes and a reproducible build pipeline using **Pandoc** to generate:

- **PDF** → primary format for human review
- **DOCX** → fallback for ATS systems

The goal of this system is:
- Maintain a **single source of truth (Markdown)**
- Enable **consistent, repeatable exports**
- Support **multiple tailored resume variants** (iOS, Full-Stack, etc.)

---

## 🏷️ Build Naming Convention

Whenever the user asks to build, generate, export, or regenerate the resumes, use this output naming convention:

```text
YYYY.mm.dd - Resume (<Resume Type>)
```

Where `<Resume Type>` must be exactly one of:

- `iOS`
- `Full Stack`

Examples:

```text
2026.05.04 - Resume (iOS).pdf
2026.05.04 - Resume (iOS).docx
2026.05.04 - Resume (Full Stack).pdf
2026.05.04 - Resume (Full Stack).docx
```

Use the current local date for `YYYY.mm.dd` unless the user explicitly requests a different date.

---

## 🧹 Export Cleanup

After successfully generating new PDF and DOCX resume files, delete older generated resume exports for the same resume types so the directory only keeps the current dated outputs.

This cleanup applies to files matching:

```text
YYYY.mm.dd - Resume (iOS).pdf
YYYY.mm.dd - Resume (iOS).docx
YYYY.mm.dd - Resume (Full Stack).pdf
YYYY.mm.dd - Resume (Full Stack).docx
```

Do not delete the Markdown source files, build scripts, templates, raw data, or any explicitly requested archived exports.

---

## 📁 Directory Structure

```bash
resume/
├── resume-ios.md
├── resume-fullstack.md
├── faang-resume-header.tex
├── reference.docx
├── build_resume_common.sh (optional)
├── build_ios_resume.sh (optional)
├── build_fullstack_resume.sh (optional)
├── AGENTS.md
