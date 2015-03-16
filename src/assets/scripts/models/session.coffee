Backbone = require 'backbone'

module.exports = class Session extends Backbone.Model
  cookieName: 'sashimi_session'

  defaults:
    id         : null
    token      : null
    authHeader : null

  initialize: ->
    @on 'change:id', ->
      @set
        authHeader: @authHeader()

  sync: (method, model, options={}) ->
    try
      switch method
        when 'create', 'update', 'patch'
          Backbone.$.cookie @cookieName, btoa JSON.stringify
            id    : model.id
            token : model.get('token')
          options.success?()
        when 'read'
          if (cookie = Backbone.$.cookie @cookieName)
            options.success? JSON.parse atob cookie
          else
            options.success? {}
        when 'delete'
          Backbone.$.removeCookie @cookieName
          options.success?()
    catch e
      options.error? e

  signIn: (authHeader) ->
    Backbone.$.ajax
      url     : "#{process.env.apiUrl}/oauth/authorizations"
      type    : 'POST'
      headers :
        'Authorization' : authHeader
    .done (result) =>
      @set
        id    : result.id
        token : result.token
      @save()
    .fail (xhr) =>
      @handleSignInError(xhr)

  signInUser: (options={}) ->
    @signIn "Basic #{btoa("#{options.email}:#{options.password}")}"

  handleSignInError: (xhr) ->
    # alerts.reset [
    #   title   : xhr.statusText
    #   message : xhr.responseJSON?.error or 'An unknown error occured'
    #   type    : 'danger'
    # ]

  signOut: (options={}) ->
    Backbone.$.ajax
      url     : "#{process.env.apiUrl}/oauth/authorizations/#{@id}"
      type    : 'DELETE'
      headers :
        'Authorization': @get('authHeader')
    @destroy()
    @set @defaults

  authHeader: ->
    if @has('id') and @has('token')
      "Bearer #{btoa(@id + ':' + @get('token'))}"
    else
      null

module.exports.session = new Session
