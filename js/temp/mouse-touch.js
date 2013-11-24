(function() {
  var DragHandler;

  DragHandler = (function() {
    var downHandler, mouseJoint, mouseX, mouseY, moveHandler, selectedBody, upHandler, updateFromEvent;
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
      var fixture;
      fixture = bodySet[domEl.attr('data-box2d-bodykey')];
      if (!fixture.GetUserData().isPassive) {
        selectedBody = fixture.GetBody();
        return updateFromEvent(e);
      }
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

}).call(this);
