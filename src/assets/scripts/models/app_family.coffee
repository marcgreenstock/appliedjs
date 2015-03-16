Backbone = require 'backbone'

module.exports = class AppFamily extends Backbone.Model
  require('./concerns/authenticatable')(@)

  urlRoot: "#{process.env.apiUrl}/app_families"
