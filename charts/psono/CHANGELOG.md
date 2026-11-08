## [psono-v3.1.2](https://github.com/dreitier/helm-charts/compare/psono-3.1.1...psono-3.1.2) (2026-11-08)

### Bug Fixes

* **psono:** leave OIDC_CONFIGURATIONS to PSONO_OIDC_CONFIGURATIONS with existingSecret ([#50](https://github.com/dreitier/helm-charts/issues/50)) ([453dbe4](https://github.com/dreitier/helm-charts/commit/453dbe4ebf6b1cb3f20b9539e84cff6023e35e05))

## [psono-v3.1.1](https://github.com/dreitier/helm-charts/compare/psono-3.1.0...psono-3.1.1) (2026-11-05)

### Bug Fixes

* **deps:** bump psono/psono-combo-enterprise from 7.5.7-4.9.2-1.10.4 to 7.5.8-4.9.2-1.10.4 in /charts/psono ([#48](https://github.com/dreitier/helm-charts/issues/48)) ([1a1c868](https://github.com/dreitier/helm-charts/commit/1a1c86899244dd39adecb80272c7aa9712a26003))
* **deps:** bump psono/psono-fileserver from 7.0.31 to 7.0.32 in /charts/psono ([#47](https://github.com/dreitier/helm-charts/issues/47)) ([f72fff1](https://github.com/dreitier/helm-charts/commit/f72fff1dd301413549c8e54289900063ecd7e54a))

## [psono-v3.1.0](https://github.com/dreitier/helm-charts/compare/psono-3.0.4...psono-3.1.0) (2026-11-03)

### Features

* **psono:** existingSecret, extra env/volumes and fileserver service account ([#45](https://github.com/dreitier/helm-charts/issues/45)) ([aee7d1a](https://github.com/dreitier/helm-charts/commit/aee7d1a477a3eeed3599a33e24371b1ffb7d0855))

## [psono-v3.0.4](https://github.com/dreitier/helm-charts/compare/psono-3.0.3...psono-3.0.4) (2026-11-03)

### Bug Fixes

* **deps:** bump dreitier/gobackup from 20220717-dreitier to 20251119-dreitier in /charts/psono ([#40](https://github.com/dreitier/helm-charts/issues/40)) ([8e9ac7b](https://github.com/dreitier/helm-charts/commit/8e9ac7b91c1017ec8a49380e9fda2e35468e7757))
* **deps:** bump psono/psono-combo-enterprise from 7.5.5.4.9.2.1.10.3 to 7.5.7-4.9.2-1.10.4 in /charts/psono ([#41](https://github.com/dreitier/helm-charts/issues/41)) ([ec45b23](https://github.com/dreitier/helm-charts/commit/ec45b23e330e7c63b4d913aeb7c81e63ee0ed7bf))
* **deps:** bump psono/psono-fileserver from 7.0.29 to 7.0.31 in /charts/psono ([#42](https://github.com/dreitier/helm-charts/issues/42)) ([72ba8b6](https://github.com/dreitier/helm-charts/commit/72ba8b6641eabad9ddcdef9f472f2011a7433e2f))

## [psono-v3.0.3](https://github.com/dreitier/helm-charts/compare/psono-3.0.2...psono-3.0.3) (2026-10-30)

### Bug Fixes

* **deps:** bump psono/psono-combo-enterprise from 7.5.3.4.9.1.1.10.2 to 7.5.5.4.9.2.1.10.3 in /charts/psono ([#34](https://github.com/dreitier/helm-charts/issues/34)) ([d364bf5](https://github.com/dreitier/helm-charts/commit/d364bf560e4e3a52f82e9081a92e3ba948d55cb1))
* **deps:** bump psono/psono-fileserver from 7.0.28 to 7.0.29 in /charts/psono ([#35](https://github.com/dreitier/helm-charts/issues/35)) ([5118b50](https://github.com/dreitier/helm-charts/commit/5118b50c772d28108f32b2d12d3c242dcefd4ee9))

## [psono-v3.0.2](https://github.com/dreitier/helm-charts/compare/psono-3.0.1...psono-3.0.2) (2026-10-26)

### Bug Fixes

* **deps:** bump psono/psono-combo-enterprise from 7.5.1-4.9.0-1.10.1 to 7.5.3.4.9.1.1.10.2 in /charts/psono ([#30](https://github.com/dreitier/helm-charts/issues/30)) ([ae0fd18](https://github.com/dreitier/helm-charts/commit/ae0fd18449dbd2d1d22791875d66c634d6781459))

## [psono-v3.0.1](https://github.com/dreitier/helm-charts/compare/psono-3.0.0...psono-3.0.1) (2026-10-26)

### Bug Fixes

* **deps:** bump psono/psono-fileserver from 7.0.27 to 7.0.28 in /charts/psono ([#31](https://github.com/dreitier/helm-charts/issues/31)) ([6e34541](https://github.com/dreitier/helm-charts/commit/6e345417dfa493ca8ac5db91f30a9906be1b1faf))

## [psono-v3.0.0](https://github.com/dreitier/helm-charts/compare/psono-2.6.0...psono-3.0.0) (2026-10-20)

### ⚠ BREAKING CHANGES

* **psono:** Psono server 7.5.1 / fileserver 7.0.27 (DB migrations, PostgreSQL >= 14 required).
Bundled database is now groundhog2k/postgres (values key "postgres" instead of "postgresql").
server.db.checkImage moved to server.db.check.image; postgres exporter switched to
quay.io/prometheuscommunity/postgres-exporter.

* fix(postfix): use chart apiVersion v2

* style(psono): formatting

### Features

* **psono:** upgrade to Psono 7.5.1, replace bundled Bitnami PostgreSQL ([#18](https://github.com/dreitier/helm-charts/issues/18)) ([e775f16](https://github.com/dreitier/helm-charts/commit/e775f16e2966fc0aa8b694a1889ae6a52d93effd))

## [psono-v2.6.0](https://github.com/dreitier/helm-charts/compare/psono-2.5.1...psono-2.6.0) (2026-10-20)

### Features

* **ci:** add dependabot ([9efdeb2](https://github.com/dreitier/helm-charts/commit/9efdeb271a2e85ff642204be8125a0a062640434))
