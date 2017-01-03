
provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_security_group" "default" {
  name        = "drone_example"
  description = "Used in the terraform"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module drone-server {
  source = "./drone-server"
  private_key = "${var.private_key}"
  github_client = "${var.github_client}"
  github_secret = "${var.github_secret}"
  drone_admin_user = "${var.drone_admin_user}"
  drone_secret = "${var.drone_secret}"
  security_group = "${aws_security_group.default.name}"
}

module drone-client {
  source = "./drone-client" 
  private_key = "${var.private_key}"
  drone_server = "ws://${module.drone-server.drone_server_address}/ws/broker"
  drone_secret = "${var.drone_secret}"
  security_group = "${aws_security_group.default.name}"
}
