# openPMD Formulae for Homebrew

[![brew test-bot](https://github.com/openPMD/homebrew-openPMD/actions/workflows/tests.yml/badge.svg?branch=master)](https://github.com/openPMD/homebrew-openPMD/actions/workflows/tests.yml)

This [Homebrew](https://brew.sh) tap provides formulae to build [openPMD](https://www.openpmd.org) libraries and tools on macOS and Linux.


## Provided Packages

- [openpmd-api](https://github.com/openPMD/openPMD-api): C++ & Python API for scientific I/O with openPMD


## Install

```bash
brew update
brew install openpmd/openpmd/openpmd-api
```

Installing by the fully qualified name taps this repository and [trusts](https://docs.brew.sh/Tap-Trust) only the `openpmd-api` formula, as required since Homebrew 6.0.0.
To use the short name instead, trust the formula before tapping:
```bash
brew trust --formula openpmd/openpmd/openpmd-api
brew tap openpmd/openpmd
brew install openpmd-api
```

### Python

The `openpmd_api` Python module is built for Homebrew's `python@3.14` and needs no `PYTHONPATH`:
```bash
python3.14 -c "import openpmd_api"
```

Virtual environments only see it if created with `python3.14 -m venv --system-site-packages`.

### pkg-config

If you are not using CMake, Homebrew's `pkg-config` finds openPMD-api without extra setup.
If a different `pkg-config` comes first in your `PATH` (check with `command -v pkg-config`), e.g., from an active conda/mamba or Spack environment, set this environment hint:
```bash
export PKG_CONFIG_PATH=$(brew --prefix openpmd-api)/lib/pkgconfig:$PKG_CONFIG_PATH
```


## Tests

After installing, check that the formula works with:
```bash
brew test openpmd-api
```

CI runs `brew test-bot` on macOS and Linux for every pull request.


## Feedback

This installation method is experimental.
Please [open an issue](https://github.com/openPMD/homebrew-openPMD/issues) if you run into problems, we welcome any feedback!


## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).
