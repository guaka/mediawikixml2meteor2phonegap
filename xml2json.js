#! /usr/bin/env node

var parser = require('xml2json');
var fs = require('fs');

var wiki = process.argv.slice(2)[0];

if (!wiki || wiki.length == 0) {
  wiki = 'hitchwiki';
}

console.log('Processing', wiki);

fs.readFile('dumps/' + wiki + '.xml', function(err, data) {
  var xml = data;
  console.log ('xml size:', data.length);

  var json = parser.toJson(xml, { sanitize: false, trim: false });
  console.log('json size:', json.length);

  var js = "var jsondump = " + json;

  fs.writeFile('dumps/' + wiki + '.js', js, function(err) {
    if (err) {
      throw err;
    }
    console.log('saved');
  });
});
              
  
