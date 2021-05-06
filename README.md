## Create a Self-managed kubernetes Cluster in any Cloud platform (AWS, GCP or Azur)

##### 1) Requirements

- Three Linux-based OS (any distro) of your choice with atleast 2CPUs and 4 GB. I am using Ubunutu 20.14,
- Stable internet connection,
- I have prepered infrastructures as listed in [`k8s-infrastructure-with-terraform`](https://github.com/asongent/Create-Self-Managed-k8s-Cluster/tree/master/k8s-infrastructure-with-terraform) folder above. You just need to clone it, edit it to your own preference and then deploy it to continue with this tutorial.  

----

##### Step 1.

###### Once all your devices are up and running you will have to perform the following to insure that all the applications are up and running

- On `master-node`, `workernode01`, and `workernode02` perform the following

```bash
docker --version
kubectl vesion
```
----

##### Step 2
###### Initialize Kubernetes on Master Node 

- on `master-node`, the k8s cluster
 
 ```bash
 sudo kubeadm init --pod-network-cidr=172.16.0.0/16
 ```
 ###### NB. The cidr block (172.16.0.0/16) is for my VPC. Yours may be different if you choose not to use what is decleared on the [`variable.tf`](https://github.com/asongent/Create-Self-Managed-k8s-Cluster/blob/master/k8s-infrastructure-with-terraform/variables.tf#L65) file above.


```bash
sudo kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
```