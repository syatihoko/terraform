
########## PRIVATE SUBNET ##########
//output "aws_subnet_private_subnet"  {
//  value = aws_subnet.private.cidr_block
//}


//########## PRIVATE NAT GATEWAY ##########
//output "aws_nat_gateway_private_id" {   # просто имя
//  value = [aws_nat_gateway.private_nat.id]
//}
//

########## VPC ##########
# output "aws_vpc"  {
#   value = module.vpc
# }



########## PRIVATE ROUTE TABLE ##########
output "aws_route_table_private"  {
  #value = aws_route_table.private_route.id
  value = aws_route_table.private_route
}

########## S3 ##########
//назначенное доменное имя bucket, путь до него 
//url_aws_bucket_name = kaa-20210903.s3.amazonaws.com
output "url_aws_bucket_name"  {
  value = data.aws_s3_bucket.kaa_b.bucket_domain_name
}

//file_aws_bucket_object = kaa_foto.jpg
output "file_aws_bucket_object"  {
  value = data.aws_s3_bucket_object.kaa_foto.key
}   

//https://s3.console.aws.amazon.com/s3/object/kaa-20210903?region=eu-west-3&prefix=kaa_foto.jpg