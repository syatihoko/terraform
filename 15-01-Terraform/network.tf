  // ################## Публичная сеть. #####################
  //Создать в vpc subnet с названием public, сетью 172.31.32.0/19 и Internet gateway.
  //Добавить RouteTable, направляющий весь исходящий трафик в Internet gateway.
  //Создать в этой публичной сети виртуалку с публичным IP и подключиться к ней, убедиться что есть доступ к интернету.

  ########## PUBLIC SUBNET ##########
  //https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
  resource "aws_subnet" "public_subnet" {
    vpc_id     = module.vpc.vpc_id
    cidr_block = "172.31.32.0/19"

  tags = {
    Name = "public_subnet"
  }
}
  ########## PUBLIC GATEWAY##########
  //https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway

  resource "aws_internet_gateway" "public_gw" {
    vpc_id = module.vpc.vpc_id

  tags = {
    Name = "public_gw"
  }
}

  ########## PUBLIC ROUTE TABLE##########
  //https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
  resource "aws_route_table" "public_route" {
    vpc_id = module.vpc.vpc_id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.public_gw.id
      }
    tags = {
      Name = "public route"
    }

  }

########## PUBLIC ROUTE TABLE ASSOCIATION ##########
//https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
//Предоставляет ресурс для создания связи между таблицей маршрутов и подсетью или таблицей маршрутов и интернет-шлюзом или виртуальным частным шлюзом.
resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route.id
//  tags = {
//    Name = "public_route_assoc"
//    }
}


// #################### Приватная сеть. #######################
//Создать в vpc subnet с названием private, сетью 172.31.96.0/19.
//Добавить NAT gateway в public subnet.
//Добавить Route, направляющий весь исходящий трафик private сети в NAT.
//  private_subnets = ["172.31.96.0/19"]

########## PRIVATE SUBNET ##########
  resource "aws_subnet" "private_subnet" {
    vpc_id     = module.vpc.vpc_id
    cidr_block = "172.31.96.0/19"

    tags = {
      Name = "private subnet"
    }
}


########## PRIVATE NAT GATEWAY ##########
//https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway
  resource "aws_nat_gateway" "private_nat" {
    connectivity_type = "private"
    subnet_id         = aws_subnet.private_subnet.id

    tags = {
      Name = "NAT gw private"
    }
}


########## PRIVATE ROUTE TABLE ##########
//https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
//https://github.com/FairwindsOps/terraform-vpc/blob/master/route-table.tf
    resource "aws_route_table" "private_route" {
      vpc_id = module.vpc.vpc_id
      route {
          cidr_block = "0.0.0.0/0"
          nat_gateway_id = aws_nat_gateway.private_nat.id
        }
      tags = {
        Name = "private route NAT"
      }
  }

########## PRIVATE ROUTE TABLE ASSOCIATION ##########
//https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
//Предоставляет ресурс для создания связи между таблицей маршрутов и подсетью или таблицей маршрутов и интернет-шлюзом или виртуальным частным шлюзом.
resource "aws_route_table_association" "private_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route.id
}



// #################### VPN.  ######################################
//Настроить VPN, соединить его с сетью private.
//Создать себе учетную запись и подключиться через нее.
//Создать виртуалку в приватной сети.
//Подключиться к ней по SSH по приватному IP и убедиться, что с виртуалки есть выход в интернет.

//  enable_vpn_gateway = true

  //https://docs.aws.amazon.com/vpn/latest/clientvpn-admin/cvpn-getting-started.html
  //https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpn_gateway
  //https://rtfm.co.ua/openvpn-nastrojka-openvpn-access-server-i-aws-vpc-peering/
  // Требования: VPC как минимум с одной подсетью и интернет-шлюзом. Таблица маршрутов, связанная с вашей подсетью, должна иметь маршрут к интернет-шлюзу.



