#!/bin/bash
set -euxo
source config.sh

WORKING_DIR="$(pwd)/build"
mkdir -p "$WORKING_DIR"

if ! which ninja; then
    echo "ninja not found. Try: brew install ninja"
    exit 1
fi
if ! which cmake; then
    echo "cmake not found. Try: brew install cmake"
    exit 1
fi

cd "$WORKING_DIR"
if [ ! -d "$WORKING_DIR/swift-llvm" ]; then
    git clone https://github.com/apple/swift-llvm.git -b "$SWIFT_BRANCH"
fi
cd "$WORKING_DIR/swift-llvm"
git reset --hard
git clean -f
git checkout "origin/$SWIFT_BRANCH"
cd ..

mkdir -p llvm-build
cd llvm-build
cmake "$WORKING_DIR/swift-llvm" -DCMAKE_INSTALL_PREFIX="$WORKING_DIR/llvm-root" -DCMAKE_BUILD_TYPE=Release -DLLVM_INSTALL_UTILS=ON -DLLVM_TARGETS_TO_BUILD='X86;ARM;AArch64' -G Ninja
ninja
ninja install

cd "$WORKING_DIR"
if [ ! -d "$WORKING_DIR/rust" ]; then
    git clone https://github.com/rust-lang/rust.git
fi
cd rust
git reset --hard
git clean -f
git checkout "$RUST_COMMIT"
cd ..
mkdir -p rust-build
cd rust-build
IOS_TARGETS=aarch64-apple-ios,armv7-apple-ios,x86_64-apple-ios,x86_64-apple-darwin
ANDROID_TARGETS=aarch64-linux-android,armv7-linux-androideabi,i686-linux-android,x86_64-linux-android
../rust/configure --llvm-config="$WORKING_DIR/llvm-root/bin/llvm-config" --target=${IOS_TARGETS},${ANDROID_TARGETS}
export RUSTFLAGS_NOT_BOOTSTRAP=-Zembed-bitcode
export CFLAGS_aarch64_apple_ios=-fembed-bitcode
export CFLAGS_armv7_apple_ios=-fembed-bitcode
python "$WORKING_DIR/rust/x.py" build
