# Terraform Main

terraform {
  backend "s3" {
    region = "ap-northeast-2"
    bucket = "terraform-nalbam-seoul"
    key    = "dev-sns-sms.tfstate"
  }
  required_version = ">= 0.12"
}

provider "aws" {
  region = var.region
}

module "dev-lambda" {
  source = "github.com/nalbam/terraform-aws-lambda-sns?ref=v0.12.1"
  region = var.region

  name        = var.name
  stage       = var.stage
  description = "sns > lambda > sms"
  runtime     = "nodejs10.x"
  handler     = "index.handler"
  memory_size = 512
  timeout     = 5
  s3_bucket   = var.s3_bucket
  s3_source   = "target/lambda.zip"
  s3_key      = "lambda/${var.name}/${var.name}.zip"

  env_vars = {
    PROFILE      = var.stage
    PHONE_NUMBER = var.PHONE_NUMBER
  }
}
