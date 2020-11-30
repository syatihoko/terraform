provider "aws" {
  region = "eu-west-3"
}

//ищем самый новый образ ubuntu
data "aws_ami" "aws_ubuntu" {

  most_recent = true

  owners = [
    "amazon"]

  filter {
    name = "name"
    values = [
      "*ubuntu*"]
  }
}

//https://linux-notes.org/rabota-s-aws-ec2-i-terraform-v-unix-linux/
//https://linux-notes.org/rabota-s-aws-vpc-i-terraform-v-unix-linux/