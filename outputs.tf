

data "aws_secretsmanager_secret" "secrets" {
  arn = var.dockerhub_credentials
}

data "aws_secretsmanager_secret_version" "current" {
  secret_id = data.aws_secretsmanager_secret.secrets.id
}

output "sensitive_example_hash" {
  value = jsondecode(nonsensitive(data.aws_secretsmanager_secret_version.current.secret_string))
}