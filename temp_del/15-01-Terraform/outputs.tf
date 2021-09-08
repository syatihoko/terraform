




########## PRIVATE SUBNET ##########
//output "aws_subnet_private_subnet"  {
//  value = aws_subnet.private.cidr_block
//}


//########## PRIVATE NAT GATEWAY ##########
//output "aws_nat_gateway_private_id" {   # просто имя
//  value = [aws_nat_gateway.private_nat.id]
//}
//
//########## PRIVATE ROUTE TABLE ##########
//output "aws_route_table_private_id"  {
//  value = [aws_route_table.private_route.id]
//}
//
////В файл outputs.tf поместить блоки output с данными об используемых в данный момент:
////AWS account ID,
////AWS user ID,
////AWS регион, который используется в данный момент,
////Приватный IP ec2 инстансы,
////Идентификатор подсети в которой создан инстанс.

//#AWS account ID
//output "account_id" {
//  value = data.aws_caller_identity.current.account_id
//  description = "The private IP address of the main server instance."
//}
//
//
//#AWS user ID,
//output "caller_user" {
//  value = data.aws_caller_identity.current.user_id
//  description = "The private IP address of the main server instance."
//}
//
//#AWS регион, который используется в данный момент,
//output "aws_region" {
//  value = data.aws_region.current.name
//  description = "Current aws region."
//}
//
//#Приватный IP ec2 инстансы,
//output "instance_private_ip_addr" {
//  value = aws_instance.ubuntu_new.private_ip
//  description = "The private IP address of the main server instance."
//}
//
//#Идентификатор подсети в которой создан инстанс.
//output "instance_subnet_id" {
//  value = aws_instance.ubuntu_new.subnet_id
//  description = "The subnet id of instance."
//}



