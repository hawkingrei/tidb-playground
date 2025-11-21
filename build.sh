#!/usr/bin/env bash
set -x
current_date=$(date +%Y-%m-%d)
TIDB_VERSION_SLICE=('v7.5.7' 'v8.1.2' 'v8.5.3' "nightly")

for version in "${TIDB_VERSION_SLICE[@]}"
do

    export TIDB_VERSION=${version}
    if [ "$version" == "nightly" ]; then
        TIDB_VERSION="${version}-${current_date}"
    fi
    echo ${version}
    docker build -t hawkingrei/tidb-playground:${TIDB_VERSION} --no-cache  --build-arg TIDB_VERSION=${version} .
    docker push hawkingrei/tidb-playground:${TIDB_VERSION}
done
docker tag hawkingrei/tidb-playground:nightly-${current_date}  hawkingrei/tidb-playground:nightly
docker push hawkingrei/tidb-playground:nightly
