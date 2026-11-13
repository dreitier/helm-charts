# Helm chart: postfix - SMTP relay

Postfix as an SMTP relay in Kubernetes: applications in the cluster send mail without authentication to the
service, Postfix forwards it to an upstream SMTP server (e.g. Mailgun, Amazon SES, Microsoft 365) with TLS and
SASL authentication.

- Image: [dreitier/postfix](https://github.com/dreitier/postfix-docker) (environment variables and details in its README)

## Getting started

```console
$ helm repo add dreitier https://dreitier.github.io/helm-charts/
$ helm repo update
$ helm install postfix dreitier/postfix \
    --set smtp.relayHost='[smtp.mailgun.org]:587' \
    --set smtp.relayMyhostname=relay.example.com \
    --set smtp.relayUsername=postmaster@mg.example.com \
    --set secret.useExistingSecret=true \
    --set secret.existingSecretName=postfix-relay
```

The chart is also available as OCI artifact: `oci://ghcr.io/dreitier/charts/postfix`.

Applications use `<release>-postfix.<namespace>.svc:25` as SMTP server, without authentication and TLS.

## Configuration parameters

| Parameter | Description | Default |
|---|---|---|
| `smtp.relayHost` | Upstream SMTP server, e.g. `[smtp.mailgun.org]:587` (brackets: no MX lookup). Required | `[smtp.mailgun.org]:587` |
| `smtp.relayMyhostname` | Host name of the relay (HELO, `Received:` header). Required | `my.host.local` |
| `smtp.relayUsername` | SASL user name; without user name and password, SASL is disabled | `""` |
| `smtp.relayPassword` | SASL password, stored in a Secret created by the chart. Prefer `secret.useExistingSecret` | `""` |
| `smtp.relayNetworks` | Clients allowed to relay (Postfix `mynetworks`), comma-separated | `127.0.0.0/8,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16` |
| `smtp.tlsSecurityLevel` | TLS to the upstream server: `encrypt` (required), `secure`/`verify` (with certificate check), `may`, `none` | `encrypt` |
| `smtp.tlsWrappermode` | `true` for implicit TLS (port 465), `false` for STARTTLS (ports 587/25) | `false` |
| `smtp.saslSecurityOptions` | Postfix `smtp_sasl_security_options` | `noanonymous, noplaintext` |
| `smtp.saslTlsSecurityOptions` | Postfix `smtp_sasl_tls_security_options` | `noanonymous` |
| `smtp.postfixParameters` | Any other `main.cf` parameter, e.g. `{message_size_limit: "52428800"}` | `{}` |
| `secret.useExistingSecret` | Read the password from an existing Secret instead of `smtp.relayPassword` | `false` |
| `secret.existingSecretName` | Name of the existing Secret | `my-postfix-secret` |
| `secret.existingSecretKey` | Key of the password in the existing Secret | `tx-smtp-relay-password` |
| `extraEnv` | Additional environment variables of the container | `[]` |
| `replicaCount` | Number of replicas. Each replica has its own mail queue | `1` |
| `image.repository` / `image.tag` | Image | `dreitier/postfix` / chart `appVersion` |
| `service.type` / `service.port` / `service.annotations` | Service | `ClusterIP` / `25` / `{}` |
| `serviceAccount.create` / `.name` / `.annotations` | Service account | `true` / generated / `{}` |
| `serviceAccount.automountServiceAccountToken` | Mount the API token into the pod (Postfix doesn't need it) | `false` |
| `podAnnotations`, `podSecurityContext`, `securityContext`, `resources`, `nodeSelector`, `tolerations`, `affinity` | Usual pod settings | empty |

The password is mounted as a file (`TX_SMTP_RELAY_PASSWORD_FILE`), not passed as an environment variable. The pod
restarts when the configuration or the chart's Secret changes; after changing an existing Secret, restart it with
`kubectl rollout restart`.

## Security

Every client in `smtp.relayNetworks` can send mail with your credentials. In Kubernetes the default private
networks include every pod and every node of the cluster. Keep the service internal (`ClusterIP`): with a
`LoadBalancer` (`externalTrafficPolicy: Cluster`) or `NodePort`, external connections arrive with a node
address and are allowed to relay. Narrow `smtp.relayNetworks` or add a NetworkPolicy if only some workloads
should send mail.

The Postfix master process runs as root and drops privileges for its daemons; `runAsNonRoot` doesn't work.

Queued mail (e.g. while the upstream server is unreachable) lives in the container and is lost when the pod
is replaced.

## Upgrading to chart 2.0.0 (image 1.x)

- `smtp.saslSecurityLevel` was renamed to `smtp.tlsSecurityLevel`, default `encrypt` instead of `may`
  (TLS to the upstream server is required). The chart refuses to render with the old key.
- `smtp.relayNetworks` defaults to the private networks; the old default contained the public range
  `192.0.0.0/8`. Check values that set it explicitly.
- `smtp.relayUsername` / `smtp.relayPassword` default to empty (SASL disabled) instead of placeholders.
- `rbac.*` and `autoscaling.*` were removed: Postfix doesn't use the Kubernetes API, and the
  HorizontalPodAutoscaler used the API version `autoscaling/v2beta1` removed in Kubernetes 1.25.
- The password is mounted as a file; existing Secrets keep working (key configurable with
  `secret.existingSecretKey`).
- TCP readiness/liveness probes on port 25.
- Image 1.x: logs on stdout only, Postfix in the foreground, see the
  [postfix-docker changelog](https://github.com/dreitier/postfix-docker/blob/main/CHANGELOG.md).
