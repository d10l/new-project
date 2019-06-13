---
to: vars.tf
---
variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}

variable "AWS_REGION" {
  type    = "string"
  default = "eu-central-1"
}
