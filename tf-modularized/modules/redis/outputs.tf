output "redis_primary_endpoint" { value = aws_elasticache_cluster.redis.cache_nodes[0].address }
output "redis_port" { value = aws_elasticache_cluster.redis.port }
