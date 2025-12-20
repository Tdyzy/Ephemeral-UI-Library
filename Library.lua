-- Variables
local Library = {}
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- Styling
local PURPLE = Color3.fromRGB(130, 0, 255)
local BG_COLOR = Color3.fromRGB(30, 30, 30)
local TEXT_COLOR = Color3.fromRGB(220, 220, 220)
local FONT = Enum.Font.SourceSansBold

-- Dragging logic
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

function Library:Init(defaultKey)
	local sg = Instance.new("ScreenGui")
	sg.Name = "Ephemeral_Lib"
	sg.ResetOnSpawn = false
	sg.Parent = player:WaitForChild("PlayerGui")

	local mainContainer = Instance.new("Frame")
	mainContainer.Name = "Main"
	mainContainer.Size = UDim2.new(1, 0, 1, 0)
	mainContainer.BackgroundTransparency = 1
	mainContainer.Parent = sg

	-- Branding
	local brandFrame = Instance.new("Frame")
	brandFrame.Size = UDim2.new(0, 300, 0, 50)
	brandFrame.Position = UDim2.new(0, 20, 0, 20)
	brandFrame.BackgroundTransparency = 1
	brandFrame.Parent = mainContainer

	local mainTitle = Instance.new("TextLabel")
	mainTitle.Text = "ephemeral"
	mainTitle.Size = UDim2.new(0, 0, 1, 0)
	mainTitle.AutomaticSize = Enum.AutomaticSize.X
	mainTitle.Font = FONT
	mainTitle.TextSize = 35
	mainTitle.TextColor3 = PURPLE
	mainTitle.TextXAlignment = Enum.TextXAlignment.Left
	mainTitle.BackgroundTransparency = 1
	mainTitle.Parent = brandFrame

	local subTitle = Instance.new("TextLabel")
	subTitle.Text = "v1.0.0"
	subTitle.Size = UDim2.new(0, 0, 1, 0)
	subTitle.Position = UDim2.new(1, 10, 0, 5)
	subTitle.AutomaticSize = Enum.AutomaticSize.X
	subTitle.Font = Enum.Font.SourceSans
	subTitle.TextSize = 18
	subTitle.TextColor3 = Color3.fromRGB(150, 150, 150)
	subTitle.TextXAlignment = Enum.TextXAlignment.Left
	subTitle.BackgroundTransparency = 1
	subTitle.Parent = mainTitle

	self.ToggleKey = defaultKey or Enum.KeyCode.RightControl
	local visible = true
	UIS.InputBegan:Connect(function(input, gpe)
		if not gpe and input.KeyCode == self.ToggleKey then
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
	column.Size = UDim2.new(0, 170, 0, 30) -- Slightly wider for better slider look
	column.Position = startPos or UDim2.new(0.1, 0, 0.2, 0)
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
	MakeDraggable(column, header)

	local list = Instance.new("Frame")
	list.Name = "Container"
	list.Size = UDim2.new(1, 0, 0, 0)
	list.Position = UDim2.new(0, 0, 0, 32) -- Start below header
	list.AutomaticSize = Enum.AutomaticSize.Y
	list.BackgroundTransparency = 1
	list.Parent = column

	local layout = Instance.new("UIListLayout")
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 8) -- Space between elements
	layout.Parent = list
	
	Instance.new("UIPadding", list).PaddingLeft = UDim.new(0, 10)

	function window:AddLabel(text)
		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(0.9, 0, 0, 18)
		label.BackgroundTransparency = 1
		label.Text = text
		label.TextColor3 = Color3.fromRGB(180, 180, 180)
		label.Font = Enum.Font.SourceSansItalic
		label.TextSize = 14
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Parent = list
	end

	function window:AddButton(text, callback)
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(0.9, 0, 0, 22)
		btn.BackgroundTransparency = 1
		btn.Text = "[ " .. text .. " ]"
		btn.TextColor3 = TEXT_COLOR
		btn.Font = FONT
		btn.TextSize = 15
		btn.TextXAlignment = Enum.TextXAlignment.Left
		btn.Parent = list
		btn.MouseButton1Click:Connect(function()
			btn.TextColor3 = PURPLE task.wait(0.1) btn.TextColor3 = TEXT_COLOR
			callback()
		end)
	end

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
		sliderFrame.Size = UDim2.new(0.9, 0, 0, 38)
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
		barBg.Size = UDim2.new(1, 0, 0, 6)
		barBg.Position = UDim2.new(0, 0, 0, 24)
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
		barBg.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true update() end end)
		UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
		UIS.InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then update() end end)
	end

	function window:AddKeybind(text, default, libObj)
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(0.9, 0, 0, 22)
		btn.BackgroundTransparency = 1
		btn.Text = text .. ": " .. default.Name
		btn.TextColor3 = TEXT_COLOR
		btn.Font = FONT
		btn.TextSize = 15
		btn.TextXAlignment = Enum.TextXAlignment.Left
		btn.Parent = list
		btn.MouseButton1Click:Connect(function()
			btn.Text = "... Press a Key ..."
			local inputWait;
			inputWait = UIS.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.Keyboard then
					libObj.ToggleKey = input.KeyCode
					btn.Text = text .. ": " .. input.KeyCode.Name
					inputWait:Disconnect()
				end
			end)
		end)
	end

	return window
end

return Library
