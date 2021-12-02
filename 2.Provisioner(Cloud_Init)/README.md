# Provisioner

### Created ssh key
```
$ ssh-keygen -t rsa
$ sudo chmod 400 id_rsa.pub
```
### Created key-pair and added ssh key
### Created Security Group
### Created userdata.yml
```
Reference: https://cloudinit.readthedocs.io/en/latest/topics/examples.html
```
### Import it into the main.tf
### Apply the changes
### SSH into the EC2
```
$ ssh ec2-user@$(terraform output -raw Public_IPv4) -i /home/deep/.ssh/id_rsa
```
### Added local exec code
#### local-exec provisioner helps run a script on instance where we are running our terraform code, not on the resource we are creating.
### Added remote exec code
#### remote-exec provisioner helps invoke a script on the remote resource once it is created.
### Added file code
### Added null resource to check if the instance creation along with status check is completed or not.