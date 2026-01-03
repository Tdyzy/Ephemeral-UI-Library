local Library = {}
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Styling
local TEXT_COLOR = Color3.fromRGB(255, 255, 255)
local MAIN_COLOR = Color3.fromRGB(130, 0, 255) 
local DEFAULT_TRANSPARENCY = 0.4 
local FONT = Enum.Font.SourceSansBold

-- Tracking Tables
Library.AccentObjects = {} 
Library.WindowFrames = {}
Library.DropdownFrames = {} -- NEW: Track for transparency syncing
Library.RainbowActive = false
Library.CurrentColor = MAIN_COLOR
Library.BrandingLabel = nil 
Library.IsOpaque = false -- NEW: Track state

-- Cleanup
if _G.Ephemeral_Cleanup then _G.Ephemeral_Cleanup() end

local function MakeDraggable(gui, handle)
    local dragging, dragInput, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging, dragStart, startPos = true, input.Position, gui.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end

-- Rainbow Loop
task.spawn(function()
    local hue = 0
    while true do
        task.wait()
        if Library.RainbowActive then
            hue = hue + (1/400) 
            if hue > 1 then hue = 0 end
            Library.CurrentColor = Color3.fromHSV(hue, 0.7, 1)
            for obj, isText in pairs(Library.AccentObjects) do
                if isText then obj.TextColor3 = Library.CurrentColor else obj.BackgroundColor3 = Library.CurrentColor end
            end
        end
    end
end)

function Library:Init(defaultKey)
    local sg = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
    sg.Name = "Ephemeral_UI"
    sg.ResetOnSpawn = false
    self.ScreenGui = sg

    local mainFrame = Instance.new("Frame", sg)
    mainFrame.Name = "Main"
    mainFrame.Size = UDim2.new(1, 0, 1, 0)
    mainFrame.BackgroundTransparency = 1

    local brand = Instance.new("TextLabel", mainFrame)
    brand.Text = "Ephemeral"
    brand.Font = FONT
    brand.TextSize = 26
    brand.TextColor3 = MAIN_COLOR
    brand.Position = UDim2.new(0, 15, 0, 15)
    brand.Size = UDim2.new(0, 200, 0, 30)
    brand.BackgroundTransparency = 1
    brand.TextXAlignment = Enum.TextXAlignment.Left
    Library.BrandingLabel = brand
    Library.AccentObjects[brand] = true

    self.ToggleKey = defaultKey or Enum.KeyCode.RightControl
    local visible = true
    local inputConn = UIS.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == self.ToggleKey then
            visible = not visible
            mainFrame.Visible = visible
        end
    end)

    _G.Ephemeral_Cleanup = function()
        inputConn:Disconnect()
        sg:Destroy()
        Library.RainbowActive = false
        _G.Ephemeral_Cleanup = nil
    end

    self.Container = mainFrame
    return self
end

function Library:NewWindow(title, xOffset)
    local window = {}
    local column = Instance.new("Frame", self.Container)
    column.Size = UDim2.new(0, 140, 0, 0)
    column.Position = UDim2.new(0, xOffset or 15, 0, 60)
    column.AutomaticSize = Enum.AutomaticSize.Y
    column.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    column.BackgroundTransparency = DEFAULT_TRANSPARENCY
    column.BorderSizePixel = 0
    table.insert(Library.WindowFrames, column)

    local header = Instance.new("Frame", column)
    header.Size = UDim2.new(1, 0, 0, 26)
    header.BackgroundColor3 = MAIN_COLOR
    header.BorderSizePixel = 0
    Library.AccentObjects[header] = false 
    
    local headerTitle = Instance.new("TextLabel", header)
    headerTitle.Size = UDim2.new(1, 0, 1, 0)
    headerTitle.BackgroundTransparency = 1
    headerTitle.Text = title
    headerTitle.TextColor3 = Color3.new(1, 1, 1)
    headerTitle.Font = FONT
    headerTitle.TextSize = 15

    MakeDraggable(column, header)

    local list = Instance.new("Frame", column)
    list.Size = UDim2.new(1, 0, 0, 0)
    list.Position = UDim2.new(0, 0, 0, 26)
    list.AutomaticSize = Enum.AutomaticSize.Y
    list.BackgroundTransparency = 1
    Instance.new("UIListLayout", list).SortOrder = Enum.SortOrder.LayoutOrder

    function window:AddToggle(text, callback)
        local btn = Instance.new("TextButton", list)
        btn.Size = UDim2.new(1, 0, 0, 22)
        btn.BackgroundTransparency = 1
        btn.Text = "  > " .. text
        btn.TextColor3 = TEXT_COLOR
        btn.Font = FONT
        btn.TextSize = 14
        btn.TextXAlignment = Enum.TextXAlignment.Left
        
        local enabled = false
        btn.MouseButton1Click:Connect(function()
            enabled = not enabled
            if enabled then
                btn.TextColor3 = Library.RainbowActive and Library.CurrentColor or MAIN_COLOR
                Library.AccentObjects[btn] = true
            else
                Library.AccentObjects[btn] = nil
                btn.TextColor3 = TEXT_COLOR
            end
            callback(enabled)
        end)
    end

    function window:AddButton(text, callback)
        local btn = Instance.new("TextButton", list)
        btn.Size = UDim2.new(1, 0, 0, 22)
        btn.BackgroundTransparency = 1
        btn.Text = "  > " .. text
        btn.TextColor3 = TEXT_COLOR
        btn.Font = FONT
        btn.TextSize = 14
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.MouseButton1Click:Connect(callback)
    end

    function window:AddTextBox(text, placeholder, callback)
        local boxFrame = Instance.new("Frame", list)
        boxFrame.Size = UDim2.new(1, 0, 0, 40)
        boxFrame.BackgroundTransparency = 1

        local label = Instance.new("TextLabel", boxFrame)
        label.Size = UDim2.new(1, 0, 0, 18)
        label.Text = "  > " .. text
        label.TextColor3 = TEXT_COLOR
        label.Font = FONT
        label.TextSize = 13
        label.BackgroundTransparency = 1
        label.TextXAlignment = Enum.TextXAlignment.Left

        local input = Instance.new("TextBox", boxFrame)
        input.Size = UDim2.new(0.9, 0, 0, 18)
        input.Position = UDim2.new(0.05, 0, 0.5, 0)
        input.BackgroundColor3 = Color3.fromRGB(30,30,30)
        input.PlaceholderText = placeholder
        input.Text = ""
        input.TextColor3 = Color3.new(1,1,1)
        input.Font = FONT
        input.TextSize = 12
        input.BorderSizePixel = 0
        input.FocusLost:Connect(function(enter)
            if enter then callback(input.Text) end
        end)
    end

    function window:AddDropdown(text, list_items, callback)
        local expanded = false
        local dropFrame = Instance.new("Frame", list)
        dropFrame.Size = UDim2.new(1, 0, 0, 22)
        dropFrame.BackgroundTransparency = 1
        dropFrame.ClipsDescendants = true

        local btn = Instance.new("TextButton", dropFrame)
        btn.Size = UDim2.new(1, 0, 0, 22)
        btn.BackgroundTransparency = 1
        btn.Text = "  > " .. text .. ": ..."
        btn.TextColor3 = TEXT_COLOR
        btn.Font = FONT
        btn.TextSize = 14
        btn.TextXAlignment = Enum.TextXAlignment.Left

        local optionList = Instance.new("Frame", dropFrame)
        optionList.Size = UDim2.new(1, 0, 0, 0)
        optionList.Position = UDim2.new(0, 0, 0, 22)
        optionList.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        optionList.BackgroundTransparency = 0.5 -- Half transparent by default
        optionList.BorderSizePixel = 0
        table.insert(Library.DropdownFrames, optionList)
        Instance.new("UIListLayout", optionList)
        
        btn.MouseButton1Click:Connect(function()
            expanded = not expanded
            dropFrame.Size = UDim2.new(1, 0, 0, expanded and (22 + (#list_items * 20)) or 22)
            optionList.Size = UDim2.new(1, 0, 0, expanded and (#list_items * 20) or 0)
        end)

        for _, item in pairs(list_items) do
            local opt = Instance.new("TextButton", optionList)
            opt.Size = UDim2.new(1, 0, 0, 20)
            opt.BackgroundTransparency = 1
            opt.Text = tostring(item)
            opt.TextColor3 = Color3.fromRGB(200, 200, 200)
            opt.Font = FONT
            opt.TextSize = 13
            opt.MouseButton1Click:Connect(function()
                btn.Text = "  > " .. text .. ": " .. item
                callback(item)
            end)
        end
    end

    function window:AddKeybind(text, default, callback)
        local currentKey = default or Enum.KeyCode.F
        local binding = false
        local btn = Instance.new("TextButton", list)
        btn.Size = UDim2.new(1, 0, 0, 22)
        btn.BackgroundTransparency = 1
        btn.Text = "  > " .. text .. ": " .. currentKey.Name
        btn.TextColor3 = TEXT_COLOR
        btn.Font = FONT
        btn.TextSize = 14
        btn.TextXAlignment = Enum.TextXAlignment.Left

        btn.MouseButton1Click:Connect(function()
            binding = true
            btn.Text = "  > " .. text .. ": ..."
            Library.AccentObjects[btn] = true -- Force rainbow sync during bind
        end)

        UIS.InputBegan:Connect(function(input, gpe)
            if gpe then return end
            if binding and input.UserInputType == Enum.UserInputType.Keyboard then
                currentKey = input.KeyCode
                binding = false
                btn.Text = "  > " .. text .. ": " .. currentKey.Name
                Library.AccentObjects[btn] = nil -- Return to default text color after sync
                btn.TextColor3 = TEXT_COLOR
            elseif input.KeyCode == currentKey then
                callback()
            end
        end)
    end

    function window:AddSlider(text, min, max, default, callback)
        local sliderFrame = Instance.new("Frame", list)
        sliderFrame.Size = UDim2.new(1, 0, 0, 45) 
        sliderFrame.BackgroundTransparency = 1
        local label = Instance.new("TextLabel", sliderFrame)
        label.Size = UDim2.new(1, 0, 0, 22)
        label.Text = "  > " .. text .. ": " .. default
        label.TextColor3, label.Font, label.TextSize = TEXT_COLOR, FONT, 14
        label.BackgroundTransparency, label.TextXAlignment = 1, Enum.TextXAlignment.Left
        local bg = Instance.new("Frame", sliderFrame)
        bg.Size, bg.Position = UDim2.new(0.85, 0, 0, 8), UDim2.new(0.07, 0, 0.7, 0)
        bg.BackgroundColor3, bg.BorderSizePixel = Color3.fromRGB(40, 40, 40), 0
        local fill = Instance.new("Frame", bg)
        fill.Size = UDim2.new(math.clamp((default - min) / (max - min), 0, 1), 0, 1, 0)
        fill.BackgroundColor3, fill.BorderSizePixel = MAIN_COLOR, 0
        Library.AccentObjects[fill] = false
        sliderFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local conn
                conn = RunService.RenderStepped:Connect(function()
                    if not UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then conn:Disconnect() return end
                    local percent = math.clamp((UIS:GetMouseLocation().X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)
                    local value = math.floor(min + (max - min) * percent)
                    fill.Size = UDim2.new(percent, 0, 1, 0)
                    label.Text = "  > " .. text .. ": " .. value
                    callback(value)
                end)
            end
        end)
    end

    return window
end

function Library:SetRainbow(state)
    Library.RainbowActive = state
    if not state then
        task.wait(0.05)
        for obj, isText in pairs(Library.AccentObjects) do
            if isText then obj.TextColor3 = MAIN_COLOR else obj.BackgroundColor3 = MAIN_COLOR end
        end
    end
end

function Library:SetOpaque(state)
    Library.IsOpaque = state
    local winTrans = state and 0 or DEFAULT_TRANSPARENCY
    local dropTrans = state and 0 or 0.5
    for _, frame in pairs(Library.WindowFrames) do frame.BackgroundTransparency = winTrans end
    for _, frame in pairs(Library.DropdownFrames) do frame.BackgroundTransparency = dropTrans end
end

return Library
