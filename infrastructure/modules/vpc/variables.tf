variable "environment" {
  type = string
}
variable "project" {
  type = string
}
variable "public_cidr_blocks" {
  type = list(string)
}
variable "vpc_cidr_block" {
  type = string
}
variable "private_cidr_blocks" {
  type = list(string)
}
