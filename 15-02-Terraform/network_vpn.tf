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
  //Загружал сертификаты руками, получаею их Arn, потом через terraform
  //сертификат Сервера: "CertificateArn": "arn:aws:acm:eu-west-3:835931830893:certificate/c4204212-27ff-48e0-ae0f-5b80c6a3c07a" Из Certificate Manager
  //server_certificate_arn = "arn:aws:acm:eu-west-3:835931830893:certificate/c4204212-27ff-48e0-ae0f-5b80c6a3c07a"
  server_certificate_arn = aws_acm_certificate.vpn_server_cert.arn
  client_cidr_block      = "10.0.0.0/16"

  // сертификат Клиента:  "CertificateArn": "	arn:aws:acm:eu-west-3:835931830893:certificate/14b3c188-81a9-4d74-882b-cf0e5eb97fad" из Certificate Manager
  authentication_options {
    type                       = "certificate-authentication"
    //root_certificate_chain_arn = "arn:aws:acm:eu-west-3:835931830893:certificate/14b3c188-81a9-4d74-882b-cf0e5eb97fad"
    root_certificate_chain_arn = aws_acm_certificate.vpn_client_cert.arn
  }

  connection_log_options {
    enabled               = false
  }
}

# //https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "from_vpn_access" {
  //vpc_id = aws_vpc.my-vpc.id  //так как создал через модуль VPC
  vpc_id = module.vpc.vpc_id
  name = "vpn-secgroup"

  //Разрешаем весь входящий
  ingress {
    from_port = 0
    //from_port = 443
    //protocol = "UDP"
    protocol = "-1"
    //to_port = 443
    to_port = 0
    //cidr_blocks = ["0.0.0.0/0"]
    cidr_blocks = [module.vpc.vpc_cidr_block]  //назначение подсеть VPC
    description = "Incoming VPN connection"
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
    description = "Outcoming VPN connection"
  }
}



//Сопоставляем конечную точку VPN и сеть
resource "aws_ec2_client_vpn_network_association" "vpn_to_private_association" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.kaa_vpn_endpoint.id
  subnet_id              = aws_subnet.private.id
  //Если создали, то назначаем security_groups
  //security_groups = [aws_security_group.from_vpn_access.id]
}

resource "aws_ec2_client_vpn_authorization_rule" "default_vpn_authorization_rule" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.kaa_vpn_endpoint.id
  target_network_cidr    = aws_subnet.private.cidr_block
  authorize_all_groups   = true
}

#Подключение к машине в приватной сети
#ssh -i "151_new.pem" ec2-user@172-31-125-60
#ssh -i "151_new.pem" ec2-user@172.31.55.37