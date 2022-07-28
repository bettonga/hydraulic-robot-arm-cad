require("math")
function sysCall_init()
    objectName="Arm_1"
    objectHandle=sim.getObjectHandle(objectName)
    referenceName="box"
    referenceHandle=sim.getObjectHandle(referenceName)
    rosInterfacePresent=simROS
    print("init")
    -- Prepare the publishers and subscribers :
    if rosInterfacePresent then
      print("found ros")
      subscriber = simROS.subscribe('/olimex/joint_angles_goal','std_msgs/Int16MultiArray','subscriber_angles_callback')
      publisher = simROS.advertise('/olimex/joint_angles_position', 'std_msgs/Int16MultiArray')
    end
    target_angle1 = -45
    target_angle2 = -90
    target_angle3 = -90
    actuator1 = sim.getObjectHandle("Linear_1_Actuator")
    actuator2 = sim.getObjectHandle("Linear_2_Actuator")
    actuator3 = sim.getObjectHandle("Linear_3_Actuator")
    pivot1 = sim.getObjectHandle("Arm_Pivot_1_2")
    pivot2 = sim.getObjectHandle("Arm_Pivot_2_3")
    pivot3 = sim.getObjectHandle("Wrist_Pivot")
end

function sysCall_cleanup()
    -- do some clean-up here
    if rosInterfacePresent then
        simROS.shutdownPublisher(publisher)
        simROS.shutdownSubscriber(subscriber)
        --simROS.shutdownPublisher(publisher2)
        --simROS.shutdownPublisher(publisher3)
    end
end

function sysCall_actuation()
    -- put your actuation code here
    sim.setJointTargetPosition(actuator1, (target_angle1 - 15) / (15 + 45) * (- 0.05))
    sim.setJointTargetPosition(actuator2, (target_angle2 - 0) / (0 + 90) * (- 0.05))
    sim.setJointTargetPosition(actuator3, ((0.05-0.015)/180*(-target_angle3+(90 + 180*0.015/(0.05-0.015)))) * (-1))
    pos = {
      layout={
        dim={},data_offset=0
      },
      data={2 * math.atan(math.tan(sim.getJointPosition(pivot1)/2))*180/math.pi,2*math.atan(math.tan((sim.getJointPosition(pivot2) - 58.865 * math.pi /180) /2))*180/math.pi,2*math.atan(math.tan((sim.getJointPosition(pivot3)+ math.pi/2)/2))*180/math.pi}
    }
    -- print(pos.data)
    simROS.publish(publisher, pos)
end

function subscriber_angles_callback(msg)

    -- angle1 = sim.getJointPosition(pivot1, -1)
    -- angle2 = sim.getJointPosition(pivot2, -1) - 58.895 * math.pi / 180
    -- angle3 = sim.getJointPosition(pivot3, -1) + math.pi/2
    -- print("a", angle1 * 180 / math.pi, angle2 * 180 / math.pi, angle3 * 180 / math.pi)
    target_angle1 = msg.data[1]
    target_angle2 = msg.data[2]
    target_angle3 = msg.data[3]
    -- e1 = 2 * math.atan(math.tan((target_angle1-angle1)/2)) * 180 / math.pi
    -- e2 = 2 * math.atan(math.tan((target_angle2-angle2)/2)) * 180 / math.pi
    -- e3 = 2 * math.atan(math.tan((target_angle3-angle3)/2)) * 180 / math.pi
    -- print("e", e1, e2, e3)
    -- k1, k2, k3 = 1, 1, 1
    -- print(pos.data)
end
