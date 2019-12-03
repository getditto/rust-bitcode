#!/bin/bash
set -euxo
source config.sh

WORKING_DIR="$(pwd)/build"
DEST_TOOLCHAIN="$HOME/.fs-rust/toolchain-${TOOLCHAIN_NAME}"

mkdir -p "$DEST_TOOLCHAIN"
cp -r "$WORKING_DIR/rust-build/build/x86_64-apple-darwin/stage2"/* "$DEST_TOOLCHAIN"

rustup toolchain link ${TOOLCHAIN_NAME} "$DEST_TOOLCHAIN"
