data "aws_caller_identity" "current" {}

data "aws_ami" "default_ami" {
    most_recent      = true
    name_regex       = "amzn2-ami-hvm-2.0.\\d{8}-x86_64-gp2"
    owners           = ["amazon"]
    filter {
      name = "name"
      values = ["amzn2-ami-hvm-2*"]
    }
    filter {
      name = "root-device-type"
      values = ["ebs"]
    }
    filter {
      name = "architecture"
     values = ["x86_64"]
    }
    filter {
      name = "virtualization-type"
      values = ["hvm"]
    }
}

# --------------
# Golden Image Bucket and Packer Archive
# --------------
resource "aws_s3_bucket" "golden_image_bucket" {
    bucket_prefix       = "golden-image-bucket"
    acl                 = "private"
    force_destroy       = true
    tags                = {
      Environment       = var.environment
      CostCenter        = var.cost_center
    }
    versioning {
      enabled           = true
    }
    server_side_encryption_configuration {
      rule {
        apply_server_side_encryption_by_default {
          sse_algorithm  = "aws:kms"
        }
      }
    }
}

resource "aws_s3_bucket_object" "build_spec_file" {
    bucket = aws_s3_bucket.golden_image_bucket.id
    key    = "source/buildspec.zip"
    source = "../files/packer/buildspec.zip"
    #etag   = "${md5(file("../files/packer/buildspec.zip"))}"
}

resource "aws_ssm_parameter" "cloudwatch_logs_configuration_parameter" {
    name  = "cloudwatch-logs-configuration"
    type  = "String"
    value = <<EOF
{
        "logs": {
                "logs_collected": {
                        "files": {
                                "collect_list": [
                                        {
                                                "file_path": "/var/log/secure",
                                                "log_group_name": "secure",
                                                "log_stream_name": "{instance_id}"
                                        },
                                        {
                                                "file_path": "/var/log/messages",
                                                "log_group_name": "messages",
                                                "log_stream_name": "{instance_id}"
                                        }
                                ]
                        }
                }
        },
        "metrics": {
                "append_dimensions": {
                        "AutoScalingGroupName": "$${aws:AutoScalingGroupName}",
                        "ImageId": "$${aws:ImageId}",
                        "InstanceId": "$${aws:InstanceId}",
                        "InstanceType": "$${aws:InstanceType}"
                },
                "metrics_collected": {
                        "mem": {
                                "measurement": [
                                        "mem_used_percent"
                                ],
                                "metrics_collection_interval": 60
                        },
                        "statsd": {
                                "metrics_aggregation_interval": 60,
                                "metrics_collection_interval": 10,
                                "service_address": ":8125"
                        },
                        "swap": {
                                "measurement": [
                                        "swap_used_percent"
                                ],
                                "metrics_collection_interval": 60
                        }
                }
        }
}
EOF
}


# --------------
# CodeBuild-Packer Resources
# --------------
resource "aws_iam_role" "codebuild_packer_service_role" {
    name = "CodeBuild-Packer-Service-Role"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "codebuild_packer_service_role_policy" {
    name        = "CodeBuild-Packer-Service-Role-Policy"
    path        = "/"
    description = "Permissions for CodeBuild to use Packer in a VPC."
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Resource": [
                "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/Golden-Image-Project:log-stream:*"
            ],
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ]
        },
        {
            "Effect": "Allow",
            "Resource": [
                "${aws_s3_bucket.golden_image_bucket.arn}*"
            ],
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:GetObjectVersion",
                "s3:GetBucketAcl",
                "s3:GetBucketLocation",
                "s3:ListBucket",
                "s3:GetBucketAcl",
                "s3:GetBucketLocation"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:AttachVolume",
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:CopyImage",
                "ec2:CreateImage",
                "ec2:CreateKeypair",
                "ec2:CreateSecurityGroup",
                "ec2:CreateSnapshot",
                "ec2:CreateTags",
                "ec2:CreateVolume",
                "ec2:DeleteKeyPair",
                "ec2:DeleteSecurityGroup",
                "ec2:DeleteSnapshot",
                "ec2:DeleteVolume",
                "ec2:DeregisterImage",
                "ec2:DescribeImageAttribute",
                "ec2:DescribeImages",
                "ec2:DescribeInstances",
                "ec2:DescribeInstanceStatus",
                "ec2:DescribeRegions",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeSnapshots",
                "ec2:DescribeSubnets",
                "ec2:DescribeTags",
                "ec2:DescribeVolumes",
                "ec2:DetachVolume",
                "ec2:GetPasswordData",
                "ec2:ModifyImageAttribute",
                "ec2:ModifyInstanceAttribute",
                "ec2:ModifySnapshotAttribute",
                "ec2:RegisterImage",
                "ec2:RunInstances",
                "ec2:StopInstances",
                "ec2:TerminateInstances",
                "ec2:CreateNetworkInterface",
                "ec2:DescribeDhcpOptions",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DeleteNetworkInterface",
                "ec2:DescribeSubnets",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeVpcs"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:CreateNetworkInterfacePermission"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "iam:PassRole",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ssm:DescribeParameters",
                "ssm:GetParameters",
                "ssm:GetParameter"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_policy_attachment" "codebuild_packer_service_role_policy_attachment" {
    name       = "CodeBuild-Packer-Service-Role-Policy-Attachment"
    roles      = [aws_iam_role.codebuild_packer_service_role.name]
    policy_arn = aws_iam_policy.codebuild_packer_service_role_policy.arn
}

resource "aws_security_group" "golden_image_sg" {
    name          = "Golden-Image-SG"
    description   = "Golden Image Access Security Group"
    vpc_id        = var.codebuild_vpc_id
    ingress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
    tags {
      CostCenter  = var.cost_center
      Environment = var.environment
    }
}

resource "aws_codebuild_project" "golden_image_codebuild_project" {
    name          = "Golden-Image-Project"
    description   = "AMI Builder to create a Golden Image"
    build_timeout = "30"
    service_role  = aws_iam_role.codebuild_packer_service_role.arn
    artifacts {
      type = "NO_ARTIFACTS"
    }
    environment {
      compute_type                = "BUILD_GENERAL1_SMALL"
      image                       = "aws/codebuild/standard:1.0"
      type                        = "LINUX_CONTAINER"
    }
    source {
      type            = "S3"
      location        = "${aws_s3_bucket.golden_image_bucket.id}/${aws_s3_bucket_object.build_spec_file.id}"
    }
    vpc_config {
      vpc_id = var.codebuild_vpc_id
      subnets = [
        var.codebuild_subnet
      ]
      security_group_ids = [
        aws_security_group.golden_image_sg.id
      ]
    }
    tags = {
      CostCenter = var.cost_center
      Environment = var.environment
    }
}

resource "aws_ssm_parameter" "amazon_linux_packer_template_parameter" {
    name  = "amazon-linux-packer-template"
    type  = "String"
    value = <<EOF
{
    "builders": [
      {
        "type": "amazon-ebs",
        "vpc_id": "${var.codebuild_vpc_id}",
        "subnet_id": "${var.codebuild_subnet}",
        "region": "${var.region}",
        "ami_name": "Custom_EC2_Image",
        "ami_description": "Customized AMZN 2 Linux",
        "force_deregister": true,
        "force_delete_snapshot": true,
        "instance_type": "t3.small",
        "iam_instance_profile": "EC2-Instance-Profile",
        "associate_public_ip_address": true,
        "security_group_id": "${aws_security_group.golden_image_sg.id}",
        "shutdown_behavior": "terminate",
        "ssh_username": "ec2-user",
        "ssh_interface": "private_ip",
        "source_ami_filter": {
            "filters": {
              "architecture": "x86_64",
              "virtualization-type": "hvm",
              "name": "amzn2-ami-hvm-2*",
              "root-device-type": "ebs"
            },
            "owners": "amazon",
            "most_recent": true
        }
      }
    ],
  
    "provisioners": [
      {
        "type": "shell",
        "inline": [
            "sudo yum update -y",
            "sudo yum install httpd mod_ssl wget git -y",
            "sudo systemctl start httpd",
            "sudo systemctl enable httpd",
            "cd /tmp",
            "wget https://inspector-agent.amazonaws.com/linux/latest/install",
            "sudo bash install",
            "sudo rpm -i https://s3.amazonaws.com/amazoncloudwatch-agent/redhat/amd64/latest/amazon-cloudwatch-agent.rpm",
            "sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c ssm:${aws_ssm_parameter.cloudwatch_logs_configuration_parameter.name} -s",
            "sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm"
        ]
      }
    ]
}
EOF
}



# --------------
# CodePipeline-Packer Resources
# --------------
resource "aws_iam_role" "codepipeline_packer_service_role" {
    name = "CodePipeline-Packer-Service-Role"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "codepipeline_packer_policy" {
    name = "CodePipeline-Packer-Policy"
    policy = <<EOF
{
    "Statement": [
        {
            "Action": [
                "iam:PassRole"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "s3:*"
            ],
            "Resource": "${aws_s3_bucket.golden_image_bucket.arn}*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "lambda:InvokeFunction",
                "lambda:ListFunctions"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "codebuild:BatchGetBuilds",
                "codebuild:StartBuild"
            ],
            "Resource": "*",
            "Effect": "Allow"
        }
    ],
    "Version": "2012-10-17"
}
EOF
}

resource "aws_iam_role_policy_attachment" "codepipeline_packer_policy_attachment" {
    role       = aws_iam_role.codepipeline_packer_service_role.name
    policy_arn = aws_iam_policy.codepipeline_packer_policy.arn
}

resource "aws_codepipeline" "golden_image_pipeline" {
    depends_on = ["aws_codebuild_project.golden_image_codebuild_project"]
    name     = "Golden-Image-Pipeline"
    role_arn = aws_iam_role.codepipeline_packer_service_role.arn
    artifact_store {
      location = aws_s3_bucket.golden_image_bucket.bucket
      type     = "S3"
    }
    
    stage {
      name = "Source"
      action {
        name             = "Source"
        category         = "Source"
        owner            = "AWS"
        provider         = "S3"
        version          = "1"
        output_artifacts = ["ami_build"]
        run_order = "1"
        configuration = {
          S3Bucket    = aws_s3_bucket.golden_image_bucket.bucket
          S3ObjectKey = aws_s3_bucket_object.build_spec_file.key
        }
      }
    }

    stage {
      name = "Build"
      action {
        name            = "Build-Custom-AMI"
        category        = "Build"
        owner           = "AWS"
        provider        = "CodeBuild"
        input_artifacts = ["ami_build"]
        version         = "1"
        run_order = "1"
        configuration = {
          ProjectName = "Golden-Image-Project"
        }
      }
    }

    stage {
      name = "Update-Functions"
      action {
        name            = "Write-AMI-ID-to-Paramstore"
        category        = "Invoke"
        owner           = "AWS"
        provider        = "Lambda"
        input_artifacts = ["ami_build"]
        version         = "1"
        run_order = "1"
        configuration = {
          FunctionName = aws_lambda_function.codepipeline_write_new_ami_parameter.function_name
        }
      }

      action {
        name            = "Update-Launch-Template"
        category        = "Invoke"
        owner           = "AWS"
        provider        = "Lambda"
        input_artifacts = ["ami_build"]
        version         = "1"
        run_order = "2"
        configuration = {
          FunctionName = aws_lambda_function.update_launch_template.function_name
        }
      }
    }
}



# --------------
# Lambda Resources
# --------------
resource "aws_iam_role" "lambda_ssm_execution_role" {
    name = "Lambda-SSM-Automation-Role"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service":[
               "lambda.amazonaws.com",
               "ssm.amazonaws.com"
            ]
        },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda_ssm_execution_policy" {
    name = "Lambda-SSM-Execution-Policy"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "iam:PassRole",
                "iam:GetRole"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "logs:CreateLogGroup",
            "Resource": "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "ssm:DescribeParameters",
                "ssm:GetParameters",
                "ssm:GetParameter",
                "ssm:PutParameter",
                "ssm:DescribeAutomationExecutions",
                "ssm:DescribeInstanceInformation",
                "ssm:DescribeAutomationStepExecutions",
                "ssm:StopAutomationExecution",
                "ssm:SendAutomationSignal",
                "ssm:GetAutomationExecution",
                "ssm:StartAutomationExecution",
                "ssm:SendCommand",
                "ssm:ListCommands",
                "ssm:ListCommandInvocations"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:AttachVolume",
                "ec2:DeregisterImage",
                "ec2:DescribeImages",
                "ec2:DescribeImageAttribute",
                "ec2:DescribeInstances",
                "ec2:DescribeInstanceAttribute",
                "ec2:DescribeRegions",
                "ec2:CreateImage",
                "ec2:DeleteVolume",
                "ec2:GetLaunchTemplateData",
                "ec2:DescribeVolumeStatus",
                "ec2:CreateNetworkInterface",
                "ec2:DeleteNetworkInterface",
                "ec2:DetachNetworkInterface",
                "ec2:DeleteNetworkInterfacePermission",
                "ec2:DescribeNetworkInterfaces",
                "ec2:CreateNetworkInterfacePermission",
                "ec2:ModifyNetworkInterfaceAttribute",
                "ec2:AttachNetworkInterface",
                "ec2:StartInstances",
                "ec2:DescribeNetworkInterfaceAttribute",
                "ec2:DescribeVolumes",
                "ec2:DescribeNetworkInterfacePermissions",
                "ec2:DescribeKeyPairs",
                "ec2:DescribeInstanceStatus",
                "ec2:DetachVolume",
                "ec2:TerminateInstances",
                "ec2:DescribeIamInstanceProfileAssociations",
                "ec2:DescribeTags",
                "ec2:RegisterImage",
                "ec2:RunInstances",
                "ec2:AssignPrivateIpAddresses",
                "ec2:StopInstances",
                "ec2:DescribeVolumeAttribute",
                "ec2:DescribeSecurityGroups",
                "ec2:CreateVolume",
                "ec2:CreateNetworkInterface",
                "ec2:DescribeImages",
                "ec2:DescribeVpcs",
                "ec2:DescribeImageAttribute",
                "ec2:DescribeVpcEndpoints",
                "ec2:DescribeSubnets",
                "ec2:AssociateIamInstanceProfile",
                "ec2:ModifyImageAttribute",
                "ec2:DescribeLaunchTemplates",
                "ec2:DescribeLaunchTemplateVersions",
                "ec2:CreateLaunchTemplateVersion",
                "ec2:GetLaunchTemplateData",
                "ec2:ModifyLaunchTemplate",
                "ec2:DeleteLaunchTemplateVersions"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "codepipeline:PollForJobs",
                "codepipeline:PutJobFailureResult",
                "codepipeline:PutJobSuccessResult",
                "codepipeline:AcknowledgeJob",
                "codepipeline:GetJobDetails"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "lambda:InvokeFunction"
            ],
            "Resource": [
              "${aws_lambda_function.ssm_write_custom_ami_paramstore.arn}",
              "${aws_lambda_function.update_launch_template.arn}"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_ssm_execution_policy_attachment" {
    role       = aws_iam_role.lambda_ssm_execution_role.name
    policy_arn = aws_iam_policy.lambda_ssm_execution_policy.arn
}

resource "aws_security_group" "lambda_sg" {
    name        = "Lambda-VPC-Access-SG"
    description = "Lambda VPC Access Security Group"
    vpc_id      = var.codebuild_vpc_id
    egress {
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      cidr_blocks     = ["0.0.0.0/0"]
    }
    tags {
      CostCenter = var.cost_center
      Environment = var.environment
    }
}

resource "aws_lambda_function" "codepipeline_write_new_ami_parameter" {
    function_name    = "CodePipeline-Write-New-AMI-Parameter"
    filename         = "../files/lambda/CodePipeline-Write-New-AMI-Parameter.zip"
    source_code_hash = base64sha256(file("../files/lambda/CodePipeline-Write-New-AMI-Parameter.zip"))
    role             = aws_iam_role.lambda_ssm_execution_role.arn
    handler          = "CodePipeline-Write-New-AMI-Parameter.lambda_handler"
    runtime          = "python3.7"
    timeout = 300
    vpc_config = {
      subnet_ids = [var.lambda_subnet]
      security_group_ids = [aws_security_group.lambda_sg.id]
    }
}

resource "aws_lambda_function" "ssm_write_custom_ami_paramstore" {
    function_name    = "SSM-Write-Custom-AMI"
    filename         = "../files/lambda/Update-Custom-AMI-ParamStore.zip"
    source_code_hash = base64sha256(file("../files/lambda/Update-Custom-AMI-ParamStore.zip"))
    role             = aws_iam_role.lambda_ssm_execution_role.arn
    handler          = "Update-Custom-AMI-ParamStore.lambda_handler"
    runtime          = "python3.7"
    timeout = 300
    vpc_config = {
      subnet_ids = [var.lambda_subnet]
      security_group_ids = [aws_security_group.lambda_sg.id]
    }
}

resource "aws_cloudwatch_log_group" "codepipeline_write_new_ami_parameter_log_group" {
    name              = "/aws/lambda/${aws_lambda_function.codepipeline_write_new_ami_parameter.function_name}"
    retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "ssm_write_custom_ami_paramstore_log_group" {
    name              = "/aws/lambda/${aws_lambda_function.ssm_write_custom_ami_paramstore.function_name}"
    retention_in_days = 30
}

resource "aws_lambda_function" "start_custom_ami_patching_job" {
    function_name    = "Start-Custom-AMI-Patching"
    filename         = "../files/lambda/Start-Custom-AMI-Patching.zip"
    source_code_hash = base64sha256(file("../files/lambda/Start-Custom-AMI-Patching.zip"))
    role             = aws_iam_role.lambda_ssm_execution_role.arn
    handler          = "Start-Custom-AMI-Patching.lambda_handler"
    runtime          = "python3.7"
    timeout = 300
    vpc_config = {
      subnet_ids = [var.lambda_subnet]
      security_group_ids = [aws_security_group.lambda_sg.id]
    }
}

resource "aws_cloudwatch_log_group" "start_custom_ami_patching_job_log_group" {
    name              = "/aws/lambda/${aws_lambda_function.start_custom_ami_patching_job.function_name}"
    retention_in_days = 30
}

resource "aws_cloudwatch_event_rule" "start_custom_ami_patching_job_trigger" {
    name        = "start-custom-ami-patching-job-trigger"
    description = "Starts the AWS Automation job to patch the custom AMI"
    schedule_expression  = "cron(30 7 1 * ? *)"
}

resource "aws_cloudwatch_event_target" "lambda_target" {
    rule      = aws_cloudwatch_event_rule.start_custom_ami_patching_job_trigger.name
    target_id = "SendToLambda"
    arn       = aws_lambda_function.start_custom_ami_patching_job.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_trigger" {
    statement_id  = "AllowExecutionFromCloudWatch"
    action        = "lambda:InvokeFunction"
    function_name = aws_lambda_function.start_custom_ami_patching_job.function_name
    principal     = "events.amazonaws.com"
    source_arn    = aws_cloudwatch_event_rule.start_custom_ami_patching_job_trigger.arn
    qualifier     = aws_lambda_alias.allow_cloudwatch_trigger_alias.name
}

resource "aws_lambda_alias" "allow_cloudwatch_trigger_alias" {
    name             = "allow_cloudwatch_trigger_alias"
    function_name    = aws_lambda_function.start_custom_ami_patching_job.function_name
    function_version = "$LATEST"
}

resource "aws_lambda_function" "update_launch_template" {
    function_name    = "Update-Launch-Template"
    filename         = "../files/lambda/Update-Launch-Template.zip"
    source_code_hash = base64sha256(file("../files/lambda/Update-Launch-Template.zip"))
    role             = aws_iam_role.lambda_ssm_execution_role.arn
    handler          = "Update-Launch-Template.lambda_handler"
    runtime          = "python3.7"
    timeout = 300
    vpc_config = {
      subnet_ids = [var.lambda_subnet]
      security_group_ids = [aws_security_group.lambda_sg.id]
    }
}

resource "aws_cloudwatch_log_group" "update_launch_template_log_group" {
    name              = "/aws/lambda/${aws_lambda_function.update_launch_template.function_name}"
    retention_in_days = 30
}


# --------------
# SSM Automatic AMI Patching task
# --------------
resource "aws_ssm_document" "patch_linux_ami" {
    name          = "Patch-Linux-AMI"
    document_type = "Automation"
    document_format = "YAML"
    content = <<DOC
---
schemaVersion: '0.3'
description: Updates AMI with Linux distribution packages and Amazon software. For
  details,see https://docs.aws.amazon.com/systems-manager/latest/userguide/automation-awsdocs-linux.html
assumeRole: "{{AutomationAssumeRole}}"
parameters:
  SubnetId:
    type: String
    description: "Subnet to run the AMI patching in."
    default: subnet-060f4439f31d1126c
  SecurityGroupId:
    type: String
    description: "Security Group to apply to the instance."
    default: sg-0a6a5d0585ffaab01
  SourceAmiId:
    type: String
    description: "(Required) The source Amazon Machine Image ID."
    default: ami-0ea01c14981ba35d7
  IamInstanceProfileName:
    type: String
    description: "The instance profile that enables Systems Manager (SSM)
      to manage the instance."
    default: EC2-Instance-Profile
  AutomationAssumeRole:
    type: String
    description: "The ARN of the role that allows Automation to perform
      the actions on your behalf."
    default: arn:aws:iam::{{global:ACCOUNT_ID}}:role/SSM-Service-Role
  TargetAmiName:
    type: String
    description: "(Optional) The name of the new AMI that will be created. Default
      is a system-generated string including the source AMI id, and the creation time
      and date."
    default: Custom-AMI-{{global:DATE_TIME}}
  PreUpdateScript:
    type: String
    description: (Optional) URL of a script to run before updates are applied. Default
      ("none") is to not run a script.
    default: none
  PostUpdateScript:
    type: String
    description: (Optional) URL of a script to run after package updates are applied.
      Default ("none") is to not run a script.
    default: none
  IncludePackages:
    type: String
    description: (Optional) Only update these named packages. By default ("all"),
      all available updates are applied.
    default: all
  ExcludePackages:
    type: String
    description: (Optional) Names of packages to hold back from updates, under all
      conditions. By default ("none"), no package is excluded.
    default: none
  LambdaUpdateFunction:
    type: String
    description: Lambda function to update latest_ami_id.
    default: SSM-Write-Custom-AMI
mainSteps:
- name: launchInstance
  action: aws:runInstances
  maxAttempts: 3
  timeoutSeconds: 300
  onFailure: Abort
  inputs:
    ImageId: "{{SourceAmiId}}"
    InstanceType: "t3.medium"
    SubnetId: "{{SubnetId}}"
    MinInstanceCount: 1
    MaxInstanceCount: 1
    IamInstanceProfileName: "{{IamInstanceProfileName}}"
    TagSpecifications: 
      - Key: Name
        Value: SSM-Patching-Instance
- name: verifySsmInstall
  action: aws:runCommand
  maxAttempts: 3
  timeoutSeconds: 300
  onFailure: Abort
  inputs:
    DocumentName: AWS-RunShellScript
    InstanceIds:
    - "{{launchInstance.InstanceIds}}"
    Parameters:
      commands:
      - hostname
- name: updateOSSoftware
  action: aws:runCommand
  maxAttempts: 3
  timeoutSeconds: 600
  onFailure: Abort
  inputs:
    DocumentName: AWS-RunShellScript
    InstanceIds:
    - "{{launchInstance.InstanceIds}}"
    Parameters:
      commands:
      - set -e
      - '[ -x "$(which wget)" ] && get_contents=''wget $1 -O -'''
      - '[ -x "$(which curl)" ] && get_contents=''curl -s -f $1'''
      - if [[ {{global:REGION}} == 'us-gov-'* ]]
      - then
      - eval $get_contents https://s3-fips-{{global:REGION}}.amazonaws.com/aws-ssm-downloads-{{global:REGION}}/scripts/aws-update-linux-instance
        > /var/lib/amazon/ssm/aws-update-linux-instance
      - elif [[ {{global:REGION}} == 'cn-'* ]]
      - then
      - eval $get_contents https://aws-ssm-downloads-{{global:REGION}}.s3.{{global:REGION}}.amazonaws.com.cn/scripts/aws-update-linux-instance
        > /var/lib/amazon/ssm/aws-update-linux-instance
      - else
      - eval $get_contents https://aws-ssm-downloads-{{global:REGION}}.s3.amazonaws.com/scripts/aws-update-linux-instance
        > /var/lib/amazon/ssm/aws-update-linux-instance
      - fi
      - chmod +x /var/lib/amazon/ssm/aws-update-linux-instance
      - "/var/lib/amazon/ssm/aws-update-linux-instance --pre-update-script '{{PreUpdateScript}}'
        --post-update-script '{{PostUpdateScript}}' --include-packages '{{IncludePackages}}'
        --exclude-packages '{{ExcludePackages}}' 2>&1 | tee /tmp/aws-update-linux-instance.log"
      - rm -rf /var/lib/amazon/ssm/aws-update-linux-instance
- name: stopInstance
  action: aws:changeInstanceState
  maxAttempts: 3
  timeoutSeconds: 300
  onFailure: Abort
  inputs:
    InstanceIds:
    - "{{launchInstance.InstanceIds}}"
    DesiredState: stopped
- name: createImage
  action: aws:createImage
  maxAttempts: 3
  timeoutSeconds: 300
  onFailure: Abort
  inputs:
    InstanceId: "{{launchInstance.InstanceIds}}"
    ImageName: "{{TargetAmiName}}"
    NoReboot: true
    ImageDescription: AMI Generated by EC2 Automation on {{global:DATE_TIME}} from
      {{SourceAmiId}}
- name: deleteSourceImage
  action: aws:deleteImage
  maxAttempts: 3
  timeoutSeconds: 300
  onFailure: Continue
  inputs:
    ImageId: "{{SourceAmiId}}"
- name: terminateInstance
  action: aws:changeInstanceState
  maxAttempts: 3
  timeoutSeconds: 300
  onFailure: Continue
  inputs:
    InstanceIds:
    - "{{launchInstance.InstanceIds}}"
    DesiredState: terminated
- name: updateSsmParam
  action: aws:invokeLambdaFunction
  timeoutSeconds: 300
  maxAttempts: 1
  onFailure: Abort
  inputs:
    FunctionName: "{{LambdaUpdateFunction}}"
    Payload: '{"parameterName":"latest_ami_id", "parameterValue":"{{createImage.ImageId}}"}'
- name: updateLaunchTemplate
  action: aws:invokeLambdaFunction
  timeoutSeconds: 300
  maxAttempts: 1
  onFailure: Abort
  inputs:
    FunctionName: "Update-Launch-Template"
outputs:
- createImage.ImageId
DOC
}

resource "aws_ssm_parameter" "lastest_ami_id_parameter" {
    name      = "latest_ami_id"
    type      = "String"
    value     = data.aws_ami.default_ami.id
    overwrite = false
    lifecycle {
        ignore_changes = [
            "value"
        ]
    }
}

resource "aws_ssm_parameter" "lastest_ami_subnet_parameter" {
    name  = "latest_ami_subnet"
    type  = "String"
    value = var.lambda_subnet
}

resource "aws_ssm_parameter" "lastest_ami_securitygroup_parameter" {
    name  = "latest_ami_securitygroup"
    type  = "String"
    value = aws_security_group.golden_image_sg.id
}

resource "aws_ssm_parameter" "latest_ami_instance_profile_name_parameter" {
    name  = "latest_ami_instance_profile_name"
    type  = "String"
    value = "EC2-Instance-Profile"
}

resource "aws_ssm_parameter" "latest_ami_ssm_service_role_parameter" {
    name  = "latest_ami_ssm_service_role"
    type  = "String"
    value = aws_iam_role.lambda_ssm_execution_role.arn
}