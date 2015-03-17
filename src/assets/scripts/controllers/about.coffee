BaseController = require './base'

class Show extends BaseController
  template: require '../templates/about/show'

  load: ->
    @render()

  render: ->
    @$el.append @renderer()

module.exports =
  Show: Show
