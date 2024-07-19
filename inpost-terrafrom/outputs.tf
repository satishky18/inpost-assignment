output "webserver_lb_dns_name" {
  value = module.webserver.lb_dns_name
}

output "rds_endpoint" {
  value = module.rds.db_instance_endpoint
}

output "s3_bucket" {
  value = module.s3.bucket_name
}
