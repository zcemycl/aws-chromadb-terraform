resource "aws_acm_certificate" "server_vpn_cert" {
  certificate_body  = file(var.server_crt_path)
  private_key       = file(var.server_key_path)
  certificate_chain = file(var.ca_cert_path)
}

resource "aws_acm_certificate" "client_vpn_cert" {
  certificate_body  = file(var.client_crt_path)
  private_key       = file(var.client_key_path)
  certificate_chain = file(var.ca_cert_path)
}
