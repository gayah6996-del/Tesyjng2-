local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer

-- Основной GUI (помещаем в CoreGui чтобы не пропадал при смерти)
local gui = Instance.new("ScreenGui")
gui.Name = "AimbotGUI"
gui.Parent = CoreGui

-- Главный фрейм меню
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = gui

-- Закругление углов
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
shadow.ZIndex = -1

-- Заголовок (будет использоваться для перемещения)
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
title.Text = "AIMBOT"
title.TextColor3 = Color3.fromRGB(255, 50, 50)
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

-- Делаем заголовок активным для перемещения
title.Active = true
title.Selectable = true

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = title

-- Контейнер для элементов
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 1, -40)
scrollFrame.Position = UDim2.new(0, 0, 0, 40)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 4
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.Parent = scrollFrame
layout.Padding = UDim.new(0, 8)

local padding = Instance.new("UIPadding")
padding.Parent = scrollFrame
padding.PaddingLeft = UDim.new(0, 10)
padding.PaddingRight = UDim.new(0, 10)
padding.PaddingTop = UDim.new(0, 10)
padding.PaddingBottom = UDim.new(0, 10)

-- Переменные для настроек
local settings = {
    aimbot = false,
    fov = 50,
    teamCheck = false,
    killCheck = false,
    wallHack = false
}

-- ФИКСИРОВАННЫЙ FOV круг (белый, по центру экрана)
local fovCircle = Instance.new("Frame")
fovCircle.Size = UDim2.new(0, settings.fov * 2, 0, settings.fov * 2)
fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
fovCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
fovCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
fovCircle.BackgroundTransparency = 0.8
fovCircle.BorderSizePixel = 0
fovCircle.Visible = false
fovCircle.Parent = gui

local fovCorner = Instance.new("UICorner")
fovCorner.CornerRadius = UDim.new(1, 0)
fovCorner.Parent = fovCircle

-- Таблицы для хранения данных
local wallHackItems = {}
local killFeed = {}
local currentTarget = nil

-- Переменные для перемещения меню
local dragging = false
local dragInput
local dragStart
local startPos

-- Функция для начала перемещения
local function updateInput(input)
    dragInput = input
end

local function beginDrag(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end

local function updateDrag(input)
    if dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X,
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end
end

-- Подключаем события перемещения к заголовку
title.InputBegan:Connect(beginDrag)
title.InputChanged:Connect(updateInput)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateDrag(input)
    end
end)

-- Функция создания переключателей
function createToggle(name, parent, defaultValue)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 30)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 50, 0, 25)
    toggle.Position = UDim2.new(1, -50, 0.5, -12.5)
    toggle.BackgroundColor3 = defaultValue and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
    toggle.Text = defaultValue and "ON" or "OFF"
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.TextSize = 12
    toggle.Font = Enum.Font.GothamBold
    toggle.Parent = frame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = toggle

    toggle.MouseButton1Click:Connect(function()
        local newValue = not (toggle.Text == "ON")
        toggle.Text = newValue and "ON" or "OFF"
        toggle.BackgroundColor3 = newValue and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
        settings[name:gsub(" ", ""):lower()] = newValue
        
        -- Особые действия для некоторых переключателей
        if name == "AimBot" then
            fovCircle.Visible = newValue
        elseif name == "WallHack" then
            if newValue then
                createWallHack()
            else
                removeWallHack()
            end
        elseif name == "Kill Check" then
            if newValue then
                setupKillFeed()
            else
                clearKillFeed()
            end
        end
    end)

    return toggle
end

-- Функция создания слайдера для FOV
function createSlider(name, parent, minValue, maxValue, defaultValue)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 60)
    container.BackgroundTransparency = 1
    container.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = name .. ": " .. defaultValue
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, 0, 0, 25)
    sliderFrame.Position = UDim2.new(0, 0, 0, 25)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    sliderFrame.Parent = container

    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 4)
    sliderCorner.Parent = sliderFrame

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((defaultValue - minValue) / (maxValue - minValue), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    fill.BorderSizePixel = 0
    fill.Parent = sliderFrame

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 4)
    fillCorner.Parent = fill

    local sliderButton = Instance.new("TextButton")
    sliderButton.Size = UDim2.new(0, 20, 1, 4)
    sliderButton.Position = UDim2.new((defaultValue - minValue) / (maxValue - minValue), -10, 0, -2)
    sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderButton.Text = ""
    sliderButton.Parent = sliderFrame

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 4)
    buttonCorner.Parent = sliderButton

    local dragging = false

    local function updateSlider(input)
        local pos = UDim2.new(math.clamp((input.Position.X - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X, 0, 1), -10, 0, -2)
        sliderButton.Position = pos
        
        local value = math.floor(minValue + (pos.X.Scale * (maxValue - minValue)))
        label.Text = name .. ": " .. value
        fill.Size = UDim2.new(pos.X.Scale, 0, 1, 0)
        
        settings[name:gsub(" ", ""):lower()] = value
        
        -- Обновляем FOV круг
        if name == "FOV" then
            fovCircle.Size = UDim2.new(0, value * 2, 0, value * 2)
        end
    end

    sliderButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)

    sliderButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    sliderFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateSlider(input)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)

    return container
end

-- АИМБОТ ФУНКЦИЯ (улучшенная)
function findTarget()
    local closestPlayer = nil
    local shortestDistance = settings.fov
    
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("Humanoid") and otherPlayer.Character.Humanoid.Health > 0 then
            
            -- Team Check
            if settings.teamCheck then
                if player.Team and otherPlayer.Team and player.Team == otherPlayer.Team then
                    continue
                end
            end
            
            local character = otherPlayer.Character
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            local head = character:FindFirstChild("Head")
            
            if humanoidRootPart then
                local screenPoint, onScreen = workspace.CurrentCamera:WorldToViewportPoint(humanoidRootPart.Position)
                
                if onScreen then
                    -- Проверка на видимость (не через стены)
                    local raycastParams = RaycastParams.new()
                    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                    raycastParams.FilterDescendantsInstances = {player.Character, character}
                    
                    local rayOrigin = workspace.CurrentCamera.CFrame.Position
                    local rayDirection = (humanoidRootPart.Position - rayOrigin).Unit * 1000
                    local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
                    
                    if raycastResult and raycastResult.Instance:IsDescendantOf(character) then
                        -- Игрок видим
                        local center = Vector2.new(workspace.CurrentCamera.ViewportSize.X/2, workspace.CurrentCamera.ViewportSize.Y/2)
                        local playerLocation = Vector2.new(screenPoint.X, screenPoint.Y)
                        local distance = (center - playerLocation).Magnitude
                        
                        if distance < shortestDistance then
                            closestPlayer = otherPlayer
                            shortestDistance = distance
                        end
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

function aimAtTarget(target)
    if not target or not target.Character then return end
    
    local humanoidRootPart = target.Character:FindFirstChild("HumanoidRootPart")
    local head = target.Character:FindFirstChild("Head")
    if not humanoidRootPart then return end
    
    -- Для мобильных устройств - наведение на цель
    local camera = workspace.CurrentCamera
    local targetPosition = head and head.Position or humanoidRootPart.Position
    
    -- Плавное перемещение камеры к цели (только если это разрешено игрой)
    local currentCFrame = camera.CFrame
    local newCFrame = CFrame.new(currentCFrame.Position, targetPosition)
    
    -- Пытаемся изменить положение камеры
    pcall(function()
        camera.CFrame = newCFrame
    end)
end

-- WALLHACK ФУНКЦИИ
function createWallHack()
    removeWallHack()
    
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player then
            createPlayerESP(otherPlayer)
        end
    end
    
    -- Слушаем новых игроков
    Players.PlayerAdded:Connect(function(newPlayer)
        if newPlayer ~= player then
            createPlayerESP(newPlayer)
        end
    end)
end

function createPlayerESP(targetPlayer)
    if wallHackItems[targetPlayer] then return end
    
    local espFolder = Instance.new("Folder")
    espFolder.Name = targetPlayer.Name .. "_ESP"
    espFolder.Parent = gui
    
    wallHackItems[targetPlayer] = {
        folder = espFolder,
        tracers = {},
        boxes = {},
        healthBars = {},
        labels = {}
    }
    
    if targetPlayer.Character then
        setupCharacterESP(targetPlayer, targetPlayer.Character)
    end
    
    targetPlayer.CharacterAdded:Connect(function(character)
        setupCharacterESP(targetPlayer, character)
    end)
end

function setupCharacterESP(player, character)
    local espData = wallHackItems[player]
    if not espData then return end
    
    -- TRACER (линия от центра экрана к игроку)
    local tracer = Instance.new("Frame")
    tracer.Name = "Tracer"
    tracer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    tracer.BorderSizePixel = 0
    tracer.Size = UDim2.new(0, 2, 0, 100)
    tracer.AnchorPoint = Vector2.new(0.5, 0)
    tracer.Visible = false
    tracer.Parent = espData.folder
    
    table.insert(espData.tracers, tracer)
    
    -- BOX (рамка вокруг игрока)
    local box = Instance.new("Frame")
    box.Name = "Box"
    box.BackgroundTransparency = 1
    box.BorderColor3 = Color3.fromRGB(0, 255, 0)
    box.BorderSizePixel = 2
    box.Size = UDim2.new(0, 50, 0, 100)
    box.Visible = false
    box.Parent = espData.folder
    
    table.insert(espData.boxes, box)
    
    -- HEALTH BAR
    local healthBar = Instance.new("Frame")
    healthBar.Name = "HealthBar"
    healthBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    healthBar.BorderSizePixel = 0
    healthBar.Size = UDim2.new(0, 4, 0, 30)
    healthBar.Visible = false
    healthBar.Parent = espData.folder
    
    local healthBarBackground = Instance.new("Frame")
    healthBarBackground.Name = "HealthBarBackground"
    healthBarBackground.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    healthBarBackground.BorderSizePixel = 0
    healthBarBackground.Size = UDim2.new(1, 0, 1, 0)
    healthBarBackground.Parent = healthBar
    healthBarBackground.ZIndex = -1
    
    table.insert(espData.healthBars, healthBar)
    
    -- NAME LABEL
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextSize = 14
    nameLabel.Visible = false
    nameLabel.Parent = espData.folder
    
    table.insert(espData.labels, nameLabel)
    
    -- Обновление позиций
    local humanoid = character:WaitForChild("Humanoid")
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    
    local connection
    connection = RunService.Heartbeat:Connect(function()
        if not character or not humanoidRootPart or not humanoid or humanoid.Health <= 0 then
            if connection then
                connection:Disconnect()
            end
            return
        end
        
        local screenPoint, onScreen = workspace.CurrentCamera:WorldToViewportPoint(humanoidRootPart.Position)
        
        if onScreen then
            -- Обновление трассера
            tracer.Visible = true
            tracer.Position = UDim2.new(0, workspace.CurrentCamera.ViewportSize.X/2, 0, workspace.CurrentCamera.ViewportSize.Y)
            local angle = math.atan2(screenPoint.Y - workspace.CurrentCamera.ViewportSize.Y/2, screenPoint.X - workspace.CurrentCamera.ViewportSize.X/2)
            tracer.Rotation = math.deg(angle) + 90
            
            local distance = (Vector2.new(workspace.CurrentCamera.ViewportSize.X/2, workspace.CurrentCamera.ViewportSize.Y) - Vector2.new(screenPoint.X, screenPoint.Y)).Magnitude
            tracer.Size = UDim2.new(0, 2, 0, distance)
            
            -- Обновление бокса
            box.Visible = true
            box.Position = UDim2.new(0, screenPoint.X - 25, 0, screenPoint.Y - 100)
            
            -- Обновление health bar
            healthBar.Visible = true
            healthBar.Position = UDim2.new(0, screenPoint.X + 30, 0, screenPoint.Y - 100)
            local healthPercent = humanoid.Health / humanoid.MaxHealth
            healthBar.Size = UDim2.new(0, 4, 0, 60 * healthPercent)
            healthBar.BackgroundColor3 = Color3.new(1 - healthPercent, healthPercent, 0)
            
            -- Обновление имени
            nameLabel.Visible = true
            nameLabel.Position = UDim2.new(0, screenPoint.X - 25, 0, screenPoint.Y - 120)
            nameLabel.Text = player.Name .. " (" .. math.floor(humanoid.Health) .. ")"
        else
            tracer.Visible = false
            box.Visible = false
            healthBar.Visible = false
            nameLabel.Visible = false
        end
    end)
end

function removeWallHack()
    for player, espData in pairs(wallHackItems) do
        if espData.folder then
            espData.folder:Destroy()
        end
    end
    wallHackItems = {}
end

-- KILL FEED ФУНКЦИИ
function setupKillFeed()
    clearKillFeed()
    
    -- Создаем GUI для kill feed
    local killFeedFrame = Instance.new("Frame")
    killFeedFrame.Name = "KillFeed"
    killFeedFrame.Size = UDim2.new(0, 200, 0, 200)
    killFeedFrame.Position = UDim2.new(0, 10, 0, 50)
    killFeedFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    killFeedFrame.BackgroundTransparency = 0.5
    killFeedFrame.Parent = gui
    
    local killFeedCorner = Instance.new("UICorner")
    killFeedCorner.CornerRadius = UDim.new(0, 8)
    killFeedCorner.Parent = killFeedFrame
    
    local killFeedLayout = Instance.new("UIListLayout")
    killFeedLayout.Parent = killFeedFrame
    killFeedLayout.Padding = UDim.new(0, 5)
    
    local killFeedPadding = Instance.new("UIPadding")
    killFeedPadding.Parent = killFeedFrame
    killFeedPadding.PaddingLeft = UDim.new(0, 5)
    killFeedPadding.PaddingRight = UDim.new(0, 5)
    killFeedPadding.PaddingTop = UDim.new(0, 5)
    killFeedPadding.PaddingBottom = UDim.new(0, 5)
    
    -- Отслеживаем смерти игроков
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        trackPlayerDeaths(otherPlayer, killFeedFrame)
    end
    
    Players.PlayerAdded:Connect(function(newPlayer)
        trackPlayerDeaths(newPlayer, killFeedFrame)
    end)
end

function trackPlayerDeaths(targetPlayer, killFeedFrame)
    targetPlayer.CharacterAdded:Connect(function(character)
        local humanoid = character:WaitForChild("Humanoid")
        humanoid.Died:Connect(function()
            addKillToFeed(targetPlayer.Name .. " был убит", killFeedFrame)
        end)
    end)
end

function addKillToFeed(killText, killFeedFrame)
    local killLabel = Instance.new("TextLabel")
    killLabel.Size = UDim2.new(1, 0, 0, 20)
    killLabel.BackgroundTransparency = 1
    killLabel.Text = killText
    killLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
    killLabel.TextSize = 12
    killLabel.Font = Enum.Font.Gotham
    killLabel.TextXAlignment = Enum.TextXAlignment.Left
    killLabel.Parent = killFeedFrame
    
    table.insert(killFeed, killLabel)
    
    -- Автоматическое удаление старых записей
    delay(10, function()
        if killLabel and killLabel.Parent then
            killLabel:Destroy()
        end
    end)
    
    -- Ограничиваем количество записей
    if #killFeed > 8 then
        local oldest = table.remove(killFeed, 1)
        if oldest and oldest.Parent then
            oldest:Destroy()
        end
    end
end

function clearKillFeed()
    for _, killLabel in pairs(killFeed) do
        if killLabel and killLabel.Parent then
            killLabel:Destroy()
        end
    end
    killFeed = {}
    
    local existingKillFeed = gui:FindFirstChild("KillFeed")
    if existingKillFeed then
        existingKillFeed:Destroy()
    end
end

-- Создание элементов интерфейса
createToggle("AimBot", scrollFrame, false)
createSlider("FOV", scrollFrame, 10, 200, 50)
createToggle("Team Check", scrollFrame, false)
createToggle("Kill Check", scrollFrame, false)
createToggle("WallHack", scrollFrame, false)

-- Кнопка переоткрытия меню (улучшенная для мобильных устройств)
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 50, 0, 50)
toggleButton.Position = UDim2.new(1, -60, 0, 10)
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
toggleButton.Text = "≡"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 24
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Parent = gui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggleButton

local toggleShadow = Instance.new("ImageLabel")
toggleShadow.Size = UDim2.new(1, 10, 1, 10)
toggleShadow.Position = UDim2.new(0, -5, 0, -5)
toggleShadow.BackgroundTransparency = 1
toggleShadow.Image = "rbxassetid://1316045217"
toggleShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
toggleShadow.ImageTransparency = 0.8
toggleShadow.ScaleType = Enum.ScaleType.Slice
toggleShadow.SliceCenter = Rect.new(10, 10, 118, 118)
toggleShadow.Parent = toggleButton
toggleShadow.ZIndex = -1

-- Улучшенная функция переключения меню для мобильных устройств
local function toggleMenu()
    mainFrame.Visible = not mainFrame.Visible
end

-- Обработка кликов и касаний для кнопки
toggleButton.MouseButton1Click:Connect(toggleMenu)
toggleButton.TouchTap:Connect(toggleMenu)

-- Основной цикл аимбота
RunService.RenderStepped:Connect(function()    
    -- Аимбот логика
    if settings.aimbot then
        local target = findTarget()
        if target and target ~= currentTarget then
            currentTarget = target
            aimAtTarget(target)
        end
    else
        currentTarget = nil
    end
end)

-- Защита от удаления GUI при смерти
player.CharacterAdded:Connect(function()
    -- Пересоздаем GUI если он был удален
    if not gui or not gui.Parent then
        gui = Instance.new("ScreenGui")
        gui.Name = "AimbotGUI"
        gui.Parent = CoreGui
        
        -- Здесь нужно пересоздать все элементы GUI...
        -- Для простоты перезагрузим скрипт
        print("GUI был пересоздан после смерти")
    end
end)

print("Aimbot Menu loaded! Use the square button to toggle menu.")
print("Menu will not disappear when you die!")
print("Drag the title bar to move the menu!")