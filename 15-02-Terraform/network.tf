  // ################## Публичная сеть. #####################
  //Создать в vpc subnet с названием public, сетью 172.31.32.0/19 и Internet gateway.
  //Добавить RouteTable, направляющий весь исходящий трафик в Internet gateway.
  //Создать в этой публичной сети виртуалку с публичным IP и подключиться к ней, убедиться что есть доступ к интернету.

  ########## PUBLIC SUBNET ##########
  //https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
  resource "aws_subnet" "public" {
    vpc_id     = module.vpc.vpc_id
    cidr_block = "172.31.32.0/19"
    availability_zone =  "eu-west-3a"

  tags = {
    Name = "public_subnet"
  }
}

  resource "aws_subnet" "public2" {
    vpc_id     = module.vpc.vpc_id
    cidr_block = "172.31.0.0/19"
    availability_zone =  "eu-west-3b"

  tags = {
    Name = "public_subnet2"
  }
}

  resource "aws_subnet" "public3" {
    vpc_id     = module.vpc.vpc_id
    cidr_block = "172.31.64.0/19"
    availability_zone =  "eu-west-3c"

  tags = {
    Name = "public_subnet3"
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
resource "aws_route_table_association" "public_association1" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_route.id
//  tags = {
//    Name = "public_route_assoc"
//    }
}

resource "aws_route_table_association" "public_association2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public_route.id
//  tags = {
//    Name = "public_route_assoc"
//    }
}

resource "aws_route_table_association" "public_association3" {
  subnet_id      = aws_subnet.public3.id
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
  resource "aws_subnet" "private" {
    vpc_id     = module.vpc.vpc_id
    cidr_block = "172.31.96.0/19"

    tags = {
      Name = "private subnet"
    }
}

//Elastic IP addresses (необязательно)
//https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip
  resource "aws_eip" "ip_for_nat" {
  vpc      = true
}

########## PRIVATE NAT GATEWAY ##########
//https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway
  resource "aws_nat_gateway" "private_nat_gateway" {
    //connectivity_type = "private"
    //Allocation ID эластичного IP-адреса для шлюза. Required for connectivity_type of public.
    allocation_id = aws_eip.ip_for_nat.id
    //Subnet ID в подсети, в которой следует разместить шлюз.
    //subnet_id         = aws_subnet.private.id
    // ID подсети подсети, в которой нужно разместить шлюз.
    subnet_id         = aws_subnet.public.id  //?????????

    tags = {
      Name = "NAT gw private"
    }
    #Зависимость от Шлюза публичной сети
      depends_on = [aws_internet_gateway.public_gw]
}


########## PRIVATE ROUTE TABLE ##########
//https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
//https://github.com/FairwindsOps/terraform-vpc/blob/master/route-table.tf
    resource "aws_route_table" "private_route" {
      vpc_id = module.vpc.vpc_id
      route {
          cidr_block = "0.0.0.0/0"
          nat_gateway_id = aws_nat_gateway.private_nat_gateway.id
        }
      tags = {
        Name = "private route NAT"
      }
  }

########## PRIVATE ROUTE TABLE ASSOCIATION ##########
//https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
//Предоставляет ресурс для создания связи между таблицей маршрутов и подсетью или таблицей маршрутов и интернет-шлюзом или виртуальным частным шлюзом.
resource "aws_route_table_association" "private_association" {
  subnet_id      = aws_subnet.private.id
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



