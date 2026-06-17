output "vpc_id" {
  value = aws_vpc.hackathon_vpc.id
}

output "public_subnet_ids" {
  value = [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id
  ]
}

output "rds_host" {
  value = aws_db_instance.hackathon_rds.address
}