variable "instance_enabled" {
  type        = bool
  description = "Flag to control the instance creation. Set to false if it is necessary to skip instance creation"
  default     = true
}

variable "ami" {
  type        = string
  description = "The image ID to be created from. Required."
}

variable "instance_type" {
  type        = string
  description = "Defaults to t3.micro."
  default = "t3.micro"
}

variable "vpc_id" {
    type = string
    description = "vpc id"
 
}

variable key_name {}
