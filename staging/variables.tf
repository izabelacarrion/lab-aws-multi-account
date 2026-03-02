variable "staging_vpc_cidr" {
  default = "10.0.0.0/16" # Valor específico para Staging
}

variable "ambiente" {
  default = "stg" # Recurso alocado para ambiente de Staging
}

variable "nome_subnets" {
  type    = set(string)
  default = ["priv", "pub"]
}

variable "bloco_ips_liberados" {
  type        = string
  description = "Define os endereços de IP liberados"
  default     = "192.168.0.50/32"
}