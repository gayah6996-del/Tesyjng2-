-- Services
local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local players = game:GetService("Players")
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")

-- Aimbot & ESP Variables
local aimbotEnabled = false
local espEnabled = false
local teamCheckEnabled = false
local fovRadius = 100
local aimbotMaxDistance = 100
local guiName = "ASTRALCHEAT"
local guiVisible = true
local espObjects = {}
local aimbotTarget = "Head"

-- Переменные для камеры
local customCameraFOVEnabled = false
local cameraFOV = 70

-- Переменные для Infinite Jump
local infiniteJumpEnabled = false

-- Переменные для SpeedHack
local speedHackEnabled = false
local speedMultiplier = 1
local originalWalkSpeed = 16

-- Переменные для перемещения GUI
local frame = nil
local isDragging = false
local dragStart = nil
local frameStart = nil
local activeTab = "Info"

-- Переменные для системы ключа
local keyActivated = false
local keyStartTime = nil
local keyDuration = 20 * 60 -- 20 минут в секундах
local keyTimerConnection = nil

-- Переменная для невидимости
local invisibleEnabled = false

-- Система языка
local currentLanguage = "Russian"
local translations = {
    Russian = {
        -- Вкладки
        tabInfo = "Инфо",
        tabESP = "ESP", 
        tabAimBot = "АимБот",
        tabCamera = "Камера",
        tabLanguage = "Язык",
        
        -- Общие
        infoTitle = "ASTRALCHEAT v1.0",
        close = "Закрыть",
        hideGUI = "Скрыть GUI",
        showGUI = "Показать GUI",
        on = "ВКЛ",
        off = "ВЫКЛ",
        head = "Голова",
        body = "Тело",
        
        -- Info tab
        infoText = "ASTRALCHEAT v1.0\n\nРазработчик: @SFXCL\n\nФункции:\n• Aimbot с настройкой\n• ESP с боксами\n• Настройка FOV\n• Кастомный FOV камеры\n• Ограничение дистанции аимбота\n• Infinite Jump\n• SpeedHack\n• Невидимость\n\nИспользуйте на свой страх и риск!",
        keyTime = "Оставшееся время ключа: %02d:%02d",
        
        -- ESP tab
        esp = "ESP",
        invisible = "Невидимость",
        
        -- AimBot tab
        aimbot = "Aimbot",
        target = "Цель",
        fovRadius = "Радиус FOV",
        aimbotDistance = "Дистанция аимбота",
        
        -- Camera tab
        speedHack = "SpeedHack",
        infiniteJump = "Беск. прыжок",
        cameraFOV = "FOV камеры",
        
        -- Language tab
        language = "Язык",
        russian = "Русский",
        english = "Английский",
        selectLanguage = "Выберите язык",
        
        -- Подтверждение закрытия
        confirmClose = "Вы хотите закрыть меню?",
        yes = "Да",
        no = "Нет"
    },
    English = {
        -- Вкладки
        tabInfo = "Info",
        tabESP = "ESP",
        tabAimBot = "AimBot", 
        tabCamera = "Camera",
        tabLanguage = "Language",
        
        -- Общие
        infoTitle = "ASTRALCHEAT v1.0",
        close = "Close",
        hideGUI = "Hide GUI",
        showGUI = "Show GUI",
        on = "ON",
        off = "OFF",
        head = "Head",
        body = "Body",
        
        -- Info tab
        infoText = "ASTRALCHEAT v1.0\n\nDeveloper: @SFXCL\n\nFeatures:\n• Aimbot with settings\n• ESP with boxes\n• FOV settings\n• Custom camera FOV\n• Aimbot distance limit\n• Infinite Jump\n• SpeedHack\n• Invisibility\n\nUse at your own risk!",
        keyTime = "Key time remaining: %02d:%02d",
        
        -- ESP tab
        esp = "ESP",
        invisible = "Invisible",
        
        -- AimBot tab
        aimbot = "Aimbot",
        target = "Target",
        fovRadius = "FOV Radius",
        aimbotDistance = "Aimbot Distance",
        
        -- Camera tab
        speedHack = "SpeedHack",
        infiniteJump = "Infinite Jump",
        cameraFOV = "Camera FOV",
        
        -- Language tab
        language = "Language",
        russian = "Russian",
        english = "English",
        selectLanguage = "Select language",
        
        -- Подтверждение закрытия
        confirmClose = "Do you want to close menu?",
        yes = "Yes",
        no = "No"
    }
}

-- FOV Circle
local circle = Drawing.new("Circle")
circle.Color = Color3.fromRGB(255, 255, 255)
circle.Thickness = 1
circle.Filled = false
circle.Radius = fovRadius
circle.Visible = true
circle.Position = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)

-- Функция для получения перевода
local function t(key)
    return translations[currentLanguage][key] or key
end

-- Функция для полного отключения всех функций
local function disableAllFeatures()
    aimbotEnabled = false
    espEnabled = false
    customCameraFOVEnabled = false
    infiniteJumpEnabled = false
    speedHackEnabled = false
    invisibleEnabled = false
    
    if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = originalWalkSpeed
    end
    camera.FieldOfView = 70
    
    if player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 0
            end
        end
    end
    
    if circle then
        circle:Remove()
    end
    
    for _, drawings in pairs(espObjects) do
        if drawings then
            for _, drawing in pairs(drawings) do
                if drawing then
                    drawing:Remove()
                end
            end
        end
    end
    espObjects = {}
    
    if keyTimerConnection then
        keyTimerConnection:Disconnect()
        keyTimerConnection = nil
    end
end

-- Функция для включения/выключения невидимости
local function toggleInvisibility()
    if not player.Character then return end
    
    if invisibleEnabled then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 1
            end
        end
    else
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 0
            end
        end
    end
end

-- Infinite Jump Functionality
userInputService.JumpRequest:connect(function()
    if infiniteJumpEnabled then
        game:GetService"Players".LocalPlayer.Character:FindFirstChildOfClass'Humanoid':ChangeState("Jumping")
    end
end)

-- SpeedHack Functionality
local function updateSpeed()
    if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if speedHackEnabled then
            humanoid.WalkSpeed = originalWalkSpeed * speedMultiplier
        else
            humanoid.WalkSpeed = originalWalkSpeed
        end
    end
end

-- Функция для обновления времени ключа в Info
local function updateKeyTime()
    if not keyStartTime then return end
    
    local elapsed = os.time() - keyStartTime
    local remaining = keyDuration - elapsed
    
    if remaining <= 0 then
        disableAllFeatures()
        if frame and frame.Parent then
            frame.Parent:Destroy()
        end
        return
    end
    
    local minutes = math.floor(remaining / 60)
    local seconds = remaining % 60
    
    return string.format(t("keyTime"), minutes, seconds)
end

-- Show Notification
local function showNotification()
    local notification = Instance.new("ScreenGui")
    notification.Name = "NotificationGUI"
    notification.ResetOnSpawn = false
    notification.Parent = player:WaitForChild("PlayerGui")

    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://9125402735"
    sound.Volume = 1
    sound.Parent = notification
    sound:Play()

    local textLabel = Instance.new("TextLabel")
    textLabel.Parent = notification
    textLabel.Size = UDim2.new(0, 250, 0, 50)
    textLabel.Position = UDim2.new(1, -260, 1, -60)
    textLabel.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    textLabel.BorderSizePixel = 0
    textLabel.Text = "ASTRALCHEAT успешно запущен!"
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.SourceSansBold

    task.delay(3, function()
        for i = 1, 10 do
            textLabel.TextTransparency = i * 0.1
            textLabel.BackgroundTransparency = i * 0.1
            task.wait(0.05)
        end
        notification:Destroy()
    end)
end

-- Create ESP for a player
local function createESPForPlayer(p)
    local nameTag = Drawing.new("Text")
    nameTag.Size = 14
    nameTag.Color = Color3.fromRGB(255, 0, 0)
    nameTag.Center = true
    nameTag.Outline = true

    local distanceTag = Drawing.new("Text")
    distanceTag.Size = 13
    distanceTag.Color = Color3.fromRGB(255, 0, 0)
    distanceTag.Center = true
    distanceTag.Outline = true

    local box = Drawing.new("Square")
    box.Thickness = 1
    box.Color = Color3.fromRGB(255, 0, 0)
    box.Filled = false

    local tracer = Drawing.new("Line")
    tracer.Thickness = 1
    tracer.Color = Color3.fromRGB(255, 0, 0)

    espObjects[p] = {
        name = nameTag,
        distance = distanceTag,
        box = box,
        tracer = tracer
    }
end

-- Remove ESP
local function removeESPForPlayer(p)
    if espObjects[p] then
        for _, drawing in pairs(espObjects[p]) do
            drawing:Remove()
        end
        espObjects[p] = nil
    end
end

players.PlayerRemoving:Connect(removeESPForPlayer)

-- Visibility Check
local function isVisible(part)
    if not part then return false end
    local origin = camera.CFrame.Position
    local direction = (part.Position - origin)
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist
    rayParams.FilterDescendantsInstances = { player.Character or workspace }
    local result = workspace:Raycast(origin, direction, rayParams)
    if result then
        return part:IsDescendantOf(result.Instance.Parent) or result.Instance:IsDescendantOf(part.Parent)
    else
        return true
    end
end

-- Closest Player Function (with team check and distance check)
local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = fovRadius

    for _, p in pairs(players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
            if teamCheckEnabled and p.Team == player.Team then
                continue
            end
            
            local targetPart = p.Character:FindFirstChild(aimbotTarget)
            if not targetPart then
                targetPart = p.Character.Head
            end
            
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local distanceToPlayer = (player.Character.HumanoidRootPart.Position - targetPart.Position).Magnitude
                if distanceToPlayer > aimbotMaxDistance then
                    continue
                end
            end
            
            local screenPos, onScreen = camera:WorldToViewportPoint(targetPart.Position)
            if onScreen then
                local distanceFromCenter = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)).Magnitude
                if distanceFromCenter < shortestDistance and isVisible(targetPart) then
                    shortestDistance = distanceFromCenter
                    closestPlayer = p
                end
            end
        end
    end

    return closestPlayer
end

-- Main GUI Creation Function
local function createMainGUI()
    local gui = Instance.new("ScreenGui")
    gui.Name = guiName
    gui.ResetOnSpawn = false
    gui.Parent = player:WaitForChild("PlayerGui")

    -- Основной контейнер
    frame = Instance.new("Frame", gui)
    frame.Position = UDim2.new(0.5, -175, 0.5, -150)
    frame.Size = UDim2.new(0, 350, 0, 300)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BorderSizePixel = 1
    frame.BorderColor3 = Color3.fromRGB(100, 100, 100)
    frame.Visible = guiVisible

    -- Заголовок
    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, 0, 0, 25)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    title.Text = t("infoTitle")
    title.TextColor3 = Color3.new(1, 1, 1)
    title.TextScaled = true
    title.Font = Enum.Font.SourceSansBold
    title.BorderSizePixel = 0

    -- Кнопка закрытия
    local closeButton = Instance.new("TextButton", frame)
    closeButton.Size = UDim2.new(0, 25, 0, 25)
    closeButton.Position = UDim2.new(1, -25, 0, 0)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.new(1, 1, 1)
    closeButton.TextScaled = true
    closeButton.BorderSizePixel = 0
    closeButton.ZIndex = 2

    -- Контейнер для подтверждения закрытия
    local confirmFrame = Instance.new("Frame", gui)
    confirmFrame.Size = UDim2.new(0, 300, 0, 120)
    confirmFrame.Position = UDim2.new(0.5, -150, 0.5, -60)
    confirmFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    confirmFrame.BorderSizePixel = 1
    confirmFrame.BorderColor3 = Color3.fromRGB(100, 100, 100)
    confirmFrame.Visible = false
    confirmFrame.ZIndex = 100

    local confirmText = Instance.new("TextLabel", confirmFrame)
    confirmText.Size = UDim2.new(0.9, 0, 0.4, 0)
    confirmText.Position = UDim2.new(0.05, 0, 0.1, 0)
    confirmText.BackgroundTransparency = 1
    confirmText.Text = t("confirmClose")
    confirmText.TextColor3 = Color3.new(1, 1, 1)
    confirmText.TextScaled = true
    confirmText.Font = Enum.Font.SourceSansBold
    confirmText.ZIndex = 101

    local yesButton = Instance.new("TextButton", confirmFrame)
    yesButton.Size = UDim2.new(0.4, 0, 0.3, 0)
    yesButton.Position = UDim2.new(0.05, 0, 0.55, 0)
    yesButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    yesButton.Text = t("yes")
    yesButton.TextColor3 = Color3.new(1, 1, 1)
    yesButton.TextScaled = true
    yesButton.BorderSizePixel = 0
    yesButton.ZIndex = 101

    local noButton = Instance.new("TextButton", confirmFrame)
    noButton.Size = UDim2.new(0.4, 0, 0.3, 0)
    noButton.Position = UDim2.new(0.55, 0, 0.55, 0)
    noButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
    noButton.Text = t("no")
    noButton.TextColor3 = Color3.new(1, 1, 1)
    noButton.TextScaled = true
    noButton.BorderSizePixel = 0
    noButton.ZIndex = 101

    -- Основной контейнер
    local mainContainer = Instance.new("Frame", frame)
    mainContainer.Size = UDim2.new(1, 0, 1, -25)
    mainContainer.Position = UDim2.new(0, 0, 0, 25)
    mainContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainContainer.BorderSizePixel = 0

    -- Панель вкладок
    local tabsPanel = Instance.new("Frame", mainContainer)
    tabsPanel.Size = UDim2.new(0, 80, 1, 0)
    tabsPanel.Position = UDim2.new(0, 0, 0, 0)
    tabsPanel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    tabsPanel.BorderSizePixel = 0

    -- Контейнер для контента
    local contentContainer = Instance.new("Frame", mainContainer)
    contentContainer.Size = UDim2.new(1, -80, 1, 0)
    contentContainer.Position = UDim2.new(0, 80, 0, 0)
    contentContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    contentContainer.BorderSizePixel = 0

    -- Создаем вкладки
    local tabButtons = {}
    local tabContainers = {}
    
    local tabNames = {"Info", "ESP", "AimBot", "Camera", "Language"}
    local tabTranslations = {
        Info = "tabInfo",
        ESP = "tabESP", 
        AimBot = "tabAimBot",
        Camera = "tabCamera",
        Language = "tabLanguage"
    }
    
    for i, tabName in ipairs(tabNames) do
        -- Кнопка вкладки
        local tabButton = Instance.new("TextButton", tabsPanel)
        tabButton.Size = UDim2.new(0.9, 0, 0, 25)
        tabButton.Position = UDim2.new(0.05, 0, 0.02 + (i-1)*0.1, 0)
        tabButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        tabButton.Text = t(tabTranslations[tabName])
        tabButton.TextColor3 = Color3.new(1, 1, 1)
        tabButton.TextScaled = true
        tabButton.BorderSizePixel = 1
        tabButton.BorderColor3 = Color3.fromRGB(150, 150, 150)
        tabButton.Name = tabName
        
        -- Контейнер вкладки
        local tabContainer = Instance.new("Frame", contentContainer)
        tabContainer.Size = UDim2.new(1, 0, 1, 0)
        tabContainer.Position = UDim2.new(0, 0, 0, 0)
        tabContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        tabContainer.BorderSizePixel = 0
        tabContainer.Visible = false
        tabContainer.Name = tabName
        
        tabButtons[tabName] = tabButton
        tabContainers[tabName] = tabContainer
    end

    -- ========== ВКЛАДКА INFO ==========
    local infoContainer = tabContainers.Info
    infoContainer.Visible = true
    
    local infoText = Instance.new("TextLabel", infoContainer)
    infoText.Size = UDim2.new(0.9, 0, 0.8, 0)
    infoText.Position = UDim2.new(0.05, 0, 0.05, 0)
    infoText.BackgroundTransparency = 1
    infoText.Text = t("infoText")
    infoText.TextColor3 = Color3.new(1, 1, 1)
    infoText.TextScaled = true
    infoText.TextWrapped = true
    infoText.Font = Enum.Font.SourceSans

    -- ========== ВКЛАДКА ESP ==========
    local espContainer = tabContainers.ESP
    
    local espButton = Instance.new("TextButton", espContainer)
    espButton.Size = UDim2.new(0.9, 0, 0, 35)
    espButton.Position = UDim2.new(0.05, 0, 0.05, 0)
    espButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    espButton.Text = t("esp") .. ": " .. t("off")
    espButton.TextColor3 = Color3.new(1, 1, 1)
    espButton.TextScaled = true
    espButton.BorderSizePixel = 0

    local invisibleButton = Instance.new("TextButton", espContainer)
    invisibleButton.Size = UDim2.new(0.9, 0, 0, 35)
    invisibleButton.Position = UDim2.new(0.05, 0, 0.20, 0)
    invisibleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    invisibleButton.Text = t("invisible") .. ": " .. t("off")
    invisibleButton.TextColor3 = Color3.new(1, 1, 1)
    invisibleButton.TextScaled = true
    invisibleButton.BorderSizePixel = 0

    -- ========== ВКЛАДКА AIMBOT ==========
    local aimbotContainer = tabContainers.AimBot
    
    local aimbotButton = Instance.new("TextButton", aimbotContainer)
    aimbotButton.Size = UDim2.new(0.9, 0, 0, 35)
    aimbotButton.Position = UDim2.new(0.05, 0, 0.05, 0)
    aimbotButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    aimbotButton.Text = t("aimbot") .. ": " .. t("off")
    aimbotButton.TextColor3 = Color3.new(1, 1, 1)
    aimbotButton.TextScaled = true
    aimbotButton.BorderSizePixel = 0

    local targetDropdown = Instance.new("TextButton", aimbotContainer)
    targetDropdown.Size = UDim2.new(0.9, 0, 0, 35)
    targetDropdown.Position = UDim2.new(0.05, 0, 0.20, 0)
    targetDropdown.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    targetDropdown.Text = t("target") .. ": " .. t("head")
    targetDropdown.TextColor3 = Color3.new(1, 1, 1)
    targetDropdown.TextScaled = true
    targetDropdown.BorderSizePixel = 0

    -- Контейнер для выпадающего списка цели
    local dropdownContainer = Instance.new("Frame", aimbotContainer)
    dropdownContainer.Size = UDim2.new(0.9, 0, 0, 70)
    dropdownContainer.Position = UDim2.new(0.05, 0, 0.20, 35)
    dropdownContainer.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    dropdownContainer.BorderSizePixel = 1
    dropdownContainer.BorderColor3 = Color3.fromRGB(100, 100, 100)
    dropdownContainer.Visible = false
    dropdownContainer.ZIndex = 10

    local headButton = Instance.new("TextButton", dropdownContainer)
    headButton.Size = UDim2.new(1, 0, 0, 35)
    headButton.Position = UDim2.new(0, 0, 0, 0)
    headButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    headButton.Text = t("head")
    headButton.TextColor3 = Color3.new(1, 1, 1)
    headButton.TextScaled = true
    headButton.BorderSizePixel = 0
    headButton.ZIndex = 11

    local bodyButton = Instance.new("TextButton", dropdownContainer)
    bodyButton.Size = UDim2.new(1, 0, 0, 35)
    bodyButton.Position = UDim2.new(0, 0, 0, 35)
    bodyButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    bodyButton.Text = t("body")
    bodyButton.TextColor3 = Color3.new(1, 1, 1)
    bodyButton.TextScaled = true
    bodyButton.BorderSizePixel = 0
    bodyButton.ZIndex = 11

    -- FOV Slider
    local fovSliderFrame = Instance.new("Frame", aimbotContainer)
    fovSliderFrame.Size = UDim2.new(0.9, 0, 0, 60)
    fovSliderFrame.Position = UDim2.new(0.05, 0, 0.35, 0)
    fovSliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    fovSliderFrame.BorderSizePixel = 0

    local fovLabel = Instance.new("TextLabel", fovSliderFrame)
    fovLabel.Size = UDim2.new(1, 0, 0.3, 0)
    fovLabel.Position = UDim2.new(0, 0, 0, 0)
    fovLabel.BackgroundTransparency = 1
    fovLabel.Text = t("fovRadius") .. ": " .. fovRadius
    fovLabel.TextColor3 = Color3.new(1, 1, 1)
    fovLabel.TextScaled = true
    fovLabel.Font = Enum.Font.SourceSans

    local sliderBackground = Instance.new("TextButton", fovSliderFrame)
    sliderBackground.Size = UDim2.new(1, 0, 0.4, 0)
    sliderBackground.Position = UDim2.new(0, 0, 0.4, 0)
    sliderBackground.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    sliderBackground.BorderSizePixel = 0
    sliderBackground.Text = ""
    sliderBackground.AutoButtonColor = false

    local sliderFill = Instance.new("Frame", sliderBackground)
    sliderFill.Size = UDim2.new((fovRadius - 50) / 200, 0, 1, 0)
    sliderFill.Position = UDim2.new(0, 0, 0, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    sliderFill.BorderSizePixel = 0

    local sliderButton = Instance.new("Frame", sliderBackground)
    sliderButton.Size = UDim2.new(0, 15, 1.5, 0)
    sliderButton.Position = UDim2.new((fovRadius - 50) / 200, -7, -0.25, 0)
    sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderButton.BorderSizePixel = 1
    sliderButton.BorderColor3 = Color3.fromRGB(200, 200, 200)

    local minusButton = Instance.new("TextButton", fovSliderFrame)
    minusButton.Size = UDim2.new(0.2, 0, 0.3, 0)
    minusButton.Position = UDim2.new(0, 0, 0.8, 10)
    minusButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    minusButton.Text = "-"
    minusButton.TextColor3 = Color3.new(1, 1, 1)
    minusButton.TextScaled = true
    minusButton.BorderSizePixel = 0

    local plusButton = Instance.new("TextButton", fovSliderFrame)
    plusButton.Size = UDim2.new(0.2, 0, 0.3, 0)
    plusButton.Position = UDim2.new(0.8, 0, 0.8, 10)
    plusButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    plusButton.Text = "+"
    plusButton.TextColor3 = Color3.new(1, 1, 1)
    plusButton.TextScaled = true
    plusButton.BorderSizePixel = 0

    -- Distance Slider
    local distanceSliderFrame = Instance.new("Frame", aimbotContainer)
    distanceSliderFrame.Size = UDim2.new(0.9, 0, 0, 60)
    distanceSliderFrame.Position = UDim2.new(0.05, 0, 0.50, 0)
    distanceSliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    distanceSliderFrame.BorderSizePixel = 0

    local distanceLabel = Instance.new("TextLabel", distanceSliderFrame)
    distanceLabel.Size = UDim2.new(1, 0, 0.3, 0)
    distanceLabel.Position = UDim2.new(0, 0, 0, 0)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.Text = t("aimbotDistance") .. ": " .. aimbotMaxDistance
    distanceLabel.TextColor3 = Color3.new(1, 1, 1)
    distanceLabel.TextScaled = true
    distanceLabel.Font = Enum.Font.SourceSans

    local distanceSliderBackground = Instance.new("TextButton", distanceSliderFrame)
    distanceSliderBackground.Size = UDim2.new(1, 0, 0.4, 0)
    distanceSliderBackground.Position = UDim2.new(0, 0, 0.4, 0)
    distanceSliderBackground.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    distanceSliderBackground.BorderSizePixel = 0
    distanceSliderBackground.Text = ""
    distanceSliderBackground.AutoButtonColor = false

    local distanceSliderFill = Instance.new("Frame", distanceSliderBackground)
    distanceSliderFill.Size = UDim2.new((aimbotMaxDistance - 10) / 190, 0, 1, 0)
    distanceSliderFill.Position = UDim2.new(0, 0, 0, 0)
    distanceSliderFill.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
    distanceSliderFill.BorderSizePixel = 0

    local distanceSliderButton = Instance.new("Frame", distanceSliderBackground)
    distanceSliderButton.Size = UDim2.new(0, 15, 1.5, 0)
    distanceSliderButton.Position = UDim2.new((aimbotMaxDistance - 10) / 190, -7, -0.25, 0)
    distanceSliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    distanceSliderButton.BorderSizePixel = 1
    distanceSliderButton.BorderColor3 = Color3.fromRGB(200, 200, 200)

    local distanceMinusButton = Instance.new("TextButton", distanceSliderFrame)
    distanceMinusButton.Size = UDim2.new(0.2, 0, 0.3, 0)
    distanceMinusButton.Position = UDim2.new(0, 0, 0.8, 10)
    distanceMinusButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    distanceMinusButton.Text = "-"
    distanceMinusButton.TextColor3 = Color3.new(1, 1, 1)
    distanceMinusButton.TextScaled = true
    distanceMinusButton.BorderSizePixel = 0

    local distancePlusButton = Instance.new("TextButton", distanceSliderFrame)
    distancePlusButton.Size = UDim2.new(0.2, 0, 0.3, 0)
    distancePlusButton.Position = UDim2.new(0.8, 0, 0.8, 10)
    distancePlusButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    distancePlusButton.Text = "+"
    distancePlusButton.TextColor3 = Color3.new(1, 1, 1)
    distancePlusButton.TextScaled = true
    distancePlusButton.BorderSizePixel = 0

    -- ========== ВКЛАДКА CAMERA ==========
    local cameraContainer = tabContainers.Camera
    
    local speedHackButton = Instance.new("TextButton", cameraContainer)
    speedHackButton.Size = UDim2.new(0.9, 0, 0, 30)
    speedHackButton.Position = UDim2.new(0.05, 0, 0.05, 0)
    speedHackButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    speedHackButton.Text = t("speedHack") .. ": " .. t("off")
    speedHackButton.TextColor3 = Color3.new(1, 1, 1)
    speedHackButton.TextScaled = true
    speedHackButton.BorderSizePixel = 0

    local infiniteJumpButton = Instance.new("TextButton", cameraContainer)
    infiniteJumpButton.Size = UDim2.new(0.9, 0, 0, 30)
    infiniteJumpButton.Position = UDim2.new(0.05, 0, 0.18, 0)
    infiniteJumpButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    infiniteJumpButton.Text = t("infiniteJump") .. ": " .. t("off")
    infiniteJumpButton.TextColor3 = Color3.new(1, 1, 1)
    infiniteJumpButton.TextScaled = true
    infiniteJumpButton.BorderSizePixel = 0

    local cameraFOVButton = Instance.new("TextButton", cameraContainer)
    cameraFOVButton.Size = UDim2.new(0.9, 0, 0, 30)
    cameraFOVButton.Position = UDim2.new(0.05, 0, 0.30, 0)
    cameraFOVButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    cameraFOVButton.Text = t("cameraFOV") .. ": " .. t("off")
    cameraFOVButton.TextColor3 = Color3.new(1, 1, 1)
    cameraFOVButton.TextScaled = true
    cameraFOVButton.BorderSizePixel = 0

    -- Camera FOV Slider
    local cameraFOVSliderFrame = Instance.new("Frame", cameraContainer)
    cameraFOVSliderFrame.Size = UDim2.new(0.9, 0, 0, 50)
    cameraFOVSliderFrame.Position = UDim2.new(0.05, 0, 0.43, 0)
    cameraFOVSliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    cameraFOVSliderFrame.BorderSizePixel = 0

    local cameraFOVLabel = Instance.new("TextLabel", cameraFOVSliderFrame)
    cameraFOVLabel.Size = UDim2.new(1, 0, 0.3, 0)
    cameraFOVLabel.Position = UDim2.new(0, 0, 0, 0)
    cameraFOVLabel.BackgroundTransparency = 1
    cameraFOVLabel.Text = t("cameraFOV") .. ": " .. cameraFOV
    cameraFOVLabel.TextColor3 = Color3.new(1, 1, 1)
    cameraFOVLabel.TextScaled = true
    cameraFOVLabel.Font = Enum.Font.SourceSans

    local cameraSliderBackground = Instance.new("TextButton", cameraFOVSliderFrame)
    cameraSliderBackground.Size = UDim2.new(1, 0, 0.4, 0)
    cameraSliderBackground.Position = UDim2.new(0, 0, 0.4, 0)
    cameraSliderBackground.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    cameraSliderBackground.BorderSizePixel = 0
    cameraSliderBackground.Text = ""
    cameraSliderBackground.AutoButtonColor = false

    local cameraSliderFill = Instance.new("Frame", cameraSliderBackground)
    cameraSliderFill.Size = UDim2.new((cameraFOV - 30) / 90, 0, 1, 0)
    cameraSliderFill.Position = UDim2.new(0, 0, 0, 0)
    cameraSliderFill.BackgroundColor3 = Color3.fromRGB(170, 0, 255)
    cameraSliderFill.BorderSizePixel = 0

    local cameraSliderButton = Instance.new("Frame", cameraSliderBackground)
    cameraSliderButton.Size = UDim2.new(0, 15, 1.5, 0)
    cameraSliderButton.Position = UDim2.new((cameraFOV - 30) / 90, -7, -0.25, 0)
    cameraSliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    cameraSliderButton.BorderSizePixel = 1
    cameraSliderButton.BorderColor3 = Color3.fromRGB(200, 200, 200)

    local cameraMinusButton = Instance.new("TextButton", cameraFOVSliderFrame)
    cameraMinusButton.Size = UDim2.new(0.2, 0, 0.3, 0)
    cameraMinusButton.Position = UDim2.new(0, 0, 0.8, 10)
    cameraMinusButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    cameraMinusButton.Text = "-"
    cameraMinusButton.TextColor3 = Color3.new(1, 1, 1)
    cameraMinusButton.TextScaled = true
    cameraMinusButton.BorderSizePixel = 0

    local cameraPlusButton = Instance.new("TextButton", cameraFOVSliderFrame)
    cameraPlusButton.Size = UDim2.new(0.2, 0, 0.3, 0)
    cameraPlusButton.Position = UDim2.new(0.8, 0, 0.8, 10)
    cameraPlusButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    cameraPlusButton.Text = "+"
    cameraPlusButton.TextColor3 = Color3.new(1, 1, 1)
    cameraPlusButton.TextScaled = true
    cameraPlusButton.BorderSizePixel = 0

    -- ========== ВКЛАДКА LANGUAGE ==========
    local languageContainer = tabContainers.Language
    
    local languageText = Instance.new("TextLabel", languageContainer)
    languageText.Size = UDim2.new(0.9, 0, 0.2, 0)
    languageText.Position = UDim2.new(0.05, 0, 0.05, 0)
    languageText.BackgroundTransparency = 1
    languageText.Text = t("selectLanguage")
    languageText.TextColor3 = Color3.new(1, 1, 1)
    languageText.TextScaled = true
    languageText.Font = Enum.Font.SourceSansBold

    local languageDropdown = Instance.new("TextButton", languageContainer)
    languageDropdown.Size = UDim2.new(0.9, 0, 0, 35)
    languageDropdown.Position = UDim2.new(0.05, 0, 0.3, 0)
    languageDropdown.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    languageDropdown.Text = t("language") .. ": " .. t(currentLanguage:lower())
    languageDropdown.TextColor3 = Color3.new(1, 1, 1)
    languageDropdown.TextScaled = true
    languageDropdown.BorderSizePixel = 0

    -- Контейнер для выпадающего списка языка
    local languageDropdownContainer = Instance.new("Frame", languageContainer)
    languageDropdownContainer.Size = UDim2.new(0.9, 0, 0, 70)
    languageDropdownContainer.Position = UDim2.new(0.05, 0, 0.3, 35)
    languageDropdownContainer.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    languageDropdownContainer.BorderSizePixel = 1
    languageDropdownContainer.BorderColor3 = Color3.fromRGB(100, 100, 100)
    languageDropdownContainer.Visible = false
    languageDropdownContainer.ZIndex = 10

    local russianButton = Instance.new("TextButton", languageDropdownContainer)
    russianButton.Size = UDim2.new(1, 0, 0, 35)
    russianButton.Position = UDim2.new(0, 0, 0, 0)
    russianButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    russianButton.Text = "Русский"
    russianButton.TextColor3 = Color3.new(1, 1, 1)
    russianButton.TextScaled = true
    russianButton.BorderSizePixel = 0
    russianButton.ZIndex = 11

    local englishButton = Instance.new("TextButton", languageDropdownContainer)
    englishButton.Size = UDim2.new(1, 0, 0, 35)
    englishButton.Position = UDim2.new(0, 0, 0, 35)
    englishButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    englishButton.Text = "English"
    englishButton.TextColor3 = Color3.new(1, 1, 1)
    englishButton.TextScaled = true
    englishButton.BorderSizePixel = 0
    englishButton.ZIndex = 11

    -- Кнопка Hide/Show GUI
    local hideButton = Instance.new("TextButton", gui)
    hideButton.Size = UDim2.new(0, 150, 0, 40)
    hideButton.Position = UDim2.new(0.5, -75, 1, -50)
    hideButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    hideButton.Text = t("hideGUI")
    hideButton.TextColor3 = Color3.new(1, 1, 1)
    hideButton.TextScaled = true
    hideButton.BorderSizePixel = 0
    hideButton.ZIndex = 10

    -- Функция обновления текстов интерфейса
    local function updateInterfaceTexts()
        title.Text = t("infoTitle")
        confirmText.Text = t("confirmClose")
        yesButton.Text = t("yes")
        noButton.Text = t("no")
        hideButton.Text = guiVisible and t("hideGUI") or t("showGUI")
        infoText.Text = t("infoText")
        languageText.Text = t("selectLanguage")
        languageDropdown.Text = t("language") .. ": " .. t(currentLanguage:lower())
        
        -- Обновляем названия вкладок
        for tabName, button in pairs(tabButtons) do
            button.Text = t(tabTranslations[tabName])
        end
        
        -- Обновляем кнопки функций
        espButton.Text = t("esp") .. ": " .. (espEnabled and t("on") or t("off"))
        invisibleButton.Text = t("invisible") .. ": " .. (invisibleEnabled and t("on") or t("off"))
        aimbotButton.Text = t("aimbot") .. ": " .. (aimbotEnabled and t("on") or t("off"))
        targetDropdown.Text = t("target") .. ": " .. (aimbotTarget == "Head" and t("head") or t("body"))
        speedHackButton.Text = t("speedHack") .. ": " .. (speedHackEnabled and t("on") or t("off"))
        infiniteJumpButton.Text = t("infiniteJump") .. ": " .. (infiniteJumpEnabled and t("on") or t("off"))
        cameraFOVButton.Text = t("cameraFOV") .. ": " .. (customCameraFOVEnabled and t("on") or t("off"))
        
        -- Обновляем тексты слайдеров
        fovLabel.Text = t("fovRadius") .. ": " .. fovRadius
        distanceLabel.Text = t("aimbotDistance") .. ": " .. aimbotMaxDistance
        cameraFOVLabel.Text = t("cameraFOV") .. ": " .. cameraFOV
        
        -- Обновляем выпадающий список цели
        headButton.Text = t("head")
        bodyButton.Text = t("body")
    end

    -- Функция переключения вкладок
    local function switchTab(tabName)
        for _, container in pairs(tabContainers) do
            container.Visible = false
        end
        for _, button in pairs(tabButtons) do
            button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        end
        
        if tabContainers[tabName] then
            tabContainers[tabName].Visible = true
            tabButtons[tabName].BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            activeTab = tabName
        end
        
        -- Закрываем все выпадающие меню при переключении вкладок
        dropdownContainer.Visible = false
        languageDropdownContainer.Visible = false
        
        -- Возвращаем слайдеры на место
        fovSliderFrame.Position = UDim2.new(0.05, 0, 0.35, 0)
        distanceSliderFrame.Position = UDim2.new(0.05, 0, 0.50, 0)
    end

    -- Функция для открытия/закрытия выпадающего списка цели
    local function toggleTargetDropdown()
        local isOpening = not dropdownContainer.Visible
        dropdownContainer.Visible = isOpening
        
        if isOpening then
            -- Сдвигаем слайдеры вниз
            fovSliderFrame.Position = UDim2.new(0.05, 0, 0.60, 0)
            distanceSliderFrame.Position = UDim2.new(0.05, 0, 0.75, 0)
        else
            -- Возвращаем слайдеры на место
            fovSliderFrame.Position = UDim2.new(0.05, 0, 0.35, 0)
            distanceSliderFrame.Position = UDim2.new(0.05, 0, 0.50, 0)
        end
    end

    -- Функция для открытия/закрытия выпадающего списка языка
    local function toggleLanguageDropdown()
        languageDropdownContainer.Visible = not languageDropdownContainer.Visible
    end

    -- Обработчики вкладок
    for tabName, button in pairs(tabButtons) do
        button.MouseButton1Click:Connect(function()
            switchTab(tabName)
        end)
    end

    -- Функции обновления значений
    local function updateFOV(value)
        fovRadius = math.floor(math.clamp(value, 50, 250))
        circle.Radius = fovRadius
        fovLabel.Text = t("fovRadius") .. ": " .. fovRadius
        
        local fillSize = (fovRadius - 50) / 200
        sliderFill.Size = UDim2.new(fillSize, 0, 1, 0)
        sliderButton.Position = UDim2.new(fillSize, -7, -0.25, 0)
    end

    local function updateCameraFOV(value)
        cameraFOV = math.floor(math.clamp(value, 30, 120))
        cameraFOVLabel.Text = t("cameraFOV") .. ": " .. cameraFOV
        
        local fillSize = (cameraFOV - 30) / 90
        cameraSliderFill.Size = UDim2.new(fillSize, 0, 1, 0)
        cameraSliderButton.Position = UDim2.new(fillSize, -7, -0.25, 0)
        
        if customCameraFOVEnabled then
            camera.FieldOfView = cameraFOV
        end
    end

    local function updateAimbotDistance(value)
        aimbotMaxDistance = math.floor(math.clamp(value, 10, 200))
        distanceLabel.Text = t("aimbotDistance") .. ": " .. aimbotMaxDistance
        
        local fillSize = (aimbotMaxDistance - 10) / 190
        distanceSliderFill.Size = UDim2.new(fillSize, 0, 1, 0)
        distanceSliderButton.Position = UDim2.new(fillSize, -7, -0.25, 0)
    end

    -- Обработчики кнопок
    hideButton.MouseButton1Click:Connect(function()
        guiVisible = not guiVisible
        frame.Visible = guiVisible
        hideButton.Text = guiVisible and t("hideGUI") or t("showGUI")
    end)

    closeButton.MouseButton1Click:Connect(function()
        confirmFrame.Visible = true
    end)

    yesButton.MouseButton1Click:Connect(function()
        disableAllFeatures()
        gui:Destroy()
    end)

    noButton.MouseButton1Click:Connect(function()
        confirmFrame.Visible = false
    end)

    -- Обработчики функций
    espButton.MouseButton1Click:Connect(function()
        espEnabled = not espEnabled
        espButton.Text = t("esp") .. ": " .. (espEnabled and t("on") or t("off"))
        if not espEnabled then
            for _, drawings in pairs(espObjects) do
                if drawings then
                    drawings.box.Visible = false
                    drawings.name.Visible = false
                    drawings.distance.Visible = false
                    drawings.tracer.Visible = false
                end
            end
        end
    end)

    invisibleButton.MouseButton1Click:Connect(function()
        invisibleEnabled = not invisibleEnabled
        invisibleButton.Text = t("invisible") .. ": " .. (invisibleEnabled and t("on") or t("off"))
        toggleInvisibility()
    end)

    aimbotButton.MouseButton1Click:Connect(function()
        aimbotEnabled = not aimbotEnabled
        aimbotButton.Text = t("aimbot") .. ": " .. (aimbotEnabled and t("on") or t("off"))
    end)

    targetDropdown.MouseButton1Click:Connect(function()
        toggleTargetDropdown()
    end)

    headButton.MouseButton1Click:Connect(function()
        aimbotTarget = "Head"
        targetDropdown.Text = t("target") .. ": " .. t("head")
        toggleTargetDropdown()
        updateInterfaceTexts()
    end)

    bodyButton.MouseButton1Click:Connect(function()
        aimbotTarget = "HumanoidRootPart"
        targetDropdown.Text = t("target") .. ": " .. t("body")
        toggleTargetDropdown()
        updateInterfaceTexts()
    end)

    speedHackButton.MouseButton1Click:Connect(function()
        speedHackEnabled = not speedHackEnabled
        speedHackButton.Text = t("speedHack") .. ": " .. (speedHackEnabled and t("on") or t("off"))
        if speedHackEnabled and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            originalWalkSpeed = player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed
        end
        updateSpeed()
    end)

    infiniteJumpButton.MouseButton1Click:Connect(function()
        infiniteJumpEnabled = not infiniteJumpEnabled
        infiniteJumpButton.Text = t("infiniteJump") .. ": " .. (infiniteJumpEnabled and t("on") or t("off"))
    end)

    cameraFOVButton.MouseButton1Click:Connect(function()
        customCameraFOVEnabled = not customCameraFOVEnabled
        cameraFOVButton.Text = t("cameraFOV") .. ": " .. (customCameraFOVEnabled and t("on") or t("off"))
        if customCameraFOVEnabled then
            camera.FieldOfView = cameraFOV
        else
            camera.FieldOfView = 70
        end
    end)

    languageDropdown.MouseButton1Click:Connect(function()
        toggleLanguageDropdown()
    end)

    russianButton.MouseButton1Click:Connect(function()
        currentLanguage = "Russian"
        updateInterfaceTexts()
        toggleLanguageDropdown()
    end)

    englishButton.MouseButton1Click:Connect(function()
        currentLanguage = "English"
        updateInterfaceTexts()
        toggleLanguageDropdown()
    end)

    -- Обработчики слайдеров
    local function setupSlider(sliderBg, fill, button, minusBtn, plusBtn, updateFunc, minVal, maxVal, currentVal)
        local isSliding = false
        
        local function updateSlider(value)
            updateFunc(value)
        end
        
        sliderBg.MouseButton1Down:Connect(function(x, y)
            isSliding = true
            local relativeX = (x - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X
            relativeX = math.clamp(relativeX, 0, 1)
            local newValue = minVal + (relativeX * (maxVal - minVal))
            updateSlider(newValue)
        end)
        
        minusBtn.MouseButton1Click:Connect(function()
            updateSlider(currentVal - 10)
        end)
        
        plusBtn.MouseButton1Click:Connect(function()
            updateSlider(currentVal + 10)
        end)
        
        userInputService.InputChanged:Connect(function(input)
            if isSliding and input.UserInputType == Enum.UserInputType.Touch then
                local relativeX = (input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X
                relativeX = math.clamp(relativeX, 0, 1)
                local newValue = minVal + (relativeX * (maxVal - minVal))
                updateSlider(newValue)
            end
        end)
        
        userInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                isSliding = false
            end
        end)
    end

    -- Настраиваем слайдеры
    setupSlider(sliderBackground, sliderFill, sliderButton, minusButton, plusButton, updateFOV, 50, 250, fovRadius)
    setupSlider(distanceSliderBackground, distanceSliderFill, distanceSliderButton, distanceMinusButton, distancePlusButton, updateAimbotDistance, 10, 200, aimbotMaxDistance)
    setupSlider(cameraSliderBackground, cameraSliderFill, cameraSliderButton, cameraMinusButton, cameraPlusButton, updateCameraFOV, 30, 120, cameraFOV)

    -- Функции перемещения
    local function startDrag(input)
        isDragging = true
        dragStart = input.Position
        frameStart = frame.Position
    end

    local function endDrag()
        isDragging = false
    end

    local function updateDrag(input)
        if isDragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                frameStart.X.Scale, 
                frameStart.X.Offset + delta.X,
                frameStart.Y.Scale, 
                frameStart.Y.Offset + delta.Y
            )
        end
    end

    title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            startDrag(input)
        end
    end)

    title.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            endDrag()
        end
    end)

    userInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
            updateDrag(input)
        end
    end)

    -- Закрытие выпадающих списков при клике вне их
    userInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mousePos = input.Position
            
            -- Закрытие выпадающего списка цели
            if dropdownContainer.Visible then
                local dropdownAbsPos = dropdownContainer.AbsolutePosition
                local dropdownAbsSize = dropdownContainer.AbsoluteSize
                local targetDropdownAbsPos = targetDropdown.AbsolutePosition
                local targetDropdownAbsSize = targetDropdown.AbsoluteSize

                if not (mousePos.X >= dropdownAbsPos.X and mousePos.X <= dropdownAbsPos.X + dropdownAbsSize.X and
                       mousePos.Y >= dropdownAbsPos.Y and mousePos.Y <= dropdownAbsPos.Y + dropdownAbsSize.Y) and
                   not (mousePos.X >= targetDropdownAbsPos.X and mousePos.X <= targetDropdownAbsPos.X + targetDropdownAbsSize.X and
                       mousePos.Y >= targetDropdownAbsPos.Y and mousePos.Y <= targetDropdownAbsPos.Y + targetDropdownAbsSize.Y) then
                    toggleTargetDropdown()
                end
            end
            
            -- Закрытие выпадающего списка языка
            if languageDropdownContainer.Visible then
                local dropdownAbsPos = languageDropdownContainer.AbsolutePosition
                local dropdownAbsSize = languageDropdownContainer.AbsoluteSize
                if not (mousePos.X >= dropdownAbsPos.X and mousePos.X <= dropdownAbsPos.X + dropdownAbsSize.X and
                       mousePos.Y >= dropdownAbsPos.Y and mousePos.Y <= dropdownAbsPos.Y + dropdownAbsSize.Y) then
                    toggleLanguageDropdown()
                end
            end
        end
    end)

    -- Запускаем таймер для обновления времени ключа
    keyTimerConnection = runService.Heartbeat:Connect(function()
        local timeText = updateKeyTime()
        if timeText and infoText then
            infoText.Text = t("infoText") .. "\n\n" .. timeText
        end
    end)

    -- Инициализация
    switchTab("Info")
    updateInterfaceTexts()
end

-- Key System
local function createKeyGUI()
    local keyGui = Instance.new("ScreenGui")
    keyGui.Name = "KeyGUI"
    keyGui.ResetOnSpawn = false
    keyGui.Parent = player:WaitForChild("PlayerGui")

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 300, 0, 200)
    mainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.BorderSizePixel = 1
    mainFrame.BorderColor3 = Color3.fromRGB(100, 100, 100)
    mainFrame.Parent = keyGui

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    title.Text = "ASTRALCHEAT - Введите ключ"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.TextScaled = true
    title.Font = Enum.Font.SourceSansBold
    title.BorderSizePixel = 0
    title.Parent = mainFrame

    local keyBox = Instance.new("TextBox")
    keyBox.Size = UDim2.new(0.8, 0, 0, 35)
    keyBox.Position = UDim2.new(0.1, 0, 0.3, 0)
    keyBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    keyBox.BorderSizePixel = 1
    keyBox.BorderColor3 = Color3.fromRGB(100, 100, 100)
    keyBox.Text = ""
    keyBox.PlaceholderText = "Введите ключ..."
    keyBox.TextColor3 = Color3.new(1, 1, 1)
    keyBox.TextScaled = true
    keyBox.Parent = mainFrame

    local submitButton = Instance.new("TextButton")
    submitButton.Size = UDim2.new(0.6, 0, 0, 35)
    submitButton.Position = UDim2.new(0.2, 0, 0.6, 0)
    submitButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    submitButton.Text = "Проверить ключ"
    submitButton.TextColor3 = Color3.new(1, 1, 1)
    submitButton.TextScaled = true
    submitButton.BorderSizePixel = 0
    submitButton.Parent = mainFrame

    local messageLabel = Instance.new("TextLabel")
    messageLabel.Size = UDim2.new(0.8, 0, 0, 20)
    messageLabel.Position = UDim2.new(0.1, 0, 0.85, 0)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Text = ""
    messageLabel.TextColor3 = Color3.new(1, 1, 1)
    messageLabel.TextScaled = true
    messageLabel.Font = Enum.Font.SourceSans
    messageLabel.Parent = mainFrame

    submitButton.MouseButton1Click:Connect(function()
        if keyBox.Text == "SFXCL" then
            keyActivated = true
            keyStartTime = os.time()
            keyGui:Destroy()
            createMainGUI()
            showNotification()
        else
            messageLabel.Text = "Key None"
            messageLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        end
    end)

    keyBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            if keyBox.Text == "SFXCL" then
                keyActivated = true
                keyStartTime = os.time()
                keyGui:Destroy()
                createMainGUI()
                showNotification()
            else
                messageLabel.Text = "Key None"
                messageLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
            end
        end
    end)
end

-- Основной код
createKeyGUI()

player.CharacterAdded:Connect(function(character)
    task.wait(1)
    if speedHackEnabled then
        updateSpeed()
    end
    if invisibleEnabled then
        toggleInvisibility()
    end
end

runService.RenderStepped:Connect(function()
    circle.Position = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)

    if aimbotEnabled then
        local target = getClosestPlayer()
        if target and target.Character then
            local targetPart = target.Character:FindFirstChild(aimbotTarget)
            if not targetPart then
                targetPart = target.Character:FindFirstChild("Head")
            end
            
            if targetPart then
                local targetPos = targetPart.Position
                camera.CFrame = CFrame.new(camera.CFrame.Position, targetPos)
            end
        end
    end

    for _, p in pairs(players:GetPlayers()) do
        if p ~= player then
            if not espObjects[p] then
                createESPForPlayer(p)
            end

            local drawings = espObjects[p]
            local char = p.Character
            if espEnabled and char and char:FindFirstChild("Head") and char:FindFirstChild("HumanoidRootPart") then
                if teamCheckEnabled and p.Team == player.Team then
                    if drawings then
                        drawings.box.Visible = false
                        drawings.name.Visible = false
                        drawings.distance.Visible = false
                        drawings.tracer.Visible = false
                    end
                    continue
                end

                local head = char.Head
                local hrp = char.HumanoidRootPart
                local headPos2D, onScreen1 = camera:WorldToViewportPoint(head.Position)
                local rootPos2D, onScreen2 = camera:WorldToViewportPoint(hrp.Position)

                if onScreen1 and onScreen2 and drawings then
                    local height = (headPos2D - rootPos2D).Magnitude * 2
                    local width = height / 2

                    drawings.box.Size = Vector2.new(width, height)
                    drawings.box.Position = Vector2.new(rootPos2D.X - width/2, rootPos2D.Y - height/2)
                    drawings.box.Visible = true

                    drawings.name.Text = p.Name
                    drawings.name.Position = Vector2.new(headPos2D.X, headPos2D.Y - 20)
                    drawings.name.Visible = true

                    local distance = math.floor((player.Character.HumanoidRootPart.Position - hrp.Position).Magnitude)
                    drawings.distance.Text = tostring(distance) .. "m"
                    drawings.distance.Position = Vector2.new(rootPos2D.X, rootPos2D.Y + height/2 + 5)
                    drawings.distance.Visible = true

                    drawings.tracer.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                    drawings.tracer.To = Vector2.new(rootPos2D.X, rootPos2D.Y)
                    drawings.tracer.Visible = true
                elseif drawings then
                    drawings.box.Visible = false
                    drawings.name.Visible = false
                    drawings.distance.Visible = false
                    drawings.tracer.Visible = false
                end
            elseif drawings then
                drawings.box.Visible = false
                drawings.name.Visible = false
                drawings.distance.Visible = false
                drawings.tracer.Visible = false
            end
        end
    end
end)