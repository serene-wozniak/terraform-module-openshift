variable "nodes" {}
variable "name" {}
variable "domain" {}

variable "master_instance_type" {
  default = "m4.large"
}

variable "node_instance_type" {
  default = "m4.large"
}

variable "bootstrapper_instance_type" {
  default = "t2.small"
}

variable "github_ssh_privatekey" {}
variable "ssh_ca_publickey" {}

variable "instance_profile_id" {}
variable "ami" {}

variable "private_subnets" {
  type = "list"
}

variable "vpc_id" {}

variable "cluster_id" {}

variable "this_repo" {
  default = "git@github.com:serene-wozniak/terraform-module-minishift.git"
}

variable "ssh_cluster_publickey" {}
