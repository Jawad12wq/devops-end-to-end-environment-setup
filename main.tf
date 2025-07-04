resource "null_resource" "vagrant_up" {
  provisioner "local-exec" {
    command = "vagrant up"
  }
}