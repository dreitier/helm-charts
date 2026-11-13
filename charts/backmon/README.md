# Helm chart: backmon - Monitoring of backup files in filesystems and object storages

- [Project website on GitHub](https://github.com/dreitier/backmon)
- [Official documentation](https://dreitier.github.io/backmon-docs)

## Prerequisites

| Requirement | Version | Notes |
|---|---|---|
| Kubernetes | 1.19+ | Enforced by `kubeVersion` of the chart. The chart uses `apps/v1` and, if `ingress.enabled` is set, `networking.k8s.io/v1` |
| Helm | 3.0+ | 3.8+ to install the chart from the OCI registry |
| backmon image | the chart's `appVersion` | Pulled from Docker Hub (`dreitier/backmon`) by default; the same images are published to GHCR (`ghcr.io/dreitier/backmon`). Other versions can be set with `image.tag`. The `BackmonStatusError` rule adapts to images older than 5.0.0, everything else is only tested with the `appVersion` |
| Prometheus Operator CRDs | `monitoring.coreos.com/v1` | Only for `serviceMonitor.enabled` (**enabled by default**) and `prometheusRules.enabled` |
| Node architecture | `amd64` or `arm64` | Architectures of the published images |

- **Prometheus Operator:** the chart creates a `ServiceMonitor` by default. In a cluster without the Prometheus
  Operator CRDs (e.g. installed by [kube-prometheus-stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack)),
  the installation fails unless you set `serviceMonitor.enabled=false`. backmon's metrics can then be scraped from
  `/metrics` of the service by other means.
- **Access to the backups:** the pod needs network access to the object storage it monitors (S3 endpoint or
  `storage.googleapis.com`), or the backup directories have to be mounted with `extraVolumes` and `extraVolumeMounts`.
  backmon runs as non-root user 65532; set e.g. `podSecurityContext.fsGroup` if that user can't read a mounted volume
  (or can't delete files in it, if backups are purged).
- **Credentials:** an identity that is allowed to list and read the backups, and to delete them if backups are purged:
  S3 access keys or a Google service account key in an existing secret (`extraEnvFrom`, `extraVolumes`), or a cloud
  identity bound to the service account (`serviceAccount.annotations`, e.g. IRSA or GKE Workload Identity).
  Google Cloud Storage requires a backmon image with GCS support.
- **Backup definitions:** each monitored disk (bucket or directory) contains a `backup_definitions.yaml`, see the
  [official documentation](https://dreitier.github.io/backmon-docs).
- **Ingress controller:** only if `ingress.enabled` is set. backmon's API is not protected unless `http.basic_auth` is
  configured in `backmon.config.content`; `/metrics` is never protected.

## Getting started

```console
$ helm repo add dreitier https://dreitier.github.io/helm-charts/
$ helm repo update
$ helm install backmon dreitier/backmon
```

The chart is also published as OCI artifact to the GitHub Container Registry. No `helm repo add` is needed
(Helm 3.8+):

```console
$ helm show values oci://ghcr.io/dreitier/charts/backmon
$ helm install backmon oci://ghcr.io/dreitier/charts/backmon --version <version>
```

To pull the backmon image from the GitHub Container Registry instead of Docker Hub, e.g. because of Docker Hub's
rate limits:

```console
$ helm install backmon dreitier/backmon --set image.repository=ghcr.io/dreitier/backmon
```

### Configuration parameters

The following tables lists the configurable parameters of the backmon chart and their default values.

backmon's configuration file is passed as a whole in `backmon.config.content`. Credentials should not be part of it: use
`__${VAR}__` placeholders, which backmon replaces with environment variables, and provide those from an existing secret
with `extraEnvFrom`:

```yaml
backmon:
  config:
    content: |-
      port: 8000
      update_interval: 15m
      environments:
        aws-prod:
          s3:
            access_key_id: __${BACKMON_AWS_PROD_ACCESS_KEY_ID}__
            secret_access_key: __${BACKMON_AWS_PROD_SECRET_ACCESS_KEY}__
        gcs-prod:
          gcs:
            project_id: my-gcp-project
            credentials_file: /etc/backmon/gcs/key.json

# secret with the keys BACKMON_AWS_PROD_ACCESS_KEY_ID and BACKMON_AWS_PROD_SECRET_ACCESS_KEY
extraEnvFrom:
  - name: backmon-aws

# secret with the service account key for Google Cloud Storage as key.json (requires backmon with GCS support)
extraVolumes:
  - name: gcs-key
    secret:
      secretName: backmon-gcs
extraVolumeMounts:
  - name: gcs-key
    mountPath: /etc/backmon/gcs
    readOnly: true
```

| Parameter | Description | Default |
|---|---|---|
| `replicaCount` | Number of replicas | `1` |
| `image.repository` | Image repository. The images are published to Docker Hub (`dreitier/backmon`) and to the GitHub Container Registry (`ghcr.io/dreitier/backmon`) | `dreitier/backmon` |
| `image.tag` | Image tag; defaults to the chart's `appVersion` if empty | see `values.yaml` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `imagePullSecrets` | List of image pull secrets | `[]` |
| `nameOverride` | String to partially override the fullname template (will prepend the release name) | `""` |
| `fullnameOverride` | String to fully override the fullname template | `""` |
| `serviceAccount.create` | Whether to create a service account | `true` |
| `serviceAccount.annotations` | Annotations of the service account, e.g. `eks.amazonaws.com/role-arn` (IRSA) or `iam.gke.io/gcp-service-account` (GKE Workload Identity) | `{}` |
| `serviceAccount.name` | Name of the service account; generated from the fullname template if empty and `serviceAccount.create` is `true` | `""` |
| `serviceAccount.automountServiceAccountToken` | Mount the service account token into the pod; only applies if `serviceAccount.create` is `true` | `true` |
| `podAnnotations` | Annotations of the pod | `{}` |
| `podSecurityContext` | Security context of the pod. backmon runs as non-root user 65532; set e.g. `fsGroup` if it has to read backup files from mounted volumes | `{}` |
| `securityContext` | Security context of the container | `{}` |
| `service.type` | Kubernetes Service type | `ClusterIP` |
| `service.port` | HTTP port of the service | `80` |
| `ingress.enabled` | Whether to create an Ingress | `false` |
| `ingress.className` | Ingress class | `""` |
| `ingress.annotations` | Annotations for the Ingress | `{}` |
| `ingress.hosts` | Hosts and paths of the Ingress. See `values.yaml` for an example | `chart-example.local` |
| `ingress.tls` | TLS configuration of the Ingress. See `values.yaml` for an example | `[]` |
| `resources` | Resource requests and limits of the container | `{}` |
| `nodeSelector` | Node selector of the pod | `{}` |
| `tolerations` | Tolerations of the pod | `[]` |
| `affinity` | Affinity of the pod | `{}` |
| `backmon.config.enabled` | Whether to create the configuration file from `backmon.config.content`. Set to `false` to supply your own at `/etc/backmon/config.yaml`, e.g. with `extraVolumes` | `true` |
| `backmon.config.content` | Content of backmon's `config.yaml` ([official docs](https://dreitier.github.io/backmon-docs/reference/backmon-configuration/overview)). Stored in a secret. Keep `port: 8000` | see `values.yaml` |
| `extraEnvFrom` | List of existing secrets (`name`) whose keys are injected as environment variables, e.g. for `__${VAR}__` placeholders in the configuration | `[]` |
| `extraEnv` | List of environment variables to be injected into the backmon container. See `values.yaml` for an example | `[]` |
| `extraVolumes` | List of volumes to be added to the pod. See `values.yaml` for an example | `[]` |
| `extraVolumeMounts` | List of volume mounts to be added to the backmon container. See `values.yaml` for an example | `[]` |
| `serviceMonitor.enabled` | Whether to deploy a ServiceMonitor object to make Prometheus scrape the application metrics. Requires the corresponding CRD to be installed | `true` |
| `prometheusRules.enabled` | Whether to deploy PrometheusRule objects to monitor the state of backups. Requires the corresponding CRD to be installed | `false` |
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

## Development

### Test local chart output

```bash
$ helm template . --debug
```
