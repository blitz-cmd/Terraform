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
### Standard Module Structure
|—— main.tf
|—— variables.tf
|—— outputs.tf