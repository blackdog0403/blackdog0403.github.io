variable "profile" {
  description = "AWS CLI profile to use. Leave null to use AWS_PROFILE or the default credential chain."
  type        = string
  default     = null
}

variable "region" {
  type    = string
  default = "ap-northeast-2"
}

variable "fallback_mode" {
  description = "Test 4: SGPP standard mode + EXTERNALSNAT=false"
  type        = bool
  default     = false
}

variable "kubernetes_version" {
  type    = string
  default = "1.35"
}
