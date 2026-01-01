-- Variables
local Library = {}
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- Styling
local TEXT_COLOR = Color3.fromRGB(255, 255, 255)
local MAIN_COLOR = Color3.fromRGB(130, 0, 255) 
local BG_TRANSPARENCY = 0.4 
local FONT = Enum.Font.SourceSansBold

-- Rainbow Logic Variables
Library.AccentObjects = {} -- Stores [Object] = isText (bool)
Library.RainbowActive = false
Library.CurrentColor = MAIN_COLOR
Library.BrandingLabel = nil -- Store reference to fix the color bug

-- Dragging logic
local function MakeDraggable(gui, handle)
	local dragging, dragInput, dragStart, startPos
	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = gui.Position
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

-- Global Rainbow Loop
task.spawn(function()
    local hue = 0
    while task.wait() do
        if Library.RainbowActive then
            hue = hue + (1/400) -- Speed of cycle
            if hue > 1 then hue = 0 end
            Library.CurrentColor = Color3.fromHSV(hue, 0.7, 1)
            
            for obj, isText in pairs(Library.AccentObjects) do
                if isText then
                    obj.TextColor3 = Library.CurrentColor
                else
                    obj.BackgroundColor3 = Library.CurrentColor
                end
            end
        end
    end
end)

function Library:Init(defaultKey)
	local sg = Instance.new("ScreenGui")
	sg.Name = "Ephemeral_UI"
	sg.ResetOnSpawn = false
	sg.Parent = player:WaitForChild("PlayerGui")

	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "Main"
	mainFrame.Size = UDim2.new(1, 0, 1, 0)
	mainFrame.BackgroundTransparency = 1
	mainFrame.Parent = sg

	-- Branding (Top Left)
	local brand = Instance.new("TextLabel")
	brand.Name = "Branding"
	brand.Text = "Ephemeral <font color='#A0A0A0'> </font>"
	brand.RichText = true
	brand.Font = FONT
	brand.TextSize = 26
	brand.TextColor3 = MAIN_COLOR
	brand.Position = UDim2.new(0, 15, 0, 15)
	brand.Size = UDim2.new(0, 200, 0, 30)
	brand.BackgroundTransparency = 1
	brand.TextXAlignment = Enum.TextXAlignment.Left
	brand.Parent = mainFrame
    
    -- Track branding reference and add to rainbow
    Library.BrandingLabel = brand
    Library.AccentObjects[brand] = true

	self.ToggleKey = defaultKey or Enum.KeyCode.RightControl
	local visible = true
	UIS.InputBegan:Connect(function(input, gpe)
		if not gpe and input.KeyCode == self.ToggleKey then
			visible = not visible
			mainFrame.Visible = visible
		end
	end)

	self.Container = mainFrame
	return self
end

function Library:NewWindow(title, xOffset)
	local window = {}
	local column = Instance.new("Frame")
	column.Size = UDim2.new(0, 140, 0, 0)
	column.Position = UDim2.new(0, xOffset or 15, 0, 60)
	column.AutomaticSize = Enum.AutomaticSize.Y
	column.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	column.BackgroundTransparency = BG_TRANSPARENCY
	column.BorderSizePixel = 0
	column.Parent = self.Container

	local header = Instance.new("Frame")
	header.Size = UDim2.new(1, 0, 0, 26)
	header.BackgroundColor3 = MAIN_COLOR
	header.BorderSizePixel = 0
	header.Parent = column
    Library.AccentObjects[header] = false -- Add to rainbow (Background)
	
	local headerTitle = Instance.new("TextLabel")
    headerTitle.Size = UDim2.new(1, 0, 1, 0)
    headerTitle.BackgroundTransparency = 1
    headerTitle.Text = title
    headerTitle.TextColor3 = Color3.new(1, 1, 1)
    headerTitle.Font = FONT
    headerTitle.TextSize = 15
    headerTitle.Parent = header

	MakeDraggable(column, header)

	local list = Instance.new("Frame")
	list.Size = UDim2.new(1, 0, 0, 0)
	list.Position = UDim2.new(0, 0, 0, 26)
	list.AutomaticSize = Enum.AutomaticSize.Y
	list.BackgroundTransparency = 1
	list.Parent = column
    
	local vLayout = Instance.new("UIListLayout")
	vLayout.SortOrder = Enum.SortOrder.LayoutOrder
	vLayout.Parent = list

	function window:AddToggle(text, callback)
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1, 0, 0, 22)
		btn.BackgroundTransparency = 1
		btn.Text = "  > " .. text
		btn.TextColor3 = TEXT_COLOR
		btn.Font = FONT
		btn.TextSize = 14
		btn.TextXAlignment = Enum.TextXAlignment.Left
		btn.Parent = list
		
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
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1, 0, 0, 22)
		btn.BackgroundTransparency = 1
		btn.Text = "  > " .. text
		btn.TextColor3 = TEXT_COLOR
		btn.Font = FONT
		btn.TextSize = 14
		btn.TextXAlignment = Enum.TextXAlignment.Left
		btn.Parent = list

		btn.MouseButton1Click:Connect(function()
			btn.TextColor3 = Library.CurrentColor
			task.delay(0.3, function()
				btn.TextColor3 = TEXT_COLOR
			end)
			callback()
		end)
	end

	return window
end

-- The new function to handle the Rainbowify toggle
function Library:SetRainbow(state)
    Library.RainbowActive = state
    if not state then
        -- RESET LOGIC
        -- 1. Reset branding specifically
        if Library.BrandingLabel then
            Library.BrandingLabel.TextColor3 = MAIN_COLOR
        end
        
        -- 2. Reset all other tracked objects
        for obj, isText in pairs(Library.AccentObjects) do
            if isText then
                -- If it's a button and turned on, it should be Purple. Branding handled above.
                obj.TextColor3 = MAIN_COLOR
            else
                -- Headers go back to Purple
                obj.BackgroundColor3 = MAIN_COLOR
            end
        end
    end
end

return Library
