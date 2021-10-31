# What happens here?

Repository contains two Dockerfile configurations
- Fluentd https://hub.docker.com/r/fluent/fluentd/
- telegram-send  https://github.com/rahiel/telegram-send

Fluentd configured to work with [minecraft server docker container](https://hub.docker.com/r/itzg/minecraft-server) running with [fluentd log driver](https://docs.docker.com/config/containers/logging/fluentd/) 
The goal is to collect all minecraft logs, individually match login/logout/advancement/chat_message game log records and send notification to Telegram Bot

# Manual deploy to dodocker using docker machine

## Use dodocker machine

docker-machine use dodocker

## Build telegram_send image

`docker build -t dodomi_telegram_send ./`

# Build Fluentd image

`docker build -t dodomi-fluentd:latest ./`
 
# Rsync

`rsync -av -e 'docker-machine ssh dodocker' /home/varloc2000/web/infra/fluentd_telegram_notifier/docker/fluentd :/home/varloc2000/web`

# ssh to dodocker machine

`docker-machine ssh dodocker`

# Run fluentd container

`docker run --privileged -dt --rm --name dodomi-fluent-logger -e RUBY_GC_HEAP_OLDOBJECT_LIMIT_FACTOR=0.9 -v /home/varloc2000/web/fluentd/log:/fluentd/log -v /var/run/docker.sock:/var/run/docker.sock dodomi-fluentd:latest fluentd --log-rotate-age weekly`
`docker run --privileged -dt --rm --name dodomi-fluent-logger -e TG_CHAT_ID=-1001296975499 -e TG_TOKEN=TOKEN_HERE -v /home/varloc2000/web/fluentd/log:/fluentd/log -v /var/run/docker.sock:/var/run/docker.sock dodomi-fluentd:latest fluentd --log-rotate-age weekly`

## 3 Get fluentd IP adress (typically 172.17.0.2)

`docker inspect -f '{{.NetworkSettings.IPAddress}}' dodomi-fluent-logger`

172.17.0.2

## Backup minecraft data 

`docker-machine scp -r dodocker:/home/docker/minecraft/_data /home/varloc2000/Games/ServerMinecraft/backup/dd_mm_2021`

## 4 Run minecraft container with fluentd

`docker run --log-driver=fluentd --log-opt tag="docker.{{.ID}}" --log-opt fluentd-address=172.17.0.2:24224 -d -p 25565:25565 --name minecraft -e EULA=TRUE -e OPS=varloc2000,hecate,masha,zmicer -e SPAWN_PROTECTION=50 -e ALLOW_NETHER=true -e ONLINE_MODE=FALSE -e MEMORY=2G -v /home/docker/minecraft/_data:/data itzg/minecraft-server`

docker run --env-file env.list -e TEXT="your text here" dodomi_telegram_send



rsync -av -e 'docker-machine ssh dodocker' /home/varloc2000/Games/ServerMinecraft/plugins/* :/home/docker/minecraft/_data/plugins