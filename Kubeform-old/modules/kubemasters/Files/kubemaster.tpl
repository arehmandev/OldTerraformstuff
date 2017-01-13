#!/bin/bash
#### AWS Userdata bash script for bootstrapping kubernetes master nodes

#Cert generation
echo "$$cacert" > /var/lib/kubernetes/ca.pem
echo "$$kubemastercert" > /var/lib/kubernetes/kubernetes.pem
echo "$$kubemasterpem" > /var/lib/kubernetes/kubernetes-key.pem
echo "$$elbdnsname"


#Kube API server
INTERNAL_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)

wget -O /usr/bin/kube-apiserver https://storage.googleapis.com/kubernetes-release/release/v1.4.0/bin/linux/amd64/kube-apiserver

wget -O /usr/bin/kube-controller-manager https://storage.googleapis.com/kubernetes-release/release/v1.4.0/bin/linux/amd64/kube-controller-manager

wget -O /usr/bin/kube-scheduler wget https://storage.googleapis.com/kubernetes-release/release/v1.4.0/bin/linux/amd64/kube-scheduler

wget -O /usr/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v1.4.0/bin/linux/amd64/kubectl

chmod +x /usr/bin/kube-apiserver /usr/bin/kube-controller-manager /usr/bin/kube-scheduler /usr/bin/kubectl

# Modify as you wish for production
cat > /var/lib/kubernetes/token.csv <<"EOF"
chAng3m3,admin,admin
chAng3m3,scheduler,scheduler
chAng3m3,kubelet,kubelet
EOF

# Modify as you wish for production
cat > /var/lib/kubernetes/authorization-policy.jsonl <<"EOF"
{"apiVersion": "abac.authorization.kubernetes.io/v1beta1", "kind": "Policy", "spec": {"user":"*", "nonResourcePath": "*", "readonly": true}}
{"apiVersion": "abac.authorization.kubernetes.io/v1beta1", "kind": "Policy", "spec": {"user":"admin", "namespace": "*", "resource": "*", "apiGroup": "*"}}
{"apiVersion": "abac.authorization.kubernetes.io/v1beta1", "kind": "Policy", "spec": {"user":"scheduler", "namespace": "*", "resource": "*", "apiGroup": "*"}}
{"apiVersion": "abac.authorization.kubernetes.io/v1beta1", "kind": "Policy", "spec": {"user":"kubelet", "namespace": "*", "resource": "*", "apiGroup": "*"}}
{"apiVersion": "abac.authorization.kubernetes.io/v1beta1", "kind": "Policy", "spec": {"group":"system:serviceaccounts", "namespace": "*", "resource": "*", "apiGroup": "*", "nonResourcePath": "*"}}
EOF

cat > /etc/systemd/system/kube-apiserver.service <<"EOF"
[Unit]
Description=Kubernetes API Server
Documentation=https://github.com/GoogleCloudPlatform/kubernetes

[Service]
ExecStart=/usr/bin/kube-apiserver \
  --admission-control=NamespaceLifecycle,LimitRanger,SecurityContextDeny,ServiceAccount,ResourceQuota \
  --advertise-address=INTERNAL_IP \
  --allow-privileged=true \
  --apiserver-count=3 \
  --authorization-mode=ABAC \
  --authorization-policy-file=/var/lib/kubernetes/authorization-policy.jsonl \
  --bind-address=0.0.0.0 \
  --enable-swagger-ui=true \
  --etcd-cafile=/var/lib/kubernetes/ca.pem \
  --insecure-bind-address=0.0.0.0 \
  --kubelet-certificate-authority=/var/lib/kubernetes/ca.pem \
  --etcd-servers=https://ETCD0IP,https://ETCD1IP,https://ETCD2IP \
  --service-account-key-file=/var/lib/kubernetes/kubernetes-key.pem \
  --service-cluster-ip-range=10.32.0.0/24 \
  --service-node-port-range=30000-32767 \
  --tls-cert-file=/var/lib/kubernetes/kubernetes.pem \
  --tls-private-key-file=/var/lib/kubernetes/kubernetes-key.pem \
  --token-auth-file=/var/lib/kubernetes/token.csv \
  --v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

sed -i s/ETCD0IP/$$etcd0ip/g /etc/systemd/system/kube-apiserver.service
sed -i s/ETCD1IP/$$etcd1ip/g /etc/systemd/system/kube-apiserver.service
sed -i s/ETCD2IP/$$etcd2ip/g /etc/systemd/system/kube-apiserver.service

sed -i s/INTERNAL_IP/$$INTERNAL_IP/g /etc/systemd/system/kube-apiserver.service
systemctl daemon-reload
systemctl enable kube-apiserver
systemctl start kube-apiserver

#Kubernetes Controller Manager

cat > /etc/systemd/system/kube-controller-manager.service <<"EOF"
[Unit]
Description=Kubernetes Controller Manager
Documentation=https://github.com/GoogleCloudPlatform/kubernetes

[Service]
ExecStart=/usr/bin/kube-controller-manager \
  --allocate-node-cidrs=true \
  --cluster-cidr=10.200.0.0/16 \
  --cluster-name=kubernetes \
  --leader-elect=true \
  --master=http://INTERNAL_IP:8080 \
  --root-ca-file=/var/lib/kubernetes/ca.pem \
  --service-account-private-key-file=/var/lib/kubernetes/kubernetes-key.pem \
  --service-cluster-ip-range=10.32.0.0/24 \
  --v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

sed -i s/INTERNAL_IP/$$INTERNAL_IP/g /etc/systemd/system/kube-controller-manager.service
systemctl daemon-reload
systemctl enable kube-controller-manager
systemctl start kube-controller-manager

#Kubernetes Scheduler

cat > /etc/systemd/system/kube-scheduler.service <<"EOF"
[Unit]
Description=Kubernetes Scheduler
Documentation=https://github.com/GoogleCloudPlatform/kubernetes

[Service]
ExecStart=/usr/bin/kube-scheduler \
  --leader-elect=true \
  --master=http://INTERNAL_IP:8080 \
  --v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

sed -i s/INTERNAL_IP/$$INTERNAL_IP/g /etc/systemd/system/kube-scheduler.service
systemctl daemon-reload
systemctl enable kube-scheduler
systemctl start kube-scheduler

#Verification
systemctl status kube-scheduler --no-pager
kubectl get componentstatuses
