-- auto rocket surfing, crouch jumps when a rocket is nearby
-- only activates when player is on ground

---@type boolean, lnxLib
local libLoaded, lnxLib = pcall(require, "lnxLib")
assert(libLoaded, "lnxLib not found, please install it!")
assert(lnxLib.GetVersion() >= 0.995, "lnxLib version is too old, please update it!")
UnloadLib()

local Math, Conversion = lnxLib.Utils.Math, lnxLib.Utils.Conversion
local WPlayer, WWeapon = lnxLib.TF2.WPlayer, lnxLib.TF2.WWeapon
local Helpers = lnxLib.TF2.Helpers
local Prediction = lnxLib.TF2.Prediction


local projectiles = {}

local function onCreateMove( cmd )

	local pLocal = entities.GetLocalPlayer()
	local flags = pLocal:GetPropInt( "m_fFlags" );

	if flags & FL_ONGROUND == 1 then
		projectiles = entities.FindByClass("CTFProjectile_Rocket")
		
		local closestProjectile = nil
		local closestDistance = 125
		
		
		for _, projectile in pairs(projectiles) do
			--local owner = projectile:GetTeamNumber()
			if projectile:GetTeamNumber() ~= pLocal:GetTeamNumber() then
				local projectilePos = projectile:GetAbsOrigin()
				local distance = (pLocal:GetAbsOrigin() - projectilePos):Length()

				if distance < closestDistance then
					closestDistance = distance
					closestProjectile = projectile
				end
			end
		end
		
		if closestProjectile ~= nil then
			cmd:SetButtons(cmd.buttons | IN_DUCK)
			cmd:SetButtons(cmd.buttons | IN_JUMP)
		end
	end
end

callbacks.Register("CreateMove", onCreateMove)