variable "AWS_DEFAULT_REGION" {
  type        = string
  description = "AWS Region"
  default     = "us-east-1"
}

variable "environment" {
  description = "Most Used Variables in All services"
  type        = list(string)
}
