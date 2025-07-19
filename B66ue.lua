local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
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
MenuFrame.Size = UDim2.new(0, 220, 0, 200)
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

-- Fly botón
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

-- Slider de velocidad vuelo
local SpeedSlider = Instance.new("TextBox")
SpeedSlider.Size = UDim2.new(1, -20, 0, 30)
SpeedSlider.Position = UDim2.new(0, 10, 0, 140)
SpeedSlider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SpeedSlider.TextColor3 = Color3.new(1,1,1)
SpeedSlider.Text = "Fly Speed: 50"
SpeedSlider.Font = Enum.Font.SourceSans
SpeedSlider.TextSize = 18
SpeedSlider.ClearTextOnFocus = false
SpeedSlider.Parent = MenuFrame

-- Estados
local noclipEnabled = false
local flyEnabled = false
local jumpHeld = false
local flySpeed = 50

-- Mostrar/ocultar menú
BallButton.MouseButton1Click:Connect(function()
	MenuFrame.Visible = not MenuFrame.Visible
end)

-- Toggle noclip
NoclipBtn.MouseButton1Click:Connect(function()
	noclipEnabled = not noclipEnabled
	NoclipBtn.Text = "Noclip: " .. (noclipEnabled and "ON" or "OFF")
end)

-- Toggle fly
FlyBtn.MouseButton1Click:Connect(function()
	flyEnabled = not flyEnabled
	FlyBtn.Text = "Fly: " .. (flyEnabled and "ON" or "OFF")
end)

-- Ajustar velocidad vuelo
SpeedSlider.FocusLost:Connect(function()
	local val = tonumber(SpeedSlider.Text:match("%d+"))
	if val then
		flySpeed = math.clamp(val, 10, 300)
		SpeedSlider.Text = "Fly Speed: " .. flySpeed
	end
end)

-- Detectar si salto está presionado
UserInputService.InputBegan:Connect(function(input, gpe)
	if (input.KeyCode == Enum.KeyCode.Space or input.UserInputType == Enum.UserInputType.Touch) and flyEnabled then
		jumpHeld = true
	end
end)

UserInputService.InputEnded:Connect(function(input, gpe)
	if (input.KeyCode == Enum.KeyCode.Space or input.UserInputType == Enum.UserInputType.Touch) then
		jumpHeld = false
	end
end)

-- Noclip loop
RunService.Stepped:Connect(function()
	if noclipEnabled and LocalPlayer.Character then
		for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)

-- Fly loop con movimiento vertical solo mientras se mantiene salto
RunService.RenderStepped:Connect(function()
	if flyEnabled and jumpHeld and LocalPlayer.Character then
		local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		if hrp then
			-- Sube verticalmente según flySpeed
			hrp.CFrame = hrp.CFrame + Vector3.new(0, flySpeed * RunService.RenderStepped:Wait(), 0)
		end
	end
end)
