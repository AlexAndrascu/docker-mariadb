FROM debian:wheezy
MAINTAINER ALEX, ANDRASCU <office@intellix.eu>

RUN apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db && \
    echo 'deb http://ftp.osuosl.org/pub/mariadb/repo/5.5/debian wheezy main' >> /etc/apt/sources.list && \
    echo 'deb-src http://ftp.osuosl.org/pub/mariadb/repo/5.5/debian wheezy main' >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y --force-yes mariadb-server pwgen inotify-tools && \
    rm -rf /var/lib/mysql/* && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

#change bind address to 0.0.0.0
RUN sed -i -r 's/bind-address.*$/bind-address = 0.0.0.0/' /etc/mysql/my.cnf

# Change the innodb-buffer-pool-size to 128M (default is 256M).
# This should make it friendlier to run on low memory servers.
RUN sed -i -e 's/^innodb_buffer_pool_size\s*=.*/innodb_buffer_pool_size = 128M/' /etc/mysql/my.cnf

ADD scripts /scripts
RUN chmod +x /scripts/start.sh
RUN touch /firstrun

# Add VOLUMEs to allow backup of config and databases
VOLUME  ["/etc/mysql"]

EXPOSE 3306
CMD ["/scripts/start.sh"]
