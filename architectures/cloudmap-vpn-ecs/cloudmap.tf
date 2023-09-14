resource "aws_service_discovery_private_dns_namespace" "backend" {
  name = var.internal_domain_name
  vpc  = aws_vpc.base_vpc.id
}

resource "aws_service_discovery_service" "backend" {
  name = var.internal_serv_name
  dns_config {
    namespace_id   = aws_service_discovery_private_dns_namespace.backend.id
    routing_policy = "WEIGHTED"
    dns_records {
      ttl  = 10
      type = "A"
    }
  }

  health_check_custom_config {
    failure_threshold = 5
  }
}
