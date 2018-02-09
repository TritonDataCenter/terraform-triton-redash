#
# Outputs
#
output "redash_ip" {
  value = ["${triton_machine.redash.*.primaryip}"]
}

output "redash_role_tag" {
  value = "${var.role_tag}"
}

output "redash_address" {
  value = "${local.redash_address}"
}
