variable "environment" {
  description = "One of [prod | stage | dev | test]"
  type = "string"
}

variable "region" {
  description = "One of [eu-west-2 | us-west-1 | us-east-1]"
  type = "string"
}

