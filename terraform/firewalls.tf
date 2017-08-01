resource "aws_security_group" "openshift-external-access" {
  description = "Openshift UI Access"
  name        = "${var.name} - Openshift UI Access"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    ignore_changes = ["name"]
  }
}

resource "aws_security_group" "openshift-internal-access" {
  description = "Openshift UI Access"
  name        = "${var.name} - Openshift Internal Access"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }
  lifecycle {
    ignore_changes = ["name"]
  }
}
