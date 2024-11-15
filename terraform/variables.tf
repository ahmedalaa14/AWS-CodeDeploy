variable "region" {
  description = "AWS region"
  default     = "us-west-2"
}

variable "ami" {
  type    = string
  default = "ami-015c25ad8763b2f11"
}

variable "aws_s3_bucket" {
  type    = string
  default = "dev-codedeploy-bucket"
}

variable "public_key" {
  description = "ssh public key"
}

variable "email" {
  description = "workahmeedalaa@gmail.com"
}