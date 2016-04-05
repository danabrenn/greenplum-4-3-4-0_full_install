#!/usr/bin/env bash

echo "***** Installing Greenplum Database 4.3.4.0 on segment hosts ( sdw1 & sdw2 ) *****"

# change to the root directory
cd /

# make greenplum database commands available
source /usr/local/greenplum-db/greenplum_path.sh

cd /rawdata/Binaries

# create hostfile_exkeys containing all host names
echo "mdw" > hostfile_exkeys
echo "smdw" >> hostfile_exkeys
echo "sdw1" >> hostfile_exkeys
echo "sdw2" >> hostfile_exkeys

chmod 777 hostfile_exkeys

echo "***** exchange ssh keys for root between the master host, standby master host *****"
echo "***** segment host 1, segment host 2 ( mdw, smdw, sdw1 & sdw2 ) *****"
gpssh-exkeys -f hostfile_exkeys

# create hostfile_gpssh_segonly containing only segment host names
echo "sdw1" > hostfile_gpssh_segonly
echo "sdw2" >> hostfile_gpssh_segonly

chmod 777 hostfile_gpssh_segonly

echo "***** Installing Greenplum Database on segment hosts ( sdw1 & sdw2 ) *****"
# add a system user (default: gpadmin) & create a password (default: changeme)
# deploy greenplum database on segment hosts ( sdw1 & swd2 )
# exchange keys between all greenplum database hosts as both root and gpadmin
gpseginstall -f hostfile_exkeys -u gpadmin -p changeme

# test that all hosts are accessable and have their own copy of the greenplum software installed
gpssh -f hostfile_exkeys -e ls -la $GPHOME

echo "***** Creating The Data Storage Area's *****"

cd /

echo "***** Creating /data/master directories on master host ( mdw ) *****"

mkdir data/master

chown gpadmin:gpadmin /data/master

echo "***** Creating /data/master directories on standby master host ( smdw ) *****"
gpssh -h smdw -e 'mkdir /data/master'
gpssh -h smdw -e 'chown gpadmin:gpadmin /data/master'

cd /rawdata/Binaries

echo "***** Creating /data/master directories on segment hosts ( sdw1 & sdw2 )*****"
gpssh -f hostfile_gpssh_segonly -e 'mkdir /data/primary /data/mirror; chown gpadmin:gpadmin /data/primary /data/mirror'

#check /data directories on all hosts
gpssh -h mdw -e 'ls -laR /data'
gpssh -h smdw -e 'ls -laR /data'
gpssh -h sdw1 -e 'ls -laR /data'
gpssh -h sdw2 -e 'ls -laR /data'

echo "***** Synchronizing System Clocks *****"
echo "***** Setup NTP on master host ( mdw ) *****"
sed -i 's/server 0.centos.pool.ntp.org/#server 0.centos.pool.ntp.org/g' /etc/ntp.conf
sed -i 's/server 1.centos.pool.ntp.org/#server 0.centos.pool.ntp.org/g' /etc/ntp.conf
sed -i 's/server 2.centos.pool.ntp.org/#server 0.centos.pool.ntp.org/g' /etc/ntp.conf
echo "server 172.16.1.14" >> /etc/ntp.conf
/etc/init.d/ntpd start

echo "***** Setup NTP on segment host 1 ( sdw1 ) *****"
gpssh -h sdw1 -e 'sed -i "s/server 0.centos.pool.ntp.org/#server 0.centos.pool.ntp.org/g" /etc/ntp.conf'
gpssh -h sdw1 -e 'sed -i "s/server 1.centos.pool.ntp.org/#server 0.centos.pool.ntp.org/g" /etc/ntp.conf'
gpssh -h sdw1 -e 'sed -i "s/server 2.centos.pool.ntp.org/#server 0.centos.pool.ntp.org/g" /etc/ntp.conf'
gpssh -h sdw1 -e 'echo "server mdw prefer" >> /etc/ntp.conf'
gpssh -h sdw1 -e 'echo "server smdw" >> /etc/ntp.conf'
gpssh -h sdw1 -e '/etc/init.d/ntpd start'

echo "***** Setup NTP on segment host 2 ( sdw2 ) *****"
gpscp -h sdw2 /etc/ntp.conf =:/etc/ntp.conf
gpssh -h sdw2 -e '/etc/init.d/ntpd start'

echo "***** Setup NTP on standby master host ( smdw ) *****"
gpssh -h smdw -e 'sed -i "s/server 0.centos.pool.ntp.org/#server 0.centos.pool.ntp.org/g" /etc/ntp.conf'
gpssh -h smdw -e 'sed -i "s/server 1.centos.pool.ntp.org/#server 0.centos.pool.ntp.org/g" /etc/ntp.conf'
gpssh -h smdw -e 'sed -i "s/server 2.centos.pool.ntp.org/#server 0.centos.pool.ntp.org/g" /etc/ntp.conf'
gpssh -h smdw -e 'echo "server mdw prefer" >> /etc/ntp.conf'
gpssh -h smdw -e 'echo "server 172.16.1.14" >> /etc/ntp.conf'
gpssh -h smdw -e '/etc/init.d/ntpd start'

echo "***** reset nptd service on all hosts *****"
gpssh -f hostfile_exkeys -v -e 'ntpd'

echo "***** verify ntpd service is executing on all hosts *****"
gpssh -f hostfile_exkeys -e 'pgrep ntp'