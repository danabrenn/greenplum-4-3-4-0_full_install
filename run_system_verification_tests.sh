#!/usr/bin/env bash

echo "***** Performing System Verification Tests On All Hosts *****"

# change to the root directory
cd /

# make greenplum database commands available
source /usr/local/greenplum-db/greenplum_path.sh

echo "***** execute /rawdata/solutions/lab2/update_block_devices_IO_scheduler.sh to resolve scheduler & readahead errors *****"
/rawdata/solutions/lab2/update_block_devices_IO_scheduler.sh

cd /rawdata/Binaries

echo "***** confirm scheduler & readahead errors are resolved *****"
gpcheck -f hostfile_exkeys

echo "***** save, stop and disable iptables *****"
gpssh -f hostfile_exkeys -e 'service iptables save'
gpssh -f hostfile_exkeys -e 'service iptables stop'
gpssh -f hostfile_exkeys -e 'chkconfig iptables off'

echo "***** run performance checks on all hosts *****"
gpcheckperf -f hostfile_exkeys -d /data -D



