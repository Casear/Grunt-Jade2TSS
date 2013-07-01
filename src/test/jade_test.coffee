grunt = require('grunt');

exports.jade = 
  compile: (test)->
    'use strict'

    test.expect(1)

    actual = grunt.file.read('tmp/jade.tss')
    expected = grunt.file.read('test/expected/jade.tss')
    test.equal(expected, actual, 'should compile jade templates to html')

   
    test.done()