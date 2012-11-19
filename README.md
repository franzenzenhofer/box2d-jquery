#box2d-jQuery

##note: not yet ready for prime time
##links not yet working
## v0.8

hi, as [i](http://www.fullstackoptimization.com/) - in a moment of madness - decided to become an offical sponsor of the **[jQuery Europe 2013 conference in Vienna](http://events.jquery.org/2013/eu/)** i decided to code a jquery plugin i wish existed but strangly didn't - until now

`jquery.box2d.js` is a simple jquery plugin that transforms DOM elements into actual physical objects. well, physical in a 2d-world that is. just go to

 * [countdown to jquery europe 2013](http://www.fullstackoptimization.com/box2d-jquery/index.html)
 * [101 bouncing balls](http://www.fullstackoptimization.com/box2d-jquery/101-bouncing-balls.html)
 * 2 videos (to come)
 * you, yourself and i (to come)

 and start to **KICK STUFF AROUND** (with your mouse/touchpad pointer - or using your fingers on modern iOS devices.)

 oh, and before i forget, stop by the jquery conference, it will be cool (i promise), and use the [voucher code 'fullstackoptimization'](http://jquery-eu-2013.eventbrite.com/?discount=fullstackoptimization) for 5% off.

##acknowledgements

thx to box2dweb [http://code.google.com/p/box2dweb/](http://code.google.com/p/box2dweb/) which is the engine that works in the background.

thx to 
[Pål Smitt-Amundsen](https://twitter.com/PaalSA) i based this project heavily on the stuff i found in [his blog (and lab experiments)](http://paal.org/blog/) and thx for giving me [permission to reuse his stuff open source style](https://twitter.com/PaalSA/status/266630391971057664).



##how to use jquery.box2d.js

well, the [hello-world.html](http://www.fullstackoptimization.com/box2d-jquery/hello-world.html) knows best

    <!doctype html><!-- it's HTML5 time -->

    <html>
    <head><title>hello world box2d-jquery example</title>
    </head>

    <style>
      /* it's a good idea to give block elements a width, otherwise they go all the way (to the width of theire parent)*/
      h1 {background-color: lightgray; width: 500px;}
      div {width: 500px; background-color: lightgray;}
    </style>

    <body>

    <h1>Hello World Lorem Ipsum</h1>

    <!-- it's a very good idea to give img an width and height, as physical 2d objects need them to make any sense -->
    <img src="http://placekitten.com/400/300" width="400px" height="300px">

    <div>Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat ...</div>
    
    <!-- it's a jquery plugin, so make sure you include jquery -->
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js"></script>

    <!-- include the production version of jquery.box2d.js -->
    <script src="./js/lib/jquery.box2d.min.js"></script>

    <!-- your script starts here -->
    <script> 
      <!-- wait until the DOM is ready, otherwise strange things might happen -->
      $(document).ready(function() { 
        <!-- select DOM nodes and make them fall down with a speed of 5px per step --> 
        $("h1, div, img").box2d({'y-velocity':5});
      });
    </script>
    <!-- that's it -->

    </body>
    </html>

so well, yes, after you have a DOM ready and included all the necessary dependencies (jquery and jquery.box2d.js) all you have to do it

    $("#some_element").box2d({'y-velocity':10});

with this simpel jquery function call, you

  * initalize a 2d world
  * with a top (window top), left (window left), right (document width) and bottom (document height) boundary
  * where everything falls down, with about 10px per step
  * and you made the element with the id 'some_element' part of that cruel world

  it is important to note, that every first call to `.box2d()` initalized the world. every other, follow up call only adds stuff to this world (well, we have to create a world sometime)

  `.box2d()` takes a few options

  ```javascript
    {
    'y-velocity': 10, /* everything falls down, default 0 */
    'x-velocity': 10, /* everything falls right, default 0 */
    'debug': false, /* fancy debug modus using canvas, default false */
    'static': false, /* true ... it stays | false ... it moves, default false */
    'density': 1.2 ,/* thik weight (relational to its size) between 0 and n, default 1.5 */
    'restitution': 0.4,/* think: bounciness, from 0 to 1, default 0.4 */
    'friction': 0.3, /* think: slideiness, from 0 to 1, default 0.3 */
    'shape': 'box' /* default "box", but could also be a "circle", it it's not a "circle", it's a "box"*/
    }
  ```

if you want to be more specific about density, restitution and friction i recommend the great <a href="http://www.box2d.org/manual.html">box2d</a> manual.

> **Density**<br>
> The fixture density is used to compute the mass properties of the parent body. The density can be zero or positive. You should generally use similar densities for all your fixtures. This will improve stacking stability.

> **Friction**<br>
> Friction is used to make objects slide along each other realistically. Box2D supports static and dynamic friction, but uses the same parameter for both. Friction is simulated accurately in Box2D and the friction strength is proportional to the normal force (this is called Coulomb friction). The friction parameter is usually set between 0 and 1, but can be any non-negative value. A friction value of 0 turns off friction and a value of 1 makes the friction strong. When the friction force is computed between two shapes, Box2D must combine the friction parameters of the two parent fixtures.
>So if one fixture has zero friction then the contact will have zero friction.

> **Restitution**<br>
>Restitution is used to make objects bounce. The restitution value is usually set to be between 0 and 1. Consider dropping a ball on a table. A value of zero means the ball won't bounce. This is called an inelastic collision. A value of one means the ball's velocity will be exactly reflected. This is called a perfectly elastic collision.


## about the world initialization
with the first `.box2d()` call you initalize the world. currently

 * y-velocity
 * x-velocity
 * debug

are first call / world initialization only calls.

with the world world initialization you create boundaries. these are invisible and static (unmoveable) and try to mimic the "normal" HTML-document boundaries.

the boundaries are objects like any other object (but invisble and unmoveable), so the have the density, restitution and friction of the first `.box2d()` call (default: density=1.5, restitution=0.4, friction=0.3)

## things to mind
ok, this is very important, you should read this twice:

**things must have a width and height** and it's a good idea to set them explicit. 

ok, you say no big deal, but well. take the simple a simpel H1 or even a simple DIV element. i.e.: take a look at [development-setup.html](http://www.fullstackoptimization.com/box2d-jquery/development-setup.html) (debug enabled)
the H1 goes all the way, the whole width of it's parent. that's because it's a block element. these things do stuff like this, but normaly you don't see it (and you don't see the box aroun the block element). so the H1 will float strangely to the not-DOM-box-model experienced user. give it a width and everything is fine.

also **IMAGES**
if you don't give image a widht or height, either via attributes or css-styles, they do not have any height or widht - until they are fully loaded. this can take a while, and can lead to strange effects. sometimes everything will work fine, othertimes everything is slightly screwed up, and sometimes box2d will just hang your browser window. give your images an explicit width and height and everthing will be fine (and faster, too).

box2d-jquery will complain on the console that it found an image without width and height.

## look ma HTML attributes!!!

    <div box2d-static='true' style="widht:200px; height:200px;"></div>
    <div box2d-shape='circle' style="widht:200px; height:200px;"></div>
    <div box2d-density="1.5" box2d-restitution="0.4" box2d-friction="0.3" style="widht:200px; height:200px;"></div>

HTML attributes > jquery options assignment, nuff said!

ok, that's bascally it. any question? bugs? other stuff? please use the issue tracker. 

## TODOs

 * debug touch on andorid devices
 * performance profiling
 * collision detection 
 * colliosn dection events
 * make y/x-volocity changeable after world initialization
 * change world boundaries with window resize

##license
  Copyright (C) 2012 - 305678 Franz Enzenhofer
  (see in source code licenses for other copyright holders)

  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the authors be held liable for any damages
  arising from the use of this software.

  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:

  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgment in the product documentation would be
     appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.




