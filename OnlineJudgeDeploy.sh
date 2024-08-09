#!/bin/bash

help() {
    echo "This script should not be run as the root user."
    echo "Please execute it as a non-root user using the following command and replace <TOKEN>:"
    echo "cat OnlineJudgeDeploy.sh | sh -s -- -t <TOKEN>"
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

cd ~/OnlineJudge/OnlineJudgeDeploy
sed -i "s|TOKEN=.*|TOKEN=$token|" docker-compose.yml
docker compose --profile esa pull
docker compose --profile esa up -d --build

# 無法從原始碼 build 的話，需透過以下方式更新（可能需要修改）
# cd ~/OnlineJudge/OnlineJudgeBE
# git remote add -f b https://github.com/QingdaoU/OnlineJudge.git
# git remote update
# git diff remotes/b/master master > be.patch
# git remote rm b
# docker cp be.patch oj-backend:/tmp/
# docker exec oj-backend patch -p1 -i /tmp/be.patch
# docker exec oj-backend rm /tmp/be.patch
# rm be.patch

# cd ~/OnlineJudge/OnlineJudgeDeploy
# docker compose --profile origin stop
# docker compose --profile origin start
