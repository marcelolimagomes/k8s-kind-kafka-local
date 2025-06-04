# Apache Kafka KRaft no Kubernetes com Terraform

## Pré-requisitos

- Cluster Kubernetes (ex: kind)
- `kubectl` configurado
- Terraform >= 1.0

## Como usar

```sh
cd terraform-kafka-kraft
terraform init
terraform apply
```

Por padrão, será criado 1 broker Kafka em modo KRaft (sem Zookeeper) no namespace `kafka`.

Para customizar variáveis:

```sh
terraform apply -var="replicas=3" -var="kafka_image=bitnami/kafka:3.7.0-debian-11-r0"
```

Para acessar o serviço dentro do cluster:

```sh
kubectl -n kafka get svc kafka
```
