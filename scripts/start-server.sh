#!/bin/bash
echo "---Checking for 'runtime' folder---"
if [ ! -d ${SERVER_DIR}/runtime ]; then
	echo "---'runtime' folder not found, creating...---"
	mkdir ${SERVER_DIR}/runtime
else
	echo "---'runtime' folder found---"
fi

if [ ! -z "$(find ${SERVER_DIR}/runtime -name jre*)" ]; then
	if [ "${RUNTIME_NAME}" == "basicjre" ]; then
		if [ "$(ls -d ${SERVER_DIR}/runtime/* | cut -d '/' -f5)" != "jre1.8.0_333" ]; then
			rm -rf ${SERVER_DIR}/runtime/*
		fi
	elif [ "${RUNTIME_NAME}" != "$(ls -d ${SERVER_DIR}/runtime/* | cut -d '/' -f5)" ]; then
		rm -rf ${SERVER_DIR}/runtime/*
	fi
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
	elif  [ "${RUNTIME_NAME}" == "jre16" ]; then
		JRE16_URL="https://github.com/AdoptOpenJDK/openjdk16-binaries/releases/download/jdk16u-2021-05-08-12-45/OpenJDK16U-jre_x64_linux_hotspot_2021-05-08-12-45.tar.gz"
    	echo "---Downloading and installing JRE16---"
		cd ${SERVER_DIR}/runtime
		if wget -q -nc --show-progress --progress=bar:force:noscroll -O ${SERVER_DIR}/runtime/${RUNTIME_NAME}.tar.gz ${JRE16_URL} ; then
			echo "---Successfully downloaded JRE16!---"
		else
			echo "---Something went wrong, can't download JRE16, putting server in sleep mode---"
			sleep infinity
		fi
		mkdir ${SERVER_DIR}/runtime/${RUNTIME_NAME}
        tar --directory ${SERVER_DIR}/runtime/${RUNTIME_NAME} --strip-components=1 -xvzf ${SERVER_DIR}/runtime/${RUNTIME_NAME}.tar.gz
        rm -rf ${SERVER_DIR}/runtime/${RUNTIME_NAME}.tar.gz
	elif  [ "${RUNTIME_NAME}" == "jre17" ]; then
		JRE17_URL="https://github.com/AdoptOpenJDK/openjdk17-binaries/releases/download/jdk-2021-05-07-13-31/OpenJDK-jdk_x64_linux_hotspot_2021-05-06-23-30.tar.gz"
    	echo "---Downloading and installing JRE17---"
		cd ${SERVER_DIR}/runtime
		if wget -q -nc --show-progress --progress=bar:force:noscroll -O ${SERVER_DIR}/runtime/${RUNTIME_NAME}.tar.gz ${JRE17_URL} ; then
			echo "---Successfully downloaded JRE17!---"
		else
			echo "---Something went wrong, can't download JRE17, putting server in sleep mode---"
			sleep infinity
		fi
		mkdir ${SERVER_DIR}/runtime/${RUNTIME_NAME}
        tar --directory ${SERVER_DIR}/runtime/${RUNTIME_NAME} --strip-components=1 -xvzf ${SERVER_DIR}/runtime/${RUNTIME_NAME}.tar.gz
        rm -rf ${SERVER_DIR}/runtime/${RUNTIME_NAME}.tar.gz
	elif  [ "${RUNTIME_NAME}" == "jre21" ]; then
		JRE21_URL="https://download.java.net/java/GA/jdk21.0.2/f2283984656d49d69e91c558476027ac/13/GPL/openjdk-21.0.2_linux-x64_bin.tar.gz"
    	echo "---Downloading and installing JRE21---"
		cd ${SERVER_DIR}/runtime
		if wget -q -nc --show-progress --progress=bar:force:noscroll -O ${SERVER_DIR}/runtime/${RUNTIME_NAME}.tar.gz ${JRE21_URL} ; then
			echo "---Successfully downloaded JRE21!---"
		else
			echo "---Something went wrong, can't download JRE21, putting server in sleep mode---"
			sleep infinity
		fi
		mkdir ${SERVER_DIR}/runtime/${RUNTIME_NAME}
        tar --directory ${SERVER_DIR}/runtime/${RUNTIME_NAME} --strip-components=1 -xvzf ${SERVER_DIR}/runtime/${RUNTIME_NAME}.tar.gz
        rm -rf ${SERVER_DIR}/runtime/${RUNTIME_NAME}.tar.gz
	elif  [ "${RUNTIME_NAME}" == "jre22" ]; then
		JRE22_URL="https://download.java.net/java/GA/jdk22.0.2/c9ecb94cd31b495da20a27d4581645e8/9/GPL/openjdk-22.0.2_linux-x64_bin.tar.gz"
    	echo "---Downloading and installing JRE22---"
		cd ${SERVER_DIR}/runtime
		if wget -q -nc --show-progress --progress=bar:force:noscroll -O ${SERVER_DIR}/runtime/${RUNTIME_NAME}.tar.gz ${JRE22_URL} ; then
			echo "---Successfully downloaded JRE22!---"
		else
			echo "---Something went wrong, can't download JRE22, putting server in sleep mode---"
			sleep infinity
		fi
		mkdir ${SERVER_DIR}/runtime/${RUNTIME_NAME}
        tar --directory ${SERVER_DIR}/runtime/${RUNTIME_NAME} --strip-components=1 -xvzf ${SERVER_DIR}/runtime/${RUNTIME_NAME}.tar.gz
        rm -rf ${SERVER_DIR}/runtime/${RUNTIME_NAME}.tar.gz
	elif  [ "${RUNTIME_NAME}" == "jre23" ]; then
		JRE23_URL="https://download.java.net/java/GA/jdk23.0.2/6da2a6609d6e406f85c491fcb119101b/7/GPL/openjdk-23.0.2_linux-x64_bin.tar.gz"
    	echo "---Downloading and installing JRE23---"
		cd ${SERVER_DIR}/runtime
		if wget -q -nc --show-progress --progress=bar:force:noscroll -O ${SERVER_DIR}/runtime/${RUNTIME_NAME}.tar.gz ${JRE23_URL} ; then
			echo "---Successfully downloaded JRE23!---"
		else
			echo "---Something went wrong, can't download JRE23, putting server in sleep mode---"
			sleep infinity
		fi
		mkdir ${SERVER_DIR}/runtime/${RUNTIME_NAME}
        tar --directory ${SERVER_DIR}/runtime/${RUNTIME_NAME} --strip-components=1 -xvzf ${SERVER_DIR}/runtime/${RUNTIME_NAME}.tar.gz
        rm -rf ${SERVER_DIR}/runtime/${RUNTIME_NAME}.tar.gz
	elif  [ "${RUNTIME_NAME}" == "jre24" ]; then
		JRE24_URL="https://download.java.net/java/GA/jdk24.0.2/fdc5d0102fe0414db21410ad5834341f/12/GPL/openjdk-24.0.2_linux-x64_bin.tar.gz"
    	echo "---Downloading and installing JRE24---"
		cd ${SERVER_DIR}/runtime
		if wget -q -nc --show-progress --progress=bar:force:noscroll -O ${SERVER_DIR}/runtime/${RUNTIME_NAME}.tar.gz ${JRE24_URL} ; then
			echo "---Successfully downloaded JRE24!---"
		else
			echo "---Something went wrong, can't download JRE24, putting server in sleep mode---"
			sleep infinity
		fi
		mkdir ${SERVER_DIR}/runtime/${RUNTIME_NAME}
        tar --directory ${SERVER_DIR}/runtime/${RUNTIME_NAME} --strip-components=1 -xvzf ${SERVER_DIR}/runtime/${RUNTIME_NAME}.tar.gz
        rm -rf ${SERVER_DIR}/runtime/${RUNTIME_NAME}.tar.gz
	elif  [ "${RUNTIME_NAME}" == "jre25" ]; then
		JRE25_URL="https://download.java.net/java/GA/jdk25/bd75d5f9689641da8e1daabeccb5528b/36/GPL/openjdk-25_linux-x64_bin.tar.gz"
    	echo "---Downloading and installing JRE25---"
		cd ${SERVER_DIR}/runtime
		if wget -q -nc --show-progress --progress=bar:force:noscroll -O ${SERVER_DIR}/runtime/${RUNTIME_NAME}.tar.gz ${JRE25_URL} ; then
			echo "---Successfully downloaded JRE25!---"
		else
			echo "---Something went wrong, can't download JRE25, putting server in sleep mode---"
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
if [ ! -z "${JVM_CUSTOM_COMMAND}" ]; then
	echo "---Detected JVM_CUSTOM_COMMAND: ${JVM_CUSTOM_COMMAND} skipping Check for Minecraft Server executable!---"
elif [ "${GAME_V}" == "custom" ]; then
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
	cp /tmp/server.properties ${SERVER_DIR}/
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
if [ -z "${JVM_CUSTOM_COMMAND}" ]; then
	screen -S Minecraft -L -Logfile ${SERVER_DIR}/masterLog.0 -d -m ${SERVER_DIR}/runtime/${RUNTIME_NAME}/bin/java ${EXTRA_JVM_PARAMS} -Xmx${XMX_SIZE}M -Xms${XMS_SIZE}M -jar ${SERVER_DIR}/${JAR_NAME}.jar nogui ${GAME_PARAMS}
else
	screen -S Minecraft -L -Logfile ${SERVER_DIR}/masterLog.0 -d -m ${SERVER_DIR}/runtime/${RUNTIME_NAME}/bin/java ${JVM_CUSTOM_COMMAND} ${GAME_PARAMS}
fi
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
if [ "${ENABLE_WEBCONSOLE}" == "true" ]; then
    /opt/scripts/start-gotty.sh 2>/dev/null &
fi
sleep 30
if [ -f ${SERVER_DIR}/logs/latest.log ]; then
	screen -S watchdog -d -m /opt/scripts/start-watchdog.sh
	tail -F ${SERVER_DIR}/logs/latest.log
else
	screen -S watchdog -d -m /opt/scripts/start-watchdog.sh
	tail -f ${SERVER_DIR}/masterLog.0
fi