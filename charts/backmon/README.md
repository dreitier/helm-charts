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

| Parameter                                     | Description                                                                                                            | Default                                                     |
| --------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------- |
| `image.pullSecrets`                           | Specify Image pull secrets                                                                                             | `nil` (does not add image pull secrets to deployed pods)    |
| `nameOverride`                                | String to partially override app.fullname template with a string (will prepend the release name)                     | `nil`                                                       |
| `fullnameOverride`                            | String to fully override app.fullname template with a string                                                         | `nil`                                                       |
| `service.type`                                | Kubernetes Service type                                                                                                | `ClusterIP`                                                 |
| `service.port`                                | HTTP port                                                                                                              | `80`                                                        | 
| `ingress.enabled`                             | Whether to create an Ingress                                                                                           | `false`                                                     |
| `ingress.annotations`                         | Annotations for the Ingress                                                                                            | `{}`                                                        |
| `ingress.host`                                | Hostname the Ingress should map to                                                                                     | `chart-example.local`                                       |
| `ingress.tls.enabled`                         | Enable TLS on the Ingress. The name of the TLS secret is `{{ $fullName }}-tls`                                         | `false`                                                     |
| `probes.enabled`                              | Enable the readiness and liveness probes                                                                               | `false`                                                     |
| `backmon.log_level`                           | Log level of the application. See https://github.com/sirupsen/logrus#level-logging for more information                | `info`                                                      |
| `backmon.update_interval`                     | How often Cloudmon should scan the configured buckets (interval in minutes)                                            | `60`                                                        |
| `backmon.disks.include`                     | Explicitly include those disks during discovery ([official docs](https://dreitier.github.io/backmon-docs/reference/backmon-configuration/overview)) | `[]`                                                        |
| `backmon.disks.exclude`                     | Explicitly exclude those disks during discovery ([official docs](https://dreitier.github.io/backmon-docs/reference/backmon-configuration/overview)) | `[]`                                                        |
| `backmon.disks.all_others`                     | For each other disk found during discovery, do that ([official docs](https://dreitier.github.io/backmon-docs/reference/backmon-configuration/overview)) | `include`                                                        |
| `backmon.environments`                       | Map of environments backmon should scan. See `values.yaml` for an example                                             | `{}`                                                        |
| `backmon.secrets`                            | List of secrets to be used in Cloudmon environment configuration. See `values.yaml` for an example                     | `[]`                                                        |

### Prerequisites

- Kubernetes 1.10+

## Development
### Test local chart output

```bash
$ helm template . --debug
```