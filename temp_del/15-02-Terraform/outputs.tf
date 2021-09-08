
output "s3_bucket" {
  value = data.aws_s3_bucket.kaa_b
}

output "s3_object" {
  value = data.aws_s3_bucket_object.kaa_foto
}



//ARN - универсальный идентификатор в амазоне. Здесть для EC2 Instance.
# output "ec3_web_arn" {
#   value = "aws_instance.web.arn"
# }

# //Для примера тип Instance
# output "ec2_web_instance_type {
#   value = "aws_instance.web.instance_type"
# }