#HOW TO BUILD box2d-jquery

box2d-jquery is written mostly in coffee-script, with some dependencies in javas-script.

the build system is based on grunt@0.4.0rc8. grunt v4 is cutting edge, please follow these install instructions carefully. 

    npm install -g grunt-cli

this install a command line grunt wrapper, please see <https://github.com/gruntjs/grunt-cli>

now, in your box2d-jquery folder do

    npm install

this installs a lot of stuff. after it finished successfully, do 

    npm grunt --version 

if something like this shows up

    grunt-cli v0.1.6
    grunt v0.4.0rc8

you are ready to go.

    grunt -v

will

  * build a new version of box2d-jquery
  * watch
    * <js/src/init.coffee>
    * <js/src/app.coffee>
    * <js/vendor/box2dweb/Box2dWeb-2.1.a.3.min.js>
    * <js/vendor/jquery.bodysnatch.js>
    * <js/vendor/RequestAnimationFrame.js>
  * for changes
  * if one of these files changes, a new version of
    * <js/lib/jquery.box2d.js>
    * <js/lib/jquery.box2d.min.js>
  * will be build
  * yes, i'm not very subtil in my build process

for debugging reasons, in between build steps can be found in the <js/temp/> folder.

if you want to add files to the build process, please add the files to the
 
  * buildfiles
  * coffeesrc

section of <package.json> 







