variable "environment" {
  type = string
}
variable "cpu" {
  type = number
}
variable "memory" {
  type = number
}
variable "execution_role_arn" {
  type = string
}
variable "task_role_arn" {
  type = string
}
variable "image" {
  type = string
}
variable "container_cpu" {
  type = string
}
variable "container_memory" {
  type = string
}
variable "desired_count" {
  type = number
}
variable "private_subnet_ids" {
  type = list(string)
}
variable "security_groups" {
  type = list(string)
}
variable "target_group_arn" {
  type = string
}