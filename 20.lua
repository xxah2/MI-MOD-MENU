local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- GUI principal
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "BallModMenu"

-- Bola negra flotante
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

-- Menú oculto
local MenuFrame = Instance.new("Frame")
MenuFrame.Size = UDim2.new(0, 200, 0, 180)
MenuFrame.Position = UDim2.new(0, 90, 0.5, -90)
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

-- Noclip botón
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

-- Speed botón (aumenta por pasos)
local SpeedBtn = Instance.new("TextButton")
SpeedBtn.Size = UDim2.new(1, -20, 0, 40)
SpeedBtn.Position = UDim2.new(0, 10, 0, 90)
SpeedBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SpeedBtn.TextColor3 = Color3.new(1,1,1)
SpeedBtn.Font = Enum.Font.SourceSansBold
SpeedBtn.TextSize = 20
SpeedBtn.Text = "Speed: 16"
SpeedBtn.BorderSizePixel = 0
SpeedBtn.Parent = MenuFrame

-- Estados
local noclipEnabled = false
local currentSpeed = 16

-- Mostrar menú al pulsar la bola
BallButton.MouseButton1Click:Connect(function()
	MenuFrame.Visible = not MenuFrame.Visible
end)

-- Activar/desactivar noclip
NoclipBtn.MouseButton1Click:Connect(function()
	noclipEnabled = not noclipEnabled
	NoclipBtn.Text = "Noclip: " .. (noclipEnabled and "ON" or "OFF")
end)

-- Noclip funcional
RunService.Stepped:Connect(function()
	if noclipEnabled and LocalPlayer.Character then
		for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)

-- Aumentar velocidad cada vez que se hace clic
SpeedBtn.MouseButton1Click:Connect(function()
	currentSpeed += 4
	if currentSpeed > 100 then
		currentSpeed = 16
	end
	SpeedBtn.Text = "Speed: " .. tostring(currentSpeed)

	local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.WalkSpeed = currentSpeed
	end
end)

-- Reaplicar velocidad tras morir
LocalPlayer.CharacterAdded:Connect(function(char)
	char:WaitForChild("Humanoid").WalkSpeed = currentSpeed
end)
