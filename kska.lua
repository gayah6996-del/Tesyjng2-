local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer

-- Основной GUI
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

-- Заголовок (для перемещения)
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
title.Text = "AIMBOT"
title.TextColor3 = Color3.fromRGB(255, 50, 50)
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame
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
    smoothness = 1,
    aimPart = "Head",
    tracers = false,
    distanceHealth = false
}

-- FOV круг
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
local espItems = {}
local currentTarget = nil

-- Переменные для перемещения меню
local dragging = false
local dragInput
local dragStart
local startPos

-- Функция для перемещения меню
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
        
        if name == "AimBot" then
            fovCircle.Visible = newValue
        elseif name == "Tracers" or name == "Distance Health" then
            if newValue then
                createESP()
            else
                removeESP()
            end
        end
    end)

    return toggle
end

-- Функция создания слайдера
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

-- Функция создания выпадающего списка
function createDropdown(name, parent, options, defaultValue)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 50)
    container.BackgroundTransparency = 1
    container.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local dropdown = Instance.new("TextButton")
    dropdown.Size = UDim2.new(1, 0, 0, 25)
    dropdown.Position = UDim2.new(0, 0, 0, 25)
    dropdown.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    dropdown.Text = defaultValue
    dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdown.TextSize = 12
    dropdown.Font = Enum.Font.Gotham
    dropdown.Parent = container

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = dropdown

    local open = false
    local optionButtons = {}

    local function toggleDropdown()
        open = not open
        for _, btn in pairs(optionButtons) do
            btn.Visible = open
        end
    end

    dropdown.MouseButton1Click:Connect(toggleDropdown)

    for i, option in ipairs(options) do
        local optionBtn = Instance.new("TextButton")
        optionBtn.Size = UDim2.new(1, 0, 0, 25)
        optionBtn.Position = UDim2.new(0, 0, 0, 25 * (i + 1))
        optionBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        optionBtn.Text = option
        optionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        optionBtn.TextSize = 12
        optionBtn.Font = Enum.Font.Gotham
        optionBtn.Visible = false
        optionBtn.Parent = container

        local optionCorner = Instance.new("UICorner")
        optionCorner.CornerRadius = UDim.new(0, 4)
        optionCorner.Parent = optionBtn

        optionBtn.MouseButton1Click:Connect(function()
            dropdown.Text = option
            settings[name:gsub(" ", ""):lower()] = option
            toggleDropdown()
        end)

        table.insert(optionButtons, optionBtn)
    end

    return container
end

-- УЛУЧШЕННЫЙ АИМБОТ ДЛЯ МОБИЛЬНЫХ УСТРОЙСТВ
function findTarget()
    local closestPlayer = nil
    local shortestDistance = settings.fov
    local camera = workspace.CurrentCamera
    
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
            local aimPart = character:FindFirstChild(settings.aimPart)
            
            if humanoidRootPart and aimPart then
                local screenPoint, onScreen = camera:WorldToViewportPoint(aimPart.Position)
                
                if onScreen then
                    -- Проверка на видимость через Raycast
                    local rayOrigin = camera.CFrame.Position
                    local rayDirection = (aimPart.Position - rayOrigin).Unit * 1000
                    
                    local raycastParams = RaycastParams.new()
                    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                    raycastParams.FilterDescendantsInstances = {player.Character, character}
                    
                    local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
                    
                    local isVisible = false
                    if raycastResult then
                        local hitCharacter = raycastResult.Instance:FindFirstAncestorOfClass("Model")
                        if hitCharacter == character then
                            isVisible = true
                        end
                    end
                    
                    if isVisible then
                        local center = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)
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
    
    local aimPart = target.Character:FindFirstChild(settings.aimPart)
    if not aimPart then return end
    
    local camera = workspace.CurrentCamera
    
    -- Плавное наведение для мобильных устройств
    local currentCF = camera.CFrame
    local targetPosition = aimPart.Position
    
    -- Вычисляем направление к цели
    local direction = (targetPosition - currentCF.Position).Unit
    
    -- Создаем новый CFrame с плавностью
    local smoothness = math.clamp(settings.smoothness, 1, 10)
    local newLookVector = currentCF.LookVector:Lerp(direction, 1/smoothness)
    
    -- Создаем новый CFrame
    local newCF = CFrame.new(currentCF.Position, currentCF.Position + newLookVector)
    
    -- Применяем к камере
    pcall(function()
        camera.CFrame = newCF
    end)
end

-- НОВЫЕ ESP ФУНКЦИИ
function createESP()
    removeESP()
    
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player then
            createPlayerESP(otherPlayer)
        end
    end
    
    Players.PlayerAdded:Connect(function(newPlayer)
        if newPlayer ~= player then
            createPlayerESP(newPlayer)
        end
    end)
end

function createPlayerESP(targetPlayer)
    if espItems[targetPlayer] then return end
    
    local espFolder = Instance.new("Folder")
    espFolder.Name = targetPlayer.Name .. "_ESP"
    espFolder.Parent = gui
    
    espItems[targetPlayer] = {
        folder = espFolder,
        tracers = {},
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
    local espData = espItems[player]
    if not espData then return end
    
    -- TRACERS LINE (линия от центра экрана к игроку)
    if settings.tracers then
        local tracer = Instance.new("Frame")
        tracer.Name = "Tracer"
        tracer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        tracer.BorderSizePixel = 0
        tracer.Size = UDim2.new(0, 2, 0, 100)
        tracer.AnchorPoint = Vector2.new(0.5, 0)
        tracer.Visible = false
        tracer.Parent = espData.folder
        
        table.insert(espData.tracers, tracer)
    end
    
    -- DISTANCE HEALTH (информация над игроком)
    if settings.distanceHealth then
        local infoLabel = Instance.new("TextLabel")
        infoLabel.Name = "DistanceHealth"
        infoLabel.BackgroundTransparency = 1
        infoLabel.Text = ""
        infoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        infoLabel.TextSize = 14
        infoLabel.Font = Enum.Font.GothamBold
        infoLabel.Visible = false
        infoLabel.Parent = espData.folder
        
        table.insert(espData.labels, infoLabel)
    end
    
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
            -- TRACERS LINE
            if settings.tracers then
                for _, tracer in pairs(espData.tracers) do
                    tracer.Visible = true
                    local startPos = UDim2.new(0, workspace.CurrentCamera.ViewportSize.X/2, 1, 0) -- снизу экрана
                    local endPos = UDim2.new(0, screenPoint.X, 0, screenPoint.Y)
                    
                    -- Вычисляем угол и длину линии
                    local angle = math.atan2(screenPoint.Y - workspace.CurrentCamera.ViewportSize.Y, screenPoint.X - workspace.CurrentCamera.ViewportSize.X/2)
                    local distance = (Vector2.new(workspace.CurrentCamera.ViewportSize.X/2, workspace.CurrentCamera.ViewportSize.Y) - Vector2.new(screenPoint.X, screenPoint.Y)).Magnitude
                    
                    tracer.Size = UDim2.new(0, 2, 0, distance)
                    tracer.Position = startPos
                    tracer.Rotation = math.deg(angle) + 90
                end
            end
            
            -- DISTANCE HEALTH INFO
            if settings.distanceHealth then
                for _, label in pairs(espData.labels) do
                    label.Visible = true
                    local distance = (humanoidRootPart.Position - workspace.CurrentCamera.CFrame.Position).Magnitude
                    local healthPercent = math.floor((humanoid.Health / humanoid.MaxHealth) * 100)
                    
                    -- Цвет здоровья (зеленый -> желтый -> красный)
                    local healthColor = Color3.new(1 - healthPercent/100, healthPercent/100, 0)
                    
                    label.Text = player.Name .. "\n" .. math.floor(distance) .. " studs\n" .. healthPercent .. "% HP"
                    label.TextColor3 = healthColor
                    label.Position = UDim2.new(0, screenPoint.X, 0, screenPoint.Y - 50) -- над игроком
                    label.TextStrokeTransparency = 0.5
                    label.TextStrokeColor3 = Color3.new(0, 0, 0)
                end
            end
        else
            -- Скрываем ESP если игрок не на экране
            for _, tracer in pairs(espData.tracers) do
                tracer.Visible = false
            end
            for _, label in pairs(espData.labels) do
                label.Visible = false
            end
        end
    end)
end

function removeESP()
    for player, espData in pairs(espItems) do
        if espData.folder then
            espData.folder:Destroy()
        end
    end
    espItems = {}
end

-- Создание элементов интерфейса
createToggle("AimBot", scrollFrame, false)
createSlider("FOV", scrollFrame, 10, 200, 50)
createSlider("Smoothness", scrollFrame, 1, 10, 1)
createToggle("Team Check", scrollFrame, false)
createToggle("Tracers", scrollFrame, false)
createToggle("Distance Health", scrollFrame, false)
createDropdown("Aim Part", scrollFrame, {"Head", "HumanoidRootPart", "UpperTorso"}, "Head")

-- Кнопка переоткрытия меню
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

-- Функция переключения меню
local function toggleMenu()
    mainFrame.Visible = not mainFrame.Visible
end

toggleButton.MouseButton1Click:Connect(toggleMenu)
toggleButton.TouchTap:Connect(toggleMenu)

-- Основной цикл аимбота
RunService.RenderStepped:Connect(function()    
    -- Аимбот логика
    if settings.aimbot then
        local target = findTarget()
        if target then
            aimAtTarget(target)
        end
    end
    
    -- ESP логика
    if settings.tracers or settings.distanceHealth then
        -- Автоматическое обновление ESP
        for player, espData in pairs(espItems) do
            if not player.Character or not player.Character:FindFirstChild("Humanoid") or player.Character.Humanoid.Health <= 0 then
                if espData.folder then
                    espData.folder:Destroy()
                    espItems[player] = nil
                end
            end
        end
    end
end)

-- Защита от удаления GUI при смерти
player.CharacterAdded:Connect(function()
    if not gui or not gui.Parent then
        gui = Instance.new("ScreenGui")
        gui.Name = "AimbotGUI"
        gui.Parent = CoreGui
        print("GUI был пересоздан после смерти")
    end
end)

print("Aimbot Menu loaded! Use the square button to toggle menu.")
print("Drag the title bar to move the menu!")
print("ESP features: Tracers Line and Distance Health Info")