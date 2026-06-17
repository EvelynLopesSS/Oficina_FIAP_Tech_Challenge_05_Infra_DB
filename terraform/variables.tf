variable "db_name" {
  default = "hackathon_db"
}
variable "db_username" {
  default = "postgres"
}
variable "db_password" {
  sensitive = true
}
variable "allowed_ips" {
  description = "Lista de IPs autorizados (Usaremos 0.0.0.0/0 para CI/CD)"
  type        = list(string)
}