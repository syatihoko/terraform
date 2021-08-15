//// #################### VPN. #######################

// Client VPN endpoint  - это сеть, которую вы связываете с конечной точкой Client VPN
// Подсеть из VPC - это целевая сеть. Связывание подсети с конечной точкой VPN клиента позволяет устанавливать сеансы VPN.
//Вы можете связать несколько подсетей с конечной точкой VPN клиента для обеспечения высокой доступности. Все подсети должны быть из одного VPC. Каждая подсеть должна принадлежать разной зоне доступности.
// Target network -  Каждая конечная точка VPN клиента имеет таблицу маршрутов, в которой описаны доступные сетевые маршруты назначения. Каждый маршрут в таблице маршрутов указывает путь для трафика к определенным ресурсам или сетям.
// Client CIDR range - Диапазон IP-адресов, из которого можно назначить IP-адреса клиентов. Каждому подключению к конечной точке VPN клиента назначается уникальный IP-адрес из диапазона CIDR клиента. Вы выбираете диапазон CIDR клиента, например 10.2.0.0/16.
// Client VPN ports -  AWS Client VPN поддерживает порты 443 и 1194 как для TCP, так и для UDP. По умолчанию это порт 443.

// https://docs.aws.amazon.com/vpn/latest/clientvpn-admin/cvpn-getting-started.html
//Step 1: Generate server and client certificates and keys
// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_client_vpn_route


//// #################### VPN. #######################
resource "aws_ec2_client_vpn_endpoint" "kaa_vpn_endpoint" {
  description            = "terraform-clientvpn-endpoint"
  //сертификат Сервера: "CertificateArn": "arn:aws:acm:eu-west-3:250629965860:certificate/1b6ef1fd-0cb7-4ce1-91e4-55240336abd4"
  server_certificate_arn = "arn:aws:acm:eu-west-3:250629965860:certificate/1b6ef1fd-0cb7-4ce1-91e4-55240336abd4"
  client_cidr_block      = "10.0.0.0/16"

  // сертификат Клиента:  "CertificateArn": "arn:aws:acm:eu-west-3:250629965860:certificate/3ec7ccb9-e31b-4525-ad16-23051cd75591"
  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = "arn:aws:acm:eu-west-3:250629965860:certificate/3ec7ccb9-e31b-4525-ad16-23051cd75591"
  }

  connection_log_options {
    enabled               = false
  }
}

resource "aws_ec2_client_vpn_network_association" "vpn_to_private_association" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.kaa_vpn_endpoint.id
  subnet_id              = aws_subnet.private.id
}

resource "aws_ec2_client_vpn_authorization_rule" "default_vpn_authorization_rule" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.kaa_vpn_endpoint.id
  target_network_cidr    = aws_subnet.private.cidr_block
  authorize_all_groups   = true
}