variable "kubeconfig" {
  description = "Caminho para o kubeconfig"
  type        = string
  default     = "~/.kube/config"
}

variable "namespace" {
  description = "Namespace para o Kafka"
  type        = string
  default     = "kafka"
}

variable "replicas" {
  description = "Número de réplicas do Kafka"
  type        = number
  default     = 1
}

variable "kafka_image" {
  description = "Imagem do Apache Kafka (com suporte a KRaft)"
  type        = string
  default     = "bitnami/kafka:latest"
}
