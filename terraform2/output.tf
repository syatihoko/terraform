//arn - универсальный идентификатор в амазоне EC2 Instance.
output "ec3_web_arn" {
  value = "aws_instance.web.arn"
}

//Для примера тип Instance
output "ec2_web_instance_type {
  value = "aws_instance.web.instance_type"
}