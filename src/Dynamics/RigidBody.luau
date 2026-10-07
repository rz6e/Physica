--!strict

local Physica = script.Parent.Parent

local Typings = Physica.Typings
local Math = Physica.Math

local Collider = require(Physica.Collision.Collider)
type Collider = Collider.Collider

local Matrix3 = require(Math.Matrix3)
local Matrix3Typing = require(Typings.Matrix3Typing)

local RigidBody = {}
RigidBody.__index = RigidBody

type self = {
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
	
	Colliders: {Collider},
}

function RigidBody.new(LocalCentroid, Mass): self
	
	local self = setmetatable({} :: self, RigidBody)
	
	self.LocalCentroid = LocalCentroid
	self.Colliders = {}
	self.Mass = Mass
	
	return self
	
end

function RigidBody.AddCollider(self: self, Collider: Collider)
	
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

end

function RigidBody.ApplyForce(self: self, Force: Vector3, At: Vector3)
	self.ForceAccumulator += Force
	self.TorqueAccumulator += (At - self.GlobalCentroid):Cross(Force)
end

export type RigidBody = typeof(RigidBody.new(...))

return RigidBody
