local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- GUI
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "BallModMenu"

-- Bola negra
local BallButton = Instance.new("TextButton")
BallButton.Size = UDim2.new(0, 60, 0, 60)
BallButton.Position = UDim2.new(0, 20, 0.5, -30)
BallButton.BackgroundColor3 = Color3.new(0, 0, 0)
BallButton.Text = ""
BallButton.BorderSizePixel = 0
BallButton.AutoButtonColor = true
BallButton.Draggable = true
BallButton.Active = true
BallButton.Parent = ScreenGui

-- Frame del menú
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

-- Fly toggle
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

-- Slider de velocidad
local SpeedSlider = Instance.new("TextBox")
SpeedSlider.Size = UDim2.new(1, -20, 0, 30)
SpeedSlider.Position = UDim2.new(0, 10, 0, 140)
SpeedSlider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SpeedSlider.TextColor3 = Color3.new(1,1,1)
SpeedSlider.Text = "Fly Speed: 100"
SpeedSlider.Font = Enum.Font.SourceSans
SpeedSlider.TextSize = 18
SpeedSlider.ClearTextOnFocus = false
SpeedSlider.Parent = MenuFrame

-- Estados
local noclipEnabled = false
local flyEnabled = false
local jumpHeld = false
local flySpeed = 100
local BodyGyro, BodyVelocity

-- Toggle menú
BallButton.MouseButton1Click:Connect(function()
	MenuFrame.Visible = not MenuFrame.Visible
end)

-- Noclip funcional
NoclipBtn.MouseButton1Click:Connect(function()
	noclipEnabled = not noclipEnabled
	NoclipBtn.Text = "Noclip: " .. (noclipEnabled and "ON" or "OFF")
end)

-- Fly activador
FlyBtn.MouseButton1Click:Connect(function()
	flyEnabled = not flyEnabled
	FlyBtn.Text = "Fly: " .. (flyEnabled and "ON" or "OFF")
	if not flyEnabled then
		if BodyGyro then BodyGyro:Destroy() end
		if BodyVelocity then BodyVelocity:Destroy() end
	end
end)

-- Velocidad ajustable
SpeedSlider.FocusLost:Connect(function()
	local val = tonumber(SpeedSlider.Text:match("%d+"))
	if val then
		flySpeed = math.clamp(val, 10, 500)
		SpeedSlider.Text = "Fly Speed: " .. flySpeed
	end
end)

-- Detección de salto presionado
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

-- Loop Noclip
RunService.Stepped:Connect(function()
	if noclipEnabled and LocalPlayer.Character then
		for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)

-- Loop Fly funcional
RunService.RenderStepped:Connect(function()
	if flyEnabled and jumpHeld and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local HRP = LocalPlayer.Character.HumanoidRootPart

		if not BodyGyro then
			BodyGyro = Instance.new("BodyGyro")
			BodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
			BodyGyro.P = 20000
			BodyGyro.CFrame = workspace.CurrentCamera.CFrame
			BodyGyro.Parent = HRP
		else
			BodyGyro.CFrame = workspace.CurrentCamera.CFrame
		end

		if not BodyVelocity then
			BodyVelocity = Instance.new("BodyVelocity")
			BodyVelocity.Velocity = Vector3.new(0, 0, 0)
			BodyVelocity.MaxForce = Vector3.new(400000, 400000, 400000)
			BodyVelocity.P = 10000
			BodyVelocity.Parent = HRP
		end

		local direction = workspace.CurrentCamera.CFrame.LookVector
		BodyVelocity.Velocity = direction * flySpeed
	else
		if BodyVelocity then BodyVelocity.Velocity = Vector3.zero end
	end
end)
