# Evolution API Scripts

O **Evolution API Scripts** é um projeto que visa integrar chamadas de voz do WhatsApp via API da Wavoip com o **Evolution API**. Este repositório contém scripts para automatizar a integração e modificar a configuração padrão do Docker do Evolution API para incluir suporte às funcionalidades da Wavoip.

## Objetivo

Integrar chamadas de voz do WhatsApp usando a API da Wavoip ao projeto Evolution API, permitindo a comunicação por voz através do WhatsApp diretamente no seu sistema.

## Estrutura do Projeto

- **`create_wavoip.sh`**: Script para criar o arquivo `wavoip.js` com a implementação necessária.
- **`replace_wuid.sh`**: Script para fazer a substituição de uma string específica no arquivo `main.js` apenas se a string `wavoip.js` não estiver presente.
- **`Dockerfile`**: Configuração padrão do Docker para o Evolution API.
- **`docker-compose.yml`**: Arquivo de configuração para o Docker Compose, que inclui o serviço `evolution2` com a integração da Wavoip.

## Scripts

### `create_wavoip.sh`

Cria o arquivo `wavoip.js` com o código necessário para a integração da Wavoip.

### `replace_wuid.sh`

Substitui a string `wuid=this.client.user.id.replace` por `const wavoip=require("./wavoip.js");wavoip(this.client, this.instance); wuid=this.client.user.id.replace` no arquivo `./dist/main.js`, somente se a string `wavoip.js` não estiver presente.

## Exemplo de Configuração do Docker

Segue um exemplo de configuração do Docker Compose para o Evolution API com a integração da Wavoip:

```yaml
version: '3.7'
services:
  evolution2:
    image: atendai/evolution-api:v2.1.0
    networks:
      - evolutionapi
    environment:
      - SERVER_URL=https://evolution.wavoip.com
      - AUTHENTICATION_API_KEY=xxxxxxxxxxxxxxxxxxx # Crie a sua API Key em https://api-keygen.com/
      - AUTHENTICATION_EXPOSE_IN_FETCH_INSTANCES=true
      - LANGUAGE=en
      - DEL_INSTANCE=false
      - DATABASE_PROVIDER=postgresql
      - DATABASE_CONNECTION_URI=postgresql://evolution2:evolution2@postgres:5432/evolution2?schema=public
      - DATABASE_SAVE_DATA_INSTANCE=true
      - DATABASE_SAVE_DATA_NEW_MESSAGE=true
      - DATABASE_SAVE_MESSAGE_UPDATE=true
      - DATABASE_SAVE_DATA_CONTACTS=true
      - DATABASE_SAVE_DATA_CHATS=true
      - DATABASE_SAVE_DATA_LABELS=true
      - DATABASE_SAVE_DATA_HISTORIC=true
      - DATABASE_CONNECTION_CLIENT_NAME=evolution2
      #Rabbitmq
      - RABBITMQ_ENABLED=false
      - RABBITMQ_URI=amqp://admin:admin@rabbitmq:5672/default
      - RABBITMQ_EXCHANGE_NAME=evolution
      - RABBITMQ_GLOBAL_ENABLED=false
      - RABBITMQ_EVENTS_APPLICATION_STARTUP=false
      - RABBITMQ_EVENTS_INSTANCE_CREATE=false
      - RABBITMQ_EVENTS_INSTANCE_DELETE=false
      - RABBITMQ_EVENTS_QRCODE_UPDATED=false
      - RABBITMQ_EVENTS_MESSAGES_SET=false
      - RABBITMQ_EVENTS_MESSAGES_UPSERT=true
      - RABBITMQ_EVENTS_MESSAGES_EDITED=false
      - RABBITMQ_EVENTS_MESSAGES_UPDATE=false
      - RABBITMQ_EVENTS_MESSAGES_DELETE=false
      - RABBITMQ_EVENTS_SEND_MESSAGE=false
      - RABBITMQ_EVENTS_CONTACTS_SET=false
      - RABBITMQ_EVENTS_CONTACTS_UPSERT=false
      - RABBITMQ_EVENTS_CONTACTS_UPDATE=false
      - RABBITMQ_EVENTS_PRESENCE_UPDATE=false
      - RABBITMQ_EVENTS_CHATS_SET=false
      - RABBITMQ_EVENTS_CHATS_UPSERT=false
      - RABBITMQ_EVENTS_CHATS_UPDATE=false
      - RABBITMQ_EVENTS_CHATS_DELETE=false
      - RABBITMQ_EVENTS_GROUPS_UPSERT=false
      - RABBITMQ_EVENTS_GROUP_UPDATE=false
      - RABBITMQ_EVENTS_GROUP_PARTICIPANTS_UPDATE=false
      - RABBITMQ_EVENTS_CONNECTION_UPDATE=true
      - RABBITMQ_EVENTS_CALL=false
      - RABBITMQ_EVENTS_TYPEBOT_START=false
      - RABBITMQ_EVENTS_TYPEBOT_CHANGE_STATUS=false
      #SqS
      - SQS_ENABLED=false
      - SQS_ACCESS_KEY_ID=
      - SQS_SECRET_ACCESS_KEY=
      - SQS_ACCOUNT_ID=
      - SQS_REGION=
      - WEBSOCKET_ENABLED=false
      - WEBSOCKET_GLOBAL_EVENTS=false
      - WA_BUSINESS_TOKEN_WEBHOOK=evolution
      - WA_BUSINESS_URL=https://graph.facebook.com
      - WA_BUSINESS_VERSION=v20.0
      - WA_BUSINESS_LANGUAGE=pt_BR
      #Webhook
      - WEBHOOK_GLOBAL_URL=''
      - WEBHOOK_GLOBAL_ENABLED=false
      - WEBHOOK_GLOBAL_WEBHOOK_BY_EVENTS=false
      - WEBHOOK_EVENTS_APPLICATION_STARTUP=false
      - WEBHOOK_EVENTS_QRCODE_UPDATED=true
      - WEBHOOK_EVENTS_MESSAGES_SET=true
      - WEBHOOK_EVENTS_MESSAGES_UPSERT=true
      - WEBHOOK_EVENTS_MESSAGES_EDITED=true
      - WEBHOOK_EVENTS_MESSAGES_UPDATE=true
      - WEBHOOK_EVENTS_MESSAGES_DELETE=true
      - WEBHOOK_EVENTS_SEND_MESSAGE=true
      - WEBHOOK_EVENTS_CONTACTS_SET=true
      - WEBHOOK_EVENTS_CONTACTS_UPSERT=true
      - WEBHOOK_EVENTS_CONTACTS_UPDATE=true
      - WEBHOOK_EVENTS_PRESENCE_UPDATE=true
      - WEBHOOK_EVENTS_CHATS_SET=true
      - WEBHOOK_EVENTS_CHATS_UPSERT=true
      - WEBHOOK_EVENTS_CHATS_UPDATE=true
      - WEBHOOK_EVENTS_CHATS_DELETE=true
      - WEBHOOK_EVENTS_GROUPS_UPSERT=true
      - WEBHOOK_EVENTS_GROUPS_UPDATE=true
      - WEBHOOK_EVENTS_GROUP_PARTICIPANTS_UPDATE=true
      - WEBHOOK_EVENTS_CONNECTION_UPDATE=true
      - WEBHOOK_EVENTS_LABELS_EDIT=true
      - WEBHOOK_EVENTS_LABELS_ASSOCIATION=true
      - WEBHOOK_EVENTS_CALL=true
      - WEBHOOK_EVENTS_TYPEBOT_START=false
      - WEBHOOK_EVENTS_TYPEBOT_CHANGE_STATUS=false
      - WEBHOOK_EVENTS_ERRORS=false
      - WEBHOOK_EVENTS_ERRORS_WEBHOOK=
      - CONFIG_SESSION_PHONE_CLIENT=Evolution API V2
      - CONFIG_SESSION_PHONE_NAME=Chrome
      - CONFIG_SESSION_PHONE_VERSION=2.3000.1015901307 # https://web.whatsapp.com/check-update?version=0&platform=web
      - QRCODE_LIMIT=30
      #Openai
      - OPENAI_ENABLED=true
      #Dify
      - DIFY_ENABLED=true
      #Typebot
      - TYPEBOT_ENABLED=true
      - TYPEBOT_API_VERSION=latest
      #Chatwoot
      - CHATWOOT_ENABLED=false
      - CHATWOOT_MESSAGE_READ=true
      - CHATWOOT_MESSAGE_DELETE=true
      - CHATWOOT_IMPORT_DATABASE_CONNECTION_URI=postgresql://evolution:evolution@postgres:5432/chatwoot?sslmode=disable
      - CHATWOOT_IMPORT_PLACEHOLDER_MEDIA_MESSAGE=true
      #redis
      - CACHE_REDIS_ENABLED=true
      - CACHE_REDIS_URI=redis://redis:6379/1
      - CACHE_REDIS_PREFIX_KEY=evolution
      - CACHE_REDIS_SAVE_INSTANCES=false
      - CACHE_LOCAL_ENABLED=false
      #Minio
      - S3_ENABLED=false
      - S3_ACCESS_KEY=suachave
      - S3_SECRET_KEY=suachave
      - S3_BUCKET=evolutionv3
      - S3_PORT=443
      - S3_ENDPOINT=minioserver.meubot.top
      - S3_USE_SSL=true
    labels:
      - traefik.enable=true
      - traefik.http.routers.evolution_v2.rule=Host(`evolution.wavoip.com`)
      - traefik.http.routers.evolution_v2.entrypoints=websecure
      - traefik.http.routers.evolution_v2.priority=1
      - traefik.http.routers.evolution_v2.tls.certresolver=myresolver
      - traefik.http.routers.evolution_v2.service=evolution_v2
      - traefik.http.services.evolution_v2.loadbalancer.server.port=8080
      - traefik.http.services.evolution_v2.loadbalancer.passHostHeader=true
    volumes:
      - evolution_code_data:/evolution
    entrypoint: >
      /bin/sh -c "apk add git && git && chmod 777 -R ./wavoip_script.sh && npm run start:prod"
  postgres:
    image: postgres:latest
    environment:
      POSTGRES_DB: evolution2
      POSTGRES_USER: evolution2
      POSTGRES_PASSWORD: evolution2
    networks:
      - evolutionapi
    volumes:
      - evolution_postgres_data:/var/lib/postgresql/data
  redis:
    image: redis:latest
    command: 
      - "redis-server"
      - "--appendonly yes"
      - "--port 6379"
    volumes:
      - evolution_redis_data:/data
    networks:
      - evolutionapi

volumes:
  evolution_code_data:
  evolution_postgres_data:
  evolution_redis_data:

networks:
  evolutionapi:
    external: true
```