#!/bin/bash
echo "---Checking for Minecraft Server executable ---"
if [ "${GAME_V}" == "custom" ]; then
	echo "---Custom mode enabled please make sure that '${JAR_NAME}.jar' is in the main directory!---"
	if [ ! -f $SERVER_DIR/${JAR_NAME}.jar ]; then
		echo "---Can't find '${JAR_NAME}.jar' please make sure that it's in the main directory, putting server into sleep mode!---"
		sleep infinity
	fi
	echo "---Executable '${JAR_NAME}.jar' in main directory found, continuing!---"
elif [ "${GAME_V}" == "latest" ]; then
	VERSION="$(wget -qO- https://github.com/ich777/versions/raw/master/MinecraftJavaEdition)"
	LAT_V="$(echo "$VERSION" | grep "LATEST" | cut -d '=' -f2)"
	DL_URL="$(echo "$VERSION" | grep "DL_URL" | cut -d '=' -f2)"
	CUR_V="$(unzip -p ${SERVER_DIR}/${JAR_NAME}.jar version.json | grep "name" | cut -d '"' -f 4)"
	if [ -z "$VERSION" ]; then
		LAT_V="$(curl -s https://launchermeta.mojang.com/mc/game/version_manifest.json | jq -r '.latest.release')"
		if [ -z "$LAT_V" ]; then
			if [ -z "$CUR_V" ]; then
				echo "---Can't get latest version from Minecraft falling back to v1.16.2---"
				DL_URL="https://launcher.mojang.com/v1/objects/c5f6fb23c3876461d46ec380421e42b289789530/server.jar"
				LAT_V="1.16.2"
			else
				echo "---Can't get latest version from Minecraft falling back to current version: v$CUR_V---"
				LAT_V="$CUR_V"
			fi
		fi
	fi
	if [ ! -f ${SERVER_DIR}/${JAR_NAME}.jar ]; then
		cd ${SERVER_DIR}
		echo "---Downloading Minecraft Server $LAT_V---"
		if wget -q -nc --show-progress --progress=bar:force:noscroll "$DL_URL" ; then
			echo "---Successfully downloaded Minecraft $LAT_V Server!---"
		else
			echo "---Something went wrong, can't download Minecraft Server, putting server in sleep mode---"
			sleep infinity
		fi
	elif [ "$LAT_V" != "$CUR_V" ]; then
		cd ${SERVER_DIR}
		echo "---Newer version of Minecraft v$LAT_V found, currently installed: $CUR_V---"
		rm ${SERVER_DIR}/${JAR_NAME}.jar
		if wget -q -nc --show-progress --progress=bar:force:noscroll "$DL_URL" ; then
			echo "---Successfully downloaded Minecraft $LAT_V Server!---"
		else
			echo "---Something went wrong, can't download Minecraft Server, putting server in sleep mode---"
			sleep infinity
		fi
	elif [ "$LAT_V" == "$CUR_V" ]; then
		echo "---Minecraft v${CUR_V} is Up-To-Date!---"
	fi
fi

echo "---Preparing Server---"
echo "---Checking for 'server.properties'---"
if [ ! -f ${SERVER_DIR}/server.properties ]; then
    echo "---No 'server.properties' found, downloading...---"
	if wget -q -nc --show-progress --progress=bar:force:noscroll https://raw.githubusercontent.com/ich777/docker-minecraft-basic-server/master/config/server.properties ; then
		echo "---Successfully downloaded 'server.properties'!---"
	else
		echo "---Something went wrong, can't download 'server.properties', putting server in sleep mode---"
		sleep infinity
	fi
else
    echo "---'server.properties' found..."
fi
chmod -R ${DATA_PERM} ${DATA_DIR}
if [ ! -f $SERVER_DIR/eula.txt ]; then
	:
else
	if [ "${ACCEPT_EULA}" == "false" ]; then
		if grep -rq 'eula=true' ${SERVER_DIR}/eula.txt; then
			sed -i '/eula=true/c\eula=false' ${SERVER_DIR}/eula.txt
		fi
		echo
		echo "-------------------------------------------------------"
    	echo "------EULA not accepted, you must accept the EULA------"
    	echo "---to start the Server, putting server in sleep mode---"
    	echo "-------------------------------------------------------"
    	sleep infinity
    fi
fi
echo "---Checking for old logs---"
find ${SERVER_DIR} -name "masterLog.*" -exec rm -f {} \;
screen -wipe 2&>/dev/null

echo "---Starting Server---"
cd ${SERVER_DIR}
screen -S Minecraft -L -Logfile ${SERVER_DIR}/masterLog.0 -d -m /usr/bin/java ${EXTRA_JVM_PARAMS} -Xmx${XMX_SIZE}M -Xms${XMS_SIZE}M -jar ${SERVER_DIR}/${JAR_NAME}.jar nogui ${GAME_PARAMS}
sleep 2
if [ ! -f $SERVER_DIR/eula.txt ]; then
	echo "---EULA not found please stand by...---"
	sleep 30
fi
if [ "${ACCEPT_EULA}" == "true" ]; then
	if grep -rq 'eula=false' ${SERVER_DIR}/eula.txt; then
    	sed -i '/eula=false/c\eula=true' ${SERVER_DIR}/eula.txt
		echo "---EULA accepted, server restarting, please wait...---"
        sleep 5
        exit 0
    fi
elif [ "${ACCEPT_EULA}" == "false" ]; then
	echo
	echo "-------------------------------------------------------"
    echo "------EULA not accepted, you must accept the EULA------"
    echo "---to start the Server, putting server in sleep mode---"
    echo "-------------------------------------------------------"
    sleep infinity
else
	echo "---Something went wrong, please check EULA variable---"
fi
echo "---Waiting for logs, please stand by...---"
sleep 30
if [ -f ${SERVER_DIR}/logs/latest.log ]; then
	screen -S watchdog -d -m /opt/scripts/start-watchdog.sh
	tail -F ${SERVER_DIR}/logs/latest.log
else
	screen -S watchdog -d -m /opt/scripts/start-watchdog.sh
	tail -f ${SERVER_DIR}/masterLog.0
fi