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
  #world.Step 1 / 60, 10, 10 #position iterations
  world.Step 2 / 60, 8, 3 
  drawDOMObjects()
  if D_E_B_U_G
    world.DrawDebugData()
  world.ClearForces()
  #update()
  #requestAnimationFrame(update);
  window.setTimeout(update, 1000 / 30)


startWorld = (jquery_selector, density = default_density, restitution = default_restitution, friction=default_friction) ->
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
  
#startWorld("#container div, img")
#startWorld("h1")
#canvasPosition = getElementPosition(document.getElementById("canvas"))



 

