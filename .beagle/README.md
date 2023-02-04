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
# cache build
docker run \
--rm \
-v $PWD/:/go/src/github.com/grafana/grafana \
-v $PWD/bin/cache/:/cache \
-w /go/src/github.com/grafana/grafana \
-e PLUGIN_REBUILD=true \
-e PLUGIN_CHECK=yarn.lock \
-e PLUGIN_MOUNT=./node_modules,./packages/grafana-data/node_modules,./packages/grafana-e2e/node_modules,./packages/grafana-e2e-selectors/node_modules,./packages/grafana-runtime/node_modules,./packages/grafana-toolkit/node_modules,./packages/grafana-ui/node_modules,./packages/jaeger-ui-components/node_modules,plugins-bundled/internal/input-datasource/node_modules \
-e DRONE_COMMIT_BRANCH=dev \
-e CI_WORKSPACE=/go/src/github.com/grafana/grafana \
registry.cn-qingdao.aliyuncs.com/wod/devops-cache:1.0

rm -rf \
  node_modules \
  public/build \
  packages/grafana-data/node_modules \
  packages/grafana-e2e/node_modules \
  packages/grafana-e2e-selectors/node_modules \
  packages/grafana-runtime/node_modules \
  packages/grafana-toolkit/node_modules \
  packages/grafana-ui/node_modules \
  packages/jaeger-ui-components/node_modules \
  plugins-bundled/internal/input-datasource/node_modules

# cache read
docker run \
--rm \
-v $PWD/:/go/src/github.com/grafana/grafana \
-v $PWD/bin/cache/:/cache \
-w /go/src/github.com/grafana/grafana \
-e PLUGIN_RESTORE=true \
-e PLUGIN_CHECK=yarn.lock \
-e PLUGIN_MOUNT=./node_modules,./packages/grafana-data/node_modules,./packages/grafana-e2e/node_modules,./packages/grafana-e2e-selectors/node_modules,./packages/grafana-runtime/node_modules,./packages/grafana-toolkit/node_modules,./packages/grafana-ui/node_modules,./packages/jaeger-ui-components/node_modules,plugins-bundled/internal/input-datasource/node_modules \
-e DRONE_COMMIT_BRANCH=dev \
-e CI_WORKSPACE=/go/src/github.com/grafana/grafana \
registry.cn-qingdao.aliyuncs.com/wod/devops-cache:1.0
```

## grafana-ui

```bash
docker run -ti --rm \
-v /usr/local/share/.cache/yarn:/usr/local/share/.cache/yarn \
-v $PWD/:/go/src/github.com/grafana/grafana \
-w /go/src/github.com/grafana/grafana \
registry.cn-qingdao.aliyuncs.com/wod/node:14.18.1-bullseye \
bash -c 'yarn && export NODE_ENV=production && yarn build'

docker build \
  --build-arg BASE=registry.cn-qingdao.aliyuncs.com/wod/alpine:3.12 \
  --build-arg AUTHOR=mengkzhaoyun@gmail.com \
  --build-arg VERSION=v9.3.6 \
  --tag registry.cn-qingdao.aliyuncs.com/wod/grafana-ui:v9.3.6 \
  --file .beagle/grafana-ui.dockerfile .

docker push registry.cn-qingdao.aliyuncs.com/wod/grafana-ui:v9.3.6
```
