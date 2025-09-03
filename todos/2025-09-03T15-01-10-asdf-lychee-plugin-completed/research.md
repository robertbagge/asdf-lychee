# asdf-lychee Plugin Implementation Research

## Lychee Project Overview

**lychee** is a fast, async, stream-based link checker written in Rust.

- GitHub: <https://github.com/lycheeverse/lychee>
- Latest version: v0.20.1 (as of research date)
- Installation methods: Binary releases, Cargo, Docker, various package managers

## Binary Release Pattern Analysis

### Version Naming

- Release tags follow pattern: `lychee-vX.Y.Z` (e.g., `lychee-v0.20.1`)
- Version numbers follow semantic versioning

### Available Binary Assets (v0.20.1)

```
lychee-aarch64-unknown-linux-gnu.tar.gz
lychee-aarch64-unknown-linux-musl.tar.gz
lychee-arm-unknown-linux-gnueabihf.tar.gz
lychee-arm-unknown-linux-musleabi.tar.gz
lychee-arm-unknown-linux-musleabihf.tar.gz
lychee-arm64-macos.dmg
lychee-arm64-macos.tar.gz
lychee-x86_64-unknown-linux-gnu.tar.gz
lychee-x86_64-unknown-linux-musl.tar.gz
lychee-x86_64-windows.exe
```

### Platform/Architecture Mapping for asdf

- **macOS ARM64 (Apple Silicon)**: `lychee-arm64-macos.tar.gz`
- **macOS x86_64**: Not directly available, may need to use Rosetta or build from source
- **Linux x86_64**: `lychee-x86_64-unknown-linux-gnu.tar.gz` or musl variant
- **Linux ARM64**: `lychee-aarch64-unknown-linux-gnu.tar.gz` or musl variant
- **Linux ARM**: Various ARM variants available

## Required asdf Plugin Scripts

### 1. `bin/list-all` (Required)

Lists all installable versions. Must output space-separated list with newest last.

**Implementation approach:**

```bash
# Use GitHub API to list releases
curl -s "https://api.github.com/repos/lycheeverse/lychee/releases" | \
  grep -o '"tag_name": "lychee-v[^"]*' | \
  sed 's/"tag_name": "lychee-v//' | \
  sort -V | \
  tr '\n' ' '
```

### 2. `bin/download` (Required)

Downloads binary for specified version to `$ASDF_DOWNLOAD_PATH`.

**Key environment variables:**

- `ASDF_INSTALL_VERSION`: Version to install
- `ASDF_DOWNLOAD_PATH`: Where to download files

**Implementation approach:**

1. Detect platform/architecture using `uname -s` and `uname -m`
2. Map to appropriate binary asset name
3. Download from: `https://github.com/lycheeverse/lychee/releases/download/lychee-v${version}/${asset_name}`
4. Extract tarball to `$ASDF_DOWNLOAD_PATH`

### 3. `bin/install` (Required)

Installs from downloaded files to `$ASDF_INSTALL_PATH`.

**Key environment variables:**

- `ASDF_INSTALL_PATH`: Installation target directory
- `ASDF_DOWNLOAD_PATH`: Source of downloaded files
- `ASDF_CONCURRENCY`: Number of cores for parallel operations

**Implementation approach:**

1. Create `$ASDF_INSTALL_PATH/bin`
2. Copy/move lychee binary from `$ASDF_DOWNLOAD_PATH` to `$ASDF_INSTALL_PATH/bin/`
3. Ensure executable permissions (`chmod +x`)
4. Verify with `lychee --version`

### 4. `bin/latest-stable` (Optional but recommended)

Returns latest stable version, excluding pre-releases.

**Implementation approach:**

```bash
curl -s "https://api.github.com/repos/lycheeverse/lychee/releases/latest" | \
  grep '"tag_name":' | \
  sed -E 's/.*"lychee-v([^"]+)".*/\1/'
```

### 5. `bin/help.overview` (Optional)

Provides plugin description.

**Example content:**

```
lychee is a fast, async, stream-based link checker written in Rust.
It finds broken URLs and mail addresses inside Markdown, HTML, reStructuredText,
websites, and more.
```

## Platform Detection Logic

```bash
get_platform() {
  local platform
  case "$(uname -s)" in
    Darwin) platform="macos" ;;
    Linux) platform="linux" ;;
    *) fail "Unsupported platform" ;;
  esac
  echo "$platform"
}

get_arch() {
  local arch
  case "$(uname -m)" in
    x86_64) arch="x86_64" ;;
    aarch64|arm64) arch="aarch64" ;;
    armv7l) arch="arm" ;;
    *) fail "Unsupported architecture" ;;
  esac
  echo "$arch"
}

get_asset_name() {
  local version="$1"
  local platform="$2"
  local arch="$3"
  
  case "${platform}-${arch}" in
    macos-aarch64|macos-arm64)
      echo "lychee-arm64-macos.tar.gz"
      ;;
    linux-x86_64)
      echo "lychee-x86_64-unknown-linux-gnu.tar.gz"
      ;;
    linux-aarch64)
      echo "lychee-aarch64-unknown-linux-gnu.tar.gz"
      ;;
    linux-arm)
      echo "lychee-arm-unknown-linux-gnueabihf.tar.gz"
      ;;
    *)
      fail "No prebuilt binary for ${platform}-${arch}"
      ;;
  esac
}
```

## Error Handling Best Practices

1. **Always use `set -euo pipefail`** at script start
2. **Provide clear error messages** using a `fail()` function
3. **Check HTTP response codes** before downloading
4. **Verify downloads** with checksums if available
5. **Test executable** after installation

## GitHub API Rate Limiting

Handle rate limiting with authentication token:

```bash
curl_opts=(-fsSL)
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
  curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi
```

## Testing the Plugin

Use asdf's built-in test command:

```bash
asdf plugin test lychee . 'lychee --version'
```

## CI/CD Considerations

### GitHub Actions Workflow

```yaml
name: Test
on: [push, pull_request]
jobs:
  plugin_test:
    strategy:
      matrix:
        os: [ubuntu-latest, macos-latest]
    runs-on: ${{ matrix.os }}
    steps:
      - uses: actions/checkout@v3
      - uses: asdf-vm/actions/plugin-test@v2
        with:
          command: lychee --version
```

## Current Implementation Status

The current template in `/Users/robertbagge/code/asdf/asdf-lychee/lib/utils.bash`:

- Has placeholder GitHub repo URL (needs update to lycheeverse/lychee)
- Has generic download logic (needs platform-specific binary download)
- Missing proper version listing from GitHub releases
- Missing binary extraction and installation logic

## Key Implementation Tasks

1. **Update `lib/utils.bash`**:
   - Fix `GH_REPO` to point to lycheeverse/lychee
   - Update `list_github_tags()` to handle lychee's tag format
   - Implement proper `download_release()` for binary downloads

2. **Implement `bin/list-all`**:
   - Query GitHub releases API
   - Parse and format version numbers

3. **Implement `bin/download`**:
   - Detect platform/architecture
   - Download appropriate binary asset
   - Extract tarball

4. **Implement `bin/install`**:
   - Move binary to correct location
   - Set executable permissions
   - Verify installation

5. **Add `bin/latest-stable`**:
   - Query latest release from GitHub API

6. **Add GitHub Actions workflow** for testing

## Dependencies and Requirements

- **curl**: For downloading releases
- **tar**: For extracting archives  
- **Standard POSIX tools**: grep, sed, sort, etc.
- No build dependencies needed (using prebuilt binaries)

## Reference Implementations

Good examples to follow:

- **asdf-golang**: Clean implementation with checksums
- **asdf-nodejs**: Comprehensive platform detection
- **asdf-rust**: Similar Rust binary distribution pattern

This prompt together with your research output is to be added in @todos/2025-09-03T15-01-10-asdf-lychee-plugin-open/research.md
Also update the file table in @todos/2025-09-03T15-01-10-asdf-lychee-plugin-open/index.md
