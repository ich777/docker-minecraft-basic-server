#!/bin/bash
echo "---Setting umask to ${UMASK}---"
umask ${UMASK}

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
    	echo "---Downloading and installing Runtime---"
		cd ${SERVER_DIR}/runtime
		if wget -q -nc --show-progress --progress=bar:force:noscroll https://github.com/ich777/runtimes/raw/master/jre/basicjre.tar.gz ; then
			echo "---Successfully downloaded Runtime!---"
		else
			echo "---Something went wrong, can't download Runtime, putting server in sleep mode---"
			sleep infinity
		fi
        tar --directory ${SERVER_DIR}/runtime -xvzf ${SERVER_DIR}/runtime/basicjre.tar.gz
        rm -R ${SERVER_DIR}/runtime/basicjre.tar.gz
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
if [ ! -f ${SERVER_DIR}/${JAR_NAME}.jar ]; then
	cd ${SERVER_DIR}
	echo "---Downloading Minecraft Server 1.14.1---"
	if wget -nc --show-progress --progress=bar:force:noscroll -qi ${JAR_NAME} https://launcher.mojang.com/v1/objects/ed76d597a44c5266be2a7fcd77a8270f1f0bc118/server.jar ; then
		echo "---Successfully downloaded Minecraft Server!---"
	else
		echo "---Something went wrong, can't download Minecraft Server, putting server in sleep mode---"
		sleep infinity
	fi
    sleep 2
    if [ ! -f $SERVER_DIR/${JAR_NAME}.jar ]; then
    	echo "----------------------------------------------------------------------------------------------------"
    	echo "---Something went wrong, please install Minecraft Server manually. Putting server into sleep mode---"
        echo "----------------------------------------------------------------------------------------------------"
        sleep infinity
    fi
else
	echo "---Minecraft Server executable found---"
fi

echo "---Preparing Server---"
export RUNTIME_NAME="$(ls -d ${SERVER_DIR}/runtime/* | cut -d '/' -f5)"
echo "---Checking for 'server.properties'---"
if [ ! -f ${SERVER_DIR}/server.properties ]; then
    echo "---No 'server.properties' found, downloading...---"
	if wget -nc --show-progress --progress=bar:force:noscroll -qi ${SERVER_DIR}/server.properties https://raw.githubusercontent.com/ich777/docker-minecraft-basic-server/master/config/server.properties ; then
		echo "---Successfully downloaded 'server.properties'!---"
	else
		echo "---Something went wrong, can't download 'server.properties', putting server in sleep mode---"
		sleep infinity
	fi
else
    echo "---'server.properties' found..."
fi
chmod -R 777 ${DATA_DIR}
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

echo "---Starting Server---"
cd ${SERVER_DIR}
screen -S Minecraft -L -Logfile ${SERVER_DIR}/masterLog.0 -d -m ${SERVER_DIR}/runtime/${RUNTIME_NAME}/bin/java -Xmx${XMX_SIZE}M -Xms${XMS_SIZE}M -jar ${SERVER_DIR}/${JAR_NAME}.jar nogui ${GAME_PARAMS}
sleep 2
if [ ! -f $SERVER_DIR/eula.txt ]; then
	echo "---EULA not found please stand by...---"
	sleep 30
fi
if [ "${ACCEPT_EULA}" == "true" ]; then
	if grep -rq 'eula=false' ${SERVER_DIR}/eula.txt; then
    	sed -i '/eula=false/c\eula=true' ${SERVER_DIR}/eula.txt
		echo "---EULA accepted, please restart server---"
        sleep infinity
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
        tail -F ${SERVER_DIR}/logs/latest.log
else
        tail -f ${SERVER_DIR}/masterLog.0
fi