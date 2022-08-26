#---------------------------------------------------------------------------------------------------------------------
# Create AWS ECR repository
#---------------------------------------------------------------------------------------------------------------------
resource "aws_ecr_repository" "ecr_repo" {
  count = var.enable_ecr_repo ? 1 : 0

  name = var.ecr_repo_name != "" ? var.ecr_repo_name : "${lower(var.name)}-ecr-${lower(var.environment)}"

  image_tag_mutability = var.image_tag_mutability

  #Deprecation warning
  #ScanOnPush configuration at the repository level is deprecated in favor of registry level scan filters.
  # see - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_registry_scanning_configuration
  image_scanning_configuration {
    scan_on_push = var.ecr_repo_scan_images
  }

  # KMS
  encryption_configuration {
    encryption_type = var.ecr_repo_encryption_type
    #kms_key = ""
  }

  tags = merge(
    {
      Name = var.ecr_repo_name != "" ? var.ecr_repo_name : "${lower(var.name)}-ecr-${lower(var.environment)}"
    },
    var.tags
  )

  timeouts {
    delete = var.timeouts_delete
  }

  depends_on = []
}

#---------------------------------------------------------------------------------------------------------------------
# Create ECR repository policy
#
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_registry_policy
#---------------------------------------------------------------------------------------------------------------------

#---------------------------------------------------------------------------------------------------------------------
# Create ECR repository policy
#
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_lifecycle_policy
#---------------------------------------------------------------------------------------------------------------------
