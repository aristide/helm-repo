# Ldap Helm Chart

This is a simple LDAP server that tries to simulate an AD using 
Apache Directory Server. IT is based on https://github.com/dwimberger/ldap-ad-it

## Configure Ldap Helm repo

```bash
helm repo add d4n https://aristide.github.io/helm-repo/stable
```

### Installing the Chart

Install this chart using:

```bash
helm install --namespace ldap --generate-name d4n/ldap
```

The command deploys MinIO on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.
