## Chart Repository Structure 

```
charts/
  |
  |- index.yaml
  |
  |- my-app-config-1.0.0.tgz
  |
  |- my-app-config-2.0.0.tgz
```
## Package a Chart
### Package my-app-config Chart V1
-`helm package .`
### Create index.yaml
-`helm repo index --url  https://aristide.github.io/helm-repo/stable/ .`
### Package my-app-config Chart V2
-`helm package .`
### Merge my-app-config index.yaml
-`helm repo index --url https://aristide.github.io/helm-repo/stable/ --merge index.yaml .`
  
```