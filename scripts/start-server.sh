#!/bin/bash
echo "---Checking for 'runtime' folder---"
if [ ! -d ${SERVER_DIR}/runtime ]; then
	echo "---'runtime' folder not found, creating...---"
	mkdir ${SERVER_DIR}/runtime
else
	echo "---'runtime' folder found---"
fi

echo "---Checking if Runtime is installed---"
if [ -z "$(find ${SERVER_DIR}/runtime -name jre*)" ]; then
    if [ "${RUNTIME_NAME}" == "basicjre" ]; then
    	echo "---Downloading and installing Basic Runtime---"
		cd ${SERVER_DIR}/runtime
		if wget -q -nc --show-progress --progress=bar:force:noscroll https://github.com/ich777/runtimes/raw/master/jre/basicjre.tar.gz ; then
			echo "---Successfully downloaded Runtime!---"
		else
			echo "---Something went wrong, can't download Runtime, putting server in sleep mode---"
			sleep infinity
		fi
        tar --directory ${SERVER_DIR}/runtime -xvzf ${SERVER_DIR}/runtime/basicjre.tar.gz
        rm -rf ${SERVER_DIR}/runtime/basicjre.tar.gz
	elif  [ "${RUNTIME_NAME}" == "jre11" ]; then
		JRE11_URL="https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.9.1%2B1/OpenJDK11U-jre_x64_linux_hotspot_11.0.9.1_1.tar.gz"
    	echo "---Downloading and installing JRE11---"
		cd ${SERVER_DIR}/runtime
		if wget -q -nc --show-progress --progress=bar:force:noscroll -O ${SERVER_DIR}/runtime/${RUNTIME_NAME}.tar.gz ${JRE11_URL} ; then
			echo "---Successfully downloaded JRE11!---"
		else
			echo "---Something went wrong, can't download JRE11, putting server in sleep mode---"
			sleep infinity
		fi
		mkdir ${SERVER_DIR}/runtime/${RUNTIME_NAME}
        tar --directory ${SERVER_DIR}/runtime/${RUNTIME_NAME} --strip-components=1 -xvzf ${SERVER_DIR}/runtime/${RUNTIME_NAME}.tar.gz
        rm -rf ${SERVER_DIR}/runtime/${RUNTIME_NAME}.tar.gz
	elif  [ "${RUNTIME_NAME}" == "jre15" ]; then
		JRE15_URL="https://github.com/AdoptOpenJDK/openjdk15-binaries/releases/download/jdk-15.0.1%2B9/OpenJDK15U-jre_x64_linux_hotspot_15.0.1_9.tar.gz"
    	echo "---Downloading and installing JRE15---"
		cd ${SERVER_DIR}/runtime
		if wget -q -nc --show-progress --progress=bar:force:noscroll -O ${SERVER_DIR}/runtime/${RUNTIME_NAME}.tar.gz ${JRE15_URL} ; then
			echo "---Successfully downloaded JRE15!---"
		else
			echo "---Something went wrong, can't download JRE15, putting server in sleep mode---"
			sleep infinity
		fi
		mkdir ${SERVER_DIR}/runtime/${RUNTIME_NAME}
        tar --directory ${SERVER_DIR}/runtime/${RUNTIME_NAME} --strip-components=1 -xvzf ${SERVER_DIR}/runtime/${RUNTIME_NAME}.tar.gz
        rm -rf ${SERVER_DIR}/runtime/${RUNTIME_NAME}.tar.gz
    else
    	if [ ! -d ${SERVER_DIR}/runtime/${RUNTIME_NAME} ]; then
        	echo "---------------------------------------------------------------------------------------------"
        	echo "---Runtime not found in folder 'runtime' please check again! Putting server in sleep mode!---"
        	echo "---------------------------------------------------------------------------------------------"
        	sleep infinity
        fi
    fi
else
	echo "---Runtime found---"
fi

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
if [ ! -f ~/.screenrc ]; then
    echo "defscrollback 30000
bindkey \"^C\" echo 'Blocked. Please use to command \"stop\" to shutdown the server or close this window to exit the terminal.'" > ~/.screenrc
fi
export RUNTIME_NAME="$(ls -d ${SERVER_DIR}/runtime/* | cut -d '/' -f5)"
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
screen -S Minecraft -L -Logfile ${SERVER_DIR}/masterLog.0 -d -m ${SERVER_DIR}/runtime/${RUNTIME_NAME}/bin/java ${EXTRA_JVM_PARAMS} -Xmx${XMX_SIZE}M -Xms${XMS_SIZE}M -jar ${SERVER_DIR}/${JAR_NAME}.jar nogui ${GAME_PARAMS}
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
/opt/scripts/start-gotty.sh 2>/dev/null &
sleep 30
if [ -f ${SERVER_DIR}/logs/latest.log ]; then
	screen -S watchdog -d -m /opt/scripts/start-watchdog.sh
	tail -F ${SERVER_DIR}/logs/latest.log
else
	screen -S watchdog -d -m /opt/scripts/start-watchdog.sh
	tail -f ${SERVER_DIR}/masterLog.0
fi