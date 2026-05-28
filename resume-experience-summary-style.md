# Resume Experience Summary Style

## Purpose

This resume style consolidates each job into one readable summary followed by a focused technology callout. The goal is to help non-technical reviewers quickly understand the work, audience, and business value while still giving technical reviewers enough keywords to recognize the depth of the experience.

## Structure

Each role should use this pattern:

```markdown
### Job Title — Company
Date – Date

Plain-English summary paragraph.

**Technologies:** Tool, Framework, Platform, Language, Practice
```

## Summary Ideology

The summary should answer three questions in one paragraph:

- What did I do?
- Who was it for?
- What benefit did the work create?

Write for an HR manager first. Use product names, audience names, scale, and outcomes. Avoid leading with implementation details unless the technology itself is central to the business value.

Good summary language is simple, concrete, and human:

- "built and maintained features for bp's earnify iOS app"
- "made releases safer"
- "helped product teams understand user behavior"
- "made hardware-test integrations easier for other developers"

Avoid dense engineering-only phrasing in the paragraph:

- "implemented Combine pipelines"
- "refactored VIPER interactors"
- "migrated auth token acquisition"

Those details belong in the technology line unless they directly explain the impact.

## Technology Line Ideology

The technology line should preserve searchability and technical credibility without competing with the summary. Include languages, frameworks, architectures, platforms, delivery tools, and testing practices that are specific to the role.

Keep the line compact and grouped by relevance rather than exhaustive history. Prefer terms likely to matter to recruiters, hiring managers, ATS systems, or technical interviewers.

## Tone

Use first person when it makes the summary sound natural and personally owned. Avoid repetitive openers like "The [Company] role..." across every job. Prefer plain, human phrasing such as "At Sweetwater, I..." or "As a self-employed iOS developer, I..." while keeping the tone direct, senior, and outcome-oriented.

## Source Priority

When rewriting future roles, use this source order:

1. Current resume Markdown
2. `Raw Data/work-experience-from-logs.md`
3. `Raw Data/consolidated_old_technical_experience.md`

Use raw data to sharpen audience, scale, risk, and outcome. Do not import every raw detail into the resume; use it to choose the clearest story.
