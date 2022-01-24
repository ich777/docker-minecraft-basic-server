FROM ich777/debian-baseimage:latest_arm64

LABEL maintainer="admin@minenet.at"

RUN apt-get update && \
	apt-get -y install --no-install-recommends software-properties-common gnupg2 screen curl jq unzip && \
	wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add - && \
	add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/ && \
	mkdir -p /usr/share/man/man1 && \
	apt-get update && \
	apt-get -y install adoptopenjdk-8-hotspot && \
	apt-get -y remove software-properties-common gnupg2 && \
	apt-get -y autoremove && \
	rm -rf /var/lib/apt/lists/*

ENV DATA_DIR="/serverdata"
ENV SERVER_DIR="${DATA_DIR}/serverfiles"
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