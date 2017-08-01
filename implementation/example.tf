resource "random_pet" "cluster_id" {}

variable "git_private_key_b64" {}
variable "ssh_user_ca_publickey" {}
variable "ssh_cluster_publickey" {}
variable "github_access_token" {}

data "aws_caller_identity" "current" {}

data "terraform_remote_state" "network" {
  backend = "s3"

  config {
    bucket = "${data.aws_caller_identity.current.account_id}-terraform-state"
    key    = "network/terraform.tfstate"
    region = "eu-west-1"
  }
}

terraform {
  backend "s3" {
    bucket = "841990667482-terraform-state"
    key    = "openshift"
    region = "eu-west-1"
  }
}

module "openshift_cluster" {
  source = "../terraform"

  name                  = "${terraform.env}"
  domain                = "${terraform.env}.aws.int.giffgaff.co.uk"
  nodes                 = 4
  ami                   = "ami-7abd0209"
  vpc_id                = "${data.terraform_remote_state.network.vpc_id}"
  github_ssh_privatekey = "${base64decode(var.git_private_key_b64)}"
  ssh_ca_publickey      = "${var.ssh_user_ca_publickey}"
  private_subnets       = ["${data.terraform_remote_state.network.private_1_subnet_a}"]
  cluster_id            = "${random_pet.cluster_id.id}"
  instance_profile_id   = "oc-jenkins"
  ssh_cluster_publickey = "${var.ssh_cluster_publickey}"
  openshift_tag         = "release-1.5"
  route53_zone_id       = "Z2YGY2YY43KYJW"
  node_instance_type    = "m4.xlarge"
}

provider "aws" {
  region = "eu-west-1"
}

provider "aws" {
  alias = "dns"

  assume_role = {
    role_arn = "arn:aws:iam::604083106117:role/DNSMgr"
  }

  region = "eu-west-1"
}
