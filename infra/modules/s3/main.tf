resource "aws_s3_bucket" "tf_state" {
    bucket = var.bucket_name
    object_lock_enabled = true
}

resource "aws_s3_bucket_versioning" "tf_state" {
    bucket = aws_s3_bucket.tf_state.id

    versioning_configuration {
      status = "Enabled"
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

}