-- Tdyyyz UI Library
-- Features: Draggable, Keybind Toggle, Toggles, Sliders
local Library = {}
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- Styling
local PURPLE = Color3.fromRGB(130, 0, 255)
local BG_COLOR = Color3.fromRGB(30, 30, 30)
local TEXT_COLOR = Color3.fromRGB(220, 220, 220)
local FONT = Enum.Font.SourceSansBold

-- Dragging function
local function MakeDraggable(gui, handle)
	local dragging, dragInput, dragStart, startPos
	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = gui.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	handle.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
	end)
	UIS.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

function Library:Init(toggleKey)
	local sg = Instance.new("ScreenGui")
	sg.Name = "JailbreakHaxx_Lib"
	sg.ResetOnSpawn = false
	sg.Parent = player:WaitForChild("PlayerGui")

	local mainContainer = Instance.new("Frame")
	mainContainer.Name = "Main"
	mainContainer.Size = UDim2.new(1, 0, 1, 0)
	mainContainer.BackgroundTransparency = 1
	mainContainer.Parent = sg

	-- Toggle GUI Visibility
	local visible = true
	local key = toggleKey or Enum.KeyCode.RightControl
	UIS.InputBegan:Connect(function(input, gpe)
		if not gpe and input.KeyCode == key then
			visible = not visible
			mainContainer.Visible = visible
		end
	end)

	self.Container = mainContainer
	return self
end

function Library:NewWindow(title, startPos)
	local window = {}
	local column = Instance.new("Frame")
	column.Name = title
	column.Size = UDim2.new(0, 150, 0, 0)
	column.Position = startPos or UDim2.new(0.1, 0, 0.1, 0)
	column.AutomaticSize = Enum.AutomaticSize.Y
	column.BackgroundColor3 = BG_COLOR
	column.BackgroundTransparency = 0.2
	column.BorderSizePixel = 0
	column.Parent = self.Container

	local header = Instance.new("TextLabel")
	header.Size = UDim2.new(1, 0, 0, 28)
	header.BackgroundColor3 = PURPLE
	header.Text = title
	header.TextColor3 = Color3.new(1, 1, 1)
	header.Font = FONT
	header.TextSize = 17
	header.Parent = column
	
	MakeDraggable(column, header) -- Draggable by the top

	local list = Instance.new("Frame")
	list.Size = UDim2.new(1, 0, 0, 0)
	list.Position = UDim2.new(0, 0, 0, 28)
	list.AutomaticSize = Enum.AutomaticSize.Y
	list.BackgroundTransparency = 1
	list.Parent = column

	local vLayout = Instance.new("UIListLayout")
	vLayout.Padding = UDim.new(0, 5)
	vLayout.Parent = list
	Instance.new("UIPadding", list).PaddingLeft = UDim.new(0, 10)

	function window:AddToggle(text, callback)
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(0.9, 0, 0, 22)
		btn.BackgroundTransparency = 1
		btn.Text = "> " .. text
		btn.TextColor3 = TEXT_COLOR
		btn.Font = FONT
		btn.TextSize = 15
		btn.TextXAlignment = Enum.TextXAlignment.Left
		btn.Parent = list

		local enabled = false
		btn.MouseButton1Click:Connect(function()
			enabled = not enabled
			btn.TextColor3 = enabled and PURPLE or TEXT_COLOR
			callback(enabled)
		end)
	end

	function window:AddSlider(text, min, max, default, callback)
		local sliderFrame = Instance.new("Frame")
		sliderFrame.Size = UDim2.new(0.9, 0, 0, 35)
		sliderFrame.BackgroundTransparency = 1
		sliderFrame.Parent = list

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, 0, 0, 15)
		label.BackgroundTransparency = 1
		label.Text = text .. ": " .. default
		label.TextColor3 = TEXT_COLOR
		label.Font = FONT
		label.TextSize = 14
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Parent = sliderFrame

		local barBg = Instance.new("Frame")
		barBg.Size = UDim2.new(1, 0, 0, 5)
		barBg.Position = UDim2.new(0, 0, 0, 22)
		barBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		barBg.BorderSizePixel = 0
		barBg.Parent = sliderFrame

		local barFill = Instance.new("Frame")
		barFill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
		barFill.BackgroundColor3 = PURPLE
		barFill.BorderSizePixel = 0
		barFill.Parent = barBg

		local dragging = false
		local function update()
			local percent = math.clamp((UIS:GetMouseLocation().X - barBg.AbsolutePosition.X) / barBg.AbsoluteSize.X, 0, 1)
			local value = math.floor(min + (max - min) * percent)
			barFill.Size = UDim2.new(percent, 0, 1, 0)
			label.Text = text .. ": " .. value
			callback(value)
		end

		barBg.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true update() end
		end)
		UIS.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
		end)
		UIS.InputChanged:Connect(function(input)
			if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then update() end
		end)
	end

	return window
end
