

json = null


getPage = (title) ->
  console.log title
  title = title.replace /_/g, ' '
  page = _.find json.page, (p) ->
    p.title == title


getPageText = (title) ->
  getPage(title)?.revision.text.$t


unsafe = (text) ->
  if text?
    new Handlebars.SafeString text


Meteor.startup ->
  page = location.hash.slice(1)
  if page == ''
    page = 'Main Page'
  Session.set 'currentTitle', page

  json = jsondump
  Session.set 'jsonChanged', Meteor.uuid()

  css = document.createElement "style"
  css.type = "text/css"
  css.innerHTML = getPageText('MediaWiki:Common.css')
  document.body.appendChild(css)

