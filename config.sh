# 1. Select the best branch from https://github.com/apple/swift-llvm

# $ xcrun -sdk iphoneos swiftc --version
# Apple Swift version 5.0.1 (swiftlang-1001.0.82.4 clang-1001.0.46.5)
# Target: x86_64-apple-darwin18.7.0

# swift-5.0-branch corresponds to LLVM 7
# swift-5.1-branch corresponds to LLVM 8
# To determine the LLVM version look inside the CMakeLists.txt file around lines 18-29
# where it sets the version. There is also a note that the swift-llvm repository is frozen
# and for historical purposes only, and that active development is happening in
# https://github.com/apple/llvm-project so we may need to move as well for future versions
# of LLVM.
SWIFT_BRANCH="swift-5.1-branch"
LLVM_VERSION="8"   # only used for naming purposes below

# 2. Pick/install a working Rust nightly (ideally one where RLS and clippy built)
# 3. Note its date
RUST_NIGHTLY="2019-09-05"

# 4. Get its commit - this is what we will check out to build the iOS version
# rustc --version | cut -d '(' -f2 | cut -d ' ' -f1
RUST_COMMIT="c6e9c76c5"

TOOLCHAIN_NAME="fs-${RUST_NIGHTLY}-llvm${LLVM_VERSION}"
