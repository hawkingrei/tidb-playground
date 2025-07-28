FROM bitnami/minideb:latest

RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

RUN  curl --proto '=https' --tlsv1.2 -sSf https://tiup-mirrors.pingcap.com/install.sh | sh && ln -s /root/.tiup/bin/tiup /bin/tiup

RUN tiup install tidb:${TIDB_VERSION} pd:${TIDB_VERSION} tikv:${TIDB_VERSION} playground
COPY config.toml /root/.tiup/config.toml
CMD tiup playground ${TIDB_VERSION} --db.host 0.0.0.0 --tiflash 0 --db.config /root/.tiup/config.toml
