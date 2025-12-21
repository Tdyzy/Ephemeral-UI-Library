-- Example use of Ephemeral UI lib
local Ephemeral = loadstring(game:HttpGet("https://raw.githubusercontent.com/Tdyzy/Tdyyyz-UI-library/refs/heads/main/Library.lua"))()

local Main = Ephemeral:Init(Enum.KeyCode.RightControl)

-- Local Player
local PlayerWin = Main:NewWindow("Self", UDim2.new(0.05, 0, 0.2, 0))
PlayerWin:AddButton("Reset Character", function() 
    game.Players.LocalPlayer.Character.Humanoid.Health = 0 
end)
PlayerWin:AddToggle("God Mode (Mock)", function(s) print(s) end)

-- Movement
local Movement = Main:NewWindow("Movement", UDim2.new(0.2, 0, 0.2, 0))
Movement:AddSlider("Speed", 16, 250, 16, function(v)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
end)
Movement:AddSlider("Jump", 50, 500, 50, function(v)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = v
end)
Movement:AddToggle("Spin", function(s) _G.Spin = s 
    task.spawn(function() while _G.Spin do 
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame *= CFrame.Angles(0,0.5,0) task.wait() 
    end end)
end)

-- Settings
local Settings = Main:NewWindow("Settings", UDim2.new(0.35, 0, 0.2, 0))
Settings:AddKeybind("Menu Key", Enum.KeyCode.RightControl, Main)
Settings:AddButton("Unload UI", function()
    game.Players.LocalPlayer.PlayerGui:FindFirstChild("Ephemeral_Lib"):Destroy()
end)
