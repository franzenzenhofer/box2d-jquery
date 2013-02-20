(function() {
  var createBox, createCircle, createDOMObjects;

  createDOMObjects = function(jquery_selector, shape, static_, density, restitution, friction) {
    if (shape == null) {
      shape = default_shape;
    }
    if (static_ == null) {
      static_ = default_static;
    }
    if (density == null) {
      density = default_density;
    }
    if (restitution == null) {
      restitution = default_restitution;
    }
    if (friction == null) {
      friction = default_friction;
    }
    return $(jquery_selector).each(function(a, b) {
      var body, domObj, domPos, full_height, full_width, height, make_density, make_friction, make_restitution, make_shape, make_static, origin_values, r, width, x, y;
      domObj = $(b);
      full_width = domObj.width();
      full_height = domObj.height();
      if (!(full_width && full_height)) {
        if (domObj.attr('src')) {
          if (typeof console !== "undefined" && console !== null) {
            console.log(' - box2d-jquery ERROR: an element withour width or height, will lead to strangeness!');
          }
          domObj.on('load', function() {
            return createDOMObjects(this, shape, static_, density, restitution, friction);
          });
        }
        return true;
      }
      domPos = $(b).position();
      width = full_width / 2;
      height = full_height / 2;
      x = domPos.left + width;
      y = domPos.top + height;
      make_shape = (domObj.attr('box2d-shape') ? domObj.attr('box2d-shape') : shape);
      make_density = parseFloat((domObj.attr('box2d-density') ? domObj.attr('box2d-density') : density));
      make_restitution = parseFloat((domObj.attr('box2d-restitution') ? domObj.attr('box2d-restitution') : restitution));
      make_friction = parseFloat((domObj.attr('box2d-friction') ? domObj.attr('box2d-friction') : friction));
      if (domObj.attr('box2d-static') === "true") {
        make_static = true;
      } else if (domObj.attr('box2d-static') === "false") {
        make_static = false;
      } else {
        make_static = static_;
      }
      if (make_shape && make_shape !== 'circle') {
        body = createBox(x, y, width, height, make_static, make_density, make_restitution, make_friction);
      } else {
        r = (width > height ? width : height);
        body = createCircle(x, y, r, make_static, make_density, make_restitution, make_friction);
      }
      body.m_userData = {
        domObj: domObj,
        width: width,
        height: height
      };
      origin_values = '50% 50% 0';
      domObj.css({
        "-webkit-transform-origin": origin_values,
        "-moz-transform-origin": origin_values,
        "-ms-transform-origin": origin_values,
        "-o-transform-origin": origin_values,
        "transform-origin": origin_values
      });
      return true;
    });
  };

  createBox = function(x, y, width, height, static_, density, restitution, friction) {
    var bodyDef, fixDef;
    if (static_ == null) {
      static_ = default_static;
    }
    if (density == null) {
      density = default_density;
    }
    if (restitution == null) {
      restitution = default_restitution;
    }
    if (friction == null) {
      friction = default_friction;
    }
    bodyDef = new b2BodyDef;
    bodyDef.type = (static_ ? b2Body.b2_staticBody : b2Body.b2_dynamicBody);
    bodyDef.position.x = x / SCALE;
    bodyDef.position.y = y / SCALE;
    fixDef = new b2FixtureDef;
    fixDef.density = density;
    fixDef.friction = friction;
    fixDef.restitution = restitution;
    fixDef.shape = new b2PolygonShape;
    fixDef.shape.SetAsBox(width / SCALE, height / SCALE);
    return world.CreateBody(bodyDef).CreateFixture(fixDef);
  };

  createCircle = function(x, y, r, static_, density, restitution, friction) {
    var bodyDef, fixDef;
    if (static_ == null) {
      static_ = default_static;
    }
    if (density == null) {
      density = default_density;
    }
    if (restitution == null) {
      restitution = default_restitution;
    }
    if (friction == null) {
      friction = default_friction;
    }
    bodyDef = new b2BodyDef;
    bodyDef.type = (static_ ? b2Body.b2_staticBody : b2Body.b2_dynamicBody);
    bodyDef.position.x = x / SCALE;
    bodyDef.position.y = y / SCALE;
    fixDef = new b2FixtureDef;
    fixDef.density = density;
    fixDef.friction = friction;
    fixDef.restitution = restitution;
    fixDef.shape = new b2CircleShape(r / SCALE);
    return world.CreateBody(bodyDef).CreateFixture(fixDef);
  };

  /*
  
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
  */


}).call(this);
