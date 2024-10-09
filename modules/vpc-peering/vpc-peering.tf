# Create VPC Peering Connection between staging and live
resource "aws_vpc_peering_connection" "staging_live_peer" {
  vpc_id        = var.staging_vpc_id
  peer_vpc_id   = var.live_vpc_id
  auto_accept   = true

  tags = {
    Name = "staging-live-peering"
  }
}

# Add route in staging VPC to route traffic to live VPC
resource "aws_route" "staging_to_live" {
  route_table_id            = var.staging_route_table_id
  destination_cidr_block    = var.live_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.staging_live_peer.id
}

# Add route in live VPC to route traffic to staging VPC
resource "aws_route" "live_to_staging" {
  route_table_id            = var.live_route_table_id
  destination_cidr_block    = var.staging_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.staging_live_peer.id
}


variable "staging_vpc_id" {
  description = "The ID of the staging VPC"
}

variable "live_vpc_id" {
  description = "The ID of the live VPC"
}

variable "staging_route_table_id" {
  description = "Route table ID for staging VPC"
}

variable "live_route_table_id" {
  description = "Route table ID for live VPC"
}

variable "staging_vpc_cidr" {
  description = "CIDR block of the staging VPC"
}

variable "live_vpc_cidr" {
  description = "CIDR block of the live VPC"
}