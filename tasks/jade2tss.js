(function() {
  'use strict';
  module.exports = function(grunt) {
    var defaultProcessContent, defaultProcessName, helpers, _;
    _ = grunt.util._;
    helpers = require('grunt-lib-contrib').init(grunt);
    defaultProcessContent = function(content) {
      return content;
    };
    defaultProcessName = function(name) {
      return name.replace('.jade', '');
    };
    return grunt.registerMultiTask('j2tss', 'Compile jade templates to tss.', function() {
      var data, options, processContent, processName;
      options = this.options({
        separator: grunt.util.linefeed + grunt.util.linefeed
      });
      grunt.verbose.writeflags(options, 'Options');
      data = options.data;
      delete options.data;
      processContent = options.processContent || defaultProcessContent;
      processName = options.processName || defaultProcessName;
      return this.files.forEach(function(f) {
        var output, templates, xml2tss;
        templates = [];
        f.src.filter(function(filepath) {
          if (!grunt.file.exists(filepath)) {
            grunt.log.warn('Source file "' + filepath + '" not found.');
            return false;
          } else {
            return true;
          }
        }).forEach(function(filepath) {
          var compiled, e, filename, src;
          src = processContent(grunt.file.read(filepath));
          filename = processName(filepath);
          options = grunt.util._.extend(options, {
            filename: filepath
          });
          try {
            compiled = require('jade').compile(src, options);
            if (options.client) {
              compiled = compiled.toString();
            } else {
              compiled = compiled(_.isFunction(data) ? data.call(f.orig, f.dest, f.src) : data);
            }
          } catch (_error) {
            e = _error;
            grunt.log.error(e);
            grunt.fail.warn('Jade failed to compile ' + filepath + '.');
          }
          return templates.push(compiled);
        });
        output = templates;
        if (output.length < 1) {
          return grunt.log.warn('Destination not written because compiled files were empty.');
        } else {
          xml2tss = require('xml2tss');
          if (!grunt.file.exists(f.dest)) {
            return xml2tss.convertString(output.join(grunt.util.normalizelf(options.separator)), function(err, data) {
              if (!err) {
                grunt.file.write(f.dest, data);
                return grunt.log.writeln('File "' + f.dest + '" created.');
              }
            });
          } else {
            return xml2tss.convertArray(output.join(grunt.util.normalizelf(options.separator)), function(err, data) {
              var d, n, p, result, t, tmpP, _i, _len;
              if (!err) {
                result = [];
                d = grunt.file.read(f.dest);
                for (_i = 0, _len = data.length; _i < _len; _i++) {
                  p = data[_i];
                  tmpP = p.replace('.', '\\.');
                  t = new RegExp('\\"' + tmpP + '\\"(\\s*):(\\s*){(\\s|.)*}', "m");
                  if (!t.test(d)) {
                    result.push(p);
                  }
                }
                n = result.map(function(e) {
                  return '"' + e + '" : {\n  \n}';
                }).join('\n');
              }
              if (n !== '') {
                grunt.file.write(f.dest, d + '\n' + n);
                return grunt.log.writeln('File "' + f.dest + '" modified.');
              }
            });
          }
        }
      });
    });
  };

}).call(this);
