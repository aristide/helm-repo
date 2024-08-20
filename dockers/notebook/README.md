# basick notebook docker 

from [b-data notebook](https://github.com/b-data/jupyterlab-r-docker-stack/tree/main)

```bash
# jupyterlab version 3.6.5 
$docker build -t aristidetm/basic-notebook:3.6.6  --build-arg JUPYTERHUB_VERSION=4.0.1  --build-arg JUPYTERLAB_VERSION=3.6.6  --build-arg JUPYTERLAB_LANG_PACK_VERSION=3.6.post2  .
# disable jupyterlab download features
$docker build -t aristidetm/basic-notebook-no-dwl:3.6.6  --build-arg JUPYTERHUB_VERSION=4.0.1  --build-arg JUPYTERLAB_VERSION=3.6.6  --build-arg JUPYTERLAB_LANG_PACK_VERSION=3.6. post2  .
```     