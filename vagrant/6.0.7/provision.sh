#!/usr/bin/env bash

set -eux

sudo apt-get update
sudo dpkg --configure -a
sudo apt-get install -y --no-install-recommends \
        ca-certificates \
        unzip

sudo add-apt-repository -y ppa:webupd8team/java
sudo apt-get update
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
sudo apt-get install -y oracle-java8-installer
java -version
javac -version

wget "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.7.0.zip"
sha512sum -c "elasticsearch-6.7.0.zip.sha512"
unzip -o -q elasticsearch-6.7.0.zip  # overwrite files

cp -f ~/elasticsearch.yml ~/elasticsearch-6.7.0/config/elasticsearch.yml
cp -f ~/jvm.options ~/elasticsearch-6.7.0/config/jvm.options

# make sure all resources used by ElasticSearch
sudo cp -f ~/limits.conf /etc/security/limits.conf
sudo cp -f ~/pamd_su /etc/pam.d/su

sudo cp -f ~/sysctl.conf /etc/sysctl.conf
sudo sysctl --system

source ~/.env

sudo -E -u vagrant ~/elasticsearch-6.7.0/bin/elasticsearch

