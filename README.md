**mediawikixml2meteor2phonegap** turns a MediaWiki XML dump into a
Meteor app and consequently into a Phonegap app.  Requires
https://github.com/guaka/meteor-phonegap


This is a work in progress with running code.

It's mainly built for information that you want to have available when not online.
Or when roaming.  Sites like Hitchwiki, Couchwiki and Wikivoyage.




How this works 
==============

`build.sh` is the main script. It will parse a MediaWiki XML dump into
json, only keeping the most important namespaces.  The json ends up in
`dump.js` in meteor/client. It is thus parsed directly on the client.

This works really well with wikis the size of Hitchwiki (around 3000
articles).  It will fail miserably with the English Wikipedia. But the
English Wikivoyage is a good candidate.


Examples
--------

* http://hitchwiki.meteor.com/ and https://play.google.com/store/apps/details?id=io.cordova.cordovahitchwikimeteorcom



Currently GPLv2+ for compatibility with MediaWiki.
