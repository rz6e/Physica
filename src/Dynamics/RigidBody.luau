--!strict
const ColliderTyping = require "../Typings/ColliderTyping"
const Matrix3Typing = require "../Typings/Matrix3Typing"
const RigidBodyTyping = require "../Typings/RigidBodyTyping"
const Matrix3 = require "../Math/Matrix3"

type Collider = ColliderTyping.Collider

type RigidBodyVars = RigidBodyTyping.RigidBodyVars
type RigidBodyMethods = RigidBodyTyping.RigidBodyMethods
type RigidBody = RigidBodyTyping.RigidBody

const RigidBodyClass = {}

const ClassMethods = table.freeze({
	AddCollider = function(self: RigidBody, Collider: Collider)
		
		self.Colliders[#self.Colliders + 1] = Collider
		
		local LocalInertiaTensor = Matrix3.Zero()
		self.LocalCentroid = vector.zero
		self.Mass = 0
		
		for _, Collider in self.Colliders do
			self.Mass += Collider.Mass
			
			self.LocalCentroid += Collider.LocalCentroid * Collider.Mass
		end
		
		self.InverseMass = 1/self.Mass
		self.LocalCentroid *= self.InverseMass
		
		for _, Collider in self.Colliders do
			const R = self.LocalCentroid - Collider.LocalCentroid
			const E = Matrix3.Identity()
			const RSquared = vector.dot(R, R)
			const OuterProduct = Matrix3.OuterProduct(R, R)
			
			LocalInertiaTensor += self.Mass * ((RSquared * E) - OuterProduct)
		end
		
		self.LocalInverseInertiaTensor = LocalInertiaTensor:Inverse()
		
		--local L = LocalInertiaTensor * omega

		warn(self.LocalInverseInertiaTensor:Beautify())

	end,

	ApplyForce = function(self: RigidBody, Force: vector, At: vector)
		self.ForceAccumulator += Force
		self.TorqueAccumulator += vector.cross((At - self.GlobalCentroid), Force)
	end,
})

const MethodsMetatable: RigidBodyTyping.RigidBodyMetatable = table.freeze({
	__index = ClassMethods
})

function RigidBodyClass.new(LocalCentroid, Mass)
	
	const RigidBodyVars: RigidBodyVars = {
		Mass = Mass,
		InverseMass = 0,

		LocalInverseInertiaTensor = Matrix3.Zero(),
		GlobalInverseInertiaTensor = Matrix3.Zero(),

		LocalCentroid = LocalCentroid,
		GlobalCentroid = vector.zero,

		Position = vector.zero,
		Orientation = Matrix3.Identity(),
		LinearVelocity = vector.zero,
		AngularVelocity = vector.zero,

		TorqueAccumulator = vector.zero,
		ForceAccumulator = vector.zero,

		Colliders = {},
	}

	const RigidBody: RigidBody = setmetatable(RigidBodyVars, MethodsMetatable)

	return RigidBody
	
end

table.freeze(RigidBodyClass)

return RigidBodyClass
