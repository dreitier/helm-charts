## [postfix-v2.0.0](https://github.com/dreitier/helm-charts/compare/postfix-1.2.0...postfix-2.0.0) (2026-11-13)

### ⚠ BREAKING CHANGES

* **postfix:** smtp.saslSecurityLevel was renamed to
smtp.tlsSecurityLevel (default encrypt
instead of may; the chart fails with the old key). smtp.relayNetworks
defaults to the private
networks (the old default contained the public range 192.0.0.0/8).
smtp.relayUsername and
smtp.relayPassword default to empty (SASL disabled). rbac.* and
autoscaling.* were removed.
Image 1.x logs to stdout only, see the postfix-docker changelog.

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01BcFBPBfRRJPkKw8fikKb6N

Co-authored-by: Claude Opus 5.5 <noreply@anthropic.com>

### Features

* **postfix:** support postfix image 1.x ([#64](https://github.com/dreitier/helm-charts/issues/64)) ([144d2ba](https://github.com/dreitier/helm-charts/commit/144d2ba350d3500adcc12b11fbf9ca15edcc0445))

## [postfix-v1.2.0](https://github.com/dreitier/helm-charts/compare/postfix-1.1.1...postfix-1.2.0) (2026-10-20)

### Features

* **ci:** add dependabot ([9efdeb2](https://github.com/dreitier/helm-charts/commit/9efdeb271a2e85ff642204be8125a0a062640434))

### Bug Fixes

* **deps:** bump dreitier/postfix from 0.3.3 to 0.4.0 in /charts/postfix ([#12](https://github.com/dreitier/helm-charts/issues/12)) ([649dc41](https://github.com/dreitier/helm-charts/commit/649dc41888fee7c961fe5407dd0c0f03373208ff))
* **postfix:** use chart apiVersion v2 ([#19](https://github.com/dreitier/helm-charts/issues/19)) ([2aac18a](https://github.com/dreitier/helm-charts/commit/2aac18a664ab69f5483a8f9d6a4a2596375d62f2))
