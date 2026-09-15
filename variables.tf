variable "project" {
  type    = string
  default = "auto-repair"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "engine_version" {
  type    = string
  default = "16.15"
}

variable "instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "allocated_storage" {
  type    = number
  default = 20
}

variable "database_name" {
  type    = string
  default = "auto_repair_prod"
}

variable "master_username" {
  type    = string
  default = "auto_repair"
}

variable "backup_retention_days" {
  type    = number
  default = 1
}
