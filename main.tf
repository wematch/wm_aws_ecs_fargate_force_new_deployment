data aws_region current {}

module lambda {
    source  = "terraform-aws-modules/lambda/aws"
    version = "~> 2.0" # TODO: Update module version

    function_name                       = "${var.name_prefix}-ECS-Force-New-Deployment"
    description                         = "ECS Force New Deployment for ${var.name_prefix}"
    handler                             = "lambda.lambda_handler"
    runtime                             = "python3.9"
    timeout                             = 30
    memory_size                         = 256
    maximum_retry_attempts              = 2
    attach_policy                       = true
    create_package                      = false
    local_existing_package              = "${path.module}/lambda.zip"
    policy                              = aws_iam_policy.policy.arn
    tags                                = var.standard_tags
    cloudwatch_logs_retention_in_days   = var.cloudwatch_logs_retention_in_days

    environment_variables = {
        ECS_CLUSTER     = var.ecs_cluster
    }
}

resource aws_iam_policy policy {
    name        = "${var.name_prefix}-ECS-Force-New-Deployment"
    path        = "/"
    description = "Allow to list and update ECS services withing the ${var.ecs_cluster} cluster"

    # Policy looks complicated? Here's why: 
    # https://stackoverflow.com/questions/59604987/why-i-am-getting-not-authorized-to-perform-ecslisttasks-on-resource-excep
    policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
            {
                Action = [
                    "ecs:ListServices",
                    "ecs:DescribeServices",
                    "ecs:UpdateService"
                ]
                Effect   = "Allow"
                Resource = "*"
                Condition = {
                    ArnEquals = {
                        "ecs:cluster" = var.ecs_cluster
                    }
                }
            }
        ]
    })
}

resource aws_cloudwatch_event_rule schedule {
    count               = var.create ? 1 : 0
    name                = var.schedule.name
    description         = var.schedule.description
    schedule_expression = var.schedule.expression
}

resource aws_cloudwatch_event_target this {
    count   = var.create ? 1 : 0
    rule    = aws_cloudwatch_event_rule.schedule.name
    arn     = module.lambda.lambda_function_arn
}

resource aws_lambda_permission allow_cloudwatch_to_invoke_lambda {
    count           = var.create ? 1 : 0
    statement_id    = "AllowExecutionFromCloudWatch"
    action          = "lambda:InvokeFunction"
    function_name   = module.lambda.lambda_function_name
    principal       = "events.amazonaws.com"
    source_arn      = aws_cloudwatch_event_rule.schedule.arn
}
