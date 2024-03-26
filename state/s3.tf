resource "aws_s3_bucket" "tf-state" {
  bucket = "let-code-speak-for-itself-state-db.ap-southeast-2.terraform"
  acl    = "private"

  tags = {
    Name        = "let-code-speak-for-itself-state-db.ap-southeast-2.terraform"
    Environment = var.env
  }

}

resource "aws_s3_bucket_versioning" "versioning_tf-state" {
  bucket = aws_s3_bucket.tf-state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3bucketkey" {
  bucket = aws_s3_bucket.tf-state.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.mykey.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_kms_key" "mykey" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}