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

mkdir -p $WIKI
cd $WIKI

if [ ! -f dump.xml ]; then
    echo 'Downloading hitchwiki dump'
    wget http://hitchwiki.org/dumps/current-en.xml
    mv current-en.xml dump.xml
fi

if [ ! -f dump.js ]; then
    ../xml2json.coffee
fi

cp dump.js ../meteor/client/dump.js

cd ../meteor
meteor deploy $WIKI.meteor.com

cd ../$WIKI
echo Waiting a bit for meteor servers to settle down.
sleep 5

#
# And now do something phonegappy.
# Add some links to meteor-phonegap scripts to make this work
# 
# if [ -d ~/code/meteor-phonegap ]; then
meteor2cordova.sh $WIKI.meteor.com
signapk.sh
#fi
