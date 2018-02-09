#
# Outputs
#
output "bastion_ip" {
  value = ["${module.bastion.bastion_ip}"]
}

output "redash_ip" {
  value = ["${module.redash.redash_ip}"]
}

output "redash_address" {
  value = ["${module.redash.redash_address}"]
}
