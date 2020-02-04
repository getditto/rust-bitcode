# 1. Select the best branch from https://github.com/apple/llvm-project

# $ xcrun -sdk iphoneos swiftc --version
# Apple Swift version 5.1 (swiftlang-1100.0.270.13 clang-1100.0.33.7)
# Target: x86_64-apple-darwin19.0.0

# There is a branch called "apple/stable/20190619" which is equivalent to the "stable"
# Branch under https://github.com/apple/swift-llvm under which looks promising.
# At this time (running Xcode 11.3) it's a couple of months newer than the 5.1 branch
LLVM_BRANCH="apple/stable/20190619"

# 2. Pick/install a working Rust nightly (ideally one where RLS and clippy built)
# 3. Note its date
RUST_NIGHTLY="2019-12-16"

# 4. Get its commit - this is what we will check out to build the iOS version
# rustc --version | cut -d '(' -f2 | cut -d ' ' -f1
RUST_COMMIT="a605441e0"
