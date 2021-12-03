# Terraform variables
#### **Note:**
```
- terraform.tfvars - It will be automatically loaded when running terraform apply.
- dev.tfvars       - It will not automatically loaded. As the starting name is not terraform
- dev.auto.tfvars  - It will be automatically loaded
$ terraform apply -var-file dev.tfvars  - specify variable inline via command line
$ terraform apply -var ec2_type="t2.micro"  - specify variable inline via command line
$ export TF_VAR_my_variable_name='<value>'  - terraform will watch for environment variable that begins with TF_VAR & apply those as variable

Preference of variables(desc): (-var & -var-file), (*.auto.tfvars & *.auto.tfvars.json), terraform.tfvars.json, terraform.tfvars, environemnt variable
```
### Terraform outputs
```
$ terraform output
$ terraform output Public_IPv4
$ terraform output -raw Public_IPv4
$ terraform output -json
$ terraform outpit -json | jq .
$ terraform output -json | jq -r ".Public_IPv4.type"
$ terraform output -json | jq -r ".Public_IPv4.value"