output "lambda_function_name" { value = aws_lambda_function.processor.function_name }
output "lambda_invoke_arn" { value = aws_lambda_function.processor.invoke_arn }
output "lambda_role_arn" { value = aws_iam_role.lambda.arn }
output "api_log_group_arn" { value = aws_cloudwatch_log_group.api.arn }
