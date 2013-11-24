$.fn.extend
  box2d: (options) ->
    self = $.fn.box2d
    opts = $.extend {}, self.default_options, options
    x_velocity = opts['x-velocity']
    y_velocity = opts['y-velocity']
    density = opts['density']
    restitution = opts['restitution']
    friction= opts['friction']
    shape = opts['shape']
    static_ = opts['static']
    debug = opts['debug']
    areas = opts['area-detection'] || []

    if S_T_A_R_T_E_D is false
      if debug is true then D_E_B_U_G = true
      startWorld(@, density, restitution, friction)
    absolute_elements = @bodysnatch()
    createDOMObjects(absolute_elements, shape, static_, density, restitution, friction)
    #console.log(@)
    #console.log(absolute_elements)
    return $(absolute_elements)
    #@each (i, el) =>
    #  $el = $(el)
    #@
    #$(this).each (i, el) ->
    #  self.startWorld el, opts
    #  self.log el if opts.log

$.extend $.Physics,
  default_options:
    'x-velocity': 0
    'y-velocity': 0
    'area-detection': []
    'density': default_density
    'restitution': default_restitution
    'friction': default_friction 
    'static': default_static
    'shape': default_shape
    'debug': D_E_B_U_G
    
