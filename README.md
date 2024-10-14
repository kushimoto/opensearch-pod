# OpenSearch Pod

これは個人的に OpenSearch を Podman の Pod で構築するために作ったメモです。  
利用において私は責任を持ちません。
(というか試行錯誤の反映漏れがあって動かないかもしれない...)

## 使い方

この Pod には２つのコンテナが含まれます。

- opensearch
- opensearch-dashboards

※ すべての作業は root ユーザーで進めます。

### コンテナイメージのDL
以下のイメージを利用しておりますので、予めダウンロードしておきます。

- docker.io/opensearchproject/opensearch:2
- docker.io/opensearchproject/opensearch-dashboards:2

```shell
podman pull docker.io/opensearchproject/opensearch:2
podman pull docker.io/opensearchproject/opensearch-dashboards:2
```

### opensearch-pod.yml の書き換え

環境変数などは自分で書き換えましょう。(言いたいのはそれだけ)

### 初期化

以下のスクリプトを実行します。

```shell
git clone https://github.com/kushimoto/opensearch-pod.git
cd opensearch-pod
bash init.sh
```

### 登録

以下のコマンドを実行します

```shell
/usr/libexec/podman/quadlet /usr/share/containers/systemd/opensearch-pod.kube 
systemctl daemon-reload
systemctl start opensearch-pod.service
```

### ログイン

http://{サーバーのIPアドレス}}:8002 にアクセスして admin/admin でログインできます。

selinux が有効な場合は下記コマンドが必要かもしれない。(ファイアウォールはまだ検索しやすいので書かないぞ :heart: )

```shell
semanage port -a -t http_port_t -p tcp 9200
semanage port -a -t http_port_t -p tcp 5601
```

### メモ欄

- Podを作る

```shell
podman pod create --name opensearch -p 9200:9200 -p 5601:5601 --network slirp4netns
```

- コンテナを作る

```shell
podman run -d --name dashboard --pod opensearch  \
  -e OPENSEARCH_HOSTS="https://127.0.0.1:9200" \
  docker.io/opensearchproject/opensearch-dashboards:2

podman run -d --name app --pod opensearch  \
  -e cluster.name=os-cluster \
  -e node.name=os-node \
  -e node.store.allow_mmap=false \
  -e cluster.initial_master_nodes=os-node \
  -e bootstrap.memory_lock=false \
  -e OPENSEARCH_JAVA_OPTS="-Xms512m -Xmx512m" \
  -e OPENSEARCH_INITIAL_ADMIN_PASSWORD="l%zglAd6Cc9p" \
  -v /opt/opensearch-pod/data/app:/usr/share/opensearch/data:Z \
  docker.io/opensearchproject/opensearch:2
```

- YAMLを吐き出す

```shell
podman generate kube opensearch
```
