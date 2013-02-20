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
