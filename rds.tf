resource "aws_db_subnet_group" "this" {
  name       = "${var.project}-db"
  subnet_ids = local.private_subnet_ids
}

resource "aws_security_group" "db" {
  name        = "${var.project}-db"
  description = "PostgreSQL access from inside the VPC"
  vpc_id      = local.vpc_id

  ingress {
    description = "PostgreSQL from the VPC"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [local.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "random_password" "master" {
  length  = 32
  special = false
}

resource "aws_db_parameter_group" "this" {
  name   = "${var.project}-pg16"
  family = "postgres16"

  parameter {
    name  = "log_min_duration_statement"
    value = "500"
  }
}

resource "aws_db_instance" "this" {
  identifier     = "${var.project}-db"
  engine         = "postgres"
  engine_version = var.engine_version
  instance_class = var.instance_class

  allocated_storage     = var.allocated_storage
  max_allocated_storage = 50
  storage_type          = "gp3"
  storage_encrypted     = true

  db_name  = var.database_name
  username = var.master_username
  password = random_password.master.result
  port     = 5432

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.db.id]
  parameter_group_name   = aws_db_parameter_group.this.name
  publicly_accessible    = false
  multi_az               = false

  backup_retention_period = var.backup_retention_days
  skip_final_snapshot     = true
  deletion_protection     = false
  apply_immediately       = true

  performance_insights_enabled    = true
  enabled_cloudwatch_logs_exports = ["postgresql"]
}
