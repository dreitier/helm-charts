## TL;DR;

```console
$ helm install dreitier/cloudmon
```

## Prerequisites

- Kubernetes 1.10+

## Configuration parameters

The following tables lists the configurable parameters of the Cloudmon chart and their default values.

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
| `cloudmon.logLevel`                           | Log level of the application. See https://github.com/sirupsen/logrus#level-logging for more information                | `info`                                                      |
| `cloudmon.updateInterval`                     | How often Cloudmon should scan the configured buckets (interval in minutes)                                            | `60`                                                        |
| `cloudmon.environments`                       | Map of environments cloudmon should scan. See `values.yaml` for an example                                             | `{}`                                                        |
| `cloudmon.secrets`                            | List of secrets to be used in Cloudmon environment configuration. See `values.yaml` for an example                     | `[]`                                                        |