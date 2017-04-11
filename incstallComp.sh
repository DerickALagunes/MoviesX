#!/bin/bash 

echo 'trying to install components'

######################################################################################33

echo 'mongo db'

# Script by leommoore https://gist.github.com/leommoore/10660095
echo '-----------------------------------------------------------------'
echo '-                    Mongo - Ubuntu 14.04                       -'
echo '-----------------------------------------------------------------'

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10

echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list

sudo apt-get update

#This is to install a specific version
#sudo apt-get install mongodb-org=2.6.1 mongodb-org-server=2.6.1 mongodb-org-shell=2.6.1 mongodb-org-mongos=2.6.1 mongodb-org-tools=2.6.1

#Pin the version to a specific version to top it updating automatically
#echo "mongodb-org hold" | sudo dpkg --set-selections
#echo "mongodb-org-server hold" | sudo dpkg --set-selections
#echo "mongodb-org-shell hold" | sudo dpkg --set-selections
#echo "mongodb-org-mongos hold" | sudo dpkg --set-selections
#echo "mongodb-org-tools hold" | sudo dpkg --set-selections

#This is to install the latest stable version
sudo apt-get install -y mongodb-org

#If you want to install a specific version
#apt-get install mongodb-org=2.6.0 mongodb-org-server=2.6.0 mongodb-org-shell=2.6.0 mongodb-org-mongos=2.6.0 mongodb-org-tools=2.6.0

#################################################################################################

echo 'ruby'
sudo apt-get install ruby-full
sudo gem install mongo
sudo gem install catpix































