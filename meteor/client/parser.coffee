

@articleParse = (text, config, depth = 0) ->

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
      articleParse t, config, depth+1

  # text = text.replace /<noinclude>.*?<\/noinclude>/gmi, ''  # doesn't work, hacky fix in css

  interwiki = text.match /\[\[(..)\:([^|]*?)\]\]/g
  text = text.replace /\[\[(..)\:([^|]*?)\]\]/g, ''

  # Categories
  categories = text.match /\[\[Category\:([^|]*?)\]\]/g
  text = text.replace /\[\[Category\:([^|]*?)\]\]/g, ''

  regexen = [
    # simple attempt at lists
    [/^\*(.*)/gm, '<ul><li>$1</li></ul>'],
    [/(<\/ul>\s*<ul>)/g, ''],

    [/^\#(.*)/gm, '<ol><li>$1</li></ol>'],
    [/(<\/ol>\s*<ol>)/g, ''],

    # Ditch images
    # namespace(6)
    # Do we want to include external images? Both regexes returns the following parameters: Type=$1; Filename=$2; Params=$3; Caption=$5'
    # With links inside the caption:
    [/\[\[(File|Image):([^\|\]\[]+)((\|[^\|\]]+)*\|)(([^\[\]|]*?\[\[.+?\]\][^\]\[|]*?)+)\]\]/g, '<a target="_blank" href="' + config.url + '/File:$2">$5</a>'],

    # Plaintext or empty caption:
    [/\[\[(File|Image):([^\|\]\[]+)((\|[^\|\]\[]+)*)([^\[\]|]*?)\]\]/g, ''],


    # Match [[link]]
    [/\[\[([^|]+?)\]\]/g, '<a href="#$1">$1</a>'],

    # and now match [[link|text]]
    [/\[\[(.+?)\|(.+?)\]\]/g, '<a href="#$1">$2</a>'],

    # Hyperlinks
    [/\[([^ \]]+?)\]/g, '<a target="_blank" class="external" href="$1">$1</a>'],
    [/\[(.+?) (.+?)\]/g, '<a target="_blank" class="external" href="$1">$2</a>'],

    # Tables
    [/\{\|([^|]*?)\|([.\s\S]+?)\|\}/gm, '<table $1><tr><td>$2</td></tr></table>'],
    [/\|\-/g, '</tr><tr>'],
    [/\|/g, '</td><td>'],

    # strong + em
    [/\'\'\'(.*?)\'\'\'/g, '<strong>$1</strong>'],
    [/\'\'(.*?)\'\'/g, '<em>$1</em>'],

    [/\n\n/gm, '<br />'],

    # headings
    [/\=\=\=\=(.*?)\=\=\=\=/g, '<h4>$1</h4>'],
    [/\=\=\=(.*?)\=\=\=/g, '<h3>$1</h3>'],
    [/\=\=(.*?)\=\=/g, '<h2>$1</h2>'],
    [/^\=(.*?)\=$/g, '<h1>$1</h1>'],

    [/__(NOTOC|TOC|NOEDITSECTION)__/g, ''],
  ]
  for replacement in regexen
    text = text.replace replacement[0], replacement[1]


  if categories? and categories.length > 0 and depth is 0
    text = text + '<div class="categories"><span>Categories</span>'
    for cat in categories
      text = text + cat.replace /\[\[Category\:([^|]*?)\]\]/g, '<a href="#Category:$1">$1</a>'
    text = text + "</div>"

  if interwiki? and interwiki.length > 0 and depth is 0
    text = text + '<div class="interwiki"><span>Interwiki</span>'
    for iw in interwiki
      text = text + iw.replace /\[\[(..)\:([^|]*?)\]\]/g, '<a href="#$1:$2"><span>$1</span>$2</a>'
    text = text + "</div>"

  text
