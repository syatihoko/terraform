//Задание 2. Создать запись в Route53 домен с возможностью определения из VPN.
// - Сделать запись в Route53 на приватный домен, указав адрес LB.

//https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone
//Manages a Route53 Hosted Zone.
//Для Private зоне нужно указать VPC
resource "aws_route53_zone" "dns_to_bucket" {
  name = "dns-to-bucket.local"

  vpc {
    //vpc_id = aws_vpc.my-vpc.id
    vpc_id = module.vpc.vpc_id
  }
}

//Создаем псевданим DNS
resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.dns_to_bucket.zone_id
  name    = "www.dns-to-bucket.local"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_elb.kaa-elb.dns_name]
}

//file_aws_bucket_object = kaa_foto.jpg
output "kaa-elb_dns_name"  {
  value = aws_elb.kaa-elb.dns_name
}   


