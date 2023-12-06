variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
variable "subnet_cidr" {
  default = "10.0.0.0/24" 
}
variable "ami_id" {
  default = "ami-0230bd60aa48260c6"
}
variable "instance_type" {
  default = "t2.micro"
}
variable "key_name" {
  default = "demo"
}
variable "region" {
  default = "us-east-1"
}
variable "web_ingress_rule" {
  type = map(object({
    description = string
    port = number
    protocol = string
    cidr_blocks = list(string)
  }))
 
}

variable "web_bucket" {
  
}