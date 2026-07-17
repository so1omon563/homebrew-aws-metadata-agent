## Summary

Describe what this formula or tap change achieves and why it is needed.

## Related release

Link the immutable aws-metadata-agent release and confirm its archive SHA-256.

## Validation

- [ ] `ruby -c Formula/aws-metadata-agent.rb` passes
- [ ] `brew audit --strict --formula so1omon563/aws-metadata-agent/aws-metadata-agent` passes
- [ ] The formula installs and `brew test so1omon563/aws-metadata-agent/aws-metadata-agent` passes
- [ ] Version and setup-help checks require no administrator access, service changes, AWS configuration, or credentials

## Security and lifecycle

- [ ] The formula does not run `sudo`, configure networking, or mutate services
- [ ] The source URL is an immutable project release with a verified SHA-256
- [ ] `aws-runas` remains an attributed upstream dependency and is not bundled or mirrored
- [ ] Install, setup, upgrade, rollback, agent uninstall, and Homebrew uninstall ordering remain accurate
- [ ] No credentials, account IDs, profile names, identities, or organization-specific information are included
