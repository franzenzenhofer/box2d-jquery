(function() {
  $.Physics = (function() {
    var getBodyFromEl, getVectorFromForceInput;
    getBodyFromEl = function(el) {
      var bodyKey;
      bodyKey = el.attr('data-box2d-bodykey');
      return bodySet[bodyKey] && bodySet[bodyKey].GetBody();
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
      }
    };
  })();

}).call(this);
