resource "aws_iam_user" "trino_glue_catalog_user" {
  name = "trino_glue_catalog"
}

resource "aws_iam_access_key" "trino_glue_catalog_access_key" {
  user = aws_iam_user.trino_glue_catalog_user.name
}

resource "aws_iam_user_policy" "trino_glue_catalog_policy" {
  name = "trino_glue_catalog_policy"
  user = aws_iam_user.trino_glue_catalog_user.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "glue:GetTables",
                "glue:GetTable",
                "glue:CreateTable",
                "glue:UpdateTable",
                "glue:BatchDeleteTable",
                "glue:DeleteTable",
                "glue:DeleteTableVersion",
                "glue:GetDatabases",
                "glue:GetDatabase",
                "glue:DeleteDatabase",
                "glue:CreateDatabase"
            ],
            "Resource": [
                "arn:aws:glue:*:${data.aws_caller_identity.current.account_id}:catalog",
                "arn:aws:glue:*:${data.aws_caller_identity.current.account_id}:catalog/*",
                "arn:aws:glue:*:${data.aws_caller_identity.current.account_id}:database/*",
                "arn:aws:glue:*:${data.aws_caller_identity.current.account_id}:table/*",
                "arn:aws:glue:*:${data.aws_caller_identity.current.account_id}:table/*/*",
                "arn:aws:glue:*:${data.aws_caller_identity.current.account_id}:userDefinedFunction/*/*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_user_policy" "trino_glue_s3_put_get_delete_policy" {
  name = "trino_glue_s3_put_get_delete_policy"
  user = aws_iam_user.trino_glue_catalog_user.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject"
            ],
            "Resource": [
                "arn:aws:s3:::data-lake-jho/*",
                "arn:aws:s3:::data-lake-jho/*/*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_user_policy" "trino_glue_s3_list_policy" {
  name = "trino_glue_s3_list_policy"
  user = aws_iam_user.trino_glue_catalog_user.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:PutBucketPublicAccessBlock",
                "s3:CreateBucket",
                "s3:ListBucket",
                "s3:GetBucketAcl",
                "s3:GetBucketLocation"
            ],
            "Resource": [
                "arn:aws:s3:::*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_user_policy" "trino_glue_s3_list_all_policy" {
  name = "trino_glue_s3_list_all_policy"
  user = aws_iam_user.trino_glue_catalog_user.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "s3:ListAllMyBuckets",
            "Resource": [
                "arn:aws:s3:::data-lake-jho/*",
                "arn:aws:s3:::data-lake-jho/*/*"
            ]
        }
    ]
}
EOF
}