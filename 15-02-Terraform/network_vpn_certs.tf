//// #################### Certs. #######################

  
resource "aws_acm_certificate" "vpn_server_cert" {
  private_key = file("certs/server.key")
  certificate_body = file("certs/server.crt")
  certificate_chain = file("certs/ca.crt")
}

resource "aws_acm_certificate" "vpn_client_cert" {
  private_key = file("certs/client1.domain.tld.key")
  certificate_body = file("certs/client1.domain.tld.crt")
  certificate_chain = file("certs/ca.crt")
}