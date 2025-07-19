-- Brainrot Style Mod Menu corregido y funcional

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

-- Variables
local noclipEnabled = false
local speedValue = 16
local espBasesEnabled = false
local espPlayersEnabled = false

local baseESP = {}
local playerESP = {}

-- Crear GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BrainrotModMenu"
ScreenGui.Parent = game.CoreGui

-- Floating Button
local floatingButton = Instance.new("TextButton")
floatingButton.Size = UDim2.new(0, 50, 0, 50)
floatingButton.Position = UDim2.new(0, 10, 0.5, -25)
floatingButton.BackgroundColor3 = Color3.fromRGB(0,0,0)
floatingButton.BackgroundTransparency = 0.3
floatingButton.TextColor3 = Color3.new(1,1,1)
floatingButton.Text = "Menu"
floatingButton.Parent = ScreenGui
floatingButton.ZIndex = 10

-- Menu Frame
local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0, 220, 0, 220)
menuFrame.Position = UDim2.new(0, 70, 0.5, -110)
menuFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
menuFrame.BorderSizePixel = 0
menuFrame.Visible = false
menuFrame.Parent = ScreenGui
menuFrame.ZIndex = 10

-- Función Draggable
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
    RunService.Heartbeat:Connect(function()
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

-- Toggle menú
floatingButton.MouseButton1Click:Connect(function()
    menuFrame.Visible = not menuFrame.Visible
end)

-- Botones dentro del menú

-- Speed Button
local speedButton = Instance.new("TextButton")
speedButton.Size = UDim2.new(0, 200, 0, 40)
speedButton.Position = UDim2.new(0, 10, 0, 10)
speedButton.BackgroundColor3 = Color3.fromRGB(60,60,60)
speedButton.TextColor3 = Color3.new(1,1,1)
speedButton.Font = Enum.Font.GothamBold
speedButton.TextScaled = true
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

-- Noclip Button
local noclipButton = Instance.new("TextButton")
noclipButton.Size = UDim2.new(0, 200, 0, 40)
noclipButton.Position = UDim2.new(0, 10, 0, 60)
noclipButton.BackgroundColor3 = Color3.fromRGB(60,60,60)
noclipButton.TextColor3 = Color3.new(1,1,1)
noclipButton.Font = Enum.Font.GothamBold
noclipButton.TextScaled = true
noclipButton.Text = "Noclip: OFF"
noclipButton.Parent = menuFrame

noclipButton.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    noclipButton.Text = noclipEnabled and "Noclip: ON" or "Noclip: OFF"
end)

-- ESP Bases Button
local espBasesButton = Instance.new("TextButton")
espBasesButton.Size = UDim2.new(0, 200, 0, 40)
espBasesButton.Position = UDim2.new(0, 10, 0, 110)
espBasesButton.BackgroundColor3 = Color3.fromRGB(60,60,60)
espBasesButton.TextColor3 = Color3.new(1,1,1)
espBasesButton.Font = Enum.Font.GothamBold
espBasesButton.TextScaled = true
espBasesButton.Text = "ESP Bases: OFF"
espBasesButton.Parent = menuFrame

espBasesButton.MouseButton1Click:Connect(function()
    espBasesEnabled = not espBasesEnabled
    espBasesButton.Text = espBasesEnabled and "ESP Bases: ON" or "ESP Bases: OFF"
    if not espBasesEnabled then
        for _, gui in pairs(baseESP) do
            gui:Destroy()
        end
        baseESP = {}
    end
end)

-- ESP Players Button
local espPlayersButton = Instance.new("TextButton")
espPlayersButton.Size = UDim2.new(0, 200, 0, 40)
espPlayersButton.Position = UDim2.new(0, 10, 0, 160)
espPlayersButton.BackgroundColor3 = Color3.fromRGB(60,60,60)
espPlayersButton.TextColor3 = Color3.new(1,1,1)
espPlayersButton.Font = Enum.Font.GothamBold
espPlayersButton.TextScaled = true
espPlayersButton.Text = "ESP Players: OFF"
espPlayersButton.Parent = menuFrame

espPlayersButton.MouseButton1Click:Connect(function()
    espPlayersEnabled = not espPlayersEnabled
    espPlayersButton.Text = espPlayersEnabled and "ESP Players: ON" or "ESP Players: OFF"
    if not espPlayersEnabled then
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

-- Función crear ESP Bases
local function createBaseESP(base)
    if baseESP[base] then return end
    local adorneePart = base.PrimaryPart or base:FindFirstChildWhichIsA("BasePart")
    if not adorneePart then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "BaseESP"
    billboard.Adornee = adorneePart
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

local function updateBaseESP(base)
    local billboard = baseESP[base]
    if not billboard then return end
    local textLabel = billboard:FindFirstChildOfClass("TextLabel")
    if not textLabel then return end

    -- Asumiendo variables Locked (BoolValue) y Timer (IntValue) en cada base
    local lockedVal = base:FindFirstChild("Locked") or base:FindFirstChild("locked")
    local timerVal = base:FindFirstChild("Timer") or base:FindFirstChild("timer")

    local locked = false
    local timeLeft = nil

    if lockedVal and lockedVal:IsA("BoolValue") then locked = lockedVal.Value end
    if timerVal and (timerVal:IsA("IntValue") or timerVal:IsA("NumberValue")) then timeLeft = timerVal.Value end

    if locked then
        textLabel.TextColor3 = Color3.new(1,0,0)
        textLabel.Text = "Locked: "..(timeLeft and tostring(timeLeft).."s" or "N/A")
    else
        textLabel.TextColor3 = Color3.new(0,1,0)
        textLabel.Text = "Open"
    end
end

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

local function updatePlayerESP()
    for _, player in pairs(Players:GetPlayers()) do
        if espPlayersEnabled and player ~= LocalPlayer then
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                if not playerESP[player] then
                    createPlayerESP(player)
                end
            else
                if playerESP[player] then
                    playerESP[player]:Destroy()
                    playerESP[player] = nil
                end
            end
        else
            if playerESP[player] then
                playerESP[player]:Destroy()
                playerESP[player] = nil
            end
        end
    end
end

local function detectBases()
    local basesFolder = Workspace:FindFirstChild("Bases") or Workspace
    for _, base in pairs(basesFolder:GetChildren()) do
        if base:IsA("Model") then
            if espBasesEnabled then
                if not baseESP[base] then
                    createBaseESP(base)
                end
            elseif baseESP[base] then
                baseESP[base]:Destroy()
                baseESP[base] = nil
            end
        end
    end
end

RunService.RenderStepped:Connect(function()
    -- Speed
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = speedValue
    end

    -- ESP Bases
    if espBasesEnabled then
        detectBases()
        for base, _ in pairs(baseESP) do
            updateBaseESP(base)
        end
    end

    -- ESP Players
    updatePlayerESP()
end)

Players.PlayerRemoving:Connect(function(player)
    if playerESP[player] then
        playerESP[player]:Destroy()
        playerESP[player] = nil
    end
end)
