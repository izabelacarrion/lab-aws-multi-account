output "subnets_env" {
  value       = { for nome, rede in aws_subnet.terraform-subnets : nome => rede.cidr_block }
  description = "Endereços de rede e seus ambientes"
}