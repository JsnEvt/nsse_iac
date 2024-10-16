/*o conceito de fila e tambem utilizado para comunicacao assincrona entre
microservicos atraves de uma chamada http. neste caso usaremos o padrao 
publish/subscribe
o uso do servico SQS pode ser interessante nos casos em que, em um momento, 
de black friday por exemplo, pode-se escalar automaticamente varias instancias
para processamento, porem, essa nao e a melhor estrategia. pode-se colocar 
um sistema de fila que processa as requisicoes sem precisar escalar instancias
para tal.

o conceito de DLQ dead letter queues visa colocar elementos de fila que 
falharam em outra fila para posterior analise ou reprocessamento para que nao
se perca do tracking (fallback) da mensagem ou que fique atrapalhando o processamento 
das mensagens seguintes
*/

resource "aws_sqs_queue" "nsse" {
  count = length(var.queues)

  name                      = var.queues[count.index].name
  delay_seconds             = var.queues[count.index].delay_seconds
  max_message_size          = var.queues[count.index].max_message_size
  message_retention_seconds = var.queues[count.index].message_retention_seconds
  receive_wait_time_seconds = var.queues[count.index].receive_wait_time_seconds //long pooling e short pooling - 
  //uma query faz requisicoes em todos (long) ou 
  //alguns servidores (short) retornando alguns ou todos os resultados da query. um tempo maior da margem
  //para consultar varios servidores para trazer a resposta desejada.
  sqs_managed_sse_enabled = var.queues[count.index].sqs_managed_sse_enabled // criptografia at rest ativada - ocorre no
  //disco do servidor da aws
  policy = data.aws_iam_policy_document.sqs_policy.json

  tags = var.tags
}

//criamos o recurso separado para que a fila seja criada primeiro e apos outros recursos sejam 
//adicionados a ela

resource "aws_sqs_queue_redrive_policy" "nsse" {
  count     = length(aws_sqs_queue.nsse)
  queue_url = aws_sqs_queue.nsse[count.index].id
  redrive_policy = jsonencode({
    deadLetterTargetArn = one([for queue in aws_sqs_queue.deadletter : queue.arn
    if startswith(queue.name, aws_sqs_queue.nsse[count.index].name)])
    maxReceiveCount = 2 //quantidade de processameneto da mensagem antes de mandar para dead letter queues
  })
}
