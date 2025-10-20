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

-- Настройки файла
local SETTINGS_FILE = "astralcheat_settings.txt"
local Settings = {
    ActiveKillAura = false,
    ActiveAutoChopTree = false,
    DistanceForKillAura = 25,
    DistanceForAutoChopTree = 25,
    BringCount = 5,
    BringDelay = 200
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

-- Функции сохранения настроек
local function SaveSettings()
    pcall(function()
        Settings.ActiveKillAura = ActiveKillAura
        Settings.ActiveAutoChopTree = ActiveAutoChopTree
        Settings.DistanceForKillAura = DistanceForKillAura
        Settings.DistanceForAutoChopTree = DistanceForAutoChopTree
        Settings.BringCount = BringCount
        Settings.BringDelay = BringDelay
        
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
        end
    end)
end

-- Загружаем настройки при запуске
LoadSettings()

-- Функции для UI элементов
local function CreateToggle(parent, text, callback, isActive)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, 0, 0, 35)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
    toggleFrame.BackgroundTransparency = 0.3
    toggleFrame.BorderSizePixel = 0
    toggleFrame.ZIndex = 2
    toggleFrame.Parent = parent
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = toggleFrame
    
    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Name = "ToggleLabel"
    toggleLabel.Size = UDim2.new(0.6, 0, 1, 0)
    toggleLabel.Position = UDim2.new(0, 10, 0, 0)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleLabel.Text = text
    toggleLabel.Font = Enum.Font.Gotham
    toggleLabel.TextSize = 14
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    toggleLabel.ZIndex = 3
    toggleLabel.Parent = toggleFrame
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0.3, 0, 0, 25)
    toggleButton.Position = UDim2.new(0.7, 0, 0.14, 0)
    toggleButton.BackgroundColor3 = isActive and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(100, 0, 0)
    toggleButton.BackgroundTransparency = 0.2
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.Text = isActive and "ON" or "OFF"
    toggleButton.Font = Enum.Font.Gotham
    toggleButton.TextSize = 12
    toggleButton.ZIndex = 3
    toggleButton.Parent = toggleFrame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 4)
    toggleCorner.Parent = toggleButton
    
    toggleButton.MouseButton1Click:Connect(function()
        isActive = not isActive
        toggleButton.BackgroundColor3 = isActive and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(100, 0, 0)
        toggleButton.Text = isActive and "ON" or "OFF"
        callback(isActive)
        SaveSettings()
    end)
    
    return {
        Set = function(value)
            isActive = value
            toggleButton.BackgroundColor3 = isActive and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(100, 0, 0)
            toggleButton.Text = isActive and "ON" or "OFF"
        end
    }
end

local function CreateSlider(parent, text, min, max, default, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, 0, 0, 50)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
    sliderFrame.BackgroundTransparency = 0.3
    sliderFrame.BorderSizePixel = 0
    sliderFrame.ZIndex = 2
    sliderFrame.Parent = parent
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 6)
    sliderCorner.Parent = sliderFrame
    
    local sliderText = Instance.new("TextLabel")
    sliderText.Size = UDim2.new(1, 0, 0, 20)
    sliderText.BackgroundTransparency = 1
    sliderText.Text = text .. ": " .. default
    sliderText.TextColor3 = Color3.fromRGB(255, 255, 255)
    sliderText.TextSize = 12
    sliderText.TextXAlignment = Enum.TextXAlignment.Left
    sliderText.Position = UDim2.new(0, 10, 0, 5)
    sliderText.Font = Enum.Font.Gotham
    sliderText.ZIndex = 3
    sliderText.Parent = sliderFrame
    
    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new(1, -20, 0, 12)
    sliderBar.Position = UDim2.new(0, 10, 0, 30)
    sliderBar.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
    sliderBar.ZIndex = 3
    sliderBar.Parent = sliderFrame
    
    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0, 6)
    barCorner.Parent = sliderBar
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    sliderFill.ZIndex = 4
    sliderFill.Parent = sliderBar
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 6)
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
    button.Size = UDim2.new(1, 0, 0, 35)
    button.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
    button.BackgroundTransparency = 0.3
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 12
    button.Font = Enum.Font.Gotham
    button.ZIndex = 2
    button.Parent = parent
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = button
    
    button.MouseButton1Click:Connect(callback)
    
    return button
end

-- Функция создания FOV Circle
local function createFOVCircle()
    if fovCircle then
        fovCircle:Remove()
    end
    
    fovCircle = Drawing.new("Circle")
    fovCircle.Visible = false
    fovCircle.Color = Color3.fromRGB(255, 0, 0)
    fovCircle.Thickness = 1
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

-- Функция создания кнопки открытия/закрытия
local function createOpenCloseButton()
    if OpenCloseButton then
        OpenCloseButton:Destroy()
    end

    OpenCloseButton = Instance.new("TextButton")
    OpenCloseButton.Name = "OpenCloseButton"
    OpenCloseButton.Size = UDim2.new(0, 50, 0, 50)
    OpenCloseButton.Position = savedButtonPosition
    OpenCloseButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    OpenCloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    OpenCloseButton.Text = "≡"
    OpenCloseButton.Font = Enum.Font.GothamBold
    OpenCloseButton.TextSize = 20
    OpenCloseButton.ZIndex = 10
    OpenCloseButton.Active = true
    OpenCloseButton.Draggable = true
    OpenCloseButton.Parent = ScreenGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = OpenCloseButton

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(255, 255, 255)
    Stroke.Thickness = 2
    Stroke.Parent = OpenCloseButton

    -- Обработчик нажатия
    OpenCloseButton.MouseButton1Click:Connect(function()
        isGuiOpen = not isGuiOpen
        
        -- Закрываем/открываем текущее активное меню
        if currentActiveMenu then
            currentActiveMenu.Visible = isGuiOpen
        end
        
        if isGuiOpen then
            OpenCloseButton.Text = "≡"
            OpenCloseButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        else
            OpenCloseButton.Text = "≡"
            OpenCloseButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
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
        button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        button.Text = "ON"
    else
        button.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
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
                    espObjects[otherPlayer].tracer.Color = Color3.fromRGB(255, 0, 0)
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
                    espObjects[otherPlayer].box.Color = Color3.fromRGB(255, 0, 0)
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
                    espObjects[otherPlayer].health.Color = Color3.fromRGB(255, 0, 0)
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
                    espObjects[otherPlayer].distance.Color = Color3.fromRGB(255, 0, 0)
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

-- Bring Items функция
local function BringItems(itemName)
    local targetPos = CampfirePosition
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

-- Функция создания главного меню выбора
local function createMainMenu()
    MainMenu = Instance.new("Frame")
    MainMenu.Name = "MainMenu"
    MainMenu.Size = UDim2.new(0, 250, 0, 120)
    MainMenu.Position = savedPosition
    MainMenu.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
    MainMenu.BackgroundTransparency = 0.3
    MainMenu.BorderSizePixel = 0
    MainMenu.Active = true
    MainMenu.Draggable = true
    MainMenu.Visible = isGuiOpen
    MainMenu.Parent = ScreenGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = MainMenu

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.Position = UDim2.new(0, 0, 0, 0)
    Title.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
    Title.BackgroundTransparency = 0.2
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Text = "SELECT GAME"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.ZIndex = 2
    Title.Parent = MainMenu

    local GunButton = CreateButton(MainMenu, "GUNGAME", function()
        MainMenu.Visible = false
        GunMenu.Visible = true
        currentActiveMenu = GunMenu
    end)
    GunButton.Position = UDim2.new(0, 10, 0, 40)
    GunButton.Size = UDim2.new(1, -20, 0, 30)

    local NightsButton = CreateButton(MainMenu, "99 NIGHTS", function()
        MainMenu.Visible = false
        NightsMenu.Visible = true
        currentActiveMenu = NightsMenu
    end)
    NightsButton.Position = UDim2.new(0, 10, 0, 80)
    NightsButton.Size = UDim2.new(1, -20, 0, 30)
    
    currentActiveMenu = MainMenu
end

-- Функция создания Gun Menu
local function createGunMenu()
    GunMenu = Instance.new("Frame")
    GunMenu.Name = "GunMenu"
    GunMenu.Size = UDim2.new(0, 250, 0, 220)
    GunMenu.Position = savedPosition
    GunMenu.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
    GunMenu.BackgroundTransparency = 0.3
    GunMenu.BorderSizePixel = 0
    GunMenu.Active = true
    GunMenu.Draggable = true
    GunMenu.Visible = false
    GunMenu.Parent = ScreenGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = GunMenu

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.Position = UDim2.new(0, 0, 0, 0)
    Title.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
    Title.BackgroundTransparency = 0.2
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Text = "GUNGAME MENU"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.ZIndex = 2
    Title.Parent = GunMenu

    -- Вертикальные вкладки
    local TabButtons = Instance.new("Frame")
    TabButtons.Name = "TabButtons"
    TabButtons.Size = UDim2.new(0, 80, 1, -30)
    TabButtons.Position = UDim2.new(0, 0, 0, 30)
    TabButtons.BackgroundTransparency = 0.2
    TabButtons.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
    TabButtons.ZIndex = 2
    TabButtons.Parent = GunMenu

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Parent = TabButtons

    local gunTabs = {
        {name = "Movement", defaultActive = true},
        {name = "Visual", defaultActive = false},
        {name = "AimBot", defaultActive = false}
    }

    local gunTabButtons = {}
    local gunTabContents = {}

    for i, tab in ipairs(gunTabs) do
        local tabButton = Instance.new("TextButton")
        tabButton.Name = tab.name .. "Tab"
        tabButton.Size = UDim2.new(1, 0, 0, 35)
        tabButton.LayoutOrder = i
        tabButton.BackgroundColor3 = tab.defaultActive and Color3.fromRGB(120, 0, 0) or Color3.fromRGB(80, 0, 0)
        tabButton.BackgroundTransparency = 0.2
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabButton.Text = tab.name
        tabButton.Font = Enum.Font.Gotham
        tabButton.TextSize = 12
        tabButton.ZIndex = 3
        tabButton.Parent = TabButtons

        local ContentFrame = Instance.new("ScrollingFrame")
        ContentFrame.Name = tab.name .. "Content"
        ContentFrame.Size = UDim2.new(1, -90, 1, -40)
        ContentFrame.Position = UDim2.new(0, 90, 0, 40)
        ContentFrame.BackgroundTransparency = 1
        ContentFrame.ScrollBarThickness = 4
        ContentFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 0)
        ContentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        ContentFrame.VerticalScrollBarInset = Enum.ScrollBarInset.Always
        ContentFrame.Visible = tab.defaultActive
        ContentFrame.ZIndex = 2
        ContentFrame.Parent = GunMenu

        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentLayout.Padding = UDim.new(0, 8)
        ContentLayout.Parent = ContentFrame

        gunTabButtons[tab.name] = tabButton
        gunTabContents[tab.name] = ContentFrame
    end

    -- Movement Tab Content
    local SpeedHackFrame = Instance.new("Frame")
    SpeedHackFrame.Name = "SpeedHackFrame"
    SpeedHackFrame.Size = UDim2.new(1, 0, 0, 70)
    SpeedHackFrame.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
    SpeedHackFrame.BackgroundTransparency = 0.3
    SpeedHackFrame.BorderSizePixel = 0
    SpeedHackFrame.ZIndex = 2
    SpeedHackFrame.LayoutOrder = 1
    SpeedHackFrame.Parent = gunTabContents["Movement"]

    local SpeedHackCorner = Instance.new("UICorner")
    SpeedHackCorner.CornerRadius = UDim.new(0, 6)
    SpeedHackCorner.Parent = SpeedHackFrame

    local SpeedHackLabel = Instance.new("TextLabel")
    SpeedHackLabel.Name = "SpeedHackLabel"
    SpeedHackLabel.Size = UDim2.new(0.6, 0, 0, 25)
    SpeedHackLabel.Position = UDim2.new(0, 10, 0, 5)
    SpeedHackLabel.BackgroundTransparency = 1
    SpeedHackLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SpeedHackLabel.Text = "Speed Hack"
    SpeedHackLabel.Font = Enum.Font.Gotham
    SpeedHackLabel.TextSize = 12
    SpeedHackLabel.TextXAlignment = Enum.TextXAlignment.Left
    SpeedHackLabel.ZIndex = 3
    SpeedHackLabel.Parent = SpeedHackFrame

    local SpeedHackToggle = Instance.new("TextButton")
    SpeedHackToggle.Name = "SpeedHackToggle"
    SpeedHackToggle.Size = UDim2.new(0.3, 0, 0, 25)
    SpeedHackToggle.Position = UDim2.new(0.7, 0, 0, 5)
    SpeedHackToggle.BackgroundColor3 = speedHackEnabled and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(100, 0, 0)
    SpeedHackToggle.BackgroundTransparency = 0.2
    SpeedHackToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    SpeedHackToggle.Text = speedHackEnabled and "ON" or "OFF"
    SpeedHackToggle.Font = Enum.Font.Gotham
    SpeedHackToggle.TextSize = 10
    SpeedHackToggle.ZIndex = 3
    SpeedHackToggle.Parent = SpeedHackFrame

    local SpeedHackSlider = Instance.new("Frame")
    SpeedHackSlider.Name = "SpeedHackSlider"
    SpeedHackSlider.Size = UDim2.new(1, -20, 0, 25)
    SpeedHackSlider.Position = UDim2.new(0, 10, 0, 35)
    SpeedHackSlider.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
    SpeedHackSlider.BackgroundTransparency = 0.3
    SpeedHackSlider.BorderSizePixel = 0
    SpeedHackSlider.Visible = speedHackEnabled
    SpeedHackSlider.ZIndex = 3
    SpeedHackSlider.Parent = SpeedHackFrame

    local SpeedHackSliderCorner = Instance.new("UICorner")
    SpeedHackSliderCorner.CornerRadius = UDim.new(0, 4)
    SpeedHackSliderCorner.Parent = SpeedHackSlider

    local SpeedValue = Instance.new("TextLabel")
    SpeedValue.Name = "SpeedValue"
    SpeedValue.Size = UDim2.new(1, 0, 1, 0)
    SpeedValue.BackgroundTransparency = 1
    SpeedValue.TextColor3 = Color3.fromRGB(255, 255, 255)
    SpeedValue.Text = "Speed: " .. currentSpeed
    SpeedValue.Font = Enum.Font.Gotham
    SpeedValue.TextSize = 10
    SpeedValue.ZIndex = 4
    SpeedValue.Parent = SpeedHackSlider

    -- Jump Hack
    local JumpHackToggle = CreateToggle(gunTabContents["Movement"], "Jump Hack", function(v)
        jumpHackEnabled = v
    end, jumpHackEnabled)

    -- NoClip
    local NoClipToggle = CreateToggle(gunTabContents["Movement"], "NoClip", function(v)
        noclipEnabled = v
        
        if noclipEnabled then
            if noclipConnection then
                noclipConnection:Disconnect()
            end
            noclipConnection = RunService.Stepped:Connect(function()
                if player.Character then
                    for _, part in pairs(player.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end
            
            if player.Character then
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end, noclipEnabled)

    -- Visual Tab Content
    local ESPTracersToggle = CreateToggle(gunTabContents["Visual"], "ESP Tracers", function(v)
        espTracersEnabled = v
    end, espTracersEnabled)

    local ESPBoxToggle = CreateToggle(gunTabContents["Visual"], "ESP Box", function(v)
        espBoxEnabled = v
    end, espBoxEnabled)

    local ESPHealthToggle = CreateToggle(gunTabContents["Visual"], "ESP Health", function(v)
        espHealthEnabled = v
    end, espHealthEnabled)

    local ESPDistanceToggle = CreateToggle(gunTabContents["Visual"], "ESP Distance", function(v)
        espDistanceEnabled = v
    end, espDistanceEnabled)

    local ESPCountToggle = CreateToggle(gunTabContents["Visual"], "ESP Count", function(v)
        espCountEnabled = v
        
        if espCountEnabled then
            if not espCountText then
                espCountText = Drawing.new("Text")
                espCountText.Size = 16
                espCountText.Center = true
                espCountText.Outline = true
                espCountText.Color = Color3.fromRGB(255, 0, 0)
                espCountText.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, 80)
            end
            espCountText.Visible = true
        else
            if espCountText then
                espCountText.Visible = false
            end
        end
    end, espCountEnabled)

    -- AimBot Tab Content
    local AimBotToggle = CreateToggle(gunTabContents["AimBot"], "AimBot", function(v)
        aimBotEnabled = v
        
        if fovCircle then
            fovCircle.Visible = aimBotEnabled
        else
            createFOVCircle()
            fovCircle.Visible = aimBotEnabled
        end
    end, aimBotEnabled)

    CreateSlider(gunTabContents["AimBot"], "AimBot FOV", 10, 200, aimBotFOV, function(v)
        aimBotFOV = math.floor(v)
        updateFOVCircle()
    end)

    -- Обработчики для Gun Menu
    SpeedHackToggle.MouseButton1Click:Connect(function()
        speedHackEnabled = not speedHackEnabled
        toggleButton(SpeedHackToggle, speedHackEnabled)
        SpeedHackSlider.Visible = speedHackEnabled
        
        if speedHackEnabled then
            local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = currentSpeed
            end
        else
            local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 16
            end
        end
    end)

    local speedSliderConnection
    SpeedHackSlider.InputBegan:Connect(function()
        speedSliderConnection = RunService.Heartbeat:Connect(function()
            local mouseLocation = UserInputService:GetMouseLocation()
            local relativeX = math.clamp((mouseLocation.X - SpeedHackSlider.AbsolutePosition.X) / SpeedHackSlider.AbsoluteSize.X, 0, 1)
            currentSpeed = math.floor(16 + (relativeX * 84))
            SpeedValue.Text = "Speed: " .. currentSpeed
            
            if speedHackEnabled then
                local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = currentSpeed
                end
            end
        end)
    end)

    SpeedHackSlider.InputEnded:Connect(function()
        if speedSliderConnection then
            speedSliderConnection:Disconnect()
            speedSliderConnection = nil
        end
    end)

    UserInputService.JumpRequest:Connect(function()
        if jumpHackEnabled and player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)

    -- Tab Switching для Gun Menu
    for tabName, tabButton in pairs(gunTabButtons) do
        tabButton.MouseButton1Click:Connect(function()
            for contentName, contentFrame in pairs(gunTabContents) do
                contentFrame.Visible = (contentName == tabName)
            end
            
            for btnName, btn in pairs(gunTabButtons) do
                btn.BackgroundColor3 = (btnName == tabName) and Color3.fromRGB(120, 0, 0) or Color3.fromRGB(80, 0, 0)
            end
        end)
    end

    -- Initialize ESP for existing players
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        createESP(otherPlayer)
    end

    Players.PlayerAdded:Connect(function(newPlayer)
        createESP(newPlayer)
    end)

    Players.PlayerRemoving:Connect(function(leftPlayer)
        cleanupESP(leftPlayer)
    end)

    RunService.Heartbeat:Connect(updateESPCount)

    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        if espCountText then
            espCountText.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, 80)
        end
    end)

    RunService.Heartbeat:Connect(function()
        if aimBotEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local closestPlayer = nil
            local closestDistance = 1000
            
            for _, otherPlayer in pairs(Players:GetPlayers()) do
                if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") and otherPlayer.Character:FindFirstChild("Humanoid") and otherPlayer.Character.Humanoid.Health > 0 then
                    local targetRoot = otherPlayer.Character.HumanoidRootPart
                    local distance = (player.Character.HumanoidRootPart.Position - targetRoot.Position).Magnitude
                    
                    if isInFOV(targetRoot.Position) and isPlayerVisible(otherPlayer) then
                        if distance < closestDistance then
                            closestDistance = distance
                            closestPlayer = otherPlayer
                        end
                    end
                end
            end
            
            if closestPlayer then
                workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, closestPlayer.Character.HumanoidRootPart.Position)
            end
        end
    end)
end

-- Функция создания Nights Menu
local function createNightsMenu()
    NightsMenu = Instance.new("Frame")
    NightsMenu.Name = "NightsMenu"
    NightsMenu.Size = UDim2.new(0, 250, 0, 220)
    NightsMenu.Position = savedPosition
    NightsMenu.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
    NightsMenu.BackgroundTransparency = 0.3
    NightsMenu.BorderSizePixel = 0
    NightsMenu.Active = true
    NightsMenu.Draggable = true
    NightsMenu.Visible = false
    NightsMenu.Parent = ScreenGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = NightsMenu

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.Position = UDim2.new(0, 0, 0, 0)
    Title.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
    Title.BackgroundTransparency = 0.2
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Text = "99 NIGHTS MENU"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.ZIndex = 2
    Title.Parent = NightsMenu

    -- Вертикальные вкладки
    local TabButtons = Instance.new("Frame")
    TabButtons.Name = "TabButtons"
    TabButtons.Size = UDim2.new(0, 80, 1, -30)
    TabButtons.Position = UDim2.new(0, 0, 0, 30)
    TabButtons.BackgroundTransparency = 0.2
    TabButtons.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
    TabButtons.ZIndex = 2
    TabButtons.Parent = NightsMenu

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Parent = TabButtons

    local nightsTabs = {
        {name = "Main", defaultActive = true},
        {name = "Bring", defaultActive = false}
    }

    local nightsTabButtons = {}
    local nightsTabContents = {}

    for i, tab in ipairs(nightsTabs) do
        local tabButton = Instance.new("TextButton")
        tabButton.Name = tab.name .. "Tab"
        tabButton.Size = UDim2.new(1, 0, 0, 35)
        tabButton.LayoutOrder = i
        tabButton.BackgroundColor3 = tab.defaultActive and Color3.fromRGB(120, 0, 0) or Color3.fromRGB(80, 0, 0)
        tabButton.BackgroundTransparency = 0.2
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabButton.Text = tab.name
        tabButton.Font = Enum.Font.Gotham
        tabButton.TextSize = 12
        tabButton.ZIndex = 3
        tabButton.Parent = TabButtons

        local ContentFrame = Instance.new("ScrollingFrame")
        ContentFrame.Name = tab.name .. "Content"
        ContentFrame.Size = UDim2.new(1, -90, 1, -40)
        ContentFrame.Position = UDim2.new(0, 90, 0, 40)
        ContentFrame.BackgroundTransparency = 1
        ContentFrame.ScrollBarThickness = 4
        ContentFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 0)
        ContentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        ContentFrame.VerticalScrollBarInset = Enum.ScrollBarInset.Always
        ContentFrame.Visible = tab.defaultActive
        ContentFrame.ZIndex = 2
        ContentFrame.Parent = NightsMenu

        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentLayout.Padding = UDim.new(0, 8)
        ContentLayout.Parent = ContentFrame

        nightsTabButtons[tab.name] = tabButton
        nightsTabContents[tab.name] = ContentFrame
    end

    -- Main Tab Content
    local KillAuraToggle = CreateToggle(nightsTabContents["Main"], "Kill Aura", function(v)
        ActiveKillAura = v
    end, ActiveKillAura)

    CreateSlider(nightsTabContents["Main"], "Kill Distance", 10, 150, DistanceForKillAura, function(v)
        DistanceForKillAura = v
    end)

    local AutoChopToggle = CreateToggle(nightsTabContents["Main"], "Auto Chop", function(v)
        ActiveAutoChopTree = v
    end, ActiveAutoChopTree)

    CreateSlider(nightsTabContents["Main"], "Chop Distance", 10, 150, DistanceForAutoChopTree, function(v)
        DistanceForAutoChopTree = v
    end)

    -- Bring Tab Content
    CreateSlider(nightsTabContents["Bring"], "Bring Count", 1, 20, BringCount, function(v)
        BringCount = math.floor(v)
    end)

    CreateSlider(nightsTabContents["Bring"], "Bring Speed", 50, 500, BringDelay, function(v)
        BringDelay = math.floor(v)
    end)

    CreateButton(nightsTabContents["Bring"], "Teleport to Campfire", function()
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(CampfirePosition)
        end
    end)

    -- Переменные для отслеживания открытых подменю
    local openSubMenus = {}

    -- Функция для обновления позиций всех элементов
    local function updateAllPositions()
        wait(0.1) -- Ждем обновления размеров
        
        local currentY = 0
        local padding = 8
        
        for _, child in pairs(nightsTabContents["Bring"]:GetChildren()) do
            if child:IsA("Frame") or child:IsA("TextButton") then
                child.Position = UDim2.new(0, 0, 0, currentY)
                
                -- Если это подменю и оно открыто, добавляем его высоту + дополнительный отступ
                if child.Name:find("SubMenu") and openSubMenus[child.Name] then
                    currentY = currentY + child.AbsoluteSize.Y + padding + 10 -- Дополнительный отступ
                else
                    currentY = currentY + child.AbsoluteSize.Y + padding
                end
            end
        end
    end

    -- Подменю для ресурсов
    local ResourcesButton = CreateButton(nightsTabContents["Bring"], "Resources", function()
        for _, child in pairs(nightsTabContents["Bring"]:GetChildren()) do
            if child.Name == "ResourcesSubMenu" then
                openSubMenus["ResourcesSubMenu"] = not openSubMenus["ResourcesSubMenu"]
                child.Visible = openSubMenus["ResourcesSubMenu"]
                updateAllPositions()
                return
            end
        end
    end)

    local ResourcesSubMenu = Instance.new("Frame")
    ResourcesSubMenu.Name = "ResourcesSubMenu"
    ResourcesSubMenu.Size = UDim2.new(1, 0, 0, 180)
    ResourcesSubMenu.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
    ResourcesSubMenu.BackgroundTransparency = 0.5
    ResourcesSubMenu.Visible = false
    ResourcesSubMenu.Parent = nightsTabContents["Bring"]

    local ResourcesLayout = Instance.new("UIListLayout")
    ResourcesLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ResourcesLayout.Padding = UDim.new(0, 6)
    ResourcesLayout.Parent = ResourcesSubMenu

    local resourcesItems = {"Logs", "Coal", "Chair", "Fuel Canister", "Oil Barrel"}
    for _, itemName in pairs(resourcesItems) do
        CreateButton(ResourcesSubMenu, "Bring " .. itemName, function()
            BringItems(itemName)
        end)
    end

    -- Подменю для металлов
    local MetalsButton = CreateButton(nightsTabContents["Bring"], "Metals", function()
        for _, child in pairs(nightsTabContents["Bring"]:GetChildren()) do
            if child.Name == "MetalsSubMenu" then
                openSubMenus["MetalsSubMenu"] = not openSubMenus["MetalsSubMenu"]
                child.Visible = openSubMenus["MetalsSubMenu"]
                updateAllPositions()
                return
            end
        end
    end)

    local MetalsSubMenu = Instance.new("Frame")
    MetalsSubMenu.Name = "MetalsSubMenu"
    MetalsSubMenu.Size = UDim2.new(1, 0, 0, 210)
    MetalsSubMenu.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
    MetalsSubMenu.BackgroundTransparency = 0.5
    MetalsSubMenu.Visible = false
    MetalsSubMenu.Parent = nightsTabContents["Bring"]

    local MetalsLayout = Instance.new("UIListLayout")
    MetalsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    MetalsLayout.Padding = UDim.new(0, 6)
    MetalsLayout.Parent = MetalsSubMenu

    local metalsItems = {"Bolt", "Sheet Metal", "Old Radio", "Scrap Metal", "UFO Scrap", "Broken Microwave"}
    for _, itemName in pairs(metalsItems) do
        CreateButton(MetalsSubMenu, "Bring " .. itemName, function()
            BringItems(itemName)
        end)
    end

    -- Подменю для еды и медицины
    local FoodMedButton = CreateButton(nightsTabContents["Bring"], "Food & Medical", function()
        for _, child in pairs(nightsTabContents["Bring"]:GetChildren()) do
            if child.Name == "FoodMedSubMenu" then
                openSubMenus["FoodMedSubMenu"] = not openSubMenus["FoodMedSubMenu"]
                child.Visible = openSubMenus["FoodMedSubMenu"]
                updateAllPositions()
                return
            end
        end
    end)

    local FoodMedSubMenu = Instance.new("Frame")
    FoodMedSubMenu.Name = "FoodMedSubMenu"
    FoodMedSubMenu.Size = UDim2.new(1, 0, 0, 180)
    FoodMedSubMenu.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
    FoodMedSubMenu.BackgroundTransparency = 0.5
    FoodMedSubMenu.Visible = false
    FoodMedSubMenu.Parent = nightsTabContents["Bring"]

    local FoodMedLayout = Instance.new("UIListLayout")
    FoodMedLayout.SortOrder = Enum.SortOrder.LayoutOrder
    FoodMedLayout.Padding = UDim.new(0, 6)
    FoodMedLayout.Parent = FoodMedSubMenu

    local foodMedItems = {"Carrot", "Pumpkin", "Morsel", "Steak", "MedKit", "Bandage"}
    for _, itemName in pairs(foodMedItems) do
        CreateButton(FoodMedSubMenu, "Bring " .. itemName, function()
            BringItems(itemName)
        end)
    end

    -- Подменю для оружия
    local WeaponsButton = CreateButton(nightsTabContents["Bring"], "Weapons", function()
        for _, child in pairs(nightsTabContents["Bring"]:GetChildren()) do
            if child.Name == "WeaponsSubMenu" then
                openSubMenus["WeaponsSubMenu"] = not openSubMenus["WeaponsSubMenu"]
                child.Visible = openSubMenus["WeaponsSubMenu"]
                updateAllPositions()
                return
            end
        end
    end)

    local WeaponsSubMenu = Instance.new("Frame")
    WeaponsSubMenu.Name = "WeaponsSubMenu"
    WeaponsSubMenu.Size = UDim2.new(1, 0, 0, 140)
    WeaponsSubMenu.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
    WeaponsSubMenu.BackgroundTransparency = 0.5
    WeaponsSubMenu.Visible = false
    WeaponsSubMenu.Parent = nightsTabContents["Bring"]

    local WeaponsLayout = Instance.new("UIListLayout")
    WeaponsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    WeaponsLayout.Padding = UDim.new(0, 6)
    WeaponsLayout.Parent = WeaponsSubMenu

    local weaponsItems = {"Rifle", "Rifle Ammo", "Revolver", "Revolver Ammo"}
    for _, itemName in pairs(weaponsItems) do
        CreateButton(WeaponsSubMenu, "Bring " .. itemName, function()
            BringItems(itemName)
        end)
    end

    -- Подменю для топоров
    local AxeButton = CreateButton(nightsTabContents["Bring"], "Axe", function()
        for _, child in pairs(nightsTabContents["Bring"]:GetChildren()) do
            if child.Name == "AxeSubMenu" then
                openSubMenus["AxeSubMenu"] = not openSubMenus["AxeSubMenu"]
                child.Visible = openSubMenus["AxeSubMenu"]
                updateAllPositions()
                return
            end
        end
    end)

    local AxeSubMenu = Instance.new("Frame")
    AxeSubMenu.Name = "AxeSubMenu"
    AxeSubMenu.Size = UDim2.new(1, 0, 0, 105)
    AxeSubMenu.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
    AxeSubMenu.BackgroundTransparency = 0.5
    AxeSubMenu.Visible = false
    AxeSubMenu.Parent = nightsTabContents["Bring"]

    local AxeLayout = Instance.new("UIListLayout")
    AxeLayout.SortOrder = Enum.SortOrder.LayoutOrder
    AxeLayout.Padding = UDim.new(0, 6)
    AxeLayout.Parent = AxeSubMenu

    local axeItems = {"Good Axe", "Strong Axe", "Chainsaw"}
    for _, itemName in pairs(axeItems) do
        CreateButton(AxeSubMenu, "Bring " .. itemName, function()
            BringItems(itemName)
        end)
    end

    -- Инициализация таблицы открытых подменю
    openSubMenus["ResourcesSubMenu"] = false
    openSubMenus["MetalsSubMenu"] = false
    openSubMenus["FoodMedSubMenu"] = false
    openSubMenus["WeaponsSubMenu"] = false
    openSubMenus["AxeSubMenu"] = false

    -- Первоначальное обновление позиций
    updateAllPositions()

    -- Tab Switching для Nights Menu
    for tabName, tabButton in pairs(nightsTabButtons) do
        tabButton.MouseButton1Click:Connect(function()
            for contentName, contentFrame in pairs(nightsTabContents) do
                contentFrame.Visible = (contentName == tabName)
            end
            
            for btnName, btn in pairs(nightsTabButtons) do
                btn.BackgroundColor3 = (btnName == tabName) and Color3.fromRGB(120, 0, 0) or Color3.fromRGB(80, 0, 0)
            end
        end)
    end
end

-- Функция создания GUI
local function createGUI()
    if ScreenGui then
        savedPosition = currentActiveMenu and currentActiveMenu.Position or savedPosition
        ScreenGui:Destroy()
        ScreenGui = nil
        MainMenu = nil
        GunMenu = nil
        NightsMenu = nil
        OpenCloseButton = nil
    end

    -- Create GUI
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SANSTRO_GUI"
    ScreenGui.Parent = player.PlayerGui
    ScreenGui.ResetOnSpawn = false

    -- Создаем все меню
    createMainMenu()
    createGunMenu()
    createNightsMenu()
    
    -- Создаем кнопку открытия/закрытия
    createOpenCloseButton()
end

-- Создаем GUI при запуске
createGUI()
createFOVCircle()

-- Восстанавливаем GUI после смерти
player.CharacterAdded:Connect(function()
    wait(2)
    createGUI()
end)

-- Clean up when player leaves
game:GetService("CoreGui").ChildRemoved:Connect(function(child)
    if child == ScreenGui then
        if fovCircle then
            fovCircle:Remove()
            fovCircle = nil
        end
        if espCountText then
            espCountText:Remove()
            espCountText = nil
        end
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        for _, espData in pairs(espObjects) do
            if espData.tracer then espData.tracer:Remove() end
            if espData.box then espData.box:Remove() end
            if espData.health then espData.health:Remove() end
            if espData.distance then espData.distance:Remove() end
        end
        espObjects = {}
        for _, connection in pairs(espConnections) do
            connection:Disconnect()
        end
        espConnections = {}
    end
end)