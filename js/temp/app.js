(function() {
  var drawDOMObjects, startWorld, update;

  drawDOMObjects = function() {
    var b, css, f, i, r, translate_values, x, y, _results;
    i = 0;
    b = world.m_bodyList;
    _results = [];
    while (b) {
      f = b.m_fixtureList;
      while (f) {
        if (f.m_userData) {
          x = Math.floor((f.m_body.m_xf.position.x * SCALE) - f.m_userData.width);
          y = Math.floor((f.m_body.m_xf.position.y * SCALE) - f.m_userData.height);
          r = Math.round(((f.m_body.m_sweep.a + PI2) % PI2) * R2D * 100) / 100;
          translate_values = "rotate(" + r + "deg)";
          css = {
            "-webkit-transform": translate_values,
            "-moz-transform": translate_values,
            "-ms-transform": translate_values,
            "-o-transform": translate_values,
            "transform": translate_values,
            "left": x + "px",
            "top": y + "px"
          };
          f.m_userData.domObj.css(css);
        }
        f = f.m_next;
      }
      _results.push(b = b.m_next);
    }
    return _results;
  };

  update = function() {
    updateMouseDrag();
    world.Step(2 / 60, 8, 3);
    drawDOMObjects();
    if (D_E_B_U_G) {
      world.DrawDebugData();
    }
    world.ClearForces();
    return window.setTimeout(update, 1000 / 30);
  };

  startWorld = function(jquery_selector, density, restitution, friction) {
    var S_T_A_R_T_E_D, canvas, contactListener, debugDraw, h, mouse, w, world;
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
    mouse = MouseAndTouch(document, downHandler, upHandler, moveHandler);
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

}).call(this);
