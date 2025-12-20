-- Use example of Ephemeral UI library
local Ephemeral = loadstring(game:HttpGet("https://raw.githubusercontent.com/Tdyzy/Ephemeral-UI-Library/refs/heads/main/Library.lua"))()

-- Initialize
local Main = Ephemeral:Init(Enum.KeyCode.RightControl)

-- Local Player Window
local LocalPlayer = Main:NewWindow("Local Player", UDim2.new(0.05, 0, 0.2, 0))
LocalPlayer:AddLabel("User: " .. game.Players.LocalPlayer.Name)
LocalPlayer:AddButton("Kill Me", function()
    if game.Players.LocalPlayer.Character then 
        game.Players.LocalPlayer.Character.Humanoid.Health = 0 
    end
end)

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

Movement:AddToggle("Spin Bot", function(state)
    _G.Spinning = state
    task.spawn(function()
        while _G.Spinning do
            local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(25), 0) end
            task.wait()
        end
    end)
end)

-- Settings Window
local Settings = Main:NewWindow("Settings", UDim2.new(0.35, 0, 0.2, 0))
Settings:AddKeybind("Toggle Key", Enum.KeyCode.RightControl, Main)
Settings:AddButton("Destroy UI", function()
    local ui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("Ephemeral_Lib")
    if ui then ui:Destroy() end
end)
