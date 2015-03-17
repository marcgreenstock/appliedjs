Backbone = require 'backbone'

module.exports = class BaseController extends Backbone.ParentView
  initialize: ->
    @load()
