vpc_cidr = "10.10.0.0/16"
subnet_cidr = "10.10.0.0/24"
instance_type = "t2.micro"
key_name = "demo"
web_ingress_rule = {
  "22" = {
      port = 22
      protocol = "tcp"
      cidr_blocks =["0.0.0.0/0"]
      description = "ssh"
    },
    "80" = {
        port = 80
        protocol = "tcp"
        cidr_blocks =["0.0.0.0/0"]
        description = "http"
    }
}
web_bucket = "s3-nov-bucket-01"