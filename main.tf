provider "aws" {
  region = var.region
}


//IAM role for codepipeline


# resource "aws_iam_role" "codepipeline-role" {
#   name = "codepipeline-role"


#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "codepipeline.amazonaws.com"
#       },
#       "Action": "sts:AssumeRole"
#     }
#   ]
# }
# EOF
# }


# // codepipeline policy doc

# data "aws_iam_policy_document" "pipeline-policies" {
#   statement {
#     sid = ""
#     actions = [
#       "codestar-connections:UseConnection"
#     ]
#     resources = [
#       "*"
#     ]
#     effect = "Allow"
#   }

#   statement {
#     sid = ""
#     actions = [
#       "cloudwatch:*",
#       "s3:*",
#       "codebuild:*"
#     ]

#     resources = [
#       "*"
#     ]
#     effect = "Allow"
#   }
# }


# // iam role policy

# resource "aws_iam_policy" "pipeline-policy" {
#   name        = "pipeline-policy"
#   path        = "/"
#   description = "My pipeline policy"
#   policy      = data.aws_iam_policy_document.pipeline-policies.json
# }

# // policy attachment

# resource "aws_iam_policy_attachment" "pipeline-policy-attachement" {
#   name       = "pipeline-policy-attachement"
#   policy_arn = aws_iam_policy.pipeline-policy.arn
#   roles      = [aws_iam_role.codepipeline-role.name]
# }


# // codebuild role

# resource "aws_iam_role" "codebuild-role" {
#   name = "codebuild-role"

#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "codebuild.amazonaws.com"
#       },
#       "Action": "sts:AssumeRole"
#     }
#   ]
# }
# EOF
# }

# //codebuild policy document

# data "aws_iam_policy_document" "build-policies" {
#   statement {
#     sid = ""
#     actions = [
#       "logs:*",
#       "s3:*",
#       "codebuild:*",
#       "secretsmanager:*",
#       "iam:*"
#     ]
#     resources = [
#       "*"
#     ]
#     effect = "Allow"
#   }
# }


# // iam codebuild role policy

# resource "aws_iam_policy" "build-policy" {
#   name        = "build-policy"
#   path        = "/"
#   description = "My build policy"
#   policy      = data.aws_iam_policy_document.build-policies.json
# }

# // policy attachment

# resource "aws_iam_policy_attachment" "codebuild-policy-attachement1" {
#   name       = "codebuild-policy-attachement1"
#   policy_arn = aws_iam_policy.build-policy.arn
#   roles      = [aws_iam_role.codebuild-role.name]
# }



# resource "aws_iam_policy_attachment" "codebuild-policy-attachement2" {
#   name       = "codebuild-policy-attachement2"
#   policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
#   roles      = [aws_iam_role.codebuild-role.name]
# }



#----------------------------------------------------------------------------------------------


resource "aws_iam_role" "tf-codepipeline-role" {
  name = "tf-codepipeline-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

data "aws_iam_policy_document" "tf-cicd-pipeline-policies" {
    statement{
        sid = ""
        actions = ["codestar-connections:UseConnection"]
        resources = ["*"]
        effect = "Allow"
    }
    statement{
        sid = ""
        actions = ["cloudwatch:*", "s3:*", "codebuild:*"]
        resources = ["*"]
        effect = "Allow"
    }
}

resource "aws_iam_policy" "tf-cicd-pipeline-policy" {
    name = "tf-cicd-pipeline-policy"
    path = "/"
    description = "Pipeline policy"
    policy = data.aws_iam_policy_document.tf-cicd-pipeline-policies.json
}

resource "aws_iam_role_policy_attachment" "tf-cicd-pipeline-attachment" {
    policy_arn = aws_iam_policy.tf-cicd-pipeline-policy.arn
    role = aws_iam_role.tf-codepipeline-role.id
}


resource "aws_iam_role" "tf-codebuild-role" {
  name = "tf-codebuild-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Effect": "Allow",
    
    }
  ]
}
EOF

}

data "aws_iam_policy_document" "tf-cicd-build-policies" {
    statement{
        sid = ""
        actions = ["logs:*", "s3:*", "codebuild:*", "secretsmanager:*","iam:*"]
        resources = ["*"]
        effect = "Allow"
    }
}

resource "aws_iam_policy" "tf-cicd-build-policy" {
    name = "tf-cicd-build-policy"
    path = "/"
    description = "Codebuild policy"
    policy = data.aws_iam_policy_document.tf-cicd-build-policies.json
}

resource "aws_iam_role_policy_attachment" "tf-cicd-codebuild-attachment1" {
    policy_arn  = aws_iam_policy.tf-cicd-build-policy.arn
    role        = aws_iam_role.tf-codebuild-role.id
}

resource "aws_iam_role_policy_attachment" "tf-cicd-codebuild-attachment2" {
    policy_arn  = "arn:aws:iam::aws:policy/PowerUserAccess"
    role        = aws_iam_role.tf-codebuild-role.id
}