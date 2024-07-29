resource "aws_ssm_patch_baseline" "this" {
  name                                 = var.debian_patch_baseline.name
  description                          = var.debian_patch_baseline.description
  approved_patches_enable_non_security = var.debian_patch_baseline.approved_patches_enable_non_security
  operating_system                     = var.debian_patch_baseline.operating_system

  approval_rule {
    approve_after_days = 0
    compliance_level   = "CRITICAL"

    patch_filter {
      key    = "PRODUCT"
      values = ["Debian12"]
    }

    patch_filter {
      key    = "SECTION"
      values = ["*"]
    }

    patch_filter {
      key    = "PRIORITY"
      values = ["Required", "Important"]
    }
  }

  approval_rule {
    approve_after_days = 0
    compliance_level   = "INFORMATIONAL"

    patch_filter {
      key    = "PRODUCT"
      values = ["Debian12"]
    }

    patch_filter {
      key    = "SECTION"
      values = ["*"]
    }

    patch_filter {
      key    = "PRIORITY"
      values = ["Standard"]
    }
  }
}
