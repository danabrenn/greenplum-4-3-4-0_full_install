#!/usr/bin/env bash

echo "***** Pivotal Greenplum Database Initialization *****"

# change to the root directory
cd /

# make greenplum database commands available to root
source /usr/local/greenplum-db/greenplum_path.sh

cd /rawdata/Binaries

echo "***** exchange ssh keys for gpadmin between the master host, standby master host *****"
echo "***** segment host 1, segment host 2 ( mdw, smdw, sdw1 & sdw2 ) *****"
gpssh-exkeys -f hostfile_exkeys

echo "***** create initialization directory /home/gpadmin/gponfigs *****"
mkdir /home/gpadmin/gpconfigs

echo "***** copy gpinitsystem_conf to /home/gpadmin/gpconfigs *****"
cp /usr/local/greenplum-db/docs/cli_help/gpconfigs/gpinitsystem_config /home/gpadmin/gpconfigs/gpinitsystem_config

cd /home/gpadmin/gpconfigs

echo "***** create hostfile with segment hosts sdw1 & sdw2 entries *****"
echo "sdw1" > hostfile_gpinitsystem
echo "sdw2" >> hostfile_gpinitsystem

chown gpadmin:gpadmin hostfile_gpinitsystem

chmod 777 /home/gpadmin/gpconfigs

echo "***** modify gpinitsystem_config to define /data/primary and uncomment /data/mirror parameters *****"
sed -i 's/\declare -a DATA_DIRECTORY=(\/data1\/primary \/data1\/primary \/data1\/primary \/data2\/primary \/data2\/primary \/data2\/primary)/declare -a DATA_DIRECTORY=(\/data\/primary)/g' /home/gpadmin/gpconfigs/gpinitsystem_config
sed -i 's/#MIRROR_PORT_BASE=50000/MIRROR_PORT_BASE=50000/g' /home/gpadmin/gpconfigs/gpinitsystem_config
sed -i 's/#REPLICATION_PORT_BASE=41000/REPLICATION_PORT_BASE=41000/g' /home/gpadmin/gpconfigs/gpinitsystem_config
sed -i 's/#MIRROR_REPLICATION_PORT_BASE=51000/MIRROR_REPLICATION_PORT_BASE=51000/g' /home/gpadmin/gpconfigs/gpinitsystem_config
sed -i 's/#declare -a MIRROR_DATA_DIRECTORY=(\/data1\/mirror \/data1\/mirror \/data1\/mirror \/data2\/mirror \/data2\/mirror \/data2\/mirror)/declare -a MIRROR_DATA_DIRECTORY=(\/data\/mirror)/g' /home/gpadmin/gpconfigs/gpinitsystem_config

echo "***** create an instance of the greenplum database from gpinitsystem_config *****"
# must be run as gpadmin
# make greenplum database commands available to gpadmin
# run gpinitsystem
sudo -u gpadmin bash -c ". ~/.bashrc && source /usr/local/greenplum-db/greenplum_path.sh && gpinitsystem -a -c gpinitsystem_config -h hostfile_gpinitsystem -s smdw -S"

cd /home/gpadmin

echo "***** add Master Data Directory to .bash_profile *****"
echo "" >> .bash_profile
echo "MASTER_DATA_DIRECTORY=/data/master/gpseg-1" >> .bash_profile
echo "export MASTER_DATA_DIRECTORY" >> .bash_profile
echo "" >> .bash_profile
echo "source /usr/local/greenplum-db/greenplum_path.sh" >> .bash_profile

# push .bash_profile to the standby master host ( smdw )
scp /home/gpadmin/.bash_profile smdw:/home/gpadmin/

echo "***** check the state of the greenplum database *****"
# must be run as gpadmin
# shell out gpadmin's .bash_profile
# make greenplum database commands available to gpadmin
# run gpstate
#sudo -u gpadmin bash -c ". ~/.bashrc && source /home/gpadmin/.bash_profile && source /usr/local/greenplum-db/greenplum_path.sh && gpstate"
sudo -u gpadmin bash -c ". ~/.bashrc && source /home/gpadmin/.bash_profile && gpstate"