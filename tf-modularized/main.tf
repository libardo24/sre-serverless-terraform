data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_caller_identity" "current" {}

locals {
  azs         = slice(data.aws_availability_zones.available.names, 0, 2)
  common_tags = {
    Project   = var.project_name
    ManagedBy = "Terraform"
  }
  bucket_name = "${var.project_name}-${data.aws_caller_identity.current.account_id}-${var.aws_region}-results"
}

module "networking" {
  source               = "./modules/networking"
  project_name         = var.project_name
  vpc_cidr             = var.vpc_cidr
  availability_zones   = local.azs
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  aws_region           = var.aws_region
  tags                 = local.common_tags
}

module "security" {
  source       = "./modules/security"
  project_name = var.project_name
  vpc_id       = module.networking.vpc_id
  redis_port   = var.redis_port
  tags         = local.common_tags
}

module "s3_bucket" {
  source         = "./modules/s3_bucket"
  bucket_name    = local.bucket_name
  force_destroy  = true
  lambda_role_arn = module.lambda_processor.lambda_role_arn
  tags           = local.common_tags
}

module "redis" {
  source             = "./modules/redis"
  project_name       = var.project_name
  private_subnet_ids = module.networking.private_subnet_ids
  redis_sg_id        = module.security.redis_sg_id
  redis_node_type    = var.redis_node_type
  redis_port         = var.redis_port
  tags               = local.common_tags
}

module "lambda_processor" {
  source               = "./modules/lambda_processor"
  project_name         = var.project_name
  lambda_runtime       = var.lambda_runtime
  lambda_timeout       = var.lambda_timeout
  lambda_memory_size   = var.lambda_memory_size
  lambda_zip_path      = "${path.root}/../lambda/lambda.zip"
  subnet_ids           = module.networking.private_subnet_ids
  security_group_ids   = [module.security.lambda_sg_id]
  s3_bucket_name       = module.s3_bucket.bucket_name
  s3_bucket_arn        = module.s3_bucket.bucket_arn
  redis_host           = module.redis.redis_primary_endpoint
  redis_port           = module.redis.redis_port
  cache_ttl            = var.cache_ttl
  tags                 = local.common_tags
}

module "api_http" {
  source                   = "./modules/api_http"
  project_name             = var.project_name
  lambda_invoke_arn        = module.lambda_processor.lambda_invoke_arn
  lambda_function_name     = module.lambda_processor.lambda_function_name
  access_log_destination_arn = module.lambda_processor.api_log_group_arn
  throttle_burst_limit     = var.throttle_burst_limit
  throttle_rate_limit      = var.throttle_rate_limit
  cors_allow_origins       = var.cors_allow_origins
  tags                     = local.common_tags
}
