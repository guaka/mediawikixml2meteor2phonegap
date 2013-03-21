#! /usr/bin/env coffee

parser = require "xml2json"
fs = require "fs"
_ = require "underscore"

wiki = process.argv.slice(2)[0]
wiki = "hitchwiki"  unless wiki?.length is 0

console.log "Processing", wiki

fs.readFile "dumps/" + wiki + ".xml", (err, data) ->
  xml = data

  console.log "xml size:", data.length

  json = parser.toJson(xml,
    sanitize: false
    trim: false
  )
  json.page = _.filter json.page, (p) -> p.ns == 0

  console.log "json size:", json.length

  js = "var jsondump = " + json

  fs.writeFile "dumps/" + wiki + ".js", js, (err) ->
    throw err  if err
    console.log "saved"