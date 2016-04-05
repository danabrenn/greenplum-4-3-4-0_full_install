#!/usr/bin/env bash

echo "***** Changing Password On Hosts *****"

# change password on mdw, smdw, sdw1 & sdw2 from 'vagrant' to 'Piv0tal'

# change to the root directory
cd /

# switch to root
/usr/bin/expect<<EOF
spawn  su - root
expect "Password"
send  "\r"
expect
EOF

# change password from 'vagrant' to 'Pivotal' on master ( mdw )
/usr/bin/expect<<EOF
spawn ssh root@172.16.1.11 passwd
expect "Are you sure you want to continue connecting (yes/no)? "
send "yes\r"
expect "New password"
send "Piv0tal\r"
expect "Retype new password"
send "Piv0tal\r"
expect
EOF

# change password from 'vagrant' to 'Pivotal' on segment host one ( sdw1 )
/usr/bin/expect<<EOF
spawn ssh root@172.16.1.12 passwd
expect "New password"
send "Piv0tal\r"
expect "Retype new password"
send "Piv0tal\r"
expect
EOF

# change password from 'vagrant' to 'Pivotal' on segment host two ( sdw2 )
/usr/bin/expect<<EOF
spawn ssh root@172.16.1.13 passwd
expect "New password"
send "Piv0tal\r"
expect "Retype new password"
send "Piv0tal\r"
expect
EOF

# change password from 'vagrant' to 'Pivotal' on standby master ( smdw )
/usr/bin/expect<<EOF
spawn ssh root@172.16.1.14 passwd
expect "New password"
send "Piv0tal\r"
expect "Retype new password"
send "Piv0tal\r"
expect
EOF
