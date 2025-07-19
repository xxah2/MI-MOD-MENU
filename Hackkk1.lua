local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local speed = 16

-- GUI Setup
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "ModMenu"

local Ball = Instance.new("TextButton")
Ball.Size = UDim2.new(0, 60, 0, 60)
Ball.Position = UDim2.new(0, 20, 0.5, -30)
Ball.BackgroundColor3 = Color3.new(0, 0, 0)
Ball.Text = ""
Ball.BorderSizePixel = 0
Ball.Draggable = true
Ball.Parent = gui

local Menu = Instance.new("Frame")
Menu.Size = UDim2.new(0, 200, 0, 250)
Menu.Position = UDim2.new(0, 90, 0.5, -100)
Menu.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Menu.Visible = false
Menu.Parent = gui

local function createBtn(text, y, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -20, 0, 40)
	btn.Position = UDim2.new(0, 10, 0, y)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 20
	btn.Text = text
	btn.Parent = Menu
	btn.MouseButton1Click:Connect(callback)
	return btn
end

-- Toggle menú
Ball.MouseButton1Click:Connect(function()
	Menu.Visible = not Menu.Visible
end)

-- Noclip
local noclip = false
createBtn("Noclip: OFF", 10, function(btn)
	noclip = not noclip
	btn.Text = "Noclip: " .. (noclip and "ON" or "OFF")
end)

-- Speed
createBtn("Aumentar Speed", 60, function()
	speed = speed + 5
	LocalPlayer.Character.Humanoid.WalkSpeed = speed
end)

-- ESP Jugadores
createBtn("ESP Jugadores", 110, function()
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character and not plr.Character:FindFirstChild("ESPTag") then
			local tag = Instance.new("BillboardGui", plr.Character)
			tag.Name = "ESPTag"
			tag.Size = UDim2.new(0, 100, 0, 20)
			tag.Adornee = plr.Character:FindFirstChild("Head")
			tag.AlwaysOnTop = true

			local label = Instance.new("TextLabel", tag)
			label.Size = UDim2.new(1,0,1,0)
			label.BackgroundTransparency = 1
			label.TextColor3 = Color3.new(1,0,0)
			label.TextStrokeTransparency = 0
			label.Text = plr.Name
		end
	end
end)

-- ESP Brainrot Bases y Secret
createBtn("ESP Bases & Brainrot", 160, function()
	for _, obj in ipairs(Workspace:GetDescendants()) do
		if obj:IsA("Model") and (obj.Name:lower():find("base") or obj.Name:lower():match("brainrot") or obj.Name:lower():find("madang") or obj.Name:lower():find("madunduung")) then
			if not obj:FindFirstChild("ESP") then
				local esp = Instance.new("BillboardGui", obj)
				esp.Name = "ESP"
				esp.Size = UDim2.new(0, 100, 0, 20)
				esp.Adornee = obj:FindFirstChildWhichIsA("BasePart")
				esp.AlwaysOnTop = true

				local label = Instance.new("TextLabel", esp)
				label.Size = UDim2.new(1,0,1,0)
				label.BackgroundTransparency = 1
				label.TextColor3 = Color3.new(0,1,0)
				label.TextStrokeTransparency = 0
				label.Text = obj.Name
			end
		end
	end
end)

-- Noclip Loop
RunService.Stepped:Connect(function()
	if noclip and LocalPlayer.Character then
		for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)
