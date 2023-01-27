resource "aws_s3_bucket" "logs" {
  bucket = "rpi-airflow-logs"

  tags = {
    Name      = "rpi-airflow-logs"
    raspberry = true
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