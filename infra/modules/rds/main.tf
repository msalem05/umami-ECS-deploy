
resource "aws_db_instance" "postgresql" {
    allocated_storage = var.minimum_storage
    max_allocated_storage = var.maximum_storage
    db_name = "${var.db_name}-postgresql"
    engine = "postgresql"
    engine_version = "15.5"
    instance_class = var.instance_class
    storage_encrypted = true
    multi_az = true
    manage_master_user_password = true
    username = "mohammedsalem"
    maintenance_window = var.maintenance_window
    backup_retention_period = var.backup_retention_period

}

resource "aws_db_subnet_group" "private"{
    name = var.subnet_group_name
    subnet_ids = var.subnet_ids

}

resource "aws_db_snapshot" "umami-db-snapshot" {
    db_instance_identifier = aws_db_instance.postgresql.identifier
    db_snapshot_identifier = var.snapshot_identifier
}