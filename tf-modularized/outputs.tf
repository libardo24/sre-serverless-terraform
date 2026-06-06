output "api_base_url" {
  value = module.api_http.api_base_url
}

output "bucket_name" {
  value = module.s3_bucket.bucket_name
}

output "redis_primary_endpoint" {
  value = module.redis.redis_primary_endpoint
}

output "lambda_function_name" {
  value = module.lambda_processor.lambda_function_name
}
