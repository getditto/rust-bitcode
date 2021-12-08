# 1. Select the best branch, tag or commit hash from https://github.com/apple/llvm-project
# The recommended approach is to use the tagged release that matches the Swift version
# returned by the command below:
# $ xcrun -sdk iphoneos swiftc --version

set -euxo pipefail

RUST_TOOLCHAIN="1.57.0"

LLVM_BRANCH="swift-5.3.2-RELEASE"

get_rust_commit_for_toolchain() (
    # Yields "" for a toolchain like `x.y.z`, and `mm-dd-yy` for `nightly-mm-dd-yy`
    IF_NIGHTLY_DATE_STRIPPED=$(echo "${RUST_TOOLCHAIN}" | sed -n 's/^nightly-//p')
    if [ -n "${IF_NIGHTLY_DATE_STRIPPED}" ]; then
        curl "https://static.rust-lang.org/dist/${IF_NIGHTLY_DATE_STRIPPED}/channel-rust-nightly-git-commit-hash.txt"
    else
        echo "refs/tags/${RUST_TOOLCHAIN}"
    fi
)

# 2. Select the best branch, tag or commit hash from https://github.com/rust-lang/rust

RUST_BRANCH="$(get_rust_commit_for_toolchain)"

# 3. Select a name for the toolchain you want to install as. The toolchain will be installed
# under $HOME/.rustup/toolchains/rust-$RUST_TOOLCHAIN

RUST_TOOLCHAIN="ios-arm64-${RUST_TOOLCHAIN}"
