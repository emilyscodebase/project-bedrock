resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = var.private_subnets

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}

resource "aws_security_group" "rds" {
  name        = "${var.project_name}-rds-sg"
  description = "Security group for RDS instances"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.eks_sg_id]
  }

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.eks_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-rds-sg"
  }
}

resource "aws_secretsmanager_secret" "mysql" {
  name                    = "${var.project_name}-mysql-credentials"
  recovery_window_in_days = 0

  tags = {
    Name = "${var.project_name}-mysql-credentials"
  }
}

resource "aws_secretsmanager_secret_version" "mysql" {
  secret_id = aws_secretsmanager_secret.mysql.id
  secret_string = jsonencode({
    username = "bedrockadmin"
    password = "BedrockMySQL2025!"
    host     = aws_db_instance.mysql.address
    port     = 3306
    dbname   = "retailstore"
  })
}

resource "aws_db_instance" "mysql" {
  identifier             = "${var.project_name}-mysql"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  storage_type           = "gp2"
  db_name                = "retailstore"
  username               = "bedrockadmin"
  password               = "BedrockMySQL2025!"
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  skip_final_snapshot    = true
  multi_az               = false

  tags = {
    Name = "${var.project_name}-mysql"
  }
}

resource "aws_secretsmanager_secret" "postgres" {
  name                    = "${var.project_name}-postgres-credentials"
  recovery_window_in_days = 0

  tags = {
    Name = "${var.project_name}-postgres-credentials"
  }
}

resource "aws_secretsmanager_secret_version" "postgres" {
  secret_id = aws_secretsmanager_secret.postgres.id
  secret_string = jsonencode({
    username = "bedrockadmin"
    password = "BedrockPostgres2025!"
    host     = aws_db_instance.postgres.address
    port     = 5432
    dbname   = "retailstore"
  })
}

resource "aws_db_instance" "postgres" {
  identifier             = "${var.project_name}-postgres"
  engine                 = "postgres"
  engine_version         = "15"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  storage_type           = "gp2"
  db_name                = "retailstore"
  username               = "bedrockadmin"
  password               = "BedrockPostgres2025!"
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  skip_final_snapshot    = true
  multi_az               = false

  tags = {
    Name = "${var.project_name}-postgres"
  }
}
