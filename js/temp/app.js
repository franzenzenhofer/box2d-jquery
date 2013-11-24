(function() {
  var applyCustomGravity, areaDetection, cleanGraveyard, drawDOMObjects, measureTime, mutationHandler, startWorld, update;

  drawDOMObjects = function() {
    var b, css, domObj, f, i, r, translate_values, x, y, _results;
    i = 0;
    b = world.m_bodyList;
    _results = [];
    while (b) {
      f = b.m_fixtureList;
      while (f) {
        if (f.m_userData) {
          domObj = f.m_userData.domObj;
          x = Math.floor((f.m_body.m_xf.position.x * SCALE) - f.m_userData.width) + 'px';
          y = Math.floor((f.m_body.m_xf.position.y * SCALE) - f.m_userData.height) + 'px';
          r = Math.round(((f.m_body.m_sweep.a + PI2) % PI2) * R2D * 100) / 100;
          translate_values = ["translateX(", x, ') translateY(', y, ')'].join('');
          translate_values += " rotate(" + r + "deg)";
          css = {
            "-webkit-transform": translate_values,
            "-moz-transform": translate_values,
            "-ms-transform": translate_values,
            "-o-transform": translate_values,
            "transform": translate_values
          };
          f.m_userData.domObj.css(css);
        }
        f = f.m_next;
      }
      _results.push(b = b.m_next);
    }
    return _results;
  };

  applyCustomGravity = function() {
    var b, f, force, _results;
    b = world.m_bodyList;
    _results = [];
    while (b) {
      f = b.m_fixtureList;
      while (f) {
        if (f.m_userData && f.m_userData.gravity) {
          force = f.GetUserData().gravity;
          f.GetBody().ApplyForce(force, f.GetBody().GetWorldCenter());
        }
        f = f.m_next;
      }
      _results.push(b = b.m_next);
    }
    return _results;
  };

  areaDetection = (function() {
    var _elementsInArea;
    _elementsInArea = [];
    return function() {
      var aabb, area, elements, i, joined, left, shape, shapes, _i, _j, _len, _len1, _results;
      _results = [];
      for (i = _i = 0, _len = areas.length; _i < _len; i = ++_i) {
        area = areas[i];
        if (!_elementsInArea[i]) {
          _elementsInArea[i] = [];
        }
        aabb = new b2AABB();
        aabb.lowerBound = new b2Vec2(area[0] / SCALE, area[1] / SCALE);
        aabb.upperBound = new b2Vec2(area[2] / SCALE, area[3] / SCALE);
        shapes = [];
        world.QueryAABB(function(shape) {
          shapes.push(shape);
          return true;
        }, aabb);
        elements = [];
        for (_j = 0, _len1 = shapes.length; _j < _len1; _j++) {
          shape = shapes[_j];
          if (shape.GetUserData()) {
            elements.push(shape.GetUserData().domObj);
          }
        }
        joined = $(elements).not(_elementsInArea[i]);
        left = $(_elementsInArea[i]).not(elements);
        _elementsInArea[i] = elements;
        if (joined.length !== 0) {
          _results.push($(document).trigger('areajoined', {
            areaIndex: i,
            joinedEl: joined,
            areaElements: _elementsInArea[i]
          }));
        } else {
          if (left.length !== 0) {
            _results.push($(document).trigger('arealeft', {
              areaIndex: i,
              leftEl: left,
              areaElements: _elementsInArea[i]
            }));
          } else {
            _results.push(void 0);
          }
        }
      }
      return _results;
    };
  })();

  measureTime = function() {
    var fps, now, time0;
    now = (window['performance'] && performance.now()) || +(new Date);
    fps = 1000 / (now - time0);
    fpsEl.text((fps >> 0) + ' fps');
    return time0 = now;
  };

  update = function() {
    cleanGraveyard();
    DragHandler.updateMouseDrag();
    applyCustomGravity();
    if (areas.length > 0) {
      areaDetection();
    }
    world.Step(2 / 60, 8, 3);
    drawDOMObjects();
    if (D_E_B_U_G) {
      world.DrawDebugData();
      measureTime();
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
    var S_T_A_R_T_E_D, canvas, contactListener, debugDraw, fpsEl, h, mutationObserver, w, world;
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
    world = new b2World(new b2Vec2(x_velocity, y_velocity), false);
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
      fpsEl = $('<div style="position:absolute;bottom:0;right:0;background:red;padding:5px;">0</div>');
      $('body').append(canvas).append(fpsEl);
    }
    return update();
  };

}).call(this);
