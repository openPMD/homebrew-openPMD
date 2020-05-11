# openPMD Formulas for Homebrew

This [Homebrew](http://brew.sh) formula installs provides recipes to build [openPMD](https://www.openpmd.org) libraries and tools on your MacOS or Linux system.

TL;DR: Just execute
```
brew update
brew tap openpmd/openpmd
brew install openpmd-api
```


## NOTE

This is quite an experimental installation method.
Please open an issue in any case when trying this, we welcome any feedback on it!


## To Do

- [ ] set pkg-config environment helpers... but brew does not set `PKG_CONFIG_PATH`


## Provided Packages

- [openpmd-api](https://github.com/openPMD/openPMD-api)


## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).


## Tests

With `brew test openpmd-api` you can check if the formula is working properly. Note the formula needs to be installed before it can be tested.
