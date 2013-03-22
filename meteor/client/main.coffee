

json = null


addCssFromWiki = (page) ->
  css = document.createElement "style"
  css.type = "text/css"
  css.innerHTML = getPageText page
  document.body.appendChild css


Meteor.startup ->

  if jsondump.hasOwnProperty 'mediawiki'
    json = jsondump.mediawiki
  else
    json = jsondump
  Session.set 'jsonChanged', Meteor.uuid()

  # TODO: ifExists
  addCssFromWiki 'MediaWiki:Vector.css'
  addCssFromWiki 'MediaWiki:Monobook.css'
  addCssFromWiki 'MediaWiki:Common.css'

  $('#search').focus()

  Session.set 'mainpage', json.siteinfo.base.split('/').slice(-1)[0]

  page = location.hash.slice(1)
  if page == ''
    page = Session.get 'mainpage'
  Session.set 'currentTitle', page
