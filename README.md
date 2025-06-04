# k8s-kind-kafka-local

## Introdução: O que é Kubernetes e Kind?

O **Kubernetes** é uma plataforma open source para orquestração de containers, permitindo automatizar a implantação, o dimensionamento e o gerenciamento de aplicações em containers. Ele facilita a administração de ambientes complexos, garantindo alta disponibilidade, escalabilidade e gerenciamento eficiente de recursos.

O **kind** (Kubernetes IN Docker) é uma ferramenta que permite criar clusters Kubernetes locais usando containers Docker como nós do cluster. É ideal para desenvolvimento, testes e experimentação, pois permite simular um ambiente Kubernetes real de forma rápida e simples, sem a necessidade de infraestrutura dedicada.

**Por que usar Kubernetes ao invés de apenas containers Docker?**

Enquanto o Docker permite empacotar e executar aplicações em containers isolados, o Kubernetes oferece recursos avançados de orquestração, como:

- Gerenciamento automático de escala e balanceamento de carga
- Recuperação automática de falhas (self-healing)
- Atualizações contínuas (rolling updates)
- Gerenciamento de configurações e segredos
- Deploys declarativos e reprodutíveis

Esses recursos tornam o Kubernetes uma escolha robusta para ambientes de produção e para simular cenários reais em ambientes de desenvolvimento e testes.

## Sobre o Apache Kafka

O **Apache Kafka** é uma plataforma distribuída de streaming de eventos, projetada para processar grandes volumes de dados em tempo real com alta performance, tolerância a falhas e escalabilidade horizontal.

### Principais features do Apache Kafka

- **Alta performance**: Capaz de processar milhões de mensagens por segundo.
- **Escalabilidade horizontal**: Fácil de expandir adicionando mais brokers ao cluster.
- **Persistência**: Armazena dados de forma durável em disco.
- **Tolerância a falhas**: Replicação de dados entre múltiplos brokers.
- **Processamento em tempo real**: Suporte a consumidores e produtores de eventos em tempo real.
- **KRaft Mode**: Nova arquitetura que elimina a dependência do Apache ZooKeeper, simplificando a operação do cluster.

### Casos de uso comuns

- **Integração de sistemas**: Comunicação assíncrona entre microserviços.
- **Pipelines de dados**: Ingestão, processamento e distribuição de grandes volumes de dados.
- **Monitoramento e logs**: Centralização e análise de logs e métricas em tempo real.
- **Event sourcing**: Implementação de arquiteturas baseadas em eventos.
- **Analytics em tempo real**: Processamento e análise de dados assim que são gerados.

## Pré-requisitos

- [Docker](https://www.docker.com/)
- [curl](https://curl.se/)
- [git](https://git-scm.com/)

## Passo a passo para configuração do ambiente

### 1. Clonando o projeto

Para começar, clone este repositório em sua máquina local:

```sh
git clone https://github.com/marcelolimagomes/k8s-kind-kafka-local.git
cd k8s-kind-kafka-local
```

### 2. Instale o kubectl e o kind

Utilize o script fornecido para instalar o `kind`:

```sh
./scripts/install-kind.sh
```

### 3. Crie o cluster Kubernetes local com kind

Execute o script para criar o cluster:

```sh
./scripts/create-kind-cluster.sh
```

### 4. Implante o Apache Kafka com KRaft

Clone o projeto [terraform-kafka-kraft](https://github.com/seu-usuario/terraform-kafka-kraft) e siga as instruções para aplicar o Terraform e implantar o Kafka no cluster:

```sh
git clone https://github.com/seu-usuario/terraform-kafka-kraft.git
cd terraform-kafka-kraft
terraform init
terraform apply
```

> **Obs:** Certifique-se de que o contexto do `kubectl` está apontando para o cluster criado pelo kind.

### 5. Implante o Kafka UI

Clone o projeto [kafka-ui-terraform](https://github.com/seu-usuario/kafka-ui-terraform) e aplique o Terraform para instalar o Kafka UI:

```sh
git clone https://github.com/seu-usuario/kafka-ui-terraform.git
cd kafka-ui-terraform
terraform init
terraform apply
```

### 6. Acesse o Kafka UI

Após a implantação, o Kafka UI estará disponível via NodePort ou Ingress, conforme configurado nos manifests. Por padrão, acesse:

- **NodePort:** http://localhost:30080
- **Ingress:** http://kafka-ui.localdev.me (configure seu `/etc/hosts` se necessário)

## Limpeza do ambiente

### Removendo o cluster kind

Para remover completamente o cluster kind e limpar os recursos do Docker:

```sh
# Remove o cluster kind (substitua 'kind' pelo nome do seu cluster se for diferente)
kind delete cluster

# Ou para remover um cluster específico por nome
kind delete cluster --name nome-do-cluster

# Para listar todos os clusters kind existentes
kind get clusters

# Para remover todos os clusters kind
kind delete clusters --all
```

### Verificando a remoção

Após executar o comando, você pode verificar se o cluster foi removido:

```sh
# Verifica se ainda existem clusters kind
kind get clusters

# Verifica se os containers Docker foram removidos
docker ps -a | grep kind

# Lista contextos do kubectl (o contexto do kind deve ter sido removido)
kubectl config get-contexts
```

## Contribuições

Este projeto é aberto à comunidade! Sinta-se à vontade para sugerir melhorias, reportar problemas ou enviar pull requests. Toda contribuição é bem-vinda para evoluirmos juntos este ambiente de testes.

---

**Dúvidas ou sugestões?** Abra uma issue ou envie um pull request!

## Contato

Fique à vontade para entrar em contato comigo:

- **Marcelo Lima Gomes**
- LinkedIn - https://www.linkedin.com/in/marcelolimagomes/
- **E-mail:** marcelolimagomes@gmail.com

---
