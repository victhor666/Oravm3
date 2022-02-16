output "vnet_name" {
  description = "Nombre de la Vnet creada para el Oracle"
  value       = aws_vpc.Oracle-VPC.id
}
