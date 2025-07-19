-- Servicios
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- GUI principal
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "BrainrotModMenu"

-- Bola negra
local ball = Instance.new("TextButton")
ball.Size = UDim2.new(0, 60, 0, 60)
ball.Position = UDim2.new(0, 20, 0.5, -30)
ball.BackgroundColor3 = Color3.new(0, 0, 0)
ball.Text = ""
ball.BorderSizePixel = 0
ball.AutoButtonColor = true
ball.Draggable = true
ball.Parent = gui

-- Frame del menú
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 220, 0, 230)
menu.Position = UDim2.new(0, 90, 0.5, -115)
menu.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
menu.BorderSizePixel = 0
menu.Visible = false
menu.Parent = gui

local title = Instance.new("TextLabel", menu)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Brainrot Mod Menu"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 22
title.BackgroundTransparency = 1

-- Velocidad
local speed = 16
local speedBtn = Instance.new("TextButton", menu)
speedBtn.Position = UDim2.new(0, 10, 0, 50)
speedBtn.Size = UDim2.new(1, -20, 0, 40)
speedBtn.Text = "Speed: " .. speed
speedBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
speedBtn.TextColor3 = Color3.new(1,1,1)
speedBtn.Font = Enum.Font.SourceSansBold
speedBtn.TextSize = 18

-- ESP de temporizador en bases
local baseEsp = false
local baseBtn = Instance.new("TextButton", menu)
baseBtn.Position = UDim2.new(0, 10, 0, 100)
baseBtn.Size = UDim2.new(1, -20, 0, 40)
baseBtn.Text = "ESP Bases: OFF"
baseBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
baseBtn.TextColor3 = Color3.new(1,1,1)
baseBtn.Font = Enum.Font.SourceSansBold
baseBtn.TextSize = 18

-- ESP jugadores
local playerEsp = false
local playerBtn = Instance.new("TextButton", menu)
playerBtn.Position = UDim2.new(0, 10, 0, 150)
playerBtn.Size = UDim2.new(1, -20, 0, 40)
playerBtn.Text = "ESP Jugadores: OFF"
playerBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
playerBtn.TextColor3 = Color3.new(1,1,1)
playerBtn.Font = Enum.Font.SourceSansBold
playerBtn.TextSize = 18

-- Toggle menú
ball.MouseButton1Click:Connect(function()
    menu.Visible = not menu.Visible
end)

-- Aumentar velocidad
speedBtn.MouseButton1Click:Connect(function()
    speed = speed + 4
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = speed
    end
    speedBtn.Text = "Speed: " .. speed
end)

-- Toggle ESP bases
baseBtn.MouseButton1Click:Connect(function()
    baseEsp = not baseEsp
    baseBtn.Text = "ESP Bases: " .. (baseEsp and "ON" or "OFF")
end)

-- Toggle ESP jugadores
playerBtn.MouseButton1Click:Connect(function()
    playerEsp = not playerEsp
    playerBtn.Text = "ESP Jugadores: " .. (playerEsp and "ON" or "OFF")
end)

-- Función para crear ESP
local function makeESP(parent, text, color)
    if parent:FindFirstChild("ESP") then return end
    local bb = Instance.new("BillboardGui", parent)
    bb.Name = "ESP"
    bb.Adornee = parent
    bb.Size = UDim2.new(0, 120, 0, 40)
    bb.AlwaysOnTop = true
    local lbl = Instance.new("TextLabel", bb)
    lbl.Size = UDim2.new(1,0,1,0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = color
    lbl.TextStrokeTransparency = 0
    lbl.TextScaled = true
    lbl.Text = text
end

-- Refrescar ESPs
RunService.RenderStepped:Connect(function()
    -- ESP bases
    if baseEsp then
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("TextButton") and obj.Text:lower():match("locked") or tonumber(obj.Text) then
                local remaining = obj.Text
                makeESP(obj, remaining, Color3.new(0,1,0))
            end
        end
    else
        for _, esp in ipairs(Workspace:GetDescendants()) do
            if esp.Name == "ESP" and esp.Adornee and esp.Adornee:IsA("TextButton") then
                esp:Destroy()
            end
        end
    end

    -- ESP jugadores
    if playerEsp then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and not plr.Character:FindFirstChild("ESP") then
                local head = plr.Character:FindFirstChild("Head")
                if head then
                    makeESP(head, plr.Name, Color3.new(1,0,0))
                end
            end
        end
    else
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Character and plr.Character:FindFirstChild("ESP") then
                plr.Character:FindFirstChild("ESP"):Destroy()
            end
        end
    end
end)
