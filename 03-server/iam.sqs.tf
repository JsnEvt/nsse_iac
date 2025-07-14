#para permitir que o HPA use a quantidade de mensagem em uma fila para
#disparar a criacao de mais pods.(feito na ocasiao do teste durante o curso)
#enquanto realizava a carga de requests.

/* no teste, atraves do K9S, e realizado um port-forward na porta 8080 para gerar um token do postgres
dentro do swagger para ser usado na header para lancar varias cadastros de produtos dentro do banco
e isso fara com que o pod seja escalado atraves do HPA para atender a demanda. 
apos a geracao do token que sera informado na header para atender a requisicao de cadastro dos itens
feitas atraves da linha de comando:
- entra no shell do ngix (pod criado a titulo de testes)
comando:
curl -X POST -H 'Content-Type: application/json' -H 'Authorization: Bearer senha_gerada_pelo_token_dentro_do_swagger -d '{"Price": 1, "Name": "Product"}' -k https://ip_do_pod:4443/main/api/product
obs: -d significa payload
A requisicao e feita usando o pod do identity-server que e o sistema de identificacao usado pelo .NET, assim como o OAuth ou JWT

o teste para repetir a operacao a ponto do pod ser escalado foi usando o while dentro do shell:
while true; do sleep 1; curl -X POST -H 'Content-Type: application/json' -H 'Authorization: Bearer senha_gerada_pelo_token_dentro_do_swagger -d '{"Price": 1, "Name": "Product"}' -k https://ip_do_pod:4443/main/api/product; done;


*/

resource "aws_iam_role_policy_attachment" "sqs" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
  role       = aws_iam_role.instance_role.name
}
