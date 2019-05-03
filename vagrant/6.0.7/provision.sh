#!/usr/bin/env bash

# -e: exit if any commands return non-zero status
set -eux

# install necessary packages
sudo apt-get update
sudo dpkg --configure -a
sudo apt-get install -y --no-install-recommends \
        ca-certificates \
        unzip

# install java8
sudo add-apt-repository -y ppa:webupd8team/java
sudo apt-get update
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
sudo apt-get install -y oracle-java8-installer
java -version
javac -version

wget "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.7.0.zip" -O ~/elasticsearch-6.7.0.zip
sha512sum -c elasticsearch-6.7.0.zip.sha512
unzip -o -q elasticsearch-6.7.0.zip  # overwrite files

cp -f ~/tmp/elasticsearch/elasticsearch.yml ~/elasticsearch-6.7.0/config/elasticsearch.yml
cp -f ~/tmp/elasticsearch/jvm.options ~/elasticsearch-6.7.0/config/jvm.options

# make sure all resources used by ElasticSearch
sudo cp -f ~/tmp/etc/security/limits.conf /etc/security/limits.conf
sudo cp ~/tmp/etc/pam.d/sudo /etc/pam.d/sudo

sudo cp -f ~/tmp/etc/sysctl.conf /etc/sysctl.conf
sudo cp -f ~/tmp/hosts /etc/hosts

sudo sysctl --system

# adapt environment variable
source ~/.env

# clean the directory
sudo rm -rf ~/tmp/

# sudo to run elasticsearch in new session (pam.d/sudo, limits.conf)
sudo -E -u vagrant "if pkill -F pid 6969; then echo \"6969 process does not exist\" fi && ~/elasticsearch-6.7.0/bin/elasticsearch -d -p 6969"
