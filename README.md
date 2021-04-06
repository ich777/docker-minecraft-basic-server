# Minecraft Basic Server in Docker optimized for Unraid
This is a Basic Minecraft Server, with the basic configuration it will download and install a Vanilla Minecraft Server. You can also install a FTB (FeedTheBeast), Bukkit, Spigot,... server.
If you want to copy over your favorite server executable (don't forget to set the Serverfile name to the same as you copied over without the '.jar' extension) and start the container again or simply start the server if you wait for it to completely start if you want to play Minecraft Vanilla.

UPDATE: If you set the variable GAME_V to 'latest' the container will check on every restart if there is a newer version available (if set to 'latest' the variable JAR_NAME has to be 'server').

JAVA RUNTIME: Enter your prefered Runtime 'basicjre'=jre8, 'jre11'=jre11, 'jre15'=jre15 Don't change unless you are knowing what you are doing! Please keep in mind if you change the runtime you have to delete the old runtime before!

ATTENTION: Don't forget to accept the EULA down below and don't forget to edit the 'server.properties' file the server is by default configured to be a LAN server and to be not snooped.

>**WEB CONSOLE:** You can connect to the Minecraft console by opening your browser and go to HOSTIP:9011 (eg: 192.168.1.1:9011) or click on WebUI on the Docker page within Unraid.

## Env params
| Name | Value | Example |
| --- | --- | --- |
| SERVER_DIR | Folder for gamefile | /serverdata/serverfiles |
| RUNTIME_NAME | Enter your prefered Runtime 'basicjre'=jre8, 'jre11'=jre11, 'jre15'=jre15 Don't change unless you are knowing what you are doing! Please keep in mind if you change the runtime you have to delete the old runtime before! | basicjre |
| JAR_NAME | Executable jar file (Minecraft Serverfile) withouat the .jar extension. | server |
| GAME_PARAMS | Extra startup Parameters if needed (leave empty if not needed) | |
| GAME_PORT | TCP Gameport for the server | 25565 |
| GAME_V | If set to 'latest' the JAR_NAME must be 'server' valid options are 'latest', 'custom' or simply leave empty | latest |
| XMX_SIZE | Enter your XMX size in MB (XMX=The maximum heap size. The performance will decrease if the max heap value is set lower than the amount of live data. It will force frequent garbage collections in order to free up space). | 1024 |
| XMS_SIZE | Enter your XMS size in MB (XMS=The initial and minimum heap size. It is recommended to set the minimum heap size equivalent to the maximum heap size in order to minimize the garbage collection). | 1024 |
| EXTRA_JVM_PARAMS | Extra JVM startup Parameters if needed (leave empty if not needed) | |
| ACCEPT_EULA | Head over to: https://account.mojang.com/documents/minecraft_eula to read the EULA. (If you accept the EULA change the value to 'true' without quotes). | true |
| UID | User Identifier | 99 |
| GID | Group Identifier | 100 |

## Run example
```
docker run --name MinecraftBasicServer -d \
	-p 25565:25565 -p 9011:8080 \
	--env 'RUNTIME_NAME=basicjre' \
	--env 'JAR_NAME=server' \
	--env 'GAME_V=latest' \
	--env 'GAME_PORT=25565' \
	--env 'XMX_SIZE=1024' \
    --env 'XMS_SIZE=1024' \
    --env 'ACCEPT_EULA=true' \
	--env 'UID=99' \
	--env 'GID=100' \
	--volume /mnt/user/appdata/minecraftbasicserver:/serverdata/serverfiles \
	ich777/minecraftbasicserver
```
>**NOTE** You can also forward port the TCP port 25575 if you want to connect to the RCON console.


This Docker was mainly edited for better use with Unraid, if you don't use Unraid you should definitely try it!

#### Support Thread: https://forums.unraid.net/topic/79530-support-ich777-gameserver-dockers/