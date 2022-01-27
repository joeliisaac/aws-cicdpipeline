variable "dockerhub_credentials" { 
  type = string
  //default     = "arn:aws:secretsmanager:us-east-1:460475058893:secret:docker-token-07oSpz" 
}
variable "codestar_connector_credentials" {
  type = string
  //default     = "arn:aws:codestar-connections:us-east-1:460475058893:connection/6214a430-eb42-4b1c-8c94-cebe2f341d2f"
}

variable region {
  type    = string
  default = "us-east-1"
  
}
