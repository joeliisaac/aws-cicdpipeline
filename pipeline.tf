resource "aws_codebuild_project" "terraform-plan" {
  name         = "terraform-cicd-plan"
  description  = "Plan stage for TF"
  service_role = aws_iam_role.codebuild-role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "hashicorp/terraform:latest"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "SERVICE_ROLE"
    registry_credential {
      credential          = var.dockerhub_credentials
      credential_provider = "SECRETS_MANAGER"
    }
  }
  source {
    type      = "CODEPIPELINE"
    buildspec = file("buildspec/plan-buildspec.yml")

  }
}


resource "aws_codebuild_project" "terraform-apply" {
  name         = "terraform-cicd-apply"
  description  = "apply stage for TF"
  service_role = aws_iam_role.codebuild-role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "hashicorp/terraform:latest"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "SERVICE_ROLE"
    registry_credential {
      credential          = var.dockerhub_credentials
      credential_provider = "SECRETS_MANAGER"
    }
  }
  source {
    type      = "CODEPIPELINE"
    buildspec = file("buildspec/apply-buildspec.yml")

  }
}



resource "aws_codepipeline" "my-pipeline" {
  name     = "tf-cicd-pipeline"
  role_arn = aws_iam_role.codepipeline-role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline-artifacts.bucket
    type     = "S3"

  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = var.codestar_connector_credentials
        FullRepositoryId = "joeliisaac/aws-cicdpipeline"
        BranchName       = "master"
        //OutputArtifactFormat  = " CODE_ZIP"
      }
    }
  }

  stage {
    name = "Plan"

    action {
      name            = "Build"
      category        = "Build"
      provider        = "CodeBuild"
      owner           = "AWS"
      input_artifacts = ["source_output"]
      version         = "1"

      configuration = {
        ProjectName = "terraform-cicd-plan"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Build"
      provider        = "CodeBuild"
      owner           = "AWS"
      input_artifacts = ["source_output"]
      version         = "1"

      configuration = {
        ProjectName = "terraform-cicd-apply"
      }
    }
  }
}

