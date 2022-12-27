locals {
  common_tags = {
    environment = var.environment
    project     = var.project
    deployment  = "managed by terraform"
  }
  name_prefix = "${var.project}-${var.environment}"

}