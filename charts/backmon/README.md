# Helm chart: backmon - Monitoring of backup files in filesystems and object storages

- [Project website on GitHub](https://github.com/dreitier/backmon)
- [Official documentation](https://dreitier.github.io/backmon-docs)

## Getting started

```console
$ helm repo add dreitier https://dreitier.github.io/helm-charts/
$ helm repo update
$ helm install dreitier/backmon
```

### Configuration parameters

The following tables lists the configurable parameters of the backmon chart and their default values.

| Parameter                  | Description                                                                                                                                                               | Default                                                  |
|----------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------|
| `image.pullSecrets`        | Specify Image pull secrets                                                                                                                                                | `nil` (does not add image pull secrets to deployed pods) |
| `nameOverride`             | String to partially override app.fullname template with a string (will prepend the release name)                                                                          | `nil`                                                    |
| `fullnameOverride`         | String to fully override app.fullname template with a string                                                                                                              | `nil`                                                    |
| `service.type`             | Kubernetes Service type                                                                                                                                                   | `ClusterIP`                                              |
| `service.port`             | HTTP port                                                                                                                                                                 | `80`                                                     |
| `ingress.enabled`          | Whether to create an Ingress                                                                                                                                              | `false`                                                  |
| `ingress.annotations`      | Annotations for the Ingress                                                                                                                                               | `{}`                                                     |
| `ingress.host`             | Hostname the Ingress should map to                                                                                                                                        | `chart-example.local`                                    |
| `ingress.tls.enabled`      | Enable TLS on the Ingress. The name of the TLS secret is `{{ $fullName }}-tls`                                                                                            | `false`                                                  |
| `probes.enabled`           | Enable the readiness and liveness probes                                                                                                                                  | `false`                                                  |
| `backmon.log_level`        | Log level of the application. See https://github.com/sirupsen/logrus#level-logging for more information                                                                   | `info`                                                   |
| `backmon.update_interval`  | How often backmon should scan the configured buckets (interval in minutes)                                                                                                | `60`                                                     |
| `backmon.disks.include`    | Explicitly include those disks during discovery ([official docs](https://dreitier.github.io/backmon-docs/reference/backmon-configuration/overview))                       | `[]`                                                     |
| `backmon.disks.exclude`    | Explicitly exclude those disks during discovery ([official docs](https://dreitier.github.io/backmon-docs/reference/backmon-configuration/overview))                       | `[]`                                                     |
| `backmon.disks.all_others` | For each other disk found during discovery, do that ([official docs](https://dreitier.github.io/backmon-docs/reference/backmon-configuration/overview))                   | `include`                                                |
| `backmon.environments`     | Map of environments backmon should scan. See `values.yaml` for an example                                                                                                 | `{}`                                                     |
| `backmon.secrets`          | List of secrets to be used in backmon environment configuration. See `values.yaml` for an example                                                                         | `[]`                                                     |
| `externalSecret.enabled`   | If enabled, environment variables from an external secret are injected into the container . See `values.yaml` for an example                                              | `false`                                                  |
| `externalSecret.name`      | Name of the external secret to use. For this to work, `externalSecret.enabled` must be set to `true`                                                                      | `custom-secret`                                          |
| `extraEnv`                 | List of environment variables to be injected into to backmon container. See `values.yaml` for an example                                                                  | `[]`                                                     |
| `extraVolumes`             | List of volumes to be injected into to backmon container. See `values.yaml` for an example                                                                                | `[]`                                                     |
| `extraVolumeMounts`        | List of volume mounts variables to be injected into to backmon container. See `values.yaml` for an example                                                                | `[]`                                                     |
| `createConfigFile`         | Whether to create the config file. Set to ```false``` to supply your own, for example via a secret.                                                                       | `true`                                                   |
| `serviceMonitor.enabled`   | Whether to deploy a ServiceMonitor object to make Prometheus scrape the application metrics. Requires the corresponding CRD to be installed                               | `true`                                                   |
| `prometheusRules.enabled`  | Whether to deploy PrometheusRule objects to monitor the state of backups. Requires the corresponding CRD to be installed | `false`                                                  |
| `prometheusRules.backupOverdue.enabled` | Alert `BackupOverdue`: the latest backup is older than expected | `true` |
| `prometheusRules.backupOverdue.gracePeriod` | Hours a backup may be overdue before `BackupOverdue` fires | `24` |
| `prometheusRules.backupCountExceeding.enabled` | Alert `BackupCountExceeding`: more backups than `retention-count` (plus threshold) are present | `true` |
| `prometheusRules.backupCountExceeding.thresholdPercentage` | Share of `retention-count` the number of backups may exceed it | `0.25` |
| `prometheusRules.backupPurgeStalled.enabled` | Alert `BackupPurgeStalled`: the oldest backup is older than `maxAgeHours`, i.e. backups are not purged anymore. Only useful for files with `purge: true`. Alternative to `BackupCountExceeding` if additional backups are expected, e.g. before deployments | `false` |
| `prometheusRules.backupPurgeStalled.maxAgeHours` | Maximum age of the oldest backup in hours; set it to `retention-age` plus a grace period | `384` |
| `prometheusRules.backupPurgeStalled.for` | How long the condition has to hold before `BackupPurgeStalled` fires | `6h` |
| `prometheusRules.backupCountShort.enabled` | Alert `BackupCountShort`: fewer backups than `retention-count` times threshold are present | `true` |
| `prometheusRules.backupCountShort.thresholdPercentage` | Share of `retention-count` that has to be present | `0.75` |
| `prometheusRules.backupMissing.enabled` | Alert `BackupMissing`: a monitored backup disappeared | `true` |
| `prometheusRules.backupSizeChanged.enabled` | Alert `BackupSizeChanged`: the size of the latest backup changed by more than the threshold within an hour | `true` |
| `prometheusRules.backupSizeChanged.thresholdPercentage` | Allowed relative change of the backup size | `0.25` |
| `prometheusRules.backupDefinitionError.enabled` | Alert `BackmonStatusError`: backmon reports an error for a disk | `true` |

### Prerequisites

- Kubernetes 1.10+

## Development

### Test local chart output

```bash
$ helm template . --debug
```
