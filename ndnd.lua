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
local guiName = "ASTRALCHEAT"
local guiVisible = true
local espObjects = {}
local aimbotTarget = "Head"

-- Переменные для камеры
local customCameraFOVEnabled = false
local cameraFOV = 70

-- Переменные для Auto Tree
local autoTreeEnabled = false
local treeChopping = false

-- Переменные для перемещения GUI
local frame = nil
local isDragging = false
local dragStart = nil
local frameStart = nil
local activeTab = "Info" -- Активная вкладка по умолчанию

-- FOV Circle
local circle = Drawing.new("Circle")
circle.Color = Color3.fromRGB(255, 255, 255)
circle.Thickness = 1
circle.Filled = false
circle.Radius = fovRadius
circle.Visible = true
circle.Position = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)

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

-- Closest Player Function (with team check)
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

-- Auto Tree Function
local function startTreeChopping()
    if treeChopping then return end
    treeChopping = true
    
    spawn(function()
        while autoTreeEnabled and player.Character do
            local character = player.Character
            local humanoid = character:FindFirstChild("Humanoid")
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            
            if humanoid and rootPart then
                -- Поиск топора в инвентаре
                local axe = nil
                for _, tool in pairs(character:GetChildren()) do
                    if tool:IsA("Tool") and (tool.Name:lower():find("axe") or tool.Name:lower():find("топор")) then
                        axe = tool
                        break
                    end
                end
                
                -- Если топор найден, экипируем его
                if axe then
                    humanoid:EquipTool(axe)
                    
                    -- Поиск деревьев поблизости
                    local nearestTree = nil
                    local nearestDistance = 50 -- Максимальная дистанция
                    
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if obj:IsA("Part") and (obj.Name:lower():find("tree") or obj.Name:lower():find("wood") or obj.Name:lower():find("дерево")) then
                            local distance = (rootPart.Position - obj.Position).Magnitude
                            if distance < nearestDistance then
                                nearestTree = obj
                                nearestDistance = distance
                            end
                        end
                    end
                    
                    -- Если дерево найдено, подходим и рубим
                    if nearestTree then
                        -- Подход к дереву
                        humanoid:MoveTo(nearestTree.Position)
                        
                        -- Ждем пока подойдем
                        wait(1)
                        
                        -- Рубка дерева (активация инструмента)
                        if axe:IsA("Tool") then
                            for i = 1, 10 do -- 10 ударов по дереву
                                if not autoTreeEnabled then break end
                                axe:Activate()
                                wait(0.5)
                            end
                        end
                    end
                end
            end
            
            wait(1) -- Пауза между поиском деревьев
        end
        treeChopping = false
    end)
end

-- GUI Creation Function
local function createGUI()
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
    title.Text = "ASTRALCHEAT v1.0"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.TextScaled = true
    title.Font = Enum.Font.SourceSansBold
    title.BorderSizePixel = 0

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
    espTabButton.Position = UDim2.new(0.05, 0, 0.12, 0) -- Отступ 2-3 см
    espTabButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    espTabButton.Text = "ESP"
    espTabButton.TextColor3 = Color3.new(1, 1, 1)
    espTabButton.TextScaled = true
    espTabButton.BorderSizePixel = 1
    espTabButton.BorderColor3 = Color3.fromRGB(150, 150, 150)

    -- Вкладка AimBot (третья)
    local aimbotTabButton = Instance.new("TextButton", tabsPanel)
    aimbotTabButton.Size = UDim2.new(0.9, 0, 0, 25)
    aimbotTabButton.Position = UDim2.new(0.05, 0, 0.22, 0) -- Отступ 2-3 см
    aimbotTabButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    aimbotTabButton.Text = "AimBot"
    aimbotTabButton.TextColor3 = Color3.new(1, 1, 1)
    aimbotTabButton.TextScaled = true
    aimbotTabButton.BorderSizePixel = 1
    aimbotTabButton.BorderColor3 = Color3.fromRGB(150, 150, 150)

    -- Вкладка Memory (четвертая)
    local memoryTabButton = Instance.new("TextButton", tabsPanel)
    memoryTabButton.Size = UDim2.new(0.9, 0, 0, 25)
    memoryTabButton.Position = UDim2.new(0.05, 0, 0.32, 0) -- Отступ 2-3 см
    memoryTabButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    memoryTabButton.Text = "Memory"
    memoryTabButton.TextColor3 = Color3.new(1, 1, 1)
    memoryTabButton.TextScaled = true
    memoryTabButton.BorderSizePixel = 1
    memoryTabButton.BorderColor3 = Color3.fromRGB(150, 150, 150)

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

    local memoryContainer = Instance.new("Frame", contentContainer)
    memoryContainer.Size = UDim2.new(1, 0, 1, 0)
    memoryContainer.Position = UDim2.new(0, 0, 0, 0)
    memoryContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    memoryContainer.BorderSizePixel = 0
    memoryContainer.Visible = false

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
    infoText.Text = "ASTRALCHEAT v1.0\n\nРазработчик: @SFXCL\n\nФункции:\n• Aimbot с настройкой\n• ESP с боксами\n• Настройка FOV\n• Кастомный FOV камеры\n• Auto Tree для 99 ночей в лесу\n\nИспользуйте на свой страх и риск!"
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

    -- Кнопки выбора цели (серые)
    local targetHeadButton = Instance.new("TextButton", aimbotContainer)
    targetHeadButton.Size = UDim2.new(0.44, 0, 0, 35)
    targetHeadButton.Position = UDim2.new(0.05, 0, 0.15, 0)
    targetHeadButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    targetHeadButton.Text = "Head ✅"
    targetHeadButton.TextColor3 = Color3.new(1, 1, 1)
    targetHeadButton.TextScaled = true
    targetHeadButton.BorderSizePixel = 0

    local targetBodyButton = Instance.new("TextButton", aimbotContainer)
    targetBodyButton.Size = UDim2.new(0.44, 0, 0, 35)
    targetBodyButton.Position = UDim2.new(0.51, 0, 0.15, 0)
    targetBodyButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    targetBodyButton.Text = "Body"
    targetBodyButton.TextColor3 = Color3.new(1, 1, 1)
    targetBodyButton.TextScaled = true
    targetBodyButton.BorderSizePixel = 0

    -- FOV Slider для аимбота
    local fovSliderFrame = Instance.new("Frame", aimbotContainer)
    fovSliderFrame.Size = UDim2.new(0.9, 0, 0, 60)
    fovSliderFrame.Position = UDim2.new(0.05, 0, 0.3, 0) -- Отступ 2-3 см от других функций
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
    minusButton.Position = UDim2.new(0, 0, 0.8, 0)
    minusButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    minusButton.Text = "-"
    minusButton.TextColor3 = Color3.new(1, 1, 1)
    minusButton.TextScaled = true
    minusButton.BorderSizePixel = 0

    local plusButton = Instance.new("TextButton", fovSliderFrame)
    plusButton.Size = UDim2.new(0.2, 0, 0.3, 0)
    plusButton.Position = UDim2.new(0.8, 0, 0.8, 0)
    plusButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    plusButton.Text = "+"
    plusButton.TextColor3 = Color3.new(1, 1, 1)
    plusButton.TextScaled = true
    plusButton.BorderSizePixel = 0

    -- ========== ВКЛАДКА MEMORY ==========
    
    -- Кнопка Auto Tree
    local autoTreeButton = Instance.new("TextButton", memoryContainer)
    autoTreeButton.Size = UDim2.new(0.9, 0, 0, 35)
    autoTreeButton.Position = UDim2.new(0.05, 0, 0.05, 0)
    autoTreeButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    autoTreeButton.Text = "Auto Tree: OFF"
    autoTreeButton.TextColor3 = Color3.new(1, 1, 1)
    autoTreeButton.TextScaled = true
    autoTreeButton.BorderSizePixel = 0

    -- Camera FOV Slider (после Auto Tree с отступом 2-3 см)
    local cameraFOVSliderFrame = Instance.new("Frame", memoryContainer)
    cameraFOVSliderFrame.Size = UDim2.new(0.9, 0, 0, 60)
    cameraFOVSliderFrame.Position = UDim2.new(0.05, 0, 0.2, 0) -- Отступ 2-3 см от Auto Tree
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
    cameraSliderFill.Size = UDim2.new((cameraFOV - 30) / 120, 0, 1, 0)
    cameraSliderFill.Position = UDim2.new(0, 0, 0, 0)
    cameraSliderFill.BackgroundColor3 = Color3.fromRGB(170, 0, 255)
    cameraSliderFill.BorderSizePixel = 0

    local cameraSliderButton = Instance.new("Frame", cameraSliderBackground)
    cameraSliderButton.Size = UDim2.new(0, 15, 1.5, 0)
    cameraSliderButton.Position = UDim2.new((cameraFOV - 30) / 120, -7, -0.25, 0)
    cameraSliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    cameraSliderButton.BorderSizePixel = 1
    cameraSliderButton.BorderColor3 = Color3.fromRGB(200, 200, 200)

    -- Кнопки + и - для Camera FOV
    local cameraMinusButton = Instance.new("TextButton", cameraFOVSliderFrame)
    cameraMinusButton.Size = UDim2.new(0.2, 0, 0.3, 0)
    cameraMinusButton.Position = UDim2.new(0, 0, 0.8, 0)
    cameraMinusButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    cameraMinusButton.Text = "-"
    cameraMinusButton.TextColor3 = Color3.new(1, 1, 1)
    cameraMinusButton.TextScaled = true
    cameraMinusButton.BorderSizePixel = 0

    local cameraPlusButton = Instance.new("TextButton", cameraFOVSliderFrame)
    cameraPlusButton.Size = UDim2.new(0.2, 0, 0.3, 0)
    cameraPlusButton.Position = UDim2.new(0.8, 0, 0.8, 0)
    cameraPlusButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    cameraPlusButton.Text = "+"
    cameraPlusButton.TextColor3 = Color3.new(1, 1, 1)
    cameraPlusButton.TextScaled = true
    cameraPlusButton.BorderSizePixel = 0

    -- Кнопка Hide/Show GUI (внизу экрана по центру)
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
        cameraFOV = math.floor(math.clamp(value, 30, 150))
        cameraFOVLabel.Text = "Camera FOV: " .. cameraFOV
        
        local fillSize = (cameraFOV - 30) / 120
        cameraSliderFill.Size = UDim2.new(fillSize, 0, 1, 0)
        cameraSliderButton.Position = UDim2.new(fillSize, -7, -0.25, 0)
        
        if customCameraFOVEnabled then
            camera.FieldOfView = cameraFOV
        end
    end

    -- Обработка тача для слайдеров
    local isFOVSliding = false
    local isCameraSliding = false

    local function updateSliderFromTouch(touchPosition, isCamera)
        local sliderAbsPos = isCamera and cameraSliderBackground.AbsolutePosition or sliderBackground.AbsolutePosition
        local sliderAbsSize = isCamera and cameraSliderBackground.AbsoluteSize or sliderBackground.AbsoluteSize
        local touchX = touchPosition.X
        
        local relativeX = (touchX - sliderAbsPos.X) / sliderAbsSize.X
        relativeX = math.clamp(relativeX, 0, 1)
        
        if isCamera then
            local newCameraFOV = 30 + (relativeX * 120)
            updateCameraFOV(newCameraFOV)
        else
            local newFOV = 50 + (relativeX * 200)
            updateFOV(newFOV)
        end
    end

    -- Обработка для FOV слайдера
    sliderBackground.MouseButton1Down:Connect(function(x, y)
        isFOVSliding = true
        updateSliderFromTouch(Vector2.new(x, y), false)
    end)

    -- Обработка для Camera FOV слайдера
    cameraSliderBackground.MouseButton1Down:Connect(function(x, y)
        isCameraSliding = true
        updateSliderFromTouch(Vector2.new(x, y), true)
    end)

    userInputService.InputChanged:Connect(function(input)
        if isFOVSliding and input.UserInputType == Enum.UserInputType.Touch then
            updateSliderFromTouch(input.Position, false)
        elseif isCameraSliding and input.UserInputType == Enum.UserInputType.Touch then
            updateSliderFromTouch(input.Position, true)
        end
    end)

    userInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            isFOVSliding = false
            isCameraSliding = false
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

    -- Функция переключения вкладок
    local function switchTab(tabName)
        activeTab = tabName
        
        -- Скрыть все контейнеры
        infoContainer.Visible = false
        espContainer.Visible = false
        aimbotContainer.Visible = false
        memoryContainer.Visible = false
        
        -- Сбросить цвета всех вкладок
        infoTabButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        espTabButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        aimbotTabButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        memoryTabButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        
        -- Показать выбранный контейнер и выделить вкладку
        if tabName == "Info" then
            infoContainer.Visible = true
            infoTabButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        elseif tabName == "ESP" then
            espContainer.Visible = true
            espTabButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        elseif tabName == "AimBot" then
            aimbotContainer.Visible = true
            aimbotTabButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        elseif tabName == "Memory" then
            memoryContainer.Visible = true
            memoryTabButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        end
    end

    -- ОБРАБОТЧИКИ КНОПОК
    infoTabButton.MouseButton1Click:Connect(function()
        switchTab("Info")
    end)

    espTabButton.MouseButton1Click:Connect(function()
        switchTab("ESP")
    end)

    aimbotTabButton.MouseButton1Click:Connect(function()
        switchTab("AimBot")
    end)

    memoryTabButton.MouseButton1Click:Connect(function()
        switchTab("Memory")
    end)

    hideButton.MouseButton1Click:Connect(function()
        guiVisible = not guiVisible
        frame.Visible = guiVisible
        hideButton.Text = guiVisible and "Hide GUI" or "Show GUI"
    end)

    targetHeadButton.MouseButton1Click:Connect(function()
        aimbotTarget = "Head"
        targetHeadButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        targetBodyButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        targetHeadButton.Text = "Head ✅"
        targetBodyButton.Text = "Body"
    end)

    targetBodyButton.MouseButton1Click:Connect(function()
        aimbotTarget = "HumanoidRootPart"
        targetHeadButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        targetBodyButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        targetHeadButton.Text = "Head"
        targetBodyButton.Text = "Body ✅"
    end)

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

    autoTreeButton.MouseButton1Click:Connect(function()
        autoTreeEnabled = not autoTreeEnabled
        if autoTreeEnabled then
            autoTreeButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            autoTreeButton.Text = "Auto Tree: ON ✅"
            startTreeChopping()
        else
            autoTreeButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            autoTreeButton.Text = "Auto Tree: OFF"
        end
    end)

    -- Инициализация вкладок
    switchTab("Info")
end

createGUI()
showNotification()

player.CharacterAdded:Connect(function()
    task.wait(1)
    if not player:WaitForChild("PlayerGui"):FindFirstChild(guiName) then
        createGUI()
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