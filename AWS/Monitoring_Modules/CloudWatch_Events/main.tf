# --------------
# CloudWatch Event Rules
# --------------
resource "aws_cloudwatch_event_rule" "root_user_actions_rule" {
    name        = "Root-User-Actions"
    description = "Captures each AWS Root user action."
    event_pattern = <<PATTERN
{
  "detail-type": ["AWS API Call via CloudTrail","AWS Console Sign In via CloudTrail"],
  "detail": {
  "userIdentity": {
      "type": ["Root"]
    }
  }
}
PATTERN
}

resource "aws_cloudwatch_event_target" "root_user_actions_target" {
    target_id = "root_user_actions_rule"
    rule      = aws_cloudwatch_event_rule.root_user_actions_rule.name
    arn       = "arn:aws:events:${var.region}:${var.master_account}:event-bus/default"
    role_arn  = var.cross_account_role
}

resource "aws_cloudwatch_event_rule" "risky_kms_actions_rule" {
    name          = "Risky-KMS-Actions"
    description   = "Captures risky actions taken against KMS."
    event_pattern = <<PATTERN
{
  "source": [
    "aws.kms"
  ],
  "detail-type": [
    "AWS API Call via CloudTrail"
  ],
  "detail": {
    "eventSource": [
      "kms.amazonaws.com"
    ],
    "eventName": [
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion",
      "kms:DisableKey",
      "kms:DisableKeyRotation",
      "kms:PutKeyPolicy",
      "kms:RevokeGrant",
      "kms:RetireGrant",
      "kms:CreateGrant"
    ]
  }
}
PATTERN
}

resource "aws_cloudwatch_event_target" "risky_kms_actions_target" {
    target_id = "risky_kms_actions_rule"
    rule      = aws_cloudwatch_event_rule.risky_kms_actions_rule.name
    arn       = "arn:aws:events:${var.region}:${var.master_account}:event-bus/default"
    role_arn  = var.cross_account_role
}

resource "aws_cloudwatch_event_rule" "cloudtrail_disabled_rule" {
    name          = "CloudTrail-Disabled"
    description   = "Triggers when CloudTrail logging is turned off or deleted."
    event_pattern = <<PATTERN
{
  "source": [
    "aws.cloudtrail"
  ],
  "detail-type": [
    "AWS API Call via CloudTrail"
  ],
  "detail": {
    "eventSource": [
      "cloudtrail.amazonaws.com"
    ],
    "eventName": [
      "cloudtrail:StopLogging",
      "cloudtrail:DeleteTrail"
    ]
  }
}
PATTERN
}

resource "aws_cloudwatch_event_target" "cloudtrail_disabled_target" {
    target_id = "cloudtrail_disabled_rule"
    rule      = aws_cloudwatch_event_rule.cloudtrail_disabled_rule.name
    arn       = "arn:aws:events:${var.region}:${var.master_account}:event-bus/default"
    role_arn  = var.cross_account_role
}

resource "aws_cloudwatch_event_rule" "config_compliance_changed_rule" {
    name          = "Config-Compliance-Changed"
    description   = "Triggers when the compliance status of a Config rule changes."
    event_pattern = <<PATTERN
{
  "source": [
    "aws.config"
  ],
  "detail-type": [
    "Config Rules Compliance Change"
  ]
}
PATTERN
}

resource "aws_cloudwatch_event_target" "config_compliance_changed_target" {
    target_id = "config_compliance_changed_rule"
    rule      = aws_cloudwatch_event_rule.config_compliance_changed_rule.name
    arn       = "arn:aws:events:${var.region}:${var.master_account}:event-bus/default"
    role_arn  = var.cross_account_role
}

resource "aws_cloudwatch_event_rule" "risky_config_actions_rule" {
    name          = "Risky-Config-Actions"
    description   = "Captures risky actions taken against Config recorder and rules."
    event_pattern = <<PATTERN
{
  "source": [
    "aws.config"
  ],
  "detail-type": [
    "AWS API Call via CloudTrail"
  ],
  "detail": {
    "eventSource": [
      "config.amazonaws.com"
    ],
    "eventName": [
      "config:StopConfigurationRecorder",
      "config:DeleteConfigurationRecorder",
      "config:DeleteConfigRule",
      "config:DeleteRetentionConfiguration",
      "config:DeleteEvaluationResults",
      "config:DeleteDeliveryChannel",
      "config:DeleteAggregationAuthorization",
      "config:DeleteConfigurationAggregator"
    ]
  }
}
PATTERN
}

resource "aws_cloudwatch_event_target" "risky_config_actions_target" {
    target_id = "risky_config_actions_rule"
    rule      = aws_cloudwatch_event_rule.risky_config_actions_rule.name
    arn       = "arn:aws:events:${var.region}:${var.master_account}:event-bus/default"
    role_arn  = var.cross_account_role
}

resource "aws_cloudwatch_event_rule" "risky_guardduty_actions_rule" {
    name          = "Risky-GuardDuty-Actions"
    description   = "Captures risky actions taken against GuardDuty."
    event_pattern = <<PATTERN
{
  "source": [
    "aws.guardduty"
  ],
  "detail-type": [
    "AWS API Call via CloudTrail"
  ],
  "detail": {
    "eventSource": [
      "guardduty.amazonaws.com"
    ],
    "eventName": [
      "guardduty:DeleteDetector",
      "guardduty:DeleteMembers",
      "guardduty:DisassociateFromMasterAccount",
      "guardduty:DisassociateMembers",
      "guardduty:DeleteIPSet",
      "guardduty:DeleteThreatIntelSet",
      "guardduty:StopMonitoringMembers"
    ]
  }
}
PATTERN
}

resource "aws_cloudwatch_event_target" "risky_guardduty_actions_target" {
    target_id = "risky_guardduty_actions_rule"
    rule      = aws_cloudwatch_event_rule.risky_guardduty_actions_rule.name
    arn       = "arn:aws:events:${var.region}:${var.master_account}:event-bus/default"
    role_arn  = var.cross_account_role
}