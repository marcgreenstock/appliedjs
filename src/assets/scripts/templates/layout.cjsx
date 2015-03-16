# @cjsx React.DOM

React  = require 'react'
Layout = React.createClass
  render: ->
    <nav class="navbar navbar-default navbar-fixed-top">
      <div class="container">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar_menu">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="navbar-brand" href="#">Applied JS Berlin</a>
        </div>
        <div class="collapse navbar-collapse" id="navbar_menu">
          <ul class="nav navbar-nav">
            <li>
              <a href="#/">Home</a>
            </li>
            <li>
              <a href="#/users">Users</a>
            </li>
          </ul>
        </div>
      </div>
    </nav>

module.exports = Layout
