//para gerar a chave privada que sera instalada na maquina local 
//para acesso remoto as instancias

//terraform output -raw key_pair_private_key exibira o conteudo da chave privada
//com o output acima seguido do "> nome_da_chave.pem", sera gerado um arquivo 
//com a chave privada para instalacao dentro da maquina local

output "key_pair_private_key" {
  sensitive = true
  value     = tls_private_key.this.private_key_pem
}
