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
