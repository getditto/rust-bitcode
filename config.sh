# 1. Select the best branch, tag or commit hash from https://github.com/apple/llvm-project
# The recommended approach is to use the tagged release that matches the Swift version
# returned by the command below:
# $ xcrun -sdk iphoneos swiftc --version

LLVM_BRANCH="swift-5.3.2-RELEASE"

# 2. Select the best branch, tag or commit hash from https://github.com/rust-lang/rust

RUST_BRANCH="bd41e09da334697c0f993b36685cb599061d9faa" # nightly-2021-10-19

# 3. Select a name for the toolchain you want to install as. The toolchain will be installed
# under $HOME/.rustup/toolchains/rust-$RUST_TOOLCHAIN

RUST_TOOLCHAIN="ios-arm64-nightly-2021-10-19"
