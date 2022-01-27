variable "dockerhub_credentials" {
  type = string
}
variable "codestar_connector_credentials" {
  type = string
}

variable region {
  type    = string
  default = "us-east-1"
}