local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Tdyzy/Ephemeral-UI-Library/refs/heads/main/Library.lua"))()

-- Initialize with your toggle key
local Main = Lib:Init(Enum.KeyCode.RightControl)

-- Create Windows side-by-side
local Combat = Main:NewWindow("Combat", 20)
Combat:AddToggle("KillAura", function(s) print("KillAura: ", s) end)
Combat:AddToggle("Trigger Bot", function(s) print("Trigger: ", s) end)

local Movement = Main:NewWindow("Movement", 165)
Movement:AddToggle("Speed", function(s) 
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s and 100 or 16 
end)
Movement:AddToggle("Super Jump", function(s) 
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = s and 150 or 50 
end)

local Settings = Main:NewWindow("Settings", 310)
Settings:AddToggle("Disable Blur", function(s)
    Main.BlurObject.Enabled = not s
end)

-- (Optional) Enable the smooth RGB color cycle like the photo
Main:EnableRGB()
