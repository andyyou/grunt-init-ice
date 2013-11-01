'use strict'

module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json'),
    banner: '/*! <%= pkg.title || pkg.name %> - v<%= pkg.version %>' +
            ':: <%= grunt.template.today("yyyy-mm-dd")\n' +
            '** Copyright (c) <%= grunt.template.today("yyyy") %> <%= pkg.author.name %>;' +
            '** Licensed <%= _.pluck(pkg.licenses, "type").join(", ") %> */\n',
    clean:
      css:
        src: ['css/*.css']
      tmp:
        src: ['tmp/*']
      js:
        src: ['js/*.js']
      dist:
        src: ['dist']
    concat:
      options: '<%= banner %>',
      stripBanners: true
      dist:
        'dist/css/<%= pkg.name %>.css': ['css/*.css'],
        'dist/js/<%= pkg.name %>.js': ['js/*.js']
    connect:
      server:
        options:
          port: 9001,
          base: './'
    coffee:
      compile:
        files: [{
          expand: true,
          cwd: 'js/coffee',
          src: ['*.coffee'],
          dest: 'js',
          ext: '.js'
        }]
    sass:
      options:
        style: 'expanded'
      files:[{
        expand: true,
        cwd: 'css/sass',
        src: ['*.sass'],
        dest: ['css'],
        ext: '.css'
        }]
      normalize:
        files:[
          {src: ['bower_components/normalize-sass/*.sass'], dest: 'css/normalize.css'}
        ]
    watch:
      static:
        files: ['*.html'],
        options:
          livereload: true
    copy:
      bootstrap:
        files:[
          {
            expand: true
            cwd: 'bower_components/bootstrap/dist'
            src:  ['**/*.min.css', '**/*.min.js', 'fonts/*']
            dest: './'
          }
        ]
      jquery:
        files:[
          {
            expand: true
            cwd: 'bower_components/jquery'
            src: ['*.min.js']
            dest: './js'
          }
        ]
      angular:
        files: [
          {
            expand: true
            cwd: 'bower_components/angular'
            src: ['*.min.js']
            dest: './js'
          }
        ]
    #============================================================================================================================
    # Compress and minify javascript                              
    #============================================================================================================================
    # uglify:
    #   options:
    #     banner: '<%= banner %>'
    #   dist:
    #     'dest' : 'src'
    #============================================================================================================================
    # TEST                                                        
    #============================================================================================================================
    # qunit: 
    #   files: ['test/**/*.html']
    #============================================================================================================================
    # Jshint                                                      
    #============================================================================================================================
    # jshint:
    #   gruntfile:
    #     options:
    #       jshintrc: '.jshintrc',
    #       curly:   true,
    #       eqeqeq:  true,
    #       eqnull:  true,
    #       browser: true,
    #       globals: 
    #         jQuery: true
    #     src: 'Gruntfile.js'
    #   src:
    #     options:
    #       jshintrc: 'src/.jshintrc'
    #     src: ['src/**/*.js']
    #============================================================================================================================
    # Compass                                                     
    #============================================================================================================================
    # compass: 
    #   dist:
    #     options:
    #       sassDir: 'css/sass',
    #       cssDir: 'css',
    #       environment: 'production'
    #============================================================================================================================
    # CoffeeScript jshint                                         
    #============================================================================================================================
    # coffee_jshint:
    #   options: 
    #     globals: ['console']
    #   source: 
    #     src: 'src/**/*.coffee'
    #   specs: 
    #     src: 'specs/**/*.coffee'

  # Load Npm package, Note:: You need install grunt plugin  
  # ex: npm install grunt-contrib-clean --save-dev
  grunt.loadNpmTasks('grunt-contrib-clean')
  grunt.loadNpmTasks('grunt-contrib-concat')
  grunt.loadNpmTasks('grunt-contrib-connect')
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-sass')
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-contrib-copy')

  # Comment plugins
  # grunt.loadNpmTasks('grunt-contrib-uglify');
  # grunt.loadNpmTasks('grunt-contrib-qunit');
  # grunt.loadNpmTasks('grunt-contrib-jshint');
  # grunt.loadNpmTasks('grunt-contrib-compass');
  # grunt.loadNpmTasks('grunt-coffee-jshint');

  # *** Custom tasks ***

  #============================================================================================================================
  #  Initialze a new project 
  #============================================================================================================================
  # command : npm install -> bower install -> grunt iniz
  grunt.registerTask 'iniz', 'Initialize frontend basic project'
  , [
      'clean:css', 'clean:js',
      'sass:normalize',
      'copy:jquery', 'copy:bootstrap', 'copy:angular'
    ]

  #============================================================================================================================
  #  Start server
  #============================================================================================================================
  # command : npm install -> bower install -> grunt iniz
  grunt.registerTask 'start', 'Start local server'
  , [
      'connect', 'watch'
    ]


  #============================================================================================================================
  # [UNDONE] Create a new project 
  #============================================================================================================================
  # grunt.registerTask 'new', 'Initialize frontend basic project', () ->
  #   async = require('async');
  #   exec = require('child_process').exec
  #   done = this.async
  #   run = (item, callback) ->
  #     process.stdout.write('running "' + item + '"...\n')
  #     cmd = exec item
  #     cmd.stdout.on 'data', (data) ->
  #       grunt.log.writeln(data)
  #     cmd.stderr.on 'data', (data) ->
  #       grunt.log.errorlns(data)
  #     cmd.on 'exit', (code) ->
  #       if code isnt 0
  #         throw new Error '#{item} failed'
  #       grunt.log.writeln "done!!\n"
  #       callback

  #   async.series
  #     npm: (callback) ->
  #       run 'npm install', callback
  #     bower: (callback) ->
  #       run 'bower install', callback
  #     (err, results) ->
  #       if err then done false
  #       done()
  
