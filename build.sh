#!/bin/bash
set -euxo
source config.sh

export OPENSSL_STATIC=1
export OPENSSL_DIR=/usr/local/opt/openssl  # for cimac3: /opt/homebrew/opt/openssl@3
if [ ! -d "$OPENSSL_DIR" ]; then
    echo "OpenSSL not found at expected location. Try: brew install openssl"
    exit 1
fi
if ! which ninja; then
    echo "ninja not found. Try: brew install ninja"
    exit 1
fi
if ! which cmake; then
    echo "cmake not found. Try: brew install cmake"
    exit 1
fi

WORKING_DIR="$(pwd)/build"
mkdir -p "$WORKING_DIR"
cd "$WORKING_DIR"

if [ ! -d "llvm-project" ]; then
    git clone \
        --shallow-since="1 year" --no-single-branch \
        https://github.com/apple/llvm-project.git \
    ;
fi
(cd "llvm-project"
    git reset --hard
    git clean -f
    git checkout "$LLVM_BRANCH"
    git apply ../../patches/llvm-system-libs.patch
)

mkdir -p llvm-build
(cd llvm-build
    cmake \
        "$WORKING_DIR/llvm-project/llvm" \
        -DCMAKE_INSTALL_PREFIX="$WORKING_DIR/llvm-root" \
        -DCMAKE_BUILD_TYPE=Release \
        -DLLVM_INSTALL_UTILS=ON \
        -DLLVM_TARGETS_TO_BUILD='X86;ARM;AArch64' \
        -G Ninja \
    ;
    ninja
    ninja install
)

if [ ! -d "rust" ]; then
    git clone https://github.com/rust-lang/rust.git
fi
(cd rust
    git reset --hard
    git clean -f
    git checkout "$RUST_BRANCH"
)

mkdir -p rust-build
(cd rust-build
    ../rust/configure \
        --llvm-config="$WORKING_DIR/llvm-root/bin/llvm-config" \
        --target=aarch64-apple-ios \
        --enable-extended \
        --tools=cargo \
        --release-channel=nightly \
    ;
    CFLAGS_aarch64_apple_ios=-fembed-bitcode \
        python "$WORKING_DIR/rust/x.py" build --stage 2
)
