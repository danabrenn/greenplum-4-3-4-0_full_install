#!/usr/bin/env bash

echo "***** Installing Lab Files On sdw1 *****"

# change to the root directory
cd /

# all files & directories in the  /vagrant directory are mounted each vm
# VM-Bits-4-3-4-0 contains all of the bits required to build a full GPDB 4.3.4.0
# sandbox and perform all of the EMC GPDB lab exercises
cd vagrant/VM-Bits-4-3-4-0

# extract sdw1_loaddata.tar to the /loaddata directory
# Note that this data is loaded to sdw1 only
tar -xf sdw1_loaddata.tar -C /

# create /home/gp/sql/load_files on sdw1 to store CustomerData.csv
mkdir -p /home/gp/sql/load_files