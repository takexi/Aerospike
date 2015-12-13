FROM centos:centos7

# Install Aerospike
RUN \
  yum update -y \
  && yum install -y tar wget logrotate \
  && wget -O aerospike.tgz 'http://aerospike.com/download/server/latest/artifact/el6' \
  && tar zxf aerospike.tgz \
  && cd aerospike-server-community-*-el6 \
  && ./asinstall \
  && cd ../ \
  && rm -rf aerospike.tgz aerospike-server-community-*-el6 

# Add the Aerospike configuration specific to this dockerfile
ADD aerospike.conf /etc/aerospike/aerospike.conf

# Mount the Aerospike data directory
VOLUME ["/opt/aerospike/data"]

# Expose Aerospike ports
#
#   3000 ? service port, for client connections
#   3001 ? fabric port, for cluster communication
#   3002 ? mesh port, for cluster heartbeat
#   3003 ? info port
#
EXPOSE 3000 3001 3002 3003

# Execute the run script in foreground mode
CMD ["/usr/bin/asd","--foreground"]
