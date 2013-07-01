module.exports = (grunt) ->
  grunt.initConfig {
    pkg : grunt.file.readJSON('package.json')
    watch:
      coffee : 
        files:["src/*.coffee","src/*/*.coffee"]
        tasks:["coffee"]
    coffee : 
      server :
          expand:true
          cwd:"./src/"
          src:["*/*.coffee","*.coffee"]
          dest:"./"
          ext:".js"
    clean: 
      test: ['tmp']
    j2tss:
      compile: 
        expand:true
        src:"test/fixtures/*.jade"
        dest:"tmp"
        ext: '.tss'
        flatten:true
       
    nodeunit: 
      tests: ['test/*_test.js']
    
  }
  grunt.loadTasks('tasks');
  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-contrib-nodeunit');
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.registerTask('default', ['coffee'])
  grunt.registerTask('test', [ 'j2tss', 'nodeunit'])
