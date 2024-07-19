variable "vpc_id" {
  description = "The ID of the VPC."
  type        = string
}

variable "subnet_ids" {
  description = "A list of private subnet IDs."
  type        = list(string)
}

variable "db_username" {
  description = "The username for the RDS instance."
  type        = string
}

variable "db_password" {
  description = "The password for the RDS instance."
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "The name of the database to create."
  type        = string
}

variable "db_name_identifier" {
  description = "The name of the mysql instance to create."
  type        = string
}

variable "cidr_to_allow" {
  description = "A list of cidr that are allowed to access rds"
  type        = list(string)
}