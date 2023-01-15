resource "aws_iam_user" "sink-s3" {
  name = "kafka-connect-sink-s3"
}

resource "aws_iam_access_key" "sink-s3" {
  user = aws_iam_user.sink-s3.name
}

resource "aws_iam_user_policy" "sink-s3" {
  name = "sink-s3-user-policy"
  user = aws_iam_user.sink-s3.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:*",
        ]
        Effect = "Allow"
        "Resource" : "${aws_s3_bucket.sink-bucket.arn}/*"
      },
    ]
  })
}


resource "kubernetes_secret" "aws-secret" {
  metadata {
    namespace = kubernetes_namespace.kafka.metadata.0.name
    name      = "aws-creds"
  }

  type = "Opaque"

  data = {
    awsAccessKey       = aws_iam_access_key.sink-s3.id
    awsSecretAccessKey = aws_iam_access_key.sink-s3.secret
  }
}