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
