# homebrew-aws-metadata-agent

Homebrew tap for [aws-metadata-agent](https://github.com/so1omon563/aws-metadata-agent).

This is a third-party tap containing executable Ruby formula code. Review the
formula before trusting it:

```sh
brew trust --tap so1omon563/aws-metadata-agent
brew tap so1omon563/aws-metadata-agent
brew install aws-metadata-agent
aws-metadata setup --mode user
```

Homebrew installs only the versioned, unprivileged package payload. The
explicit user-mode setup runs entirely in the signed-in account. Use
`aws-metadata setup --mode system` instead when the transparent link-local
endpoint is required; only system mode requests administrator access.
Privileged jobs use root-owned copies at absolute paths and never execute from
the Homebrew Cellar.

The formula does not bundle, mirror, or claim ownership of `aws-runas`. If it
is not already installed, setup downloads the pinned upstream release directly
from [mmmorris1975/aws-runas](https://github.com/mmmorris1975/aws-runas) and
verifies the official checksum.

## Support

The supported Homebrew host boundary is Apple Silicon macOS 26. Other macOS
versions and architectures are currently unverified. Linux users should use
the tagged source installer from the main project.

## Upgrade

```sh
brew update
brew upgrade aws-metadata-agent
aws-metadata setup --mode user
# or: aws-metadata setup --mode system
aws-metadata version
aws-metadata status
```

Setup refreshes the selected service mode after Homebrew changes the package
payload.

## Uninstall

Remove service state before removing the package:

```sh
aws-metadata uninstall --mode user
# or: aws-metadata uninstall --mode system
brew uninstall aws-metadata-agent
```

If Homebrew was removed first, reinstall the formula and run
the matching explicit uninstall command, or use `uninstall.sh` from the
matching project release.

## Rollback

The tap carries the current supported release rather than historical formulae.
Uninstall the service and formula in the order above, review the target
release's migration notes, then use its tagged source installer.

## Verification

```sh
ruby -c Formula/aws-metadata-agent.rb
brew audit --strict --formula so1omon563/aws-metadata-agent/aws-metadata-agent
brew test so1omon563/aws-metadata-agent/aws-metadata-agent
```

Report security concerns privately as described in [SECURITY.md](SECURITY.md).
