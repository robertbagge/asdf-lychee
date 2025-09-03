#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/lycheeverse/lychee"
TOOL_NAME="lychee"
TOOL_TEST="lychee --version"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if lychee is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
	# lychee uses tags like "lychee-vX.Y.Z"
	git ls-remote --tags --refs "$GH_REPO" |
		grep -o 'refs/tags/lychee-v[0-9].*' | cut -d/ -f3- |
		sed 's/^lychee-v//' # Remove "lychee-v" prefix to get clean version numbers
}

list_all_versions() {
	# Use GitHub API to list all releases for lychee
	curl "${curl_opts[@]}" "https://api.github.com/repos/lycheeverse/lychee/releases" |
		grep -o '"tag_name": "lychee-v[^"]*' |
		sed 's/"tag_name": "lychee-v//'
}

# Platform and architecture detection functions
get_platform() {
	local platform
	case "$(uname -s)" in
		Darwin) platform="macos" ;;
		Linux) platform="linux" ;;
		*) fail "Unsupported platform: $(uname -s)" ;;
	esac
	echo "$platform"
}

get_arch() {
	local arch
	case "$(uname -m)" in
		x86_64) arch="x86_64" ;;
		aarch64|arm64) arch="aarch64" ;;
		armv7l) arch="arm" ;;
		*) fail "Unsupported architecture: $(uname -m)" ;;
	esac
	echo "$arch"
}

get_asset_name() {
	local platform="$1"
	local arch="$2"
	
	case "${platform}-${arch}" in
		macos-aarch64|macos-arm64)
			echo "lychee-arm64-macos.tar.gz"
			;;
		macos-x86_64)
			# x86_64 macOS users can use the ARM64 binary via Rosetta 2
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
			fail "No prebuilt binary available for ${platform}-${arch}"
			;;
	esac
}

