# 1. Select the best branch from https://github.com/apple/swift-llvm

# $ xcrun -sdk iphoneos swiftc --version
# Apple Swift version 5.0.1 (swiftlang-1001.0.82.4 clang-1001.0.46.5)
# Target: x86_64-apple-darwin18.7.0

# So this branch seems a likely candidate
SWIFT_BRANCH="swift-5.0-branch"

# 2. Pick/install a working Rust nightly (ideally one where RLS and clippy built)
# 3. Note its date
RUST_NIGHTLY="2019-09-05"

# 4. Get its commit - this is what we will check out to build the iOS version
# rustc --version | cut -d '(' -f2 | cut -d ' ' -f1
RUST_COMMIT="c6e9c76c5"
