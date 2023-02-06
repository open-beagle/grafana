# grafana

<https://github.com/grafana/grafana>

```bash
git remote add upstream git@github.com:grafana/grafana.git

git fetch upstream

git merge v9.3.6
```

## build

```bash
docker run -it --rm \
-v /usr/local/share/.cache/yarn:/usr/local/share/.cache/yarn \
-v $PWD/:/go/src/github.com/grafana/grafana \
-w /go/src/github.com/grafana/grafana \
registry.cn-qingdao.aliyuncs.com/wod/devops-node:v16 \
bash -c 'YARN_ENABLE_PROGRESS_BARS=false yarn install --immutable && yarn build && yarn run plugins:build-bundled'

docker run -it --rm \
-v $PWD/:/go/src/github.com/grafana/grafana \
-w /go/src/github.com/grafana/grafana \
registry.cn-qingdao.aliyuncs.com/wod/golang:1.19 \
bash .beagle/build.sh
```

## cache

```bash
# 构建缓存-->推送缓存至服务器
docker run --rm \
  -e PLUGIN_REBUILD=true \
  -e PLUGIN_ENDPOINT=$PLUGIN_ENDPOINT \
  -e PLUGIN_ACCESS_KEY=$PLUGIN_ACCESS_KEY \
  -e PLUGIN_SECRET_KEY=$PLUGIN_SECRET_KEY \
  -e DRONE_REPO_OWNER="open-beagle" \
  -e DRONE_REPO_NAME="grafana" \
  -e PLUGIN_MOUNT="./.git,./public/build,./public/views" \
  -v $(pwd):$(pwd) \
  -w $(pwd) \
  registry.cn-qingdao.aliyuncs.com/wod/devops-s3-cache:1.0

# 读取缓存-->将缓存从服务器拉取到本地
docker run --rm \
  -e PLUGIN_RESTORE=true \
  -e PLUGIN_ENDPOINT=$PLUGIN_ENDPOINT \
  -e PLUGIN_ACCESS_KEY=$PLUGIN_ACCESS_KEY \
  -e PLUGIN_SECRET_KEY=$PLUGIN_SECRET_KEY \
  -e DRONE_REPO_OWNER="open-beagle" \
  -e DRONE_REPO_NAME="grafana" \
  -v $(pwd):$(pwd) \
  -w $(pwd) \
  registry.cn-qingdao.aliyuncs.com/wod/devops-s3-cache:1.0
```
