# AWS Multi-Account Infrastructure with Terraform & GitHub Actions

Este repositório contém a fundação de rede (Landing Zone simplificada) para um ambiente AWS multi-account, utilizando **Terraform** e **GitHub Actions**. O projeto foi desenhado para simular um cenário real de segregação de ambientes (Staging e Produção) com automação robusta.

## 🚀 Arquitetura do Projeto

A infraestrutura é dividida em camadas para garantir o isolamento e a segurança dos recursos:

* **Rede (VPC):** Criação de VPCs distintas para `stg` e `prod`.
* **Segregação:** Subnets públicas e privadas distribuídas.
* **Segurança:** Implementação de Gateways e tabelas de roteamento customizadas.
* **Gestão de Estado:** Terraform State armazenado remotamente no Amazon S3.

## 🛠️ Tecnologias Utilizadas

* **Terraform:** Infraestrutura como Código (IaC).
* **GitHub Actions:** CI/CD pipelines para automação de Plan e Apply.
* **AWS (Multi-Account):** Utilização de diferentes contas/ambientes via OIDC.

## 🤖 Pipeline de CI/CD

O workflow no GitHub Actions foi configurado para:
1.  **Validação Automática:** Execução de `terraform fmt` e `tfsec` para garantir boas práticas e segurança.
2.  **Identificação de Ambiente:** O pipeline identifica a branch (`stg` ou `prod`) e aponta automaticamente para o diretório de trabalho correto e para o arquivo de backend correspondente.
3.  **Segurança de Variáveis:** Uso de `cat <<EOF` para injetar segredos dinâmicos de backend sem expor informações sensíveis nos logs.

## 📂 Estrutura de Pastas

```text
.
├── staging/            # Recursos de Terraform para o ambiente de Staging
├── production/         # Recursos de Terraform para o ambiente de Produção
├── modules/            # Módulos reutilizáveis (VPC, Security Groups, etc.)
└── .github/workflows/  # Definições do pipeline de CI/CD
```
