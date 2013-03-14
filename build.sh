#! /usr/bin/env bash
#
#  Hitchwiki dump => Meteor app => Android app
#
#
# todo: 
# * other wikis
# * rewrite in coffeescript
# 
#

cd $(dirname $0)

mkdir -p dumps

if [ ! -f dumps/hitchwiki.xml ]; then
    echo 'Downloading hitchwiki dump'
    cd dumps
    wget http://hitchwiki.org/dumps/current-en.xml
    mv current-en.xml hitchwiki.xml
    cd ..
fi

cp dumps/hitchwiki.xml meteor/public/dump.xml

cd meteor
meteor deploy hitchwiki.meteor.com

echo Waiting a bit for meteor servers to settle down.
sleep 5

#
# And now do something phonegappy.
# This will only work if oyu have meteor-phonegap installed in this specific directory.
# 
cd ~/code/meteor-phonegap
./meteor2cordova.sh hitchwiki.meteor.com
