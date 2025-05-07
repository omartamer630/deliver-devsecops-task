# IAM Role of Codepipeline
resource "aws_iam_role" "codepipeline-role" {
  name               = "pipeline-role"
  assume_role_policy = data.aws_iam_policy_document.assume-pipeline-role.json
  tags = {
    Env   = var.environment[0]
    Owner = var.environment[1]
  }
}

data "aws_iam_policy_document" "assume-pipeline-role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "codepipeline-policy" {
  statement {
    effect = "Allow"
    actions = [
      "s3:*"
    ]
    resources = [
      aws_s3_bucket.codepipeline_artifact_store.arn,
      "${aws_s3_bucket.codepipeline_artifact_store.arn}/*"
    ]
  }

  statement {
    effect    = "Allow"
    actions   = ["codestar-connections:UseConnection"]
    resources = [aws_codestarconnections_connection.github_connections_with_pipeline.arn]
  }

  statement {
    effect = "Allow"
    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "codepipeline-policy" {
  name   = "codepipeline-policy"
  role   = aws_iam_role.codepipeline-role.id
  policy = data.aws_iam_policy_document.codepipeline-policy.json
}

# IAM Role of Codebuild
resource "aws_iam_role" "codebuild-role" {
  name = "codebuild-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
  tags = {
    Env   = var.environment[0]
    Owner = var.environment[1]
  }
}

resource "aws_iam_role_policy" "codebuild_policy" {
  name = "codebuild-policy"
  role = aws_iam_role.codebuild-role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {

        Effect = "Allow"

        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
        }, {
        Effect = "Allow"
        Action = [
          "s3:*"
        ],
        Resource = "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "codepipeline:PutJobSuccessResult",
          "codepipeline:PutJobFailureResult",
          "codepipeline:GetJobDetails",
          "codepipeline:AcknowledgeJob"
        ],
        "Resource" : "*"
      },
      {
        Effect = "Allow"
        Action = [
          "codebuild:BatchGet*",
          "codebuild:StartBuild"
        ]
        Resource = "*"
        }, {
        Effect = "Allow",
        Action = [
          "iam:PassRole",
          "iam:GetRole",
          "iam:CreateRole",
          "iam:DeleteRole",
          "iam:PutRolePolicy",
          "iam:DeleteRolePolicy",
          "iam:ListRolePolicies",
          "iam:GetRolePolicy"
        ],
        Resource = "*"
      },
      {
      "Effect": "Allow",
      "Action": [
        "codeconnections:GetConnection"
      ],
      "Resource": "arn:aws:codestar-connections:us-east-1:022499038054:connection/a9d2b322-8c1a-4094-8a71-a75ddbaca357"
    }
    ]
  })
}
