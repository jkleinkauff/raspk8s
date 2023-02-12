data "aws_iam_policy_document" "airbyte_s3_logs" {
  statement {
    sid = "AirbyteS3ReadWrite"

    actions = [
      "s3:ListBucket",
      "s3:GetObject*",
      "s3:PutObject*",
    ]

    resources = [
      resource.aws_s3_bucket.logs.arn,
      "${resource.aws_s3_bucket.logs.arn}/*",
    ]
  }
}

resource "aws_iam_user" "airbyte" {
  name = "airbyte-user-logs"
}

resource "aws_iam_access_key" "airbyte" {
  user = aws_iam_user.airbyte.name
}


resource "aws_iam_user_policy" "airbyte_s3_logs_policy" {
  name   = "airbyte_bucket_logs"
  user   = aws_iam_user.airbyte.name
  policy = data.aws_iam_policy_document.airbyte_s3_logs.json
}