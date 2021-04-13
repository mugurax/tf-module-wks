locals {
  instance_count = var.instance_enabled ? 1 : 0
}

# hardcoded user data is not a problem ftm
data "template_file" "user_data" {
  template = "${file("${path.module}/user-data.conf")}"
  vars     = {}
}

resource "aws_instance" "wks" {
  count         = local.instance_count
  ami           = var.ami
  instance_type = var.instance_type

  tags = {
    Name = "wks"
  }

  volume_tags = {
    Name = "wks"
  }

  key_name               = var.key_name
  vpc_security_group_ids = ["${module.sg_wks.this_security_group_id}"]
  root_block_device {
    volume_size           = 100
    delete_on_termination = "true"
  }
  ebs_optimized           = true
  disable_api_termination = true
  user_data               = data.template_file.user_data.rendered
  iam_instance_profile    = "workstation"
}

data "aws_vpc" "default" {
  filter {
    name   = "isDefault"
    values = ["true"]
  }
}

module "sg_wks" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "v3.4.0"

  create          = var.instance_enabled
  vpc_id          = data.aws_vpc.default.id
  name            = "wks"
  use_name_prefix = false
  description     = "workstation security group"

  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "ssh"
      cidr_blocks = "46.93.0.0/16,79.255.0.0/16,91.199.104.0/24"
    }
  ]

  egress_rules = ["all-all"]
}

resource "aws_eip" "wks" {
  count = local.instance_count
  vpc   = true

  tags = {
    Name = "wks"
  }
}

resource "aws_eip_association" "eip_assoc" {
  count         = local.instance_count
  instance_id   = aws_instance.wks[count.index].id
  allocation_id = aws_eip.wks[count.index].id
}
