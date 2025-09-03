<div align="center">

# asdf-lychee [![Build](https://github.com/robertbagge/asdf-lychee/actions/workflows/build.yml/badge.svg)](https://github.com/robertbagge/asdf-lychee/actions/workflows/build.yml) [![Lint](https://github.com/robertbagge/asdf-lychee/actions/workflows/lint.yml/badge.svg)](https://github.com/robertbagge/asdf-lychee/actions/workflows/lint.yml)

[lychee](https://github.com/robertbagge/asdf-lychee) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

**TODO: adapt this section**

- `bash`, `curl`, `tar`, and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html).
- `SOME_ENV_VAR`: set this environment variable in your shell config to load the correct version of tool x.

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
