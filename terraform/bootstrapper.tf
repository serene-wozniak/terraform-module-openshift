resource "aws_instance" "bootstrapper" {
  ami                    = "${var.ami}"
  instance_type          = "${var.bootstrapper_instance_type}"
  subnet_id              = "${var.private_subnets[0]}"
  vpc_security_group_ids = ["${aws_security_group.openshift-internal-access.id}", "${aws_security_group.openshift-external-access.id}"]

  tags {
    Name             = "openshift-bootstrapper"
    Domain           = "${var.domain}"
    Role             = "Openshift"
    OpenshiftRole    = "Bootstrapper"
    OpenshiftCluster = "${var.cluster_id}"
  }

  root_block_device = {
    volume_size = "32"
  }

  iam_instance_profile = "${var.instance_profile_id}"
  user_data            = "${module.bootstrapper_bootstrap.cloud_init_config}"
}

resource "aws_route53_record" "bootstrapper" {
  zone_id  = "${var.route53_zone_id}"
  name     = "openshift-bootstrapper.${var.domain}"
  type     = "A"
  ttl      = "300"
  records  = ["${aws_instance.bootstrapper.private_ip}"]
  provider = "aws.dns"
}

module "bootstrapper_bootstrap" {
  source              = "git@github.com:serene-wozniak/terraform-module-bootstrap.git//ansible_bootstrap?ref=post_provision"
  ansible_source_repo = "${var.this_repo}"
  ansible_role        = "bootstrapper"

  ansible_facts = {
    cluster_id    = "${var.cluster_id}"
    openshift_tag = "${var.openshift_tag}"
  }

  ssh_ca_publickey      = "${var.ssh_ca_publickey}"
  github_ssh_privatekey = "${var.github_ssh_privatekey}"
}
