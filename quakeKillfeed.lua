draw.AddFontResource("TT Octosquares Trl Db.ttf")
local Nestoberyl = draw.CreateFont("TT Octosquares Trl Db", 25, 500)
local currentFrame = 0
local victim = 0
local attacker = 0
local customkill = 0
local killCounter = 0
local killMsgTime = 3

local function killedLogger2(event)

    if (event:GetName() == 'player_death' ) then

		local localPlayer = entities.GetLocalPlayer();
        local newVictim = entities.GetByUserID(event:GetInt("userid"))
        local newAttacker = entities.GetByUserID(event:GetInt("attacker"))
        local assist = entities.GetByUserID(event:GetInt("assister"))
        local newCustomkill = event:GetInt("customkill")

		if (assist ~= nil and localPlayer:GetIndex() == assist:GetIndex()) then -- assists
            engine.PlaySound( "quakeSounds/assist.wav" )
			attacker = assist
			victim = newVictim
			customkill = 0 - 1 -- special customkill just for the kill watermark to know if it was an assist or not
			currentFrame = globals.CurTime() + 2
			return
        end
		

        if (newAttacker == nil or localPlayer:GetIndex() ~= newAttacker:GetIndex()) then
            return
        end
		
		attacker = newAttacker
		
		victim = newVictim
		
		currentFrame = globals.CurTime() + killMsgTime
		
		if(attacker:GetIndex() == victim:GetIndex()) then
			engine.PlaySound( "quakeSounds/failed.wav" )
			customkill = 0 - 2
			currentFrame = globals.CurTime() + 2
			return
        end
		
		killCounter = killCounter + 1
		
		if(killCounter >= 2) then
			if(killCounter == 2) then
				engine.PlaySound( "quakeSounds/doublekill.wav" )
			elseif (killCounter == 3) then
				engine.PlaySound( "quakeSounds/triplekill.wav" )
			elseif (killCounter == 4) then
				engine.PlaySound( "quakeSounds/multikill.wav" )
			elseif (killCounter == 5) then
				engine.PlaySound( "quakeSounds/megakill.wav" )
			elseif (killCounter == 6) then
				engine.PlaySound( "quakeSounds/killingspree.wav" )
			elseif (killCounter == 7) then
				engine.PlaySound( "quakeSounds/ultrakill.wav" )
			elseif (killCounter == 8) then
				engine.PlaySound( "quakeSounds/rampage.wav" )
			elseif (killCounter == 9) then
				engine.PlaySound( "quakeSounds/unstoppable.wav" )
			elseif (killCounter == 10) then
				engine.PlaySound( "quakeSounds/monsterkill.wav" )
			elseif (killCounter >= 11 and killCounter < 20) then
				engine.PlaySound( "quakeSounds/godlike.wav" )
			elseif (killCounter == 20) then
				engine.PlaySound( "quakeSounds/winner.wav" ) -- i doubt anyone will get this normally LOL
			end
			
		end
		
        if (newCustomkill == 1) then
			customkill = 1
            print("*** You headshot " ..  victim:GetName() .. ".") -- the *** in from of the print is from cs 1.6
			engine.PlaySound( "quakeSounds/headshot.wav" )
			return
        end
		
        if (newCustomkill == 2) then
			customkill = 2
            print("*** You backstabbed " ..  victim:GetName() .. ".")
			return
        end

		customkill = 0
        print("You killed " ..  victim:GetName() .. ".")
    end

end

local function watermark()
	local timeLeft = globals.CurTime() - currentFrame
	
	if (timeLeft <= 0 and engine.IsGameUIVisible() == false) then
	
		local localPlayer = entities.GetLocalPlayer();
		local w, h = draw.GetScreenSize()
		
		if (localPlayer:GetIndex() ~= attacker:GetIndex()) then
            return
        end
	
		draw.SetFont(Nestoberyl)
		draw.Color(255, 255, 255, 255)
		
		local killMsgText = "You killed " ..  victim:GetName() .. "." -- normal kills
		
		if(attacker:GetIndex() == victim:GetIndex() or customkill == 0-2) then -- suicides
			killMsgText = "You killed yourself!"
        end
		
		if(customkill == 0-1) then -- assists
			killMsgText = "You assisted in killing " ..  victim:GetName() .. "."
        end
		
		if(customkill == 1) then -- headshots
			killMsgText = "You headshot " ..  victim:GetName() .. "."
        end
		
		if(customkill == 2) then -- backstabs
			killMsgText = "You stabbed " ..  victim:GetName() .. "."
        end
		
		
		local heightTextW, heightTextH = draw.GetTextSize(killMsgText)
		local heightX = math.floor((w - heightTextW) / 2)
		local heightY = math.floor((h / 2) + 100)  -- below crosshair, change if needed
		
		draw.TextShadow(heightX, heightY, killMsgText)
	
	else
		if(timeLeft > 0) then
			killCounter = 0
		end
	end
	
end

callbacks.Register("Draw", "drawWatermark", watermark)

callbacks.Register("FireGameEvent", "examplekilledLogger2", killedLogger2)
-- made by lovetaste 2021, edited by Boner 2025