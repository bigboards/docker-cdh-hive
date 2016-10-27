#!/bin/bash

FILE_PREFIX="file://"
HDFS_FORMAT_MARKER="/etc/hadoop/hdfs.format"

HDFS_PATH_NN="$(xpath -q  -e '/configuration/property[name="dfs.namenode.name.dir"]/value/text()' '/etc/hadoop/conf/hdfs-site.xml')"
HDFS_PATH_NN="${HDFS_PATH_NN#$FILE_PREFIX}"

HDFS_FORMATTED_MARKER=$HDFS_PATH_NN"/current/VERSION"

DAEMON=$1

if [ -e "$HDFS_FORMAT_MARKER" ]; then
    echo "Found the HDFS format marker ... check formatted or not ...";

    if [ ! -f "$HDFS_FORMATTED_MARKER" ]; then
        echo "Did not find the VERSION formatted marker. Formatting hdfs before starting";

        mkdir -p $HDFS_PATH_NN

        /usr/bin/hdfs --config /etc/hadoop/conf namenode -format -force -nonInteractive

        if [ $? -eq 0 ]; then
            rm -rf "$HDFS_FORMAT_MARKER"
        fi
    else
        rm -rf "$HDFS_FORMAT_MARKER"
    fi
fi

if [ ! -e "$HDFS_FORMAT_MARKER" ]; then
    /usr/bin/hdfs --config /etc/hadoop/conf namenode
fi
