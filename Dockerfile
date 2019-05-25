FROM ubuntu

MAINTAINER ich777

RUN apt-get update
RUN apt-get -y install wget screen

ENV DATA_DIR="/serverdata"
ENV SERVER_DIR="${DATA_DIR}/serverfiles"
ENV RUNTIME_NAME="template"
ENV JAR_NAME="template"
ENV GAME_PARAMS=""
ENV GAME_PORT=25565
ENV XMX_SIZE=1024
ENV XMS_SIZE=1024
ENV ACCEPT_EULA="false"
ENV UID=99
ENV GID=100

RUN mkdir $DATA_DIR
RUN mkdir $SERVER_DIR
RUN useradd -d $DATA_DIR -s /bin/bash --uid $UID --gid $GID minecraft
RUN chown -R minecraft $DATA_DIR

RUN ulimit -n 2048

ADD /scripts/ /opt/scripts/
RUN chmod -R 770 /opt/scripts/
RUN chown -R minecraft /opt/scripts

USER minecraft

#Server Start
ENTRYPOINT ["/opt/scripts/start-server.sh"]
