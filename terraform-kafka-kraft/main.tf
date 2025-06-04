terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

provider "kubernetes" {
  config_path = var.kubeconfig
}

resource "kubernetes_namespace" "kafka" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_config_map" "kafka_config" {
  metadata {
    name      = "kafka-config"
    namespace = kubernetes_namespace.kafka.metadata[0].name
  }
  data = {
    "server.properties" = <<-EOT
      process.roles=broker,controller
      node.id=1
      controller.quorum.voters=1@localhost:9093
      listeners=PLAINTEXT://0.0.0.0:9092,CONTROLLER://0.0.0.0:9093
      advertised.listeners=PLAINTEXT://kafka:9092
      inter.broker.listener.name=PLAINTEXT
      controller.listener.names=CONTROLLER
      log.dirs=/var/lib/kafka/data
      num.partitions=1
      offsets.topic.replication.factor=1
      transaction.state.log.replication.factor=1
      transaction.state.log.min.isr=1
      group.initial.rebalance.delay.ms=0
    EOT
  }
}

resource "kubernetes_deployment" "kafka" {
  metadata {
    name      = "kafka"
    namespace = kubernetes_namespace.kafka.metadata[0].name
    labels = {
      app = "kafka"
    }
  }
  spec {
    replicas = var.replicas
    selector {
      match_labels = {
        app = "kafka"
      }
    }
    template {
      metadata {
        labels = {
          app = "kafka"
        }
      }
      spec {
        container {
          name  = "kafka"
          image = var.kafka_image
          port {
            container_port = 9092
          }
          port {
            container_port = 9093
          }
          volume_mount {
            name       = "config"
            mount_path = "/etc/kafka"
          }
          volume_mount {
            name       = "data"
            mount_path = "/var/lib/kafka/data"
          }
          env {
            name  = "KAFKA_CFG_PROCESS_ROLES"
            value = "broker,controller"
          }
          env {
            name  = "KAFKA_CFG_NODE_ID"
            value = "1"
          }
          env {
            name  = "KAFKA_CFG_CONTROLLER_QUORUM_VOTERS"
            value = "1@kafka:9093"
          }
          env {
            name  = "KAFKA_CFG_LISTENERS"
            value = "PLAINTEXT://:9092,CONTROLLER://:9093"
          }
          env {
            name  = "KAFKA_CFG_ADVERTISED_LISTENERS"
            value = "PLAINTEXT://kafka:9092"
          }
          env {
            name  = "KAFKA_CFG_CONTROLLER_LISTENER_NAMES"
            value = "CONTROLLER"
          }
          env {
            name  = "KAFKA_CFG_INTER_BROKER_LISTENER_NAME"
            value = "PLAINTEXT"
          }
          env {
            name  = "KAFKA_CFG_LOG_DIRS"
            value = "/var/lib/kafka/data"
          }
        }
        volume {
          name = "config"
          config_map {
            name = kubernetes_config_map.kafka_config.metadata[0].name
            items {
              key  = "server.properties"
              path = "server.properties"
            }
          }
        }
        volume {
          name = "data"
          empty_dir {}
        }
      }
    }
  }
}

resource "kubernetes_service" "kafka" {
  metadata {
    name      = "kafka"
    namespace = kubernetes_namespace.kafka.metadata[0].name
  }
  spec {
    selector = {
      app = "kafka"
    }
    port {
      port        = 9092
      target_port = 9092
      protocol    = "TCP"
      name        = "kafka"
    }
    port {
      port        = 9093
      target_port = 9093
      protocol    = "TCP"
      name        = "controller"
    }
    type = "ClusterIP"
  }
}
