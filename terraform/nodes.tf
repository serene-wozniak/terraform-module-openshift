resource "aws_instance" "node" {
  ami                    = "${var.ami}"
  instance_type          = "${var.node_instance_type}"
  subnet_id              = "${var.private_subnets[0]}"
  vpc_security_group_ids = ["${aws_security_group.openshift-internal-access.id}", "${aws_security_group.openshift-external-access.id}"]
  count                  = "${var.nodes}"

  tags {
    Name             = "openshift-node${format("%02d", count.index + 1)}"
    Domain           = "${var.domain}"
    Role             = "Openshift"
    OpenshiftRole    = "Node"
    OpenshiftCluster = "${var.cluster_id}"
  }

  root_block_device = {
    volume_size = "120"
  }

  iam_instance_profile = "${var.instance_profile_id}"
  user_data            = "${module.node_bootstrap.cloud_init_config}"
}

resource "aws_route53_record" "nodes" {
  zone_id  = "${var.route53_zone_id}"
  name     = "openshift-node${format("%02d", count.index + 1)}.${var.domain}"
  type     = "A"
  ttl      = "300"
  records  = ["${element(aws_instance.node.*.private_ip, count.index)}"]
  provider = "aws.dns"
  count    = "${var.nodes}"
}

module "node_bootstrap" {
  source              = "git@github.com:serene-wozniak/terraform-module-bootstrap.git//ansible_bootstrap?ref=post_provision"
  ansible_source_repo = "${var.this_repo}"
  ansible_role        = "node"

  ansible_facts = {
    cluster_ssh_token = "${var.ssh_cluster_publickey}"
  }

  ssh_ca_publickey      = "${var.ssh_ca_publickey}"
  github_ssh_privatekey = "${var.github_ssh_privatekey}"
}
