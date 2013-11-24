(function() {
  $.fn.extend({
    box2d: function(options) {
      var D_E_B_U_G, absolute_elements, areas, debug, density, friction, opts, restitution, self, shape, static_, x_velocity, y_velocity;
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
      areas = opts['area-detection'] || [];
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
      'area-detection': [],
      'density': default_density,
      'restitution': default_restitution,
      'friction': default_friction,
      'static': default_static,
      'shape': default_shape,
      'debug': D_E_B_U_G
    }
  });

}).call(this);
