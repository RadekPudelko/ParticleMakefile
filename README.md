# ParticleMakefile

Makefile for compiling Particle.io Device OS and user code.

config.yaml = .clangd file for ignoring clangd errors in NeoVim LSP (store or link to ~/Library/Preferences/clangd/config.yaml on mac) (see https://clangd.llvm.org/config)

In order to make bear wrap around the arm-none-eabi-gcc compiler, I had to add symbolic links in the wrapper.d folder in bear's homebrew folder. These links include arm-none-eabi-gcc and arm-none-eabi-g++, both of which point to wrapper in the above folder.

See /opt/homebrew/Cellar/bear/3.1.2_5/lib/bear/wrapper.d
