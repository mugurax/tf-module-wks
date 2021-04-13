variable "instance_enabled" {
  type        = bool
  description = "Set to false to skip creating the instance."
  default     = true
}

variable "ami" {
  type        = string
  description = "The image ID to be created from. Required."
}

variable "instance_type" {
  type        = string
  description = "Defaults to t3.micro."
  default     = "t3.micro"
}

variable key_name {}
