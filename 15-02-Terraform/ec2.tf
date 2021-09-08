# Задание 3. Загрузить несколько ЕС2-инстансов с веб-страницей, на которой будет картинка из S3.
# - Сделать Launch configurations с использованием bootstrap скрипта с созданием веб-странички на которой будет ссылка на картинку в S3.
# - Загрузить 3 ЕС2-инстанса и настроить LB с помощью Autoscaling Group.


# //ищем самый свежий образ ubuntu //Не запустился, Error: "The t2.micro instance type does not support an AMI with a boot mode of UEFI."
# data "aws_ami" "aws_ubuntu" {

#   most_recent = true

#   owners = [
#     "amazon"]

#   filter {
#     name = "name"
#     values = [
#       "*ubuntu*"]
#   }
# }


//https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_configuration
//Из этого примера взял версию ami
data "aws_ami" "aws_ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


//https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file
//Создаем bootstrap для использования в EC2
data "template_file" "bootstrap" {
  //путь к файлу
  template = "${file("files/bootstrap.tpl")}"
  //Переменные для интерполяции в шаблоне. Обратите внимание, что все переменные должны быть примитивами.
  vars = {
    //consul_address = "${aws_instance.consul.private_ip}"
    //назначенное доменное имя bucket
    url = data.aws_s3_bucket.kaa_b.bucket_domain_name
    //путь к файлу-картинке
    file = data.aws_s3_bucket_object.kaa_foto.key
  }
}



//file_aws_bucket_object = kaa_foto.png
//kaa-elb_dns_name = kaa-elb-1068444968.eu-west-3.elb.amazonaws.com
//url_aws_bucket_name = kaa-20210903.s3.amazonaws.com

//Сделать Launch configurations
//https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_configuration
//Предоставляет ресурс для создания новой конфигурации запуска, используемой для автомасштабирования групп.
resource "aws_launch_configuration" "as_conf" {
  name_prefix   = "kaa-"
  //image_id      = data.aws_ami.aws_ubuntu.id
  image_id      ="ami-072056ff9d3689e7b"  //Amazon Linux
  instance_type = "t2.micro"
  
  //Список связанных IDS группы безопасности.
  security_groups = [aws_security_group.kaa-sec-group.id]

  //Имя ключа ssh для подключения
  key_name = "151_new2"

  //Публичный адрес для диагностики
  associate_public_ip_address = true

  //(необязательно) данные пользователя, которые необходимо предоставить при запуске экземпляра. 
  user_data = data.template_file.bootstrap.rendered

  lifecycle {
    create_before_destroy = true
  }
}

  

//LB с помощью Autoscaling Group
//https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elb
//Предоставляет ресурс Elastic Load Balancer,
resource "aws_elb" "kaa-elb" {
  name = "kaa-elb"
  // Список идентификаторов подсетей для запуска ресурсов. Подсети автоматически определяют, в каких зонах доступности будет находиться группа. Конфликты с availability_zones.
  //subnets = [aws_subnet.public.id]
  subnets = [aws_subnet.public.id, aws_subnet.public2.id, aws_subnet.public3.id]
  //availability_zones = ["eu-west-3a","eu-west-3b","eu-west-3c"]
  //availability_zones = module.vpc.azs   //берем значение из модуля
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  # listener {
  #   instance_port      = 80
  #   instance_protocol  = "http"
  #   lb_port            = 443
  #   lb_protocol        = "https"
  #   ssl_certificate_id = "arn:aws:iam::123456789012:server-certificate/certName"
  # }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 10 
    timeout             = 5
    target              = "HTTP:80/"
    interval            = 30
  }

  //Список идентификаторов групп безопасности для назначения ELB. Действует только при создании ELB в VPC
   security_groups = [aws_security_group.kaa-sec-group.id]

  //(Необязательно) Список идентификаторов экземпляров для размещения в пуле ELB.
  //instances                   = [aws_instance.foo.id]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "kaa-elb"
  }
}

output "classic-balancer-dns_name" {
  value = "${aws_elb.kaa-elb.dns_name}"
}

//https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group
//Предоставляет ресурс группы автоматического масштабирования.
resource "aws_autoscaling_group" "kaa_autoscaling" {
  name                 = "kaa_autoscaling"
  launch_configuration = aws_launch_configuration.as_conf.name //конф. запуска, созданная ранее.
  min_size             = 2
  max_size             = 6

  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 4
  force_delete              = true

  //  Список идентификаторов подсетей для запуска ресурсов. Подсети автоматически определяют, в каких зонах доступности будет находиться группа. Конфликты с availability_zones.
  //vpc_zone_identifier  = [aws_subnet.public.id]
  vpc_zone_identifier = [aws_subnet.public.id, aws_subnet.public2.id, aws_subnet.public3.id]
  //availability_zones = ["eu-west-3a","eu-west-3b","eu-west-3c"]
  //availability_zones = module.vpc.azs   //берем значение из модуля 

  //задаем баллансировщик
  //Terraform в настоящее время предоставляет как автономный ресурс aws_autoscaling_attachment (описывающий ASG, прикрепленный к ELB или ALB), так и aws_autoscaling_group с load_balancers.
  //Список имен эластичных балансировщиков нагрузки для добавления к именам групп автомасштабирования.
  load_balancers = [aws_elb.kaa-elb.id]

  lifecycle {
    create_before_destroy = true
  }
}

