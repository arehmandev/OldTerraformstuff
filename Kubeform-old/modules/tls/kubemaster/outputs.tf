output "private_key" {
  value = "${tls_private_key.master.private_key_pem}"
}

output "cert_pem" {
  value = "${tls_locally_signed_cert.master.cert_pem}"
}
