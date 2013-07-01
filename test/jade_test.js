(function() {
  var grunt;

  grunt = require('grunt');

  exports.jade = {
    compile: function(test) {
      'use strict';
      var actual, expected;
      test.expect(1);
      actual = grunt.file.read('tmp/jade.tss');
      expected = grunt.file.read('test/expected/jade.tss');
      test.equal(expected, actual, 'should compile jade templates to html');
      return test.done();
    }
  };

}).call(this);
