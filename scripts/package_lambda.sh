#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="${ROOT_DIR}/lambda/build"
ZIP_FILE="${ROOT_DIR}/lambda/lambda.zip"

rm -rf "${BUILD_DIR}" "${ZIP_FILE}"
mkdir -p "${BUILD_DIR}"

python3 -m pip install -r "${ROOT_DIR}/lambda/requirements.txt" -t "${BUILD_DIR}" >/dev/null
cp "${ROOT_DIR}/lambda/handler.py" "${BUILD_DIR}/"

(
  cd "${BUILD_DIR}"
  zip -rq "${ZIP_FILE}" .
)

echo "Lambda package created at ${ZIP_FILE}"