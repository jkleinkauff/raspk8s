resource "aws_iam_user" "airflow" {
  name = "airflow-iam-user"
}

resource "aws_iam_access_key" "airflow" {
  user = aws_iam_user.airflow.name
}

data "aws_iam_policy_document" "access_s3_read_write" {
  statement {
    sid = "S3ReadWrite"

    actions = [
      "s3:ListBucket",
      "s3:GetObject*",
      "s3:PutObject*",
    ]

    resources = [
      "arn:aws:s3:::rpi-airflow-logs/*",
    ]
  }
}

resource "aws_iam_user_policy" "access_s3_read_write" {
  name   = "S3_Read_Write"
  user   = aws_iam_user.airflow.name
  policy = data.aws_iam_policy_document.access_s3_read_write.json
}