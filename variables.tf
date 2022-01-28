variable "dockerhub_credentials" { 
  type = string
  dockerhub_credentials     = "${var.dockerhub_credentials}"
}
variable "codestar_connector_credentials" {
  type = string
  codestar_connector_credentials     = "${var.codestar_connector_credentials}"
}

variable region {
  type    = string
  default = "us-east-1"
  
}

