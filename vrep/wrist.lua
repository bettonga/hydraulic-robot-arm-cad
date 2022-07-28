require("math")
function sysCall_init()
    corout=coroutine.create(coroutineMain)
end

function sysCall_actuation()
    if coroutine.status(corout)~='dead' then
        local ok,errorMsg=coroutine.resume(corout)
        if errorMsg then
            error(debug.traceback(corout,errorMsg),2)
        end
    end
end

function sysCall_cleanup()
    -- do some clean-up here
end

function coroutineMain()
    -- Put some initialization code here
    actuator = sim.getObjectHandle("Linear_3_Actuator")
    wrist = sim.getObjectHandle("Wrist_Pivot")

    -- Put your main loop here, e.g.:
    --
    -- while true do
    --     local p=sim.getObjectPosition(objHandle,-1)
    --     p[1]=p[1]+0.001
    --     sim.setObjectPosition(objHandle,-1,p)
    --     sim.switchThread() -- resume in next simulation step
    -- end
    while sim.getSimulationState()~=sim.simulation_advancing_abouttostop do
      local pistonSize = -sim.getJointPosition(actuator, -1)
      sim.setJointPosition(wrist, (pistonSize - 0.015) / (0.05 - 0.015) * math.pi * -1)
      sim.switchThread()
    end
end

-- See the user manual or the available code snippets for additional callback functions and details
