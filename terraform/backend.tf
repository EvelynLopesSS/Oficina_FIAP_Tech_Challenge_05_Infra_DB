terraform {
  backend "s3" {
    bucket  = "oficina-techchallenge-terraform-state-fase5-2026"
    key     = "infra-db/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}