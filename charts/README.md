## Chart Repository Structure 

```
stable/
  |
  |- index.yaml
  |- chart-package-on-<version>.tgz
  |- chart-package-two-<version>.tgz
  |- ...... 
```
## Package a Chart

Move inside the chart folder  and run the following commande line

### Lint the Chart
-`helm lint .`
### Package the chart
-`helm package .`
### Merge the chart into the index.yaml
-`helm repo index --url https://aristide.github.io/helm-repo/stable/ --merge ../index.yaml .` 
```