##############3 run and collect logs with fluentd to send Telegram notification ################# 

## 1 Build fluentd
docker build -t dodomi-fluentd:latest ./

docker build \
	--build-arg DOCKER_GROUP_ID=`getent group docker | cut -d: -f3` \
	-t dodomi-fluentd:latest ./

## 2 Run fluentd

docker run \
	--privileged \
	-t --rm --name dodomi-fluent-logger \
	-v $(pwd)/log:/fluentd/log \
	-v /var/run/docker.sock:/var/run/docker.sock \
	dodomi-fluentd:latest \
	fluentd --log-rotate-age weekly -v

## 3 Get fluentd IP adress (typically 172.17.0.2)
docker inspect -f '{{.NetworkSettings.IPAddress}}' dodomi-fluent-logger

## Test by sending fake logs 

### Simulate chat message
curl -X POST -d 'json={"source":"stdout","log":"[07:16:49] [Server thread/INFO]: <varloc2000> miners! Preparing spawn area: 0%","container_id":"5ed3045581e5d918f00a79e5bdfba2a3218b2cb2d81194d25b5abe79892c3af2","container_name":"/minecraft"}' http://172.17.0.2:9880/docker.test

### Simulate login
curl -X POST -d 'json={"source":"stdout","log":"[07:16:49] [Server thread/INFO]: <varloc2000> joined the game","container_id":"5ed3045581e5d918f00a79e5bdfba2a3218b2cb2d81194d25b5abe79892c3af2","container_name":"/minecraft"}' http://172.17.0.2:9880/docker.test

### Simulate advancement
curl -X POST -d 'json={"source":"stdout","log":"[07:16:49] [Server thread/INFO]: <varloc2000>  has made the advancement [Cool Guy]","container_id":"5ed3045581e5d918f00a79e5bdfba2a3218b2cb2d81194d25b5abe79892c3af2","container_name":"/minecraft"}' http://172.17.0.2:9880/docker.test

## OR Run minecraft container with fluentd
docker run \
--log-driver=fluentd \
--log-opt tag="docker.{{.ID}}" \
--log-opt fluentd-address=172.17.0.2:24224 \
-d \
-p 25565:25565 \
--name minecraft \
-e EULA=TRUE \
-e OPS=varloc2000,hecate,masha,zmicer \
-e SPAWN_PROTECTION=50 \
-e ALLOW_NETHER=true \
-e ONLINE_MODE=FALSE \
-e MEMORY=700m \
-v /home/docker/minecraft/_data:/data \
itzg/minecraft-server
