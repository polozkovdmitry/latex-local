# LaTeX Infinite Repository Structure

This document contains all the contents of the `latex-infinite` repository to help understand its structure and create similar files.

## Repository Structure

```
latex-infinite/
├── .gitignore
├── .vscode/
│   └── settings.json
├── build/              (build output directory, ignored by git)
├── LICENSE
├── README.md
└── src/
    └── main.tex
```

## File Contents

### README.md

```1:5:README.md
# LaTeX Infinite Compile Project

Local XeLaTeX + VS Code + LaTeX Workshop.
Unlimited compiles, no cloud limits.
```

### .gitignore

```1:9:.gitignore
/build/
*.aux
*.log
*.out
*.toc
*.synctex.gz
*.fls
*.fdb_latexmk
```

### .vscode/settings.json

```1:27:.vscode/settings.json
{
    "latex-workshop.latex.autoBuild.run": "onFileChange",
    "latex-workshop.latex.clean.enabled": true,
    "latex-workshop.latex.outDir": "%DIR%/build",
    "latex-workshop.latex.recipe.default": "latexmk (xelatex)",
    "latex-workshop.latex.recipes": [
      {
        "name": "latexmk (xelatex)",
        "tools": ["latexmk-xe"]
      }
    ],
    "latex-workshop.latex.tools": [
      {
        "name": "latexmk-xe",
        "command": "latexmk",
        "args": [
          "-xelatex",
          "-synctex=1",
          "-interaction=nonstopmode",
          "-file-line-error",
          "-output-directory=%OUTDIR%",
          "%DOC%"
        ]
      }
    ]
  }
```

### src/main.tex

```1:24:src/main.tex
\documentclass[12pt]{article}

\usepackage{fontspec}
\usepackage{amsmath}
\usepackage{amssymb}
\usepackage{graphicx}
\usepackage{hyperref}
\usepackage{geometry}
\geometry{margin=1in}

\setmainfont{Latin Modern Roman}

\title{Project Title}
\author{Author}
\date{}

\begin{document}
\maketitle

\section{Start}
Your text here.

\end{document}
```

## Key Features

1. **XeLaTeX Compilation**: Uses XeLaTeX via `latexmk` for Unicode support and modern font handling
2. **VS Code Integration**: Configured with LaTeX Workshop extension for automatic compilation
3. **Build Directory**: Output files are placed in `build/` directory to keep source clean
4. **Auto-compile**: Automatically rebuilds on file changes
5. **Font Support**: Uses `fontspec` package with Latin Modern Roman as the main font
6. **Standard Packages**: Includes common packages for math, graphics, hyperlinks, and page geometry

## Configuration Details

- **Compiler**: XeLaTeX (via latexmk)
- **Output Directory**: `build/` (relative to project root)
- **Auto-build**: Enabled on file change
- **SyncTeX**: Enabled for forward/backward search
- **Error Handling**: Non-stop mode with file-line-error reporting

## License

Apache License 2.0 (see LICENSE file)

