resource "aws_db_parameter_group" "parameter_group" {
  count  = var.is_db_instance ? 1 : 0
  name   = "${var.rds_instace_name}-parameter-group"
  family = "${var.engine}${var.engine_version}"

  dynamic "parameter" {
    for_each = var.parameters
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }
}

resource "aws_db_option_group" "option_group" {
  count                = var.is_db_instance ? 1 : 0
  name                 = "${var.rds_instace_name}-option-group"
  engine_name          = var.engine
  major_engine_version = var.engine_version

  dynamic "option" {
    for_each = var.options
    content {
      option_name  = option.value.option_name
      option_settings {
        name  = option.value.option_setting_name
        value = option.value.option_setting_value
      }
    }
  }
}

resource "aws_db_subnet_group" "subnet_group" {
  name       = "${var.rds_instace_name}-subnet-group"
  subnet_ids = data.aws_subnets.rds_subnets.ids
  tags       = var.tags
}

resource "aws_db_instance" "db_instance" {
  count                           = var.is_db_instance ? 1 : 0
  allocated_storage               = var.allocated_storage
  max_allocated_storage           = var.max_allocated_storage
  availability_zone               = "${data.aws_region.current.name}${var.availability_zone}"
  backup_window                   = var.backup_window
  db_name                         = var.db_name
  engine                          = var.engine
  engine_version                  = var.engine_version
  instance_class                  = var.instance_class
  multi_az                        = var.multi_az
  character_set_name              = var.character_set_name
  username                        = var.username
  password                        = var.password
  parameter_group_name            = aws_db_parameter_group.parameter_group[0].name
  db_subnet_group_name            = aws_db_subnet_group.subnet_group.name
  option_group_name               = aws_db_option_group.option_group[0].name
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  apply_immediately               = var.apply_immediately
  skip_final_snapshot             = var.skip_final_snapshot
  deletion_protection             = var.deletion_protection
  allow_major_version_upgrade     = var.allow_major_version_upgrade
  backup_retention_period         = var.backup_retention_period
  publicly_accessible             = var.publicly_accessible
  kms_key_id                      = var.kms_key_id
  identifier                      = var.rds_instace_name
  maintenance_window              = var.maintenance_window
  snapshot_identifier             = var.snapshot_identifier
  storage_type                    = var.storage_type
  iops                            = var.iops
  storage_encrypted               = var.storage_encrypted
  tags                            = var.tags
  vpc_security_group_ids          = var.security_group_ids
}

# resource "aws_rds_cluster" "db_cluster" {
#   count                           = var.is_db_cluster ? 1 : 0
#   cluster_identifier      = "aurora-cluster-demo"
#   engine                  = "aurora-mysql"
#   engine_version          = "5.7.mysql_aurora.2.03.2"
#   availability_zones      = ["${data.aws_region.current.name}a", "${data.aws_region.current.name}b", "${data.aws_region.current.name}c"]
#   database_name           = "mydb"
#   master_username         = "foo"
#   master_password         = "bar"
#   backup_retention_period = 5
#   preferred_backup_window = "07:00-09:00"
# }

# resource "aws_rds_cluster_parameter_group" "default" {
#   count                           = var.is_db_cluster ? 1 : 0
#   name        = "rds-cluster-pg"
#   family      = "aurora5.6"
#   description = "RDS default cluster parameter group"

#   dynamic "parameter" {
#     for_each = var.parameters
#     content {
#       name  = parameter.value.name
#       value = parameter.value.value
#     }
#   }
# }