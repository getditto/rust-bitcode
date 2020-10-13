#!/bin/bash
set -euxo
source config.sh

# The built toolchain that we are going to package
WORKING_DIR="$(pwd)/build"

# The directory which will be added to the final zip file
DEST="$(pwd)/dist/rust-${RUST_TOOLCHAIN}"

# The actual toolchain inside that, which will be installed to ~/.rustup/...
TOOLCHAIN_DEST="${DEST}/${RUST_TOOLCHAIN}"

rm -rf "$DEST"
mkdir -p "$TOOLCHAIN_DEST"

# Remove unneeded files from output
rm -rf "$WORKING_DIR/rust-build/build/x86_64-apple-darwin/stage2/lib/rustlib/src"

# Copy in toolchain artifacts
cp -r "$WORKING_DIR/rust-build/build/x86_64-apple-darwin/stage2"/* "$TOOLCHAIN_DEST"
cp -r "$WORKING_DIR/rust-build/build/x86_64-apple-darwin/stage2-tools/x86_64-apple-darwin/release/cargo" "$TOOLCHAIN_DEST/bin"

# Copy in static files that need to be included in the distribution
cp LICENSE* README.md "$DEST"

echo "#!/bin/bash" >> "$DEST/install.sh"
echo "DEST_TOOLCHAIN=\"\$HOME/.rustup/toolchains/$RUST_TOOLCHAIN\"" >> "$DEST/install.sh"
echo "mkdir -p \"\$DEST_TOOLCHAIN\"" >> $DEST/install.sh
echo "cp -r \"$RUST_TOOLCHAIN\"/* \"\$DEST_TOOLCHAIN\"" >> "$DEST/install.sh"
chmod +x "$DEST/install.sh"

cd dist
rm -f "rust-${RUST_TOOLCHAIN}.zip"
zip -r "rust-${RUST_TOOLCHAIN}.zip" "rust-${RUST_TOOLCHAIN}"
cd ..
