provider "aws" {
  region = var.region
}


//IAM role for codepipeline


resource "aws_iam_role" "codepipeline-role" {
   name = "codepipeline-role"


   assume_role_policy = <<EOF
 {
   "Version": "2012-10-17",
   "Statement": [
     {
      "Effect": "Allow",
       "Principal": {
         "Service": "codepipeline.amazonaws.com"
       },
       "Action": "sts:AssumeRole"
     }
   ]
 }
 EOF
 }


 // codepipeline policy doc

 data "aws_iam_policy_document" "pipeline-policies" {
  statement {
     sid = ""
     actions = [
       "codestar-connections:UseConnection"
     ]
     resources = [
       "*"
     ]
     effect = "Allow"
   }

   statement {
     sid = ""
     actions = [
       "cloudwatch:*",
       "s3:*",
       "codebuild:*"
     ]

     resources = [
       "*"
     ]
     effect = "Allow"
   }
 }


 // iam role policy

 resource "aws_iam_policy" "pipeline-policy" {
   name        = "pipeline-policy"
   path        = "/"
   description = "My pipeline policy"
   policy      = data.aws_iam_policy_document.pipeline-policies.json
 }

 // policy attachment

 resource "aws_iam_policy_attachment" "pipeline-policy-attachement" {
   name       = "pipeline-policy-attachement"
   policy_arn = aws_iam_policy.pipeline-policy.arn
   roles      = [aws_iam_role.codepipeline-role.name]
 }


 // codebuild role

 resource "aws_iam_role" "codebuild-role" {
   name = "codebuild-role"

   assume_role_policy = <<EOF
 {
   "Version": "2012-10-17",
   "Statement": [
     {
       "Effect": "Allow",
       "Principal": {
         "Service": "codebuild.amazonaws.com"
       },
       "Action": "sts:AssumeRole"
     }
   ]
 }
 EOF
 }

 //codebuild policy document

 data "aws_iam_policy_document" "build-policies" {
   statement {
     sid = ""
     actions = [
       "logs:*",
       "s3:*",
       "codebuild:*",
       "secretsmanager:*",
       "iam:*"
     ]
     resources = [
       "*"
     ]
     effect = "Allow"
   }
 }


 // iam codebuild role policy

 resource "aws_iam_policy" "build-policy" {
   name        = "build-policy"
   path        = "/"
   description = "My build policy"
   policy      = data.aws_iam_policy_document.build-policies.json
 }

 // policy attachment

 resource "aws_iam_policy_attachment" "codebuild-policy-attachement1" {
   name       = "codebuild-policy-attachement1"
   policy_arn = aws_iam_policy.build-policy.arn
   roles      = [aws_iam_role.codebuild-role.name]
 }



 resource "aws_iam_policy_attachment" "codebuild-policy-attachement2" {
   name       = "codebuild-policy-attachement2"
   policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
   roles      = [aws_iam_role.codebuild-role.name]
 }



