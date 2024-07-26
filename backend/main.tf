//a separacao das pastas networking (rede) e backend favorecem
//a criacao de recursos de forma separada e impede a destruicao 
//completa do mesmo

provider "aws" {
  region = var.region
  assume_role {
    role_arn    = var.assume_role.role_arn
    external_id = var.assume_role.external_id
  }
}
