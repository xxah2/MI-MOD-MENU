-- Brainrot Style Mod Menu

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Variables
local noclipEnabled = false
local speedValue = 16 -- speed default
local espBasesEnabled = false
local espPlayersEnabled = false

-- Tabla para guardar ESP de bases y jugadores
local baseESP = {}
local playerESP = {}

-- Crear GUI base
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BrainrotModMenu"
ScreenGui.Parent = game.CoreGui

-- Floating button para abrir/cerrar menú
local floatingButton = Instance.new("TextButton")
floatingButton.Size = UDim2.new(0, 50, 0, 50)
floatingButton.Position = UDim2.new(0, 10, 0.5, -25)
floatingButton.BackgroundColor3 = Color3.new(0, 0, 0)
floatingButton.TextColor3 = Color3.new(1, 1, 1)
floatingButton.Text = "Menu"
floatingButton.Parent = ScreenGui
floatingButton.ZIndex = 5
floatingButton.BackgroundTransparency = 0.4

-- Menú principal (oculto al inicio)
local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0, 220, 0, 220)
menuFrame.Position = UDim2.new(0, 70, 0.5, -110)
menuFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
menuFrame.BorderSizePixel = 0
menuFrame.Visible = false
menuFrame.Parent = ScreenGui
menuFrame.ZIndex = 5

-- Función para hacer draggable el botón y el menú
local function makeDraggable(guiObject)
    local dragging, dragInput, dragStart, startPos

    guiObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = guiObject.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    guiObject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    RunService.Heartbeat:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            guiObject.Position = UDim2.new(
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

-- Toggle menú
floatingButton.MouseButton1Click:Connect(function()
    menuFrame.Visible = not menuFrame.Visible
end)

-- Botón Speed
local speedButton = Instance.new("TextButton")
speedButton.Size = UDim2.new(0, 200, 0, 40)
speedButton.Position = UDim2.new(0, 10, 0, 10)
speedButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedButton.TextColor3 = Color3.new(1,1,1)
speedButton.Text = "Speed: "..speedValue
speedButton.Parent = menuFrame

speedButton.MouseButton1Click:Connect(function()
    speedValue = speedValue + 4
    if speedValue > 100 then speedValue = 16 end
    speedButton.Text = "Speed: "..speedValue
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = speedValue
    end
end)

-- Toggle Noclip
local noclipButton = Instance.new("TextButton")
noclipButton.Size = UDim2.new(0, 200, 0, 40)
noclipButton.Position = UDim2.new(0, 10, 0, 60)
noclipButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
noclipButton.TextColor3 = Color3.new(1,1,1)
noclipButton.Text = "Noclip: OFF"
noclipButton.Parent = menuFrame

noclipButton.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    noclipButton.Text = noclipEnabled and "Noclip: ON" or "Noclip: OFF"
end)

-- Toggle ESP Bases
local espBasesButton = Instance.new("TextButton")
espBasesButton.Size = UDim2.new(0, 200, 0, 40)
espBasesButton.Position = UDim2.new(0, 10, 0, 110)
espBasesButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
espBasesButton.TextColor3 = Color3.new(1,1,1)
espBasesButton.Text = "ESP Bases: OFF"
espBasesButton.Parent = menuFrame

espBasesButton.MouseButton1Click:Connect(function()
    espBasesEnabled = not espBasesEnabled
    espBasesButton.Text = espBasesEnabled and "ESP Bases: ON" or "ESP Bases: OFF"
    if not espBasesEnabled then
        -- Limpiar ESP bases cuando se apaga
        for _, gui in pairs(baseESP) do
            gui:Destroy()
        end
        baseESP = {}
    end
end)

-- Toggle ESP Jugadores
local espPlayersButton = Instance.new("TextButton")
espPlayersButton.Size = UDim2.new(0, 200, 0, 40)
espPlayersButton.Position = UDim2.new(0, 10, 0, 160)
espPlayersButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
espPlayersButton.TextColor3 = Color3.new(1,1,1)
espPlayersButton.Text = "ESP Players: OFF"
espPlayersButton.Parent = menuFrame

espPlayersButton.MouseButton1Click:Connect(function()
    espPlayersEnabled = not espPlayersEnabled
    espPlayersButton.Text = espPlayersEnabled and "ESP Players: ON" or "ESP Players: OFF"
    if not espPlayersEnabled then
        -- Limpiar ESP jugadores cuando se apaga
        for _, gui in pairs(playerESP) do
            gui:Destroy()
        end
        playerESP = {}
    end
end)

-- Noclip loop
RunService.Stepped:Connect(function()
    if noclipEnabled and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    elseif LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") and not part.CanCollide then
                part.CanCollide = true
            end
        end
    end
end)

-- Función para crear ESP bases
local function createBaseESP(base)
    if baseESP[base] then return end -- ya tiene ESP

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "BaseESP"
    billboard.Adornee = base.PrimaryPart or base:FindFirstChildWhichIsA("BasePart")
    billboard.Size = UDim2.new(0, 120, 0, 30)
    billboard.StudsOffset = Vector3.new(0, 5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = base

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1,0,1,0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.new(1,0,0)
    textLabel.TextStrokeTransparency = 0
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextScaled = true
    textLabel.Parent = billboard

    baseESP[base] = billboard
end

-- Función para actualizar ESP bases con tiempo restante
local function updateBaseESP(base)
    local billboard = baseESP[base]
    if not billboard then return end

    local textLabel = billboard:FindFirstChildOfClass("TextLabel")
    if not textLabel then return end

    -- Suponiendo que la base tiene un valor "Locked" boolean y un IntValue "Timer" o similar
    -- Esto depende de la estructura específica del servidor Brainrot
    local locked = false
    local timeLeft = nil

    -- Buscamos en las propiedades o hijos de la base
    local lockedValue = base:FindFirstChild("Locked") or base:FindFirstChild("locked")
    local timerValue = base:FindFirstChild("Timer") or base:FindFirstChild("timer") or base:FindFirstChild("TimeLeft") or base:FindFirstChild("timeLeft")

    if lockedValue and lockedValue:IsA("BoolValue") then
        locked = lockedValue.Value
    end

    if timerValue and (timerValue:IsA("IntValue") or timerValue:IsA("NumberValue")) then
        timeLeft = timerValue.Value
    elseif timerValue and timerValue:IsA("StringValue") then
        timeLeft = tonumber(timerValue.Value)
    end

    if locked then
        textLabel.TextColor3 = Color3.new(1,0,0) -- rojo si está bloqueada
        textLabel.Text = "Locked: "..(timeLeft and tostring(timeLeft).."s" or "")
    else
        textLabel.TextColor3 = Color3.new(0,1,0) -- verde si desbloqueada o cerca
        textLabel.Text = "Open"
    end
end

-- Función para crear ESP jugadores
local function createPlayerESP(player)
    if player == LocalPlayer then return end
    if playerESP[player] then return end

    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "PlayerESP"
    billboard.Adornee = hrp
    billboard.Size = UDim2.new(0, 150, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = char

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1,0,1,0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.new(1,0,0)
    textLabel.TextStrokeTransparency = 0
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextScaled = true
    textLabel.Text = player.Name
    textLabel.Parent = billboard

    playerESP[player] = billboard
end

-- Actualizar ESP jugadores (en caso de reaparecer)
local function updatePlayerESP()
    for _, player in pairs(Players:GetPlayers()) do
        if espPlayersEnabled and player ~= LocalPlayer then
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                if not playerESP[player] then
                    createPlayerESP(player)
                end
            else
                -- limpiar ESP si no hay personaje
                if playerESP[player] then
                    playerESP[player]:Destroy()
                    playerESP[player] = nil
                end
            end
        else
            -- limpiar ESP si está apagado
            if playerESP[player] then
                playerESP[player]:Destroy()
                playerESP[player] = nil
            end
        end
    end
end

-- Detectar bases en workspace para ESP
local function detectBases()
    local basesFolder = Workspace:FindFirstChild("Bases") or Workspace:FindFirstChild("bases") or Workspace -- Ajustar según servidor

    for _, base in pairs(basesFolder:GetChildren()) do
        if base:IsA("Model") and espBasesEnabled then
            if not baseESP[base] then
                createBaseESP(base)
            end
        elseif baseESP[base] and not espBasesEnabled then
            baseESP[base]:Destroy()
            baseESP[base] = nil
        end
    end
end

-- Loop principal para actualizar ESP y speed
RunService.RenderStepped:Connect(function()
    -- Actualizar speed en humanoide
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = speedValue
    end

    -- Actualizar noclip
    -- (Se hace en Stepped)

    -- Actualizar ESP bases
    if espBasesEnabled then
        detectBases()
        for base, _ in pairs(baseESP) do
            updateBaseESP(base)
        end
    end

    -- Actualizar ESP jugadores
    updatePlayerESP()
end)

-- Limpiar ESP al salir o resetear
Players.PlayerRemoving:Connect(function(player)
    if playerESP[player] then
        playerESP[player]:Destroy()
        playerESP[player] = nil
    end
end)

-- Mensaje para activar speed default y evitar bugs al entrar
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
    LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = speedValue
end
