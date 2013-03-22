
search = (s) ->
  found = _.find json.page, (p) -> p.title is s
  # First try to find exact match
  if found
    Session.set 'currentTitle', s
  else
    # First then case insensitive
    found = _.find json.page, (p) -> p.title.toLowerCase() is s.toLowerCase()
    console.log found
    if found
      Session.set 'currentTitle', found.title
    else
      # Finally resort to showing potential matches
      Session.set 'currentTitle', 'search:' + s


# This one doesn't work yet...
matches = (s) ->
  matches = _.map json.page, (p) ->
    re = new RegExp s, 'i'
    (p.title + '').match re
  _.filter matches, (m) -> m



