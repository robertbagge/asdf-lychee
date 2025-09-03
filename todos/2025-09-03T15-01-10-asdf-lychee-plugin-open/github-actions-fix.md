# GitHub Actions Build Failure Analysis and Solution

## Issue Summary
The GitHub Actions workflow (.github/workflows/build.yml) is failing with the error:
```
FAILED: lychee was not properly installed reason: unable to clone plugin: fatal: Remote branch [SHA] not found in upstream origin
```

## Root Cause
The `asdf-vm/actions/plugin-test@v4` action has a bug when running on pull requests. It tries to checkout the plugin repository at GitHub's merge commit SHA (e.g., 842e1e8d5d6eb1200a29bdabe21e9fdd2b9a3b38), which doesn't actually exist in the repository.

This happens because:
1. GitHub creates a temporary merge commit for PRs to test the merged state
2. This merge commit SHA is not pushed to any branch in the repository
3. The plugin-test action defaults to using this non-existent SHA
4. When it tries to clone the plugin at this SHA, it fails

## Solution (Implemented)

Fixed by explicitly specifying the correct gitref in `.github/workflows/build.yml`:

```yaml
- name: asdf_plugin_test
  uses: asdf-vm/actions/plugin-test@v4
  with:
    command: lychee --version
    gitref: ${{ github.event.pull_request.head.sha || github.sha }}
```

This configuration:
- Uses the actual PR head commit SHA for pull requests (`github.event.pull_request.head.sha`)
- Falls back to the current SHA for push events (`github.sha`)
- Ensures the action always uses a commit that exists in the repository

## Verification

### Local Testing Successful
The plugin works correctly when tested locally:
```bash
$ asdf plugin test lychee . 'lychee --version'
Location of lychee plugin: /tmp/asdf.qxTn/plugins/lychee
* Downloading lychee 0.20.1 for linux-x86_64...
* Download URL: https://github.com/lycheeverse/lychee/releases/download/lychee-v0.20.1/lychee-x86_64-unknown-linux-gnu.tar.gz
* Extracting lychee-x86_64-unknown-linux-gnu.tar.gz...
* Download and extraction completed successfully
* Installing lychee binary...
* Verifying installation...
* lychee 0.20.1 installation was successful!
lychee 0.20.1
```

### Multiple Version Testing
Successfully tested with multiple versions:
- ✅ 0.20.1 (latest)
- ✅ 0.19.0
- ✅ 0.18.0

## Conclusion
The plugin implementation is correct. The GitHub Actions failure is solely due to the unpushed commit. Once all commits are pushed to the remote repository, the workflow should pass successfully.