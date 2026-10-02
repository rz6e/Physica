--!strict

local Simplex = {}
Simplex.__index = Simplex

type self = {
	MPoints: {{Point: vector, PointA: vector, PointB: vector}},
	MSize: number,
	Direction: vector,
}

-- Is point A past the origin or not?
local function PastOrigin(Direction: vector, ao: vector)
	return vector.dot(Direction, ao) > 0
end

function Simplex.new() 
	
	local self = setmetatable({} :: self, Simplex)
	
	self.MPoints = {
		[1] = {Point = vector.zero, PointA = vector.zero, PointB = vector.zero},
		[2] = {Point = vector.zero, PointA = vector.zero, PointB = vector.zero},
		[3] = {Point = vector.zero, PointA = vector.zero, PointB = vector.zero},
		[4] = {Point = vector.zero, PointA = vector.zero, PointB = vector.zero},
	}
	self.MSize = 0
	self.Direction = vector.create(1, 0, 0)
	
	return self
	
end

export type Simplex = typeof(Simplex.new(...))

function Simplex.PushFront(self: Simplex, Point)
	
	self.MPoints[4] = self.MPoints[3]
	self.MPoints[3] = self.MPoints[2]
	self.MPoints[2] = self.MPoints[1]
	self.MPoints[1] = Point
	
	self.MSize = math.min(self.MSize + 1, 4)
	
end

function Simplex.Line(self: Simplex)
	local A = self.MPoints[1]
	local B = self.MPoints[2]
	
	local a = A.Point
	local b = B.Point
	
	local ab = b - a
	-- Direction AO is vector.zero - a 
	local ao = -a 
	
	if PastOrigin(ab, ao) then
		self.Direction = vector.cross(vector.cross(ab, ao), ab)
		self.MSize = 2
	else
		self.MPoints[1] = A
		self.MPoints[2] = {Point = vector.zero, PointA = vector.zero, PointB = vector.zero}
		self.MPoints[3] = {Point = vector.zero, PointA = vector.zero, PointB = vector.zero}
		self.MPoints[4] = {Point = vector.zero, PointA = vector.zero, PointB = vector.zero}
		self.MSize = 1
		self.Direction = ao
	end
	
	return false
	
end

function Simplex.Triangle(self: Simplex)
	local A = self.MPoints[1]
	local B = self.MPoints[2]
	local C = self.MPoints[3]
	
	local a = A.Point
	local b = B.Point
	local c = C.Point
	
	local ab = b - a 
	local ac = c - a
	local ao = -a
	
	local ABC = vector.cross(ab, ac)
	
	local ABPerp = vector.cross(ab, ABC)
	local ACPerp = vector.cross(ABC, ac)
	
	if PastOrigin(ABPerp, ao) then
		print("Region AB contains the origin")
		self.MPoints[1] = A
		self.MPoints[2] = B
		self.MPoints[3] = {Point = vector.zero, PointA = vector.zero, PointB = vector.zero}
		self.MPoints[4] = {Point = vector.zero, PointA = vector.zero, PointB = vector.zero}
		self.MSize = 2
		
		return self:Line()
		
	elseif PastOrigin(ACPerp, ao) then
		print("Region AC contains the origin")
		self.MPoints[1] = A
		self.MPoints[2] = C
		self.MPoints[3] = {Point = vector.zero, PointA = vector.zero, PointB = vector.zero}
		self.MPoints[4] = {Point = vector.zero, PointA = vector.zero, PointB = vector.zero}
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
	
end


function Simplex.Tetrahedron(self: Simplex): boolean
	local A = self.MPoints[1]
	local B = self.MPoints[2]
	local C = self.MPoints[3]
	local D = self.MPoints[4]
	
	local a = A.Point
	local b = B.Point
	local c = C.Point
	local d = D.Point
	
	local ab = b - a
	local ac = c - a
	local ad = d - a
	local ao = -a
	
	local PerpABC = vector.cross(ab, ac)
	local PerpACD = vector.cross(ac, ad)
	local PerpADB = vector.cross(ad, ab)
	
	if PastOrigin(PerpABC, ao) then
		self.MPoints[1] = A
		self.MPoints[2] = B
		self.MPoints[3] = C
		self.MPoints[4] = {Point = vector.zero, PointA = vector.zero, PointB = vector.zero}
		self.MSize = 3
		
		return self:Triangle()
	elseif PastOrigin(PerpACD, ao) then
		self.MPoints[1] = A
		self.MPoints[2] = C
		self.MPoints[3] = D
		self.MPoints[4] = {Point = vector.zero, PointA = vector.zero, PointB = vector.zero}
		self.MSize = 3
		
		return self:Triangle()
	elseif PastOrigin(PerpADB, ao) then
		self.MPoints[1] = A
		self.MPoints[2] = D
		self.MPoints[3] = B
		self.MPoints[4] = {Point = vector.zero, PointA = vector.zero, PointB = vector.zero}
		self.MSize = 3
		
		return self:Triangle()
	else
		return true
	end
end


function Simplex.NextSimplex(self: Simplex): boolean
	local Size = self:Size()
	
	if Size == 2 then
		return self:Line()
	elseif Size == 3 then
		return self:Triangle()
	elseif Size == 4 then
		return self:Tetrahedron()
	end
	
	return false
	
end

function Simplex.Size(self: Simplex)
	return self.MSize
end

function Simplex.GetTetraPoints(self: Simplex)
	return self.MPoints[1], self.MPoints[2],
		self.MPoints[3], self.MPoints[4]
end

return Simplex
