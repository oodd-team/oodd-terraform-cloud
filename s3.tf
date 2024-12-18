data "aws_iam_policy_document" "allow_access_from_another_account" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      aws_s3_bucket.frontend_prod_bucket.arn,
      "${aws_s3_bucket.frontend_prod_bucket.arn}/*",
      aws_s3_bucket.frontend_dev_bucket.arn,
      "${aws_s3_bucket.frontend_dev_bucket.arn}/*",
    ]
  }
}

// Prod CloudFront bucket
resource "aws_s3_bucket" "frontend_prod_bucket" {
  bucket = "oodd.today"

  tags = {
    Name        = "prod-frontend-bucket"
    Environment = "prod"
  }
}

resource "aws_s3_bucket_policy" "prod_bucket_policy" {
  bucket = aws_s3_bucket.frontend_prod_bucket.id
  policy = <<POLICY
{
  "Id": "Policy1728830219292",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1728830216422",
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::oodd.today/*",
      "Principal": "*"
    }
  ]
}
POLICY
}

resource "aws_s3_bucket_ownership_controls" "prod_bucket_ownership_controls" {
  bucket = aws_s3_bucket.frontend_prod_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "prod_bucket_public_access_block" {
  bucket = aws_s3_bucket.frontend_prod_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "frontend_prod_bucket_website" {
  bucket = aws_s3_bucket.frontend_prod_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_acl" "frontend_prod_bucket_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.prod_bucket_ownership_controls,
    aws_s3_bucket_public_access_block.prod_bucket_public_access_block,
  ]

  bucket = aws_s3_bucket.frontend_prod_bucket.id
  acl    = "public-read"
}

// Dev CloudFront bucket
resource "aws_s3_bucket" "frontend_dev_bucket" {
  bucket = "dev.oodd.today"

  tags = {
    Name        = "dev-frontend-bucket"
    Environment = "dev"
  }
} 

resource "aws_s3_bucket_policy" "dev_bucket_policy" {
  bucket = aws_s3_bucket.frontend_dev_bucket.id
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1728830216422",
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::dev.oodd.today/*",
      "Principal": "*"
    }
  ]
}
POLICY
}

resource "aws_s3_bucket_ownership_controls" "dev_bucket_ownership_controls" {
  bucket = aws_s3_bucket.frontend_dev_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "dev_bucket_public_access_block" {
  bucket = aws_s3_bucket.frontend_dev_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "frontend_dev_bucket_website" {
  bucket = aws_s3_bucket.frontend_dev_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_acl" "frontend_dev_bucket_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.dev_bucket_ownership_controls,
    aws_s3_bucket_public_access_block.dev_bucket_public_access_block,
  ]

  bucket = aws_s3_bucket.frontend_dev_bucket.id
  acl    = "public-read"
}

# Server S3 bucket
resource "aws_s3_bucket" "api_bucket" {
  bucket = "oodd-api-bucket"

  tags = {
    Name        = "oodd-api-bucket"
    Environment = "prod"
  }
}


resource "aws_s3_bucket_ownership_controls" "api_bucket_ownership_controls" {
  bucket = aws_s3_bucket.api_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "api_bucket_public_access_block" {
  bucket = aws_s3_bucket.api_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_s3_bucket_acl" "api_bucket_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.api_bucket_ownership_controls,
    aws_s3_bucket_public_access_block.api_bucket_public_access_block,
  ]

  bucket = aws_s3_bucket.api_bucket.id
  acl    = "private"
}