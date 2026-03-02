module "account-staging" {
  source              = "../modules"
  cidr_bloco_da_vpc   = var.staging_vpc_cidr
  ambiente            = var.ambiente
  nome_subnets        = var.nome_subnets
  bloco_ips_liberados = var.bloco_ips_liberados
}