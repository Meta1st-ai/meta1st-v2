variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "lambda_runtime" {
  description = "Lambda runtime"
  type        = string
  default     = "python3.11"
}

variable "lambda_architecture" {
  description = "Lambda architecture"
  type        = string
  default     = "x86_64"
}

variable "azure_metadata_url" {
  description = "Azure AD SAML metadata URL"
  type        = string
  default     = ""
}
