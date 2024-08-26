#!/bin/bash

# Diretorio de trabalho que deseja-se mapear para dentro do container.
GIT_REP=/home/arthur/workspace
IMAGE_NAME=mettainnovations/dev:2.2
CONTAINER_NAME=dev_tc

docker create -it --privileged \
	--runtime=nvidia --gpus all \
	--name $CONTAINER_NAME \
	--ipc=host \
	-p 9016:9016 \
	--restart always \
	-v $GIT_REP/html:/html \
	-v $GIT_REP:/home/developer/workspace \
	-v $HOME/.Xauthority:/root/.Xauthority \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-e DISPLAY=$DISPLAY \
	$IMAGE_NAME

# Flags de GPU.
#--runtime=nvidia --gpus all
