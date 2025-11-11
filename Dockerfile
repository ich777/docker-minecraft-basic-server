FROM ich777/debian-baseimage

LABEL org.opencontainers.image.authors="admin@minenet.at"
LABEL org.opencontainers.image.source="https://github.com/ich777/docker-minecraft-basic-server"

RUN apt-get update && \
	apt-get -y install --no-install-recommends screen curl jq unzip && \
	rm -rf /var/lib/apt/lists/*

RUN wget -O /tmp/gotty.tar.gz https://github.com/yudai/gotty/releases/download/v1.0.1/gotty_linux_amd64.tar.gz && \
	tar -C /usr/bin/ -xvf /tmp/gotty.tar.gz && \
	rm -rf /tmp/gotty.tar.gz

ENV DATA_DIR="/serverdata"
ENV SERVER_DIR="${DATA_DIR}/serverfiles"
ENV RUNTIME_NAME="jre22"
ENV JAR_NAME="server"
ENV GAME_V=""
ENV GAME_PARAMS=""
ENV GAME_PORT=25565
ENV ENABLE_WEBCONSOLE="true"
ENV GOTTY_PARAMS="-w --title-format MinecraftJavaEdition"
ENV XMX_SIZE=1024
ENV XMS_SIZE=1024
ENV EXTRA_JVM_PARAMS=""
ENV JVM_CUSTOM_COMMAND=""
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
COPY /config/server.properties /tmp/server.properties
RUN chmod -R 770 /opt/scripts/

#Server Start
ENTRYPOINT ["/opt/scripts/start.sh"]