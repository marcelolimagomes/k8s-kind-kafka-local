resource "kubernetes_deployment" "kafka_ui" {
  metadata {
    name      = "kafka-ui"
    namespace = "kafka"
    labels = {
      app = "kafka-ui"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "kafka-ui"
      }
    }
    template {
      metadata {
        labels = {
          app = "kafka-ui"
        }
      }
      spec {
        container {
          name  = "kafka-ui"
          image = "provectuslabs/kafka-ui:latest"
          port {
            container_port = 8080
          }
          env {
            name  = "KAFKA_CLUSTERS_0_NAME"
            value = "local"
          }
          env {
            name  = "KAFKA_CLUSTERS_0_BOOTSTRAPSERVERS"
            value = "kafka:9092"
          }
          resources {
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "kafka_ui" {
  metadata {
    name      = "kafka-ui"
    namespace = "kafka"
  }
  spec {
    selector = {
      app = "kafka-ui"
    }
    port {
      port        = 8080
      target_port = 8080
      protocol    = "TCP"
      node_port   = 30080
    }
    type = "NodePort"
  }
}
