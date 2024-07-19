resource "aws_db_subnet_group" "main" {
  name       = "main"
  subnet_ids = var.subnet_ids
}

resource "aws_db_instance" "main" {
  identifier             = var.db_name_identifier
  engine                 = "mysql"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  db_subnet_group_name   = aws_db_subnet_group.main.name
  username               = var.db_username
  password               = var.db_password
  db_name                = var.db_name
  multi_az               = true
  skip_final_snapshot    = true
  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.rds.id]
}

resource "aws_security_group" "rds" {
  vpc_id = var.vpc_id
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = var.cidr_to_allow
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
