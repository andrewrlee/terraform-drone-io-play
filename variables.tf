# AWS Access Key
variable "access_key" {}
# AWS Secret
variable "secret_key" {}
# AWS region
variable "region" {
  default = "us-east-1"
}

# Location of private key to connect (to allow ssh to created instances)
variable "private_key" {}

# The client id for the application created in github
variable "github_client" {}
# The secret for the application created in github
variable "github_secret" {}
# The drone servers admin user
variable "drone_admin_user" {}
# The drone secret for allowing nodes to connect to server
variable "drone_secret" {}

