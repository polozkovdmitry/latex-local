#!/bin/bash

# Check if filename argument is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <document_name>"
    echo "Example: $0 main.tex"
    echo "Example: $0 ks_jj.tex"
    exit 1
fi

# Get the input filename
INPUT_FILE="$1"

# Remove .tex extension if present to get base name
BASENAME="${INPUT_FILE%.tex}"

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Change to src directory
cd "${SCRIPT_DIR}"

# Check if file exists
if [ ! -f "${INPUT_FILE}" ]; then
    echo "Error: File '${INPUT_FILE}' not found in src/ directory!"
    echo "Available .tex files:"
    ls -1 *.tex 2>/dev/null | sed 's|^|  |' || echo "  (none found)"
    exit 1
fi

# First XeLaTeX run - generates .aux file
echo "Running XeLaTeX (first pass) on ${INPUT_FILE}..."
xelatex -interaction=nonstopmode -output-directory=../build "${INPUT_FILE}"

# Run Biber to process bibliography
echo "Running Biber on ${BASENAME}..."
pushd ../build >/dev/null
export BIBINPUTS="${SCRIPT_DIR}//:${BIBINPUTS}"
export BSTINPUTS="${SCRIPT_DIR}//:${BSTINPUTS}"
biber "${BASENAME}"
popd >/dev/null

# Second XeLaTeX run - incorporates bibliography
echo "Running XeLaTeX (second pass) on ${INPUT_FILE}..."
xelatex -interaction=nonstopmode -output-directory=../build "${INPUT_FILE}"

# Third XeLaTeX run - resolves all cross-references
echo "Running XeLaTeX (third pass) on ${INPUT_FILE}..."
xelatex -interaction=nonstopmode -output-directory=../build "${INPUT_FILE}"

echo "Compilation complete! PDF saved to build/${BASENAME}.pdf"