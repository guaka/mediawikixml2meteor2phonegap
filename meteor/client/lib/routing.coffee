#
# This is our router, we might want to replace it with meteor-router
# at some point.
#
# All "pages" are already in the html.
# The router will
# - change the address bar url (without a page refresh, thanks to HTML5)
# - set the sidebar-page session var, reactivity will do the rest
#



@Router = new class extends Backbone.Router
  routes:
    "test": "test"
    ":page": "page"
    "": "home"

  test: ->
    jasmineTest()

  page: (page) ->
    # do something


Meteor.startup ->
  Backbone.history.start pushState: true
