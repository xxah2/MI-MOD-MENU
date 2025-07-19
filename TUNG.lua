-- 📜 MOD MENU INTERACTIVO (KRNL Android Friendly)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")

-- 🧠 Estados
local noclipEnabled = false
local speedEnabled = false
local originalSpeed = 16
local fastSpeed = 50

-- 🖼 GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "ModMenu"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 180, 0, 160)
Frame.Position = UDim2.new(0, 10, 0, 200)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BackgroundTransparency = 0.2
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

local title = Instance.new("TextLabel", Frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "⚙️ MOD MENU"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16

-- 🔘 Noclip Button
local noclipButton = Instance.new("TextButton", Frame)
noclipButton.Size = UDim2.new(1, -20, 0, 30)
noclipButton.Position = UDim2.new(0, 10, 0, 40)
noclipButton.Text = "🔄 Activar Noclip"
noclipButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
noclipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
noclipButton.Font = Enum.Font.Gotham
noclipButton.TextSize = 14

-- 🚀 Speed Button
local speedButton = Instance.new("TextButton", Frame)
speedButton.Size = UDim2.new(1, -20, 0, 30)
speedButton.Position = UDim2.new(0, 10, 0, 80)
speedButton.Text = "⚡ Activar Speed"
speedButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
speedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
speedButton.Font = Enum.Font.Gotham
speedButton.TextSize = 14

-- 🔄 Función Noclip
RunService.Stepped:Connect(function()
	if noclipEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)

noclipButton.MouseButton1Click:Connect(function()
	noclipEnabled = not noclipEnabled
	noclipButton.Text = noclipEnabled and "❌ Desactivar Noclip" or "🔄 Activar Noclip"
end)

-- 🏃‍♂️ Speed Handler
speedButton.MouseButton1Click:Connect(function()
	speedEnabled = not speedEnabled
	if speedEnabled then
		LocalPlayer.Character.Humanoid.WalkSpeed = fastSpeed
		speedButton.Text = "❌ Desactivar Speed"
	else
		LocalPlayer.Character.Humanoid.WalkSpeed = originalSpeed
		speedButton.Text = "⚡ Activar Speed"
	end
end)
