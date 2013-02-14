# Usage Examples

```js
coffee: {
  compile: {
    files: {
      'path/to/result.js': 'path/to/source.coffee', // 1:1 compile
      'path/to/another.js': ['path/to/sources/*.coffee', 'path/to/more/*.coffee'] // compile and concat into single file
    }
  },

  glob_to_multiple: {
    files: grunt.file.expandMapping(['path/to/*.coffee'], 'path/to/dest/', {
      rename: function(destBase, destPath) {
        return destBase + destPath.replace(/\.coffee$/, '.js');
      }
    })
  }
}
```