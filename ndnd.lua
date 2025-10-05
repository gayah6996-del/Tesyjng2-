-- ESP Script for Roblox
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local localPlayer = Players.LocalPlayer
local espEnabled = false
local espObjects = {}

-- Создание GUI меню
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ESPMenu"
screenGui.Parent = CoreGui

-- Основной фрейм меню
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 200)
mainFrame.Position = UDim2.new(0, 50, 0, 50)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Скругление углов
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- Тень
local shadow = Instance.new("ImageLabel")
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316045217"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.8
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 118, 118)
shadow.Parent = mainFrame

-- Заголовок
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.Text = "ESP MENU"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = title

-- Кнопка переключения ESP
local espButton = Instance.new("TextButton")
espButton.Size = UDim2.new(0.8, 0, 0, 40)
espButton.Position = UDim2.new(0.1, 0, 0.3, 0)
espButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
espButton.Text = "ESP: OFF"
espButton.TextColor3 = Color3.fromRGB(255, 50, 50)
espButton.TextSize = 16
espButton.Font = Enum.Font.Gotham
espButton.Parent = mainFrame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 6)
buttonCorner.Parent = espButton

-- Информация
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(0.9, 0, 0, 40)
infoLabel.Position = UDim2.new(0.05, 0, 0.7, 0)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "Box + Line + Name"
infoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
infoLabel.TextSize = 14
infoLabel.Font = Enum.Font.Gotham
infoLabel.Parent = mainFrame

-- Функция создания ESP для игрока
local function createESP(player)
    if player == localPlayer then return end
    
    local character = player.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    -- Box
    local box = Instance.new("BoxHandleAdornment")
    box.Name = "ESPBox"
    box.Adornee = humanoidRootPart
    box.AlwaysOnTop = true
    box.ZIndex = 5
    box.Size = Vector3.new(4, 6, 4)
    box.Color3 = Color3.fromRGB(0, 255, 0)
    box.Transparency = 0.7
    box.Parent = humanoidRootPart
    
    -- Line
    local line = Instance.new("BoxHandleAdornment")
    line.Name = "ESPLine"
    line.Adornee = humanoidRootPart
    line.AlwaysOnTop = true
    line.ZIndex = 4
    line.Size = Vector3.new(0.1, 100, 0.1)
    line.Color3 = Color3.fromRGB(255, 0, 0)
    line.Transparency = 0.5
    line.Parent = humanoidRootPart
    
    -- Name Label
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESPName"
    billboard.Adornee = humanoidRootPart
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 4, 0)
    billboard.AlwaysOnTop = true
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    nameLabel.TextSize = 18
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Parent = billboard
    
    billboard.Parent = humanoidRootPart
    
    espObjects[player] = {
        box = box,
        line = line,
        billboard = billboard
    }
end

-- Функция удаления ESP
local function removeESP(player)
    if espObjects[player] then
        espObjects[player].box:Destroy()
        espObjects[player].line:Destroy()
        espObjects[player].billboard:Destroy()
        espObjects[player] = nil
    end
end

-- Функция обновления линии
local function updateLine(player)
    if not espObjects[player] then return end
    
    local character = player.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    -- Обновляем позицию линии (от игрока к земле)
    espObjects[player].line.CFrame = CFrame.new(
        humanoidRootPart.Position.X, 
        humanoidRootPart.Position.Y - 3, 
        humanoidRootPart.Position.Z
    )
end

-- Обработчик кнопки ESP
espButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    
    if espEnabled then
        espButton.Text = "ESP: ON"
        espButton.TextColor3 = Color3.fromRGB(50, 255, 50)
        
        -- Включить ESP для всех игроков
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character then
                createESP(player)
            end
        end
    else
        espButton.Text = "ESP: OFF"
        espButton.TextColor3 = Color3.fromRGB(255, 50, 50)
        
        -- Отключить ESP для всех игроков
        for player, _ in pairs(espObjects) do
            removeESP(player)
        end
    end
end)

-- Обработка новых игроков
Players.PlayerAdded:Connect(function(player)
    if espEnabled and player.Character then
        createESP(player)
    end
    
    player.CharacterAdded:Connect(function(character)
        if espEnabled then
            wait(1) -- Ждем загрузки персонажа
            createESP(player)
        end
    end)
end)

-- Обработка вышедших игроков
Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
end)

-- Обновление ESP в реальном времени
RunService.Heartbeat:Connect(function()
    if espEnabled then
        for player, _ in pairs(espObjects) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                updateLine(player)
            else
                removeESP(player)
            end
        end
    end
end)

-- Инициализация ESP для уже подключенных игроков
for _, player in ipairs(Players:GetPlayers()) do
    if player.Character then
        createESP(player)
        removeESP(player) -- Сначала удаляем, чтобы не было дублирования при включении
    end
    
    player.CharacterAdded:Connect(function(character)
        if espEnabled then
            wait(1)
            createESP(player)
        end
    end
end)