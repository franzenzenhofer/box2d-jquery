(function() {
  var $, D2R, D_E_B_U_G, MutationObserver, PI2, R2D, SCALE, S_T_A_R_T_E_D, areas, b2AABB, b2Body, b2BodyDef, b2CircleShape, b2ContactListener, b2DebugDraw, b2Fixture, b2FixtureDef, b2MassData, b2MouseJointDef, b2PolygonShape, b2RevoluteJointDef, b2Vec2, b2World, bodyKey, bodySet, default_density, default_friction, default_passive, default_restitution, default_shape, default_static, fpsEl, graveyard, hw, interval, isMouseDown, mouseJoint, mousePVec, mouseX, mouseY, mutationConfig, mutationObserver, selectedBody, time0, world, x_velocity, y_velocity;

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

  areas = [];

  graveyard = [];

  time0 = 0;

  fpsEl = void 0;

}).call(this);
