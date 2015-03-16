React    = require 'react'
Layout   = React.createFactory require '../templates/layout.cjsx'
Backbone = require 'backbone'

module.exports = class MainView extends Backbone.ParentView
  initialize: ->
    @render()

  render: ->
    React.render Layout(), @el
