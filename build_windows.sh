#!/usr/bin/env bash
set -eu

OUT_DIR="build/windows"
WIN_SDK="$HOME/.local/share/xwin"
LIBPATH_SDK="$WIN_SDK/sdk/lib/um/x86_64"
LIBPATH_UCRT="$WIN_SDK/sdk/lib/ucrt/x86_64"
LIBPATH_CRT="$WIN_SDK/crt/lib/x86_64"

if [ ! -d "$WIN_SDK" ]; then
    echo "ERROR: Windows SDK not found on $WIN_SDK"
    echo "For a one time download, run:"
    echo "  xwin --accept-license splat --output ~/.local/share/xwin"
    exit 1
fi

mkdir -p "$OUT_DIR"

echo "Compiling Windows (x86_64) release..."
odin build source/main_release \
    -target:windows_amd64 \
    -linker:lld \
    -windows-sdk-root:"$WIN_SDK" \
    -extra-linker-flags:"/libpath:$LIBPATH_SDK /libpath:$LIBPATH_UCRT /libpath:$LIBPATH_CRT" \
    -out:"$OUT_DIR/game.exe" \
    -strict-style \
    -vet \
    -no-bounds-check \
    -o:speed

# Copy assets folder along with the exe
cp -R assets "$OUT_DIR/"

echo "Windows build succesfully created at: $OUT_DIR"
