-- Ephemeral UI lib example use
local Ephemeral = loadstring(game:HttpGet("https://raw.githubusercontent.com/Tdyzy/Ephemeral-UI-Library/refs/heads/main/Library.lua"))()
-- Main(includes a key for RightCTRL to hide the menu)
local Main = Ephemeral:Init(Enum.KeyCode.RightControl)

-- Info window
local Info = Main:NewWindow("Information", UDim2.new(0.05, 0, 0.2, 0))
Info:AddLabel("Ephemeral")
Info:AddLabel("User: " .. game.Players.LocalPlayer.Name)
Info:AddLabel("Version: 1.0.0")

-- Combat Window
local Combat = Main:NewWindow("Combat", UDim2.new(0.2, 0, 0.2, 0))
Combat:AddButton("Kill Me", function()
    game.Players.LocalPlayer.Character.Humanoid.Health = 0
end)
Combat:AddToggle("Kill Aura (Mock)", function(s) print("Kill Aura is:", s) end)

-- LocalPlayer Window
local localPlayer = Main:NewWindow("LocalPlayer", UDim2.new(0.35, 0, 0.2, 0))
localPlayer:AddSlider("WalkSpeed", 16, 300, 16, function(v)
    if game.Players.LocalPlayer.Character then game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v end
end)
localPlayer:AddSlider("JumpPower", 50, 500, 50, function(v)
    local hum = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
    if hum then hum.UseJumpPower = true hum.JumpPower = v end
end)

local spinning = false
localPlayer:AddToggle("Spin Player", function(state)
    spinning = state
    task.spawn(function()
        while spinning do
            local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(30), 0) end
            task.wait()
        end
    end)
end)

-- Settings Window(Keybind disabling Blur)
local Settings = Main:NewWindow("Settings", UDim2.new(0.5, 0, 0.2, 0))

-- Keybind Change
Settings:AddKeybind("Toggle Key", Enum.KeyCode.RightControl, Main)

-- Disable Blur Toggle
Settings:AddToggle("Disable Blur", function(state)
    for _, effect in pairs(game:GetService("Lighting"):GetChildren()) do
        if effect:IsA("BlurEffect") then
            effect.Enabled = not state -- If toggle is true (on), set enabled to false
        end
    end
end)

-- Destroy UI lib
Settings:AddButton("Destroy UI", function()
    local ui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("Ephemeral_Lib")
    if ui then
        ui:Destroy()
    end
end)
