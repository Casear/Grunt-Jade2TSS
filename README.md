# grunt-jade-tss 

> Compile Jade templates to titanium style sheets.



## Getting Started
This plugin requires Grunt `~0.4.0`


```shell
npm install grunt-jade-tss --save-dev
```

Once the plugin has been installed, it may be enabled inside your Gruntfile with this line of JavaScript:

```js
grunt.loadNpmTasks('grunt-jade-tss');
```


### Usage Examples

```js
j2tss: {
  compile: {
    options: {
      data: {
        debug: false
      }
    },
    files: {
      "path/to/dest.tss": ["path/to/templates/*.jade", "another/path/tmpl.jade"]
    }
  }
}
```
```
j2tss:{
  compile: {
    expand:true
    src:"path/to/templates/*.jade"
    dest:"path/to/"
    ext: '.tss'
    flatten:true
  }
}
```



---

Task submitted by [Casear Chu](http://ericw.ca/)

*This file was generated on Thu July 01 2013 12:01:29.*
