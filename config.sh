# 1. Select the best branch, tag or commit hash from https://github.com/apple/llvm-project
# The recommended approach is to use the tagged release that matches the Swift version
# returned by the command below:
# $ xcrun -sdk iphoneos swiftc --version

set -euxo pipefail

RUST_TOOLCHAIN="1.60.0"

# Note(Daniel): the official tagged releases of that llvm fork are currently
# lagging too much behind the official `llvm`, which makes them incompatible
# with the LLVM API required to compile the Rust toolchain, at least as of 1.60.
# So neither swift-5.6.1-RELEASE nor swift-5.7-DEVELOPMENT-SNAPSHOT-2022-04-12-a
#
# But the tip of `apple/llvm-project`'s is too advanced as well, so I've had
# to find a "sweet spot" in between both. I guess a decent approach could be
# to start at https://github.com/rust-lang/rust/blob/1.60.0/.gitmodules#L37, and
# to find a commit in `apple/llvm-project` close to it (ideally containing it)
LLVM_BRANCH=bda51ce411586a8c012623300d8598ce84fced53

get_rust_commit_for_toolchain() (
    # Yields "" for a toolchain like `x.y.z`, and `mm-dd-yy` for `nightly-mm-dd-yy`
    IF_NIGHTLY_DATE_STRIPPED=$(echo "${RUST_TOOLCHAIN}" | sed -n 's/^nightly-//p')
    if [ -n "${IF_NIGHTLY_DATE_STRIPPED}" ]; then # `if let Some(nightly_date)`
        curl "https://static.rust-lang.org/dist/${IF_NIGHTLY_DATE_STRIPPED}/channel-rust-nightly-git-commit-hash.txt"
    else
        echo "refs/tags/${RUST_TOOLCHAIN}"
    fi
)

# 2. Select the best branch, tag or commit hash from https://github.com/rust-lang/rust
# Thanks to `get_rust_commit_for_toolchain` helper, this should no longer need
# to be manually done.
RUST_BRANCH="$(get_rust_commit_for_toolchain)"

# 3. Select a name for the toolchain you want to install as. The toolchain will be installed
# under $HOME/.rustup/toolchains/rust-$RUST_TOOLCHAIN
RUST_TOOLCHAIN="ios-arm64-${RUST_TOOLCHAIN}"
