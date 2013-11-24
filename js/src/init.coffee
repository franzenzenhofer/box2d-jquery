b2Vec2 = Box2D.Common.Math.b2Vec2
b2AABB = Box2D.Collision.b2AABB
b2BodyDef = Box2D.Dynamics.b2BodyDef
b2Body = Box2D.Dynamics.b2Body
b2FixtureDef = Box2D.Dynamics.b2FixtureDef
b2Fixture = Box2D.Dynamics.b2Fixture
b2World = Box2D.Dynamics.b2World
b2MassData = Box2D.Collision.Shapes.b2MassData
b2PolygonShape = Box2D.Collision.Shapes.b2PolygonShape
b2CircleShape = Box2D.Collision.Shapes.b2CircleShape
b2ContactListener = Box2D.Dynamics.b2ContactListener
b2DebugDraw = Box2D.Dynamics.b2DebugDraw
b2RevoluteJointDef = Box2D.Dynamics.Joints.b2RevoluteJointDef
b2MouseJointDef =  Box2D.Dynamics.Joints.b2MouseJointDef
$ = jQuery


hw = {
  '-webkit-transform': 'translateZ(0)'
  '-moz-transform': 'translateZ(0)'
  '-o-transform': 'translateZ(0)'
  'transform': 'translateZ(0)'  
}

S_T_A_R_T_E_D = false
D_E_B_U_G = false
world = {}
x_velocity = 0
y_velocity = 0
SCALE = 30
D2R = Math.PI / 180
R2D = 180 / Math.PI
PI2 = Math.PI*2
interval = {}
default_static = false
default_density = 1.5
default_friction = 0.3
default_restitution = 0.4
default_shape = 'box'
default_passive = false
#static_ = default_static, density = default_density, restitution = default_restitution, friction=default_friction 

mouseX = 0
mouseY = 0
mousePVec = undefined
isMouseDown = false
selectedBody = undefined
mouseJoint = undefined


MutationObserver = window.MutationObserver || window.WebKitMutationObserver || window.MozMutationObserver;
mutationObserver = undefined
mutationConfig = 
  attributes: false
  childList: true
  characterData: false
bodySet = {}
bodyKey = 0;
areas = []
graveyard = []
time0 = 0
fpsEl = undefined