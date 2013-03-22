
ucfirst = (s) ->
  s.charAt(0).toUpperCase() + s.slice(1)



# Handlebar helper
unsafe = (text) ->
  if text?
    new Handlebars.SafeString text

