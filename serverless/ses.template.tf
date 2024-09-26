resource "aws_ses_template" "order_confirmed" {
  name    = "order-confirmed-template"
  subject = "Importante"
  html    = "<h1>Invoice gerada {{InvoiceNumber}} com sucesso, para order {{OderId}}!</h1>"
  text    = "Invoice gerada {{InvoiceNumber}} com sucesso, para order {{OderId}}!"
}

//necessario apontar a geracao do e-mail para a numvem a partir dos containeres
//informando no arquivo .env a conta da aws e gerando novamente os containeres
//para realizarmos os testes
