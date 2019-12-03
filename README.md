This repository contains the build scripts that FullStory uses for building
the rust portions of native mobile.

The primary changes that we make are:
* Use LLVM 8 instead of LLVM 7 (XCode 11 uses LLVM 8)
* Include more architectures so we can use the same toolchain for both bitcode
  and non-bitcode purposes.

## Extra dependency steps

In order to build the android variants of the toolchain, the rust builder script needs
access to the clang compiler used by android. If you install Android Studio, then it
will install the appropriate toolchains, but with slightly different names, so I executed
the following commands from within the `toolchains/llvm/prebuilt/darwin-x86_64/bin` found
inside the NDK directory (which at the time was found at `${HOME}/Library/Android/sdk/ndk/20.0.5594570`)
```
ln -s aarch64-linux-android28-clang aarch64-linux-android-clang
ln -s armv7a-linux-androideabi28-clang arm-linux-androideabi-clang
ln -s i686-linux-android28-clang i686-linux-android-clang
ln -s x86_64-linux-android28-clang x86_64-linux-android-clang
```

Original README.md follows

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

## Pre-compiled releases

Visit the [releases page](https://github.com/getditto/rust-bitcode/releases) and
download a zip file. It will have a name of the form
`rust-ios-arm64-20xx-xx-xx.zip` where the date is the Rust nightly that it is
based on.

Unzip the file and open a terminal to the extracted directory. Run the
installation script:

```
./install.sh
```

This will:
1. Install the toolchain in `~/.rust-ios-arm64/toolchain-YYYY-MM-DD`
2. Configure `rustup` with a custom toolchain under the name `ios-arm64`.

You can also install and add the toolchain yourself if you don't like these
defaults.

## Build from source

1. Ensure required build tools are installed. If you are using homebrew: `brew
   install ninja cmake`
2. Clone this repository.
3. Review `config.sh` to make sure the the Rust and LLVM versions are suitable.
4. In a terminal, run `./build.sh`. This will clone the Rust and LLVM
   repositories under `build/` and compile them. The toolchain will end up
   at `build/rust-build/build/x86_64-apple-darwin/stage2`.
5. Run `./install.sh`. This will install the toolchain in
   `~/.rust-ios-arm64/toolchain-YYYY-MM-DD` and add it to rustup, the same as
   for pre-compiled releases.

## Using the toolchain

Build your library like this:

```
RUSTFLAGS="-Z embed-bitcode" cargo +ios-arm64 build --target aarch64-apple-ios --release --lib
```

## License

The shell scripts in this repository are made available under the permissive
Apache 2.0 licence. Refer to the file LICENSE.

Binary releases contain LLVM and Rust. See LICENSE-LLVM and LICENSE-RUST for
their respective licenses. These licenses are included in the binary releases.
