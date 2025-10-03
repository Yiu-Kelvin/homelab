# Basic setup
## Install flux to the cluster
```
export GITHUB_TOKEN=<your-token>
export GITHUB_USER=<your-username>
```
```
flux check --pre

flux bootstrap github \
  --owner=$GITHUB_USER \
  --repository=homelab \
  --branch=main \
  --path=./k8s/homelab \
  --personal
```
