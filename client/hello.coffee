
Template.page.siteName = ->
  Session.get 'jsonChanged'
  json?.siteinfo.sitename


json = null

articleParse = (text) ->
  text = text.replace /\[\[(.+?)\]\]/g, '<a href="#$1">$1</a>'
  text = text.replace /\=\=\=\=(.*?)\=\=\=\=/g, '<h4>$1</h4>'
  text = text.replace /\=\=\=(.*?)\=\=\=/g, '<h3>$1</h3>'
  text = text.replace /\=\=(.*?)\=\=/g, '<h2>$1</h2>'

Template.page.content = ->
  if json?
    page = _.find json.page, (p) -> p.title == Session.get 'currentTitle'
    text = page?.revision.text
    if text?
      unsafe articleParse text

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
    Session.set 'currentTitle', title



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

