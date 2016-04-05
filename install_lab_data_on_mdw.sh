#!/usr/bin/env bash

echo "***** Installing Lab Files On master host ( mdw ) *****"

# commands that must be run from the master host ( mdw )

# change to the root directory
cd /

# all files & directories in the  /vagrant directory are mounted on each vm
# /VM-Bits-4-3-4-0 contains all of the bits required by the lab exercises
cd vagrant/VM-Bits-4-3-4-0

# copy the /rawdata directory to  / ( root directory )
cp -r rawdata/ /

# copy the /gp directory to the /home directory
cp -r gp/ /home

# push the CustomerData.csv file to sdw1 
scp /home/gp/sql/load_files/CustomerData.csv root@172.16.1.12:/home/gp/sql/load_files/