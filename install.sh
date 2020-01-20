#!/bin/bash
set -euxo
source config.sh

WORKING_DIR="$(pwd)/build"
DEST_TOOLCHAIN="$HOME/.rust-ios-arm64/toolchain-$RUST_NIGHTLY"

mkdir -p "$DEST_TOOLCHAIN"
cp -r "$WORKING_DIR/rust-build/build/x86_64-apple-darwin/stage2"/* "$DEST_TOOLCHAIN"
cp -r "$WORKING_DIR/rust-build/build/x86_64-apple-darwin/stage2-tools/x86_64-apple-darwin/release/cargo" "$DEST_TOOLCHAIN/bin"

rustup toolchain link ios-arm64 "$DEST_TOOLCHAIN"
