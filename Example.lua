-- Ephemeral UI lib example use
local Ephemeral = loadstring(game:HttpGet("https://raw.githubusercontent.com/Tdyzy/Tdyyyz-UI-library/refs/heads/main/Library.lua"))()

-- Initialize
local Main = Ephemeral:Init(Enum.KeyCode.RightControl)

-- Example window of Information
local Info = Main:NewWindow("Information", UDim2.new(0.05, 0, 0.2, 0))
Info:AddLabel("Creator: Tdyyyz")
Info:AddLabel("Status: Active")
Info:AddLabel("Version: 1.0.0")

-- Movement Window
local Movement = Main:NewWindow("Movement", UDim2.new(0.2, 0, 0.2, 0))
Movement:AddSlider("WalkSpeed", 16, 250, 16, function(v)
    if game.Players.LocalPlayer.Character then game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v end
end)

local spinning = false
Movement:AddToggle("Spin Bot", function(state)
    spinning = state
    task.spawn(function()
        while spinning do
            local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(30), 0) end
            task.wait()
        end
    end)
end)

-- ettings Window
local Settings = Main:NewWindow("Settings", UDim2.new(0.35, 0, 0.2, 0))
Settings:AddKeybind("Toggle Key", Enum.KeyCode.RightControl, Main)

Settings:AddButton("Destroy UI", function()
    local ui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("Ephemeral_Lib")
    if ui then ui:Destroy() end
end)
