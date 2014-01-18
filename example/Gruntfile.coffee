module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    mochaTest:
      options:
        reporter: 'spec'
        require: 'should'
        growl: true
      src: ['test/**/*.coffee']

    watch:
      files: ['app/**/*.coffee', 'test/**/*.coffee']
      tasks: ['test']

    coffeelint:
      options:
        configFile: 'coffeelint.json'
      app: ['app/**/*.coffee', 'test/**/*.coffee']

  grunt.loadNpmTasks 'grunt-mocha-test'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-coffeelint'

  grunt.registerTask 'default', ['watch']
  grunt.registerTask 'test', ['mochaTest', 'coffeelint']

