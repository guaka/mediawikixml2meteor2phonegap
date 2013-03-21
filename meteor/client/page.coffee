
Template.page.siteName = ->
  Session.get 'jsonChanged'  # force reactivity
  json?.siteinfo.sitename



Template.page.content = ->
  if json?
    title = Session.get 'currentTitle'
    value = getPageText(title)
  if value?
    redirect = value.match /\#redirect \[\[(.+?)\]\]/i
    if redirect
      Session.set 'currentTitle', redirect[1]
    else
      unsafe articleParse value
  else
    'no page found, or still processing...'

Template.page.title = ->
  Session.get('currentTitle')?.replace(/[%20|_]/g, ' ')


Template.page.events

  'click a': (e) ->
    href = if e.srcElement? then e.srcElement.href else e.currentTarget.href
    title = href.split('#')[1]
    Session.set 'currentTitle', ucfirst title
    window.scrollTo 0, 0

  'keydown #jumpTo': (evt) ->
    if evt.keyCode is 13
      Session.set 'currentTitle', ucfirst $('#jumpTo').val()
      $('#jumpTo').val ''