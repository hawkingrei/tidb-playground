#!/usr/bin/env bash
set -x
current_date=$(date +%Y-%m-%d)
TIDB_VERSION_SLICE=('v7.5.7' 'v8.1.2' 'v8.5.3' "nightly")

NO_PUSH=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --no-push)
            NO_PUSH=true
            shift
            ;;
        *)
            shift
            ;;
    esac
done

for version in "${TIDB_VERSION_SLICE[@]}"
do

    export TIDB_VERSION=${version}
    if [ "$version" == "nightly" ]; then
        TIDB_VERSION="${version}-${current_date}"
    fi
    echo ${version}
    docker build -t hawkingrei/tidb-playground:${TIDB_VERSION}-with-tiflash --no-cache  --build-arg TIDB_VERSION=${version} -f Dockerfile_with_tiflash .
    if [ "$NO_PUSH" = false ]; then
        docker push hawkingrei/tidb-playground:${TIDB_VERSION}-with-tiflash
    fi
done
docker tag hawkingrei/tidb-playground:nightly-${current_date}-with-tiflash  hawkingrei/tidb-playground:nightly-with-tiflash
if [ "$NO_PUSH" = false ]; then
    docker push hawkingrei/tidb-playground:nightly-with-tiflash
fi
