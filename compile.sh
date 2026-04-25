#!/bin/bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

usage() {
    echo "Usage: $0 <project>"
    echo ""
    echo "  <project>  Project name (e.g. thesis, ksjj) or path to a .tex file"
    echo ""
    echo "Examples:"
    echo "  $0 ksjj"
    echo "  $0 thesis"
    echo "  $0 projects_public/ksjj/ksjj.tex"
    exit 1
}

[[ $# -eq 0 ]] && usage

INPUT="$1"

# If a .tex file path is given directly, resolve it
if [[ "$INPUT" == *.tex ]]; then
    TEX_FILE="$(cd "$(dirname "$INPUT")" && pwd)/$(basename "$INPUT")"
    PROJECT_DIR="$(dirname "$TEX_FILE")"
    PROJECT_NAME="$(basename "$TEX_FILE" .tex)"
    # Determine visibility from path
    if [[ "$TEX_FILE" == */projects_private/* ]]; then
        VISIBILITY="private"
    else
        VISIBILITY="public"
    fi
else
    # Treat as project name — search public then private
    PROJECT_NAME="$INPUT"
    if [[ -f "${REPO_DIR}/projects_public/${PROJECT_NAME}/${PROJECT_NAME}.tex" ]]; then
        VISIBILITY="public"
        PROJECT_DIR="${REPO_DIR}/projects_public/${PROJECT_NAME}"
        TEX_FILE="${PROJECT_DIR}/${PROJECT_NAME}.tex"
    elif [[ -f "${REPO_DIR}/projects_private/${PROJECT_NAME}/${PROJECT_NAME}.tex" ]]; then
        VISIBILITY="private"
        PROJECT_DIR="${REPO_DIR}/projects_private/${PROJECT_NAME}"
        TEX_FILE="${PROJECT_DIR}/${PROJECT_NAME}.tex"
    else
        echo "Error: project '${PROJECT_NAME}' not found."
        echo "Looked in:"
        echo "  ${REPO_DIR}/projects_public/${PROJECT_NAME}/${PROJECT_NAME}.tex"
        echo "  ${REPO_DIR}/projects_private/${PROJECT_NAME}/${PROJECT_NAME}.tex"
        exit 1
    fi
fi

BUILD_DIR="${REPO_DIR}/build_${VISIBILITY}/${PROJECT_NAME}"
PDF_DIR="${REPO_DIR}/pdfs_${VISIBILITY}"
mkdir -p "${BUILD_DIR}" "${PDF_DIR}"

export TEXINPUTS="./:${REPO_DIR}/shared//:${REPO_DIR}/shared/templates//:"
export BIBINPUTS="${PROJECT_DIR}/:${REPO_DIR}/shared//:"

cd "${PROJECT_DIR}"

echo "=== Compiling ${PROJECT_NAME} (${VISIBILITY}) ==="
echo "    source : ${TEX_FILE}"
echo "    build  : ${BUILD_DIR}"

echo "--- XeLaTeX pass 1 ---"
xelatex -interaction=nonstopmode -output-directory="${BUILD_DIR}" "${TEX_FILE}"

echo "--- Biber ---"
(cd "${BUILD_DIR}" && biber "${PROJECT_NAME}")

echo "--- XeLaTeX pass 2 ---"
xelatex -interaction=nonstopmode -output-directory="${BUILD_DIR}" "${TEX_FILE}"

echo "--- XeLaTeX pass 3 ---"
xelatex -interaction=nonstopmode -output-directory="${BUILD_DIR}" "${TEX_FILE}"

FINAL_PDF="${BUILD_DIR}/${PROJECT_NAME}.pdf"
if [[ -f "${FINAL_PDF}" ]]; then
    cp "${FINAL_PDF}" "${PDF_DIR}/${PROJECT_NAME}.pdf"
    echo ""
    echo "=== Done ==="
    echo "    PDF: ${PDF_DIR}/${PROJECT_NAME}.pdf"
else
    echo "Error: expected PDF not found at ${FINAL_PDF}" >&2
    exit 1
fi
