_           = require 'underscore'
fs          = require 'fs'
gulp        = require 'gulp'
gutil       = require 'gulp-util'
gulpif      = require 'gulp-if'
less        = require 'gulp-less'
revall      = require 'gulp-rev-all'
uglify      = require 'gulp-uglify'
minifyCSS   = require 'gulp-minify-css'
minifyHTML  = require 'gulp-minify-html'
streamify   = require 'gulp-streamify'
webserver   = require 'gulp-webserver'
watch       = require 'gulp-watch'
notify      = require 'gulp-notify'
stripDebug  = require 'gulp-strip-debug'
browserify  = require 'browserify'
source      = require 'vinyl-source-stream'
runSequence = require 'run-sequence'
del         = require 'del'
coffeeify   = require 'coffeeify'
reactify    = require 'coffee-reactify'
envify      = require 'envify/custom'
awspublish  = require 'gulp-awspublish'
cloudfront  = require 'gulp-cloudfront'
inquirer    = require 'inquirer'

options = {}

gulp.task 'default', (cb) ->
  runSequence ['build'], ['watch'], ['serve'], cb

gulp.task 'build', (cb) ->
  runSequence ['clean'], ['options'], ['scripts', 'styles', 'fonts', 'copy_html'], cb

gulp.task 'publish', ['build'], ->
  aws       = require('./credentials')[options.environment].aws
  headers   = 'Cache-Control': 'max-age=315360000, no-transform, public'
  publisher = awspublish.create aws

  gulp.src './_build/**'
    .pipe revall()
    .pipe awspublish.gzip()
    .pipe publisher.publish(headers)
    .pipe publisher.cache()
    .pipe awspublish.reporter()
    .pipe cloudfront(aws)

gulp.task 'options', (cb) ->
  if gutil.env.env
    options.environment = gutil.env.env
    cb()
  else
    envChoices = []
    if 'publish' not in gutil.env._
      envChoices.push
        name  : 'Development'
        value : 'development'
    envChoices.push
      name  : 'Production'
      value : 'production'
    inquirer.prompt [
      type    : 'list'
      name    : 'environment'
      message : 'Select environment?'
      choices : envChoices
    ], (result) ->
      options = result
      cb()

gulp.task 'watch', (cb) ->
  watch './src/assets/scripts/**/*', -> gulp.start 'scripts'
  watch './src/assets/styles/**/*', -> gulp.start 'styles'
  cb()

gulp.task 'serve', ->
  gulp.src './_build'
    .pipe webserver
      livereload : false
      open       : false

gulp.task 'clean', (cb) ->
  del ['./_build/**/*'], cb

gulp.task 'scripts', ->
  debug = options.environment is 'development'
  switch options.environment
    when 'production'
      apiUrl = 'https://api.sashimi.io'
    when 'sandbox'
      apiUrl = 'https://api.sandbox.sashimi.io'
    when 'staging'
      apiUrl = 'https://api.staging.sashimi.io'
    when 'development'
      apiUrl = 'http://localhost:5000/api'
  gutil.log 'scripts:', gutil.colors.magenta('Debug:'), gutil.colors.cyan(if debug then 'on' else 'off')
  gutil.log 'scripts:', gutil.colors.magenta('API URL:'), gutil.colors.cyan(apiUrl)
  browserify
      entries    : './src/assets/scripts/app.coffee'
      extensions : ['.cjsx', '.coffee', '.litcoffee']
      debug      : debug
    .transform reactify,
      coffeeout: true
    .transform coffeeify
    .transform envify
      apiUrl       : apiUrl
      lastModified : (new Date).toUTCString()
    .bundle()
    .on 'error', notify.onError (err) ->
      err.message
    .pipe source 'app.js'
    .pipe if debug then gutil.noop() else streamify stripDebug()
    .pipe if debug then gutil.noop() else streamify uglify()
    .pipe gulp.dest('./_build/assets')

gulp.task 'styles', ->
  debug = options.environment is 'development'
  gulp.src './src/assets/styles/app.less'
    .pipe less()
    .on 'error', notify.onError (err) ->
      err.message
    .pipe if debug then gutil.noop() else minifyCSS()
    .pipe gulp.dest('./_build/assets')

gulp.task 'fonts', ->
  gulp.src ['./node_modules/font-awesome/fonts/**/*']
    .pipe gulp.dest './_build/assets'

gulp.task 'copy_html', ->
  gulp.src './src/index.html'
    .pipe gulp.dest './_build'
