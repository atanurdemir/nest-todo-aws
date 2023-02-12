module "vpc" {
  source              = "../modules/vpc"
  environment         = local.env
  private_cidr_blocks = var.private_cidr_blocks[local.env]
  project             = "NestJS"
  public_cidr_blocks  = var.public_cidr_blocks[local.env]
  vpc_cidr_block      = var.vpc_cidr_blocks[local.env]
}
module "ecs" {
  source             = "../modules/ecs"
  environment        = local.env
  cpu                = var.cpu[local.env]
  memory             = var.memory[local.env]
  execution_role_arn = module.iam.ecs_execution_role_arn
  task_role_arn      = module.iam.ecs_task_role_arn
  image              = var.backend_image
  container_cpu      = var.container_cpu[local.env]
  container_memory   = var.container_memory[local.env]
  desired_count      = var.container_desired_count[local.env]
  private_subnet_ids = module.vpc.private_subnet_ids.*.id
  security_groups    = module.security.ecs_security_group.*.id
  target_group_arn   = module.loadbalancer.backend_target_group_arn
}
module "iam" {
  source      = "../modules/iam"
  environment = local.env
  account_id  = local.account_id
}
module "security" {
  source      = "../modules/security"
  environment = local.env
  vpc_id      = local.vpc_id
  cidr_blocks = var.vpc_cidr_blocks[local.env]
}
module "loadbalancer" {
  source      = "../modules/loadbalancer"
  environment = local.env
  subnet_ids  = module.vpc.public_subnet_ids.*.id
  vpc_id      = local.vpc_id
}