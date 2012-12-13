b2Vec2 = Box2D.Common.Math.b2Vec2
b2AABB = Box2D.Collision.b2AABB
b2BodyDef = Box2D.Dynamics.b2BodyDef
b2Body = Box2D.Dynamics.b2Body
b2FixtureDef = Box2D.Dynamics.b2FixtureDef
b2Fixture = Box2D.Dynamics.b2Fixture
b2World = Box2D.Dynamics.b2World
b2MassData = Box2D.Collision.Shapes.b2MassData
b2PolygonShape = Box2D.Collision.Shapes.b2PolygonShape
b2CircleShape = Box2D.Collision.Shapes.b2CircleShape
b2DebugDraw = Box2D.Dynamics.b2DebugDraw
b2RevoluteJointDef = Box2D.Dynamics.Joints.b2RevoluteJointDef
b2MouseJointDef =  Box2D.Dynamics.Joints.b2MouseJointDef
$ = jQuery


hw = {
  '-webkit-transform': 'translateZ(0)'
  '-moz-transform': 'translateZ(0)'
  '-o-transform': 'translateZ(0)'
  'transform': 'translateZ(0)'  
}

S_T_A_R_T_E_D = false
D_E_B_U_G = false
world = {}
x_velocity = 0
y_velocity = 0
SCALE = 30
D2R = Math.PI / 180
R2D = 180 / Math.PI
PI2 = Math.PI*2
interval = {}
default_static = false
default_density = 1.5
default_friction = 0.3
default_restitution = 0.4
default_shape = 'box'
#static_ = default_static, density = default_density, restitution = default_restitution, friction=default_friction 

mouseX = 0
mouseY = 0
mousePVec = undefined
isMouseDown = false
selectedBody = undefined
mouseJoint = undefined



#mouse-and-touch-stuff

MouseAndTouch = (dom, down, up, move) ->
  #console.log(dom)
  #shitty naming
  canvas = dom
  mouseX = undefined
  mouseY = undefined
  startX = undefined
  startY = undefined
  isDown = false
  #When drawing the "road" get mouse or touch positions
  #we need fixed to make this better on touch devices
  mouseMoveHandler = (e) ->
    updateFromEvent e
    move mouseX, mouseY
  #TODO: bind this to the elements, not the document, so that default actions on touch can still work
  updateFromEvent = (e) ->
    #now we can click things, but well, throwing stuff around is'nt so cool anymore
    e.preventDefault()
    touch = e.originalEvent
    if touch and touch.touches and touch.touches.length is 1
      
      #Prevent the default action for the touch event; scrolling
      touch.preventDefault()
      mouseX = touch.touches[0].pageX
      mouseY = touch.touches[0].pageY
    else
      mouseX = e.pageX
      mouseY = e.pageY
  mouseUpHandler = (e) ->
    #console.log(canvas)
    canvas.addEventListener "mousedown", mouseDownHandler, true
    canvas.removeEventListener "mousemove", mouseMoveHandler, true
    isDown = false
    updateFromEvent e
    up mouseX, mouseY
  touchUpHandler = (e) ->
    canvas.addEventListener "touchstart", touchDownHandler, true
    canvas.removeEventListener "touchmove", mouseMoveHandler, true
    isDown = false
    updateFromEvent e
    up mouseX, mouseY
  mouseDownHandler = (e) ->
    canvas.removeEventListener "mousedown", mouseDownHandler, true
    canvas.addEventListener "mouseup", mouseUpHandler, true
    canvas.addEventListener "mousemove", mouseMoveHandler, true
    isDown = true
    updateFromEvent e
    down mouseX, mouseY
  touchDownHandler = (e) ->
    canvas.removeEventListener "touchstart", touchDownHandler, true
    canvas.addEventListener "touchend", touchUpHandler, true
    canvas.addEventListener "touchmove", mouseMoveHandler, true
    isDown = true
    updateFromEvent e
    down mouseX, mouseY
  canvas.addEventListener "mousedown", mouseDownHandler, true
  canvas.addEventListener "touchstart", touchDownHandler, true
  ret = {}
  ret.mouseX = ->
    mouseX

  ret.mouseY = ->
    mouseY

  ret.isDown = ->
    isDown

  return ret

#mouse helper
downHandler = (x, y) ->
  isMouseDown = true
  moveHandler x, y
upHandler = (x, y) ->
  isMouseDown = false
  mouseX = null
  mouseY = null
moveHandler = (x, y) ->
  #console.log(canvasPosition.x)
  #console.log(canvasPosition.y)
  #mouseX = (x - canvasPosition.x) / 30
  #mouseY = (y - canvasPosition.y) / 30
  mouseX = x / 30
  mouseY = y / 30

getBodyAtMouse = ->
  mousePVec = new b2Vec2(mouseX, mouseY)
  aabb = new b2AABB()
  aabb.lowerBound.Set mouseX - 0.001, mouseY - 0.001
  aabb.upperBound.Set mouseX + 0.001, mouseY + 0.001
  
  # Query the world for overlapping shapes.
  selectedBody = null
  world.QueryAABB getBodyCB, aabb 
  selectedBody
getBodyCB = (fixture) ->
  unless fixture.GetBody().GetType() is b2Body.b2_staticBody
    if fixture.GetShape().TestPoint(fixture.GetBody().GetTransform(), mousePVec)
      selectedBody = fixture.GetBody()
      return false
  true
getElementPosition = (element) ->
  elem = element
  tagname = ""
  x = 0
  y = 0
  while (typeof (elem) is "object") and (typeof (elem.tagName) isnt "undefined")
    y += elem.offsetTop
    x += elem.offsetLeft
    tagname = elem.tagName.toUpperCase()
    elem = 0  if tagname is "BODY"
    elem = elem.offsetParent  if typeof (elem.offsetParent) is "object"  if typeof (elem) is "object"
  x: x
  y: y
updateMouseDrag = ->
  if isMouseDown and (not mouseJoint)
    body = getBodyAtMouse()
    if body
      md = new b2MouseJointDef()
      md.bodyA = world.GetGroundBody()
      md.bodyB = body
      md.target.Set mouseX, mouseY
      md.collideConnected = true
      md.maxForce = 300.0 * body.GetMass()
      mouseJoint = world.CreateJoint(md)
      body.SetAwake true
  if mouseJoint
    if isMouseDown
      mouseJoint.SetTarget new b2Vec2(mouseX, mouseY)
    else
      world.DestroyJoint mouseJoint
      mouseJoint = null



  
createDOMObjects = (jquery_selector, shape = default_shape, static_ = default_static, density = default_density, restitution = default_restitution, friction=default_friction) ->
  #iterate all div elements and create them in the Box2D system
  #$("#container div").each (a, b) ->
  #console.log(jquery_selector)
  $(jquery_selector).each (a, b) -> 
    #console.log(a)
    #console.log(b)
    domObj = $(b)
    full_width = domObj.width()
    full_height = domObj.height()
    if not (full_width and full_height)
      if domObj.attr('src')
        console?.log('box2d-jquery ERROR: an element withour width or height, will lead to strangeness!')
        domObj.on('load', ()->createDOMObjects(@, shape, static_, density, restitution, friction))
        #temp_src= domObj.attr('src')
        #domObj.attr('src', '');
        #domObj.attr('src', temp_src);
      return true
    #console.log('no load')
    #if (not full_width or not full_height) and (b[0] and (b[0].src isnt ''))  
    #  #console.log('attching event handler to an elment that isnt quite ready yet')
    #  #console.log(domObj)
    #  #console.log(shape)
    #  console?.log('WARNING: an element with a src="" but without width and height, not good, from a jquery.box2d.js kinda view!')
    #  #domObj.on('load', ()->createDOMObjects(@, shape, static_, density, restitution, friction))
    #  return true

    #console.log('in create DOM objects')
    #console.log(a)
    #console.log(b)
    
    domPos = $(b).position()
    width = full_width / 2
    height = full_height / 2
    x = (domPos.left)  + width
    y = (domPos.top) + height

    #element attributes with box2d- overwrite the other argument

    #if domObj.attr('box2d-shape')
    #  make_shape = domObj.attr('box2d-shape')
    #else
    #  make_shape = shape
    make_shape = (if domObj.attr('box2d-shape') then domObj.attr('box2d-shape') else shape)
    #TODO TEST
    make_density = parseFloat((if domObj.attr('box2d-density') then domObj.attr('box2d-density') else density))
    #TODO TEST
    make_restitution = parseFloat((if domObj.attr('box2d-restitution') then domObj.attr('box2d-restitution') else restitution))
    #TODO TEST
    make_friction = parseFloat((if domObj.attr('box2d-friction') then domObj.attr('box2d-friction') else friction))
    #TODO TEST
    if domObj.attr('box2d-static') is "true" 
      make_static = true 
    else if domObj.attr('box2d-static') is "false"
      make_static = false
    else 
      make_static = static_ 

    if make_shape and make_shape isnt 'circle'
      body = createBox(x, y, width, height, make_static, make_density, make_restitution, make_friction )
    else
      r = (if width > height then width else height)
      #console.log('radius '+r)
      body = createCircle(x, y, r, make_static, make_density, make_restitution, make_friction )
    body.m_userData = {
      domObj: domObj
      width: width
      height: height
      }

    #Reset DOM object position for use with CSS3 positioning
    #domObj.absolutize()#.css({left: "0px",top: "0px"})
    
    origin_values = '50% 50% 0'
    domObj.css(
      #"left": "0px"
      #"top": "0px"
      "-webkit-transform-origin": origin_values
      "-moz-transform-origin": origin_values 
      "-ms-transform-origin": origin_values 
      "-o-transform-origin": origin_values 
      "transform-origin": origin_values 
      )  

    return true

createBox = (x, y, width, height, static_ = default_static, density = default_density, restitution = default_restitution, friction=default_friction ) ->
  #console.log('in create box')
  bodyDef = new b2BodyDef
  bodyDef.type = (if static_ then b2Body.b2_staticBody else b2Body.b2_dynamicBody)
  bodyDef.position.x = x / SCALE
  bodyDef.position.y = y / SCALE
  fixDef = new b2FixtureDef
  #fixDef.density = 1.5
  #fixDef.friction = 0.3
  #fixDef.restitution = 0.4
  fixDef.density = density
  fixDef.friction = friction
  fixDef.restitution = restitution
  #console.log('now restitution')
  #console.log(restitution)
  #if restitution is 0 then console.log('HIHO')
  #console.log(fixDef.friction)
  fixDef.shape = new b2PolygonShape
  fixDef.shape.SetAsBox width / SCALE, height / SCALE
  return world.CreateBody(bodyDef).CreateFixture fixDef

createCircle = (x, y, r, static_ = default_static, density = default_density, restitution = default_restitution, friction=default_friction ) ->
  #console.log('in create CIRCLE')
  bodyDef = new b2BodyDef
  bodyDef.type = (if static_ then b2Body.b2_staticBody else b2Body.b2_dynamicBody)
  bodyDef.position.x = x / SCALE
  bodyDef.position.y = y / SCALE
  fixDef = new b2FixtureDef
  fixDef.density = density
  fixDef.friction = friction 
  fixDef.restitution = restitution
  #fixDef.shape = new b2PolygonShape
  #fixDef.shape.SetAsBox width / SCALE, height / SCALE
  fixDef.shape = new b2CircleShape(r / SCALE);
  return world.CreateBody(bodyDef).CreateFixture fixDef

###

fixDef = new b2FixtureDef;
      fixDef.density = 1.0;
      fixDef.friction = 0.5;
      fixDef.restitution = 0.2;

      bodyDef = new b2BodyDef;
      bodyDef.type = b2Body.b2_dynamicBody;
      fixDef.shape = new b2CircleShape(10 / SCALE);

      bodyDef.position.x = 100 / SCALE;
      bodyDef.position.y = 10 / SCALE;
      world.CreateBody(bodyDef).CreateFixture(fixDef);

###

drawDOMObjects = ->
  i = 0
  b = world.m_bodyList

  while b
    f = b.m_fixtureList

    while f
      if f.m_userData
        
        #Retrieve positions and rotations from the Box2d world
        x = Math.floor((f.m_body.m_xf.position.x * SCALE) - f.m_userData.width)
        y = Math.floor((f.m_body.m_xf.position.y * SCALE) - f.m_userData.height)
        
        #CSS3 transform does not like negative values or infitate decimals
        r = Math.round(((f.m_body.m_sweep.a + PI2) % PI2) * R2D * 100) / 100
        #translate_values = "translate(" + x + "px," + y + "px) rotate(" + r + "deg)"
        translate_values = "rotate(" + r + "deg)"
        css = 
          "-webkit-transform": translate_values 
          "-moz-transform": translate_values 
          "-ms-transform": translate_values 
          "-o-transform": translate_values 
          "transform": translate_values  
          "left": x+"px"
          "top": y+"px"  
        f.m_userData.domObj.css css
      f = f.m_next
    b = b.m_next

update = ->

  updateMouseDrag()
  #frame-rate
  #velocity iterations
  world.Step 1 / 60, 10, 10 #position iterations
  drawDOMObjects()
  if D_E_B_U_G
    world.DrawDebugData()
  world.ClearForces()
  #update()
  requestAnimationFrame(update);


init = (jquery_selector, density = default_density, restitution = default_restitution, friction=default_friction) ->
  S_T_A_R_T_E_D = true
  world = new b2World(
    new b2Vec2(x_velocity,y_velocity),
    true
    )
  #createDOMObjects($(jquery_selector).bodysnatch())
  w = $(window).width(); 
  h = $(window).height();
  #top border box
  createBox(0, -1 , $(window).width(), 1, true, density, restitution, friction);
  #right hand side box
  createBox($(window).width()+1, 0 , 1, $(window.document).height(), true, density, restitution, friction);
  #left hand side border
  createBox(-1, 0 , 1, $(window.document).height(), true, density, restitution, friction);
  #console.log($(window.document).height())
  #console.log($(window).height())
  #bottom box
  createBox(0, $(window.document).height()+1, $(window).width(), 1, true, density, restitution, friction);
  mouse = MouseAndTouch(document, downHandler, upHandler, moveHandler)

  #debug
  if D_E_B_U_G
    debugDraw = new b2DebugDraw();
    canvas = $('<canvas></canvas>')
    debugDraw.SetSprite(canvas[0].getContext("2d"));
    debugDraw.SetDrawScale(SCALE);
    debugDraw.SetFillAlpha(0.3);
    debugDraw.SetLineThickness(1.0);
    debugDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);
    canvas.css('position','absolute')
    canvas.css('top',0)
    canvas.css('left',0)
    canvas.css('border','1px solid green')
    canvas.attr('width', $(window).width());
    canvas.attr('height', $(document).height());
    world.SetDebugDraw(debugDraw);
    $('body').append(canvas)

  #trigger hardware acclearation
  #$('body').css(hw);
  
  update();
  
#init("#container div, img")
#init("h1")
#canvasPosition = getElementPosition(document.getElementById("canvas"))

$.fn.extend
  box2d: (options) ->
    self = $.fn.box2d
    opts = $.extend {}, self.default_options, options
    x_velocity = opts['x-velocity']
    y_velocity = opts['y-velocity']
    density = opts['density']
    restitution = opts['restitution']
    friction= opts['friction']
    shape = opts['shape']
    static_ = opts['static']
    debug = opts['debug']
    #console.log(opts)
    if S_T_A_R_T_E_D is false
      if debug is true then D_E_B_U_G = true
      init(@, density, restitution, friction)
    absolute_elements = @bodysnatch()
    createDOMObjects(absolute_elements, shape, static_, density, restitution, friction)
    #console.log(@)
    #console.log(absolute_elements)
    return $(absolute_elements)
    #@each (i, el) =>
    #  $el = $(el)
    #@
    #$(this).each (i, el) ->
    #  self.init el, opts
    #  self.log el if opts.log

$.extend $.fn.physics,
  default_options:
    'x-velocity': 0
    'y-velocity': 0
    'density': default_density
    'restitution': default_restitution
    'friction': default_friction 
    'static': default_static
    'shape': default_shape
    'debug': D_E_B_U_G
    


 

