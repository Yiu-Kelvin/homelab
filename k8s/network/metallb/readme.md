```
kubectl apply -f ./metallb-manifest.yaml
kubectl apply -f ./lb
kubectl label namespace metallb-system pod-security.kubernetes.io/enforce=privileged
kubectl label namespace metallb-system pod-security.kubernetes.io/audit=privileged
kubectl label namespace metallb-system pod-security.kubernetes.io/warn=privileged
```
