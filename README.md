# install-gh

## Summary
Simple one-liner installer of `gh` ([cli/cli](https://github.com/cli/cli/releases)) from the release assets without package management tools.

[![Tests](https://github.com/thombashi/install-gh/actions/workflows/tests.yaml/badge.svg)](https://github.com/thombashi/install-gh/actions/workflows/tests.yaml)


## Requirements
- `jq`

## Usage

### Install gh: the latest version
```
curl -sS https://raw.githubusercontent.com/thombashi/install-gh/main/setup-gh.sh | sudo sh
```

### Install gh: a specific version (tag)
```
curl -sS https://raw.githubusercontent.com/thombashi/install-gh/main/setup-gh.sh | sudo sh -s v2.14.7
```


## Supported environments
- Linux
- macOS


## Related project
- [thombashi/gh-update](https://github.com/thombashi/gh-update)
  - `gh-update` is a `gh` extension that updates the gh to the latest version.
