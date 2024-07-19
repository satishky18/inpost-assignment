variable "vpc_id" {
  description = "The ID of the VPC."
  type        = string
}

variable "subnet_ids" {
  description = "A list of public subnet IDs."
  type        = list(string)
}

variable "instance_type" {
  description = "The instance type for the web server."
  type        = string
}


variable "lb_name" {
  description = "Name for the web server lb."
  type        = string
}

variable "lb_type" {
  description = "Type the web server lb."
  type        = string
}

variable "name_of_launch_config" {
  description = "Type the web server lb."
  type        = string
}

variable "launch_config_ami" {
  description = "Type the web server lb."
  type        = string
}