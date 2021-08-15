//Блок провайдеров
//registry.terraform.io/providers/hashicorp/aws/latest/docs
provider "aws" {
  region = "eu-west-3"
}




// Блок внешних данных  data "aws_caller_identity" "current" {}
// Для того что бы прочитать данные из внешнего API и использовать для создания других рессурсов.
// registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity
// ищем самый новый образ ubuntu
//D:\Programs\Terraform\bin\terraform init
//data "aws_ami" "aws_ubuntu" {
//
//  most_recent = true
//
//  owners = [
//    "amazon"]
//
//  filter {
//    name = "name"
//    values = [
//      "*ubuntu*"]
//  }
//}
//https://linux-notes.org/rabota-s-aws-ec2-i-terraform-v-unix-linux/
//https://linux-notes.org/rabota-s-aws-vpc-i-terraform-v-unix-linux/


//resource "aws_instance" "ubuntu_new" {
//
//  // Для каждлого значения в local.ubuntu_instance_names_map
//  //for_each = local.ubuntu_instance_names_map
//  count = local.ubuntu_instance_workspace_count_map[terraform.workspace]
//
//  provider = aws
//  ami = data.aws_ami.aws_ubuntu.id
//  //instance_type = "t2.micro"
//  //Значение типа от текущего workspace
//  instance_type = local.ubuntu_instance_workspace_type_map[terraform.workspace]
////  tags = {
////    //Для определение имени берем значение ключа из ubuntu_instance_names_map
////    "Name" = each.key
////    //Для определение имени берем значение value из ubuntu_instance_names_map
////    "GroupName" = each.value
////  }
//}
//
//resource "aws_instance" "kaa-linux" {
//
//  // Для каждлого значения в local.ubuntu_instance_names_map
//  //for_each = local.ubuntu_instance_names_map
//  count = 1
//
//  provider = aws
//  ami = "ami-0d49cec198762b78c"
//  //instance_type = "t2.micro"
//  //Значение типа от текущего workspace
//  instance_type = "t2.micro"
////  tags = {
////    //Для определение имени берем значение ключа из ubuntu_instance_names_map
////    "Name" = each.key
////    //Для определение имени берем значение value из ubuntu_instance_names_map
////    "GroupName" = each.value
////  }
//   network_interface {
//    network_interface_id = aws_network_interface.private_subnet.id
//    device_index         = 0
//  }
//}
//

