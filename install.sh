#!/bin/bash
set -euxo
source config.sh

WORKING_DIR="$(pwd)/build"
DEST_TOOLCHAIN="$HOME/.rustup/toolchains/$RUST_TOOLCHAIN"

# Remove unneeded files from output
rm -rf "$WORKING_DIR/rust-build/build/x86_64-apple-darwin/stage2/lib/rustlib/src"

rm -rf "$DEST_TOOLCHAIN"
mkdir -p "$DEST_TOOLCHAIN"
cp -r "$WORKING_DIR/rust-build/build/x86_64-apple-darwin/stage2"/* "$DEST_TOOLCHAIN"
cp -r "$WORKING_DIR/rust-build/build/x86_64-apple-darwin/stage2-tools/x86_64-apple-darwin/release/cargo" "$DEST_TOOLCHAIN/bin"

echo "Installed bitcode-enabled Rust toolchain. Use with: +$RUST_TOOLCHAIN"
