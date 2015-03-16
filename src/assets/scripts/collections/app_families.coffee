Backbone = require 'backbone'

module.exports = class AppFamilies extends Backbone.Collection
  require('../models/concerns/authenticatable')(@)

  model: require '../models/app_family'

  url: "#{process.env.apiUrl}/app_families"

module.exports.appFamilies = new AppFamilies
