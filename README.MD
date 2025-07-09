# 🚀 Serviços n8n - Stack Docker Completo

Uma stack Docker Compose completa para automação com n8n, incluindo monitoramento com Grafana e Prometheus, API WhatsApp com WAHA ou Evolution API e cache Redis com interface visual, utilizando Caddy como proxy reverso.

## 📋 Índice

- [Visão Geral](#-visão-geral)
- [Pré-requisitos](#-pré-requisitos)
- [Instalação e Configuração](#-instalação-e-configuração)
- [Uso](#-uso)
- [Estrutura do Projeto](#-estrutura-do-projeto)
- [Scripts Utilitários](#-scripts-utilitários)
- [Monitoramento](#-monitoramento)
- [Troubleshooting](#-troubleshooting)

## 🎯 Visão Geral

Este projeto fornece uma stack completa de serviços Docker para automação de processos usando n8n, com serviços complementares para monitoramento, comunicação via WhatsApp e cache de dados, utilizando Caddy como proxy reverso moderno.

### Características Principais

- 🔧 **Automação**: Plataforma n8n para workflows
- 📊 **Monitoramento**: Grafana com dashboards personalizados
- 📱 **WhatsApp API**: Integração completa com WAHA
- 🗄️ **Cache**: Redis Stack com interface RedisInsight
- 🚀 **Proxy Reverso**: Caddy com HTTPS automático
- 🔒 **Segurança**: SSL/TLS automático via Caddy
- 📈 **Performance**: Configurações otimizadas de memória
- 🌐 **Facilidade**: Configuração simplificada

## 🛠️ Serviços Incluídos

### 1. Caddy (Proxy Reverso)

- **Imagem**: `caddy:2.7-alpine`
- **Portas**: 80 (HTTP), 443 (HTTPS)
- **Características**: HTTPS automático, configuração simples

### 2. Monitoramento

#### 2.1 Grafana

- **Imagem**: `grafana/grafana:12.0.1`
- **Acesso**: `https://grafana.services.subdomínio.com`
- **Recursos**: Dashboards de monitoramento

#### 2.2 Prometheus

- **Imagem**: `prom/prometheus:v3.4.1`
- **Acesso**: `https://prometheus.services.subdomínio.com`
- **Recursos**: recolhimento de métricas

### 4. WhatsApp

#### 4.1 WAHA

- **Imagem**: `devlikeapro/waha:latest`
- **Acesso**: `https://waha.services.seu-dominio.com`

#### 4.2 Evolution API

- **Imagem**: `atendai/evolution-api:v2.1.1`
- **Acesso**: `https://evolution.services.seu-dominio.com`
- **Requisitos**: Precisa de um redis e um postgres.

### 5. Bancos de dados

#### 5.1 Redis Stack

- **Imagem**: `redis/redis-stack:latest`
- **Acesso**: `https://redis.services.subdomínio.com`
- **Features**: Cache, banco de dados, RedisInsight UI

#### 5.2 Redis (Evo)

- **Imagem**: `redis:8-alpine`
- **Acesso**: Sem acesso web
- **Features**: Cache, banco de dados

#### 5.3 Postgres (Evo)

- **Imagem**: `postgres:17-alpine`
- **Acesso**: Sem acesso
- **Features**: Banco de dados

## 📋 Pré-requisitos

- Docker Engine 20.10+
- Docker Compose V2
- Domínio configurado com DNS apontando para seu servidor
- Portas 80 e 443 abertas no firewall

## 🚀 Instalação e Configuração

### 1. Clone o Repositório

```bash
git clone https://github.com/dario-bastos-dev/n8n-services.git
cd n8n-services
```

### 2. Configurar Variáveis de Ambiente

```bash
# Copie o arquivo de exemplo
cp .env.example .env

# Edite as variáveis conforme necessário
nano .env
```

### 3. Configurar Variáveis Obrigatórias

Edite o arquivo `.env` com suas configurações:

```bash
# Domínio principal
# Subdomínio da URL principal para os serviços
URL_SUBDOMAIN=services.subdomínio.com

# Configurações do Grafana
GRAFANA_ADMIN_USER=admin
GRAFANA_ADMIN_PASSWORD=your_secure_password_here

# Configurações do WAHA (WhatsApp HTTP API)
WAHA_SWAGGER_USERNAME=admin
WAHA_SWAGGER_PASSWORD=your_waha_swagger_password_here

# Configurações do PostgreSQL para o Evolution API
POSTGRES_USER=your_postgres_user_here
POSTGRES_PASSWORD=your_postgres_password_here
POSTGRES_DB=your_postgres_database_here

# Configurações do Evolution API
EVOLUTION_API_KEY=your_evolution_api_key_here

# Configurações do Redis
REDIS_PASSWORD=your_redis_password_here
```

### 4. Configurar o Caddyfile

Edite o arquivo `Caddyfile` e substitua `nomeservico.services.subdomínio.com` pelo seu domínio real:

```plaintext
nomeservico.services.subdomínio.com {

    reverse_proxy nome-servico:porta

    header {
        Strict-Transport-Security "max-age=31536000; includeSubDomains; preload"
        X-Content-Type-Options "nosniff"
        X-Frame-Options "DENY"
        Referrer-Policy "no-referrer-when-downgrade"
        X-XSS-Protection "1; mode=block"
    }

    encode gzip zstd

}
```

### 5. Inicializar os Serviços

```bash
# Torna o script executável (Linux/Mac)
chmod +x init.sh
chmod +x restart.sh

# Execute o script de inicialização
./init.sh
```

## 🎮 Uso

### Iniciando os Serviços

```bash
# Usando Docker Compose
docker compose up -d

# Ou usando o script
./init.sh
```

### Parando os Serviços

```bash
# Usando Docker Compose
docker compose down

# Para remover volumes também
docker compose down -v
```

### Reiniciando os Serviços

```bash
# Usando o script utilitário
./restart.sh
```

### Verificando Status

```bash
# Ver status dos contêineres
docker compose ps

# Ver logs em tempo real
docker compose logs -f

# Ver logs de um serviço específico
docker compose logs -f grafana
```

## 📁 Estrutura do Projeto

```text
Serviços_n8n/
├── compose.yml              # Definição dos serviços Docker
├── Caddyfile               # Configuração do proxy reverso Caddy
├── .env.example            # Exemplo de variáveis de ambiente
├── .env                    # Suas variáveis de ambiente (não versionado)
├── redis.conf              # Configurações do Redis
├── init.sh                 # Script de inicialização
├── restart.sh              # Script de reinicialização
├── README.MD               # Este arquivo
```

## ⚙️ Configurações

### Configurações do Redis

O arquivo `redis.conf` inclui:

- Limite de memória: 512MB
- Política LRU para limpeza automática
- Persistência automática configurada
- Compressão de dados habilitada
- Backups automáticos

### Configurações do Caddy

O `Caddyfile` fornece:

- HTTPS automático com Let's Encrypt
- Roteamento baseado em path
- Headers customizados para aplicações
- Configuração simplificada
- Renovação automática de certificados

### Configurações de Rede

Todos os serviços utilizam a rede `n8n-services` e são expostos via Caddy com:

- SSL/TLS automático
- Roteamento inteligente
- Headers de proxy apropriados
- Isolamento de rede

## 🔧 Scripts Utilitários

### init.sh

Script de inicialização que:

- Cria diretórios necessários automaticamente
- Inicia todos os serviços em modo daemon
- Aguarda a inicialização dos serviços
- Verifica o status dos contêineres
- Exibe informações úteis para uso

### restart.sh

Script para reinicialização rápida que:

- Para todos os serviços graciosamente
- Reinicia em modo daemon
- Útil para aplicar mudanças de configuração
- Mantém dados persistentes

## 📊 Monitoramento

### Grafana

- **URL**: `grafana.services.subdomínio.com`
- **Login**: Definido nas variáveis de ambiente
- **Plugins Incluídos**: Clock panel, Redis datasource
- **Dashboards**: Disponíveis para criação personalizada

### Prometheus

- **URL**: `prometheus.services.subdomínio.com`
- **Login**: Definido nas variáveis de ambiente
- **Metricas**: Defina os caminhos que ele pegará as métricas em `./prometheus/prometheus.yml`

### Redis Insight

- **URL**: `redis.services.subdomínio.com`
- **Funcionalidades**:
  - Visualização de dados em tempo real
  - Monitoramento de performance
  - Análise de uso de memória
  - Gerenciamento de chaves

### Logs Centralizados

```bash
# Ver todos os logs
docker compose logs -f

# Ver logs específicos
docker compose logs -f caddy
docker compose logs -f grafana
docker compose logs -f prometheus
docker compose logs -f waha
docker compose logs -f redis-evo
docker compose logs -f postgres-evo
docker compose logs -f evolution-api
docker compose logs -f redis-stack

# Ver logs com timestamp
docker compose logs -f -t
```

## 🐛 Troubleshooting

### Problema: Serviços não iniciam

**Solução**:

```bash
# Verificar logs detalhados
docker compose logs

# Verificar status da rede
docker network ls | grep n8n-services

# Recriar rede se necessário
docker network create n8n-services

# Verificar portas em uso
netstat -tlnp | grep -E ":(80|443)"
```

### Problema: HTTPS não funciona

**Solução**:

```bash
# Verificar logs do Caddy
docker compose logs caddy

# Verificar se o domínio aponta para o servidor
nslookup seu-dominio.com

# Verificar configuração do Caddyfile
cat Caddyfile
```

### Problema: Erro de permissão

**Solução**:

```bash
# Dar permissões aos scripts
chmod +x init.sh restart.sh

# Verificar ownership dos diretórios de dados
sudo chown -R $USER:$USER ./data

# Verificar permissões do Docker
sudo usermod -aG docker $USER
```

### Problema: Variáveis de ambiente não carregadas

**Solução**:

```bash
# Verificar se o arquivo .env existe
ls -la .env

# Validar sintaxe do arquivo .env
cat .env

# Verificar se as variáveis são lidas
docker compose config
```

### Problema: Conflitos de porta

**Solução**:

```bash
# Verificar portas em uso
sudo netstat -tlnp | grep -E ":(80|443|3000|6379|8001)"

# Parar serviços conflitantes
sudo systemctl stop apache2 nginx

# Verificar se há outros contêineres usando as portas
docker ps --format "table {{.Names}}\t{{.Ports}}"
```

### Problema: Erro de DNS/Domínio

**Solução**:

```bash
# Verificar resolução DNS
dig seu-dominio.com

# Testar conectividade
curl -I http://seu-dominio.com

# Verificar se o Caddy consegue resolver
docker compose exec caddy nslookup seu-dominio.com
```

## 📝 URLs de Acesso

Após a inicialização completa, os serviços estarão disponíveis em:

`https://nome-servico.service.seudominio.com`

## 🔐 Segurança

### Boas Práticas Implementadas

- Senhas fortes obrigatórias via variáveis de ambiente
- HTTPS automático e forçado
- Isolamento de rede entre serviços
- Limites de recursos para prevenir DoS
- Volumes persistentes para dados importantes

### Recomendações Adicionais

- Use senhas complexas (mínimo 12 caracteres)
- Mantenha as imagens Docker atualizadas
- Configure backup regular dos volumes
- Monitore logs regularmente
- Implemente firewall adicional se necessário

## 📚 Referências

- [Documentação do Caddy](https://caddyserver.com/docs/)
- [Documentação do Grafana](https://grafana.com/docs/)
- [Documentação do Prometheus](https://prometheus.io/docs/introduction/overview/)
- [Documentação do Evolution API](https://doc.evolution-api.com/v2/pt/get-started/introduction)
- [Documentação do WAHA](https://waha.devlike.pro/)
- [Documentação do Redis Stack](https://redis.io/docs/stack/)
- [Docker Compose Reference](https://docs.docker.com/compose/compose-file/)
