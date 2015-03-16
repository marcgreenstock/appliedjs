_         = require 'underscore'
Backbone  = require 'backbone'
{session} = require '../../models/session'

module.exports = (targetClass) ->
  _.extend targetClass::,
    session : session
    sync    : (method, model, options={}) ->
      opts = _.clone(options)
      opts.headers ?= {}
      opts.headers['Authorization'] = session.get('authHeader') if session.has('authHeader')
      Backbone.sync.call(@, method, model, opts)
