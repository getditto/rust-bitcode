#!/bin/bash
set -euxo
source config.sh

HOST_ARCH="$(rustc -vV | sed -nE 's/host: (.*)/\1/p')"

# The built toolchain that we are going to package
WORKING_DIR="${PWD}/build"
BUILT_TOOLCHAIN_DIR="${WORKING_DIR}/rust-build/build/${HOST_ARCH}"

# The directory which will be added to the final zip file
DEST="${PWD}/dist/rust-${RUST_TOOLCHAIN}"

# The actual toolchain inside that, which will be installed to ~/.rustup/...
TOOLCHAIN_DEST="${DEST}/${RUST_TOOLCHAIN}"

rm -rf "$DEST"
mkdir -p "$TOOLCHAIN_DEST"

# Remove unneeded files from output
rm -rf "${BUILT_TOOLCHAIN_DIR}/stage2/lib/rustlib/src"

# Copy in toolchain artifacts
cp -r \
    "${BUILT_TOOLCHAIN_DIR}/stage2"/* \
    "$TOOLCHAIN_DEST" \
;
cp -r \
    "${BUILT_TOOLCHAIN_DIR}/stage2-tools/$HOST_ARCH/release/cargo" \
    "$TOOLCHAIN_DEST/bin" \
;

# Copy in static files that need to be included in the distribution
cp LICENSE* README.md "$DEST"

sed 's/^    //' >"$DEST/install.sh"<<EOF
    #!/bin/bash
    set -euxo pipefail

    DEST_TOOLCHAIN="\$HOME/.rustup/toolchains/${RUST_TOOLCHAIN}"
    mkdir -p "\$DEST_TOOLCHAIN"
    cp -r "${RUST_TOOLCHAIN}"/* "\$DEST_TOOLCHAIN"

    echo "Installed bitcode-enabled Rust toolchain. Use with: +${RUST_TOOLCHAIN}"
EOF
chmod +x "${DEST}/install.sh"

(cd dist
    rm -f "rust-${RUST_TOOLCHAIN}.zip"
    zip -r "rust-${RUST_TOOLCHAIN}.zip" "rust-${RUST_TOOLCHAIN}"
)
