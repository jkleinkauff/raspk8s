resource "aws_s3_bucket" "logs" {
  bucket = "airbyte-jho-logs"

  tags = {
    Name = "airbyte"
  }

  force_destroy = true
}

resource "aws_s3_bucket_acl" "logs" {
  bucket = aws_s3_bucket.logs.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "logs" {
  bucket = aws_s3_bucket.logs.id

  versioning_configuration {
    status = "Enabled"
  }
}
