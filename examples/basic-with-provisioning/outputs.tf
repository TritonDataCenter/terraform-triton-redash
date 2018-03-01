#
# Outputs
#
output "bastion_address" {
  value = ["${module.bastion.bastion_address}"]
}

output "redash_address" {
  value = ["${module.redash.redash_address}"]
}
