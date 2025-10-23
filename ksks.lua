-- SANSTRO Menu for Mobile
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Глобальные переменные для сохранения состояний
local speedHackEnabled = false
local jumpHackEnabled = false
local noclipEnabled = false
local espTracersEnabled = false
local espBoxEnabled = false
local espHealthEnabled = false
local espDistanceEnabled = false
local espCountEnabled = false
local aimBotEnabled = false
local currentSpeed = 16
local aimBotFOV = 50

-- Новые переменные из второго скрипта
local ActiveKillAura = false
local ActiveAutoChopTree = false
local DistanceForKillAura = 25
local DistanceForAutoChopTree = 25
local BringCount = 5
local BringDelay = 200
local CampfirePosition = Vector3.new(0, 10, 0)

-- Переменная для цели телепортации предметов
local BringTarget = "Campfire" -- "Campfire" или "Player"

-- Новые переменные для функций в разделе More
local antiAFKEnabled = false
local antiAFKConnection = nil

-- Настройки файла
local SETTINGS_FILE = "astralcheat_settings.txt"
local Settings = {
    ActiveKillAura = false,
    ActiveAutoChopTree = false,
    DistanceForKillAura = 25,
    DistanceForAutoChopTree = 25,
    BringCount = 5,
    BringDelay = 200,
    BringTarget = "Campfire",
    speedHackEnabled = false,
    jumpHackEnabled = false,
    currentSpeed = 16,
    antiAFKEnabled = false
}

local ScreenGui = nil
local MainMenu = nil
local GunMenu = nil
local NightsMenu = nil
local minimized = false
local fovCircle = nil
local savedPosition = UDim2.new(0, 10, 0, 10)
local savedButtonPosition = UDim2.new(0, 10, 0, 10)
local isGuiOpen = false
local OpenCloseButton = nil

-- ESP объекты
local espObjects = {}
local espConnections = {}
local espCountText = nil
local noclipConnection = nil

-- Текущее активное меню
local currentActiveMenu = nil

-- Система уведомлений
local notification = nil
local notificationTimer = nil

-- Функция для показа уведомлений
local function showNotification(text)
    if not ScreenGui then return end
    
    -- Удаляем предыдущее уведомление если есть
    if notification then
        notification:Destroy()
        notification = nil
    end
    
    -- Останавливаем предыдущий таймер
    if notificationTimer then
        notificationTimer:Disconnect()
        notificationTimer = nil
    end
    
    -- Создаем уведомление
    notification = Instance.new("TextLabel")
    notification.Name = "Notification"
    notification.Size = UDim2.new(0, 250, 0, 40)
    notification.Position = UDim2.new(1, -270, 1, -50)
    notification.BackgroundColor3 = Color3.fromRGB(40, 0, 40)
    notification.BackgroundTransparency = 0.2
    notification.TextColor3 = Color3.fromRGB(255, 255, 255)
    notification.Text = text
    notification.Font = Enum.Font.Gotham
    notification.TextSize = 14
    notification.TextWrapped = true
    notification.ZIndex = 100
    notification.Parent = ScreenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = notification
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(170, 0, 170)
    stroke.Thickness = 2
    stroke.Parent = notification
    
    -- Автоматическое удаление через 3 секунды
    notificationTimer = delay(3, function()
        if notification then
            notification:Destroy()
            notification = nil
        end
    end)
end

-- Функция для воспроизведения звука
local function playClickSound()
    pcall(function()
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://3578328117" -- ID звука "тыдынь"
        sound.Volume = 0.5
        sound.Parent = workspace
        sound:Play()
        game:GetService("Debris"):AddItem(sound, 2)
    end)
end

-- Функции сохранения настроек
local function SaveSettings()
    pcall(function()
        Settings.ActiveKillAura = ActiveKillAura
        Settings.ActiveAutoChopTree = ActiveAutoChopTree
        Settings.DistanceForKillAura = DistanceForKillAura
        Settings.DistanceForAutoChopTree = DistanceForAutoChopTree
        Settings.BringCount = BringCount
        Settings.BringDelay = BringDelay
        Settings.BringTarget = BringTarget
        Settings.speedHackEnabled = speedHackEnabled
        Settings.jumpHackEnabled = jumpHackEnabled
        Settings.currentSpeed = currentSpeed
        Settings.antiAFKEnabled = antiAFKEnabled
        
        local data = HttpService:JSONEncode(Settings)
        writefile(SETTINGS_FILE, data)
    end)
end

local function LoadSettings()
    pcall(function()
        if isfile(SETTINGS_FILE) then
            local data = readfile(SETTINGS_FILE)
            local loadedSettings = HttpService:JSONDecode(data)
            for key, value in pairs(loadedSettings) do
                if Settings[key] ~= nil then 
                    Settings[key] = value 
                end
            end
            
            -- Применяем загруженные настройки
            ActiveKillAura = Settings.ActiveKillAura
            ActiveAutoChopTree = Settings.ActiveAutoChopTree
            DistanceForKillAura = Settings.DistanceForKillAura
            DistanceForAutoChopTree = Settings.DistanceForAutoChopTree
            BringCount = Settings.BringCount
            BringDelay = Settings.BringDelay
            BringTarget = Settings.BringTarget or "Campfire"
            speedHackEnabled = Settings.speedHackEnabled or false
            jumpHackEnabled = Settings.jumpHackEnabled or false
            currentSpeed = Settings.currentSpeed or 16
            antiAFKEnabled = Settings.antiAFKEnabled or false
        end
    end)
end

-- Загружаем настройки при запуске
LoadSettings()

-- Функции для UI элементов
local function CreateToggle(parent, text, callback, isActive)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, 0, 0, 45)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(30, 0, 30)
    toggleFrame.BackgroundTransparency = 0.1
    toggleFrame.BorderSizePixel = 0
    toggleFrame.ZIndex = 2
    toggleFrame.Parent = parent
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = toggleFrame
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(80, 0, 80)
    Stroke.Thickness = 1
    Stroke.Parent = toggleFrame
    
    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Name = "ToggleLabel"
    toggleLabel.Size = UDim2.new(0.6, 0, 1, 0)
    toggleLabel.Position = UDim2.new(0, 15, 0, 0)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleLabel.Text = text
    toggleLabel.Font = Enum.Font.GothamSemibold
    toggleLabel.TextSize = 14
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    toggleLabel.ZIndex = 3
    toggleLabel.Parent = toggleFrame
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0.3, 0, 0, 30)
    toggleButton.Position = UDim2.new(0.65, 0, 0.15, 0)
    toggleButton.BackgroundColor3 = isActive and Color3.fromRGB(170, 0, 170) or Color3.fromRGB(60, 0, 60)
    toggleButton.BackgroundTransparency = 0.1
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.Text = isActive and "ON" or "OFF"
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.TextSize = 12
    toggleButton.ZIndex = 3
    toggleButton.Parent = toggleFrame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 6)
    toggleCorner.Parent = toggleButton
    
    local toggleStroke = Instance.new("UIStroke")
    toggleStroke.Color = Color3.fromRGB(100, 0, 100)
    toggleStroke.Thickness = 1
    toggleStroke.Parent = toggleButton
    
    toggleButton.MouseButton1Click:Connect(function()
        playClickSound()
        isActive = not isActive
        toggleButton.BackgroundColor3 = isActive and Color3.fromRGB(170, 0, 170) or Color3.fromRGB(60, 0, 60)
        toggleButton.Text = isActive and "ON" or "OFF"
        showNotification(text .. " " .. (isActive and "ENABLED" or "DISABLED"))
        callback(isActive)
        SaveSettings()
    end)
    
    return {
        Set = function(value)
            isActive = value
            toggleButton.BackgroundColor3 = isActive and Color3.fromRGB(170, 0, 170) or Color3.fromRGB(60, 0, 60)
            toggleButton.Text = isActive and "ON" or "OFF"
        end
    }
end

local function CreateSlider(parent, text, min, max, default, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, 0, 0, 65)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(30, 0, 30)
    sliderFrame.BackgroundTransparency = 0.1
    sliderFrame.BorderSizePixel = 0
    sliderFrame.ZIndex = 2
    sliderFrame.Parent = parent
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 8)
    sliderCorner.Parent = sliderFrame
    
    local sliderStroke = Instance.new("UIStroke")
    sliderStroke.Color = Color3.fromRGB(80, 0, 80)
    sliderStroke.Thickness = 1
    sliderStroke.Parent = sliderFrame
    
    local sliderText = Instance.new("TextLabel")
    sliderText.Size = UDim2.new(1, 0, 0, 25)
    sliderText.BackgroundTransparency = 1
    sliderText.Text = text .. ": " .. default
    sliderText.TextColor3 = Color3.fromRGB(255, 255, 255)
    sliderText.TextSize = 14
    sliderText.TextXAlignment = Enum.TextXAlignment.Left
    sliderText.Position = UDim2.new(0, 15, 0, 5)
    sliderText.Font = Enum.Font.GothamSemibold
    sliderText.ZIndex = 3
    sliderText.Parent = sliderFrame
    
    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new(1, -30, 0, 15)
    sliderBar.Position = UDim2.new(0, 15, 0, 35)
    sliderBar.BackgroundColor3 = Color3.fromRGB(50, 0, 50)
    sliderBar.ZIndex = 3
    sliderBar.Parent = sliderFrame
    
    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0, 8)
    barCorner.Parent = sliderBar
    
    local barStroke = Instance.new("UIStroke")
    barStroke.Color = Color3.fromRGB(100, 0, 100)
    barStroke.Thickness = 1
    barStroke.Parent = sliderBar
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(170, 0, 170)
    sliderFill.ZIndex = 4
    sliderFill.Parent = sliderBar
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 8)
    fillCorner.Parent = sliderFill
    
    local isDragging = false
    local connection = nil
    
    local function updateSlider(value)
        local norm = math.clamp((value - min) / (max - min), 0, 1)
        sliderFill.Size = UDim2.new(norm, 0, 1, 0)
        sliderText.Text = text .. ": " .. math.floor(value)
        callback(value)
    end
    
    sliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = true
            playClickSound()
            connection = RunService.Heartbeat:Connect(function()
                local mouseLocation = UserInputService:GetMouseLocation()
                local relativeX = math.clamp((mouseLocation.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
                local value = min + relativeX * (max - min)
                updateSlider(value)
            end)
        end
    end)
    
    sliderBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
            if connection then
                connection:Disconnect()
                connection = nil
            end
            SaveSettings()
        end
    end)
    
    updateSlider(default)
end

local function CreateButton(parent, text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 45)
    button.BackgroundColor3 = Color3.fromRGB(30, 0, 30)
    button.BackgroundTransparency = 0.1
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    button.Font = Enum.Font.GothamSemibold
    button.ZIndex = 2
    button.Parent = parent
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = button
    
    local buttonStroke = Instance.new("UIStroke")
    buttonStroke.Color = Color3.fromRGB(80, 0, 80)
    buttonStroke.Thickness = 1
    buttonStroke.Parent = button
    
    button.MouseButton1Click:Connect(function()
        playClickSound()
        callback()
    end)
    
    return button
end

-- Функция создания FOV Circle
local function createFOVCircle()
    if fovCircle then
        fovCircle:Remove()
    end
    
    fovCircle = Drawing.new("Circle")
    fovCircle.Visible = false
    fovCircle.Color = Color3.fromRGB(170, 0, 170)
    fovCircle.Thickness = 2
    fovCircle.Filled = false
    fovCircle.Radius = aimBotFOV
    fovCircle.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)
end

-- Функция обновления FOV Circle
local function updateFOVCircle()
    if fovCircle then
        fovCircle.Radius = aimBotFOV
        fovCircle.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)
    end
end

-- Функция создания современной кнопки открытия/закрытия
local function createOpenCloseButton()
    if OpenCloseButton then
        OpenCloseButton:Destroy()
    end

    OpenCloseButton = Instance.new("TextButton")
    OpenCloseButton.Name = "OpenCloseButton"
    OpenCloseButton.Size = UDim2.new(0, 65, 0, 65)
    OpenCloseButton.Position = savedButtonPosition
    OpenCloseButton.BackgroundColor3 = Color3.fromRGB(20, 0, 20)
    OpenCloseButton.BackgroundTransparency = 0.1
    OpenCloseButton.TextColor3 = Color3.fromRGB(170, 0, 170)
    OpenCloseButton.Text = "⚙️"
    OpenCloseButton.Font = Enum.Font.GothamBold
    OpenCloseButton.TextSize = 24
    OpenCloseButton.ZIndex = 10
    OpenCloseButton.Active = true
    OpenCloseButton.Draggable = true
    OpenCloseButton.Parent = ScreenGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(1, 0)
    Corner.Parent = OpenCloseButton

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(170, 0, 170)
    Stroke.Thickness = 2
    Stroke.Parent = OpenCloseButton

    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.Size = UDim2.new(1, 10, 1, 10)
    Shadow.Position = UDim2.new(0, -5, 0, -5)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://5554236805"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.8
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    Shadow.ZIndex = 9
    Shadow.Parent = OpenCloseButton

    -- Обработчик нажатия
    OpenCloseButton.MouseButton1Click:Connect(function()
        playClickSound()
        isGuiOpen = not isGuiOpen
        
        -- Закрываем/открываем текущее активное меню
        if currentActiveMenu then
            currentActiveMenu.Visible = isGuiOpen
        end
        
        if isGuiOpen then
            OpenCloseButton.Text = "✕"
            OpenCloseButton.BackgroundColor3 = Color3.fromRGB(40, 0, 40)
        else
            OpenCloseButton.Text = "⚙️"
            OpenCloseButton.BackgroundColor3 = Color3.fromRGB(20, 0, 20)
        end
    end)

    -- Сохраняем позицию кнопки при перетаскивании
    OpenCloseButton.DragStopped:Connect(function()
        savedButtonPosition = OpenCloseButton.Position
    end)
end

-- Функция для переключения кнопок
local function toggleButton(button, enabled)
    if enabled then
        button.BackgroundColor3 = Color3.fromRGB(170, 0, 170)
        button.Text = "ON"
    else
        button.BackgroundColor3 = Color3.fromRGB(60, 0, 60)
        button.Text = "OFF"
    end
end

-- Функция очистки ESP
local function cleanupESP(otherPlayer)
    if espObjects[otherPlayer] then
        if espObjects[otherPlayer].tracer then
            espObjects[otherPlayer].tracer:Remove()
        end
        if espObjects[otherPlayer].box then
            espObjects[otherPlayer].box:Remove()
        end
        if espObjects[otherPlayer].health then
            espObjects[otherPlayer].health:Remove()
        end
        if espObjects[otherPlayer].distance then
            espObjects[otherPlayer].distance:Remove()
        end
        espObjects[otherPlayer] = nil
    end
    
    if espConnections[otherPlayer] then
        espConnections[otherPlayer]:Disconnect()
        espConnections[otherPlayer] = nil
    end
end

-- ESP Functions
local function createESP(otherPlayer)
    if otherPlayer == player then return end
    
    cleanupESP(otherPlayer)
    
    espObjects[otherPlayer] = {
        tracer = nil,
        box = nil,
        health = nil,
        distance = nil
    }
    
    local function updateESP()
        if not espObjects[otherPlayer] then return end
        
        -- Check if player is dead or doesn't exist
        if not otherPlayer.Character or not otherPlayer.Character:FindFirstChild("HumanoidRootPart") or not otherPlayer.Character:FindFirstChild("Humanoid") then
            if espObjects[otherPlayer].tracer then espObjects[otherPlayer].tracer.Visible = false end
            if espObjects[otherPlayer].box then espObjects[otherPlayer].box.Visible = false end
            if espObjects[otherPlayer].health then espObjects[otherPlayer].health.Visible = false end
            if espObjects[otherPlayer].distance then espObjects[otherPlayer].distance.Visible = false end
            return
        end
        
        local rootPart = otherPlayer.Character.HumanoidRootPart
        local humanoid = otherPlayer.Character.Humanoid
        local head = otherPlayer.Character:FindFirstChild("Head")
        
        if not head then return end
        
        -- Check if player is dead
        if humanoid.Health <= 0 then
            if espObjects[otherPlayer].tracer then espObjects[otherPlayer].tracer.Visible = false end
            if espObjects[otherPlayer].box then espObjects[otherPlayer].box.Visible = false end
            if espObjects[otherPlayer].health then espObjects[otherPlayer].health.Visible = false end
            if espObjects[otherPlayer].distance then espObjects[otherPlayer].distance.Visible = false end
            return
        end
        
        local vector, onScreen = workspace.CurrentCamera:WorldToViewportPoint(rootPart.Position)
        
        if onScreen then
            -- Tracer
            if espTracersEnabled then
                if not espObjects[otherPlayer].tracer then
                    espObjects[otherPlayer].tracer = Drawing.new("Line")
                    espObjects[otherPlayer].tracer.Thickness = 1
                    espObjects[otherPlayer].tracer.Color = Color3.fromRGB(170, 0, 170)
                end
                
                local screenCenter = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y)
                espObjects[otherPlayer].tracer.From = screenCenter
                espObjects[otherPlayer].tracer.To = Vector2.new(vector.X, vector.Y)
                espObjects[otherPlayer].tracer.Visible = true
            elseif espObjects[otherPlayer].tracer then
                espObjects[otherPlayer].tracer.Visible = false
            end
            
            -- Box ESP
            if espBoxEnabled then
                if not espObjects[otherPlayer].box then
                    espObjects[otherPlayer].box = Drawing.new("Square")
                    espObjects[otherPlayer].box.Thickness = 1
                    espObjects[otherPlayer].box.Color = Color3.fromRGB(170, 0, 170)
                    espObjects[otherPlayer].box.Filled = false
                end
                
                local headPos = workspace.CurrentCamera:WorldToViewportPoint(head.Position)
                local rootPos = workspace.CurrentCamera:WorldToViewportPoint(rootPart.Position)
                
                local size = Vector2.new(2000 / rootPos.Z, 3000 / rootPos.Z)
                local position = Vector2.new(headPos.X - size.X / 2, headPos.Y - size.Y / 2)
                
                espObjects[otherPlayer].box.Size = size
                espObjects[otherPlayer].box.Position = position
                espObjects[otherPlayer].box.Visible = true
            elseif espObjects[otherPlayer].box then
                espObjects[otherPlayer].box.Visible = false
            end
            
            -- Health ESP
            if espHealthEnabled then
                if not espObjects[otherPlayer].health then
                    espObjects[otherPlayer].health = Drawing.new("Text")
                    espObjects[otherPlayer].health.Size = 14
                    espObjects[otherPlayer].health.Center = true
                    espObjects[otherPlayer].health.Outline = true
                    espObjects[otherPlayer].health.Color = Color3.fromRGB(170, 0, 170)
                end
                
                local headPos = workspace.CurrentCamera:WorldToViewportPoint(head.Position)
                espObjects[otherPlayer].health.Position = Vector2.new(headPos.X, headPos.Y - 40)
                espObjects[otherPlayer].health.Text = "HP: " .. math.floor(humanoid.Health)
                espObjects[otherPlayer].health.Visible = true
            elseif espObjects[otherPlayer].health then
                espObjects[otherPlayer].health.Visible = false
            end
            
            -- Distance ESP
            if espDistanceEnabled then
                if not espObjects[otherPlayer].distance then
                    espObjects[otherPlayer].distance = Drawing.new("Text")
                    espObjects[otherPlayer].distance.Size = 14
                    espObjects[otherPlayer].distance.Center = true
                    espObjects[otherPlayer].distance.Outline = true
                    espObjects[otherPlayer].distance.Color = Color3.fromRGB(170, 0, 170)
                end
                
                local headPos = workspace.CurrentCamera:WorldToViewportPoint(head.Position)
                local distance = (player.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
                espObjects[otherPlayer].distance.Position = Vector2.new(headPos.X, headPos.Y - 60)
                espObjects[otherPlayer].distance.Text = "Distance: " .. math.floor(distance)
                espObjects[otherPlayer].distance.Visible = true
            elseif espObjects[otherPlayer].distance then
                espObjects[otherPlayer].distance.Visible = false
            end
        else
            if espObjects[otherPlayer].tracer then espObjects[otherPlayer].tracer.Visible = false end
            if espObjects[otherPlayer].box then espObjects[otherPlayer].box.Visible = false end
            if espObjects[otherPlayer].health then espObjects[otherPlayer].health.Visible = false end
            if espObjects[otherPlayer].distance then espObjects[otherPlayer].distance.Visible = false end
        end
    end
    
    -- Update ESP continuously
    espConnections[otherPlayer] = RunService.Heartbeat:Connect(updateESP)
    
    -- Clean up when player leaves
    otherPlayer.AncestryChanged:Connect(function()
        if not otherPlayer.Parent then
            cleanupESP(otherPlayer)
        end
    end)
end

-- ESP Count Function
local function updateESPCount()
    if not espCountEnabled or not espCountText then return end
    
    local aliveCount = 0
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("Humanoid") and otherPlayer.Character.Humanoid.Health > 0 then
            aliveCount = aliveCount + 1
        end
    end
    
    espCountText.Text = "Players: " .. aliveCount
    espCountText.Visible = true
end

-- Improved AimBot with wall check and FOV
local function isPlayerVisible(targetPlayer)
    if not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return false
    end
    
    local targetRoot = targetPlayer.Character.HumanoidRootPart
    local camera = workspace.CurrentCamera
    local origin = camera.CFrame.Position
    
    -- Raycast to target
    local direction = (targetRoot.Position - origin).Unit
    local ray = Ray.new(origin, direction * 1000)
    
    local ignoreList = {player.Character, camera}
    local hit, hitPosition = workspace:FindPartOnRayWithIgnoreList(ray, ignoreList)
    
    if hit then
        -- Check if we hit the target player
        local hitModel = hit:FindFirstAncestorOfClass("Model")
        if hitModel and hitModel == targetPlayer.Character then
            return true
        end
    end
    
    return false
end

-- Check if target is within FOV circle
local function isInFOV(targetPosition)
    local camera = workspace.CurrentCamera
    local screenPoint, onScreen = camera:WorldToViewportPoint(targetPosition)
    
    if not onScreen then return false end
    
    local center = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    local targetPoint = Vector2.new(screenPoint.X, screenPoint.Y)
    local distance = (targetPoint - center).Magnitude
    
    return distance <= aimBotFOV
end

-- Функции из второго скрипта
-- Kill Aura функция
local function RunKillAura()
    while ActiveKillAura do
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local weapon = player.Inventory:FindFirstChild("Old Axe") or player.Inventory:FindFirstChild("Good Axe") or player.Inventory:FindFirstChild("Strong Axe") or player.Inventory:FindFirstChild("Chainsaw")
        
        if hrp and weapon then
            for _, enemy in pairs(workspace.Characters:GetChildren()) do
                if enemy:IsA("Model") and enemy.PrimaryPart then
                    local dist = (enemy.PrimaryPart.Position - hrp.Position).Magnitude
                    if dist <= DistanceForKillAura then
                        game:GetService("ReplicatedStorage").RemoteEvents.ToolDamageObject:InvokeServer(enemy, weapon, 999, hrp.CFrame)
                    end
                end
            end
        end
        wait(0.1)
    end
end

-- Auto Chop функция
local function RunAutoChop()
    while ActiveAutoChopTree do
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local weapon = player.Inventory:FindFirstChild("Old Axe") or player.Inventory:FindFirstChild("Good Axe") or player.Inventory:FindFirstChild("Strong Axe") or player.Inventory:FindFirstChild("Chainsaw")
        
        if hrp and weapon then
            for _, tree in pairs(workspace.Map.Foliage:GetChildren()) do
                if tree:IsA("Model") and (tree.Name == "Small Tree" or tree.Name == "TreeBig1" or tree.Name == "TreeBig2") and tree.PrimaryPart then
                    local dist = (tree.PrimaryPart.Position - hrp.Position).Magnitude
                    if dist <= DistanceForAutoChopTree then
                        game:GetService("ReplicatedStorage").RemoteEvents.ToolDamageObject:InvokeServer(tree, weapon, 999, hrp.CFrame)
                    end
                end
            end
        end
        wait(0.1)
    end
end

-- Обновленная функция Bring Items с поддержкой выбора цели
local function BringItems(itemName)
    local targetPos
    if BringTarget == "Player" then
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            targetPos = char.HumanoidRootPart.Position
        else
            targetPos = CampfirePosition
        end
    else
        targetPos = CampfirePosition
    end
    
    local items = {}
    
    for _, item in pairs(workspace.Items:GetChildren()) do
        if item:IsA("Model") then
            local itemLower = item.Name:lower()
            local searchLower = itemName:lower()
            
            if itemLower:find(searchLower) then
                local part = item:FindFirstChildWhichIsA("BasePart")
                if part then table.insert(items, part) end
            end
        end
    end
    
    local teleported = 0
    for i = 1, math.min(BringCount, #items) do
        local item = items[i]
        item.CFrame = CFrame.new(
            targetPos.X + math.random(-3,3),
            targetPos.Y + 3,
            targetPos.Z + math.random(-3,3)
        )
        item.Anchored = false
        item.AssemblyLinearVelocity = Vector3.new(0,0,0)
        teleported = teleported + 1
        
        if BringDelay > 0 then
            wait(BringDelay / 1000)
        end
    end
    
    -- Показываем уведомление о количестве телепортированных предметов
    showNotification("Teleported " .. teleported .. " " .. itemName .. "(s)")
end

-- Anti AFK функция
local function EnableAntiAFK()
    if antiAFKConnection then
        antiAFKConnection:Disconnect()
        antiAFKConnection = nil
    end
    
    antiAFKConnection = RunService.Heartbeat:Connect(function()
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            -- Просто обновляем время последней активности
            player.Character.Humanoid.Jump = true
            wait(0.1)
            player.Character.Humanoid.Jump = false
        end
    end)
end

local function DisableAntiAFK()
    if antiAFKConnection then
        antiAFKConnection:Disconnect()
        antiAFKConnection = nil
    end
end

-- Запускаем функции геймплея
task.spawn(function()
    while true do
        if ActiveKillAura then
            RunKillAura()
        end
        wait(1)
    end
end)

task.spawn(function()
    while true do
        if ActiveAutoChopTree then
            RunAutoChop()
        end
        wait(1)
    end
end)

-- Применяем настройки SpeedHack при загрузке
if speedHackEnabled then
    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = currentSpeed
    end
end

-- Применяем настройки AntiAFK при загрузке
if antiAFKEnabled then
    EnableAntiAFK()
end

-- Функция создания главного меню выбора
local function createMainMenu()
    MainMenu = Instance.new("Frame")
    MainMenu.Name = "MainMenu"
    MainMenu.Size = UDim2.new(0, 300, 0, 240)
    MainMenu.Position = savedPosition
    MainMenu.BackgroundColor3 = Color3.fromRGB(20, 0, 20)
    MainMenu.BackgroundTransparency = 0.1
    MainMenu.BorderSizePixel = 0
    MainMenu.Active = true
    MainMenu.Draggable = true
    MainMenu.Visible = isGuiOpen
    MainMenu.Parent = ScreenGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = MainMenu

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(170, 0, 170)
    Stroke.Thickness = 2
    Stroke.Parent = MainMenu

    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.Size = UDim2.new(1, 20, 1, 20)
    Shadow.Position = UDim2.new(0, -10, 0, -10)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://5554236805"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.8
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    Shadow.ZIndex = -1
    Shadow.Parent = MainMenu

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundTransparency = 1
    Title.Text = "SANSTRO MENU"
    Title.TextColor3 = Color3.fromRGB(170, 0, 170)
    Title.TextSize = 20
    Title.Font = Enum.Font.GothamBold
    Title.Parent = MainMenu

    local ButtonsContainer = Instance.new("Frame")
    ButtonsContainer.Name = "ButtonsContainer"
    ButtonsContainer.Size = UDim2.new(1, -20, 1, -60)
    ButtonsContainer.Position = UDim2.new(0, 10, 0, 50)
    ButtonsContainer.BackgroundTransparency = 1
    ButtonsContainer.Parent = MainMenu

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 8)
    UIListLayout.FillDirection = Enum.FillDirection.Vertical
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = ButtonsContainer

    -- Кнопки меню
    local function createMenuButton(text, callback)
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, 0, 0, 40)
        button.BackgroundColor3 = Color3.fromRGB(30, 0, 30)
        button.BackgroundTransparency = 0.1
        button.Text = text
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextSize = 14
        button.Font = Enum.Font.GothamSemibold
        button.Parent = ButtonsContainer
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = button
        
        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(80, 0, 80)
        stroke.Thickness = 1
        stroke.Parent = button
        
        button.MouseButton1Click:Connect(function()
            playClickSound()
            callback()
        end)
        
        return button
    end

    -- Кнопка Player
    createMenuButton("Player", function()
        currentActiveMenu = createPlayerMenu()
        MainMenu.Visible = false
    end)

    -- Кнопка ESP
    createMenuButton("ESP", function()
        currentActiveMenu = createESPMenu()
        MainMenu.Visible = false
    end)

    -- Кнопка Gun
    createMenuButton("Gun", function()
        currentActiveMenu = createGunMenu()
        MainMenu.Visible = false
    end)

    -- Кнопка 99 Nights
    createMenuButton("99 Nights", function()
        currentActiveMenu = createNightsMenu()
        MainMenu.Visible = false
    end)

    -- Кнопка More
    createMenuButton("More", function()
        currentActiveMenu = createMoreMenu()
        MainMenu.Visible = false
    end)

    -- Сохраняем позицию при перетаскивании
    MainMenu.DragStopped:Connect(function()
        savedPosition = MainMenu.Position
    end)
end

-- Функция создания меню Player
local function createPlayerMenu()
    local menu = Instance.new("Frame")
    menu.Name = "PlayerMenu"
    menu.Size = UDim2.new(0, 300, 0, 300)
    menu.Position = savedPosition
    menu.BackgroundColor3 = Color3.fromRGB(20, 0, 20)
    menu.BackgroundTransparency = 0.1
    menu.BorderSizePixel = 0
    menu.Active = true
    menu.Draggable = true
    menu.Visible = isGuiOpen
    menu.Parent = ScreenGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = menu

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(170, 0, 170)
    Stroke.Thickness = 2
    Stroke.Parent = menu

    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.Size = UDim2.new(1, 20, 1, 20)
    Shadow.Position = UDim2.new(0, -10, 0, -10)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://5554236805"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.8
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    Shadow.ZIndex = -1
    Shadow.Parent = menu

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundTransparency = 1
    Title.Text = "PLAYER"
    Title.TextColor3 = Color3.fromRGB(170, 0, 170)
    Title.TextSize = 20
    Title.Font = Enum.Font.GothamBold
    Title.Parent = menu

    local BackButton = Instance.new("TextButton")
    BackButton.Name = "BackButton"
    BackButton.Size = UDim2.new(0, 60, 0, 30)
    BackButton.Position = UDim2.new(0, 10, 0, 5)
    BackButton.BackgroundColor3 = Color3.fromRGB(30, 0, 30)
    BackButton.BackgroundTransparency = 0.1
    BackButton.Text = "← Back"
    BackButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    BackButton.TextSize = 12
    BackButton.Font = Enum.Font.GothamSemibold
    BackButton.Parent = menu

    local BackCorner = Instance.new("UICorner")
    BackCorner.CornerRadius = UDim.new(0, 6)
    BackCorner.Parent = BackButton

    local BackStroke = Instance.new("UIStroke")
    BackStroke.Color = Color3.fromRGB(80, 0, 80)
    BackStroke.Thickness = 1
    BackStroke.Parent = BackButton

    BackButton.MouseButton1Click:Connect(function()
        playClickSound()
        menu.Visible = false
        MainMenu.Visible = true
        currentActiveMenu = MainMenu
    end)

    local ScrollFrame = Instance.new("ScrollingFrame")
    ScrollFrame.Name = "ScrollFrame"
    ScrollFrame.Size = UDim2.new(1, -20, 1, -60)
    ScrollFrame.Position = UDim2.new(0, 10, 0, 50)
    ScrollFrame.BackgroundTransparency = 1
    ScrollFrame.BorderSizePixel = 0
    ScrollFrame.ScrollBarThickness = 6
    ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(170, 0, 170)
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ScrollFrame.Parent = menu

    local Container = Instance.new("Frame")
    Container.Name = "Container"
    Container.Size = UDim2.new(1, 0, 0, 0)
    Container.BackgroundTransparency = 1
    Container.Parent = ScrollFrame

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 8)
    UIListLayout.FillDirection = Enum.FillDirection.Vertical
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = Container

    -- Speed Hack Toggle
    CreateToggle(Container, "Speed Hack", function(enabled)
        speedHackEnabled = enabled
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = enabled and currentSpeed or 16
        end
    end, speedHackEnabled)

    -- Speed Slider
    CreateSlider(Container, "Speed Value", 16, 100, currentSpeed, function(value)
        currentSpeed = value
        if speedHackEnabled then
            local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = value
            end
        end
    end)

    -- Jump Hack Toggle
    CreateToggle(Container, "Jump Hack", function(enabled)
        jumpHackEnabled = enabled
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.JumpPower = enabled and 50 or 50
        end
    end, jumpHackEnabled)

    -- Noclip Toggle
    CreateToggle(Container, "Noclip", function(enabled)
        noclipEnabled = enabled
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        
        if enabled then
            noclipConnection = RunService.Stepped:Connect(function()
                if player.Character then
                    for _, part in pairs(player.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end
    end, noclipEnabled)

    -- Сохраняем позицию при перетаскивании
    menu.DragStopped:Connect(function()
        savedPosition = menu.Position
    end)

    return menu
end

-- Функция создания меню ESP
local function createESPMenu()
    local menu = Instance.new("Frame")
    menu.Name = "ESPMenu"
    menu.Size = UDim2.new(0, 300, 0, 300)
    menu.Position = savedPosition
    menu.BackgroundColor3 = Color3.fromRGB(20, 0, 20)
    menu.BackgroundTransparency = 0.1
    menu.BorderSizePixel = 0
    menu.Active = true
    menu.Draggable = true
    menu.Visible = isGuiOpen
    menu.Parent = ScreenGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = menu

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(170, 0, 170)
    Stroke.Thickness = 2
    Stroke.Parent = menu

    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.Size = UDim2.new(1, 20, 1, 20)
    Shadow.Position = UDim2.new(0, -10, 0, -10)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://5554236805"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.8
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    Shadow.ZIndex = -1
    Shadow.Parent = menu

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundTransparency = 1
    Title.Text = "ESP"
    Title.TextColor3 = Color3.fromRGB(170, 0, 170)
    Title.TextSize = 20
    Title.Font = Enum.Font.GothamBold
    Title.Parent = menu

    local BackButton = Instance.new("TextButton")
    BackButton.Name = "BackButton"
    BackButton.Size = UDim2.new(0, 60, 0, 30)
    BackButton.Position = UDim2.new(0, 10, 0, 5)
    BackButton.BackgroundColor3 = Color3.fromRGB(30, 0, 30)
    BackButton.BackgroundTransparency = 0.1
    BackButton.Text = "← Back"
    BackButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    BackButton.TextSize = 12
    BackButton.Font = Enum.Font.GothamSemibold
    BackButton.Parent = menu

    local BackCorner = Instance.new("UICorner")
    BackCorner.CornerRadius = UDim.new(0, 6)
    BackCorner.Parent = BackButton

    local BackStroke = Instance.new("UIStroke")
    BackStroke.Color = Color3.fromRGB(80, 0, 80)
    BackStroke.Thickness = 1
    BackStroke.Parent = BackButton

    BackButton.MouseButton1Click:Connect(function()
        playClickSound()
        menu.Visible = false
        MainMenu.Visible = true
        currentActiveMenu = MainMenu
    end)

    local ScrollFrame = Instance.new("ScrollingFrame")
    ScrollFrame.Name = "ScrollFrame"
    ScrollFrame.Size = UDim2.new(1, -20, 1, -60)
    ScrollFrame.Position = UDim2.new(0, 10, 0, 50)
    ScrollFrame.BackgroundTransparency = 1
    ScrollFrame.BorderSizePixel = 0
    ScrollFrame.ScrollBarThickness = 6
    ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(170, 0, 170)
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ScrollFrame.Parent = menu

    local Container = Instance.new("Frame")
    Container.Name = "Container"
    Container.Size = UDim2.new(1, 0, 0, 0)
    Container.BackgroundTransparency = 1
    Container.Parent = ScrollFrame

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 8)
    UIListLayout.FillDirection = Enum.FillDirection.Vertical
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = Container

    -- ESP Tracers Toggle
    CreateToggle(Container, "ESP Tracers", function(enabled)
        espTracersEnabled = enabled
        if enabled then
            for _, otherPlayer in pairs(Players:GetPlayers()) do
                createESP(otherPlayer)
            end
        else
            for _, otherPlayer in pairs(Players:GetPlayers()) do
                cleanupESP(otherPlayer)
            end
        end
    end, espTracersEnabled)

    -- ESP Box Toggle
    CreateToggle(Container, "ESP Box", function(enabled)
        espBoxEnabled = enabled
        if enabled then
            for _, otherPlayer in pairs(Players:GetPlayers()) do
                createESP(otherPlayer)
            end
        else
            for _, otherPlayer in pairs(Players:GetPlayers()) do
                cleanupESP(otherPlayer)
            end
        end
    end, espBoxEnabled)

    -- ESP Health Toggle
    CreateToggle(Container, "ESP Health", function(enabled)
        espHealthEnabled = enabled
        if enabled then
            for _, otherPlayer in pairs(Players:GetPlayers()) do
                createESP(otherPlayer)
            end
        else
            for _, otherPlayer in pairs(Players:GetPlayers()) do
                cleanupESP(otherPlayer)
            end
        end
    end, espHealthEnabled)

    -- ESP Distance Toggle
    CreateToggle(Container, "ESP Distance", function(enabled)
        espDistanceEnabled = enabled
        if enabled then
            for _, otherPlayer in pairs(Players:GetPlayers()) do
                createESP(otherPlayer)
            end
        else
            for _, otherPlayer in pairs(Players:GetPlayers()) do
                cleanupESP(otherPlayer)
            end
        end
    end, espDistanceEnabled)

    -- ESP Count Toggle
    CreateToggle(Container, "ESP Count", function(enabled)
        espCountEnabled = enabled
        if enabled then
            if not espCountText then
                espCountText = Drawing.new("Text")
                espCountText.Size = 20
                espCountText.Position = Vector2.new(10, 10)
                espCountText.Color = Color3.fromRGB(170, 0, 170)
                espCountText.Outline = true
                espCountText.Visible = true
            end
            RunService.Heartbeat:Connect(updateESPCount)
        elseif espCountText then
            espCountText.Visible = false
        end
    end, espCountEnabled)

    -- Сохраняем позицию при перетаскивании
    menu.DragStopped:Connect(function()
        savedPosition = menu.Position
    end)

    return menu
end

-- Функция создания меню Gun
local function createGunMenu()
    local menu = Instance.new("Frame")
    menu.Name = "GunMenu"
    menu.Size = UDim2.new(0, 300, 0, 250)
    menu.Position = savedPosition
    menu.BackgroundColor3 = Color3.fromRGB(20, 0, 20)
    menu.BackgroundTransparency = 0.1
    menu.BorderSizePixel = 0
    menu.Active = true
    menu.Draggable = true
    menu.Visible = isGuiOpen
    menu.Parent = ScreenGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = menu

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(170, 0, 170)
    Stroke.Thickness = 2
    Stroke.Parent = menu

    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.Size = UDim2.new(1, 20, 1, 20)
    Shadow.Position = UDim2.new(0, -10, 0, -10)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://5554236805"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.8
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    Shadow.ZIndex = -1
    Shadow.Parent = menu

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundTransparency = 1
    Title.Text = "GUN"
    Title.TextColor3 = Color3.fromRGB(170, 0, 170)
    Title.TextSize = 20
    Title.Font = Enum.Font.GothamBold
    Title.Parent = menu

    local BackButton = Instance.new("TextButton")
    BackButton.Name = "BackButton"
    BackButton.Size = UDim2.new(0, 60, 0, 30)
    BackButton.Position = UDim2.new(0, 10, 0, 5)
    BackButton.BackgroundColor3 = Color3.fromRGB(30, 0, 30)
    BackButton.BackgroundTransparency = 0.1
    BackButton.Text = "← Back"
    BackButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    BackButton.TextSize = 12
    BackButton.Font = Enum.Font.GothamSemibold
    BackButton.Parent = menu

    local BackCorner = Instance.new("UICorner")
    BackCorner.CornerRadius = UDim.new(0, 6)
    BackCorner.Parent = BackButton

    local BackStroke = Instance.new("UIStroke")
    BackStroke.Color = Color3.fromRGB(80, 0, 80)
    BackStroke.Thickness = 1
    BackStroke.Parent = BackButton

    BackButton.MouseButton1Click:Connect(function()
        playClickSound()
        menu.Visible = false
        MainMenu.Visible = true
        currentActiveMenu = MainMenu
    end)

    local ScrollFrame = Instance.new("ScrollingFrame")
    ScrollFrame.Name = "ScrollFrame"
    ScrollFrame.Size = UDim2.new(1, -20, 1, -60)
    ScrollFrame.Position = UDim2.new(0, 10, 0, 50)
    ScrollFrame.BackgroundTransparency = 1
    ScrollFrame.BorderSizePixel = 0
    ScrollFrame.ScrollBarThickness = 6
    ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(170, 0, 170)
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ScrollFrame.Parent = menu

    local Container = Instance.new("Frame")
    Container.Name = "Container"
    Container.Size = UDim2.new(1, 0, 0, 0)
    Container.BackgroundTransparency = 1
    Container.Parent = ScrollFrame

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 8)
    UIListLayout.FillDirection = Enum.FillDirection.Vertical
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = Container

    -- AimBot Toggle
    CreateToggle(Container, "AimBot", function(enabled)
        aimBotEnabled = enabled
        if enabled then
            createFOVCircle()
            fovCircle.Visible = true
        elseif fovCircle then
            fovCircle.Visible = false
        end
    end, aimBotEnabled)

    -- AimBot FOV Slider
    CreateSlider(Container, "AimBot FOV", 10, 200, aimBotFOV, function(value)
        aimBotFOV = value
        updateFOVCircle()
    end)

    -- Сохраняем позицию при перетаскивании
    menu.DragStopped:Connect(function()
        savedPosition = menu.Position
    end)

    return menu
end

-- Функция создания меню 99 Nights
local function createNightsMenu()
    local menu = Instance.new("Frame")
    menu.Name = "NightsMenu"
    menu.Size = UDim2.new(0, 300, 0, 350)
    menu.Position = savedPosition
    menu.BackgroundColor3 = Color3.fromRGB(20, 0, 20)
    menu.BackgroundTransparency = 0.1
    menu.BorderSizePixel = 0
    menu.Active = true
    menu.Draggable = true
    menu.Visible = isGuiOpen
    menu.Parent = ScreenGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = menu

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(170, 0, 170)
    Stroke.Thickness = 2
    Stroke.Parent = menu

    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.Size = UDim2.new(1, 20, 1, 20)
    Shadow.Position = UDim2.new(0, -10, 0, -10)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://5554236805"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.8
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    Shadow.ZIndex = -1
    Shadow.Parent = menu

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundTransparency = 1
    Title.Text = "99 NIGHTS"
    Title.TextColor3 = Color3.fromRGB(170, 0, 170)
    Title.TextSize = 20
    Title.Font = Enum.Font.GothamBold
    Title.Parent = menu

    local BackButton = Instance.new("TextButton")
    BackButton.Name = "BackButton"
    BackButton.Size = UDim2.new(0, 60, 0, 30)
    BackButton.Position = UDim2.new(0, 10, 0, 5)
    BackButton.BackgroundColor3 = Color3.fromRGB(30, 0, 30)
    BackButton.BackgroundTransparency = 0.1
    BackButton.Text = "← Back"
    BackButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    BackButton.TextSize = 12
    BackButton.Font = Enum.Font.GothamSemibold
    BackButton.Parent = menu

    local BackCorner = Instance.new("UICorner")
    BackCorner.CornerRadius = UDim.new(0, 6)
    BackCorner.Parent = BackButton

    local BackStroke = Instance.new("UIStroke")
    BackStroke.Color = Color3.fromRGB(80, 0, 80)
    BackStroke.Thickness = 1
    BackStroke.Parent = BackButton

    BackButton.MouseButton1Click:Connect(function()
        playClickSound()
        menu.Visible = false
        MainMenu.Visible = true
        currentActiveMenu = MainMenu
    end)

    local ScrollFrame = Instance.new("ScrollingFrame")
    ScrollFrame.Name = "ScrollFrame"
    ScrollFrame.Size = UDim2.new(1, -20, 1, -60)
    ScrollFrame.Position = UDim2.new(0, 10, 0, 50)
    ScrollFrame.BackgroundTransparency = 1
    ScrollFrame.BorderSizePixel = 0
    ScrollFrame.ScrollBarThickness = 6
    ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(170, 0, 170)
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ScrollFrame.Parent = menu

    local Container = Instance.new("Frame")
    Container.Name = "Container"
    Container.Size = UDim2.new(1, 0, 0, 0)
    Container.BackgroundTransparency = 1
    Container.Parent = ScrollFrame

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 8)
    UIListLayout.FillDirection = Enum.FillDirection.Vertical
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = Container

    -- Kill Aura Toggle
    CreateToggle(Container, "Kill Aura", function(enabled)
        ActiveKillAura = enabled
        showNotification("Kill Aura " .. (enabled and "ENABLED" or "DISABLED"))
    end, ActiveKillAura)

    -- Kill Aura Distance Slider
    CreateSlider(Container, "Kill Aura Distance", 10, 50, DistanceForKillAura, function(value)
        DistanceForKillAura = value
    end)

    -- Auto Chop Tree Toggle
    CreateToggle(Container, "Auto Chop Tree", function(enabled)
        ActiveAutoChopTree = enabled
        showNotification("Auto Chop Tree " .. (enabled and "ENABLED" or "DISABLED"))
    end, ActiveAutoChopTree)

    -- Auto Chop Distance Slider
    CreateSlider(Container, "Auto Chop Distance", 10, 50, DistanceForAutoChopTree, function(value)
        DistanceForAutoChopTree = value
    end)

    -- Bring Items Section
    local BringSection = Instance.new("TextLabel")
    BringSection.Size = UDim2.new(1, 0, 0, 30)
    BringSection.BackgroundTransparency = 1
    BringSection.Text = "Bring Items"
    BringSection.TextColor3 = Color3.fromRGB(170, 0, 170)
    BringSection.TextSize = 16
    BringSection.Font = Enum.Font.GothamBold
    BringSection.TextXAlignment = Enum.TextXAlignment.Left
    BringSection.Parent = Container

    -- Bring Target Selection
    local targetFrame = Instance.new("Frame")
    targetFrame.Size = UDim2.new(1, 0, 0, 45)
    targetFrame.BackgroundColor3 = Color3.fromRGB(30, 0, 30)
    targetFrame.BackgroundTransparency = 0.1
    targetFrame.BorderSizePixel = 0
    targetFrame.ZIndex = 2
    targetFrame.Parent = Container
    
    local targetCorner = Instance.new("UICorner")
    targetCorner.CornerRadius = UDim.new(0, 8)
    targetCorner.Parent = targetFrame
    
    local targetStroke = Instance.new("UIStroke")
    targetStroke.Color = Color3.fromRGB(80, 0, 80)
    targetStroke.Thickness = 1
    targetStroke.Parent = targetFrame
    
    local targetLabel = Instance.new("TextLabel")
    targetLabel.Size = UDim2.new(0.6, 0, 1, 0)
    targetLabel.Position = UDim2.new(0, 15, 0, 0)
    targetLabel.BackgroundTransparency = 1
    targetLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    targetLabel.Text = "Bring Target"
    targetLabel.Font = Enum.Font.GothamSemibold
    targetLabel.TextSize = 14
    targetLabel.TextXAlignment = Enum.TextXAlignment.Left
    targetLabel.ZIndex = 3
    targetLabel.Parent = targetFrame
    
    local targetButton = Instance.new("TextButton")
    targetButton.Size = UDim2.new(0.3, 0, 0, 30)
    targetButton.Position = UDim2.new(0.65, 0, 0.15, 0)
    targetButton.BackgroundColor3 = Color3.fromRGB(60, 0, 60)
    targetButton.BackgroundTransparency = 0.1
    targetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    targetButton.Text = BringTarget
    targetButton.Font = Enum.Font.GothamBold
    targetButton.TextSize = 12
    targetButton.ZIndex = 3
    targetButton.Parent = targetFrame
    
    local targetButtonCorner = Instance.new("UICorner")
    targetButtonCorner.CornerRadius = UDim.new(0, 6)
    targetButtonCorner.Parent = targetButton
    
    local targetButtonStroke = Instance.new("UIStroke")
    targetButtonStroke.Color = Color3.fromRGB(100, 0, 100)
    targetButtonStroke.Thickness = 1
    targetButtonStroke.Parent = targetButton
    
    targetButton.MouseButton1Click:Connect(function()
        playClickSound()
        BringTarget = BringTarget == "Campfire" and "Player" or "Campfire"
        targetButton.Text = BringTarget
        SaveSettings()
    end)

    -- Bring Items Count Slider
    CreateSlider(Container, "Bring Count", 1, 20, BringCount, function(value)
        BringCount = value
    end)

    -- Bring Items Delay Slider
    CreateSlider(Container, "Bring Delay (ms)", 0, 1000, BringDelay, function(value)
        BringDelay = value
    end)

    -- Bring Items Buttons
    local function createBringButton(text, itemName)
        CreateButton(Container, "Bring " .. text, function()
            BringItems(itemName)
        end)
    end

    createBringButton("Wood", "Wood")
    createBringButton("Stone", "Stone")
    createBringButton("Metal", "Metal")
    createBringButton("Berries", "Berries")
    createBringButton("Food", "Food")
    createBringButton("All Items", "Item")

    -- Сохраняем позицию при перетаскивании
    menu.DragStopped:Connect(function()
        savedPosition = menu.Position
    end)

    return menu
end

-- Функция создания меню More
local function createMoreMenu()
    local menu = Instance.new("Frame")
    menu.Name = "MoreMenu"
    menu.Size = UDim2.new(0, 300, 0, 200)
    menu.Position = savedPosition
    menu.BackgroundColor3 = Color3.fromRGB(20, 0, 20)
    menu.BackgroundTransparency = 0.1
    menu.BorderSizePixel = 0
    menu.Active = true
    menu.Draggable = true
    menu.Visible = isGuiOpen
    menu.Parent = ScreenGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = menu

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(170, 0, 170)
    Stroke.Thickness = 2
    Stroke.Parent = menu

    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.Size = UDim2.new(1, 20, 1, 20)
    Shadow.Position = UDim2.new(0, -10, 0, -10)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://5554236805"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.8
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    Shadow.ZIndex = -1
    Shadow.Parent = menu

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundTransparency = 1
    Title.Text = "MORE"
    Title.TextColor3 = Color3.fromRGB(170, 0, 170)
    Title.TextSize = 20
    Title.Font = Enum.Font.GothamBold
    Title.Parent = menu

    local BackButton = Instance.new("TextButton")
    BackButton.Name = "BackButton"
    BackButton.Size = UDim2.new(0, 60, 0, 30)
    BackButton.Position = UDim2.new(0, 10, 0, 5)
    BackButton.BackgroundColor3 = Color3.fromRGB(30, 0, 30)
    BackButton.BackgroundTransparency = 0.1
    BackButton.Text = "← Back"
    BackButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    BackButton.TextSize = 12
    BackButton.Font = Enum.Font.GothamSemibold
    BackButton.Parent = menu

    local BackCorner = Instance.new("UICorner")
    BackCorner.CornerRadius = UDim.new(0, 6)
    BackCorner.Parent = BackButton

    local BackStroke = Instance.new("UIStroke")
    BackStroke.Color = Color3.fromRGB(80, 0, 80)
    BackStroke.Thickness = 1
    BackStroke.Parent = BackButton

    BackButton.MouseButton1Click:Connect(function()
        playClickSound()
        menu.Visible = false
        MainMenu.Visible = true
        currentActiveMenu = MainMenu
    end)

    local ScrollFrame = Instance.new("ScrollingFrame")
    ScrollFrame.Name = "ScrollFrame"
    ScrollFrame.Size = UDim2.new(1, -20, 1, -60)
    ScrollFrame.Position = UDim2.new(0, 10, 0, 50)
    ScrollFrame.BackgroundTransparency = 1
    ScrollFrame.BorderSizePixel = 0
    ScrollFrame.ScrollBarThickness = 6
    ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(170, 0, 170)
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ScrollFrame.Parent = menu

    local Container = Instance.new("Frame")
    Container.Name = "Container"
    Container.Size = UDim2.new(1, 0, 0, 0)
    Container.BackgroundTransparency = 1
    Container.Parent = ScrollFrame

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 8)
    UIListLayout.FillDirection = Enum.FillDirection.Vertical
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = Container

    -- Anti AFK Toggle
    CreateToggle(Container, "Anti AFK", function(enabled)
        antiAFKEnabled = enabled
        if enabled then
            EnableAntiAFK()
            showNotification("Anti AFK ENABLED")
        else
            DisableAntiAFK()
            showNotification("Anti AFK DISABLED")
        end
    end, antiAFKEnabled)

    -- Destroy GUI Button
    CreateButton(Container, "Destroy GUI", function()
        if ScreenGui then
            ScreenGui:Destroy()
            ScreenGui = nil
        end
    end)

    -- Сохраняем позицию при перетаскивании
    menu.DragStopped:Connect(function()
        savedPosition = menu.Position
    end)

    return menu
end

-- Инициализация GUI
local function initGUI()
    if ScreenGui then
        ScreenGui:Destroy()
    end

    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "AstralCheatMobile"
    ScreenGui.Parent = player.PlayerGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

    -- Создаем кнопку открытия/закрытия
    createOpenCloseButton()
    
    -- Создаем главное меню
    createMainMenu()
    
    currentActiveMenu = MainMenu
end

-- Инициализация
if player then
    initGUI()
    showNotification("Astral Cheat Mobile Loaded!")
    
    -- Обработчик изменения персонажа
    player.CharacterAdded:Connect(function()
        if speedHackEnabled then
            wait(1)
            local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = currentSpeed
            end
        end
    end)
end