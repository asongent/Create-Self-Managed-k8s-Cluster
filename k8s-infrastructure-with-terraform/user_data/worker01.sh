#!/bin/bash
sudo apt-get update -y

sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo swapoff -a
sudo apt install docker.io -y
sudo usermod -aG docker vagrant
sudo service docker.service enable
sudo service docker start
sudo apt-get update -y

sudo mkdir /etc/docker
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF
sudo apt-get update -y
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update -y
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
sudo systemctl enable kubeadm
sudo apt-get update -y
sudo systemctl daemon-reload
sudo systemctl enable docker
sudo systemctl restart docker
sudo rm -rf /etc/docker/key.json
sudo systemctl enable kubelet
sudo systemctl restart kubelet

modeprobe br_netfilter
sysctl -p

# Set iptables bridging
sudo cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo echo '1' > /proc/sys/net/ipv4/ip_forward
sudo sysctl --system
sudo apt-get update
sudo hostnamectl set-hostname workernode01
