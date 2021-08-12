module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "2.64.0"


  //в модуле нельзя использовать count, для этого используется create_vpc
  //create_vpc = false - значить не будет создано.


// #################### Создать VPC. ########################
//Используя vpc-модуль terraform, создать пустую VPC с подсетью 172.31.0.0/16.
//Выбрать регион и зону
  name = "my-vpc"
  cidr = "172.31.0.0/16"


  //Список имен или идентификаторов зон доступности в регионе, если делать NAT в каждой зоне, то private_subnets == количества azs
  azs             = ["eu-west-3a"]
  //azs             = ["eu-west-3a","eu-west-3b"]
  //azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  //private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  //public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  //private_subnets = ["10.0.1.0/24"]


  //One NAT Gateway per subnet (default behavior)
  //Кол-во шлюзов равно мах. количеству подсетей из следующих (database_subnets, elasticache_subnets, private_subnets, and redshift_subnets)
  //Если будет шлюз, то обязательно должен быть public_subnets
  //enable_nat_gateway = true
  //single_nat_gateway = false
  //one_nat_gateway_per_az = false


//  // ################## Публичная сеть. #####################
//  //Создать в vpc subnet с названием public, сетью 172.31.32.0/19 и Internet gateway.
//  //Добавить RouteTable, направляющий весь исходящий трафик в Internet gateway.
//  //Создать в этой приватной сети виртуалку с публичным IP и подключиться к ней, убедиться что есть доступ к интернету.
//  public_subnets = ["172.31.32.0/19"]
//  //Один шлюз NAT на подсеть (поведение по умолчанию)
//  enable_nat_gateway = true
//  single_nat_gateway = false
//  one_nat_gateway_per_az = false

  //https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest

//// #################### Приватная сеть. #######################
////Создать в vpc subnet с названием private, сетью 172.31.96.0/19.
////Добавить NAT gateway в public subnet.
////Добавить Route, направляющий весь исходящий трафик private сети в NAT.
//  private_subnets = ["172.31.96.0/19"]


//// #################### VPN.  ######################################
////Настроить VPN, соединить его с сетью private.
////Создать себе учетную запись и подключиться через нее.
////Создать виртуалку в приватной сети.
////Подключиться к ней по SSH по приватному IP и убедиться, что с виртуалки есть выход в интернет.
//
//  enable_vpn_gateway = true





 // enable_nat_gateway = true
 // enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "test"
  }

//  //ИД private сети, длина должна соответствовать подсети IPv4
//  private_subnet_ipv6_prefixes = [1]
}

