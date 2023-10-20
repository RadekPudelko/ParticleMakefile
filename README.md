# ParticleMakefile

### Makefile

Makefile for compiling Particle.io Device OS and user code.

Wraps arounds particle's makefile for easy local project cli use

I like to define some variables in a seperate .env that I can globally pull from for most projects, for instance, if I want to set the default device os version-sort

These can then set locally for project specfic configuration

To generate a full compile_commands.json needed for neovim's lsp, you must do a clean build

The device os only needs to be compile once for the specific platform in use, unless changes are being made to it. The compile commands json file needs to be linked once after a clean os build

Clean user builds are really only needed if you are adding new libraries, this is so that the compile commands json can reflect their location

### .env

Defines global vars related for the Makefile

### config.yaml

config.yaml = .clangd file for ignoring clangd errors in NeoVim LSP (store or link to ~/Library/Preferences/clangd/config.yaml on mac) (see https://clangd.llvm.org/config)

### Additional Notes

In order to make bear wrap around the arm-none-eabi-gcc compiler, I had to add symbolic links in the wrapper.d folder in bear's homebrew folder. These links include arm-none-eabi-gcc and arm-none-eabi-g++, both of which point to wrapper in the above folder.

See /opt/homebrew/Cellar/bear/3.1.2_5/lib/bear/wrapper.d

