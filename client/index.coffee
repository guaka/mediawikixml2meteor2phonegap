
Template.page.siteName = ->
  Session.get 'jsonChanged'  # force reactivity
  json?.siteinfo.sitename


json = null

articleParse = (text) ->
  text = text.replace /\[\[(File|Image):(.+?)\|(.+?)\]\]/g, ''
  text = text.replace /\[\[(.+?)\|(.+?)\]\]/g, '<a href="#$1">$2</a>'
  text = text.replace /\[\[(.+?)\]\]/g, '<a href="#$1">$1</a>'
  text = text.replace /\=\=\=\=(.*?)\=\=\=\=/g, '<h4>$1</h4>'
  text = text.replace /\=\=\=(.*?)\=\=\=/g, '<h3>$1</h3>'
  text = text.replace /\=\=(.*?)\=\=/g, '<h2>$1</h2>'

ucfirst = (s) ->
  s.charAt(0).toUpperCase() + s.slice(1)

getPage = (title) ->
  title = title.replace /_/g, ' '
  page = _.find json.page, (p) ->
    p.title == title




Template.page.content = ->
  if json?
    title = Session.get 'currentTitle'
    console.log title
    page = getPage title
    revision = page?.revision.text
    console.log page
    if revision?
      value = unsafe articleParse revision
    else
      value = 'no revision?'
  if value?
    value
  else
    'no page found'

unsafe = (text) ->
  if text?
    new Handlebars.SafeString text

Template.page.title = ->
  Session.get('currentTitle')?.replace(/[%20|_]/g, ' ')


Template.page.events
  'click a': (e) ->
    if e.srcElement?
      href = e.srcElement.href
    else
      href = e.currentTarget.href
    title = href.split('#')[1]
    Session.set 'currentTitle', ucfirst title



Meteor.startup ->
  page = location.hash.slice(1)
  if page == ''
    page = 'Main Page'
  Session.set 'currentTitle', page

  Meteor.http.get '/test.xml', {}, (error, data) ->
    # content = '<' + data.content.split('<')[1]
    xml = data.content
    json = $.xml2json xml
    Session.set 'jsonChanged', Meteor.uuid()

