#HOW TO BUILD box2d-jquery

##BUILD

box2d-jquery is written mostly in coffee-script, with some dependencies in javascript.

the build system is based on grunt@0.4.0rc8. grunt v4 is cutting edge, please follow these install instructions carefully (otherwise you will get really really confused, gront@0.3 != grunt@0.4)

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
    * [js/src/init.coffee](js/src/init.coffee)
    * [js/src/app.coffee](js/src/app.coffee)
    * [js/vendor/box2dweb/Box2dWeb-2.1.a.3.min.js](js/vendor/box2dweb/Box2dWeb-2.1.a.3.min.js)
    * [js/vendor/jquery.bodysnatch.js](js/vendor/jquery.bodysnatch.js)
    * [js/vendor/RequestAnimationFrame.js](js/vendor/RequestAnimationFrame.js)
  * for changes
  * if one of these files changes, a new version of
    * [js/lib/jquery.box2d.js](js/lib/jquery.box2d.js)
    * [js/lib/jquery.box2d.min.js](js/lib/jquery.box2d.min.js)
  * will be build
  * yes, i'm not very subtil in my build process
  * please see [Gruntfile.js](Gruntfile.js)

for debugging reasons, in between build steps can be found in the [js/temp/](js/temp/) folder.

if you want to add files to the build process, please add the files to the
 
  * buildfiles
  * coffeesrc

section of [package.json](package.json)

------------------------------

##VIEW

to view your local version of box2d-jquery do something like this

    python -m SimpleHTTPServer 3000

then visit 

 * [http://localhost:3000/](http://localhost:3000/)
 * [http://localhost:3000/development-setup.html](http://localhost:3000/development-setup.html)


------------------------------

##CODE

the important files are



### [js/vendor/jquery.bodysnatch.js](js/vendor/jquery.bodysnatch.js)
jquery plugin that replaces elements with absolute positioned clones of themselves, while hiding & silencing the originals.


### [js/src/init.coffee](js/src/init.coffee)
basically some box2d-jquery shared variables, whenever you encounter a variable you do not recogice, look there

### [js/src/mouse-touch.coffee](js/src/mouse-touch.coffee)
mouse and touch handling stuff (needs a major rewrite, by the way)


### [js/src/create.coffee](js/src/create.coffee)
creates the box2d objects (based on the DOM)


### [js/src/app.coffee](js/src/app.coffee)
the startWorld, draw and update cycle

### [js/src/jquerywrapper.coffee](js/src/jquerywrapper.coffee)
the jquery wrapper and some default options


### [js/vendor/box2dweb/Box2dWeb-2.1.a.3.min.js](js/vendor/box2dweb/Box2dWeb-2.1.a.3.min.js)
the box2d physics engine via <http://code.google.com/p/box2dweb/>

if it can be prevented, don't touch it, it's a direct 1:1 untouched version of box2dweb, i don't want to get into the business of mantaining my own for of box2dweb fork. but if it can't prevented, just do it.







