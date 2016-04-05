#!/usr/bin/env bash

echo "***** Installing Greenplum Database 4.3.4.0 on master ( mdw ) *****"

# change to the root directory
cd /

cd /rawdata/Binaries

#unzip the greenplum database installer
unzip greenplum-db-4.3.4.0-build-1-RHEL5-x86_64.zip

#unzip the greenplum command center installer
unzip greenplum-cc-web-1.3.0.0-build-91-RHEL5-x86_64.zip

# install greenplum database to /usr/local ( default ) on master ( mdw )
/usr/bin/expect<<EOF

spawn  /bin/bash greenplum-db-4.3.4.0-build-1-RHEL5-x86_64.bin

send "\q"

expect "Do you accept the Pivotal Database license agreement" 
send "yes\r"

expect "Provide the installation path for Greenplum Database" 
send "\r"

expect "Install Greenplum Database into </usr/local/greenplum-db" 
send "yes\r"

expect "/usr/local/greenplum-db" 
send "yes\r"

expect "Provide the path to previous installation"
send "\r"

expect

EOF

echo "***** Installing Greenplum Command Center 1.3.0.0 on master ( mdw ) *****"

# install greenplum command center to /usr/local/greenplum-cc-web-1.3.0.0-build-91 on master ( mdw )
/usr/bin/expect<<EOF

spawn  /bin/bash greenplum-cc-web-1.3.0.0-build-91-RHEL5-x86_64.bin

send "\q"

expect "Do you accept the Pivotal Greenplum Database end user license"
send "yes\r"

expect "Provide the installation path for Greenplum Command Center or"
send "\r"

expect "Install Greenplum Command Center into </usr/local/greenplum-cc" 
send "yes\r"

expect "/usr/local/greenplum-cc" 
send "yes\r"
expect

EOF