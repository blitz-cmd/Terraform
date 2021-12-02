# Terraform Basics

### Initialise the folder to add all the dependencies & configurations
```
$ terraform init
```
### To format & validate the configurations
```
$ terraform fmt
$ terraform validate
```
### Get blueprint of configurations
```
$ terraform plan
$ terraform plan -out=<filename>
```
### To apply the configurations
```
$ terraform apply
$ terraform apply -auto-approve
$ terraform apply -refresh-only
$ terraform apply -replace="aws_instance.my_server"
```
### Refresh the tf state file
```
$ terraform refresh
```
### Display output
```
$ terraform output
```
### Inspect state of configuration
```
$ terraform show
$ terraform state list
```
### To destroy the config.
```
$ terraform destroy
```
# Terraform resources

[HashiCorp Terraform Associate Certification Course](https://www.youtube.com/watch?v=V4waklkBC38&t)
[Terraform Registry Provider AWS Docs](https://registry.terraform.io/providers/hashicorp/aws/latest)
[Terraform Basic Docs AWS](https://learn.hashicorp.com/tutorials/terraform/aws-build?in=terraform/aws-get-started)
[Terraform AWS Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
[Terraform Modules](https://registry.terraform.io/browse/modules)
[Terraform Cloud](https://www.terraform.io/cloud)
[Cloud Init](https://cloudinit.readthedocs.io/en/latest/topics/examples.html)