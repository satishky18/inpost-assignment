variable "cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "availability_zones" {
  description = "A list of availability zones in the region."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}
