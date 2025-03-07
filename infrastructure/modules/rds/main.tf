module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "6.10.0"

  identifier = var.db_name

  engine                   = "postgres"
  engine_version           = var.db_engine_version
  major_engine_version     = var.db_major_engine_version
  engine_lifecycle_support = "open-source-rds-extended-support-disabled"
  family                   = "postgres16"

  instance_class = var.rds_instance_class

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password
  port     = var.db_port

  allocated_storage     = 20
  max_allocated_storage = 100
  storage_type          = "gp3"

  iam_database_authentication_enabled = false

  manage_master_user_password = false

  vpc_security_group_ids = [aws_security_group.database_sg.id]

  tags = {
    Name      = var.db_name
    Project   = "Pharmakart"
    ManagedBy = "Terraform"
  }

  skip_final_snapshot = true

  db_subnet_group_name = var.db_subnet_group_name

  deletion_protection = false

  backup_retention_period         = 7
  maintenance_window              = "Mon:00:00-Mon:01:00"
  backup_window                   = "03:00-04:00"
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  create_cloudwatch_log_group     = true

  performance_insights_enabled = false
  create_monitoring_role       = false

  multi_az            = true
  publicly_accessible = false
  storage_encrypted   = true
}

# Copy SQL script to bastion host
resource "null_resource" "copy_sql_script" {

  provisioner "file" {
    source      = "${path.module}/init-database.sql"
    destination = "/tmp/init-database.sql"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = var.bastion_private_key_path != "" ? file(var.bastion_private_key_path) : file("~/.ssh/id_rsa")
      host        = var.bastion_public_ip
    }
  }

  triggers = {
    instance_id   = module.rds.db_instance_identifier
    sql_file_hash = filemd5("${path.module}/init-database.sql")
  }
}

# Execute SQL script on bastion host
resource "null_resource" "db_setup" {
  depends_on = [module.rds, null_resource.copy_sql_script]

  provisioner "remote-exec" {
    inline = [
      "PGPASSWORD='${var.db_password}' psql -h ${module.rds.db_instance_address} -U ${var.db_username} -d ${var.db_name} -p ${var.db_port} -f /tmp/init-database.sql",
      "echo 'Database initialization complete'",
      "rm /tmp/init-database.sql" # Clean up
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = var.bastion_private_key_path != "" ? file(var.bastion_private_key_path) : file("~/.ssh/id_rsa")
      host        = var.bastion_public_ip
    }
  }

  triggers = {
    instance_id   = module.rds.db_instance_identifier
    sql_file_hash = filemd5("${path.module}/init-database.sql")
  }
}
