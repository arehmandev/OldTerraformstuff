provider "aws" {
  region  = "${var.adminregion}"
  profile = "${var.adminprofile}"
}

module "ec2_instance" {
  source              = "./EC2"
  instance_type       = "${var.coresize}"
  instance_name       = "CoreOS-Test"
  ami_id              = "${data.aws_ami.coreos.image_id}"
  number_of_instances = "${var.asg_number_of_instances}"
  key_name            = "${var.key_name}"
}

data "aws_ami" "coreos" {
  most_recent = true

  owners = ["679593333241"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["${var.virtualization_type}"]
  }

  filter {
    name   = "name"
    values = ["CoreOS-${var.channel}-*"]
  }
}
