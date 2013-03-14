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

WIKI=${1-hitchwiki}

cd $(dirname $0)

mkdir -p dumps

if [ ! -f dumps/hitchwiki.xml ]; then
    echo 'Downloading hitchwiki dump'
    cd dumps
    wget http://hitchwiki.org/dumps/current-en.xml
    mv current-en.xml hitchwiki.xml
    cd ..
fi

if [ ! -f dumps/$WIKI.json ]; then
    ./xml2json.js $WIKI
fi

cp dumps/$WIKI.js meteor/client/dump.js

cd meteor
meteor deploy $WIKI.meteor.com

echo Waiting a bit for meteor servers to settle down.
sleep 5

#
# And now do something phonegappy.
# This will only work if oyu have meteor-phonegap installed in this specific directory.
# 
cd ~/code/meteor-phonegap
./meteor2cordova.sh $WIKI.meteor.com
