# logs.tf

# Set up CloudWatch group and log stream and retain logs for 30 days
resource "aws_cloudwatch_log_group" "testapp_log_group" {
  name              = "/ecs/mpulsebackend-prod-green"
  retention_in_days = 30

  tags = {
    Name = "cw-log-group"
  }
}

resource "aws_cloudwatch_log_stream" "myapp_log_stream" {
  name           = "mplusebackend-prod-green-log-stream"
  log_group_name = aws_cloudwatch_log_group.testapp_log_group.name
}