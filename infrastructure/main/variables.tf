data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  env = terraform.workspace

  subnet_ids = tolist(
    module.vpc.private_subnet_ids.*.id
  )

  public_subnet_ids = tolist(
    module.vpc.public_subnet_ids.*.id
  )

  vpc_id     = module.vpc.vpc_id
  account_id = data.aws_caller_identity.current.account_id
  aws_region = data.aws_region.current.name
}

variable "allowed_account_ids" {
  type = string
}
variable "workspace_to_environment_map" {
  type = map(string)
  default = {
    staging    = "staging"
    production = "production"
  }
}

variable "vpc_cidr_blocks" {
  type = map(string)
  default = {
    staging    = "10.0.0.0/21"
    production = "11.0.8.0/21"
  }
}

variable "public_cidr_blocks" {
  type = map(any)
  default = {
    staging = [
      "10.0.0.0/24",
      "10.0.1.0/24",
      "10.0.2.0/24"
    ]
    production = [
      "11.0.8.0/24",
      "11.0.9.0/24",
      "11.0.10.0/24"
    ]
  }
}
variable "private_cidr_blocks" {
  type = map(any)
  default = {
    staging = [
      "10.0.3.0/24",
      "10.0.4.0/24",
      "10.0.5.0/24"
    ]
    production = [
      "11.0.11.0/24",
      "11.0.12.0/24",
      "11.0.13.0/24"
    ]
  }
}
variable "cpu" {
  type = map(string)
  default = {
    staging    = "256"
    production = "1024"
  }
}
variable "memory" {
  type = map(string)
  default = {
    staging    = "512"
    production = "2048"
  }
}
variable "backend_image" {
  type = string
}
variable "container_cpu" {
  type = map(number)
  default = {
    staging    = 256
    production = 1024
  }
}
variable "container_memory" {
  type = map(number)
  default = {
    staging    = 512
    production = 2048
  }
}
variable "container_desired_count" {
  type = map(number)
  default = {
    staging    = 1
    production = 2
  }
}
variable "ecs_min_capacity" {
  type = map(number)
  default = {
    staging    = 1
    production = 2
  }
}
variable "ecs_max_capacity" {
  type = map(number)
  default = {
    staging    = 100
    production = 100
  }
}
variable "ecs_target_value" {
  type = map(number)
  default = {
    staging    = 60
    production = 30
  }
}