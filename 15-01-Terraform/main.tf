//Блок провайдеров
//registry.terraform.io/providers/hashicorp/aws/latest/docs
provider "aws" {
  region = "eu-west-3"
}




// Блок внешних данных  data "aws_caller_identity" "current" {}
// Для того что бы прочитать данные из внешнего API и использовать для создания других рессурсов.
// registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity
// ищем самый новый образ ubuntu
/* data "aws_ami" "aws_ubuntu" {

  most_recent = true

  owners = [
    "amazon"]

  filter {
    name = "name"
    values = [
      "*ubuntu*"]
  }
}
* /
//https://linux-notes.org/rabota-s-aws-ec2-i-terraform-v-unix-linux/
//https://linux-notes.org/rabota-s-aws-vpc-i-terraform-v-unix-linux/