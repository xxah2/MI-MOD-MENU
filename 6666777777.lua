local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- GUI
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "ModMenu"

local BallButton = Instance.new("TextButton")
BallButton.Size = UDim2.new(0, 60, 0, 60)
BallButton.Position = UDim2.new(0, 20, 0.5, -30)
BallButton.BackgroundColor3 = Color3.new(0, 0, 0)
BallButton.Text = ""
BallButton.BorderSizePixel = 0
BallButton.Draggable = true
BallButton.Active = true
BallButton.Parent = ScreenGui

local MenuFrame = Instance.new("Frame")
MenuFrame.Size = UDim2.new(0, 200, 0, 200)
MenuFrame.Position = UDim2.new(0, 90, 0.5, -100)
MenuFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MenuFrame.BorderSizePixel = 0
MenuFrame.Visible = false
MenuFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "Mod Menu"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 22
Title.Parent = MenuFrame

-- Noclip
local NoclipBtn = Instance.new("TextButton")
NoclipBtn.Size = UDim2.new(1, -20, 0, 40)
NoclipBtn.Position = UDim2.new(0, 10, 0, 40)
NoclipBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
NoclipBtn.TextColor3 = Color3.new(1,1,1)
NoclipBtn.Font = Enum.Font.SourceSansBold
NoclipBtn.TextSize = 20
NoclipBtn.Text = "Noclip: OFF"
NoclipBtn.BorderSizePixel = 0
NoclipBtn.Parent = MenuFrame

-- Fly Toggle
local FlyBtn = Instance.new("TextButton")
FlyBtn.Size = UDim2.new(1, -20, 0, 40)
FlyBtn.Position = UDim2.new(0, 10, 0, 90)
FlyBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
FlyBtn.TextColor3 = Color3.new(1,1,1)
FlyBtn.Font = Enum.Font.SourceSansBold
FlyBtn.TextSize = 20
FlyBtn.Text = "Fly: OFF"
FlyBtn.BorderSizePixel = 0
FlyBtn.Parent = MenuFrame

-- Velocidad
local SpeedBox = Instance.new("TextBox")
SpeedBox.Size = UDim2.new(1, -20, 0, 30)
SpeedBox.Position = UDim2.new(0, 10, 0, 140)
SpeedBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SpeedBox.TextColor3 = Color3.new(1,1,1)
SpeedBox.Text = "Fly Speed: 100"
SpeedBox.Font = Enum.Font.SourceSans
SpeedBox.TextSize = 18
SpeedBox.ClearTextOnFocus = false
SpeedBox.Parent = MenuFrame

-- Estados
local noclipEnabled = false
local flyEnabled = false
local jumpHeld = false
local flySpeed = 100
local bodyVelocity = nil

-- Mostrar menú
BallButton.MouseButton1Click:Connect(function()
	MenuFrame.Visible = not MenuFrame.Visible
end)

-- Noclip toggle
NoclipBtn.MouseButton1Click:Connect(function()
	noclipEnabled = not noclipEnabled
	NoclipBtn.Text = "Noclip: " .. (noclipEnabled and "ON" or "OFF")
end)

-- Fly toggle
FlyBtn.MouseButton1Click:Connect(function()
	flyEnabled = not flyEnabled
	FlyBtn.Text = "Fly: " .. (flyEnabled and "ON" or "OFF")
	if not flyEnabled and bodyVelocity then
		bodyVelocity:Destroy()
		bodyVelocity = nil
	end
end)

-- Velocidad
SpeedBox.FocusLost:Connect(function()
	local val = tonumber(SpeedBox.Text:match("%d+"))
	if val then
		flySpeed = math.clamp(val, 10, 300)
		SpeedBox.Text = "Fly Speed: " .. flySpeed
	end
end)

-- Tecla de salto (space o touch)
UserInputService.InputBegan:Connect(function(input, gpe)
	if input.KeyCode == Enum.KeyCode.Space or input.UserInputType == Enum.UserInputType.Touch then
		jumpHeld = true
	end
end)
UserInputService.InputEnded:Connect(function(input, gpe)
	if input.KeyCode == Enum.KeyCode.Space or input.UserInputType == Enum.UserInputType.Touch then
		jumpHeld = false
	end
end)

-- Noclip
RunService.Stepped:Connect(function()
	if noclipEnabled and LocalPlayer.Character then
		for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)

-- Fly hacia adelante (solo si mantenés salto)
RunService.RenderStepped:Connect(function()
	if flyEnabled and jumpHeld and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local hrp = LocalPlayer.Character.HumanoidRootPart
		local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if not bodyVelocity or not bodyVelocity.Parent then
			bodyVelocity = Instance.new("BodyVelocity")
			bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
			bodyVelocity.Velocity = Vector3.zero
			bodyVelocity.P = 5000
			bodyVelocity.Parent = hrp
		end
		local moveDir = humanoid.MoveDirection
		bodyVelocity.Velocity = moveDir * flySpeed
	elseif bodyVelocity then
		bodyVelocity.Velocity = Vector3.zero
	end
end)
