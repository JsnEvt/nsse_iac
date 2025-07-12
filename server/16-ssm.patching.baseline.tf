resource "aws_ssm_patch_baseline" "this" {
  name                                 = var.debian_patch_baseline.name
  description                          = var.debian_patch_baseline.description
  approved_patches_enable_non_security = var.debian_patch_baseline.approved_patches_enable_non_security
  operating_system                     = var.debian_patch_baseline.operating_system

  //o bloco dinamico se repete novamnete para instalacao das patches nas maquinas 
  //workers e control-plane

  /*
  codigo escrito no arquivo de variaveis para complementar a ideia da formacao do bloco dynamic
  importante observar que no metodo normal, o parametro "product" era seria um value dentro da key do patch_filter
  product, section, priority passam a ser key nesta definicao do patch_filter para preenchimento dinamico
  o que esta dentro da lista no bloco abaixo sao os valores dos parametros do patch_filter
  */
  dynamic "approval_rule" {
    for_each = var.debian_patch_baseline.approval_rules
    content {
      approve_after_days = approval_rule.value.approve_after_days
      compliance_level   = approval_rule.value.compliance_level

      dynamic "patch_filter" {
        for_each = approval_rule.value.patch_filter
        content {
          key = upper(tostring(patch_filter.key)) //observe que a "key" recebe a propria key, sendo o nome das Key 
          //como valores vindo do arquivo de variaveis
          values = patch_filter.value
        }
      }
    }
  }
}
