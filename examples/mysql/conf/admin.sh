#!/bin/bash

# Stop mysql
service mysql stop

# Start as a safe, with no password check
mysqld_safe --skip-grant-tables &

# Wait some time to let the mysql service start
sleep 5

# Create the new admin user, adding an instruction to ensure grant tables are available
echo 'FLUSH PRIVILEGES;' | cat - /tmp/admin.sql | mysql

# Stop mysql
service mysql stop

