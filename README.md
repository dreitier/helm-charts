# Quick start

This repository contains the Helm charts for our products and tools.
To install this repository in your Kubernetes cluster, use the following commands:

```bash
helm repo add dreitier https://dreitier.github.io/helm-charts/
helm repo update
```

After that, you can search and install our charts, e.g.

```bash
helm search backmon
helm install dreitier/backmon
```

## OCI registry

All charts are also published as OCI artifacts to the GitHub Container Registry. No `helm repo add` is needed (Helm >= 3.8):

```bash
helm install backmon oci://ghcr.io/dreitier/charts/backmon --version <version>
helm show values oci://ghcr.io/dreitier/charts/backmon
```

# Available Helm charts

| Chart | Description |
| --- | --- |
| [backmon](charts/backmon) | [backmon - Monitoring of backup files in filesystems and object storages](https://github.com/dreitier/backmon) |
| [postfix](charts/postfix) | [Postfix SMTP relay that forwards mail from the cluster to an upstream SMTP server](https://github.com/dreitier/postfix-docker) |
| [psono](charts/psono) | [psono - Deploys the Psono password manager.](https://psono.com/) |
