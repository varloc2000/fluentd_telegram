FROM fluent/fluentd:v1.12-1 AS fluentd
MAINTAINER varloc2000 <varloc2000@gmail.com>

# Use root account to use apk
USER root

# Install the magic wrapper.
# @see https://github.com/jpetazzo/dind/blob/master/alpine/Dockerfile
# TODO figure out why isn't working if run this file (line 57)
#ADD ./wrapdocker /usr/local/bin/wrapdocker

#ENV DOCKER_GROUP_ID=999

# Install Docker and dependencies
RUN apk --update add \
  bash \
  iptables \
  findutils \
  ca-certificates \
  e2fsprogs \
  docker \
#  && chmod +x /usr/local/bin/wrapdocker \
  && rm -rf /var/cache/apk/*

# @see https://stackoverflow.com/questions/36185035/how-to-mount-docker-socket-as-volume-in-docker-container-with-correct-group
#RUN echo $DOCKER_GROUP_ID
#RUN addgroup -g $DOCKER_GROUP_ID -S docker
RUN adduser fluent docker

# Install fluentd plugins
# @see https://hub.docker.com/r/fluent/fluentd/
RUN apk add --no-cache --update --virtual .build-deps \
    sudo build-base ruby-dev \
  && sudo gem install fluent-plugin-rewrite-tag-filter \
  && sudo gem sources --clear-all \
  && apk del .build-deps \
  && rm -rf /home/fluent/.gem/ruby/2.5.0/cache/*.gem

# Copy required files
COPY fluent.conf /fluentd/etc/
COPY entrypoint.sh /bin/
COPY ./worker/ /bin/worker/

# Define additional metadata for our image.
VOLUME /var/lib/docker

RUN ["chmod", "+x", "/bin/entrypoint.sh"]

## TODO find a way to chmod all in one run
RUN ["chmod", "+x", "/bin/worker/_telegram_send.sh"]
RUN ["chmod", "+x", "/bin/worker/minecraft_advancement.sh"]
RUN ["chmod", "+x", "/bin/worker/minecraft_login.sh"]
RUN ["chmod", "644", "/bin/worker/env.list"]
#RUN ["find", "/bin/worker/", "-type", "f", "-iname", "*.sh", "-exec", "chmod", "+x", "{} \;"]

#CMD ["wrapdocker"]

USER fluent
