FROM ubuntu

MAINTAINER ich777

RUN apt-get update
RUN apt-get -y install wget 

ENV DATA_DIR="/serverdata"
ENV SERVER_DIR="${DATA_DIR}/serverfiles"
ENV GAME_ID="template"
ENV GAME_NAME="template"
ENV GAME_PARAMS="template"
ENV GAME_PORT=27015
ENV VALIDATE=""
ENV UID=99
ENV GID=100
ENV USERNAME=""
ENV PASSWRD=""

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
