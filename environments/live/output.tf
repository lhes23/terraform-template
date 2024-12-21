output "vpc_id" {
  value = module.vpc.id
}

output "alb_dns_name" {
  value = module.alb.dns_name
}