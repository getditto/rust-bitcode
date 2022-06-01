#!/bin/bash

set -euxo

source config.sh

# verify build requirements are present

if ! command -v cmake &> /dev/null; then
    echo "cmake not found. Try: brew install cmake"
    exit 1
fi
if ! command -v ninja &> /dev/null; then
    echo "ninja not found. Try: brew install ninja"
    exit 1
fi
if ! command -v openssl &> /dev/null; then
    echo "openssl not found. Try: brew install openssl"
    exit 1
fi

# setup openssl environment

set +x

# default lookup directory prior to 2022.06
export OPENSSL_DIR='/usr/local/opt/openssl'
export OPENSSL_STATIC=1

if [ ! -d "$OPENSSL_DIR" ]; then
    printf "OpenSSL not found at expected location (%s). Trying another location...\n" "${OPENSSL_DIR}"
    
    # location where brew installs the latest openssl version (in 2022.06)
    export OPENSSL_DIR='/opt/homebrew/opt/openssl@3'
    if [ ! -d "$OPENSSL_DIR" ]; then
        printf "OpenSSL not found at expected location (%s). Trying another location...\n" "${OPENSSL_DIR}"
        
        # location where macports installs the latest openssl version (in 2022.06)
        export OPENSSL_DIR='/opt/local/libexec/openssl3'
        if [ ! -d "$OPENSSL_DIR" ]; then
            printf "OpenSSL not found at expected location (%s). Try: brew install openssl\n" "${OPENSSL_DIR}"
            exit 1
        fi
    fi
fi

echo "OPENSSL_DIR=${OPENSSL_DIR}"
echo "OPENSSL_STATIC=${OPENSSL_STATIC}"

# setup work directory

set -x

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

# setup llvm build directory

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

# clone rust repo

if [ ! -d "rust" ]; then
    git clone https://github.com/rust-lang/rust.git
fi
(cd rust
    git reset --hard
    git clean -f
    git checkout "$RUST_BRANCH"
)

# setup rust build directory

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
