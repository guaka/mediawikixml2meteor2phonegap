
ucfirst = (s) ->
  s.charAt(0).toUpperCase() + s.slice(1)


articleParse = (text) ->

  # simple attempt at lists
  text = text.replace /^\*/gm, '<li>'
  text = text.replace /^\#/gm, '<li>'

  # ditch images
  text = text.replace /\[\[(File|Image):(.+?)\|(.+?)\]\]/g, ''

  # don't match [[link|text]]
  text = text.replace /\[\[([^|]+?)\]\]/g, '<a href="#$1">$1</a>'

  # and now match [[link|text]]
  text = text.replace /\[\[(.+?)\|(.+?)\]\]/g, '<a href="#$1">$2</a>'

  # hyperlinks
  text = text.replace /\[(.+?) (.+?)\]/g, '<a href="$1">$2</a>'

  # bold
  text = text.replace /\'\'\'(.*?)\'\'\'/g, '<strong>$1</strong>'
  # and italic
  text = text.replace /\'\'(.*?)\'\'/g, '<em>$1</em>'

  # headings
  text = text.replace /\=\=\=\=(.*?)\=\=\=\=/g, '<h4>$1</h4>'
  text = text.replace /\=\=\=(.*?)\=\=\=/g, '<h3>$1</h3>'
  text = text.replace /\=\=(.*?)\=\=/g, '<h2>$1</h2>'

  # ditch some special stuff
  text = text.replace /__(NOTOC|NOEDITSECTION)__/g, ''

  # {{NUMBEROFARTICLES}}
  text = text.replace /\{\{NUMBEROFARTICLES\}\}/, (_.filter json.page, (p) -> p.ns == '0' and p.revision.text.length > 100).length
