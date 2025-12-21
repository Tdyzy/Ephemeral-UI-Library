-- Ephemeral variables
local Library = {}
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- Styling Constants
local PURPLE_COLOR = Color3.fromRGB(130, 0, 255)
local OFF_WHITE_COLOR = Color3.fromRGB(220, 220, 220)
local BACKGROUND_COLOR = Color3.fromRGB(30, 30, 30)
local UI_FONT = Enum.Font.SourceSansBold

function Library:Init(menuData, defaultKey)
	local sg = Instance.new("ScreenGui")
	sg.Name = "Ephemeral_V2"
	sg.ResetOnSpawn = false
	sg.Parent = player:WaitForChild("PlayerGui")

	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainContainer"
	mainFrame.Size = UDim2.new(0, 800, 0, 300)
	mainFrame.Position = UDim2.new(0.5, -400, 0.1, 0)
	mainFrame.BackgroundTransparency = 1
	mainFrame.Parent = sg

	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Horizontal
	layout.Padding = UDim.new(0, 6)
	layout.Parent = mainFrame

	-- Menu Toggle Logic
	local toggleKey = defaultKey or Enum.KeyCode.RightControl
	local visible = true
	UIS.InputBegan:Connect(function(input, gpe)
		if not gpe and input.KeyCode == toggleKey then
			visible = not visible
			mainFrame.Visible = visible
		end
	end)

	-- Branding
	local brand = Instance.new("TextLabel")
	brand.Text = "ephemeral"
	brand.Font = UI_FONT
	brand.TextSize = 40
	brand.TextColor3 = PURPLE_COLOR
	brand.Position = UDim2.new(0, 0, 0, -60)
	brand.Size = UDim2.new(0, 200, 0, 50)
	brand.BackgroundTransparency = 1
	brand.TextXAlignment = Enum.TextXAlignment.Left
	brand.Parent = mainFrame

	-- Internal function to create columns
	local function createColumn(data)
		local columnBg = Instance.new("Frame")
		columnBg.Name = data.Title .. "_Col"
		columnBg.Size = UDim2.new(0, 140, 0, 0)
		columnBg.AutomaticSize = Enum.AutomaticSize.Y
		columnBg.BackgroundColor3 = BACKGROUND_COLOR
		columnBg.BackgroundTransparency = 0.1
		columnBg.BorderSizePixel = 0
		columnBg.Parent = mainFrame

		local header = Instance.new("TextLabel")
		header.Size = UDim2.new(1, 0, 0, 30)
		header.BackgroundColor3 = PURPLE_COLOR
		header.BorderSizePixel = 0
		header.Text = data.Title:upper()
		header.TextColor3 = Color3.new(1, 1, 1)
		header.Font = UI_FONT
		header.TextSize = 16
		header.Parent = columnBg

		local listContainer = Instance.new("Frame")
		listContainer.Size = UDim2.new(1, 0, 0, 0)
		listContainer.Position = UDim2.new(0, 0, 0, 30)
		listContainer.AutomaticSize = Enum.AutomaticSize.Y
		listContainer.BackgroundTransparency = 1
		listContainer.Parent = columnBg

		local vLayout = Instance.new("UIListLayout")
		vLayout.SortOrder = Enum.SortOrder.LayoutOrder
		vLayout.Padding = UDim.new(0, 0)
		vLayout.Parent = listContainer

		for _, item in ipairs(data.Items) do
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1, 0, 0, 26)
			btn.BackgroundTransparency = 1
			btn.Text = "> " .. item.Name
			btn.TextColor3 = OFF_WHITE_COLOR
			btn.Font = UI_FONT
			btn.TextSize = 14
			btn.TextXAlignment = Enum.TextXAlignment.Left
			btn.Parent = listContainer

			local btnPadding = Instance.new("UIPadding")
			btnPadding.PaddingLeft = UDim.new(0, 10)
			btnPadding.Parent = btn

			local toggled = false
			btn.MouseButton1Click:Connect(function()
				toggled = not toggled
				btn.TextColor3 = toggled and PURPLE_COLOR or OFF_WHITE_COLOR
				if item.Callback then item.Callback(toggled) end
			end)
		end
	end

	-- Build all columns
	for _, data in ipairs(menuData) do
		createColumn(data)
	end
end

return Library
