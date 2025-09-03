<div align="center">

# asdf-lychee [![Build](https://github.com/robertbagge/asdf-lychee/actions/workflows/test.yml/badge.svg)](https://github.com/robertbagge/asdf-lychee/actions/workflows/test.yml)

[lychee](https://github.com/lycheeverse/lychee) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Supported Platforms](#supported-platforms)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar`, and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html)
- `GITHUB_API_TOKEN`: Optional - set to avoid GitHub API rate limits when downloading

# Supported Platforms

This plugin downloads pre-built binaries from lychee releases. The following platforms are supported:

| Platform | Architecture | Status |
|----------|--------------|--------|
| Linux | x86_64 | ✅ Supported |
| Linux | aarch64 (ARM64) | ✅ Supported |
| Linux | armv7 | ✅ Supported |
| macOS | Apple Silicon (ARM64) | ✅ Supported |
| macOS | Intel (x86_64) | ❌ Not available* |

*lychee does not provide x86_64 macOS binaries. Intel Mac users need to [build from source](https://github.com/lycheeverse/lychee#build-from-source) using Cargo.

# Install

Plugin:

```shell
asdf plugin add lychee
# or
asdf plugin add lychee https://github.com/robertbagge/asdf-lychee.git
```

lychee:

```shell
# Show all installable versions
asdf list-all lychee

# Install specific version
asdf install lychee latest

# Set a version globally (on your ~/.tool-versions file)
asdf global lychee latest

# Now lychee commands are available
lychee --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/robertbagge/asdf-lychee/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Robert Bagge](https://github.com/robertbagge/)