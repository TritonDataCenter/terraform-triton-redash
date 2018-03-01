#
# Outputs
#
output "redash_primaryip" {
  value = ["${triton_machine.redash.*.primaryip}"]
}

output "redash_address" {
  value = "${local.redash_address}"
}
