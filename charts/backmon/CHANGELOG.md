## [backmon-v3.0.0](https://github.com/dreitier/helm-charts/compare/backmon-2.5.0...backmon-3.0.0) (2026-10-21)

### ⚠ BREAKING CHANGES

* **backmon:** backmon 4.0.1 is a new major version. Check its release
notes before upgrading:
https://github.com/dreitier/backmon/releases/tag/4.0.1

Co-authored-by: dreitier-release-bot[bot] <345434585+dreitier-release-bot[bot]@users.noreply.github.com>

### Features

* **backmon:** update backmon to 4.0.1 ([#24](https://github.com/dreitier/helm-charts/issues/24)) ([56c6afb](https://github.com/dreitier/helm-charts/commit/56c6afbe8eb8ff6dbfe537dd75eb84cff6873ff5))

## [backmon-v2.5.0](https://github.com/dreitier/helm-charts/compare/backmon-2.4.1...backmon-2.5.0) (2026-10-20)

### Features

* **ci:** add dependabot ([9efdeb2](https://github.com/dreitier/helm-charts/commit/9efdeb271a2e85ff642204be8125a0a062640434))

### Bug Fixes

* **postfix:** use chart apiVersion v2 ([#19](https://github.com/dreitier/helm-charts/issues/19)) ([2aac18a](https://github.com/dreitier/helm-charts/commit/2aac18a664ab69f5483a8f9d6a4a2596375d62f2))

# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.3.1] - 2025-12-10
### Added
- updated to backmon 3.2.2

## [2.3.1] - 2025-12-02
### Added
- updated to backmon 3.2.1

## [2.3.0] - 2025-11-20
### Added
- added automountServiceAccountToken property
- updated to backmon 3.2.0


## [2.1.0] - 2025-05-05
### Added
- added extraEnv section to deployment template

## [1.6.0] - 2024-12-20
### Added
- added option to enable/disable the deployment of the ServiceMonitor

## [1.0.0] - 2022-08-24
### Added
- initial release after renaming product name from `cloudmon` to `backmon`
