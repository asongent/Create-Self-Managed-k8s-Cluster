#### SELF-MANAGED KUBERNETES CLUSTER DEPLOYMENT STEPS

**Purpose: This documentation provides steps to create self-managed kunernetes cluster with KUBEADM**
- **The Operating System is Ubuntu 20.04 LT**
- **Terraform script will work only on AWS**
- **KUBEAM bootstrap scripts are in `user_data` directory**

**Step 1: Assume You have AWSCLI downloaded and Setup with your API keys**
<details><summary>View</summary>
<p>
 It was easy!
(:
</p>
</details>

**Step 2: Create and download keypair from CLI**
<details><summary>View</summary>
<p>

 **For Windows Users**
- Open Windows Powershell as Administrator, run 
 ```bash
aws ec2 create-key-pair --region us-xxx-2 --key-name mykeypair --query 'KeyMaterial' --output text | out-file -encoding ascii -filepath ~/Desktop/mykeypair.pem 
 ```
 - Move to directory where you saved your keypair(`mykeypair.pem`) and run 
 
 ```
 chmod 400 mykeypair.pem
```
Note!
> Your keypair must be created in the same region you intend to create your cluster.
> You must reference the keypair on your deployment script to enable you SSH to nodes

 **For MacOS users**

 ```bash
aws ec2 create-key-pair --key-name myKeypair --query 'KeyMaterial' --output text > mykeypair.pem
 ```

</p>
</details>

**Step 3: Update The Script**
<details><summary>View</summary>
<p>
  
  - `cd` into `k8s-infrastructure-with-terraform` 
  - Update `backend.tf` with an existing `S3` bucket. 
  - If you don't want to save you statefile in any `S3` bucket, comment `backend.tf`.
  - In `terraform.tfvars` update `aws_access_key` with your ***aws_access_key_id*** and `aws_secret_key` with ***aws_secret_access_key***.
  - In `variables.tf.
    - on `line 12`, update the region.
    - on `line 25`, update `ami-042e8287309f5df03`. The AMI must be `Ubuntu 20.04` and must be in the region you intend to create your nodes.

</p>
</details>

**Step 4: Deploy You infrastructures**
<details><summary>View</summary>
<p>


</p>
</details>

**Step 6: One Important Thing**
<details><summary>View</summary>
<p>
- Remember NOT to push your `keys` to github repo (:.
</p>
</details>
  

## Create a Self-managed kubernetes Cluster in any Cloud platform (AWS, GCP or Azure)

##### Requirements

###### - Three Linux-based OS (any distro) of your choice with atleast 2CPUs and 4 GB. I am using Ubunutu 20.14 LT,
###### - Stable internet connection,
###### - I have prepered infrastructures as listed in [`k8s-infrastructure-with-terraform`](https://github.com/asongent/Create-Self-Managed-k8s-Cluster/tree/master/k8s-infrastructure-with-terraform) folder above. You just need to clone it, edit it to your own preference and then deploy it to continue with this tutorial.  

----

##### Step 1
###### Once all your devices are up and running you will have to perform the following to insure that all the applications are up and running

- On `master-node`, `workernode01`, and `workernode02` perform the following
```bash
docker --version
kubectl vesion
```
----
##### Step 2
###### Initialize Kubernetes on Master Node 

- on the `master-node`, launch
 ```bash
 sudo kubeadm init --pod-network-cidr=172.16.0.0/16
 ```
 ###### NB. The cidr block (172.16.0.0/16) is for my VPC. Yours may be different if you choose not to use what is decleared on the [`variable.tf`](https://github.com/asongent/Create-Self-Managed-k8s-Cluster/blob/master/k8s-infrastructure-with-terraform/variables.tf#L65) file above.

 - Take note of the `kubeadm join` ouput (message). This displays the token that will enable worker-nodes to join the cluster.
```bash
kubeadm join 172.16.0.197:6443 --token nj5zpr.7nedjnucg1dhe6ox \
        --discovery-token-ca-cert-hash sha256:7f876317b4e0c523222765895e4447cd88ca117deb40065b9a6d220b14d2fd7f
```
- Create a directory and assign some permission to the cluster 
```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```


```bash
sudo kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
```