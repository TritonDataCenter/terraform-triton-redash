#
# Terraform/Providers
#
terraform {
  required_version = ">= 0.11.0"
}

provider "triton" {
  version = ">= 0.4.1"
}

#
# Data sources
#
data "triton_datacenter" "current" {}

data "triton_account" "current" {}

#
# Locals
#
locals {
  redash_address = "${var.cns_service_name_redash}.svc.${data.triton_account.current.id}.${data.triton_datacenter.current.name}.${var.cns_fqdn_base}"
}

#
# Machines
#
resource "triton_machine" "redash" {
  name    = "${var.name}-redash"
  package = "${var.package}"
  image   = "${var.image}"

  firewall_enabled = true

  networks = ["${var.networks}"]

  cns {
    services = ["${var.cns_service_name_redash}"]
  }

  metadata {
    version_redash = "${var.version_redash}"
  }
}

#
# Firewall Rules
#
resource "triton_firewall_rule" "ssh" {
  rule        = "FROM tag \"triton.cns.services\" = \"${var.bastion_cns_service_name}\" TO tag \"triton.cns.services\" = \"${var.cns_service_name_redash}\" ALLOW tcp PORT 22"
  enabled     = true
  description = "${var.name} - Allow access from bastion hosts to Redash servers."
}

resource "triton_firewall_rule" "client_access" {
  count = "${length(var.client_access)}"

  rule        = "FROM ${var.client_access[count.index]} TO tag \"triton.cns.services\" = \"${var.cns_service_name_redash}\" ALLOW tcp PORT 80"
  enabled     = true
  description = "${var.name} - Allow access from clients to Redash servers."
}

resource "triton_firewall_rule" "redash_to_presto_coordinator" {
  count = "${length(var.client_access)}"

  rule        = "FROM ${var.client_access[count.index]} TO tag \"triton.cns.services\" = \"${var.cns_service_name_presto_coordinator}\" ALLOW tcp PORT 8080"
  enabled     = true
  description = "${var.name} - Allow access from Redash to Presto servers."
}
