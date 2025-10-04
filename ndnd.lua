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

-- FOV Circle
local circle = Drawing.new("Circle")
circle.Color = Color3.fromRGB(255, 255, 255)
circle.Thickness = 1
circle.Filled = false
circle.Radius = fovRadius
circle.Visible = true
circle.Position = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)

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
    textLabel.Text = "ASTRALCHEAT успешно запущен✅!"
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

    -- Основной контейнер (исходный размер)
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
    title.Text = "ASTRALCHEAT v1.0"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.TextScaled = true
    title.Font = Enum.Font.SourceSansBold
    title.BorderSizePixel = 0

    -- Кнопка закрытия (крестик)
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
    confirmText.Text = "Вы хотите закрыть меню?"
    confirmText.TextColor3 = Color3.new(1, 1, 1)
    confirmText.TextScaled = true
    confirmText.Font = Enum.Font.SourceSansBold
    confirmText.ZIndex = 101

    local yesButton = Instance.new("TextButton", confirmFrame)
    yesButton.Size = UDim2.new(0.4, 0, 0.3, 0)
    yesButton.Position = UDim2.new(0.05, 0, 0.55, 0)
    yesButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    yesButton.Text = "Да"
    yesButton.TextColor3 = Color3.new(1, 1, 1)
    yesButton.TextScaled = true
    yesButton.BorderSizePixel = 0
    yesButton.ZIndex = 101

    local noButton = Instance.new("TextButton", confirmFrame)
    noButton.Size = UDim2.new(0.4, 0, 0.3, 0)
    noButton.Position = UDim2.new(0.55, 0, 0.55, 0)
    noButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
    noButton.Text = "Нет"
    noButton.TextColor3 = Color3.new(1, 1, 1)
    noButton.TextScaled = true
    noButton.BorderSizePixel = 0
    noButton.ZIndex = 101

    -- Контейнер для вкладок и контента
    local mainContainer = Instance.new("Frame", frame)
    mainContainer.Size = UDim2.new(1, 0, 1, -25)
    mainContainer.Position = UDim2.new(0, 0, 0, 25)
    mainContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainContainer.BorderSizePixel = 0

    -- Панель вкладок (вертикальная)
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

    -- Вкладка Info (первая)
    local infoTabButton = Instance.new("TextButton", tabsPanel)
    infoTabButton.Size = UDim2.new(0.9, 0, 0, 25)
    infoTabButton.Position = UDim2.new(0.05, 0, 0.02, 0)
    infoTabButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    infoTabButton.Text = "Info"
    infoTabButton.TextColor3 = Color3.new(1, 1, 1)
    infoTabButton.TextScaled = true
    infoTabButton.BorderSizePixel = 1
    infoTabButton.BorderColor3 = Color3.fromRGB(150, 150, 150)

    -- Вкладка ESP (вторая)
    local espTabButton = Instance.new("TextButton", tabsPanel)
    espTabButton.Size = UDim2.new(0.9, 0, 0, 25)
    espTabButton.Position = UDim2.new(0.05, 0, 0.12, 0)
    espTabButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    espTabButton.Text = "ESP"
    espTabButton.TextColor3 = Color3.new(1, 1, 1)
    espTabButton.TextScaled = true
    espTabButton.BorderSizePixel = 1
    espTabButton.BorderColor3 = Color3.fromRGB(150, 150, 150)

    -- Вкладка AimBot (третья)
    local aimbotTabButton = Instance.new("TextButton", tabsPanel)
    aimbotTabButton.Size = UDim2.new(0.9, 0, 0, 25)
    aimbotTabButton.Position = UDim2.new(0.05, 0, 0.22, 0)
    aimbotTabButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    aimbotTabButton.Text = "AimBot"
    aimbotTabButton.TextColor3 = Color3.new(1, 1, 1)
    aimbotTabButton.TextScaled = true
    aimbotTabButton.BorderSizePixel = 1
    aimbotTabButton.BorderColor3 = Color3.fromRGB(150, 150, 150)

    -- Вкладка Camera (четвертая)
    local cameraTabButton = Instance.new("TextButton", tabsPanel)
    cameraTabButton.Size = UDim2.new(0.9, 0, 0, 25)
    cameraTabButton.Position = UDim2.new(0.05, 0, 0.32, 0)
    cameraTabButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    cameraTabButton.Text = "Camera"
    cameraTabButton.TextColor3 = Color3.new(1, 1, 1)
    cameraTabButton.TextScaled = true
    cameraTabButton.BorderSizePixel = 1
    cameraTabButton.BorderColor3 = Color3.fromRGB(150, 150, 150)

    -- Контейнеры для содержимого вкладок
    local infoContainer = Instance.new("Frame", contentContainer)
    infoContainer.Size = UDim2.new(1, 0, 1, 0)
    infoContainer.Position = UDim2.new(0, 0, 0, 0)
    infoContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    infoContainer.BorderSizePixel = 0
    infoContainer.Visible = true

    local espContainer = Instance.new("Frame", contentContainer)
    espContainer.Size = UDim2.new(1, 0, 1, 0)
    espContainer.Position = UDim2.new(0, 0, 0, 0)
    espContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    espContainer.BorderSizePixel = 0
    espContainer.Visible = false

    local aimbotContainer = Instance.new("Frame", contentContainer)
    aimbotContainer.Size = UDim2.new(1, 0, 1, 0)
    aimbotContainer.Position = UDim2.new(0, 0, 0, 0)
    aimbotContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    aimbotContainer.BorderSizePixel = 0
    aimbotContainer.Visible = false

    local cameraContainer = Instance.new("Frame", contentContainer)
    cameraContainer.Size = UDim2.new(1, 0, 1, 0)
    cameraContainer.Position = UDim2.new(0, 0, 0, 0)
    cameraContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    cameraContainer.BorderSizePixel = 0
    cameraContainer.Visible = false

    -- Функции для перемещения GUI
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

    -- Обработчики для перемещения
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

    -- ========== ВКЛАДКА INFO ==========
    
    local infoText = Instance.new("TextLabel", infoContainer)
    infoText.Size = UDim2.new(0.9, 0, 0.8, 0)
    infoText.Position = UDim2.new(0.05, 0, 0.05, 0)
    infoText.BackgroundTransparency = 1
    infoText.Text = "ASTRALCHEAT v1.0\n\nРазработчик: @SFXCL\n\nФункции:\n• Aimbot с настройкой\n• ESP с боксами\n• Настройка FOV\n• Кастомный FOV камеры\n• Ограничение дистанции аимбота\n• Infinite Jump\n• SpeedHack\n\nИспользуйте на свой страх и риск!"
    infoText.TextColor3 = Color3.new(1, 1, 1)
    infoText.TextScaled = true
    infoText.TextWrapped = true
    infoText.Font = Enum.Font.SourceSans

    -- ========== ВКЛАДКА ESP ==========
    
    -- Кнопка ESP (серая)
    local espButton = Instance.new("TextButton", espContainer)
    espButton.Size = UDim2.new(0.9, 0, 0, 35)
    espButton.Position = UDim2.new(0.05, 0, 0.05, 0)
    espButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    espButton.Text = "ESP: OFF"
    espButton.TextColor3 = Color3.new(1, 1, 1)
    espButton.TextScaled = true
    espButton.BorderSizePixel = 0

    -- ========== ВКЛАДКА AIMBOT ==========
    
    -- Кнопка Aimbot (серая)
    local aimbotButton = Instance.new("TextButton", aimbotContainer)
    aimbotButton.Size = UDim2.new(0.9, 0, 0, 35)
    aimbotButton.Position = UDim2.new(0.05, 0, 0.05, 0)
    aimbotButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    aimbotButton.Text = "Aimbot: OFF"
    aimbotButton.TextColor3 = Color3.new(1, 1, 1)
    aimbotButton.TextScaled = true
    aimbotButton.BorderSizePixel = 0

    -- Выпадающий список для выбора цели
    local targetDropdown = Instance.new("TextButton", aimbotContainer)
    targetDropdown.Size = UDim2.new(0.9, 0, 0, 35)
    targetDropdown.Position = UDim2.new(0.05, 0, 0.20, 0)
    targetDropdown.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    targetDropdown.Text = "Target: Head"
    targetDropdown.TextColor3 = Color3.new(1, 1, 1)
    targetDropdown.TextScaled = true
    targetDropdown.BorderSizePixel = 0

    -- Контейнер для выпадающего списка
    local dropdownContainer = Instance.new("Frame", aimbotContainer)
    dropdownContainer.Size = UDim2.new(0.9, 0, 0, 70)
    dropdownContainer.Position = UDim2.new(0.05, 0, 0.20, 35)
    dropdownContainer.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    dropdownContainer.BorderSizePixel = 1
    dropdownContainer.BorderColor3 = Color3.fromRGB(100, 100, 100)
    dropdownContainer.Visible = false

    -- Кнопка выбора Head
    local headButton = Instance.new("TextButton", dropdownContainer)
    headButton.Size = UDim2.new(1, 0, 0, 35)
    headButton.Position = UDim2.new(0, 0, 0, 0)
    headButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    headButton.Text = "Head"
    headButton.TextColor3 = Color3.new(1, 1, 1)
    headButton.TextScaled = true
    headButton.BorderSizePixel = 0

    -- Кнопка выбора Body
    local bodyButton = Instance.new("TextButton", dropdownContainer)
    bodyButton.Size = UDim2.new(1, 0, 0, 35)
    bodyButton.Position = UDim2.new(0, 0, 0, 35)
    bodyButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    bodyButton.Text = "Body"
    bodyButton.TextColor3 = Color3.new(1, 1, 1)
    bodyButton.TextScaled = true
    bodyButton.BorderSizePixel = 0

    -- FOV Slider для аимбота (исходная позиция)
    local fovSliderFrame = Instance.new("Frame", aimbotContainer)
    fovSliderFrame.Size = UDim2.new(0.9, 0, 0, 60)
    fovSliderFrame.Position = UDim2.new(0.05, 0, 0.35, 0)
    fovSliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    fovSliderFrame.BorderSizePixel = 0

    local fovLabel = Instance.new("TextLabel", fovSliderFrame)
    fovLabel.Size = UDim2.new(1, 0, 0.3, 0)
    fovLabel.Position = UDim2.new(0, 0, 0, 0)
    fovLabel.BackgroundTransparency = 1
    fovLabel.Text = "FOV Radius: " .. fovRadius
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

    -- Кнопки + и - для FOV
    local minusButton = Instance.new("TextButton", fovSliderFrame)
    minusButton.Size = UDim2.new(0.2, 0, 0.3, 0)
    minusButton.Position = UDim2.new(0, 0, 0.8, 10) -- Сдвинуты на 10 пикселей вниз
    minusButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    minusButton.Text = "-"
    minusButton.TextColor3 = Color3.new(1, 1, 1)
    minusButton.TextScaled = true
    minusButton.BorderSizePixel = 0

    local plusButton = Instance.new("TextButton", fovSliderFrame)
    plusButton.Size = UDim2.new(0.2, 0, 0.3, 0)
    plusButton.Position = UDim2.new(0.8, 0, 0.8, 10) -- Сдвинуты на 10 пикселей вниз
    plusButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    plusButton.Text = "+"
    plusButton.TextColor3 = Color3.new(1, 1, 1)
    plusButton.TextScaled = true
    plusButton.BorderSizePixel = 0

    -- Distance Slider для аимбота (исходная позиция)
    local distanceSliderFrame = Instance.new("Frame", aimbotContainer)
    distanceSliderFrame.Size = UDim2.new(0.9, 0, 0, 60)
    distanceSliderFrame.Position = UDim2.new(0.05, 0, 0.50, 0)
    distanceSliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    distanceSliderFrame.BorderSizePixel = 0

    local distanceLabel = Instance.new("TextLabel", distanceSliderFrame)
    distanceLabel.Size = UDim2.new(1, 0, 0.3, 0)
    distanceLabel.Position = UDim2.new(0, 0, 0, 0)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.Text = "Aimbot Distance: " .. aimbotMaxDistance .. "m"
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

    -- Кнопки + и - для Distance
    local distanceMinusButton = Instance.new("TextButton", distanceSliderFrame)
    distanceMinusButton.Size = UDim2.new(0.2, 0, 0.3, 0)
    distanceMinusButton.Position = UDim2.new(0, 0, 0.8, 10) -- Сдвинуты на 10 пикселей вниз
    distanceMinusButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    distanceMinusButton.Text = "-"
    distanceMinusButton.TextColor3 = Color3.new(1, 1, 1)
    distanceMinusButton.TextScaled = true
    distanceMinusButton.BorderSizePixel = 0

    local distancePlusButton = Instance.new("TextButton", distanceSliderFrame)
    distancePlusButton.Size = UDim2.new(0.2, 0, 0.3, 0)
    distancePlusButton.Position = UDim2.new(0.8, 0, 0.8, 10) -- Сдвинуты на 10 пикселей вниз
    distancePlusButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    distancePlusButton.Text = "+"
    distancePlusButton.TextColor3 = Color3.new(1, 1, 1)
    distancePlusButton.TextScaled = true
    distancePlusButton.BorderSizePixel = 0

    -- ========== ВКЛАДКА CAMERA ==========
    
    -- 1. Кнопка SpeedHack (самая первая)
    local speedHackButton = Instance.new("TextButton", cameraContainer)
    speedHackButton.Size = UDim2.new(0.9, 0, 0, 35)
    speedHackButton.Position = UDim2.new(0.05, 0, 0.05, 0)
    speedHackButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    speedHackButton.Text = "SpeedHack: OFF"
    speedHackButton.TextColor3 = Color3.new(1, 1, 1)
    speedHackButton.TextScaled = true
    speedHackButton.BorderSizePixel = 0

    -- 2. Кнопка Infinite Jump (вторая) - УВЕЛИЧЕН ОТСТУП
    local infiniteJumpButton = Instance.new("TextButton", cameraContainer)
    infiniteJumpButton.Size = UDim2.new(0.9, 0, 0, 35)
    infiniteJumpButton.Position = UDim2.new(0.05, 0, 0.15, 40) -- Увеличено с 20 до 40
    infiniteJumpButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    infiniteJumpButton.Text = "Infinite Jump: OFF"
    infiniteJumpButton.TextColor3 = Color3.new(1, 1, 1)
    infiniteJumpButton.TextScaled = true
    infiniteJumpButton.BorderSizePixel = 0

    -- 3. Кнопка Camera FOV (третья) - УВЕЛИЧЕН ОТСТУП
    local cameraFOVButton = Instance.new("TextButton", cameraContainer)
    cameraFOVButton.Size = UDim2.new(0.9, 0, 0, 35)
    cameraFOVButton.Position = UDim2.new(0.05, 0, 0.25, 80) -- Увеличено с 45 до 80
    cameraFOVButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    cameraFOVButton.Text = "CamFOV: OFF"
    cameraFOVButton.TextColor3 = Color3.new(1, 1, 1)
    cameraFOVButton.TextScaled = true
    cameraFOVButton.BorderSizePixel = 0

    -- 4. Camera FOV Slider (четвертый) - УВЕЛИЧЕН ОТСТУП
    local cameraFOVSliderFrame = Instance.new("Frame", cameraContainer)
    cameraFOVSliderFrame.Size = UDim2.new(0.9, 0, 0, 60)
    cameraFOVSliderFrame.Position = UDim2.new(0.05, 0, 0.35, 120) -- Увеличено с 70 до 120
    cameraFOVSliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    cameraFOVSliderFrame.BorderSizePixel = 0

    local cameraFOVLabel = Instance.new("TextLabel", cameraFOVSliderFrame)
    cameraFOVLabel.Size = UDim2.new(1, 0, 0.3, 0)
    cameraFOVLabel.Position = UDim2.new(0, 0, 0, 0)
    cameraFOVLabel.BackgroundTransparency = 1
    cameraFOVLabel.Text = "Camera FOV: " .. cameraFOV
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

    -- Кнопки + и - для Camera FOV
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

    -- 5. SpeedHack Multiplier Slider (пятый) - УВЕЛИЧЕН ОТСТУП
    local speedHackSliderFrame = Instance.new("Frame", cameraContainer)
    speedHackSliderFrame.Size = UDim2.new(0.9, 0, 0, 60)
    speedHackSliderFrame.Position = UDim2.new(0.05, 0, 0.55, 160) -- Увеличено с 100 до 160
    speedHackSliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    speedHackSliderFrame.BorderSizePixel = 0

    local speedHackLabel = Instance.new("TextLabel", speedHackSliderFrame)
    speedHackLabel.Size = UDim2.new(1, 0, 0.3, 0)
    speedHackLabel.Position = UDim2.new(0, 0, 0, 0)
    speedHackLabel.BackgroundTransparency = 1
    speedHackLabel.Text = "Speed Multiplier: " .. speedMultiplier .. "x"
    speedHackLabel.TextColor3 = Color3.new(1, 1, 1)
    speedHackLabel.TextScaled = true
    speedHackLabel.Font = Enum.Font.SourceSans

    local speedSliderBackground = Instance.new("TextButton", speedHackSliderFrame)
    speedSliderBackground.Size = UDim2.new(1, 0, 0.4, 0)
    speedSliderBackground.Position = UDim2.new(0, 0, 0.4, 0)
    speedSliderBackground.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    speedSliderBackground.BorderSizePixel = 0
    speedSliderBackground.Text = ""
    speedSliderBackground.AutoButtonColor = false

    local speedSliderFill = Instance.new("Frame", speedSliderBackground)
    speedSliderFill.Size = UDim2.new((speedMultiplier - 1) / 9, 0, 1, 0)
    speedSliderFill.Position = UDim2.new(0, 0, 0, 0)
    speedSliderFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    speedSliderFill.BorderSizePixel = 0

    local speedSliderButton = Instance.new("Frame", speedSliderBackground)
    speedSliderButton.Size = UDim2.new(0, 15, 1.5, 0)
    speedSliderButton.Position = UDim2.new((speedMultiplier - 1) / 9, -7, -0.25, 0)
    speedSliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    speedSliderButton.BorderSizePixel = 1
    speedSliderButton.BorderColor3 = Color3.fromRGB(200, 200, 200)

    -- Кнопки + и - для SpeedHack
    local speedMinusButton = Instance.new("TextButton", speedHackSliderFrame)
    speedMinusButton.Size = UDim2.new(0.2, 0, 0.3, 0)
    speedMinusButton.Position = UDim2.new(0, 0, 0.8, 10)
    speedMinusButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    speedMinusButton.Text = "-"
    speedMinusButton.TextColor3 = Color3.new(1, 1, 1)
    speedMinusButton.TextScaled = true
    speedMinusButton.BorderSizePixel = 0

    local speedPlusButton = Instance.new("TextButton", speedHackSliderFrame)
    speedPlusButton.Size = UDim2.new(0.2, 0, 0.3, 0)
    speedPlusButton.Position = UDim2.new(0.8, 0, 0.8, 10)
    speedPlusButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    speedPlusButton.Text = "+"
    speedPlusButton.TextColor3 = Color3.new(1, 1, 1)
    speedPlusButton.TextScaled = true
    speedPlusButton.BorderSizePixel = 0

    -- Кнопка Hide/Show GUI (перемещаемая)
    local hideButton = Instance.new("TextButton", gui)
    hideButton.Size = UDim2.new(0, 150, 0, 40)
    hideButton.Position = UDim2.new(0.5, -75, 1, -50)
    hideButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    hideButton.Text = "Hide GUI"
    hideButton.TextColor3 = Color3.new(1, 1, 1)
    hideButton.TextScaled = true
    hideButton.BorderSizePixel = 0
    hideButton.ZIndex = 10

    -- Функция обновления FOV
    local function updateFOV(value)
        fovRadius = math.floor(math.clamp(value, 50, 250))
        circle.Radius = fovRadius
        fovLabel.Text = "FOV Radius: " .. fovRadius
        
        local fillSize = (fovRadius - 50) / 200
        sliderFill.Size = UDim2.new(fillSize, 0, 1, 0)
        sliderButton.Position = UDim2.new(fillSize, -7, -0.25, 0)
    end

    -- Функция обновления Camera FOV
    local function updateCameraFOV(value)
        cameraFOV = math.floor(math.clamp(value, 30, 120))
        cameraFOVLabel.Text = "Camera FOV: " .. cameraFOV
        
        local fillSize = (cameraFOV - 30) / 90
        cameraSliderFill.Size = UDim2.new(fillSize, 0, 1, 0)
        cameraSliderButton.Position = UDim2.new(fillSize, -7, -0.25, 0)
        
        if customCameraFOVEnabled then
            camera.FieldOfView = cameraFOV
        end
    end

    -- Функция обновления дистанции аимбота
    local function updateAimbotDistance(value)
        aimbotMaxDistance = math.floor(math.clamp(value, 10, 200))
        distanceLabel.Text = "Aimbot Distance: " .. aimbotMaxDistance .. "m"
        
        local fillSize = (aimbotMaxDistance - 10) / 190
        distanceSliderFill.Size = UDim2.new(fillSize, 0, 1, 0)
        distanceSliderButton.Position = UDim2.new(fillSize, -7, -0.25, 0)
    end

    -- Функция обновления множителя скорости
    local function updateSpeedMultiplier(value)
        speedMultiplier = math.floor(math.clamp(value, 1, 10))
        speedHackLabel.Text = "Speed Multiplier: " .. speedMultiplier .. "x"
        
        local fillSize = (speedMultiplier - 1) / 9
        speedSliderFill.Size = UDim2.new(fillSize, 0, 1, 0)
        speedSliderButton.Position = UDim2.new(fillSize, -7, -0.25, 0)
        
        updateSpeed()
    end

    -- Функция для выбора цели через выпадающий списко
    local function selectTarget(target)
        if target == "Head" then
            aimbotTarget = "Head"
            targetDropdown.Text = "Target: Head"
            headButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            bodyButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        else
            aimbotTarget = "HumanoidRootPart"
            targetDropdown.Text = "Target: Body"
            headButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            bodyButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        end
        dropdownContainer.Visible = false
        fovSliderFrame.Position = UDim2.new(0.05, 0, 0.35, 0)
        distanceSliderFrame.Position = UDim2.new(0.05, 0, 0.50, 0)
    end

    -- Функция для открытия/закрытия выпадающего списка
    local function toggleDropdown()
        local isOpening = not dropdownContainer.Visible
        dropdownContainer.Visible = isOpening
        
        if isOpening then
            fovSliderFrame.Position = UDim2.new(0.05, 0, 0.60, 0)
            distanceSliderFrame.Position = UDim2.new(0.05, 0, 0.75, 0)
        else
            fovSliderFrame.Position = UDim2.new(0.05, 0, 0.35, 0)
            distanceSliderFrame.Position = UDim2.new(0.05, 0, 0.50, 0)
        end
    end

    -- Обработка для слайдеров
    local isFOVSliding = false
    local isCameraSliding = false
    local isDistanceSliding = false
    local isSpeedSliding = false

    local function updateSliderFromTouch(touchPosition, sliderType)
        local sliderAbsPos, sliderAbsSize
        
        if sliderType == "fov" then
            sliderAbsPos = sliderBackground.AbsolutePosition
            sliderAbsSize = sliderBackground.AbsoluteSize
        elseif sliderType == "camera" then
            sliderAbsPos = cameraSliderBackground.AbsolutePosition
            sliderAbsSize = cameraSliderBackground.AbsoluteSize
        elseif sliderType == "distance" then
            sliderAbsPos = distanceSliderBackground.AbsolutePosition
            sliderAbsSize = distanceSliderBackground.AbsoluteSize
        elseif sliderType == "speed" then
            sliderAbsPos = speedSliderBackground.AbsolutePosition
            sliderAbsSize = speedSliderBackground.AbsoluteSize
        end
        
        local touchX = touchPosition.X
        local relativeX = (touchX - sliderAbsPos.X) / sliderAbsSize.X
        relativeX = math.clamp(relativeX, 0, 1)
        
        if sliderType == "fov" then
            local newFOV = 50 + (relativeX * 200)
            updateFOV(newFOV)
        elseif sliderType == "camera" then
            local newCameraFOV = 30 + (relativeX * 90)
            updateCameraFOV(newCameraFOV)
        elseif sliderType == "distance" then
            local newDistance = 10 + (relativeX * 190)
            updateAimbotDistance(newDistance)
        elseif sliderType == "speed" then
            local newSpeed = 1 + (relativeX * 9)
            updateSpeedMultiplier(newSpeed)
        end
    end

    -- Обработка для FOV слайдера
    sliderBackground.MouseButton1Down:Connect(function(x, y)
        isFOVSliding = true
        updateSliderFromTouch(Vector2.new(x, y), "fov")
    end)

    -- Обработка для Camera FOV слайдера
    cameraSliderBackground.MouseButton1Down:Connect(function(x, y)
        isCameraSliding = true
        updateSliderFromTouch(Vector2.new(x, y), "camera")
    end)

    -- Обработка для Distance слайдера
    distanceSliderBackground.MouseButton1Down:Connect(function(x, y)
        isDistanceSliding = true
        updateSliderFromTouch(Vector2.new(x, y), "distance")
    end)

    -- Обработка для Speed слайдера
    speedSliderBackground.MouseButton1Down:Connect(function(x, y)
        isSpeedSliding = true
        updateSliderFromTouch(Vector2.new(x, y), "speed")
    end)

    userInputService.InputChanged:Connect(function(input)
        if isFOVSliding and input.UserInputType == Enum.UserInputType.Touch then
            updateSliderFromTouch(input.Position, "fov")
        elseif isCameraSliding and input.UserInputType == Enum.UserInputType.Touch then
            updateSliderFromTouch(input.Position, "camera")
        elseif isDistanceSliding and input.UserInputType == Enum.UserInputType.Touch then
            updateSliderFromTouch(input.Position, "distance")
        elseif isSpeedSliding and input.UserInputType == Enum.UserInputType.Touch then
            updateSliderFromTouch(input.Position, "speed")
        end
    end)

    userInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            isFOVSliding = false
            isCameraSliding = false
            isDistanceSliding = false
            isSpeedSliding = false
        end
    end)

    -- Кнопки + и - для FOV
    minusButton.MouseButton1Click:Connect(function()
        updateFOV(fovRadius - 10)
    end)

    plusButton.MouseButton1Click:Connect(function()
        updateFOV(fovRadius + 10)
    end)

    -- Кнопки + и - для Camera FOV
    cameraMinusButton.MouseButton1Click:Connect(function()
        updateCameraFOV(cameraFOV - 10)
    end)

    cameraPlusButton.MouseButton1Click:Connect(function()
        updateCameraFOV(cameraFOV + 10)
    end)

    -- Кнопки + и - для Distance
    distanceMinusButton.MouseButton1Click:Connect(function()
        updateAimbotDistance(aimbotMaxDistance - 10)
    end)

    distancePlusButton.MouseButton1Click:Connect(function()
        updateAimbotDistance(aimbotMaxDistance + 10)
    end)

    -- Кнопки + и - для Speed
    speedMinusButton.MouseButton1Click:Connect(function()
        updateSpeedMultiplier(speedMultiplier - 1)
    end)

    speedPlusButton.MouseButton1Click:Connect(function()
        updateSpeedMultiplier(speedMultiplier + 1)
    end)

    -- Обработчики для выпадающего списка выбора цели
    targetDropdown.MouseButton1Click:Connect(function()
        toggleDropdown()
    end)

    headButton.MouseButton1Click:Connect(function()
        selectTarget("Head")
    end)

    bodyButton.MouseButton1Click:Connect(function()
        selectTarget("Body")
    end)

    -- Обработчики для кнопки закрытия
    closeButton.MouseButton1Click:Connect(function()
        confirmFrame.Visible = true
    end)

    yesButton.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)

    noButton.MouseButton1Click:Connect(function()
        confirmFrame.Visible = false
    end)

    -- Закрытие выпадающего списка при клике вне его
    userInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            if dropdownContainer.Visible then
                local mousePos = input.Position
                local dropdownAbsPos = dropdownContainer.AbsolutePosition
                local dropdownAbsSize = dropdownContainer.AbsoluteSize
                local targetDropdownAbsPos = targetDropdown.AbsolutePosition
                local targetDropdownAbsSize = targetDropdown.AbsoluteSize

                if not (mousePos.X >= dropdownAbsPos.X and mousePos.X <= dropdownAbsPos.X + dropdownAbsSize.X and
                       mousePos.Y >= dropdownAbsPos.Y and mousePos.Y <= dropdownAbsPos.Y + dropdownAbsSize.Y) and
                   not (mousePos.X >= targetDropdownAbsPos.X and mousePos.X <= targetDropdownAbsPos.X + targetDropdownAbsSize.X and
                       mousePos.Y >= targetDropdownAbsPos.Y and mousePos.Y <= targetDropdownAbsPos.Y + targetDropdownAbsSize.Y) then
                    dropdownContainer.Visible = false
                    fovSliderFrame.Position = UDim2.new(0.05, 0, 0.35, 0)
                    distanceSliderFrame.Position = UDim2.new(0.05, 0, 0.50, 0)
                end
            end
        end
    end)

    -- Функция переключения вкладок
    local function switchTab(tabName)
        activeTab = tabName
        
        infoContainer.Visible = false
        espContainer.Visible = false
        aimbotContainer.Visible = false
        cameraContainer.Visible = false
        
        infoTabButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        espTabButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        aimbotTabButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        cameraTabButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        
        if tabName == "Info" then
            infoContainer.Visible = true
            infoTabButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            frame.Size = UDim2.new(0, 350, 0, 300)
            frame.Position = UDim2.new(0.5, -175, 0.5, -150)
        elseif tabName == "ESP" then
            espContainer.Visible = true
            espTabButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            frame.Size = UDim2.new(0, 350, 0, 300)
            frame.Position = UDim2.new(0.5, -175, 0.5, -150)
        elseif tabName == "AimBot" then
            aimbotContainer.Visible = true
            aimbotTabButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            frame.Size = UDim2.new(0, 350, 0, 300)
            frame.Position = UDim2.new(0.5, -175, 0.5, -150)
        elseif tabName == "Camera" then
            cameraContainer.Visible = true
            cameraTabButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            -- Увеличиваем размер меню для вкладки Camera
            frame.Size = UDim2.new(0, 350, 0, 500)
            frame.Position = UDim2.new(0.5, -175, 0.5, -250)
        end
        
        dropdownContainer.Visible = false
        fovSliderFrame.Position = UDim2.new(0.05, 0, 0.35, 0)
        distanceSliderFrame.Position = UDim2.new(0.05, 0, 0.50, 0)
    end

    -- ОБРАБОТЧИКИ КНОПОК ВКЛАДОК
    infoTabButton.MouseButton1Click:Connect(function()
        switchTab("Info")
    end)

    espTabButton.MouseButton1Click:Connect(function()
        switchTab("ESP")
    end)

    aimbotTabButton.MouseButton1Click:Connect(function()
        switchTab("AimBot")
    end)

    cameraTabButton.MouseButton1Click:Connect(function()
        switchTab("Camera")
    end)

    -- ОБРАБОТЧИКИ ОСНОВНЫХ КНОПОК
    hideButton.MouseButton1Click:Connect(function()
        guiVisible = not guiVisible
        frame.Visible = guiVisible
        hideButton.Text = guiVisible and "Hide GUI" or "Show GUI"
    end)

    -- Добавляем функционал перемещения для кнопки Hide/Show GUI
    local isHideButtonDragging = false
    local hideButtonDragStart = nil
    local hideButtonStartPos = nil

    hideButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            isHideButtonDragging = true
            hideButtonDragStart = input.Position
            hideButtonStartPos = hideButton.Position
        end
    end)

    hideButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            isHideButtonDragging = false
        end
    end)

    userInputService.InputChanged:Connect(function(input)
        if isHideButtonDragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local delta = input.Position - hideButtonDragStart
            hideButton.Position = UDim2.new(
                hideButtonStartPos.X.Scale, 
                hideButtonStartPos.X.Offset + delta.X,
                hideButtonStartPos.Y.Scale, 
                hideButtonStartPos.Y.Offset + delta.Y
            )
        end
    end)

    -- Обработчик для кнопки SpeedHack
    speedHackButton.MouseButton1Click:Connect(function()
        speedHackEnabled = not speedHackEnabled
        if speedHackEnabled then
            speedHackButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            speedHackButton.Text = "SpeedHack: ON ✅"
            if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
                originalWalkSpeed = player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed
            end
        else
            speedHackButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            speedHackButton.Text = "SpeedHack: OFF"
        end
        updateSpeed()
    end)

    -- Обработчик для кнопки Infinite Jump
    infiniteJumpButton.MouseButton1Click:Connect(function()
        infiniteJumpEnabled = not infiniteJumpEnabled
        if infiniteJumpEnabled then
            infiniteJumpButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            infiniteJumpButton.Text = "Infinite Jump: ON ✅"
        else
            infiniteJumpButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            infiniteJumpButton.Text = "Infinite Jump: OFF"
        end
    end)

    -- Обработчик для кнопки Camera FOV
    cameraFOVButton.MouseButton1Click:Connect(function()
        customCameraFOVEnabled = not customCameraFOVEnabled
        if customCameraFOVEnabled then
            cameraFOVButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            cameraFOVButton.Text = "CamFOV: ON ✅"
            camera.FieldOfView = cameraFOV
        else
            cameraFOVButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            cameraFOVButton.Text = "CamFOV: OFF"
            camera.FieldOfView = 70
        end
    end)

    aimbotButton.MouseButton1Click:Connect(function()
        aimbotEnabled = not aimbotEnabled
        if aimbotEnabled then
            aimbotButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            aimbotButton.Text = "Aimbot: ON ✅"
        else
            aimbotButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            aimbotButton.Text = "Aimbot: OFF"
        end
    end)

    espButton.MouseButton1Click:Connect(function()
        espEnabled = not espEnabled
        if espEnabled then
            espButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            espButton.Text = "ESP: ON ✅"
        else
            espButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            espButton.Text = "ESP: OFF"
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

    -- Инициализация вкладок
    switchTab("Info")
    
    -- Инициализация выпадающего списка
    selectTarget("Head")
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
createKeyGUI() -- Запускаем систему ключа вместо основного меню

player.CharacterAdded:Connect(function(character)
    task.wait(1)
    if not player:WaitForChild("PlayerGui"):FindFirstChild(guiName) then
        -- Не создаем автоматически, нужно ввести ключ
    end
    if speedHackEnabled then
        updateSpeed()
    end
end)

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