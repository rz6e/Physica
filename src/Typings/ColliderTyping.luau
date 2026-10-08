const Matrix3Typing = require "../Typings/Matrix3Typing"

export type ColliderVars = {
	Mass: number,
	LocalInertiaTensor: Matrix3Typing.Matrix3,
	LocalCentroid: Vector3,
}

export type ColliderMethods = {
	
}

export type ColliderMetatable = {
    read __index: ColliderMethods,
}

export type Collider = ColliderVars & ColliderMethods

return {}