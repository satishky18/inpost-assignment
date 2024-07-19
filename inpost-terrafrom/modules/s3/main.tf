resource "aws_s3_bucket" "storage" {
  bucket = var.s3_bucket_name
}

resource "aws_s3_bucket_ownership_controls" "main" {
  bucket = aws_s3_bucket.storage.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "main" {
  depends_on = [aws_s3_bucket_ownership_controls.main]

  bucket = aws_s3_bucket.storage.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket                  = aws_s3_bucket.storage.id
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}
