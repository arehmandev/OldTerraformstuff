// EC2 Instance Resource for Module
resource "aws_key_pair" "auth" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

data "template_file" "kubeetcd" {
  template = "${file("${path.module}/Files/etcd.yml.tpl")}"

  vars {
    etcdurl = "helloworld"
  }
}

resource "aws_instance" "ec2_instance" {
  ami           = "${var.ami_id}"
  count         = "${var.number_of_instances}"
  instance_type = "${var.instance_type}"
  user_data     = "${data.template_file.kubeetcd.rendered}"
  key_name      = "${var.key_name}"

  tags {
    created_by = "${lookup(var.tags,"created_by")}"

    // Takes the instance_name input variable and adds
    //  the count.index to the name., e.g.
    //  "example-host-web-1"
    Name = "${var.instance_name}-${count.index}"
  }
}
