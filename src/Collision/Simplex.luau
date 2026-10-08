--!strict
const SimplexTyping = require "../Typings/SimplexTyping"

type SimplexVars = SimplexTyping.SimplexVars
type SimplexMethods = SimplexTyping.SimplexMethods
type Simplex = SimplexTyping.Simplex

const SimplexClass = {}

-- Is point A past the origin or not?
const function PastOrigin(Direction: Vector3, ao: Vector3): boolean
	return Direction:Dot(ao) > 0
end

const ClassMethods: SimplexMethods = table.freeze({
	PushFront = function(self: Simplex, Point: SimplexTyping.MPoint)
	
		self.MPoints[4] = self.MPoints[3]
		self.MPoints[3] = self.MPoints[2]
		self.MPoints[2] = self.MPoints[1]
		self.MPoints[1] = Point
		
		self.MSize = math.min(self.MSize + 1, 4)
	end,

	Line = function(self: Simplex): boolean
		const A = self.MPoints[1]
		const B = self.MPoints[2]
		
		const a = A.Point
		const b = B.Point
		
		const ab = b - a
		-- Direction AO is vector.zero - a 
		const ao = -a 
		
		if PastOrigin(ab, ao) then
			self.Direction = ab:Cross(ao):Cross(ab)
			self.MSize = 2
		else
			self.MPoints[1] = A
			self.MPoints[2] = {Point = Vector3.zero, PointA = Vector3.zero, PointB = Vector3.zero}
			self.MPoints[3] = {Point = Vector3.zero, PointA = Vector3.zero, PointB = Vector3.zero}
			self.MPoints[4] = {Point = Vector3.zero, PointA = Vector3.zero, PointB = Vector3.zero}
			self.MSize = 1
			self.Direction = ao
		end
		
		return false
		
	end,

	Triangle = function(self: Simplex): boolean
		const A = self.MPoints[1]
		const B = self.MPoints[2]
		const C = self.MPoints[3]
		
		const a = A.Point
		const b = B.Point
		const c = C.Point
		
		const ab = b - a 
		const ac = c - a
		const ao = -a
		
		const ABC = ab:Cross(ac)
		
		const ABPerp = ab:Cross(ABC)
		const ACPerp = ABC:Cross(ac)
		
		if PastOrigin(ABPerp, ao) then
			print("Region AB contains the origin")
			self.MPoints[1] = A
			self.MPoints[2] = B
			self.MPoints[3] = {Point = Vector3.zero, PointA = Vector3.zero, PointB = Vector3.zero}
			self.MPoints[4] = {Point = Vector3.zero, PointA = Vector3.zero, PointB = Vector3.zero}
			self.MSize = 2
			
			return self:Line()
			
		elseif PastOrigin(ACPerp, ao) then
			print("Region AC contains the origin")
			self.MPoints[1] = A
			self.MPoints[2] = C
			self.MPoints[3] = {Point = Vector3.zero, PointA = Vector3.zero, PointB = Vector3.zero}
			self.MPoints[4] = {Point = Vector3.zero, PointA = Vector3.zero, PointB = Vector3.zero}
			self.MSize = 2
			
			return self:Line()

		else
			if PastOrigin(ABC, ao) then
				self.Direction = ABC
			else
				self.Direction = -ABC
				
				self.MPoints[2] = C
				self.MPoints[3] = B
			end

			return false
		end
		
	end,

	Tetrahedron = function(self: Simplex): boolean
		const A = self.MPoints[1]
		const B = self.MPoints[2]
		const C = self.MPoints[3]
		const D = self.MPoints[4]
		
		const a = A.Point
		const b = B.Point
		const c = C.Point
		const d = D.Point
		
		const ab = b - a
		const ac = c - a
		const ad = d - a
		const ao = -a
		
		const PerpABC = ab:Cross(ac)
		const PerpACD = ac:Cross(ad)
		const PerpADB = ad:Cross(ab)
		
		if PastOrigin(PerpABC, ao) then
			self.MPoints[1] = A
			self.MPoints[2] = B
			self.MPoints[3] = C
			self.MPoints[4] = {Point = Vector3.zero, PointA = Vector3.zero, PointB = Vector3.zero}
			self.MSize = 3
			
			return self:Triangle()
		elseif PastOrigin(PerpACD, ao) then
			self.MPoints[1] = A
			self.MPoints[2] = C
			self.MPoints[3] = D
			self.MPoints[4] = {Point = Vector3.zero, PointA = Vector3.zero, PointB = Vector3.zero}
			self.MSize = 3
			
			return self:Triangle()
		elseif PastOrigin(PerpADB, ao) then
			self.MPoints[1] = A
			self.MPoints[2] = D
			self.MPoints[3] = B
			self.MPoints[4] = {Point = Vector3.zero, PointA = Vector3.zero, PointB = Vector3.zero}
			self.MSize = 3
			
			return self:Triangle()
		else
			return true
		end
	end,

	NextSimplex = function(self: Simplex): boolean
		local Size = self:Size()
		
		if Size == 2 then
			return self:Line()
		elseif Size == 3 then
			return self:Triangle()
		elseif Size == 4 then
			return self:Tetrahedron()
		end
		
		return false
		
	end,

	Size = function(self: Simplex): number
		return self.MSize
	end,

	GetTetraPoints = function(self: Simplex): 
		(SimplexTyping.MPoint, SimplexTyping.MPoint, SimplexTyping.MPoint, SimplexTyping.MPoint)
		return self.MPoints[1], self.MPoints[2],
			self.MPoints[3], self.MPoints[4]
	end,
})

const MethodsMetatable: SimplexTyping.SimplexMetatable = table.freeze({
	__index = ClassMethods
})

function SimplexClass.new() 
	
	const SimplexVars: SimplexVars = {
		MPoints = {
			[1] = {Point = Vector3.zero, PointA = Vector3.zero, PointB = Vector3.zero},
			[2] = {Point = Vector3.zero, PointA = Vector3.zero, PointB = Vector3.zero},
			[3] = {Point = Vector3.zero, PointA = Vector3.zero, PointB = Vector3.zero},
			[4] = {Point = Vector3.zero, PointA = Vector3.zero, PointB = Vector3.zero},
		},
		MSize = 0,
		Direction = Vector3.new(1, 0, 0)
	}
	
	const Simplex: Simplex = setmetatable(SimplexVars, MethodsMetatable)

	return Simplex
	
end

table.freeze(SimplexClass)

return SimplexClass
