local Ephemeral = loadstring(game:HttpGet("https://raw.githubusercontent.com/Tdyzy/Ephemeral-UI-Library/refs/heads/main/Library.lua"))()

-- Define your menu structure here
local myConfig = {
	{
		Title = "Combat",
		Items = {
			{Name = "KillAura", Callback = function(s) print("KillAura: ", s) end},
			{Name = "Trigger Bot", Callback = function(s) print("Trigger: ", s) end},
			{Name = "Infinite Ammo", Callback = function(s) print("Ammo: ", s) end}
		}
	},
	{
		Title = "Movement",
		Items = {
			{Name = "Speed", Callback = function(s) 
                game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s and 100 or 16 
            end},
			{Name = "Super Jump", Callback = function(s) 
                game.Players.LocalPlayer.Character.Humanoid.JumpPower = s and 150 or 50 
            end},
			{Name = "Noclip", Callback = function(s) print("Noclip: ", s) end}
		}
	},
	{
		Title = "Settings",
		Items = {
			{Name = "Destroy UI", Callback = function() 
                game.Players.LocalPlayer.PlayerGui.Ephemeral_V2:Destroy() 
            end}
		}
	}
}

-- Initialize everything at once
Ephemeral:Init(myConfig, Enum.KeyCode.RightControl)
