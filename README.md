# 🗄️ Hackathon Fase 5 - Infraestrutura de Banco de Dados e Rede (Repo 1 de 5)

Este repositório é o **Passo 1** na orquestração da arquitetura em nuvem para o **Sistema de Processamento de Vídeos da FIAP**. Ele é responsável por provisionar a camada fundacional da infraestrutura: A Rede (VPC) e o Banco de Dados Relacional Gerenciado (AWS RDS PostgreSQL).

Os recursos criados aqui exportam seus identificadores (via `terraform output` e *Remote State*) para que o Cluster Kubernetes (EKS), a Fila SQS e os Buckets S3 possam ser provisionados na mesma rede na próxima etapa.

## 🎯 Propósito
- Criar a **VPC (Virtual Private Cloud)** base da arquitetura.
- Criar Subnets Públicas, Internet Gateway e Tabelas de Roteamento.
- Provisionar a instância do **Amazon RDS PostgreSQL** (Free Tier / `db.t3.micro`).
- Configurar os **Security Groups** (Firewall) para controle de acesso ao banco.

## 🛠️ Tecnologias Utilizadas
- **Terraform:** Ferramenta de *Infrastructure as Code* (IaC).
- **AWS (Amazon Web Services):** Provedor de Nuvem (RDS, VPC, S3).
- **GitHub Actions:** Esteira de CI/CD para automação do provisionamento.
- **PostgreSQL:** Motor de banco de dados para persistência de Usuários e Status de Processamento de Vídeos.

## 🏛️ Desenho da Arquitetura deste Repositório

```mermaid
graph TD
    subgraph aws_cloud [AWS Cloud - us-east-1]
        subgraph vpc [VPC - 10.0.0.0/16]
            IGW[Internet Gateway]
            
            subgraph public_subnets [Public Subnets]
                RDS[(RDS PostgreSQL<br> db.t3.micro)]
            end
            
            subgraph security_groups [Security Groups]
                RDSSG[RDS Security Group<br> Porta 5432]
            end
            
            RDS --- RDSSG
        end
    end
    
    GH[GitHub Actions CI/CD] -->|Terraform Apply| aws_cloud
    GH -->|Salva Estado| S3[(S3 Bucket<br> Terraform State)]

```

⚠️ Decisões Arquiteturais (ADR)

  - PostgreSQL para Gestão de Estado: Escolhemos um banco relacional para manter
    a integridade transacional dos usuários e rastrear o status de cada vídeo
    enviado para processamento (RECEBIDO, PROCESSANDO, CONCLUIDO, ERRO). O
    armazenamento "pesado" dos vídeos não ficará aqui, mas sim no S3
    (provisionado no próximo repositório).
  - Acesso Público Temporário (0.0.0.0/0): Devido à natureza efêmera dos Runners
    do GitHub Actions e à limitação de custos da conta AWS Academy (sem NAT
    Gateway), o RDS é provisionado em subnets públicas com a regra de firewall
    aberta. A segurança é mantida por credenciais fortes e isolamento nas
    camadas de aplicação.

🚀 Passo a Passo para Execução e Deploy

Este repositório utiliza GitHub Actions para automação total.

1. Configurar os Secrets no GitHub

Vá até a aba Settings > Secrets and variables > Actions e cadastre as seguintes
variáveis:

| Secret                  | Descrição                                            | Exemplo                                            |
| ----------------------- | ---------------------------------------------------- | -------------------------------------------------- |
| `AWS_ACCESS_KEY_ID`     | Chave de acesso da AWS                               | `AKIAIOSFODNN7EXAMPLE`                             |
| `AWS_SECRET_ACCESS_KEY` | Chave secreta da AWS                                 | `wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY`         |
| `AWS_SESSION_TOKEN`     | Token de Sessão (Obrigatório na AWS Academy/voclabs) | `IQoJb3JpZ2luX2VjE...`                             |
| `AWS_REGION`            | Região da AWS                                        | `us-east-1`                                        |
| `AWS_TF_STATE_BUCKET`   | Nome **único** para o Bucket S3 de State             | `oficina-techchallenge-terraform-state-fase5-2026` |
| `DB_PASS`               | Senha forte para o banco de dados                    | `SuperSenha123!`                                   |
| `ALLOWED_IP`            | Bloco CIDR liberado no Firewall                      | `0.0.0.0/0`                                        |

2. Criar o Bucket do Terraform State (Bootstrap)

1.  Vá na aba Actions.
2.  Selecione o workflow 🪣 Bootstrap Terraform Remote State (S3).
3.  Clique em Run workflow.

3. Fazer o Deploy da Infraestrutura

1.  Selecione o workflow 🚀 Terraform Apply (Infra DB).
2.  Clique em Run workflow.
3.  Aguarde a execução (a criação do RDS leva em média 5 minutos).

4. Anotar os Outputs

Ao final da execução com sucesso, abra os logs do GitHub Actions, expanda a
seção 🚀 Terraform Apply e anote o valor do rds_host (ex:
hackathon-rds.xxxxxx.us-east-1.rds.amazonaws.com).

🔄 Continuidade

Com a Rede e o Banco de Dados provisionados, a base da arquitetura está pronta.
👉 Próximo passo: Siga para a documentação do Repositório 2 - Infraestrutura
Kubernetes (Infra_K8s), onde criaremos o EKS, S3 e a Fila SQS.

