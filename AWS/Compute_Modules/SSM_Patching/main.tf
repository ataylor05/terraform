data "aws_caller_identity" "current" {}


# --------------
# Backups
# --------------
resource "aws_backup_vault" "backup_vault" {
  name        = "Nightly-EC2-Backup-Vault"
  #kms_key_arn = "${aws_kms_key.example.arn}"
}

resource "aws_backup_plan" "backup_plan" {
  name = "Nightly-EC2-Backup-Plan"
  rule {
    rule_name         = "Nightly-EC2-Backup-Rule"
    target_vault_name = aws_backup_vault.backup_vault.name
    schedule          = var.cron_expression_to_start
    lifecycle {
        delete_after = var.number_of_days_to_retain_backups
    }
  }
}

resource "aws_backup_selection" "backup_selections" {
  plan_id      = aws_backup_plan.backup_plan.id
  name         = "Nightly-EC2-Backup-Tag-Selection"
  iam_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/service-role/AWSBackupDefaultServiceRole"

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "Backups-Enabled"
    value = "True"
  }
}



# --------------
# Patching
# --------------
resource "aws_ssm_patch_baseline" "amazon_linux_2_baseline" {
  name             = "Amazon-Linux-2-Baseline"
  operating_system = "AMAZON_LINUX_2"

  approval_rule {
    approve_after_days = var.days_to_auto_approve
    compliance_level   = "HIGH"

    patch_filter {
      key    = "PRODUCT"
      values = ["AmazonLinux2"]
    }

    patch_filter {
      key    = "CLASSIFICATION"
      values = ["Security", "Bugfix"]
    }

    patch_filter {
      key    = "SEVERITY"
      values = ["Critical", "Important"]
    }
  }
}

resource "aws_ssm_patch_group" "patchgroup" {
  baseline_id = aws_ssm_patch_baseline.amazon_linux_2_baseline.id
  patch_group = "AMZN2-Patching"
}