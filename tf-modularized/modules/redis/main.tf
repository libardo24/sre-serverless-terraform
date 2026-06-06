resource "aws_elasticache_subnet_group" "this" {
  name       = "${var.project_name}-redis-subnets"
  subnet_ids = var.private_subnet_ids
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id           = replace("${var.project_name}-redis", "_", "-")
  engine               = "redis"
  node_type            = var.redis_node_type
  num_cache_nodes      = 1
  parameter_group_name = "default.redis7"
  port                 = var.redis_port
  subnet_group_name    = aws_elasticache_subnet_group.this.name
  security_group_ids   = [var.redis_sg_id]
  tags                 = merge(var.tags, { Name = "${var.project_name}-redis" })
}
