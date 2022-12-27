<<<<<<< HEAD
locals {
  common_tags = {
    environment = var.environment
    project     = var.project
    deployment  = "managed by terraform"
  }
  name_prefix = "${var.project}-${var.environment}"

=======
locals {
  common_tags = {
    environment = var.environment
    project     = var.project
    deployment  = "managed by terraform"
  }
  name_prefix = "${var.project}-${var.environment}"

>>>>>>> 388a1ebf3638e5266f196d66735cd5bb1b831dc0
}