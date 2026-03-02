# Código que cria toda parte de Security Groups e Regras de entrada

#Cria um Security Group com base no ambiente
resource "aws_security_group" "sg_terraform" {
  name        = "sg_${var.ambiente}"
  description = "SG do ambiente ${var.ambiente}"
  vpc_id      = aws_vpc.terraform-vpc.id

  ingress { # regra de entrada
    description = "Port custom por ambiente"
    # Verifica qual ambiente é e cria regra de entrada
    from_port   = var.config_ambientes[var.ambiente].porta_app
    to_port     = var.config_ambientes[var.ambiente].porta_app
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress { # Regra de saída
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "sg_${var.ambiente}"
    Environment = var.ambiente
  }
}

# Cria uma regra de entrada para o meu endereço de IP
resource "aws_vpc_security_group_ingress_rule" "lib_meu_ssh" {
  for_each = toset(compact([for ip in split("\n", var.bloco_ips_liberados) : trimspace(ip)]))

  security_group_id = aws_security_group.sg_terraform.id
  cidr_ipv4         = each.value
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  description       = "Acesso SSH"
}