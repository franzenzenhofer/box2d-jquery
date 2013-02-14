/*global module:false*/
module.exports = function(grunt) {

  var packagejson = grunt.file.readJSON('package.json');
  // Project configuration.
  grunt.initConfig({
    // Metadata.
    pkg: packagejson,
    banner: '/*! <%= pkg.title || pkg.name %> - v<%= pkg.version %> - last build: <%= grunt.template.today("yyyy-mm-dd HH:MM:ss") %> */\n',
    // Task configuration.
    concat: {
      options: {
        banner: '<%= banner %>',
        stripBanners: true
      },
      dist: {
        src: packagejson.buildfiles,
        dest: '<%= pkg.buildto %>'
      },
      coffee: {
        options: {banner: '# <%= banner %>'},
        src: packagejson.coffeesrc,
        dest: 'js/temp/main.coffee'
      }
    },
    uglify: {
      options: {
        banner: '<%= banner %>',
        mangle: true,
        compress: false, //compress must be false, otherwise behaviour change!!!!!
        beautify: false
      },
      dist: {
        src: '<%= concat.dist.dest %>',
        dest: '<%= pkg.main %>'
      }
    },
    jshint: {
      options: {
        curly: true,
        eqeqeq: true,
        immed: true,
        latedef: true,
        newcap: true,
        noarg: true,
        sub: true,
        undef: true,
        unused: true,
        boss: true,
        eqnull: true,
        browser: true,
        globals: {
          jQuery: true
        }
      },
      gruntfile: {
        src: 'Gruntfile.js'
      }//,
      //coffee: {
      //  src: 'js/temp/*.js'
      //}//,
      //lib_test: {
      //  src: ['lib/**/*.js', 'test/**/*.js']
      //}
    },
    //qunit: {
    //  files: ['test/**/*.html']
    //},
    coffee: {
      options: {
        bare:false
      },
      testcompile: {
        expand: true,
        cwd: 'js/src',
        src: ['*.coffee'],
        dest: 'js/temp/',
        ext: '.js'
        },
      build: {
        files: {
          '<%= pkg.coffeedest %>': '<%= concat.coffee.dest %>'
        }
      }
     },
    watch: {
      gruntfile: {
        files: '<%= jshint.gruntfile.src %>',
        tasks: ['jshint:gruntfile']
      },
      dist: {
        files: packagejson.buildfiles,
        tasks: ['concat', 'uglify']
      },
      coffee: {
        files: packagejson.coffeesrc,
        tasks: ['concat:coffee','coffee:testcompile', 'coffee:build']
      }//,
      //lib_test: {
      //  files: '<%= jshint.lib_test.src %>',
      //  tasks: ['jshint:lib_test', 'qunit']
      //}
    }
  });

  // These plugins provide necessary tasks.
  grunt.loadNpmTasks('grunt-contrib-concat');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  //grunt.loadNpmTasks('grunt-contrib-nodeunit');
  grunt.loadNpmTasks('grunt-contrib-jshint');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-coffee');

  // Default task.
  //grunt.registerTask('default', ['jshint', 'qunit', 'concat', 'uglify']);
  //grunt.registerTask('default', ['jshint', 'concat', 'uglify', 'watch']);
  grunt.registerTask('default', ['concat:coffee', 'coffee', 'jshint', 'concat', 'uglify', 'watch']);

};
