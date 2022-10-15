# gh-installer

## Summary
Simple one-liner installer of `gh` ([cli/cli](https://github.com/cli/cli/releases)) from the release assets without using package management tools.

[![Tests](https://github.com/thombashi/gh-installer/actions/workflows/tests.yaml/badge.svg)](https://github.com/thombashi/gh-installer/actions/workflows/tests.yaml)

## Usage

### Install gh: the latest version
```
curl -sS https://raw.githubusercontent.com/thombashi/gh-installer/main/setup-gh.sh | sudo sh
```

### Install gh: a specific version (tag)
```
curl -sS https://raw.githubusercontent.com/thombashi/gh-installer/main/setup-gh.sh | sudo sh -s v2.14.7
```

## Supported environments
- Linux
- macOS
