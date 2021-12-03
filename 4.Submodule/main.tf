terraform {
}

module "aws_module" {
  source=".//aws_module"
}

#show output
output "Public_IPv4" {
  value = module.aws_module.Public_IPv4
}