BaseController = require './base'

class Show extends BaseController
  template: require '../templates/home/show'

  load: ->
    @render()

  render: ->
    @$el.append @renderer()

module.exports =
  Show: Show
