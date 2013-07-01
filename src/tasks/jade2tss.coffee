'use strict'

module.exports = (grunt)->
  _ = grunt.util._
  helpers = require('grunt-lib-contrib').init(grunt)

  
  defaultProcessContent = (content)-> return content

  
  defaultProcessName = (name)-> return name.replace('.jade', '')

  grunt.registerMultiTask('j2tss', 'Compile jade templates to tss.', ()->
    options = this.options {
      separator: grunt.util.linefeed + grunt.util.linefeed
    }
    grunt.verbose.writeflags(options, 'Options')

    data = options.data
    delete options.data
  
    processContent = options.processContent or defaultProcessContent
    processName = options.processName or defaultProcessName
    
    @files.forEach((f)->
      templates = [];

      f.src.filter((filepath)->
        if not grunt.file.exists(filepath) 
          grunt.log.warn('Source file "' + filepath + '" not found.')
          return false
        else 
          return true
        
      )
      .forEach((filepath)-> 
        src = processContent(grunt.file.read(filepath))
        
        filename = processName(filepath)

        options = grunt.util._.extend(options, { filename: filepath })

        try 
          compiled = require('jade').compile(src, options)
          if (options.client) 
            compiled = compiled.toString()
          else 
            compiled = compiled( if _.isFunction(data) then data.call(f.orig, f.dest, f.src) else data )
          
        catch e
          grunt.log.error(e)
          grunt.fail.warn('Jade failed to compile '+filepath+'.')
        templates.push(compiled)
        
      )

      output = templates;
      if output.length < 1 
        grunt.log.warn('Destination not written because compiled files were empty.')
      else 
        xml2tss = require 'xml2tss'
        
        if not grunt.file.exists(f.dest) 
          xml2tss.convertString output.join(grunt.util.normalizelf(options.separator)),(err,data)->
            if not err
              grunt.file.write(f.dest, data)
              grunt.log.writeln('File "' + f.dest + '" created.')
        else
          xml2tss.convertArray output.join(grunt.util.normalizelf(options.separator)),(err,data)->
            if not err 
              
              result = []
              d = grunt.file.read(f.dest)
              for p in data 
                tmpP = p.replace('.','\.')
                t =  new RegExp('\\"'+tmpP+'\\"(\\s*):(\\s*){(\\s|.)*}',"m")
                if not t.test d
                  result.push p
            
              n = result.map((e)->
                '"'+e+'" : {\n  \n}'
               ).join('\n')
              if n isnt ''
                grunt.file.write(f.dest,d + '\n'+n)
                grunt.log.writeln('File "' + f.dest + '" modified.')

              
  
    )

  )