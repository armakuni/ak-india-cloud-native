resource "random_string" "password" {
  length           = 32
  special          = true
  override_special = var.password_override_special
}

module "custom_vpc" {
  source      = "git::https://gitlab.com/bhattraideb/aws-terraform-modules.git//modules/aws_custom_vpc?ref=main"
  environment = var.environment
}

# module "flask_repo" {
#   source          = "git::https://gitlab.com/bhattraideb/aws-terraform-modules.git//modules/aws_ecr?ref=main"
#   repository_name = var.flask_api_repository_name
# }

module "django_repo" {
  source          = "git::https://gitlab.com/bhattraideb/aws-terraform-modules.git//modules/aws_ecr?ref=main"
  repository_name = var.django_api_repository_name
}

module "aws_database_instance" {
  source                      = "git::https://gitlab.com/bhattraideb/aws-terraform-modules.git//modules/aws_database?ref=main"
  db_identifier_name          = var.db_identifier_name
  database_name               = var.database_name
  storage_type                = var.storage_type
  storage                     = var.storage
  max_allocated_storage       = var.max_allocated_storage
  username                    = var.username
  password                    = var.set_password ? random_string.password.result : null
  engine                      = var.engine
  engine_family               = var.engine_family
  engine_version              = var.engine_version
  instance_type               = var.db_instance_type
  multi_az                    = var.multi_az
  vpc_id                      = module.custom_vpc.vpc_id
  encryption_at_rest          = var.encryption_at_rest
  backup_retention_period     = var.backup_retention_period
  performance_insight_enabled = var.performance_insight_enabled
  deletion_protection         = var.deletion_protection
  ingress_security_groups     = var.ingress_security_groups
  subnet_ids                  = [module.custom_vpc.private_a_subnet_id, module.custom_vpc.private_b_subnet_id]
}