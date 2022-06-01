#!/bin/bash

set -euxo

source config.sh

WORKING_DIR="$(pwd)/build"
RUST_TARGET_ARCH="$(rustc --print cfg | grep target_arch | awk -F= '{ print $2 }' | tr -d '"')"

STAGE_DIR="${WORKING_DIR}/rust-build/build/${RUST_TARGET_ARCH}-apple-darwin/stage2"

# remove unnecessary files from output

rm -rf "${STAGE_DIR}/lib/rustlib/src"

# setup toolchain directory

DEST_TOOLCHAIN="${HOME}/.rustup/toolchains/${RUST_TOOLCHAIN}"

rm -rf "${DEST_TOOLCHAIN}"
mkdir -p "${DEST_TOOLCHAIN}"

# install artifacts

cp -r "${STAGE_DIR}"/* "${DEST_TOOLCHAIN}"
cp -r "${STAGE_DIR}-tools/${RUST_TARGET_ARCH}-apple-darwin/release/cargo" "${DEST_TOOLCHAIN}/bin"

echo "Installed bitcode-enabled Rust toolchain. Use with: +${RUST_TOOLCHAIN}"
