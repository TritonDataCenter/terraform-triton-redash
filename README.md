# Triton Presto Terraform Module

A Terraform module to create a [Redash](https://prestodb.io/) server. Redash can then be used to 
query a [Presto cluster](https://github.com/joyent/terraform-triton-presto) and Triton Object Storage data.

## Usage

```hcl
#
# Data Sources
#
data "triton_image" "ubuntu" {
  name        = "ubuntu-16.04"
  type        = "lx-dataset"
  most_recent = true
}

data "triton_network" "public" {
  name = "Joyent-SDC-Public"
}

data "triton_network" "private" {
  name = "My-Fabric-Network"
}

#
# Modules
#
module "bastion" {
  source = "github.com/joyent/terraform-triton-bastion"

  name    = "redash-basic-with-provisioning"
  image   = "${data.triton_image.ubuntu.id}"
  package = "g4-general-4G"

  # Public and Private
  networks = [
    "${data.triton_network.public.id}",
    "${data.triton_network.private.id}",
  ]
}

module "redash" {
  source = "github.com/joyent/terraform-triton-redash"

  name    = "redash-basic-with-provisioning"
  image   = "${data.triton_image.ubuntu.id}"
  package = "g4-general-4G"

  # Public and Private
  networks = [
    "${data.triton_network.public.id}",
    "${data.triton_network.private.id}",
  ]

  provision        = "true"
  private_key_path = "${var.private_key_path}"

  client_access = ["any"]

  bastion_host     = "${element(module.bastion.bastion_ip,0)}"
  bastion_user     = "${module.bastion.bastion_user}"
  bastion_role_tag = "${module.bastion.bastion_role_tag}"
}
```

## Examples
- [basic-with-provisioning](examples/basic-with-provisioning) - Deploys a Redash server. Redash server 
will be _provisioned_ by Terraform.
  - _Note: This method with Terraform provisioning is only recommended for prototyping and light testing._

## Resources created

- [`triton_machine.redash`](https://www.terraform.io/docs/providers/triton/r/triton_machine.html): The Redash machine. 
- [`triton_firewall_rule.ssh`](https://www.terraform.io/docs/providers/triton/r/triton_firewall_rule.html): The firewall
rule(s) allowing SSH access FROM the bastion machine(s) TO the Redash machine.
- [`triton_firewall_rule.client_access`](https://www.terraform.io/docs/providers/triton/r/triton_firewall_rule.html): The 
firewall rule(s) allowing access FROM client machines or addresses TO Redash web ports.
- [`triton_firewall_rule.redash_to_presto_coordinator`](https://www.terraform.io/docs/providers/triton/r/triton_firewall_rule.html): The 
firewall rule(s) allowing access FROM the Redash machine TO Presto coordinator web ports.
