//para gerar a chave privada que sera instalada na maquina local 
//para acesso remoto as instancias

//terraform output -raw key_pair_private_key exibira o conteudo da chave privada
//com o output acima seguido do "> nome_da_chave.pem", sera gerado um arquivo 
//com a chave privada para instalacao dentro da maquina local

output "key_pair_private_key" {
  sensitive = true
  value     = tls_private_key.this.private_key_pem
}

/*para gerar a informacao do DNS do network load balancer para ser incorporado
ao playbook do ansible atraves da escrita do arquivo.
*/
output "nlb_dns_name" {
  value = aws_lb.nlb_control_plane.dns_name
}

output "worker_launch_template_id" {
  value = module.ec2_workers_instances.launch_template_id
}
