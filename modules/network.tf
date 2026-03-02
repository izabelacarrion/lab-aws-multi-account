# Código que cria parte de: VPC, Subredes, Tabela de roteamento, Internet Gateway, e associa a tabela de roteamento que foi criada.

# Criando a VPC
resource "aws_vpc" "terraform-vpc" {
  cidr_block = var.cidr_bloco_da_vpc


  tags = {
    Name        = "VPC-${var.ambiente}"
    Environment = var.ambiente
  }
}

# Criando a subnets
resource "aws_subnet" "terraform-subnets" {
  for_each                = var.nome_subnets
  vpc_id                  = aws_vpc.terraform-vpc.id
  cidr_block              = cidrsubnet(aws_vpc.terraform-vpc.cidr_block, 8, index(sort(tolist(var.nome_subnets)), each.value)) # Automatiza o calculo de IPs
  map_public_ip_on_launch = length(regexall("pub", each.key)) > 0 ? true : false                                               # O recurso iniciado a partir da PUB ganha Ip publico

  tags = {
    Name        = "Subnet-${each.value}-${var.ambiente}"
    Environment = var.ambiente
  }
}

# Cria internet gateway
resource "aws_internet_gateway" "terraform-gw" {
  vpc_id = aws_vpc.terraform-vpc.id

  tags = {
    Name        = "GW-${var.ambiente}"
    Environment = var.ambiente
  }
}

# Cria endereço de IP estatico (EIP)
resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags   = { Name = "EIP-NAT-${var.ambiente}" }
}


# Cria o Nat gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  # Aqui pegamos a primeira subnet que for pública (contiver 'pub' no nome)
  subnet_id = [for k, v in aws_subnet.terraform-subnets : v.id if length(regexall("pub", k)) > 0][0]

  tags = { Name = "NAT-${var.ambiente}" }

  # Recomendado: garantir que o IGW já existe antes de criar o NAT
  depends_on = [aws_internet_gateway.terraform-gw]
}

# TABELA PÚBLICA (Mantém o Internet Gateway)
resource "aws_route_table" "rt-public" {
  vpc_id = aws_vpc.terraform-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform-gw.id
  }

  tags = {
    Name = "RT-Pub-${var.ambiente}"
  }
}

# TABELA PRIVADA (Sem Internet Gateway)
resource "aws_route_table" "rt-private" {
  vpc_id = aws_vpc.terraform-vpc.id

  # Aqui entra a rota para o NAT Gateway
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "RT-Priv-${var.ambiente}"
  }
}

# Associando tabela de rotas
resource "aws_route_table_association" "rta-terraform" {
  for_each  = aws_subnet.terraform-subnets
  subnet_id = each.value.id

  # Se o nome da subnet contiver "pub", usa a RT pública. 
  # Senão, usa a privada.
  route_table_id = length(regexall("pub", each.key)) > 0 ? aws_route_table.rt-public.id : aws_route_table.rt-private.id
}