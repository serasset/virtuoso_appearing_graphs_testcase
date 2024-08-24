#!/bin/bash
DEFAULT_RAW_DATA_DIR=./data
RAW_DATA_DIR=${RAW_DATA_DIR:-${DEFAULT_RAW_DATA_DIR}}

DOCKER_CONTENT_TRUST=false docker run --name dbnary_test_db \
    --interactive \
    --tty \
    --env DBA_PASSWORD=mysecret \
    --env VIRT_PARAMETERS_NUMBEROFBUFFERS=680000\
    --env VIRT_PARAMETERS_MaxDirtyBuffers=500000\
    --env VIRT_PARAMETERS_DirsAllowed='., ../vad, /usr/share/proj, /data'\
    --publish 2222:1111 \
    --publish 8998:8890 \
    --volume `pwd`/database:/database \
    --volume `pwd`/initdb.d:/initdb.d \
    --volume $RAW_DATA_DIR:/data:ro \
    openlink/virtuoso-opensource-7:latest