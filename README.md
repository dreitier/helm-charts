# Quick start

This repository contains the Helm charts for our products and tools.
To install this repository in your Kubernetes cluster, use the following commands:

```bash
helm repo add dreitier https://dreitier.github.io/helm-charts/
helm repo update
```

After that, you can search and install our charts, e.g.

```bash
helm search cloudmon
helm install dreitier/cloudmon
```

# Available Helm charts

| Chart | Description |
| --- | --- |
| [cloudmon](charts/cloudmon) | [cloudmon - Monitoring of backup files in filesystems and object storages](https://github.com/dreitier/cloudmon) |
| [silencer](charts/silencer) | [silencer - Create new silences in the Prometheus Alertmanager through a REST API.](https://github.com/dreitier/cloudmon) |
| [postfix](charts/postfix) | Deploy postfix in Kubernetes for local mail relaying |
 
