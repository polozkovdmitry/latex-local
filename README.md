# LaTeX Infinite Compile Project

Local XeLaTeX + VS Code + LaTeX Workshop.
Unlimited compiles, no cloud limits.

## Requirements

- XeLaTeX toolchain (recommended: `texlive` with `latexmk`)
- VS Code + LaTeX Workshop (optional, but recommended)

## Quick start

From the repo root:

```bash
# Compile a .tex file from src/ into build/
./src/compile.sh main
```

Output PDFs are written to `build/`.

## Notes

- This repo intentionally keeps build artifacts out of version control; commit source files in `src/`, not generated outputs.