# Build custom docker 

## apache nifi 

```bash
# apache nifi
$docker build -t aristidetm/nifi:1.26.0 --build-arg NIFI_VERSION=1.26.0 -f Dockerfile.nifi .
# jupyterhub
$docker build -t aristidetm/k8s-hub:3.3.7 --build-arg JUPYTERHUB_VERSION=3.3.7 -f Dockerfile.hub .
```