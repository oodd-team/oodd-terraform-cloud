// Prod bucket
resource "aws_s3_bucket" "frontend_prod_bucket" {
  bucket = "oodd.today"

  tags = {
    Name        = "prod-frontend-bucket"
    Environment = "prod"
  }
}

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
    ]
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

# CloudFront 설정
resource "aws_cloudfront_distribution" "frontend_prod_cf" {
  origin {
    domain_name = aws_s3_bucket.frontend_prod_bucket.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.frontend_prod_bucket.id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "oodd prod cloudfront distribution"
  default_root_object = "index.html"

  aliases = ["oodd.today", "www.oodd.today"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.frontend_prod_bucket.id

    forwarded_values {
      query_string = true

      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  custom_error_response {
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 10
  }

  custom_error_response {
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 10
  }

  # 지리적 제한: 특정 국가에서만 접근하도록 화이트리스트 작성
  restrictions {
    geo_restriction {
      restriction_type = "none"
      # locations        = ["US", "CA", "GB", "DE"]
    }
  }
  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.prod_cert.arn
    ssl_support_method       = "sni-only"     # SNI 기반 SSL 인증서 사용
    minimum_protocol_version = "TLSv1.2_2018" # 최소 SSL/TLS 버전
  }
  tags = {
    Name        = "prod-cloudfront"
    Environment = "prod"
  }
}