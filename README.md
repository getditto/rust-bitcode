# Deprecation notice (Sep 2022)

[Apple has deprecated the use of bitcode](https://developer.apple.com/documentation/xcode-release-notes/xcode-14-release-notes).

> Starting with Xcode 14, bitcode is no longer required for watchOS and tvOS applications, and the App Store no longer accepts bitcode submissions from Xcode 14.

We have confirmed that libraries produced by the standard Rust iOS toolchain can be
included in apps using Xcode 14, which pass App Store validation.

This custom toolchain is **no longer needed** and will not be maintained going forward. 🎉

The old readme is preserved below for future reference.

# Rust toolchain for Xcode-compatible iOS bitcode

In standard releases of Rust, the bitcode in ARM64 iOS targets is often
incompatible with Xcode because they use different versions of LLVM. This is a
[known issue](https://github.com/rust-lang/rust/issues/35968) with no clear
long-term solution yet.

This repository contains scripts for building and installing a custom Rust
nightly toolchain where the Rust compiler's version of LLVM matches Xcode.
Software built using this toolchain can be included in bitcode-enabled apps that
will install on real iOS devices.

Binary releases of the toolchain will be created periodically and attached to
this repository, at least until there is a better upstream solution.

This repository is maintained by [Ditto](https://www.ditto.live). We use it
ourselves and want to share it for the benefit of the Rust iOS community! Please
create an issue if you notice any problems.

These scripts work for 64-bit iOS only. watchOS and tvOS are
[not fully supported by Rust yet](https://github.com/rust-lang/rust/issues/48862).

## Pre-compiled releases

Visit the [releases page](https://github.com/getditto/rust-bitcode/releases) and
download a zip file. It will have a name of the form
`rust-ios-arm64-xxx.zip`.

Unzip the file and open a terminal to the extracted directory. Remove the
quarantine flag so the binaries will be trusted, then run the installation
script:

```bash
xattr -r -d com.apple.quarantine .
./install.sh
```

This will install the toolchain in `~/.rustup/toolchains/ios-arm64-xxx`.

## Build from source

1. Ensure required build tools are installed. If you are using homebrew: `brew
   install ninja cmake openssl`
2. Clone this repository.
3. Review `config.sh` to make sure the the Rust and LLVM versions are suitable.
4. In a terminal, run `./build.sh`. This will clone the Rust and LLVM
   repositories under `build/` and compile them. The toolchain will end up
   at `build/rust-build/build/x86_64-apple-darwin/stage2`.
5. Run `./install.sh`. This will install the toolchain in
   `~/.rustup/toolchains/ios-arm64-1.60.0`, making it available in rustup.

## Using the toolchain

Build your library like this:

```bash
cargo +ios-arm64-1.60.0 build --target aarch64-apple-ios --release --lib
```

## License

The shell scripts in this repository are made available under the permissive
Apache 2.0 licence. Refer to the [LICENSE](LICENSE) file.

Binary releases contain LLVM and Rust. See [LICENSE-LLVM](LICENSE-LLVM) and [LICENSE-RUST](LICENSE-RUST) for
their respective licenses. These licenses are included in the binary releases.
