# LaTeX Infinite Compile Project

Local XeLaTeX + VS Code + LaTeX Workshop.
Unlimited compiles, no cloud limits.

## Compilation

Compile a LaTeX document using the `compile.sh` script:

```bash
# Compile main.tex
./src/compile.sh main.tex

# Compile ks_jj.tex
./src/compile.sh ks_jj.tex

# You can also omit the .tex extension
./src/compile.sh main
./src/compile.sh ks_jj
```

The compiled PDF will be saved in the `build/` directory.