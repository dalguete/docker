# MySQL
#
# VERSION               0.0.1

FROM dalguete/ubuntu-14-04-64
MAINTAINER Daniel Dalgo <dalguete@gmail.com>

# Reset dalguete's password
ADD conf/dalguete.pass /tmp/
RUN echo "dalguete:`cat /tmp/dalguete.pass`" | chpasswd && rm /tmp/dalguete.pass

# Update packages
RUN apt-get update

# Load debconf selections (required in packages installation later)
ADD conf/debconf-set-selections /tmp/
RUN debconf-set-selections /tmp/debconf-set-selections && rm /tmp/debconf-set-selections

# Install MySQL and some required packages
RUN apt-get install -y mysql-client mysql-server phpmyadmin

# Enable access to phpmyadmin by accessing server address
RUN sed -i -e"s/DocumentRoot\s*\/var\/www\/html/DocumentRoot \/usr\/share\/phpmyadmin/" /etc/apache2/sites-available/000-default.conf

# Load some file used to create an admin admin user
ADD conf/admin.sh /tmp/admin.sh
ADD conf/admin.sql /tmp/admin.sql

# Create the new admin user
RUN sh /tmp/admin.sh && rm /tmp/admin.sql && rm /tmp/admin.sh

# Load some custom setting for mysql
ADD conf/mysql.cnf /etc/mysql/conf.d/

# Load initial config for the supervisor to run
ADD conf/supervisord.conf /etc/supervisor/conf.d/

# Start supervisor inside container to run services defined above
ENTRYPOINT /usr/bin/supervisord

# Same as above, build for images built upon the one here created
ONBUILD ENTRYPOINT /usr/bin/supervisord

