# Cluster prerequisite
```bash
hostnamectl set-hostname <hostname>

setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
systemctl stop firewalld
systemctl disable firewalld
swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

dnf update -y
dnf install -y cri-o kubelet kubeadm kubectl


modprobe overlay
modprobe br_netfilter

tee /etc/sysctl.d/99-kubernetes-cri.conf <<EOF
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF


echo "br_netfilter" | sudo tee /etc/modules-load.d/br_netfilter.conf
sysctl -w net.bridge.bridge-nf-call-iptables=1
sysctl -w net.bridge.bridge-nf-call-ip6tables=1

systemctl enable --now crio
systemctl enable --now kubelet
sysctl --system
```

# Cluster Setup (first node)
```bash
kubeadm init --control-plane-endpoint "192.168.0.14" --upload-certs --pod-network-cidr "10.244.0.0/16"

mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

# enable worker role on control plane
kubectl taint nodes <hostname> node-role.kubernetes.io/control-plane:NoSchedule-
```

# Cluster Setup (other nodes)
```bash
kubeadm join 192.168.0.14:6443 --token <token>  --discovery-token-ca-cert-hash <ca-cert>

# enable worker role on control plane
kubectl taint nodes <hostname> node-role.kubernetes.io/control-plane:NoSchedule-

```

# Create Kubernetes secrets for Oracle Secret Manager
```bash
vim oracle-auth-secret.yaml
```

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: oracle-secret
  namespace: external-secrets
  labels:
    type: oracle
type: Opaque
stringData:
  privateKey: |
   -----BEGIN RSA PRIVATE KEY-----
   <YOUR_PRIVATE_KEY_HERE>
   -----END RSA PRIVATE KEY-----
  fingerprint: <YOUR_FINGERPRINT_HERE>
```

```
kubectl apply -f oracle-auth-secret.yaml
```

# Flux Bootstrap
```bash
flux bootstrap github \
    --owner=Yiu-Kelvin \
    --repository=homelab \
    --branch=main \
    --path=./k8s/clusters/production \
    --components-extra=image-reflector-controller,image-automation-controller,source-watcher
```

# Confirm working
```bash
flux get kustomizations
flux logs -f 
kubectl get pods
```

