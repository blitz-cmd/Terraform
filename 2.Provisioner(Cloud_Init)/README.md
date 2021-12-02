# Provisioner

### 1) Created ssh key in local
```
$ ssh-keygen -t rsa
$ sudo chmod 400 id_rsa.pub
```
### 2) Created key-pair and added ssh key
### 3) Created Security Group
### 4) Created userdata.yml

#### [Reference Link](https://cloudinit.readthedocs.io/en/latest/topics/examples.html)

### 5) Import it into the main&#46;tf
### 6) Apply the changes
### 7) SSH into the EC2
```
$ ssh ec2-user@$(terraform output -raw Public_IPv4) -i /home/deep/.ssh/id_rsa
```
### 8) Added local exec code
```
local-exec provisioner helps run a script on instance where we are running our terraform code, not on the resource we are creating.
```
### 9) Added remote exec code
```
remote-exec provisioner helps invoke a script on the remote resource once it is created.
```
### 10) Added file code
### 11) Added null resource 
```
null resource check whether the instance creation along with status check is completed or not after that terraform apply command is completed
```
### 11) Applied the changes on EC2 only
```
$ terraform apply -replace="aws_instance.my_server"
```