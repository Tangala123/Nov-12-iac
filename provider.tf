# Provider supports multiple cloud platform - Using AWS cloud provider
provider "aws" {
  region = var.region
}
terraform {
  backend "s3" {
    bucket         = "your-bucket-name"
    key            = "path/to/your/terraform.tfstate"
    region         = "your-bucket-region"
    dynamodb_table = "terraform-lock"  # Optional, for state locking
    encrypt        = true              # Optional, to enable server-side encryption
  }
}

# terraform init - Intializing the provider plugins
# terraform plan - Preview the code and showing what resources will be creating
# terraform apply - Resources will be created
# terraform apply -auto -approve  = without asking prompt will be created resources
# terraform destroy - Resources will be deleted
# terraform destroy -auto -approve  = without asking prompt will be deleted resources
# terraform validate - Checking syntax in the code
# terraform apply -auto-approve --target=aws_vpc.main => crerated specific resource
# terraform destroy -auto-approve --target=aws_vpc.main => deleted specific 
# terraform taint aws_vpc.main => taint means recreate the specific resource and it will taint as vpc, vpc must be destroy and recreate
# terraform import aws_subnet.sub-main <Subnet-id> => we are importing the terraform code with manually created subnetid
# terraform fmt - allocate the allingment
# .terraform and .terraform.lock are two hidden folders and it providers the plugins and versions in that internal folders
# terraform-statefile => Statefile is managed by terraform and it looks like json formate, it contains mapping with code and realworld object, when they run apply the resources will be created and it will be stored in statefile
# terraform workspace new prod => created and switched to workspace "prod"
# terraform apply -auto-approve -var-file=prod.tfvars => creating the resources for prod 
# tfvars means input variables to the prod or dev environment
