output "live_vpc_id" {
  value = module.live_vpc.id # Assuming you have a VPC module
}

output "live_vpc_cidr" {
  value = module.live_vpc.cidr_block
}

output "live_route_table_id" {
  value = module.live_vpc.route_table_id
}

output "alb_dns_name" {
  value = module.alb.dns_name
}