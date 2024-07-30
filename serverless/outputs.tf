output "dlqueues_urls" {
  value = aws_sqs_queue.deadletter.*.id
}

output "queues_urls" {
  value = aws_sqs_queue.nsse.*.id
}
