$.Physics = do ->
  getBodyFromEl = (el) ->
    bodyKey = el.attr('data-box2d-bodykey')
    return bodySet[bodyKey] && bodySet[bodyKey].GetBody()
  getVectorFromForceInput = (force) ->
    force = $.extend {}, { x: 0, y: 0}, force
    return new b2Vec2(force.x, force.y)

  return {
    applyForce: (force, el) ->
      body = getBodyFromEl(el)
      body.ApplyForce(getVectorFromForceInput(force), body.GetWorldCenter())

    applyImpulse: (force, el) ->
      body = getBodyFromEl(el)
      body.ApplyImpulse(getVectorFromForceInput(force), body.GetWorldCenter())
  }
