(function() {
  $.Physics = (function() {
    var getBodyFromEl, getFixtureFromEl, getVectorFromForceInput;
    getFixtureFromEl = function(el) {
      var bodyKey;
      bodyKey = el.attr('data-box2d-bodykey');
      return bodySet[bodyKey];
    };
    getBodyFromEl = function(el) {
      var fixture;
      fixture = getFixtureFromEl(el);
      return fixture && fixture.GetBody();
    };
    getVectorFromForceInput = function(force) {
      force = $.extend({}, {
        x: 0,
        y: 0
      }, force);
      return new b2Vec2(force.x, force.y);
    };
    return {
      applyForce: function(el, force) {
        var body;
        body = getBodyFromEl(el);
        return body.ApplyForce(getVectorFromForceInput(force), body.GetWorldCenter());
      },
      applyImpulse: function(el, force) {
        var body;
        body = getBodyFromEl(el);
        return body.ApplyImpulse(getVectorFromForceInput(force), body.GetWorldCenter());
      },
      setWorldGravity: function(force) {
        return world.SetGravity(new b2Vec2(force['x-velocity'], force['y-velocity']));
      },
      setElementGravity: function(el, force) {
        var fixture;
        fixture = getFixtureFromEl(el);
        return fixture.m_userData.gravity = getVectorFromForceInput(force);
      }
    };
  })();

}).call(this);
