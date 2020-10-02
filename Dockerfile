FROM ich777/debian-baseimage

LABEL maintainer="admin@minenet.at"

RUN apt-get update && \
	apt-get -y install --no-install-recommends screen curl jq unzip && \
	rm -rf /var/lib/apt/lists/*

ENV DATA_DIR="/serverdata"
ENV SERVER_DIR="${DATA_DIR}/serverfiles"
ENV RUNTIME_NAME="basicjre"
ENV JAR_NAME="server"
ENV GAME_V="latest"
ENV GAME_PARAMS=""
ENV GAME_PORT=25565
ENV XMX_SIZE=1024
ENV XMS_SIZE=1024
ENV EXTRA_JVM_PARAMS=""
ENV ACCEPT_EULA="false"
ENV UMASK=000
ENV UID=99
ENV GID=100
ENV USER="minecraft"
ENV DATA_PERM=770

RUN mkdir $DATA_DIR && \
	mkdir $SERVER_DIR && \
	useradd -d $DATA_DIR -s /bin/bash $USER && \
	chown -R $USER $DATA_DIR && \
	ulimit -n 2048

ADD /scripts/ /opt/scripts/
RUN chmod -R 770 /opt/scripts/

#Server Start
ENTRYPOINT ["/opt/scripts/start.sh"]