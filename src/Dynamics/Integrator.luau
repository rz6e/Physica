--!strict
--!native
const RigidBodyTyping = require "../Typings/RigidBodyTyping"

const Integrator = {}

-- Apply changes to the rigid body's physical properties during some timestep

-- (note) might split into seperate functions later for better customization
-- (note) use DoD to not waste resources looping over properties we dont need here
function Integrator.Integrate(RigidBodies: {RigidBodyTyping.RigidBody}, dt: number)

    for _, Body in RigidBodies do

        -- the change of linear velocity is (linear impulse * inverse mass)
        Body.LinearVelocity += Body.InverseMass * (Body.ForceAccumulator * dt)

        -- the change of angular velocity is (inverse tensor * angular impulse)
        -- convert angular impulse to object space and back to world space due to the inertia tensor being calculated locally
        Body.AngularVelocity += Body.GlobalInverseInertiaTensor * (Body.TorqueAccumulator * dt)

        -- reset this frames cumulated forces since forces are instantaneous actions
        Body.ForceAccumulator = vector.zero
        Body.TorqueAccumulator = vector.zero

        Body.GlobalCentroid += Body.LinearVelocity * dt

    end

end

table.freeze(Integrator)

return Integrator