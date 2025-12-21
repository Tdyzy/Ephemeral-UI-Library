local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Tdyzy/Ephemeral-UI-Library/refs/heads/main/Library.lua"))()

local Main = Lib:Init(Enum.KeyCode.RightControl)

-- Positioning them side-by-side using the xOffset (15, 160, 305, etc.)
local Combat = Main:NewWindow("Combat", 15)
Combat:AddToggle("KillAura", function() end)
Combat:AddToggle("Trigger Bot", function() end)
Combat:AddToggle("Auto Arrest", function() end)

local Movement = Main:NewWindow("Movement", 160)
Movement:AddToggle("Speed", function() end)
Movement:AddToggle("Super Jump", function() end)
Movement:AddToggle("Noclip", function() end)

local Settings = Main:NewWindow("Settings", 305)
Settings:AddToggle("Disable Blur", function(s)
    Main.BlurObject.Enabled = not s
end)
