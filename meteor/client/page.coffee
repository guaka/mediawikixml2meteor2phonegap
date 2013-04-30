

namespace = (ns) ->
  for n in json.siteinfo.namespaces.namespace
    if n.key is ns
      return n.$t


getPage = (title) ->
  title = title.replace /_/g, ' '
  page = _.find json.page, (p) ->
    p.title == title


@getPageText = (title) ->
  getPage(title)?.revision.text.$t


pagesInCat = (cat) ->
  pages = _.filter json.page, (p) -> p.revision.text.$t.match (namespace(14) + ':' + cat)
  titles = _.pluck pages, 'title'
  titles.sort()
  links = _.map titles, (t) -> '[[' + t + ']]'
  "*" + links.join("\n*")


# Can probably be derived from dump.js
# Global because of parser tests
@config =
  url: 'http://hitchwiki.org/en/'
  language: 'en'

Template.page.siteName = ->
  Session.get 'jsonChanged'  # force reactivity
  Session.set 'sitename', json?.siteinfo.sitename
  Session.get 'sitename'

Template.page.mainpage = ->
  Session.get 'mainpage'



Template.page.content = ->
  if json?
    title = Session.get 'currentTitle'
    value = getPageText title
  if value?
    redirect = value.match /\#redirect \[\[(.+?)\]\]/i
    if redirect
      Session.set 'currentTitle', redirect[1]
    else
      # TODO: re_cat = new RegExp namespace(14) + ':(.+)'
      if m = title.match /Category:(.+)/
        unsafe articleParse (pagesInCat(m[1]) + "\n\n" + value), config
      else
        unsafe articleParse value, config
  else
    'no page found, or still processing...'

Template.page.title = ->
  title = Session.get('currentTitle')?.replace(/[%20|_]/g, ' ')
  document.title = title + ' | ' + Session.get('sitename') + ' Meteorized'
  title


Template.page.events

  'click a': (e) ->
    href = if e.srcElement? then e.srcElement.href else e.currentTarget.href
    title = href.split('#')[1]
    Session.set 'currentTitle', ucfirst title
    window.scrollTo 0, 0

  'keydown #search': (evt) ->
    if evt.keyCode is 13
      search $('#search').val()
      $('#search').val ''


