resource "null_resource" "redash_install" {
  count = "${var.provision == "true" ? "1" : 0}"

  triggers {
    machine_ids = "${triton_machine.redash.*.id[count.index]}"
  }

  connection {
    bastion_host        = "${var.bastion_host}"
    bastion_user        = "${var.bastion_user}"
    bastion_private_key = "${file(var.private_key_path)}"

    host        = "${triton_machine.redash.*.primaryip[count.index]}"
    user        = "${var.user}"
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p /tmp/redash_installer/",
    ]
  }

  provisioner "file" {
    source      = "${path.module}/packer/scripts/install_redash.sh"
    destination = "/tmp/redash_installer/install_redash.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 0755 /tmp/redash_installer/install_redash.sh",
      "sudo /tmp/redash_installer/install_redash.sh",
    ]
  }

  # clean up
  provisioner "remote-exec" {
    inline = [
      "rm -rf /tmp/redash_installer/",
    ]
  }
}
