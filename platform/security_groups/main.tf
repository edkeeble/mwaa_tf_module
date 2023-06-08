# ---------------------------------------------------------------------------------------------------------------------
# MWAA Security Group
# ---------------------------------------------------------------------------------------------------------------------



resource "aws_security_group" "mwaa" {
  name_prefix = "${var.prefix}-mwaa-sg"
  description = "Security group for MWAA environment"
  vpc_id      = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    var.tags,
    {
      Notes = "${var.prefix}-mwaa-sg"
    }
  )
}

resource "aws_security_group_rule" "mwaa_sg_inbound" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "all"
  source_security_group_id = aws_security_group.mwaa.id
  security_group_id        = aws_security_group.mwaa.id
  description              = "Amazon MWAA inbound access"
}



resource "aws_security_group_rule" "mwaa_sg_inbound_vpn" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = var.source_cidr
  security_group_id = aws_security_group.mwaa.id
  description       = "VPN Access for Airflow UI"
}

#tfsec:ignore:aws-vpc-no-public-egress-sgr
resource "aws_security_group_rule" "mwaa_sg_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.mwaa.id
  description       = "Amazon MWAA outbound access"
}