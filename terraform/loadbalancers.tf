# Create a new load balancer
resource "aws_elb" "console" {
  name            = "${var.cluster_id}-console-lb"
  subnets         = ["${var.private_subnets}"]
  internal        = true
  security_groups = ["${aws_security_group.openshift-internal-access.id}", "${aws_security_group.openshift-external-access.id}"]

  listener {
    instance_port     = 8443
    instance_protocol = "tcp"
    lb_port           = 443
    lb_protocol       = "tcp"
  }

  instances = ["${aws_instance.master.*.id}"]

  tags {
    Name             = "openshift-console"
    Domain           = "${var.domain}"
    Role             = "Openshift"
    OpenshiftRole    = "ConsoleLB"
    OpenshiftCluster = "${var.cluster_id}"
  }
}

resource "aws_route53_record" "console-elb" {
  zone_id  = "${var.route53_zone_id}"
  name     = "openshift.${var.domain}"
  type     = "CNAME"
  ttl      = "300"
  records  = ["${aws_elb.console.dns_name}"]
  provider = "aws.dns"
}

resource "aws_elb" "router" {
  name            = "${var.cluster_id}-router-lb"
  subnets         = ["${var.private_subnets}"]
  internal        = true
  security_groups = ["${aws_security_group.openshift-internal-access.id}", "${aws_security_group.openshift-external-access.id}"]

  listener {
    instance_port     = 443
    instance_protocol = "tcp"
    lb_port           = 443
    lb_protocol       = "tcp"
  }

  instances = ["${aws_instance.master.*.id}", "${aws_instance.node.*.id}"]

  tags {
    Name             = "openshift-router"
    Domain           = "${var.domain}"
    Role             = "Openshift"
    OpenshiftRole    = "RouterLB"
    OpenshiftCluster = "${var.cluster_id}"
  }
}

resource "aws_route53_record" "router-elb" {
  zone_id  = "${var.route53_zone_id}"
  name     = "*.openshift.${var.domain}"
  type     = "CNAME"
  ttl      = "300"
  records  = ["${aws_elb.router.dns_name}"]
  provider = "aws.dns"
}
