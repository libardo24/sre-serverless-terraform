$ErrorActionPreference = "Stop"

$ROOT_DIR = Split-Path -Parent $PSScriptRoot
$BUILD_DIR = Join-Path $ROOT_DIR "lambda\build"
$ZIP_FILE = Join-Path $ROOT_DIR "lambda\lambda.zip"
$REQ_FILE = Join-Path $ROOT_DIR "lambda\requirements.txt"
$HANDLER_FILE = Join-Path $ROOT_DIR "lambda\handler.py"

Remove-Item $BUILD_DIR -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item $ZIP_FILE -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Path $BUILD_DIR -Force | Out-Null

python -m pip install -r $REQ_FILE -t $BUILD_DIR
Copy-Item $HANDLER_FILE $BUILD_DIR -Force

Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::CreateFromDirectory($BUILD_DIR, $ZIP_FILE)

Write-Host "Lambda package created at $ZIP_FILE"