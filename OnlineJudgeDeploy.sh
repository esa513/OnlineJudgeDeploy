#!/bin/bash

help() {
    echo "This script should not be run as the root user."
    echo "Please execute it as a non-root user using the following command and replace <TOKEN>:"
    echo "cat OnlineJudgeDeploy.sh | sh -s -- -t <TOKEN> && cd ~"
    exit
}

while getopts 't:hH?' opt
do
    case $opt in
        t)
            token=$OPTARG
            ;;
        h|H|\?)
            help
            ;;
    esac
done

if [ "$USER" = "root" ] || [ -z "$token" ]; then
    help
fi

sed -i "s|TOKEN=.*|TOKEN=$token|" docker-compose.yml
docker compose up -d
