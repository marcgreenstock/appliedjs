Backbone    = require 'backbone'
Controllers = require '../controllers'

module.exports = class Router extends Backbone.Router
  routes:
    ''        : 'home'
    'about'   : 'about'
    'contact' : 'contact'

  initialize: (@mainView) ->

  execute: (callback, args) ->
    view = callback.apply(@, args)
    @mainView.addChild 'page', ->
      @$('#page').prepend view.$el
      view

  home: ->
    new Controllers.Home.Show

  about: ->
    new Controllers.About.Show

  contact: ->
    new Controllers.Contact.Show
