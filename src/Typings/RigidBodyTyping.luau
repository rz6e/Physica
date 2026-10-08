const Matrix3Typing = require "../Typings/Matrix3Typing"
const ColliderTyping = require "../Typings/ColliderTyping"


export type RigidBodyVars = {
	Mass: number,
	InverseMass: number,
	
	LocalInverseInertiaTensor: Matrix3Typing.Matrix3,
	GlobalInverseInertiaTensor: Matrix3Typing.Matrix3,
	
	LocalCentroid: Vector3,
	GlobalCentroid: Vector3,
	
	Position: Vector3,
	Orientation: Matrix3Typing.Matrix3,
	LinearVelocity: Vector3,
	AngularVelocity: Vector3,
	
	ForceAccumulator: Vector3,
	TorqueAccumulator: Vector3,
	
	Colliders: {ColliderTyping.Collider},
}

export type RigidBodyMethods = {
	read AddCollider: (self: RigidBody, ColliderTyping.Collider) -> (),
    read ApplyForce: (self: RigidBody, Force: Vector3, At: Vector3) -> (),
}

export type RigidBodyMetatable = {
    read __index: RigidBodyMethods,
}

export type RigidBody = RigidBodyVars & RigidBodyMethods

return {}