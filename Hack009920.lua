-- Mod Menu básico para Android KRNL
-- Aparece un botón flotante negro que al tocarlo abre menú con Speed y Noclip

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Variables
local speedValue = 16
local noclipEnabled = false

-- Crear GUI principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SimpleModMenu"
ScreenGui.Parent = game.CoreGui

-- Botón flotante negro
local floatingButton = Instance.new("TextButton")
floatingButton.Size = UDim2.new(0, 50, 0, 50)
floatingButton.Position = UDim2.new(0, 10, 0.5, -25)
floatingButton.BackgroundColor3 = Color3.new(0,0,0)
floatingButton.BackgroundTransparency = 0
floatingButton.Text = "Menu"
floatingButton.TextColor3 = Color3.new(1,1,1)
floatingButton.TextScaled = true
floatingButton.Parent = ScreenGui
floatingButton.ZIndex = 10

-- Frame menú oculto inicialmente
local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0, 200, 0, 150)
menuFrame.Position = UDim2.new(0, 70, 0.5, -75)
menuFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
menuFrame.BorderSizePixel = 0
menuFrame.Visible = false
menuFrame.Parent = ScreenGui
menuFrame.ZIndex = 10

-- Función para hacer draggable
local function makeDraggable(gui)
    local dragging, dragInput, dragStart, startPos

    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            gui.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

makeDraggable(floatingButton)
makeDraggable(menuFrame)

-- Toggle menú al tocar botón flotante
floatingButton.MouseButton1Click:Connect(function()
    menuFrame.Visible = not menuFrame.Visible
end)

-- Botón para cambiar velocidad
local speedButton = Instance.new("TextButton")
speedButton.Size = UDim2.new(0, 180, 0, 50)
speedButton.Position = UDim2.new(0, 10, 0, 10)
speedButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
speedButton.TextColor3 = Color3.new(1, 1, 1)
speedButton.Font = Enum.Font.GothamBold
speedButton.TextScaled = true
speedButton.Text = "Speed: "..speedValue
speedButton.Parent = menuFrame

speedButton.MouseButton1Click:Connect(function()
    speedValue = speedValue + 10
    if speedValue > 100 then
        speedValue = 16
    end
    speedButton.Text = "Speed: "..speedValue
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = speedValue
    end
end)

-- Botón para activar/desactivar noclip
local noclipButton = Instance.new("TextButton")
noclipButton.Size = UDim2.new(0, 180, 0, 50)
noclipButton.Position = UDim2.new(0, 10, 0, 70)
noclipButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
noclipButton.TextColor3 = Color3.new(1, 1, 1)
noclipButton.Font = Enum.Font.GothamBold
noclipButton.TextScaled = true
noclipButton.Text = "Noclip: OFF"
noclipButton.Parent = menuFrame

noclipButton.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    noclipButton.Text = noclipEnabled and "Noclip: ON" or "Noclip: OFF"
end)

-- Loop para noclip
RunService.Stepped:Connect(function()
    if noclipEnabled and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    elseif LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end)

-- Asegurar que la velocidad se mantenga (por si se resetea)
RunService.RenderStepped:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = speedValue
    end
end)
