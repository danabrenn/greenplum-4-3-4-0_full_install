#!/usr/bin/env bash

echo "***** Setting up Master ( mdw ) *****"
# commands that must be run from the master host ( mdw )

# change to the root directory
cd /

# generate ssh keys on master ( mdw )
/usr/bin/expect<<EOF
spawn ssh-keygen -t rsa
expect "Enter file in which to save the key (/root/.ssh/id_rsa): "
send  "\r"
expect "Enter passphrase (empty for no passphrase): "
send  "\r"
expect "Enter same passphrase again: "
send  "\r"
expect
EOF

cd
cat .ssh/id_rsa.pub >> .ssh/authorized_keys

# push ssh keys to segment host 1 ( sdw1)
/usr/bin/expect<<EOF
spawn scp -r .ssh/ 172.16.1.12:/root/.ssh
expect "Are you sure you want to continue connecting (yes/no)?"
send "yes\r"
expect "password"
send  "vagrant\r"
expect
EOF

# push ssh keys to segment host 2 ( sdw2)
/usr/bin/expect<<EOF
spawn scp -r .ssh/ 172.16.1.13:/root/.ssh
expect "Are you sure you want to continue connecting (yes/no)?"
send "yes\r"
expect "password"
send  "vagrant\r"
expect
EOF

# push ssh keys to standby master ( smdw)
/usr/bin/expect<<EOF
spawn scp -r .ssh/ 172.16.1.14:/root/.ssh
expect "Are you sure you want to continue connecting (yes/no)?"
send "yes\r"
expect "password"
send  "vagrant\r"
expect
EOF

# define kernel parameters on master host ( mdw )
echo "kernel.shmmax = 500000000" > /etc/sysctl.conf
echo "kernel.shmmni = 4096" >> /etc/sysctl.conf
echo "kernel.shmall = 4000000000" >> /etc/sysctl.conf
echo "kernel.sem = 250 512000 100 2048" >> /etc/sysctl.conf
echo "kernel.sysrq = 1" >> /etc/sysctl.conf
echo "kernel.core_uses_pid = 1" >> /etc/sysctl.conf
echo "kernel.msgmnb = 65536" >> /etc/sysctl.conf
echo "kernel.msgmax = 65536" >> /etc/sysctl.conf
echo "kernel.msgmni = 2048" >> /etc/sysctl.conf
echo "net.ipv4.tcp_syncookies = 1" >> /etc/sysctl.conf
echo "net.ipv4.conf.default.accept_source_route = 0" >> /etc/sysctl.conf
echo "net.ipv4.tcp_tw_recycle = 1" >> /etc/sysctl.conf
echo "net.ipv4.tcp_max_syn_backlog = 4096" >> /etc/sysctl.conf
echo "net.ipv4.conf.all.arp_filter = 1" >> /etc/sysctl.conf
echo "net.ipv4.ip_local_port_range = 1025 65535" >> /etc/sysctl.conf
echo "net.ipv4.ip_forward = 0" >> /etc/sysctl.conf
echo "net.core.netdev_max_backlog = 10000" >> /etc/sysctl.conf
echo "vm.overcommit_memory = 2" >> /etc/sysctl.conf

# define security limits parameters on master host ( mdw )
echo "*soft nofile 65536" >> /etc/security/limits.conf
echo "*hard nofile 65536" >> /etc/security/limits.conf
echo "*soft nproc  131072" >> /etc/security/limits.conf
echo "*hard nproc  131072" >> /etc/security/limits.conf

# change to the /etc ( source directory for sysctl.conf and limits.conf
cd /etc

# push kernel parameters to smd2, sdw1 & sdw2
scp /etc/sysctl.conf 172.16.1.14:/etc
scp /etc/sysctl.conf 172.16.1.13:/etc
scp /etc/sysctl.conf 172.16.1.12:/etc

# push security limit parameters to smd2, sdw1 & sdw2
scp /etc/security/limits.conf 172.16.1.14:/etc/security
scp /etc/security/limits.conf 172.16.1.13:/etc/security
scp /etc/security/limits.conf 172.16.1.12:/etc/security