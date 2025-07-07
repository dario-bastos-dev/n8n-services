# 🚀 Serviços n8n - Stack Docker Completo

Uma stack Docker Compose completa para automação com n8n, incluindo monitoramento com Grafana, API WhatsApp com WAHA e cache Redis com interface visual, utilizando Caddy como proxy reverso.

## 📋 Índice

- [Visão Geral](#-visão-geral)
- [Serviços Incluídos](#-serviços-incluídos)
- [Pré-requisitos](#-pré-requisitos)
- [Instalação e Configuração](#-instalação-e-configuração)
- [Uso](#-uso)
- [Estrutura do Projeto](#-estrutura-do-projeto)
- [Configurações](#-configurações)
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
- **Memória**: 128MB (limite), 64MB (reservado)

### 2. Grafana (Monitoramento)

- **Imagem**: `grafana/grafana:12.0.1`
- **Acesso**: `https://seu-dominio.com/grafana`
- **Recursos**: Dashboards de monitoramento, plugins Redis
- **Memória**: 512MB (limite), 256MB (reservado)

### 3. WAHA (WhatsApp HTTP API)

- **Imagem**: `devlikeapro/waha:latest`
- **Acesso**: `https://seu-dominio.com/whatsapp`
- **Engine**: GOWS (Google Chrome Web Store)
- **Features**: API REST, Swagger UI, sessões persistentes
- **Memória**: 512MB (limite), 256MB (reservado)

### 4. Redis Stack

- **Imagem**: `redis/redis-stack:latest`
- **Acesso**: `https://seu-dominio.com/redis`
- **Features**: Cache, banco de dados, RedisInsight UI
- **Memória**: 1GB (limite), 512MB (reservado)

## 📋 Pré-requisitos

- Docker Engine 20.10+
- Docker Compose V2
- Domínio configurado com DNS apontando para seu servidor
- Portas 80 e 443 abertas no firewall

### Criando a Rede Docker

```bash
docker network create n8n-services
```

### Criando Volumes Externos

```bash
docker volume create grafana_data
```

## 🚀 Instalação e Configuração

### 1. Clone o Repositório

```bash
git clone <url-do-repositorio>
cd Serviços_n8n
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
URL_SUBDOMAIN=seu-dominio.com

# Credenciais do Grafana
GRAFANA_ADMIN_USER=admin
GRAFANA_ADMIN_PASSWORD=SuaSenhaSegura123

# Configurações WAHA
WAHA_API_KEY=sua-chave-api-waha
WAHA_SWAGGER_USERNAME=admin
WAHA_SWAGGER_PASSWORD=SuaSenhaWaha123

# Senha do Redis
REDIS_PASSWORD=SuaSenhaRedis123
```

### 4. Configurar o Caddyfile

Edite o arquivo `Caddyfile` e substitua `n8n.subdomínio.com` pelo seu domínio real:

```plaintext
seu-dominio.com {
    handle_path /grafana* {
        reverse_proxy grafana:3000
    }
    
    handle_path /whatsapp* {
        reverse_proxy waha:3000 {
            header_up X-Forwarded-Prefix /whatsapp
        }
    }
    
    handle_path /redis* {
        reverse_proxy redis-stack:8001
    }
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
└── data/                   # Diretórios de dados (criados automaticamente)
    ├── grafana/
    ├── waha/
    └── redis/
```

## ⚙️ Configurações

### Recursos Computacionais

Cada serviço está configurado com limites de recursos otimizados:

- **Caddy**: 128MB RAM, sem limite de CPU
- **Grafana**: 512MB RAM (limite), 256MB (reservado)
- **WAHA**: 512MB RAM (limite), 256MB (reservado)
- **Redis**: 1GB RAM (limite), 512MB (reservado)

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

- **URL**: `https://seu-dominio.com/grafana`
- **Login**: Definido nas variáveis de ambiente
- **Plugins Incluídos**: Clock panel, Redis datasource
- **Dashboards**: Disponíveis para criação personalizada

### Redis Insight

- **URL**: `https://seu-dominio.com/redis`
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
docker compose logs -f waha
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

- **🏠 Página Principal**: `https://seu-dominio.com`
- **📊 Grafana**: `https://seu-dominio.com/grafana`
- **📱 WAHA (WhatsApp API)**: `https://seu-dominio.com/whatsapp`
- **🗄️ Redis Insight**: `https://seu-dominio.com/redis`
- **📚 Swagger WAHA**: `https://seu-dominio.com/whatsapp/swagger`

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
- [Documentação do WAHA](https://waha.devlike.pro/)
- [Documentação do Redis Stack](https://redis.io/docs/stack/)
- [Docker Compose Reference](https://docs.docker.com/compose/compose-file/)
