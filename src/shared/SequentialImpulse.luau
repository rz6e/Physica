local SequentialImpulse = {}
SequentialImpulse.__index = SequentialImpulse

type self = {
	VelocityConstraint: vector,
	PositionConstraint: vector,
}

function SequentialImpulse.new()
	
end


export type Simplex = typeof(SequentialImpulse.new(...))

return SequentialImpulse
