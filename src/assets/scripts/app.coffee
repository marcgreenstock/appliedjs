$ = require 'jquery'
require 'jquery.cookie'
require 'bootstrap.transition'
require 'bootstrap.dropdown'
require 'bootstrap.collapse'
require 'bootstrap.carousel'
require 'bootstrap.modal'
require './lib/backbone.ext'
Backbone = require 'backbone'
Backbone.$ = $
# {account} = require './models/account'
# {session} = require './models/session'
MainView  = require './views/main_view'
# Router    = require './config/router'

new MainView
  el: 'body'

# new Router new MainView
#   el: 'body'
#
# session.fetch()
# Backbone.history.start()
#
# window.session = session
# window.account = account
