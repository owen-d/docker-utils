
#!/bin/sh

# provision elasticsearch user
adduser --no-create-home --disabled-password --gecos '' elasticsearch
adduser elasticsearch sudo

mkdir /elasticsearch || :
mkdir /data || :
chown -R elasticsearch /elasticsearch /data
echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# set environment
export CLUSTER_NAME=${CLUSTER_NAME:-elasticsearch-default}
export NODE_MASTER=${NODE_MASTER:-true}
export NODE_DATA=${NODE_DATA:-true}
export HTTP_ENABLE=${HTTP_ENABLE:-true}
export HTTP_CORS_ENABLE=${HTTP_CORS_ENABLE:-true}
export NETWORK_HOST=${NETWORK_HOST:-0.0.0.0}
export MULTICAST=${MULTICAST:-false}

# Discovery stuff
export ES_DISCOVERY_SG=${ES_DISCOVERY_SG:-elasticsearch-cluster-sg}

# AWS stuff
export AWS_REGION=${AWS_REGION:-us-east-1}

# allow for memlock, currently done via docker-compose ulimit allocation
# ulimit -l ${MEMORY_CEILING:-9223372036854775807}

# extend to the elasticsearch user within the container (who actually runs the es process)
echo "elasticsearch - nofile 65535
elasticsearch - memlock unlimited" | sudo tee -a /etc/security/limits.conf >/dev/null
# run
sudo -E -u elasticsearch /elasticsearch/bin/elasticsearch
