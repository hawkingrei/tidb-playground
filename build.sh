#!/usr/bin/env bash
set -x
TIDB_VERSION_SLICE=('v7.5.6' 'v8.1.2' 'v8.5.2' 'nightly')

for version in "${TIDB_VERSION_SLICE[@]}"
do
    export TIDB_VERSION=${version}
    echo ${version}
	docker build -t hawkingrei/tidb-playground:${TIDB_VERSION}  --build-arg TIDB_VERSION .
    docker push hawkingrei/tidb-playground:${TIDB_VERSION}
done
