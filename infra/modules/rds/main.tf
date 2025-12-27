terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_db_instance" "postgres" {
  allocated_storage           = var.minimum_storage
  max_allocated_storage       = var.maximum_storage
  db_name                     = var.db_name
  engine                      = "postgres"
  engine_version              = var.db_engine_version
  instance_class              = var.instance_class
  storage_encrypted           = true
  multi_az                    = true
  manage_master_user_password = true
  username                    = "mohammedsalem"
  maintenance_window          = var.maintenance_window
  backup_retention_period     = var.backup_retention_period
  skip_final_snapshot         = false
  final_snapshot_identifier   = var.final_snapshot
  auto_minor_version_upgrade  = true
  deletion_protection         = true
  monitoring_interval         = var.monitoring_interval
  performance_insights_enabled = true
  performance_insights_retention_period = var.performance_insights_retention_period
  iam_database_authentication_enabled = true
  enabled_cloudwatch_logs_exports = var.cloudwatch_logs_exports
  copy_tags_to_snapshot = true
  vpc_security_group_ids = [aws_security_group.db_sg.id]

}

resource "aws_db_subnet_group" "private" {
  name       = var.subnet_group_name
  subnet_ids = var.subnet_ids

}

resource "aws_db_snapshot" "umami-db-snapshot" {
  db_instance_identifier = aws_db_instance.postgres.identifier
  db_snapshot_identifier = var.snapshot_identifier

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_security_group" "db_sg" {
  name        = var.db_sg_name
  description = "Security group for RDS PostgreSQL"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow PostgreSQL from ECS tasks"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.ecs_task_sg_id]
  }
}