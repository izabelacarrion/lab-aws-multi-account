variable "cidr_bloco_da_vpc" {
  description = "O bloco CIDR para a VPC"
  type        = string
}

variable "ambiente" {
  type        = string
  description = "Ambiente do recurso prod ou stg"
}

variable "nome_subnets" {
  type        = set(string)
  description = "Lista com o nome de cada Subnet"
}

variable "bloco_ips_liberados" {
  type        = string
  description = "Define os endereços de IP liberados"
}