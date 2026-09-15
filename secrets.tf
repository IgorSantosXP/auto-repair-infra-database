resource "random_password" "jwt_secret" {
  length  = 64
  special = false
}

resource "aws_secretsmanager_secret" "app" {
  name                    = "${var.project}/app"
  description             = "Database credentials and shared JWT secret"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "app" {
  secret_id = aws_secretsmanager_secret.app.id

  secret_string = jsonencode({
    host       = aws_db_instance.this.address
    port       = aws_db_instance.this.port
    username   = var.master_username
    password   = random_password.master.result
    dbname     = var.database_name
    jwt_secret = random_password.jwt_secret.result
  })
}
