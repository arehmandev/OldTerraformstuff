resource "aws_elb_attachment" "kubemaster1" {
  elb      = "${var.elb_kubemaster_id}"
  instance = "${var.kubemaster1_ip}"
}

resource "aws_elb_attachment" "kubemaster2" {
  elb      = "${var.elb_kubemaster_id}"
  instance = "${var.kubemaster2_ip}"
}

resource "aws_elb_attachment" "kubemaster3" {
  elb      = "${var.elb_kubemaster_id}"
  instance = "${var.kubemaster3_ip}"
}
