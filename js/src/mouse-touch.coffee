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