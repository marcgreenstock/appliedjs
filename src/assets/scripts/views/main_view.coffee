Backbone = require 'backbone'

module.exports = class MainView extends Backbone.ParentView
  template: require '../templates/layout'

  initialize: ->
    @render()

  render: ->
    @$el.html @renderer
      lastModified: process.env.lastModified
