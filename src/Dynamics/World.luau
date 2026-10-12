--!strict
const RigidBodyTyping = require "../Typings/RigidBodyTyping"

local World = {
    RigidBodies = {}
}

function World.AddRigidBody(RigidBody: RigidBodyTyping.RigidBody) 

    World.RigidBodies[#World.RigidBodies + 1] = RigidBody
    
end

table.freeze(World)

return World
