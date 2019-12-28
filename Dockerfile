FROM ich777/debian-baseimage

LABEL maintainer="admin@minenet.at"

RUN apt-get update && \
	apt-get -y install --no-install-recommends screen && \
	rm -rf /var/lib/apt/lists/*

ENV DATA_DIR="/serverdata"
ENV SERVER_DIR="${DATA_DIR}/serverfiles"
ENV RUNTIME_NAME="basicjre"
ENV JAR_NAME="template"
ENV GAME_PARAMS=""
ENV GAME_PORT=25565
ENV XMX_SIZE=1024
ENV XMS_SIZE=1024
ENV ACCEPT_EULA="false"
ENV UMASK=000
ENV UID=99
ENV GID=100

RUN mkdir $DATA_DIR && \
	mkdir $SERVER_DIR && \
	useradd -d $DATA_DIR -s /bin/bash --uid $UID --gid $GID minecraft && \
	chown -R minecraft $DATA_DIR && \
	ulimit -n 2048

ADD /scripts/ /opt/scripts/
RUN chmod -R 770 /opt/scripts/  && \
	chown -R minecraft /opt/scripts

USER minecraft

#Server Start
ENTRYPOINT ["/opt/scripts/start-server.sh"]