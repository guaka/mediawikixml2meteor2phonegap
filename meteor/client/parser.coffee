
articleParse = (text) ->

  # First parse "constants"
  text = text.replace /\{\{NUMBEROFARTICLES\}\}/, '~' + (_.filter json.page, (p) -> p.ns == 0 and p.revision.text.bytes > 100).length
  text = text.replace /\{\{NUMBEROFUSERS\}\}/, '~' + (_.filter json.page, (p) -> p.ns == 10).length

  # Then templates
  text = text.replace /\{\{(.+?)\}\}/g, (all, arg1) ->
    t = getPageText "Template:" + ucfirst arg1
    if not t?
      ''  # Templates can be empty. e.g. IsIn on Hitchwiki
    else
      # DANGER: infinite template loop
      articleParse t

  # text = text.replace /<noinclude>.*?<\/noinclude>/gmi, ''  # doesn't work, hacky fix in css

  # simple attempt at lists
  text = text.replace /^\*(.*)/gm, '<ul><li>$1</li></ul>'
  text = text.replace /(<\/ul>\s*<ul>)/g, ''

  text = text.replace /^\#/gm, '<li>'

  # Ditch images
  # TODO: handle [[links]] inside image descriptions, such as e.g. hitch:Paris#Sleeping in Paris
  text = text.replace /\[\[(File|Image):(.+?)\|(.+?)\]\]/gm, ''

  # Don't match [[link|text]]
  text = text.replace /\[\[([^|]+?)\]\]/g, '<a href="#$1">$1</a>'

  # and now match [[link|text]]
  text = text.replace /\[\[(.+?)\|(.+?)\]\]/g, '<a href="#$1">$2</a>'

  # Hyperlinks
  text = text.replace /\[(.+?) (.+?)\]/g, '<a class="external" href="$1">$2</a>'

  # bold
  text = text.replace /\'\'\'(.*?)\'\'\'/g, '<strong>$1</strong>'
  # and italic
  text = text.replace /\'\'(.*?)\'\'/g, '<em>$1</em>'

  # headings
  text = text.replace /\=\=\=\=(.*?)\=\=\=\=/g, '<h4>$1</h4>'
  text = text.replace /\=\=\=(.*?)\=\=\=/g, '<h3>$1</h3>'
  text = text.replace /\=\=(.*?)\=\=/g, '<h2>$1</h2>'
  #  text = text.replace /\=(.*?)\=/g, '<h1>$1</h1>'  # Good in theory but this breaks stuff on Hitchwiki Main Page!

  # ditch some special stuff
  text = text.replace /__(NOTOC|TOC|NOEDITSECTION)__/g, ''

