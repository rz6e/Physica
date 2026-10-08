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
		self.LocalCentroid = Vector3.zero
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
			const RSquared = R:Dot(R)
			const OuterProduct = Matrix3.OuterProduct(R, R)
			
			LocalInertiaTensor += self.Mass * ((RSquared * E) - OuterProduct)
		end
		
		self.LocalInverseInertiaTensor = LocalInertiaTensor:Inverse()
		
		--local L = LocalInertiaTensor * omega

		warn(self.LocalInverseInertiaTensor:Beautify())

	end,

	ApplyForce = function(self: RigidBody, Force: Vector3, At: Vector3)
		self.ForceAccumulator += Force
		self.TorqueAccumulator += (At - self.GlobalCentroid):Cross(Force)
	end,
})

const MethodsMetatable: RigidBodyTyping.RigidBodyMetatable = table.freeze({
	__index = ClassMethods
})

function RigidBodyClass.new(LocalCentroid, Mass)
	
	const RigidBodyVars: RigidBodyVars = {
		AngularVelocity = Vector3.zero,
		Colliders = {},
		ForceAccumulator = Vector3.zero,
		GlobalCentroid = Vector3.zero,
		GlobalInverseInertiaTensor = Matrix3.Zero(),
		InverseMass = 0,
		LinearVelocity = Vector3.zero,
		LocalCentroid = LocalCentroid,
		LocalInverseInertiaTensor = Matrix3.Zero(),
		Mass = Mass,
		Orientation = Matrix3.Identity(),
		Position = Vector3.zero,
		TorqueAccumulator = Vector3.zero,
	}

	const RigidBody: RigidBody = setmetatable(RigidBodyVars, MethodsMetatable)

	return RigidBody
	
end

table.freeze(RigidBodyClass)

return RigidBodyClass
