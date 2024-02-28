# Installation

#### Prerequisites
MEMOIR relies on LLVM 9.0.0
If you do not already have it installed and on your `PATH` do the following:
```
curl -sL https://releases.llvm.org/9.0.0/clang+llvm-9.0.0-x86_64-pc-linux-gnu.tar.xz | tar xJ
mv clang+llvm-9.0.0-x86_64-pc-linux-gnu llvm-9.0.0
export PATH=$(realpath ./llvm-9.0.0):$PATH
```

If you want LLVM 9.0.0 to always be on your `PATH`, add it to your `~/.bashrc`.

#### MEMOIR
```
git clone git@github.com:arcana-lab/memoir.git
cd memoir
make
```

Following installation, MEMOIR will be installed under `memoir/install`.
Run `source enable` in the `memoir/` directory to add the MEMOIR toolchain to your `PATH`.
