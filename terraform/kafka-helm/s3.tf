resource "aws_s3_bucket" "sink-bucket" {
  bucket = "jhodb-sink-s3"

  tags = {
    Name      = "jhodb-sink-s3"
    raspberry = true
  }

  force_destroy = true
}

resource "aws_s3_bucket_acl" "sink-bucket" {
  bucket = aws_s3_bucket.sink-bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "sink-bucket" {
  bucket = aws_s3_bucket.sink-bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}