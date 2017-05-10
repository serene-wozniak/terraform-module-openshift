resource "aws_instance" "master" {
  ami                    = "${var.ami}"
  instance_type          = "${var.master_instance_type}"
  subnet_id              = "${var.private_subnets[0]}"
  vpc_security_group_ids = ["${aws_security_group.openshift-internal-access.id}", "${aws_security_group.openshift-external-access.id}"]

  tags {
    Name             = "openshift-master"
    Domain           = "${var.domain}"
    Role             = "Openshift"
    OpenshiftRole    = "Master"
    OpenshiftCluster = "${var.cluster_id}"
  }

  root_block_device = {
    volume_size = "120"
  }

  iam_instance_profile = "${var.instance_profile_id}"
  user_data            = "${module.master_bootstrap.cloud_init_config}"
}

module "master_bootstrap" {
  source              = "git@github.com:serene-wozniak/terraform-module-bootstrap.git//ansible_bootstrap?ref=master"
  ansible_source_repo = "${var.this_repo}"
  ansible_role        = "master"

  ansible_facts = {
    cluster_ssh_token = "${var.ssh_cluster_publickey}"
  }

  ssh_ca_publickey      = "${var.ssh_ca_publickey}"
  github_ssh_privatekey = "${var.github_ssh_privatekey}"
}
