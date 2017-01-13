#!/bin/bash
#### AWS Userdata bash script for bootstrapping kubernetes worker nodes

#Cert generation
echo "$$cacert" > /var/lib/kubernetes/ca.pem
echo "$$kubenodecert" > /var/lib/kubernetes/kubernetes.pem
echo "$$kubenodepem" > /var/lib/kubernetes/kubernetes-key.pem

#Docker
wget https://get.docker.com/builds/Linux/x86_64/docker-1.12.1.tgz
tar -xvf docker-1.12.1.tgz
sudo cp docker/docker* /usr/bin/

sudo sh -c 'echo "[Unit]
Description=Docker Application Container Engine
Documentation=http://docs.docker.io

[Service]
ExecStart=/usr/bin/docker daemon \
  --iptables=false \
  --ip-masq=false \
  --host=unix:///var/run/docker.sock \
  --log-level=error \
  --storage-driver=overlay
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/docker.service'

sudo systemctl daemon-reload
sudo systemctl enable docker
sudo systemctl start docker

sudo docker version

#Kubelet
sudo mkdir -p /opt/cni
wget https://storage.googleapis.com/kubernetes-release/network-plugins/cni-07a8a28637e97b22eb8dfe710eeae1344f69d16e.tar.gz
sudo tar -xvf cni-07a8a28637e97b22eb8dfe710eeae1344f69d16e.tar.gz -C /opt/cni

wget -O /usr/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v1.4.0/bin/linux/amd64/kubectl
wget -O /usr/bin/kube-proxy https://storage.googleapis.com/kubernetes-release/release/v1.4.0/bin/linux/amd64/kube-proxy
wget /usr/bin/kubelet https://storage.googleapis.com/kubernetes-release/release/v1.4.0/bin/linux/amd64/kubelet
chmod +x /usr/bin/kubectl /usr/bin/kube-proxy /usr/bin/kubelet

sudo mkdir -p /var/lib/kubelet/

sudo sh -c 'echo "apiVersion: v1
kind: Config
clusters:
- cluster:
    certificate-authority: /var/lib/kubernetes/ca.pem
    server: https://10.240.0.10:6443
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: kubelet
  name: kubelet
current-context: kubelet
users:
- name: kubelet
  user:
    token: chAng3m3" > /var/lib/kubelet/kubeconfig'

sudo sh -c 'echo "[Unit]
Description=Kubernetes Kubelet
Documentation=https://github.com/GoogleCloudPlatform/kubernetes
After=docker.service
Requires=docker.service

[Service]
ExecStart=/usr/bin/kubelet \
  --allow-privileged=true \
  --api-servers=https://10.240.0.10:6443,https://10.240.0.11:6443,https://10.240.0.12:6443 \
  --cloud-provider= \
  --cluster-dns=10.32.0.10 \
  --cluster-domain=cluster.local \
  --configure-cbr0=true \
  --container-runtime=docker \
  --docker=unix:///var/run/docker.sock \
  --network-plugin=kubenet \
  --kubeconfig=/var/lib/kubelet/kubeconfig \
  --reconcile-cidr=true \
  --serialize-image-pulls=false \
  --tls-cert-file=/var/lib/kubernetes/kubernetes.pem \
  --tls-private-key-file=/var/lib/kubernetes/kubernetes-key.pem \
  --v=2

Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/kubelet.service'

sudo systemctl daemon-reload
sudo systemctl enable kubelet
sudo systemctl start kubelet
sudo systemctl status kubelet --no-pager

#Kube-proxy

sudo sh -c 'echo "[Unit]
Description=Kubernetes Kube Proxy
Documentation=https://github.com/GoogleCloudPlatform/kubernetes

[Service]
ExecStart=/usr/bin/kube-proxy \
  --master=https://10.240.0.10:6443 \
  --kubeconfig=/var/lib/kubelet/kubeconfig \
  --proxy-mode=iptables \
  --v=2

Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/kube-proxy.service'

sudo systemctl daemon-reload
sudo systemctl enable kube-proxy
sudo systemctl start kube-proxy

sudo systemctl status kube-proxy --no-pager
