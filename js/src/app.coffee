drawDOMObjects = ->
  i = 0
  b = world.m_bodyList

  while b
    f = b.m_fixtureList

    while f
      if f.m_userData
        domObj = f.m_userData.domObj
        lastX = domObj.css('left')
        lastY = domObj.css('top')
        lastRotation = domObj.css('transform')

        unless lastRotation is 'none'
          values = lastRotation.split('(')[1];
          values = values.split(')')[0];
          values = values.split(',');
          t = values[0];
          l = values[1];


          angle = Math.round(Math.atan2(l, t) * (180/Math.PI))
          lastRotation = angle;

        #Retrieve positions and rotations from the Box2d world
        x = Math.floor((f.m_body.m_xf.position.x * SCALE) - f.m_userData.width) + 'px'
        y = Math.floor((f.m_body.m_xf.position.y * SCALE) - f.m_userData.height) + 'px'
        
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
          "left": x
          "top": y
        unless lastX is x and  lastY is y and lastRotation is r
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

      aabb.lowerBound.Set(area[0], area[1]);
      aabb.upperBound.Set(area[2], area[3]);

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
  world.ClearForces()
  #update()
  #requestAnimationFrame(update);
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
    $('body').append(canvas)

  #trigger hardware acclearation
  #$('body').css(hw);
   
  update();
  
#startWorld("#container div, img")
#startWorld("h1")
#canvasPosition = getElementPosition(document.getElementById("canvas"))



 

