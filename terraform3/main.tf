terraform {
  backend "s3" {
    bucket = "kaa-terraform-states"
    key = "terraform3"
    region = "eu-west-3"
  }
}

provider "aws" {
  region = "eu-west-3"
}

//дата будет ссылаться на другой проект terraform2
data "terraform_remoute_state" "terraform2" {
  baskend = "s3"

  config = {
    bucket = "mybucked"
    key = "terraform2"
    region = "eu-west-3"
  }

}

//https://www.terraform.io/docs/providers/terraform/d/remote_state.html
resource "aws_launch_template" "example" {
  name_prefix = "example"
  image_id = "data.aws_ami.example.id"
  //instance_type = "t2.micro"
  //Берем тип из ремоут state другого проекта
  instance_type = data.terraform_remoute_state.terraform2.outputs.ec2_web_instance_type

}