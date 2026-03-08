# whoisd

A recursive WHOIS server, it gets the data from whomever owns it.

Made with https://github.com/likexian/whois. Whatever they support, we support.

Supported queries:

- domain
- IPv6
- IPv4
- ASN

## Installation

Binaries are provided for a wide range of systems in GitHub releases.

Docker images are available at
https://gitlab.com/lama-corp/infra/tools/whoisd/container_registry.

## Configuring

Available environment variables:

- `WHOISD_LISTEN`: defaults to `:43`
- `WHOISD_LOG_LEVEL`: defaults to `warn`

## License

Copyright Marc 'risson' Schmitt 2026. Licensed under the [EUPL-1.2 or later](./LICENSE) license.

## Releasing

Run the "Release" workflow with the version to be release. The CI takes care of the rest.
