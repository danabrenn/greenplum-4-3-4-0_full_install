#!/usr/bin/env bash

echo "***** Pivotal Greenplum Command Center Initialization *****"

# change to the root directory
cd /

# change ownership of /usr/local/greenplum-cc-web-1.3.0.0-build-91 to gpadmin
chown -h gpadmin:gpadmin /usr/local/greenplum-cc-web
chown -R gpadmin:gpadmin /usr/local/greenplum-cc-web-1.3.0.0-build-91

echo "***** Install gpperfmon *****"
# make greenplum database commands available to gpadmin
# install gpperfmon
#sudo -u gpadmin bash -c ". ~/.bashrc && source /home/gpadmin/.bash_profile && source /usr/local/greenplum-db/greenplum_path.sh && gpperfmon_install --enable --password changeme --port 5432"
sudo -u gpadmin bash -c ". ~/.bashrc && source /home/gpadmin/.bash_profile && gpperfmon_install --enable --password changeme --port 5432"

cd /home/gpadmin

# echo "***** add GPPERFMONHOME to .bash_profile *****"
echo "" >> .bash_profile
echo "GPPERFMONHOME=/usr/local/greenplum-cc-web" >> .bash_profile
echo "export GPPERFMONHOME" >> .bash_profile
echo "" >> .bash_profile
echo "source /usr/local/greenplum-cc-web/gpcc_path.sh" >> .bash_profile

source /home/gpadmin/.bash_profile

# add pg_hba.conf entry to allow access by gpmon to gpperfmon via ip6 ::1
echo "host     all                 gpmon   ::1/128                md5" >>  /data/master/gpseg-1/pg_hba.conf

echo "***** run gpstop -u to reload pg_hba.conf *****"
# make greenplum database commands available to gpadmin
# run gpstop
#sudo -u gpadmin bash -c ". ~/.bashrc && source /home/gpadmin/.bash_profile && source /usr/local/greenplum-db/greenplum_path.sh && gpstop -u"
sudo -u gpadmin bash -c ". ~/.bashrc && source /home/gpadmin/.bash_profile && gpstop -u"

echo "***** running gpcmdr --setup for Greenplum Command Center *****"
# setup Greenplum Command Center
/usr/bin/expect<<EOF

spawn  sudo -u gpadmin bash -c ". ~/.bashrc && source /home/gpadmin/.bash_profile && source /usr/local/greenplum-db/greenplum_path.sh && gpcmdr --setup"

expect "Please enter a new instance name:"
send "gp1\r"

expect "Is the master host for the Greenplum Database remote?"
send "\r"

expect "What would you like to use for the display name for this instance:" 
send "traindb\r"

expect "What port does the Greenplum Database use?" 
send "\r"

expect "What port would you like the web server to use for this instance" 
send "\r"

expect "Do you want to enable SSL for the Web API" 
send "y\r"

expect "Country Name (2 letter code)" 
send "US\r"

expect "State or Province Name (full name)" 
send "MA\r"

expect "Locality Name (eg, city)" 
send "Hopkinton\r"

expect "Organization Name (eg, company)" 
send "Pivotal Inc.\r"

expect "Organizational Unit Name (eg, section)" 
send "Education\r"

expect "Common Name (e.g. server FQDN or YOUR name)" 
send "mdw\r"

expect "Email Address" 
send "gpadmin@mdw\r"

expect "Do you want to enable ipV6 for the Web API" 
send "\r"

expect "Do you want to enable Cross Site Request Forgery Protection for the Web API" 
send "\r"

expect "Do you want to copy the instance to a standby master host" 
send "n\r"

expect

EOF

echo "***** starting Greenplum Command Center *****"
# start Greenplum Command Center
#sudo -u gpadmin bash -c ". ~/.bashrc && source /home/gpadmin/.bash_profile && source /usr/local/greenplum-db/greenplum_path.sh && gpcmdr --start gp1"
sudo -u gpadmin bash -c ". ~/.bashrc && source /home/gpadmin/.bash_profile && gpcmdr --start gp1"