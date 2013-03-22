#! /usr/bin/env coffee

parser = require "xml2json"
fs = require "fs"
_ = require "underscore"

wiki = process.argv.slice(2)[0]
wiki = "hitchwiki"  unless wiki


console.log "Processing", wiki

fs.readFile "dumps/" + wiki + ".xml", (err, data) ->
  xml = data

  console.log "xml size:", data.length

  # E.g. English Wikivoyage
  if data.length < 100000000
    json_out = parser.toJson xml,
      sanitize: false
      trim: false

  # We can make it smaller
  else
    json = parser.toJson xml,
      sanitize: false
      trim: false

    js = JSON.parse json
    jsOut = {}
    jsOut.siteinfo = js.mediawiki.siteinfo

    console.log 'all pages: ',  js.mediawiki.page.length

    jsOut.page = _.filter js.mediawiki.page, (p) ->
      # Main, MediaWiki, Template or Category
      _.contains [0, 8, 10, 14], p.ns

    console.log 'ns 0, 10, 14: ',  jsOut.page.length

    json_out = JSON.stringify jsOut

    console.log "json size:", json_out.length

  dir = 'dumps/'
  fs.writeFile dir + wiki + ".js", "var jsondump = " + json_out, (err) ->
    throw err  if err
    console.log "saved in ", dir