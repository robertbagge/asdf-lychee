# Implementation Agent Prompt for asdf-lychee Plugin

You are a skilled implementation engineer tasked with completing the asdf-lychee plugin based on the research provided.

## Context

Read all files in @todos/2025-09-03T15-01-10-asdf-lychee-plugin-open/ except in the "prompts" folder before starting, especially:

- `research.md` - Contains all technical specifications and implementation guidance
- `index.md` - Task overview and requirements

## Implementation Requirements

### Primary Objectives

1. Create a fully functional asdf plugin for lychee (<https://github.com/lycheeverse/lychee>)
2. Plugin must support installing specific/pinned versions of lychee
3. Follow the exact technical guidance in research.md - only divert if something doesn't work
4. Use prebuilt binaries from GitHub releases (no compilation required)

### Implementation Steps (Follow in Order)

1. **Fix lib/utils.bash**
   - Update GH_REPO to "<https://github.com/lycheeverse/lychee>"
   - Fix list_github_tags() to handle lychee's "lychee-vX.Y.Z" tag format
   - Remove generic download_release() function (will use binary downloads)
   - Commit: `fix(utils): update repository URL and version parsing for lychee`

2. **Implement bin/list-all**
   - Create the script using GitHub API to list all versions
   - Follow the implementation approach in research.md
   - Output space-separated list with newest version last
   - Commit: `feat(list-all): implement version listing from GitHub releases`

3. **Implement bin/download**
   - Add platform/architecture detection functions from research.md
   - Map platform/arch to correct binary asset name
   - Download appropriate binary from GitHub releases
   - Extract tarball to ASDF_DOWNLOAD_PATH
   - Handle GitHub API rate limiting with GITHUB_API_TOKEN
   - Commit: `feat(download): implement binary download with platform detection`

4. **Implement bin/install**
   - Move binary from ASDF_DOWNLOAD_PATH to ASDF_INSTALL_PATH/bin/
   - Set executable permissions
   - Verify installation with lychee --version
   - Commit: `feat(install): implement binary installation and verification`

5. **Implement bin/latest-stable**
   - Query GitHub API for latest release
   - Return version number only
   - Commit: `feat(latest-stable): add latest version detection`

6. **Add bin/help.overview**
   - Create help text describing lychee
   - Commit: `feat(help): add plugin overview documentation`

7. **Add GitHub Actions workflow**
   - Create .github/workflows/test.yml
   - Test on ubuntu-latest and macos-latest
   - Use asdf-vm/actions/plugin-test@v2
   - Commit: `ci: add GitHub Actions testing workflow`

8. **Test the plugin locally**
   - Run: `asdf plugin test lychee . 'lychee --version'`
   - Fix any issues found
   - Commit any fixes with appropriate message

### Technical Guidelines

- **Always use `set -euo pipefail`** in bash scripts
- **Use the curl_opts pattern** from research.md for API calls
- **Follow platform detection logic exactly** as specified in research.md
- **Test each script** individually before moving to next
- **Use context7** to search for asdf documentation if you encounter issues
- **Handle errors gracefully** with clear error messages

### Progress Tracking

Document your implementation progress in @todos/2025-09-03T15-01-10-asdf-lychee-plugin-open/implementation.md:

- Track each completed step
- Note any deviations from the research plan and why
- Document test results
- List any issues encountered and solutions

Update the index.md table to include implementation.md entry.

### Commit Guidelines

Use conventional commit format:

- `feat:` for new features
- `fix:` for bug fixes  
- `ci:` for CI/CD changes
- `docs:` for documentation
- `test:` for test additions

Commit after EVERY step - do not batch changes.

### Error Recovery

If something from research.md doesn't work:

1. Document the issue in implementation.md
2. Use context7 to search for asdf plugin documentation
3. Look at similar plugin implementations (asdf-golang, asdf-nodejs)
4. Make minimal necessary adjustments
5. Document why you diverged from the plan

### Testing Checklist

After implementation, verify:

- [ ] `asdf list-all lychee` shows versions
- [ ] `asdf install lychee latest` works
- [ ] `asdf install lychee 0.20.1` installs specific version
- [ ] `lychee --version` works after installation
- [ ] Plugin works on Linux and macOS
- [ ] GitHub Actions tests pass

## Start Implementation

Begin by reading all context files, then start with step 1. Good luck!
