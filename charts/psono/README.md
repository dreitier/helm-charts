# Prepate Database
```sql
create extension pgcrypto;
create extension ltree;
```

# Create secrets
```
docker run --rm -it psono/psono-server-enterprise  python3 /root/psono/manage.py generateserverkeys
```

# Create initial user
```
python3 ./psono/manage.py createuser admin@my-logon-domain.com 'p4$$w0rd' admin@my-domain.com
```

# Grant superuser permissions
```
python3 ./psono/manage.py promoteuser admin@my-logon-domain.com superuser
```

# Secrets from an existing Secret (`server.existingSecret`, `fileserver.existingSecret`)

Instead of putting keys and passwords into values, point the chart at a Secret (e.g. rendered by
external-secrets). It is passed as environment (`envFrom`) – Psono reads every setting from
`PSONO_<SETTING>` (server) / `PSONOFS_<SETTING>` (fileserver), lists and dicts as JSON. The chart then
leaves these settings out of `settings.yaml`, so the Secret has to provide them:

| Component | Keys |
|---|---|
| server | `PSONO_SECRET_KEY`, `PSONO_ACTIVATION_LINK_SECRET`, `PSONO_DB_SECRET`, `PSONO_EMAIL_SECRET_SALT`, `PSONO_PRIVATE_KEY`, `PSONO_PUBLIC_KEY`, `PSONO_DATABASES_DEFAULT_USER`, `PSONO_DATABASES_DEFAULT_PASSWORD`; with `server.ldap.enabled` also `PSONO_LDAP` (whole LDAP list as JSON); with `server.oidc.enabled` also `PSONO_OIDC_CONFIGURATIONS` (JSON `{"1": {"OIDC_RP_CLIENT_ID": …, "OIDC_RP_CLIENT_SECRET": …, "OIDC_OP_…_ENDPOINT": …}}`) |
| fileserver | `PSONOFS_SECRET_KEY`, `PSONOFS_PRIVATE_KEY`, `PSONOFS_PUBLIC_KEY`, `PSONOFS_CLUSTER_ID`, `PSONOFS_CLUSTER_PRIVATE_KEY`; shards with credentials: `PSONOFS_SHARDS` (JSON) |

The database credentials for the postgres-exporter sidecar and the backup cron job are read from the same
Secret.

# Restart on secret changes (`reloader.enabled`)

`server.existingSecret`/`fileserver.existingSecret` (and `extraEnvFrom`) can change without Helm noticing, e.g.
when external-secrets renders a rotated value – Psono only reads them at startup. With `reloader.enabled=true` both
Deployments carry `reloader.stakater.com/auto: "true"`, and [Stakater Reloader](https://github.com/stakater/Reloader)
restarts them on such a change. Reloader has to be installed in the cluster; without it the annotation has no effect.

# IRSA / extra environment

`server.extraEnv`, `extraEnvFrom`, `extraVolumes`, `extraVolumeMounts` (and the same under `fileserver`)
are added to the containers. The fileserver has its own ServiceAccount (`serviceAccounts.fileserver`).
Example for an `amazon_s3` shard without static keys (boto3 uses the web identity token):

```yaml
serviceAccounts:
  fileserver:
    annotations:
      eks.amazonaws.com/role-arn: arn:aws:iam::123456789012:role/psono-files
fileserver:
  shards:
    - shard_id: <uuid>
      read: true
      write: true
      delete: true
      allow_link_shares: true
      engine: {class: amazon_s3, kwargs: {bucket_name: my-bucket, region_name: eu-central-1}}
  extraEnv:
    - {name: AWS_ROLE_ARN, value: arn:aws:iam::123456789012:role/psono-files}
    - {name: AWS_WEB_IDENTITY_TOKEN_FILE, value: /var/run/secrets/eks.amazonaws.com/serviceaccount/token}
    - {name: AWS_REGION, value: eu-central-1}
  extraVolumes:
    - name: aws-token
      projected:
        sources:
          - serviceAccountToken: {audience: sts.amazonaws.com, expirationSeconds: 86400, path: token}
  extraVolumeMounts:
    - {name: aws-token, mountPath: /var/run/secrets/eks.amazonaws.com/serviceaccount, readOnly: true}
```

# Health check rate limit

Psono throttles `/healthcheck/` per client IP (default 61/hour). A monitoring probe every 30 s, the server's
startup probe (every 10 s) or several callers behind one reverse proxy (all with the proxy's IP) run into
`429 Too Many Requests`. `server.throttleRateHealthCheck` and `fileserver.throttleRateHealthCheck` (default
`300/hour`, format `<n>/<second|minute|hour|day>`) set `PSONO_THROTTLE_RATE_HEALTH_CHECK` /
`PSONOFS_THROTTLE_RATE_HEALTH_CHECK`; `""` keeps Psono's default.

On top of that, Psono limits all anonymous requests per client IP (`THROTTLE_RATE_ANON`, default `1440/day`), health
checks included: a probe every 30 s (2880/day) passes for 12 hours, then the fileserver answers `429`.
`fileserver.throttleRateAnon` (default `10000/day`) and `server.throttleRateAnon` (default `""`, Psono's default) set
`PSONOFS_THROTTLE_RATE_ANON` / `PSONO_THROTTLE_RATE_ANON`.
