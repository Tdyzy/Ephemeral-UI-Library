local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Tdyzy/Ephemeral-UI-Library/refs/heads/main/Library.lua"))()

local Main = Lib:Init(Enum.KeyCode.RightControl)

-- Movement Window
local Movement = Main:NewWindow("Movement", 165)

-- WalkSpeed Toggle
Movement:AddToggle("Speed", function(state)
    local character = game.Players.LocalPlayer.Character
    if character and character:FindFirstChild("Humanoid") then
        if state then
            character.Humanoid.WalkSpeed = 100 -- Fast speed
        else
            character.Humanoid.WalkSpeed = 16  -- Reset to default
        end
    end
end)

-- JumpPower Toggle
Movement:AddToggle("Super Jump", function(state)
    local character = game.Players.LocalPlayer.Character
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.UseJumpPower = true -- Ensures JumpPower is used instead of Height
        if state then
            character.Humanoid.JumpPower = 150 -- High jump
        else
            character.Humanoid.JumpPower = 50  -- Reset to default
        end
    end
end)

-- Combat Window
local Combat = Main:NewWindow("Combat", 20)
Combat:AddToggle("KillAura", function(state)
    print("KillAura is now: ", state)
end)
