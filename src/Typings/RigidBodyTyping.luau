const Matrix3Typing = require "../Typings/Matrix3Typing"
const ColliderTyping = require "../Typings/ColliderTyping"

export type RigidBodyVars = {
	Mass: number,
	InverseMass: number,
	
	LocalInverseInertiaTensor: Matrix3Typing.Matrix3,
	GlobalInverseInertiaTensor: Matrix3Typing.Matrix3,
	
	LocalCentroid: vector,
	GlobalCentroid: vector,
	
	Position: vector,
	Orientation: Matrix3Typing.Matrix3,
	LinearVelocity: vector,
	AngularVelocity: vector,
	
	ForceAccumulator: vector,
	TorqueAccumulator: vector,
	
	Colliders: {ColliderTyping.Collider},
}

export type RigidBodyMethods = {
	read AddCollider: (self: RigidBody, ColliderTyping.Collider) -> (),
    read ApplyForce: (self: RigidBody, Force: vector, At: vector) -> (),
}

export type RigidBodyMetatable = {
    read __index: RigidBodyMethods,
}

export type RigidBody = RigidBodyVars & RigidBodyMethods

return {}