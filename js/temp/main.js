(function() {
  var $, D2R, D_E_B_U_G, DragHandler, MutationObserver, PI2, R2D, SCALE, S_T_A_R_T_E_D, b2AABB, b2Body, b2BodyDef, b2CircleShape, b2ContactListener, b2DebugDraw, b2Fixture, b2FixtureDef, b2MassData, b2MouseJointDef, b2PolygonShape, b2RevoluteJointDef, b2Vec2, b2World, bodyKey, bodySet, cleanGraveyard, createBox, createCircle, createDOMObjects, default_density, default_friction, default_passive, default_restitution, default_shape, default_static, drawDOMObjects, graveyard, hw, interval, isMouseDown, mouseJoint, mousePVec, mouseX, mouseY, mutationConfig, mutationHandler, mutationObserver, selectedBody, startWorld, update, world, x_velocity, y_velocity;

  b2Vec2 = Box2D.Common.Math.b2Vec2;

  b2AABB = Box2D.Collision.b2AABB;

  b2BodyDef = Box2D.Dynamics.b2BodyDef;

  b2Body = Box2D.Dynamics.b2Body;

  b2FixtureDef = Box2D.Dynamics.b2FixtureDef;

  b2Fixture = Box2D.Dynamics.b2Fixture;

  b2World = Box2D.Dynamics.b2World;

  b2MassData = Box2D.Collision.Shapes.b2MassData;

  b2PolygonShape = Box2D.Collision.Shapes.b2PolygonShape;

  b2CircleShape = Box2D.Collision.Shapes.b2CircleShape;

  b2ContactListener = Box2D.Dynamics.b2ContactListener;

  b2DebugDraw = Box2D.Dynamics.b2DebugDraw;

  b2RevoluteJointDef = Box2D.Dynamics.Joints.b2RevoluteJointDef;

  b2MouseJointDef = Box2D.Dynamics.Joints.b2MouseJointDef;

  $ = jQuery;

  hw = {
    '-webkit-transform': 'translateZ(0)',
    '-moz-transform': 'translateZ(0)',
    '-o-transform': 'translateZ(0)',
    'transform': 'translateZ(0)'
  };

  S_T_A_R_T_E_D = false;

  D_E_B_U_G = false;

  world = {};

  x_velocity = 0;

  y_velocity = 0;

  SCALE = 30;

  D2R = Math.PI / 180;

  R2D = 180 / Math.PI;

  PI2 = Math.PI * 2;

  interval = {};

  default_static = false;

  default_density = 1.5;

  default_friction = 0.3;

  default_restitution = 0.4;

  default_shape = 'box';

  default_passive = false;

  mouseX = 0;

  mouseY = 0;

  mousePVec = void 0;

  isMouseDown = false;

  selectedBody = void 0;

  mouseJoint = void 0;

  MutationObserver = window.MutationObserver || window.WebKitMutationObserver || window.MozMutationObserver;

  mutationObserver = void 0;

  mutationConfig = {
    attributes: false,
    childList: true,
    characterData: false
  };

  bodySet = {};

  bodyKey = 0;

  graveyard = [];

  DragHandler = (function() {
    var downHandler, moveHandler, upHandler, updateFromEvent;
    selectedBody = void 0;
    mouseJoint = false;
    mouseX = void 0;
    mouseY = void 0;
    upHandler = function() {
      if (selectedBody) {
        mouseX = null;
        mouseY = null;
        return selectedBody = null;
      }
    };
    moveHandler = function(e) {
      if (selectedBody) {
        return updateFromEvent(e);
      }
    };
    downHandler = function(domEl, e) {
      selectedBody = bodySet[domEl.attr('data-box2d-bodykey')].GetBody();
      return updateFromEvent(e);
    };
    $(document).mouseup(upHandler);
    $(document).mousemove(moveHandler);
    updateFromEvent = function(e) {
      var touch;
      e.preventDefault();
      touch = e.originalEvent;
      if (touch && touch.touches && touch.touches.length === 1) {
        touch.preventDefault();
        mouseX = touch.touches[0].pageX;
        mouseY = touch.touches[0].pageY;
      } else {
        mouseX = e.pageX;
        mouseY = e.pageY;
      }
      mouseX = mouseX / 30;
      return mouseY = mouseY / 30;
    };
    return {
      register: function(domEl) {
        domEl.mousedown(function(e) {
          return downHandler(domEl, e);
        });
        domEl.bind('touchstart', function(e) {
          return downHandler(domEl, e);
        });
        domEl.bind('touchend', upHandler);
        return domEl.bind('touchmove', moveHandler);
      },
      updateMouseDrag: function() {
        var md;
        if (selectedBody && (!mouseJoint)) {
          md = new b2MouseJointDef();
          md.bodyA = world.GetGroundBody();
          md.bodyB = selectedBody;
          md.target.Set(mouseX, mouseY);
          md.collideConnected = true;
          md.maxForce = 300.0 * selectedBody.GetMass();
          mouseJoint = world.CreateJoint(md);
          selectedBody.SetAwake(true);
        }
        if (mouseJoint) {
          if (selectedBody) {
            return mouseJoint.SetTarget(new b2Vec2(mouseX, mouseY));
          } else {
            world.DestroyJoint(mouseJoint);
            return mouseJoint = null;
          }
        }
      }
    };
  })();

  createDOMObjects = function(jquery_selector, shape, static_, density, restitution, friction, passive) {
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
    if (passive == null) {
      passive = default_passive;
    }
    return $(jquery_selector).each(function(a, b) {
      var body, domObj, domPos, full_height, full_width, height, make_density, make_friction, make_passive, make_restitution, make_shape, make_static, origin_values, r, width, x, y;
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
      make_shape = (domObj.attr('data-box2d-shape') ? domObj.attr('data-box2d-shape') : shape);
      make_density = parseFloat((domObj.attr('data-box2d-density') ? domObj.attr('data-box2d-density') : density));
      make_restitution = parseFloat((domObj.attr('data-box2d-restitution') ? domObj.attr('data-box2d-restitution') : restitution));
      make_friction = parseFloat((domObj.attr('data-box2d-friction') ? domObj.attr('data-box2d-friction') : friction));
      if (domObj.attr('data-box2d-static') === "true") {
        make_static = true;
      } else if (domObj.attr('data-box2d-static') === "false") {
        make_static = false;
      } else {
        make_static = static_;
      }
      if (domObj.attr('data-box2d-passive') === "true") {
        make_passive = true;
      } else if (domObj.attr('data-box2d-passive') === "false") {
        make_passive = false;
      } else {
        make_passive = passive;
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
        height: height,
        isPassive: make_passive
      };
      origin_values = '50% 50% 0';
      domObj.css({
        "-webkit-transform-origin": origin_values,
        "-moz-transform-origin": origin_values,
        "-ms-transform-origin": origin_values,
        "-o-transform-origin": origin_values,
        "transform-origin": origin_values
      });
      domObj.attr('data-box2d-bodykey', bodyKey);
      DragHandler.register(domObj);
      bodySet[bodyKey] = body;
      bodyKey++;
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


  drawDOMObjects = function() {
    var angle, b, css, domObj, f, i, l, lastRotation, lastX, lastY, r, t, translate_values, values, x, y, _results;
    i = 0;
    b = world.m_bodyList;
    _results = [];
    while (b) {
      f = b.m_fixtureList;
      while (f) {
        if (f.m_userData) {
          domObj = f.m_userData.domObj;
          lastX = domObj.css('left');
          lastY = domObj.css('top');
          lastRotation = domObj.css('transform');
          if (lastRotation !== 'none') {
            values = lastRotation.split('(')[1];
            values = values.split(')')[0];
            values = values.split(',');
            t = values[0];
            l = values[1];
            angle = Math.round(Math.atan2(l, t) * (180 / Math.PI));
            lastRotation = angle;
          }
          x = Math.floor((f.m_body.m_xf.position.x * SCALE) - f.m_userData.width) + 'px';
          y = Math.floor((f.m_body.m_xf.position.y * SCALE) - f.m_userData.height) + 'px';
          r = Math.round(((f.m_body.m_sweep.a + PI2) % PI2) * R2D * 100) / 100;
          translate_values = "rotate(" + r + "deg)";
          css = {
            "-webkit-transform": translate_values,
            "-moz-transform": translate_values,
            "-ms-transform": translate_values,
            "-o-transform": translate_values,
            "transform": translate_values,
            "left": x,
            "top": y
          };
          if (!(lastX === x && lastY === y && lastRotation === r)) {
            f.m_userData.domObj.css(css);
          }
        }
        f = f.m_next;
      }
      _results.push(b = b.m_next);
    }
    return _results;
  };

  update = function() {
    cleanGraveyard();
    DragHandler.updateMouseDrag();
    world.Step(2 / 60, 8, 3);
    drawDOMObjects();
    if (D_E_B_U_G) {
      world.DrawDebugData();
    }
    world.ClearForces();
    return window.setTimeout(update, 1000 / 30);
  };

  mutationHandler = function(mutations) {
    return mutations.forEach(function(mutation) {
      var node, _i, _len, _ref, _results;
      if (mutation.removedNodes.length > 0) {
        _ref = mutation.removedNodes;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          node = _ref[_i];
          _results.push((function(node) {
            var index;
            index = $(node).attr('data-box2d-bodykey');
            if (bodySet[index] != null) {
              return graveyard.push([index, bodySet[index]]);
            }
          })(node));
        }
        return _results;
      }
    });
  };

  cleanGraveyard = function() {
    var zombie, _results;
    _results = [];
    while (graveyard.length > 0) {
      zombie = graveyard.pop();
      zombie[1].GetBody().SetUserData(null);
      world.DestroyBody(zombie[1].GetBody());
      _results.push(delete bodySet[zombie[0]]);
    }
    return _results;
  };

  startWorld = function(jquery_selector, density, restitution, friction) {
    var canvas, contactListener, debugDraw, h, w;
    if (density == null) {
      density = default_density;
    }
    if (restitution == null) {
      restitution = default_restitution;
    }
    if (friction == null) {
      friction = default_friction;
    }
    S_T_A_R_T_E_D = true;
    world = new b2World(new b2Vec2(x_velocity, y_velocity), true);
    w = $(window).width();
    h = $(window).height();
    createBox(0, -1, $(window).width(), 1, true, density, restitution, friction);
    createBox($(window).width() + 1, 0, 1, $(window.document).height(), true, density, restitution, friction);
    createBox(-1, 0, 1, $(window.document).height(), true, density, restitution, friction);
    createBox(0, $(window.document).height() + 1, $(window).width(), 1, true, density, restitution, friction);
    contactListener = new b2ContactListener;
    contactListener.BeginContact = function(contact) {
      var node0, node1, _ref, _ref1;
      node0 = (_ref = contact.GetFixtureA().GetUserData()) != null ? _ref.domObj : void 0;
      node1 = (_ref1 = contact.GetFixtureB().GetUserData()) != null ? _ref1.domObj : void 0;
      if ((node0 != null) && (node1 != null)) {
        return node0.trigger('collisionStart', node1);
      }
    };
    contactListener.EndContact = function(contact) {
      var node0, node1, _ref, _ref1;
      node0 = (_ref = contact.GetFixtureA().GetUserData()) != null ? _ref.domObj : void 0;
      node1 = (_ref1 = contact.GetFixtureB().GetUserData()) != null ? _ref1.domObj : void 0;
      if ((node0 != null) && (node1 != null)) {
        return node0.trigger('collisionEnd', node1);
      }
    };
    world.SetContactListener(contactListener);
    mutationObserver = new MutationObserver(mutationHandler);
    mutationObserver.observe(document.body, mutationConfig);
    if (D_E_B_U_G) {
      debugDraw = new b2DebugDraw();
      canvas = $('<canvas></canvas>');
      debugDraw.SetSprite(canvas[0].getContext("2d"));
      debugDraw.SetDrawScale(SCALE);
      debugDraw.SetFillAlpha(0.3);
      debugDraw.SetLineThickness(1.0);
      debugDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);
      canvas.css('position', 'absolute');
      canvas.css('top', 0);
      canvas.css('left', 0);
      canvas.css('border', '1px solid green');
      canvas.attr('width', $(window).width());
      canvas.attr('height', $(document).height());
      world.SetDebugDraw(debugDraw);
      $('body').append(canvas);
    }
    return update();
  };

  $.Physics = (function() {
    var getBodyFromEl, getVectorFromForceInput;
    getBodyFromEl = function(el) {
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
      applyForce: function(force, el) {
        var body;
        body = getBodyFromEl(el);
        return body.ApplyForce(getVectorFromForceInput(force), body.GetWorldCenter());
      },
      applyImpulse: function(force, el) {
        var body;
        body = getBodyFromEl(el);
        return body.ApplyImpulse(getVectorFromForceInput(force), body.GetWorldCenter());
      }
    };
  })();

  $.fn.extend({
    box2d: function(options) {
      var absolute_elements, debug, density, friction, opts, restitution, self, shape, static_;
      self = $.fn.box2d;
      opts = $.extend({}, self.default_options, options);
      x_velocity = opts['x-velocity'];
      y_velocity = opts['y-velocity'];
      density = opts['density'];
      restitution = opts['restitution'];
      friction = opts['friction'];
      shape = opts['shape'];
      static_ = opts['static'];
      debug = opts['debug'];
      if (S_T_A_R_T_E_D === false) {
        if (debug === true) {
          D_E_B_U_G = true;
        }
        startWorld(this, density, restitution, friction);
      }
      absolute_elements = this.bodysnatch();
      createDOMObjects(absolute_elements, shape, static_, density, restitution, friction);
      return $(absolute_elements);
    }
  });

  $.extend($.Physics, {
    default_options: {
      'x-velocity': 0,
      'y-velocity': 0,
      'density': default_density,
      'restitution': default_restitution,
      'friction': default_friction,
      'static': default_static,
      'shape': default_shape,
      'debug': D_E_B_U_G
    }
  });

}).call(this);
