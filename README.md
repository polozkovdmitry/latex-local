# LaTeX Project Repository

Local XeLaTeX + VS Code + LaTeX Workshop. Unlimited compiles, shared preambles, per-project isolation.

---

## Prerequisites

### macOS (recommended)

```bash
brew install --cask mactex-no-gui   # full TeX Live: XeLaTeX, biber, latexmk
```

Or use BasicTeX (smaller) and install required packages manually:

```bash
brew install --cask basictex
sudo tlmgr update --self
sudo tlmgr install \
  latexmk biblatex biber \
  fontspec babel-russian \
  amsmath amssymb amsthm stmaryrd breqn euscript rsfs \
  enumitem empheq wrapfig subcaption dblfloatfix \
  pifont lipsum todonotes csquotes \
  beamer
```

### Fonts

- **Times New Roman** — bundled on macOS. On Linux, install the `ttf-mscorefonts-installer` package or switch to `TeX Gyre Termes` in the preamble.

### VS Code (optional)

Install the **LaTeX Workshop** extension (`James-Yu.latex-workshop`). The workspace settings in `.vscode/settings.json` are pre-configured.

---

## Directory layout

```
latex-local/
├── shared/
│   ├── notations.tex                  # shared math macros (used by all projects)
│   └── templates/
│       ├── preamble-article.tex       # single-column article preamble
│       ├── preamble-article-twocol.tex # two-column article preamble
│       └── preamble-beamer.tex        # Beamer slides preamble
├── projects/
│   ├── public/                        # git-tracked — ready to share
│   │   ├── thesis/                    # master's thesis (Langevin algorithms)
│   │   ├── ksjj/                      # KSJJ paper (Kramers-Smoluchowski)
│   │   │   └── archive/               # older drafts
│   │   └── _archive/                  # legacy standalone documents
│   └── private/                       # git-IGNORED — safe working space
│       └── (your drafts here)
├── build/                             # git-ignored; XeLaTeX/biber aux files
├── pdfs/                              # git-ignored; final PDFs only
├── compile.sh                         # CLI compiler (see Quickstart)
└── .vscode/settings.json              # LaTeX Workshop auto-build config
```

---

## Quickstart

```bash
# Compile a project by name — PDF lands in pdfs/public/<name>.pdf
./compile.sh ksjj
./compile.sh thesis

# Or pass a full path
./compile.sh projects/public/ksjj/ksjj.tex
```

---

## Adding a new document

1. **Create the project folder:**

   ```bash
   mkdir -p projects/public/<name>/figures
   touch projects/public/<name>/references.bib
   ```

2. **Create `projects/public/<name>/<name>.tex`:**

   ```latex
   \documentclass[12pt]{article}
   \input{preamble-article}          % or preamble-article-twocol, preamble-beamer
   \graphicspath{{figures/}}

   \begin{document}

   \begin{center}
   \textit{Document Title}\\
   \textit{Author: Your Name}\\
   \textit{Date: \today}
   \end{center}

   \tableofcontents
   \newpage

   % --- your content ---

   \printbibliography
   \end{document}
   ```

   For a **Beamer** presentation, use `\documentclass{beamer}` + `\input{preamble-beamer}` and replace `\begin{document}` content with `\begin{frame}...\end{frame}` blocks.

   For a **two-column** article, use `\documentclass[11pt,twocolumn]{article}` + `\input{preamble-article-twocol}`.

3. **Compile:**

   ```bash
   ./compile.sh <name>
   ```

---

## Public vs private workflow

- Start work privately: create your project under `projects/private/<name>/`. Git never sees it.
- When ready to publish: `mv projects/private/<name> projects/public/<name>`. On the next `git status` it appears as untracked and you can stage and commit normally.

---

## How `compile.sh` works

The script runs **XeLaTeX → Biber → XeLaTeX → XeLaTeX** and copies the final PDF to `pdfs/<visibility>/<name>.pdf`. It sets `TEXINPUTS` and `BIBINPUTS` so that `\input{preamble-article}` and `\input{notations}` resolve to the files in `shared/templates/` and `shared/` regardless of which project is being compiled.

## Notes

- Build artifacts (`.aux`, `.log`, `.bbl`, etc.) go into `build/` — never committed.
- Final PDFs go into `pdfs/` — also never committed (regenerate with `compile.sh`).
- `shared/notations.tex` defines project-wide math macros; edit it freely but be aware changes affect every project.
- Each project's `references.bib` is independent — add only the citations you actually use.
