#!/bin/bash

set -e

if [ -z ${IMAGE} ]
  then
  echo "Must provide an IMAGE"
  exit 1
fi


sed "s|{{IMAGE}}|${IMAGE}|g" docker-compose.template.yml > docker-compose.tmp.yml
sed "s|{{IMAGE}}|${IMAGE}|g" packer.template.json > packer.json

# requires mustache templating library: (npm install -g mustache)
mustache secret_vars.json docker-compose.tmp.yml > docker-compose.yml

echo "Building packer image..."
packer build -var-file=./secret_vars.json packer.json

# cleanup
rm docker-compose.tmp.yml
rm packer.json
rm docker-compose.yml
