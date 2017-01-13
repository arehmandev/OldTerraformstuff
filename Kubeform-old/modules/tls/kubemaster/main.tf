# Kubernetes master certs
resource "tls_private_key" "master" {
  algorithm = "RSA"
}

resource "tls_cert_request" "master" {
  key_algorithm   = "RSA"
  private_key_pem = "${tls_private_key.master.private_key_pem}"

  subject {
    common_name = "kube-master"
  }

  #  dns_names    = ["${concat(var.dns_names, var.default_dns_names)}"]

  dns_names = [
    "${var.elb_dnsname}",
    "kubernetes",
    "kubernetes.default",
    "kubernetes.default.svc",
    "kubernetes.default.svc.cluster.local",
  ]
  ip_addresses = ["${var.iplistca}"]
}

resource "tls_locally_signed_cert" "master" {
  cert_request_pem      = "${tls_cert_request.master.cert_request_pem}"
  ca_key_algorithm      = "RSA"
  ca_private_key_pem    = "${var.ca_private_key_pem}"
  ca_cert_pem           = "${var.ca_cert_pem}"
  validity_period_hours = "${var.validity_period_hours}"
  early_renewal_hours   = "${var.early_renewal_hours}"

  allowed_uses = [
    "server_auth",
    "client_auth",
    "digital_signature",
    "key_encipherment",
  ]
}

resource "null_resource" "keypem" {
  depends_on = ["tls_private_key.master"]

  provisioner "local-exec" {
    command = "echo '${tls_private_key.master.private_key_pem}' > ${path.module}/Files/${var.keypem} && chmod 600 ${path.module}/Files/${var.keypem}"
  }
}

resource "null_resource" "capem" {
  depends_on = ["tls_locally_signed_cert.master"]

  provisioner "local-exec" {
    command = "echo '${tls_locally_signed_cert.master.cert_pem}' > ${path.module}/Files/${var.capem} && chmod 600 ${path.module}/Files/${var.capem}"
  }
}
