# homebrew-aws-metadata-agent

Homebrew tap for [aws-metadata-agent](https://github.com/so1omon563/aws-metadata-agent).

This is a third-party tap containing executable Ruby formula code. Review the
formula before trusting it:

```sh
brew trust --tap so1omon563/aws-metadata-agent
brew tap so1omon563/aws-metadata-agent
brew install aws-metadata-agent
aws-metadata setup
```

Homebrew installs only the versioned, unprivileged package payload. The
explicit setup command invokes the reviewed project installer for the
link-local address and launchd services. Privileged jobs use root-owned copies
at absolute paths; they never execute from the Homebrew Cellar.

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
aws-metadata setup
aws-metadata version
aws-metadata status
```

Setup refreshes the root-owned service copy after Homebrew changes the package
payload.

## Uninstall

Remove service state before removing the package:

```sh
aws-metadata uninstall
brew uninstall aws-metadata-agent
```

If Homebrew was removed first, reinstall the formula and run
`aws-metadata uninstall`, or use `uninstall.sh` from the matching project
release.

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
