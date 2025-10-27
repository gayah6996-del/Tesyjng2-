-- SANSTRO Cheat Menu
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Создание окна
local Window = Rayfield:CreateWindow({
    Name = "SANSTRO Cheat Menu",
    LoadingTitle = "SANSTRO Cheat",
    LoadingSubtitle = "by SANSTRO Developer",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "SANSTRO",
        FileName = "Config"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvite",
        RememberJoins = true
    },
    KeySystem = false,
})

-- Основная вкладка ESP
local ESPTab = Window:CreateTab("ESP", "🔍")
local AimbotTab = Window:CreateTab("Aimbot", "🎯")

-- Переменные для ESP
local ESP = {
    Enabled = false,
    Box = false,
    Tracers = false,
    Names = false,
    Health = false,
    Count = false
}

local espObjects = {}
local playerCountLabel

-- Функция для создания ESP
local function createESP(player)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return
    end

    local character = player.Character
    local humanoidRootPart = character.HumanoidRootPart
    
    -- Box ESP
    if ESP.Box then
        local box = Drawing.new("Square")
        box.Visible = false
        box.Color = Color3.fromRGB(255, 255, 255)
        box.Thickness = 2
        box.Filled = false
        box.ZIndex = 1
        
        espObjects[player] = espObjects[player] or {}
        espObjects[player].Box = box
    end
    
    -- Tracer ESP
    if ESP.Tracers then
        local tracer = Drawing.new("Line")
        tracer.Visible = false
        tracer.Color = Color3.fromRGB(255, 255, 255)
        tracer.Thickness = 1
        tracer.ZIndex = 1
        
        espObjects[player] = espObjects[player] or {}
        espObjects[player].Tracer = tracer
    end
    
    -- Name ESP
    if ESP.Names then
        local name = Drawing.new("Text")
        name.Visible = false
        name.Color = Color3.fromRGB(255, 255, 255)
        name.Size = 13
        name.Center = true
        name.Outline = true
        name.Text = player.Name
        name.ZIndex = 1
        
        espObjects[player] = espObjects[player] or {}
        espObjects[player].Name = name
    end
    
    -- Health ESP
    if ESP.Health then
        local health = Drawing.new("Text")
        health.Visible = false
        health.Color = Color3.fromRGB(0, 255, 0)
        health.Size = 13
        health.Center = true
        health.Outline = true
        health.ZIndex = 1
        
        espObjects[player] = espObjects[player] or {}
        espObjects[player].Health = health
    end
end

-- Функция обновления ESP
local function updateESP()
    if not ESP.Enabled then return end
    
    local players = game:GetService("Players")
    local localPlayer = players.LocalPlayer
    local camera = workspace.CurrentCamera
    
    -- Обновление счетчика игроков
    if ESP.Count and playerCountLabel then
        local alivePlayers = 0
        for _, player in pairs(players:GetPlayers()) do
            if player ~= localPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
                alivePlayers += 1
            end
        end
        playerCountLabel.Text = "Игроков: " .. alivePlayers
    end
    
    for player, drawings in pairs(espObjects) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local character = player.Character
            local humanoidRootPart = character.HumanoidRootPart
            local humanoid = character:FindFirstChild("Humanoid")
            
            local position, onScreen = camera:WorldToViewportPoint(humanoidRootPart.Position)
            
            if onScreen then
                -- Box ESP
                if drawings.Box and ESP.Box then
                    local scale = 1 / (position.Z * math.tan(math.rad(camera.FieldOfView * 0.5)) * 2) * 100
                    local width, height = 4 * scale, 5 * scale
                    
                    drawings.Box.Size = Vector2.new(width, height)
                    drawings.Box.Position = Vector2.new(position.X - width / 2, position.Y - height / 2)
                    drawings.Box.Visible = true
                end
                
                -- Tracer ESP
                if drawings.Tracer and ESP.Tracers then
                    drawings.Tracer.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                    drawings.Tracer.To = Vector2.new(position.X, position.Y)
                    drawings.Tracer.Visible = true
                end
                
                -- Name ESP
                if drawings.Name and ESP.Names then
                    drawings.Name.Position = Vector2.new(position.X, position.Y - 40)
                    drawings.Name.Visible = true
                end
                
                -- Health ESP
                if drawings.Health and ESP.Health and humanoid then
                    drawings.Health.Text = "HP: " .. math.floor(humanoid.Health)
                    drawings.Health.Position = Vector2.new(position.X, position.Y - 25)
                    drawings.Health.Visible = true
                end
            else
                -- Скрыть ESP если игрок не на экране
                for _, drawing in pairs(drawings) do
                    if drawing then
                        drawing.Visible = false
                    end
                end
            end
        else
            -- Скрыть ESP если игрок мертв
            for _, drawing in pairs(drawings) do
                if drawing then
                    drawing.Visible = false
                end
            end
        end
    end
end

-- Функция очистки ESP
local function clearESP()
    for player, drawings in pairs(espObjects) do
        for _, drawing in pairs(drawings) do
            if drawing then
                drawing:Remove()
            end
        end
    end
    espObjects = {}
end

-- Элементы ESP
ESPTab:CreateToggle({
    Name = "Включить ESP",
    CurrentValue = false,
    Flag = "ESPEnabled",
    Callback = function(value)
        ESP.Enabled = value
        if not value then
            clearESP()
        else
            local players = game:GetService("Players")
            for _, player in pairs(players:GetPlayers()) do
                if player ~= players.LocalPlayer then
                    createESP(player)
                end
            end
        end
    end,
})

ESPTab:CreateToggle({
    Name = "ESP Box",
    CurrentValue = false,
    Flag = "ESPBox",
    Callback = function(value)
        ESP.Box = value
        clearESP()
        if ESP.Enabled then
            local players = game:GetService("Players")
            for _, player in pairs(players:GetPlayers()) do
                if player ~= players.LocalPlayer then
                    createESP(player)
                end
            end
        end
    end,
})

ESPTab:CreateToggle({
    Name = "ESP Tracers",
    CurrentValue = false,
    Flag = "ESPTracers",
    Callback = function(value)
        ESP.Tracers = value
        clearESP()
        if ESP.Enabled then
            local players = game:GetService("Players")
            for _, player in pairs(players:GetPlayers()) do
                if player ~= players.LocalPlayer then
                    createESP(player)
                end
            end
        end
    end,
})

ESPTab:CreateToggle({
    Name = "ESP Name",
    CurrentValue = false,
    Flag = "ESPName",
    Callback = function(value)
        ESP.Names = value
        clearESP()
        if ESP.Enabled then
            local players = game:GetService("Players")
            for _, player in pairs(players:GetPlayers()) do
                if player ~= players.LocalPlayer then
                    createESP(player)
                end
            end
        end
    end,
})

ESPTab:CreateToggle({
    Name = "ESP Health",
    CurrentValue = false,
    Flag = "ESPHealth",
    Callback = function(value)
        ESP.Health = value
        clearESP()
        if ESP.Enabled then
            local players = game:GetService("Players")
            for _, player in pairs(players:GetPlayers()) do
                if player ~= players.LocalPlayer then
                    createESP(player)
                end
            end
        end
    end,
})

ESPTab:CreateToggle({
    Name = "ESP Count",
    CurrentValue = false,
    Flag = "ESPCount",
    Callback = function(value)
        ESP.Count = value
        if value and not playerCountLabel then
            playerCountLabel = Drawing.new("Text")
            playerCountLabel.Visible = true
            playerCountLabel.Color = Color3.fromRGB(255, 255, 255)
            playerCountLabel.Size = 18
            playerCountLabel.Position = Vector2.new(10, 10)
            playerCountLabel.Outline = true
            playerCountLabel.Text = "Игроков: 0"
        elseif not value and playerCountLabel then
            playerCountLabel:Remove()
            playerCountLabel = nil
        end
    end,
})

-- Переменные для Aimbot
local Aimbot = {
    Enabled = false,
    FOV = 50
}

local fovCircle
local target

-- Создание FOV круга
local function createFOVCircle()
    fovCircle = Drawing.new("Circle")
    fovCircle.Visible = Aimbot.Enabled
    fovCircle.Color = Color3.fromRGB(255, 255, 255)
    fovCircle.Thickness = 1
    fovCircle.NumSides = 100
    fovCircle.Filled = false
    fovCircle.Radius = Aimbot.FOV
    fovCircle.Position = Vector2.new(
        workspace.CurrentCamera.ViewportSize.X / 2,
        workspace.CurrentCamera.ViewportSize.Y / 2
    )
end

-- Функция для проверки видимости
local function isVisible(part)
    local camera = workspace.CurrentCamera
    local origin = camera.CFrame.Position
    local direction = (part.Position - origin).Unit * 1000
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {game:GetService("Players").LocalPlayer.Character}
    
    local raycastResult = workspace:Raycast(origin, direction, raycastParams)
    
    if raycastResult then
        return raycastResult.Instance:IsDescendantOf(part.Parent)
    end
    return true
end

-- Функция для поиска цели
local function findTarget()
    local players = game:GetService("Players")
    local localPlayer = players.LocalPlayer
    local camera = workspace.CurrentCamera
    
    local closestDistance = Aimbot.FOV
    local closestPlayer = nil
    
    for _, player in pairs(players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local character = player.Character
            local humanoidRootPart = character.HumanoidRootPart
            
            local position, onScreen = camera:WorldToViewportPoint(humanoidRootPart.Position)
            
            if onScreen then
                local screenCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
                local mousePosition = Vector2.new(position.X, position.Y)
                local distance = (mousePosition - screenCenter).Magnitude
                
                if distance <= closestDistance and isVisible(humanoidRootPart) then
                    closestDistance = distance
                    closestPlayer = player
                end
            end
        end
    end
    
    return closestPlayer
end

-- Элементы Aimbot
AimbotTab:CreateToggle({
    Name = "Включить Aimbot",
    CurrentValue = false,
    Flag = "AimbotEnabled",
    Callback = function(value)
        Aimbot.Enabled = value
        if fovCircle then
            fovCircle.Visible = value
        else
            createFOVCircle()
        end
    end,
})

AimbotTab:CreateSlider({
    Name = "FOV Размер",
    Range = {10, 200},
    Increment = 5,
    Suffix = "px",
    CurrentValue = 50,
    Flag = "AimbotFOV",
    Callback = function(value)
        Aimbot.FOV = value
        if fovCircle then
            fovCircle.Radius = value
        end
    end,
})

-- Обработка новых игроков
game:GetService("Players").PlayerAdded:Connect(function(player)
    if ESP.Enabled then
        createESP(player)
    end
end)

game:GetService("Players").PlayerRemoving:Connect(function(player)
    if espObjects[player] then
        for _, drawing in pairs(espObjects[player]) do
            if drawing then
                drawing:Remove()
            end
        end
        espObjects[player] = nil
    end
end)

-- Основной цикл
game:GetService("RunService").RenderStepped:Connect(function()
    -- Обновление ESP
    if ESP.Enabled then
        updateESP()
    end
    
    -- Обновление позиции FOV круга
    if fovCircle then
        local camera = workspace.CurrentCamera
        fovCircle.Position = Vector2.new(
            camera.ViewportSize.X / 2,
            camera.ViewportSize.Y / 2
        )
    end
    
    -- Aimbot логика
    if Aimbot.Enabled then
        target = findTarget()
        
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local camera = workspace.CurrentCamera
            local targetPos = target.Character.HumanoidRootPart.Position
            
            -- Здесь можно добавить логику для автоматического прицеливания
            -- Например, изменение положения мыши или камеры
        end
    end
end)

-- Обработка смерти (чтобы меню не пропадало)
local function onCharacterAdded(character)
    -- Меню остается активным после смерти
end

game:GetService("Players").LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

Rayfield:LoadConfiguration()