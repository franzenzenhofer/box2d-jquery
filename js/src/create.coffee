
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