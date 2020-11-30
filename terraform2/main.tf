terraform {
  backend "s3" {
    bucket = "kaa-terraform-states"
    key = "terraform2"
    region = "eu-west-3"
  }
}

provider "aws" {
  region = "eu-west-3"
}

//дата будет ссылаться на другой проект terraform3
data "terraform_remoute_state" "terraform2" {
  baskend = "s3"

  config = {
    bucket = "mybucked"
    key = "terraform2"
    region = "eu-west-3"
  }

}