variable "dockerhub_credentials" { 
  type = string
  default     = "${var.dockerhub_credentials}"
}
variable "codestar_connector_credentials" {
  type = string
  default     = "${var.codestar_connector_credentials}"
}

variable region {
  type    = string
  default = "us-east-1"
  
}

