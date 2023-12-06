locals {
  azs_names = data.aws_availability_zones.azs.names
  acc_no    = data.aws_caller_identity.current.account_id
  ws = terraform.workspace == "default" ? "dev" : terraform.workspace
}