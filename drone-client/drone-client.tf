
variable "private_key" {}
variable "drone_server" {} 
variable "drone_secret" {} 
variable "security_group" {} 

resource "aws_instance" "drone-client" {
  ami           = "ami-656be372"
  instance_type = "t1.micro"
  security_groups = ["${var.security_group}"]
  key_name = "optimisticpanda" 

  provisioner "file" {
     source = "${path.module}/run-drone-client.sh"
     destination = "/tmp/run-drone-client.sh"
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
      "sudo cp /tmp/run-drone-client.sh /etc/drone/run-drone-client.sh",
      "sudo chmod +x /etc/drone/run-drone-client.sh",
      "sudo /etc/drone/run-drone-client.sh \"${var.drone_server}\" \"${var.drone_secret}\""
    ]
    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = "${file("${var.private_key}")}"
    }
  }
}

output drone_client_address {
  value = "aws_instance.drone-client.public_dns"
}
