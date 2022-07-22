# postfix-helm

This Helm chart can be used to deploy the `postfix-relay` into your Kubernetes cluster.

The chart will deploy 2 pods (for high availability), load balanced with a service, exposing port 25.

# Need to set SMTP connection details

```bash
export SMTP="[smtp.mailgun.org]:587"
export USERNAME=<your smtp username>
export PASSWORD=<your smtp password>

helm upgrade --install postfix-relay \
        --set smtp.relayHost=${SMTP} \
        --set smtp.relayMyhostname=my.local \
        --set smtp.relayUsername=${USERNAME} \
        --set smtp.relayPassword=${PASSWORD} \ 
        postfix/helm
```
