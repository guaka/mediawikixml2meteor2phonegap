


articleParse = (text, depth = 0) ->

  # avoid infinite loops when parsing sub-templates
  if depth >= 5
    return text

  # First parse "constants"
  text = text.replace /\{\{NUMBEROFARTICLES\}\}/, '~' + (_.filter json.page, (p) -> p.ns == 0 and p.revision.text.bytes > 100).length
  text = text.replace /\{\{NUMBEROFUSERS\}\}/, '~' + (_.filter json.page, (p) -> p.ns == 10).length

  # Then templates
  text = text.replace /\{\{(.+?)\}\}/g, (all, arg1) ->
    t = getPageText "Template:" + ucfirst arg1
    if not t?
      ''  # Templates can be empty. e.g. IsIn on Hitchwiki
    else
      articleParse t, depth+1

  # text = text.replace /<noinclude>.*?<\/noinclude>/gmi, ''  # doesn't work, hacky fix in css

  # simple attempt at lists
  text = text.replace /^\*(.*)/gm, '<ul><li>$1</li></ul>'
  text = text.replace /(<\/ul>\s*<ul>)/g, ''

  text = text.replace /^\#/gm, '<li>'

  # Ditch images
  # namespace(6)
  # Do we want to include external images? Both regexes returns the following parameters: Type=$1; Filename=$2; Params=$3; Caption=$5'
  # With links inside the caption:
  text = text.replace /\[\[(File|Image):([^\|\]\[]+)((\|[^\|\]]+)*\|)(([^\[\]|]*?\[\[.+?\]\][^\]\[|]*?)+)\]\]/g, ''
  # Plaintext or empty caption:
  text = text.replace /\[\[(File|Image):([^\|\]\[]+)((\|[^\|\]\[]+)*)([^\[\]|]*?)\]\]/g, ''

  # Trying to move categories to the end
  #text = text.replace /\[\[Category\:([^|]*?)\]\](.+*)/gm, '$2[[Category:$1]]'

  # Language-Interwiki
  text = text.replace /\[\[(..)\:(.*?)\]\]/g, '<div class="interwiki"><span>International</span><a href="/$1/$2"><span>$1</span>$2</a></div>iwl'
  text = text.replace /<\/div>iwl\s*<div class="interwiki"><span>International<\/span>/g, ''
  text = text.replace /<\/div>iwl/, '</div>'

  # Categories 
  text = text.replace /\[\[Category\:([^|]*?)\]\]/g, '<div class="categories"><span>Categories</span><a href="#Category:$1">$1</a></div>cat'
  text = text.replace /<\/div>cat[\s\t\r\n]*<div class="categories"><span>Categories<\/span>/g, ''
  text = text.replace /<\/div>cat/, '</div>'

  # Match [[link]]
  text = text.replace /\[\[([^|]+?)\]\]/g, '<a href="#$1">$1</a>'

  # and now match [[link|text]]
  text = text.replace /\[\[(.+?)\|(.+?)\]\]/g, '<a href="#$1">$2</a>'

  # Hyperlinks
  text = text.replace /\[([^ \]]+?)\]/g, '<a class="external" href="$1">$1</a>'
  text = text.replace /\[(.+?) (.+?)\]/g, '<a class="external" href="$1">$2</a>'

  # Tables
  text = text.replace /\{\|([^|]*?)\|([.\s\S]+?)\|\}/gm, '<table $1><tr><td>$2</td></tr></table>'
  text = text.replace /\|\-/g, '</tr><tr>'
  text = text.replace /\|/g, '</td><td>'

  # bold
  text = text.replace /\'\'\'(.*?)\'\'\'/g, '<strong>$1</strong>'
  # and italic
  text = text.replace /\'\'(.*?)\'\'/g, '<em>$1</em>'

  text = text.replace /\n\n/gm, '<br />'

  # headings
  text = text.replace /\=\=\=\=(.*?)\=\=\=\=/g, '<h4>$1</h4>'
  text = text.replace /\=\=\=(.*?)\=\=\=/g, '<h3>$1</h3>'
  text = text.replace /\=\=(.*?)\=\=/g, '<h2>$1</h2>'
  text = text.replace /^\=(.*?)\=$/g, '<h1>$1</h1>'  # fixed! 

  # ditch some special stuff
  text = text.replace /__(NOTOC|TOC|NOEDITSECTION)__/g, ''

