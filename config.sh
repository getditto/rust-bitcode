# 1. Select the best branch, tag or commit hash from https://github.com/apple/llvm-project
# The recommended approach is to use the tagged release that matches the Swift version
# returned by the command below (at this time running Xcode Version 11.3.1 (11C504))
# $ xcrun -sdk iphoneos swiftc --version
# Apple Swift version 5.1.3 (swiftlang-1100.0.282.1 clang-1100.0.33.15)
# Target: x86_64-apple-darwin19.3.0

LLVM_BRANCH="tags/swift-5.2.3-RELEASE"

# 2. Select the best branch, tag or commit hash from https://github.com/rust-lang/rust
# The stable 1.40.0 version of Rust seems to work

RUST_BRANCH="tags/1.43.0"

# 3. Select a name for the toolchain you want to install as. The toolchain will be installed
# under $HOME/.rust-ios-arm64/toolchain-$RUST_TOOLCHAIN

RUST_TOOLCHAIN="1.43.0"

