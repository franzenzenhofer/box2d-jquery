# /*! box2d-jquery - v0.8.0 - last build: 2013-11-24 23:27:02 */
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
b2ContactListener = Box2D.Dynamics.b2ContactListener
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
default_passive = false
#static_ = default_static, density = default_density, restitution = default_restitution, friction=default_friction 

mouseX = 0
mouseY = 0
mousePVec = undefined
isMouseDown = false
selectedBody = undefined
mouseJoint = undefined


MutationObserver = window.MutationObserver || window.WebKitMutationObserver || window.MozMutationObserver;
mutationObserver = undefined
mutationConfig = 
  attributes: false
  childList: true
  characterData: false
bodySet = {}
bodyKey = 0;
areas = []
graveyard = []
time0 = 0
fpsEl = undefined
DragHandler = do ->
  selectedBody = undefined
  mouseJoint = false
  mouseX = undefined
  mouseY = undefined

  upHandler = ->
    if selectedBody
        mouseX = null
        mouseY = null
        selectedBody = null
  moveHandler = (e) ->
    if selectedBody
      updateFromEvent e

  downHandler = (domEl, e) ->
    fixture = bodySet[domEl.attr('data-box2d-bodykey')]
    unless fixture.GetUserData().isPassive
      selectedBody = fixture.GetBody()
      updateFromEvent e

  # initialize up and movehandler on document
  $(document).mouseup upHandler 
  $(document).mousemove moveHandler

  updateFromEvent = (e) ->
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

    mouseX = mouseX / 30
    mouseY = mouseY / 30

  return {
    register: (domEl) ->
      domEl.mousedown (e) ->
        downHandler domEl, e 
      domEl.bind 'touchstart', (e) ->
        downHandler domEl, e
      domEl.bind 'touchend', upHandler
      domEl.bind 'touchmove', moveHandler

    updateMouseDrag: ->
      if selectedBody and (not mouseJoint)
        md = new b2MouseJointDef()
        md.bodyA = world.GetGroundBody()
        md.bodyB = selectedBody
        md.target.Set mouseX, mouseY
        md.collideConnected = true
        md.maxForce = 300.0 * selectedBody.GetMass()
        mouseJoint = world.CreateJoint(md)
        selectedBody.SetAwake true

      if mouseJoint
        if selectedBody
          mouseJoint.SetTarget new b2Vec2(mouseX, mouseY)
        else
          world.DestroyJoint mouseJoint
          mouseJoint = null
  }

createDOMObjects = (jquery_selector, shape = default_shape, static_ = default_static, density = default_density, restitution = default_restitution, friction=default_friction, passive = default_passive) ->
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
        console?.log(' - box2d-jquery ERROR: an element withour width or height, will lead to strangeness!')
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

    #if domObj.attr('data-box2d-shape')
    #  make_shape = domObj.attr('data-box2d-shape')
    #else
    #  make_shape = shape
    make_shape = (if domObj.attr('data-box2d-shape') then domObj.attr('data-box2d-shape') else shape)
    #TODO TEST
    make_density = parseFloat((if domObj.attr('data-box2d-density') then domObj.attr('data-box2d-density') else density))
    #TODO TEST
    make_restitution = parseFloat((if domObj.attr('data-box2d-restitution') then domObj.attr('data-box2d-restitution') else restitution))
    #TODO TEST
    make_friction = parseFloat((if domObj.attr('data-box2d-friction') then domObj.attr('data-box2d-friction') else friction))
    #TODO TEST
    if domObj.attr('data-box2d-static') is "true"
      make_static = true 
    else if domObj.attr('data-box2d-static') is "false"
      make_static = false
    else 
      make_static = static_ 

    if domObj.attr('data-box2d-passive') is "true"
      make_passive = true
    else if domObj.attr('data-box2d-passive') is "false"
      make_passive = false
    else
      make_passive = passive

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
      isPassive: make_passive
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

    # set an id to domObj for list identification
    domObj.attr('data-box2d-bodykey', bodyKey);
    # make it draggable
    DragHandler.register(domObj);
    bodySet[bodyKey] = body;
    bodyKey++;
    return true

#throws a DOM object as 
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
        domObj = f.m_userData.domObj

        #Retrieve positions and rotations from the Box2d world
        x = Math.floor((f.m_body.m_xf.position.x * SCALE) - f.m_userData.width) + 'px'
        y = Math.floor((f.m_body.m_xf.position.y * SCALE) - f.m_userData.height) + 'px'
        
        #CSS3 transform does not like negative values or infitate decimals
        r = Math.round(((f.m_body.m_sweep.a + PI2) % PI2) * R2D * 100) / 100
        #translate_values = "translate(" + x + "px," + y + "px) rotate(" + r + "deg)"
        translate_values = ["translateX(", x, ') translateY(', y, ')'].join('')
        translate_values += " rotate(" + r + "deg)"
        
        css = 
          "-webkit-transform": translate_values 
          "-moz-transform": translate_values 
          "-ms-transform": translate_values 
          "-o-transform": translate_values 
          "transform": translate_values  

        f.m_userData.domObj.css css
      f = f.m_next
    b = b.m_next
applyCustomGravity = ->
  b = world.m_bodyList
  while b
    f = b.m_fixtureList
    while f
      if f.m_userData and f.m_userData.gravity 
        force = f.GetUserData().gravity
        f.GetBody().ApplyForce(force, f.GetBody().GetWorldCenter())
      f = f.m_next
    b = b.m_next



areaDetection = do ->
  _elementsInArea = []
  return ->
    for area, i in areas
      _elementsInArea[i] = [] unless _elementsInArea[i]
      aabb = new b2AABB();

      # * 0.02 because it has to be converted from pixels to metre
      aabb.lowerBound = new b2Vec2(area[0]/SCALE, area[1]/SCALE)
      aabb.upperBound = new b2Vec2(area[2]/SCALE, area[3]/SCALE)

      shapes = []
      world.QueryAABB( (shape) ->
        shapes.push shape
        true
      , aabb)
      elements = []

      for shape in shapes
        elements.push shape.GetUserData().domObj if shape.GetUserData()

      joined = $(elements).not(_elementsInArea[i])
      left = $(_elementsInArea[i]).not(elements)

      _elementsInArea[i] = elements

      unless joined.length is 0

        $(document).trigger('areajoined', {
          areaIndex: i,
          joinedEl: joined
          areaElements: _elementsInArea[i]
        })
      else
        unless left.length is 0
          $(document).trigger('arealeft', {
            areaIndex: i,
            leftEl: left,
            areaElements: _elementsInArea[i]
          })

      
measureTime = ->
  now = (window['performance'] && performance.now()) || +new Date
  fps = 1000/(now - time0)
  fpsEl.text((fps >> 0)+ ' fps');
  time0 = now


update = ->
  cleanGraveyard()
  DragHandler.updateMouseDrag()
  
  applyCustomGravity()

  if areas.length > 0
    areaDetection()

  world.Step 2 / 60, 8, 3 
  drawDOMObjects()
  if D_E_B_U_G
    world.DrawDebugData()
    measureTime()
  world.ClearForces()
  
  window.setTimeout(update, 1000 / 30)

mutationHandler = (mutations) ->
  mutations.forEach (mutation) ->
    if mutation.removedNodes.length > 0
      for node in mutation.removedNodes
        do (node) ->
          index = $(node).attr('data-box2d-bodykey')
          if bodySet[index]?
            graveyard.push([index, bodySet[index]])

cleanGraveyard = ->
  while graveyard.length > 0
    zombie = graveyard.pop()
    zombie[1].GetBody().SetUserData(null)
    world.DestroyBody(zombie[1].GetBody())
    delete bodySet[zombie[0]]

startWorld = (jquery_selector, density = default_density, restitution = default_restitution, friction=default_friction) ->
  S_T_A_R_T_E_D = true
  world = new b2World(
    new b2Vec2(x_velocity,y_velocity),
    # setting the world not asleep in order to ensure gravity changes affect the world immediately
    false
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

  # listen for collisions
  contactListener = new b2ContactListener
  contactListener.BeginContact = (contact) ->
    node0 = contact.GetFixtureA().GetUserData()?.domObj
    node1 = contact.GetFixtureB().GetUserData()?.domObj 
    # if node1 is not set it's a collision with the world's boundaries
    if node0? and node1?
      node0.trigger('collisionStart', node1);
    

  contactListener.EndContact = (contact) ->
    node0 = contact.GetFixtureA().GetUserData()?.domObj
    node1 = contact.GetFixtureB().GetUserData()?.domObj
    # if node1 is not set it's a collision with the world's boundaries
    if node0? and node1?
      node0.trigger('collisionEnd', node1);

  world.SetContactListener(contactListener);

  # observe mutations
  mutationObserver = new MutationObserver(mutationHandler);
  mutationObserver.observe(document.body, mutationConfig)

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
    fpsEl = $('<div style="position:absolute;bottom:0;right:0;background:red;padding:5px;">0</div>');
    $('body').append(canvas).append(fpsEl)



  #trigger hardware acclearation
  #$('body').css(hw);
   
  update();
  
#startWorld("#container div, img")
#startWorld("h1")
#canvasPosition = getElementPosition(document.getElementById("canvas"))



 


$.Physics = do ->
  getFixtureFromEl = (el) ->
    bodyKey = el.attr('data-box2d-bodykey')
    return bodySet[bodyKey]
  getBodyFromEl = (el) ->
    fixture = getFixtureFromEl(el)
    return  fixture && fixture.GetBody()
  getVectorFromForceInput = (force) ->
    force = $.extend {}, { x: 0, y: 0}, force
    return new b2Vec2(force.x, force.y)

  return {
    applyForce: (el, force) ->
      body = getBodyFromEl(el)
      body.ApplyForce(getVectorFromForceInput(force), body.GetWorldCenter())

    applyImpulse: (el, force) ->
      body = getBodyFromEl(el)
      body.ApplyImpulse(getVectorFromForceInput(force), body.GetWorldCenter())

    setWorldGravity: (force) ->
      world.SetGravity(new b2Vec2(force['x-velocity'], force['y-velocity']));
    setElementGravity: (el, force) ->
      fixture = getFixtureFromEl(el)
      fixture.m_userData.gravity = getVectorFromForceInput(force)
  }

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
    areas = opts['area-detection'] || []

    if S_T_A_R_T_E_D is false
      if debug is true then D_E_B_U_G = true
      startWorld(@, density, restitution, friction)
    absolute_elements = @bodysnatch()
    createDOMObjects(absolute_elements, shape, static_, density, restitution, friction)
    #console.log(@)
    #console.log(absolute_elements)
    return $(absolute_elements)
    #@each (i, el) =>
    #  $el = $(el)
    #@
    #$(this).each (i, el) ->
    #  self.startWorld el, opts
    #  self.log el if opts.log

$.extend $.Physics,
  default_options:
    'x-velocity': 0
    'y-velocity': 0
    'area-detection': []
    'density': default_density
    'restitution': default_restitution
    'friction': default_friction 
    'static': default_static
    'shape': default_shape
    'debug': D_E_B_U_G
    
