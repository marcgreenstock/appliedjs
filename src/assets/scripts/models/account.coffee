Backbone = require 'backbone'

module.exports = class Account extends Backbone.Model
  require('./concerns/authenticatable')(@)

  url: "#{process.env.apiUrl}/account"

  defaults:
    signedIn: false

  initialize: ->
    @on 'change:id', ->
      @set signedIn: @has('id') and @has('email')
    @listenTo @session, 'change:authHeader', ->
      if @session.has('authHeader') then @fetch() else @set @defaults

module.exports.account = new Account
