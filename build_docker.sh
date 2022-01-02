#!/bin/bash

cd docker
docker build . --tag=turtlebot3_melodic \
	--build-arg uid=$UID \
	--build-arg user=$USER \
	--build-arg gid=$(id -g) &&  
docker rmi $(docker images -qa -f 'dangling=true')
