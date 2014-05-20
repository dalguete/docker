# Apache2
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

# Install Apache and some required packages
RUN apt-get install -y apache2 php5 php-apc curl php5-curl php5-gd php5-mysql php5-xdebug

# Enable mod_rewrite
RUN a2enmod rewrite

# Load initial config for the supervisor to run
ADD conf/supervisord.conf /etc/supervisor/conf.d/

# Start supervisor inside container to run SSH plus Apache services
ENTRYPOINT /usr/bin/supervisord

# Same as above, build for images built upon the one here created
ONBUILD ENTRYPOINT /usr/bin/supervisord

