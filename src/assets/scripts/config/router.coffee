Backbone    = require 'backbone'

parseQueryString = (string='') ->
  params = {}
  for part in string.split('&')
    [key, val] = part.split('=')
    params[key] = val
  params

module.exports = class Router extends Backbone.Router
  routes:
    ''                      : 'accountsShow'
    'sign_in'               : 'sessionsNew'
    'sign_up'               : 'accountsNew'
    'account/settings'      : 'accountsSettings'
    'account/security'      : 'accountsSecurity'
    'app_families'          : 'appFamiliesList'
    'app_families/:id'      : 'appFamiliesShow'
    # 'app_families/:id/edit' : 'appFamiliesEdit'
    'app_families/new'      : 'appFamiliesNew'

  initialize: (@mainView) ->

  execute: (callback, args) ->
    fragment = Backbone.history.fragment or 'home'
    args.push(parseQueryString(args.pop()))
    view = callback.apply(@, args)
    view.authenticate
      authorized: =>
        @mainView.addChild 'page', ->
          view.load()
          @$('#page').prepend view.$el
          view
      unauthorized: ->
        Backbone.history.navigate "sign_in?callback=#{fragment}",
          trigger: true
  #
  # sessionsNew: ->
  #   new Controllers.Sessions.New
  #
  # accountsNew: ->
  #   new Controllers.Accounts.New
  #
  # accountsShow: ->
  #   new Controllers.Accounts.Show
  #
  # accountsSettings: ->
  #   new Controllers.Accounts.Settings
  #
  # accountsSecurity: ->
  #   new Controllers.Accounts.Security
  #
  # appFamiliesList: ->
  #   new Controllers.AppFamilies.List
  #
  # appFamiliesNew: ->
  #   new Controllers.AppFamilies.New
  #
  # appFamiliesShow: (id) ->
  #   new Controllers.AppFamilies.Show(id: id)
  #
  # appFamiliesEdit: (id) ->
  #   new Controllers.AppFamilies.Edit(id: id)
