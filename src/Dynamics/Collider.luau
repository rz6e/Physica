--!strict
const ColliderTyping = require("../Typings/ColliderTyping")

type ColliderVars = ColliderTyping.ColliderVars
type ColliderMethods = ColliderTyping.ColliderMethods
type Collider = ColliderTyping.Collider

const ColliderClass = {}

const ClassMethods = table.freeze({
	
})

const MethodsMetatable: ColliderTyping.ColliderMetatable = table.freeze({
	__index = ClassMethods
})

function ColliderClass.new(Mass, LocalInertiaTensor, LocalCentroid)

	const ColliderVars: ColliderVars = {
		LocalCentroid = LocalCentroid,
		LocalInertiaTensor = LocalInertiaTensor,
		Mass = Mass,
	}
	
	const Collider: Collider = setmetatable(ColliderVars, MethodsMetatable)
	
	return Collider
	
end

table.freeze(ColliderClass)

return ColliderClass
