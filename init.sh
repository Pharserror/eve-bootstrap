#!/bin/bash

# create directory for project and own it
sudo mkdir /var/www
sudo mkdir /var/www/$BITBUCKET_PROJECT
sudo chown worker:worker -R /var/www/
sudo chown worker:worker -R /var/www/$BITBUCKET_PROJECT

# add ssh key to bitbucket project
mkdir /home/worker/.ssh
cd /home/worker/.ssh
ssh-keygen -t rsa -f worker_rsa -N '' && cat ./worker_rsa.pub | while read key; do curl --user "$BITBUCKET_USER:$BITBUCKET_PASS" --data-urlencode "key=$key" -X POST https://bitbucket.org/api/1.0/users/$BITBUCKET_USER/ssh-keys ; done
touch known_hosts
ssh-keyscan bitbucket.org >> known_hosts

# clone our eve project
cd /var/www
git clone https://$BITBUCKET_USER:$BITBUCKET_PASS@bitbucket.org/$BITBUCKET_USER/$BITBUCKET_PROJECT.git
cd /var/www/$BITBUCKET_PROJECT

# create the db
mongo admin --eval "db.createCollection('evedemo')"

# configure the db
mongo /mongo-setup.js

python run.py
