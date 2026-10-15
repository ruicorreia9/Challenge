resource "aws_s3_bucket" "challenge_bucket" {
  bucket        = "challenge-irsa-bucket"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "challenge_bucket" {
  bucket                  = aws_s3_bucket.challenge_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "object_sample" {
  bucket  = aws_s3_bucket.challenge_bucket.id
  key     = "object_sample.txt"
  content = "Random object text!"
}

resource "aws_iam_policy" "podinfo_s3_policy" {
  name        = "podinfo-s3-access-policy"
  description = "Allows podinfo to read and write to the challenge S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:ListBucket"]
        Resource = aws_s3_bucket.challenge_bucket.arn
      },
      {
        Effect   = "Allow"
        Action   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
        Resource = "${aws_s3_bucket.challenge_bucket.arn}/*"
      }
    ]
  })
}

data "aws_iam_policy_document" "irsa_trust_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(var.cluster_oidc_issuer_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:web-production:podinfo-sa"]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.cluster_oidc_issuer_url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }

    principals {
      identifiers = [var.oidc_provider_arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "podinfo_irsa_role" {
  name               = "podinfo-irsa-s3-role"
  assume_role_policy = data.aws_iam_policy_document.irsa_trust_policy.json
}

resource "aws_iam_role_policy_attachment" "podinfo_s3_attach" {
  role       = aws_iam_role.podinfo_irsa_role.name
  policy_arn = aws_iam_policy.podinfo_s3_policy.arn
}

resource "kubernetes_service_account_v1" "podinfo_sa" {
  metadata {
    name      = "podinfo-sa"
    namespace = "web-production"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.podinfo_irsa_role.arn
    }
  }
}