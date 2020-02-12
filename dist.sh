#!/bin/bash
set -euxo
source config.sh

WORKING_DIR="$(pwd)/build"
DEST="$(pwd)/dist/rust-ios-arm64-${RUST_TOOLCHAIN}"
TOOLCHAIN_DEST="${DEST}/toolchain-${RUST_TOOLCHAIN}"

rm -rf "$TOOLCHAIN_DEST"
mkdir -p "$TOOLCHAIN_DEST"
cp -r "$WORKING_DIR/rust-build/build/x86_64-apple-darwin/stage2"/* "$TOOLCHAIN_DEST"
cp -r "$WORKING_DIR/rust-build/build/x86_64-apple-darwin/stage2-tools/x86_64-apple-darwin/release/cargo" "$TOOLCHAIN_DEST/bin"

cp LICENSE* README.md "$DEST"

rm -rf "$DEST/install.sh"
echo "#!/bin/bash" >> "$DEST/install.sh"
echo "DEST_TOOLCHAIN=\"\$HOME/.rust-ios-arm64/toolchain-$RUST_TOOLCHAIN\"" >> "$DEST/install.sh"
echo "mkdir -p \"\$DEST_TOOLCHAIN\"" >> $DEST/install.sh
echo "cp -r \"toolchain-$RUST_TOOLCHAIN\"/* \"\$DEST_TOOLCHAIN\"" >> "$DEST/install.sh"
echo "rustup toolchain link ios-arm64 \"\$DEST_TOOLCHAIN\"" >> "$DEST/install.sh"
chmod +x "$DEST/install.sh"

cd dist
zip -r "rust-ios-arm64-${RUST_TOOLCHAIN}.zip" "rust-ios-arm64-${RUST_TOOLCHAIN}"
cd ..
