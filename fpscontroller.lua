scriptId = 'FPS Online Myo Controller'
-- Use with website: http://www.y8.com/games/csportable or one of your choice

-- Edit the reload/switch weapon keyboard buttons based on online games/csportable
reloadkey = "e"
switchkey = "q"
   
function conditionallySwapWave(pose)
    if myo.getArm() == "left" then
        if pose == "waveIn" then
            pose = "waveOut"
        elseif pose == "waveOut" then
            pose = "waveIn"
        end
    end
    return pose
end

function onPoseEdge(pose, edge)
    pose=conditionallySwapWave(pose)
	myo.debug("onPoseEdge: " .. pose .. ", " .. edge)
    if edge == "on" then
		-- Shoot mouse press
        if pose == "fingersSpread" and enabled then
            myo.mouse("left","down")
		-- Reload key press
        elseif pose == "fist" and enabled then   
            myo.keyboard(reloadkey,"press")
			startRoll = myo.getRoll()
			reposition = true
			myo.controlMouse(false)
        end
    elseif edge=="off" then
		myo.mouse("left","up")
        myo.mouse("right","up")
		-- Repositions the mouse pointer
		if reposition == true then
			reposition = false
			myo.controlMouse(true)
			myo.centerMousePosition()
			-- Change weapon
			myo.debug (myo.getRoll() .. " " .. startRoll)
			if (myo.getRoll()-startRoll > 0.5) then
				myo.keyboard(switchkey,"press")
			end
		end
    end
end

function onPeriodic()
    
end
function onActiveChange(isActive)
    if isActive then
        enabled = true
        myo.controlMouse(true)
    else
        enabled = false
        myo.controlMouse(false)
    end 
end

function onForegroundWindowChange(app, title)   
    if platform == "Windows" then
		if string.match(title, "- Google Chrome$") then
			reposition = false
			return true
		else
			return false
		end
    end
	return true
end
