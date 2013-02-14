module.exports = function(grunt) {
  build_files = ['js/vendor/box2dweb/Box2dWeb-2.1.a.3.min.js', 'js/vendor/jquery.bodysnatch.js', 'js/vendor/RequestAnimationFrame.js', 'js/lib/main.js']
  grunt.initConfig({
  lint: {
    all: ['js/vendor/jquery.bodysnatch.js', 'js/vendor/RequestAnimationFrame.js']
  },
  concat: {
    dist: {
      src: build_files,
      dest: 'js/lib/jquery.box2d.js'
    }
  },
  min: {
      dist: {
        src: ['js/lib/jquery.box2d.js'],
        dest: 'js/lib/jquery.box2d.min.js'
      }
    }
  });
  grunt.registerTask('default', 'concat min');
  //grunt.registerTask('concat', 'concat');
  //grunt.registerTask('lint', 'lint');
};