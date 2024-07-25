output "elastic_ip_nat_gateway_1a_public_ip" {
  value = aws_eip.elastic_ip_nat_gateway_1a.public_ip
}

output "elastic_ip_nat_gateway_1b_public_ip" {
  value = aws_eip.elastic_ip_nat_gateway_1b.public_ip
}

output "nsse_production_vpc_internet_gateway_id" {
  value = aws_internet_gateway.nsse_production_vpc_internet_gateway.id
}

output "nat_gateway_1a_id" {
  value = aws_nat_gateway.nat_gateway_1a.id
}

output "nat_gateway_1a_public_ip" {
  value = aws_nat_gateway.nat_gateway_1a.public_ip
}

output "nat_gateway_1b_id" {
  value = aws_nat_gateway.nat_gateway_1b.id
}

output "nat_gateway_1b_public_ip" {
  value = aws_nat_gateway.nat_gateway_1b.public_ip
}

output "vpc_id" {
  value = aws_vpc.nsse_production_vpc.id
}
