_          = require 'underscore'
Backbone   = require 'backbone'
translate  = require './translate'
moment     = require 'moment'
accounting = require 'accounting'

_.extend Backbone.View::,
  renderer: (options={}) ->
    throw new Error 'template is undefined' unless @template
    @template _.extend {}, options,
      a      : accounting
      t      : translate
      moment : moment

class Backbone.ParentView extends Backbone.View
  remove: ->
    console.log "-- removing view #{@cid}"
    @removeChildren()
    Backbone.View::remove.apply(@)
    @

  addChild: (name, callback) ->
    @childViews ?= {}
    @removeChild(name)
    @childViews[name] = callback.apply(@)
    console.log "-- adding child view '#{name}:#{@childViews[name].cid}'"
    @

  removeChild: (name) ->
    return @ unless _.has(@childViews or {}, name)
    console.log "-- deligating removal of child view '#{name}:#{@childViews[name].cid}'"
    @childViews[name].remove()
    delete @childViews[name]
    @

  removeChildren: ->
    @removeChild name for name in _.keys(@childViews or {})
    @
