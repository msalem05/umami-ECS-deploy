output "bucket_name" {
  description = "Name of S3 bucket used for Terraform State"
  value       = aws_s3_bucket.tf_state
}

output "alb_logs_bucket" {
  value = aws_s3_bucket.alb_access_logs.bucket
}