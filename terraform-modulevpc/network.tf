module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "2.64.0"

  //в модуле нельзя использовать count, для этого используется create_vpc
  //create_vpc = false - значить не будет создано.
  //create_vpc = false


  name = "my-vpc"
  cidr = "10.0.0.0/16"

  //One NAT Gateway per subnet (default behavior)
  //Кол-во шлюзов равно мах. количеству подсетей из следующих (database_subnets, elasticache_subnets, private_subnets, and redshift_subnets)
  //Если будет шлюз, то обязательно должен быть public_subnets
  //enable_nat_gateway = true
  //single_nat_gateway = false
  //one_nat_gateway_per_az = false

  private_subnets = ["10.0.1.0/24"]
  //public_subnets  = ["10.0.101.0/24"]

  //Список имен или идентификаторов зон доступности в регионе, если делать NAT в каждой зоне, то private_subnets => количества azs
  azs             = ["eu-west-3a","eu-west-3b"]
  //azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  //private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  //public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  //private_subnets = ["10.0.1.0/24"]



 // enable_nat_gateway = true
 // enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }

  //ИД private сети, длина должна соответствовать подсети IPv4
  private_subnet_ipv6_prefixes = [1]
}