variable "production_vpc_cidr" {
  default = "192.168.0.0/16" # Valor específico para Producao
}

variable "ambiente" {
  default = "prod" # Recurso alocado para ambiente de Producao
}

variable "nome_subnets" {
  type    = set(string)
  default = ["priv", "pub"]
}

variable "bloco_ips_liberados" {
  type        = string
  description = "Define os endereços de IP liberados"
}