#!/bin/bash
echo "---Checking for 'runtime' folder---"
if [ ! -d ${SERVER_DIR}/runtime ]; then
	echo "---'runtime' folder not found, creating...---"
	mkdir ${SERVER_DIR}/runtime
else
	echo "---"runtime" folder found---"
fi

echo "---Checking if Runtime is installed---"
if [ ! -d $SERVER_DIR/runtime/"$(find ${SERVER_DIR} -name jre*)" ]; then
    if [ "{RUNTIME_NAME}" == "jre1.8.0_211"]; then
    	echo "---Downloading and installing Runtime---"
		cd ${SERVER_DIR}/runtime
		wget -qi https://github.com/ich777/docker-minecraft-basic-server/raw/master/runtime/8u211.tar.gz
        tar --directory ${SERVER_DIR}/runtime -xvzf ${SERVER_DIR}/runtime/${RUNTIME_NAME}
    else
    	if [ ! -d ${SERVER_DIR}/runtime/${RUNTIME_NAME} ]; then
        echo "---------------------------------------------------------------------------------------------"
        echo "---Runtime not found in folder 'runtime' please check again! Putting server in sleep mode!---"
        echo "---------------------------------------------------------------------------------------------"
        sleep infinity
    fi
else
	echo "---Runtime found!---"
fi      

echo "---Checking if Minecraft is installed---"
if [ ! -f $SERVER_DIR/${JAR_NAME}.jar ]; then
	cd ${SERVER_DIR}
	echo "---Downloading Minecraft Server 1.14.1
    wget -qi https://launcher.mojang.com/v1/objects/ed76d597a44c5266be2a7fcd77a8270f1f0bc118/server.jar
    sleep 2
    if [ ! -f $SERVER_DIR/${JAR_NAME}.jar ]; then
    	echo "---Something went wrong, please install Minecraft Server manually---"
    fi
fi

echo "---Preparing Server---"
chmod -R 770 ${DATA_DIR}
echo "---Checking for old logs---"
find ${SERVER_DIR} -name "masterLog.*" -exec rm -f {} \;

sleep infinity

echo "---Starting Server---"
cd ${SERVER_DIR}
screen -S Minecraft -L -Logfile ${SERVER_DIR}/runtime/${RUNTIME_NAME}/bin/java -Xmx${XMX_SIZE} -Xms${XMS_SIZE} -jar ${SERVER_DIR}/${JAR_NAME}.jar nogui ${GAME_PARAMS}