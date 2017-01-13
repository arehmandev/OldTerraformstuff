output "kubenode_cert_pem" {
  value = "${tls_locally_signed_cert.kubenode.cert_pem}"
}

output "kubenode_private_key" {
  value = "${tls_private_key.kubenode.private_key_pem}"
}
