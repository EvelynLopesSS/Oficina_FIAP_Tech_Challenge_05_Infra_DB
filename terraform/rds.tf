resource "aws_db_subnet_group" "hackathon_subnet_group" {
  name = "hackathon-db-subnet-group"
  subnet_ids = [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id
  ]
  tags = { Name = "HackathonSubnetGroup" }
}

resource "aws_db_instance" "hackathon_rds" {
  identifier              = "hackathon-rds"
  engine                  = "postgres"
  engine_version          = "15"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  storage_type            = "gp2"

  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password

  publicly_accessible     = true
  skip_final_snapshot     = true

  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  db_subnet_group_name    = aws_db_subnet_group.hackathon_subnet_group.name

  tags = { Name = "HackathonRDS" }
}