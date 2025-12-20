-- Example use of Ephemeral UI Library
local Ephemeral = loadstring(game:HttpGet("https://raw.githubusercontent.com/Tdyzy/Tdyyyz-UI-library/refs/heads/main/Library.lua"))()

--Initialization
local Main = Ephemeral:Init(Enum.KeyCode.RightControl)

-- Local Player Window
local LocalPlayer = Main:NewWindow("Local Player", UDim2.new(0.05, 0, 0.2, 0))
LocalPlayer:AddButton("Kill Me", function()
    if game.Players.LocalPlayer.Character then 
        game.Players.LocalPlayer.Character.Humanoid.Health = 0 
    end
end)
LocalPlayer:AddLabel("User: " .. game.Players.LocalPlayer.Name)

-- Movement Window
local Movement = Main:NewWindow("Movement", UDim2.new(0.2, 0, 0.2, 0))

Movement:AddSlider("WalkSpeed", 16, 250, 16, function(v)
    if game.Players.LocalPlayer.Character then 
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v 
    end
end)

Movement:AddSlider("JumpPower", 50, 500, 50, function(v)
    if game.Players.LocalPlayer.Character then 
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = v 
    end
end)

-- Settings Window
local Settings = Main:NewWindow("Settings", UDim2.new(0.35, 0, 0.2, 0))
Settings:AddKeybind("Toggle Key", Enum.KeyCode.RightControl, Main)
Settings:AddButton("Destroy UI", function()
    local ui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("Ephemeral_Lib")
    if ui then ui:Destroy() end
end)
