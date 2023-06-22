data "aws_availability_zones" "available" {
  state = "available"
}

output "list_of_available_zones" {
  description = "The list of the available zones"
  value       = data.aws_availability_zones.available.names
}