output "kafka_service" {
  value = kubernetes_service.kafka.metadata[0].name
}

output "namespace" {
  value = kubernetes_namespace.kafka.metadata[0].name
}
