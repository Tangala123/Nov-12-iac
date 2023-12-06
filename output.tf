output "azs" {
  value = local.azs_names
}
output "acc_no" {
  value = local.acc_no
}
output "web_public_ip" {
  value = aws_instance.main.*.public_ip[0]
}