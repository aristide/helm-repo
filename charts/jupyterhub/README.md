# JupyterHub Helm chart

## Configure JupyterHub Helm repo

```bash
helm repo add d4n https://aristide.github.io/helm-repo/stable
```

### Installing the Chart (toy-setup)

Minimal toy setup for testing purposes can be deployed using:

```bash
helm show values d4n/jupyterhub  > config.yaml
helm upgrade --cleanup-on-fail --install jupyterhub d4n/jupyterhub --values config.yaml
```

### Upgrading the Chart

You can use Helm to update JupyterHub version in a live release. Assuming your release is named as `my-release`, get the values using the command:

```bash
helm get values my-release > old_values.yaml
```

Then change the field `image.tag` in `old_values.yaml` file with JupyterHub image tag you want to use. Now update the chart using

```bash
helm upgrade -f old_values.yaml my-release d4n/jupyterhub
```

Default upgrade strategies are specified in the `values.yaml` file. Update these fields if you'd like to use a different strategy.

### Configuration

Refer the [Values file](./values.yaml) for all the possible config fields.

You can provide a YAML file that specifies parameter values while installing the chart. For example,

```bash
helm install --name my-release -f values.yaml d4n/jupyterhub
```

## Uninstalling the Chart

Assuming your release is named as `my-release`, delete it using the command:

```bash
helm delete my-release
```

or

```bash
helm uninstall my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.
