--!strict
local Physica = script.Parent.Parent

local Typings = Physica.Typings
local Matrix3Typing = require(Typings.Matrix3Typing)

local Collider = {}
Collider.__index = Collider

type self = {
	Mass: number,
	LocalInertiaTensor: Matrix3Typing.Matrix3,
	LocalCentroid: Vector3
}

function Collider.new(Mass, LocalInertiaTensor, LocalCentroid): self
	
	local self = setmetatable({} :: self, Collider)
	
	self.Mass = Mass
	self.LocalInertiaTensor = LocalInertiaTensor
	self.LocalCentroid = LocalCentroid
	
	return self
	
end

export type Collider = typeof(Collider.new(...))

return Collider
