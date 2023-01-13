# terraform-aws-s3
This is a Terraform module for deploymnets of AWS S3 buckets.

## Using specific versions of this module
You can use versioned release tags to ensure that your project using this module does not break when this module is updated in the future.<br>

<b>Repo latest commit</b><br>
```
module "bucket" {
  source = "github.com/ataylor05/terraform-aws-s3"
  ...
```
<br><br>
<b>Tagged release</b><br>
```
module "iam" {
  source = "github.com/ataylor05/terraform-aws-s3?ref=1.0.0"
  ...
```

## Example of using this module
This is an example of using this module to create a bucket with versioning enabled.<br>

```
module "Bucket" {
  source            = "github.com/ataylor05/terraform-aws-s3?ref=1.0.4"
  bucket_name       = "vpc-flow-logs"
  enable_versioning = true
}
```
<br><br>
This is an example of using this module to create a bucket with a S3 bucket policy.<br>
```
module "Bucket" {
  source               = "github.com/ataylor05/terraform-aws-s3?ref=1.0.4"
  bucket_name          = "cloud-trail-logs"
  create_bucket_policy = true
  bucket_policy        = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck20150319",
            "Effect": "Allow",
            "Principal": {"Service": "cloudtrail.amazonaws.com"},
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::${local.cloud_trial_logs_bucket_name}"
        },
        {
            "Sid": "AWSCloudTrailWrite20150319",
            "Effect": "Allow",
            "Principal": {"Service": "cloudtrail.amazonaws.com"},
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${local.cloud_trial_logs_bucket_name}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
        }
    ]
}
POLICY
}
```

<br><br>
This is an example of using this module to create a bucket with a Life Cycle policy and is encrypted with a KMS key.<br>
```
module "Bucket" {
  source                        = "github.com/ataylor05/terraform-aws-s3?ref=1.0.5"
  bucket_name                   = "cloud-trail-logs"
  enable_server_side_encryption = true
  s3_kms_key_id                 = var.s3_kms_key_id
  create_lifecycle_policy       = true
  lifecycle_rules               = [
    { 
      id              = "logs", 
      status          = "Enabled" 
      expiration_days = 90
      filter_prefix   = "/"
      transitions     = [
        {
          days          = 30
          storage_class = "STANDARD_IA"
        },
        {
          days          = 60
          storage_class = "GLACIER"
        }
      ]
    }
  ]
}
```

<br><br>
Module can be tested locally:<br>
```
git clone https://github.com/ataylor05/terraform-aws-s3.git
cd terraform-aws-s3
terraform init
terraform apply
  -var="bucket_name=ataylor05-test-bucket"
```