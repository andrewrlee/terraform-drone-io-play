
variable "private_key" {}
variable "github_client" {}
variable "github_secret" {}
variable "drone_admin_user" {}
variable "drone_secret" {} 
variable "security_group" {} 

resource "aws_instance" "drone-server" {
  ami           = "ami-656be372"
  instance_type = "t1.micro"
  security_groups = ["${var.security_group}"]
  key_name = "optimisticpanda" 

  provisioner "file" {
     source = "${path.module}/run-drone-server.sh"
     destination = "/tmp/run-drone-server.sh"
     connection {
        type = "ssh"
        user = "ubuntu"
        private_key = "${file("${var.private_key}")}"
     }
  }

  provisioner "remote-exec" {
    inline = [
      "curl -sSL https://get.docker.com/ | sudo sh",
      "sudo mkdir -p /etc/drone",
      "sudo cp /tmp/run-drone-server.sh /etc/drone/run-drone-server.sh",
      "sudo chmod +x /etc/drone/run-drone-server.sh",
      "sudo /etc/drone/run-drone-server.sh ${var.github_client} ${var.github_secret} ${var.drone_admin_user} ${var.drone_secret}"
    ]
    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = "${file("${var.private_key}")}"
    }
  }
}

output drone_server_address {
  value = "${aws_instance.drone-server.public_dns}"
}
