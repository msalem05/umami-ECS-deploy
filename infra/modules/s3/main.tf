terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_kms_key" "state" {
  description = "KMS key for Terraform state bucket encryption"
  deletion_window_in_days = var.deletion_window
  enable_key_rotation = true
}

resource "aws_s3_bucket" "tf_state" {
  bucket              = var.bucket_name
  object_lock_enabled = true

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encrypt" {
  bucket = aws_s3_bucket.tf_state.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id =  aws_kms_key.state.arn
      sse_algorithm = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_versioning" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  versioning_configuration {
    status = "Enabled"
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_object_lock_configuration" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  rule {
    default_retention {
      mode = "GOVERNANCE"
      days = var.retention_days
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_kms_key" "alb_logs" {
  description = "KMS key for ALB Access Logs bucket encryption"
  deletion_window_in_days = var.deletion_window
  enable_key_rotation = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "alb_logs" {
  bucket = aws_s3_bucket.alb_access_logs.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id =  aws_kms_key.alb_logs.arn
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket" "alb_access_logs" {
  bucket = var.alb_logs_bucket_name

  lifecycle {
    prevent_destroy = true
  }
}

data "aws_caller_identity" "account" {

}

resource "aws_s3_bucket_policy" "alb_logs" {
  bucket = aws_s3_bucket.alb_access_logs.id 

  policy = jsonencode ({
    Version = "2012-10-17" 
    Statement = [
      {
        Sid = "ALBAccessLogsWrite"
        Effect = "Allow"
        Principal = {
          Service = "logdelivery.elasticloadbalancing.amazonaws.com"
        }
        Action = "s3:PutObject"
        Resource = "arn:aws:s3:::${aws_s3_bucket.alb_access_logs.bucket}/AWSLogs/${data.aws_caller_identity.account.account_id}/*"
      }
    ]
  })
}
