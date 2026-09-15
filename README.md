# openPMD Formulas for Homebrew

This [Homebrew](http://brew.sh) formula installs provides recipes to build [openPMD](https://www.openpmd.org) libraries and tools on your macOS or Linux system.

TL;DR: Just execute
```bash
brew update
brew tap openpmd/openpmd
brew install openpmd-api
```

If you are not using CMake, Homebrew's `pkg-config` finds openPMD-api without extra setup.
If a different `pkg-config` comes first in your `PATH` (check with `command -v pkg-config`), e.g., from an active conda/mamba or Spack environment, set this environment hint:
```bash
export PKG_CONFIG_PATH=$(brew --prefix openpmd-api)/lib/pkgconfig:$PKG_CONFIG_PATH
```


## NOTE

This is quite an experimental installation method.
Please open an issue in any case when trying this, we welcome any feedback on it!


## To Do

- [ ] set pkg-config environment helpers... but brew does not set `PKG_CONFIG_PATH`

user-side work-around: `export PKG_CONFIG_PATH=$(brew --prefix openpmd-api)/lib/pkgconfig:$PKG_CONFIG_PATH`


## Provided Packages

- [openpmd-api](https://github.com/openPMD/openPMD-api)


## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).


## Tests

With `brew test openpmd-api` you can check if the formula is working properly. Note the formula needs to be installed before it can be tested.
