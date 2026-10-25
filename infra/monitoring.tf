# infra/monitoring.tf - CareLink SRE Observability & Monitoring Stack

# -----------------------------------------------------------------------------
# 1. CENTRALIZED LOGGING (PDPA Compliance - 30 Day Retention)
# -----------------------------------------------------------------------------
resource "aws_cloudwatch_log_group" "carelink_app_logs" {
  name              = "/aws/carelink/${var.environment}/application"
  retention_in_days = var.log_retention_days
  kms_key_id        = var.kms_key_arn

  tags = {
    Environment = var.environment
    Service     = "CareLink-Telehealth"
    ManagedBy   = "Terraform"
  }
}

# -----------------------------------------------------------------------------
# 2. SNS ALERTING TOPIC & EMAIL SUBSCRIPTION
# -----------------------------------------------------------------------------
resource "aws_sns_topic" "sre_alerts" {
  name              = "carelink-${var.environment}-sre-alerts"
  kms_master_key_id = var.kms_key_arn

  tags = {
    Environment = var.environment
  }
}

resource "aws_sns_topic_subscription" "sre_email_alert" {
  topic_arn = aws_sns_topic.sre_alerts.arn
  protocol  = "email"
  endpoint  = var.sre_alert_email
}