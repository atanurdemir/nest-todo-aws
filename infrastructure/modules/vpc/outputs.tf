output "private_subnet_ids" {
  value = aws_subnet.private_subnet
}
output "public_subnet_ids" {
  value = aws_subnet.public_subnet
}
output "vpc_id" {
  value = aws_vpc.vpc.id
}
