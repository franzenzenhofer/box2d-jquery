#box2d-jquery challenge for jquery europe 2013

(something to do after the afterparty and during the breaks)

update: yes, i realized now that the wifi sucks and this challenge is kinda hard offline .... you will find a way.


hi, welcome to the box2d-jquery challenge. the idea is simple: contribute to box2d-jquery, get one of ~~15~~ 14 RaspberryPis.

![14 Raspberry Pis](http://replycam.com/i/jqeu13-20130221-213230.png)



###how does the challenge work

  * fork box2d-jquery
  * read [BUILD.md](BUILD.md) to understand how box2d-jquery is structured
  * read terms of the challenge at the end of the document and agree to them
  * solve one of the challenges (see below)
  * send me a pull request 
  * come to the fullstackoptimization (sponsor) table 
  * __[during the jquery europe 2013 converence in vienna (22.2 to 23.2.2013)](http://events.jquery.org/2013/eu/)__ 
  * and talk to me [@enzenhofer](http://twitter.com/enzenhofer) about your pull request

and
  
  * if i still have one of the RaspberryPi
  * and if think your pull request is awesome

then

 * you will get a (1) RaspberryPi
 * max 1 per contributor

**all pull-requests must be compatible with the zlib license of box2d-jquery and box2dWeb**. no strings attached.

##the challenges

 0. make a twitter wall for #jqeu13 using box2d-jquery update: or [make it even cooler](http://www.fullstackoptimization.com/box2d-jquery/twitter-wall.html) 
 1. better touch handling (currently scroll and links are not useable on touch devices) - for this we will have to completely rewirte the touch/mouse event stuff (it must be applied to each DOM element, not globally, i think)
 2. better google chrome android support
 3. [selecting anchor elements](linkstrangeness.html) sometimes leads to strange results, fix it
 4. [collision detection](http://blog.sethladd.com/2011/09/box2d-collision-damage-for-javascript.html) wich can be caught via eventHandler attached to the DOM
 5. support other box2d functions on the DOM elements i.e.: [ApplyImpuls, ApplyForce](http://blog.sethladd.com/2011/09/box2d-impulse-and-javascript.html)
 6. change world boundaries with window resize (without letting stuff fall out of the page)
 7. changes in the box2d "data-" HTML attributes later should change the behavior of the objects in the box2d world, too
 8. make elements keyboard controllable
 9. a) resizing b) moving c)removing an HTML element should resize/move/remove the box2d world element, too
 10. make it work with whatever microsoft browser is currently relevant
 11. make an awesome game with box2d-jquery
 12. [support combined objects](http://blog.sethladd.com/2011/09/box2d-with-complex-and-concave-objects.html) 
 13. support SVG objects
 14. make the whole [box2d](http://www.box2d.org/manual.html) object with all methods available, in a sensemaking way

some other cool ideas would be

 * testing, testing, testing (framework like)
 * performance improvements
 * other stuff i haven't thought up
 * __or jsut create something elese aweomse or usefull for/with box2d-jquery__

you can open a ticket in github and ["call dibs"](http://en.wikipedia.org/wiki/Dibs) on one of the challenges. but hey, if somebody else want to fix the same stuff - or write the awesome feature -  then there is nothing i or anyone else will do about it. it's ok. hey, coding is fun, competitive coding even more fun (maybe).

if i can't get rid of all RaspberryPis during the conference weekend (which is quite likely i think) i will give them away during the coming [viennaJS.org meetups](http://www.viennajs.org/) for minitalks. (viennajs meetups happen every last wednesday of the month, bring your minitalks!)

(that's why i only have 14 RaspberryPis anymore, i gave one away last month for the promise of an TypeScript talk this month)



##Q:"i think XYZ would be great (even though it's not in the challenges), look, here is the pull-request""

A: cool! thx! contribute, talk to me, if it's the awesomeness of awesomeness and i still have one of the RaspberryPis you will probably get one.

##Q:"i wanted to contribute, but hey man your code makes my eyes bleed"

A: live with it, i'm a recreational coder. but i invite you to improve the code, the lib, everything. 


**terms of the challenge*: at no time you get a right to RaspberryPi and at no time you can demand a RaspberryPi. the RaspberryPi challenge is a promotion, not some kind of salery or something. It's given freely as an "hey you are awesome" gesture, not as part of code for computer exchange or other implicit or explicit contract. the challenge can end at any time without prior notice. challenge terms and challenges might change at any time without prior notice. yadda yadda yadda

before taking part in this challenge you have to agree to these terms and everything in this document in some way


