(function() {
  var MouseAndTouch, downHandler, getBodyAtMouse, getBodyCB, getElementPosition, moveHandler, upHandler, updateMouseDrag;

  MouseAndTouch = function(dom, down, up, move) {
    var canvas, isDown, mouseDownHandler, mouseMoveHandler, mouseUpHandler, mouseX, mouseY, ret, startX, startY, touchDownHandler, touchUpHandler, updateFromEvent;
    canvas = dom;
    mouseX = void 0;
    mouseY = void 0;
    startX = void 0;
    startY = void 0;
    isDown = false;
    mouseMoveHandler = function(e) {
      updateFromEvent(e);
      return move(mouseX, mouseY);
    };
    updateFromEvent = function(e) {
      var touch;
      e.preventDefault();
      touch = e.originalEvent;
      if (touch && touch.touches && touch.touches.length === 1) {
        touch.preventDefault();
        mouseX = touch.touches[0].pageX;
        return mouseY = touch.touches[0].pageY;
      } else {
        mouseX = e.pageX;
        return mouseY = e.pageY;
      }
    };
    mouseUpHandler = function(e) {
      canvas.addEventListener("mousedown", mouseDownHandler, true);
      canvas.removeEventListener("mousemove", mouseMoveHandler, true);
      isDown = false;
      updateFromEvent(e);
      return up(mouseX, mouseY);
    };
    touchUpHandler = function(e) {
      canvas.addEventListener("touchstart", touchDownHandler, true);
      canvas.removeEventListener("touchmove", mouseMoveHandler, true);
      isDown = false;
      updateFromEvent(e);
      return up(mouseX, mouseY);
    };
    mouseDownHandler = function(e) {
      canvas.removeEventListener("mousedown", mouseDownHandler, true);
      canvas.addEventListener("mouseup", mouseUpHandler, true);
      canvas.addEventListener("mousemove", mouseMoveHandler, true);
      isDown = true;
      updateFromEvent(e);
      return down(mouseX, mouseY);
    };
    touchDownHandler = function(e) {
      canvas.removeEventListener("touchstart", touchDownHandler, true);
      canvas.addEventListener("touchend", touchUpHandler, true);
      canvas.addEventListener("touchmove", mouseMoveHandler, true);
      isDown = true;
      updateFromEvent(e);
      return down(mouseX, mouseY);
    };
    canvas.addEventListener("mousedown", mouseDownHandler, true);
    canvas.addEventListener("touchstart", touchDownHandler, true);
    ret = {};
    ret.mouseX = function() {
      return mouseX;
    };
    ret.mouseY = function() {
      return mouseY;
    };
    ret.isDown = function() {
      return isDown;
    };
    return ret;
  };

  downHandler = function(x, y) {
    var isMouseDown;
    isMouseDown = true;
    return moveHandler(x, y);
  };

  upHandler = function(x, y) {
    var isMouseDown, mouseX, mouseY;
    isMouseDown = false;
    mouseX = null;
    return mouseY = null;
  };

  moveHandler = function(x, y) {
    var mouseX, mouseY;
    mouseX = x / 30;
    return mouseY = y / 30;
  };

  getBodyAtMouse = function() {
    var aabb, mousePVec, selectedBody;
    mousePVec = new b2Vec2(mouseX, mouseY);
    aabb = new b2AABB();
    aabb.lowerBound.Set(mouseX - 0.001, mouseY - 0.001);
    aabb.upperBound.Set(mouseX + 0.001, mouseY + 0.001);
    selectedBody = null;
    world.QueryAABB(getBodyCB, aabb);
    return selectedBody;
  };

  getBodyCB = function(fixture) {
    var selectedBody;
    if (fixture.GetBody().GetType() !== b2Body.b2_staticBody) {
      if (fixture.GetShape().TestPoint(fixture.GetBody().GetTransform(), mousePVec)) {
        selectedBody = fixture.GetBody();
        return false;
      }
    }
    return true;
  };

  getElementPosition = function(element) {
    var elem, tagname, x, y;
    elem = element;
    tagname = "";
    x = 0;
    y = 0;
    while ((typeof elem === "object") && (typeof elem.tagName !== "undefined")) {
      y += elem.offsetTop;
      x += elem.offsetLeft;
      tagname = elem.tagName.toUpperCase();
      if (tagname === "BODY") {
        elem = 0;
      }
      if (typeof elem === "object" ? typeof elem.offsetParent === "object" : void 0) {
        elem = elem.offsetParent;
      }
    }
    return {
      x: x,
      y: y
    };
  };

  updateMouseDrag = function() {
    var body, md, mouseJoint;
    if (isMouseDown && (!mouseJoint)) {
      body = getBodyAtMouse();
      if (body) {
        md = new b2MouseJointDef();
        md.bodyA = world.GetGroundBody();
        md.bodyB = body;
        md.target.Set(mouseX, mouseY);
        md.collideConnected = true;
        md.maxForce = 300.0 * body.GetMass();
        mouseJoint = world.CreateJoint(md);
        body.SetAwake(true);
      }
    }
    if (mouseJoint) {
      if (isMouseDown) {
        return mouseJoint.SetTarget(new b2Vec2(mouseX, mouseY));
      } else {
        world.DestroyJoint(mouseJoint);
        return mouseJoint = null;
      }
    }
  };

}).call(this);
