#!/bin/bash

DOCKER_REPOSITORY=011790541531.dkr.ecr.us-east-1.amazonaws.com/gandalf_kafka

eval $(aws ecr get-login)
docker build -t $DOCKER_REPOSITORY ./
docker push $DOCKER_REPOSITORY
