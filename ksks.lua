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
local MainFrame = nil
local GunMenu = nil
local NightsMenu = nil
local minimized = false
local fovCircle = nil
local savedPosition = UDim2.new(0, 10, 0, 10)
local savedButtonPosition = UDim2.new(0, 10, 0, 10)
local isGuiOpen = false
local OpenCloseButton = nil
local currentMenu = "Gun" -- "Gun" или "Nights"

-- ESP объекты
local espObjects = {}
local espConnections = {}
local espCountText = nil
local noclipConnection = nil

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

-- Функции для UI элементов из второго скрипта
local function CreateToggle(parent, text, callback, isActive)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, 0, 0, 40)
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
    toggleButton.Size = UDim2.new(0.3, 0, 0, 30)
    toggleButton.Position = UDim2.new(0.7, 0, 0.125, 0)
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
    sliderFrame.Size = UDim2.new(1, 0, 0, 60)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
    sliderFrame.BackgroundTransparency = 0.3
    sliderFrame.BorderSizePixel = 0
    sliderFrame.ZIndex = 2
    sliderFrame.Parent = parent
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 6)
    sliderCorner.Parent = sliderFrame
    
    local sliderText = Instance.new("TextLabel")
    sliderText.Size = UDim2.new(1, 0, 0, 25)
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
    sliderBar.Position = UDim2.new(0, 10, 0, 35)
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
    
    local function onInputChanged(input)
        if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mouseLocation = UserInputService:GetMouseLocation()
            local relativeX = math.clamp((mouseLocation.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
            local value = min + relativeX * (max - min)
            updateSlider(value)
        end
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
    button.Size = UDim2.new(1, 0, 0, 40)
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
    OpenCloseButton.Size = UDim2.new(0, 60, 0, 60)
    OpenCloseButton.Position = savedButtonPosition
    OpenCloseButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    OpenCloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    OpenCloseButton.Text = "≡"
    OpenCloseButton.Font = Enum.Font.GothamBold
    OpenCloseButton.TextSize = 24
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
        MainFrame.Visible = isGuiOpen
        
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
        local weapon = player.Inventory:FindFirstChild("Old Axe") or player.Inventory:FindFirstChild("Good Axe") or player.Inventory:FindFirstChild("Strong Axe")
        
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
        local weapon = player.Inventory:FindFirstChild("Old Axe") or player.Inventory:FindFirstChild("Good Axe") or player.Inventory:FindFirstChild("Strong Axe")
        
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

-- Функция создания GUI
local function createGUI()
    if ScreenGui then
        savedPosition = MainFrame.Position
        ScreenGui:Destroy()
        ScreenGui = nil
        MainFrame = nil
        OpenCloseButton = nil
    end

    -- Create GUI
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SANSTRO_GUI"
    ScreenGui.Parent = player.PlayerGui
    ScreenGui.ResetOnSpawn = false

    MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 300, 0, 450)
    MainFrame.Position = savedPosition
    MainFrame.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
    MainFrame.BackgroundTransparency = 0.3
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Visible = isGuiOpen
    MainFrame.Parent = ScreenGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = MainFrame

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Position = UDim2.new(0, 0, 0, 0)
    Title.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
    Title.BackgroundTransparency = 0.2
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Text = "SANSTRO MENU"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.ZIndex = 2
    Title.Parent = MainFrame

    -- Кнопки выбора режима
    local ModeButtons = Instance.new("Frame")
    ModeButtons.Name = "ModeButtons"
    ModeButtons.Size = UDim2.new(1, 0, 0, 40)
    ModeButtons.Position = UDim2.new(0, 0, 0, 40)
    ModeButtons.BackgroundTransparency = 1
    ModeButtons.ZIndex = 2
    ModeButtons.Parent = MainFrame

    local GunButton = Instance.new("TextButton")
    GunButton.Name = "GunButton"
    GunButton.Size = UDim2.new(0.5, 0, 1, 0)
    GunButton.Position = UDim2.new(0, 0, 0, 0)
    GunButton.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
    GunButton.BackgroundTransparency = 0.2
    GunButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    GunButton.Text = "GUN"
    GunButton.Font = Enum.Font.GothamBold
    GunButton.TextSize = 14
    GunButton.ZIndex = 3
    GunButton.Parent = ModeButtons

    local NightsButton = Instance.new("TextButton")
    NightsButton.Name = "NightsButton"
    NightsButton.Size = UDim2.new(0.5, 0, 1, 0)
    NightsButton.Position = UDim2.new(0.5, 0, 0, 0)
    NightsButton.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
    NightsButton.BackgroundTransparency = 0.2
    NightsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    NightsButton.Text = "99 NIGHTS"
    NightsButton.Font = Enum.Font.GothamBold
    NightsButton.TextSize = 14
    NightsButton.ZIndex = 3
    NightsButton.Parent = ModeButtons

    -- Gun Menu (Movement, Visual, AimBot)
    GunMenu = Instance.new("Frame")
    GunMenu.Name = "GunMenu"
    GunMenu.Size = UDim2.new(1, 0, 1, -80)
    GunMenu.Position = UDim2.new(0, 0, 0, 80)
    GunMenu.BackgroundTransparency = 1
    GunMenu.Visible = currentMenu == "Gun"
    GunMenu.ZIndex = 2
    GunMenu.Parent = MainFrame

    -- Nights Menu (Main, Bring)
    NightsMenu = Instance.new("Frame")
    NightsMenu.Name = "NightsMenu"
    NightsMenu.Size = UDim2.new(1, 0, 1, -80)
    NightsMenu.Position = UDim2.new(0, 0, 0, 80)
    NightsMenu.BackgroundTransparency = 1
    NightsMenu.Visible = currentMenu == "Nights"
    NightsMenu.ZIndex = 2
    NightsMenu.Parent = MainFrame

    -- Gun Menu Content
    local GunTabButtons = Instance.new("Frame")
    GunTabButtons.Name = "GunTabButtons"
    GunTabButtons.Size = UDim2.new(1, 0, 0, 40)
    GunTabButtons.Position = UDim2.new(0, 0, 0, 0)
    GunTabButtons.BackgroundTransparency = 0.2
    GunTabButtons.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
    GunTabButtons.ZIndex = 2
    GunTabButtons.Parent = GunMenu

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
        tabButton.Size = UDim2.new(0.33, 0, 1, 0)
        tabButton.Position = UDim2.new(0.33 * (i-1), 0, 0, 0)
        tabButton.BackgroundColor3 = tab.defaultActive and Color3.fromRGB(120, 0, 0) or Color3.fromRGB(80, 0, 0)
        tabButton.BackgroundTransparency = 0.2
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabButton.Text = tab.name
        tabButton.Font = Enum.Font.Gotham
        tabButton.TextSize = 12
        tabButton.ZIndex = 3
        tabButton.Parent = GunTabButtons

        local ContentFrame = Instance.new("ScrollingFrame")
        ContentFrame.Name = tab.name .. "Content"
        ContentFrame.Size = UDim2.new(1, -20, 1, -50)
        ContentFrame.Position = UDim2.new(0, 10, 0, 50)
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

    -- Nights Menu Content
    local NightsTabButtons = Instance.new("Frame")
    NightsTabButtons.Name = "NightsTabButtons"
    NightsTabButtons.Size = UDim2.new(1, 0, 0, 40)
    NightsTabButtons.Position = UDim2.new(0, 0, 0, 0)
    NightsTabButtons.BackgroundTransparency = 0.2
    NightsTabButtons.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
    NightsTabButtons.ZIndex = 2
    NightsTabButtons.Parent = NightsMenu

    local nightsTabs = {
        {name = "Main", defaultActive = true},
        {name = "Bring", defaultActive = false}
    }

    local nightsTabButtons = {}
    local nightsTabContents = {}

    for i, tab in ipairs(nightsTabs) do
        local tabButton = Instance.new("TextButton")
        tabButton.Name = tab.name .. "Tab"
        tabButton.Size = UDim2.new(0.5, 0, 1, 0)
        tabButton.Position = UDim2.new(0.5 * (i-1), 0, 0, 0)
        tabButton.BackgroundColor3 = tab.defaultActive and Color3.fromRGB(120, 0, 0) or Color3.fromRGB(80, 0, 0)
        tabButton.BackgroundTransparency = 0.2
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabButton.Text = tab.name
        tabButton.Font = Enum.Font.Gotham
        tabButton.TextSize = 12
        tabButton.ZIndex = 3
        tabButton.Parent = NightsTabButtons

        local ContentFrame = Instance.new("ScrollingFrame")
        ContentFrame.Name = tab.name .. "Content"
        ContentFrame.Size = UDim2.new(1, -20, 1, -50)
        ContentFrame.Position = UDim2.new(0, 10, 0, 50)
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

    -- Gun Menu Content
    -- Movement Tab
    local SpeedHackFrame = Instance.new("Frame")
    SpeedHackFrame.Name = "SpeedHackFrame"
    SpeedHackFrame.Size = UDim2.new(1, 0, 0, 80)
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
    SpeedHackLabel.Size = UDim2.new(0.6, 0, 0, 30)
    SpeedHackLabel.Position = UDim2.new(0, 10, 0, 10)
    SpeedHackLabel.BackgroundTransparency = 1
    SpeedHackLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SpeedHackLabel.Text = "Speed Hack"
    SpeedHackLabel.Font = Enum.Font.Gotham
    SpeedHackLabel.TextSize = 14
    SpeedHackLabel.TextXAlignment = Enum.TextXAlignment.Left
    SpeedHackLabel.ZIndex = 3
    SpeedHackLabel.Parent = SpeedHackFrame

    local SpeedHackToggle = Instance.new("TextButton")
    SpeedHackToggle.Name = "SpeedHackToggle"
    SpeedHackToggle.Size = UDim2.new(0.3, 0, 0, 30)
    SpeedHackToggle.Position = UDim2.new(0.7, 0, 0, 10)
    SpeedHackToggle.BackgroundColor3 = speedHackEnabled and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(100, 0, 0)
    SpeedHackToggle.BackgroundTransparency = 0.2
    SpeedHackToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    SpeedHackToggle.Text = speedHackEnabled and "ON" or "OFF"
    SpeedHackToggle.Font = Enum.Font.Gotham
    SpeedHackToggle.TextSize = 12
    SpeedHackToggle.ZIndex = 3
    SpeedHackToggle.Parent = SpeedHackFrame

    local SpeedHackSlider = Instance.new("Frame")
    SpeedHackSlider.Name = "SpeedHackSlider"
    SpeedHackSlider.Size = UDim2.new(1, -20, 0, 30)
    SpeedHackSlider.Position = UDim2.new(0, 10, 0, 45)
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
    SpeedValue.TextSize = 12
    SpeedValue.ZIndex = 4
    SpeedValue.Parent = SpeedHackSlider

    -- Jump Hack
    local JumpHackFrame = Instance.new("Frame")
    JumpHackFrame.Name = "JumpHackFrame"
    JumpHackFrame.Size = UDim2.new(1, 0, 0, 40)
    JumpHackFrame.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
    JumpHackFrame.BackgroundTransparency = 0.3
    JumpHackFrame.BorderSizePixel = 0
    JumpHackFrame.ZIndex = 2
    JumpHackFrame.LayoutOrder = 2
    JumpHackFrame.Parent = gunTabContents["Movement"]

    local JumpHackCorner = Instance.new("UICorner")
    JumpHackCorner.CornerRadius = UDim.new(0, 6)
    JumpHackCorner.Parent = JumpHackFrame

    local JumpHackLabel = Instance.new("TextLabel")
    JumpHackLabel.Name = "JumpHackLabel"
    JumpHackLabel.Size = UDim2.new(0.6, 0, 1, 0)
    JumpHackLabel.Position = UDim2.new(0, 10, 0, 0)
    JumpHackLabel.BackgroundTransparency = 1
    JumpHackLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    JumpHackLabel.Text = "Jump Hack"
    JumpHackLabel.Font = Enum.Font.Gotham
    JumpHackLabel.TextSize = 14
    JumpHackLabel.TextXAlignment = Enum.TextXAlignment.Left
    JumpHackLabel.ZIndex = 3
    JumpHackLabel.Parent = JumpHackFrame

    local JumpHackToggle = Instance.new("TextButton")
    JumpHackToggle.Name = "JumpHackToggle"
    JumpHackToggle.Size = UDim2.new(0.3, 0, 0, 30)
    JumpHackToggle.Position = UDim2.new(0.7, 0, 0.125, 0)
    JumpHackToggle.BackgroundColor3 = jumpHackEnabled and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(100, 0, 0)
    JumpHackToggle.BackgroundTransparency = 0.2
    JumpHackToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    JumpHackToggle.Text = jumpHackEnabled and "ON" or "OFF"
    JumpHackToggle.Font = Enum.Font.Gotham
    JumpHackToggle.TextSize = 12
    JumpHackToggle.ZIndex = 3
    JumpHackToggle.Parent = JumpHackFrame

    -- NoClip
    local NoClipFrame = Instance.new("Frame")
    NoClipFrame.Name = "NoClipFrame"
    NoClipFrame.Size = UDim2.new(1, 0, 0, 40)
    NoClipFrame.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
    NoClipFrame.BackgroundTransparency = 0.3
    NoClipFrame.BorderSizePixel = 0
    NoClipFrame.ZIndex = 2
    NoClipFrame.LayoutOrder = 3
    NoClipFrame.Parent = gunTabContents["Movement"]

    local NoClipCorner = Instance.new("UICorner")
    NoClipCorner.CornerRadius = UDim.new(0, 6)
    NoClipCorner.Parent = NoClipFrame

    local NoClipLabel = Instance.new("TextLabel")
    NoClipLabel.Name = "NoClipLabel"
    NoClipLabel.Size = UDim2.new(0.6, 0, 1, 0)
    NoClipLabel.Position = UDim2.new(0, 10, 0, 0)
    NoClipLabel.BackgroundTransparency = 1
    NoClipLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    NoClipLabel.Text = "NoClip"
    NoClipLabel.Font = Enum.Font.Gotham
    NoClipLabel.TextSize = 14
    NoClipLabel.TextXAlignment = Enum.TextXAlignment.Left
    NoClipLabel.ZIndex = 3
    NoClipLabel.Parent = NoClipFrame

    local NoClipToggle = Instance.new("TextButton")
    NoClipToggle.Name = "NoClipToggle"
    NoClipToggle.Size = UDim2.new(0.3, 0, 0, 30)
    NoClipToggle.Position = UDim2.new(0.7, 0, 0.125, 0)
    NoClipToggle.BackgroundColor3 = noclipEnabled and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(100, 0, 0)
    NoClipToggle.BackgroundTransparency = 0.2
    NoClipToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    NoClipToggle.Text = noclipEnabled and "ON" or "OFF"
    NoClipToggle.Font = Enum.Font.Gotham
    NoClipToggle.TextSize = 12
    NoClipToggle.ZIndex = 3
    NoClipToggle.Parent = NoClipFrame

    -- Visual Tab
    -- ESP Tracers
    local ESPTracersFrame = Instance.new("Frame")
    ESPTracersFrame.Name = "ESPTracersFrame"
    ESPTracersFrame.Size = UDim2.new(1, 0, 0, 40)
    ESPTracersFrame.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
    ESPTracersFrame.BackgroundTransparency = 0.3
    ESPTracersFrame.BorderSizePixel = 0
    ESPTracersFrame.ZIndex = 2
    ESPTracersFrame.LayoutOrder = 1
    ESPTracersFrame.Parent = gunTabContents["Visual"]

    local ESPTracersCorner = Instance.new("UICorner")
    ESPTracersCorner.CornerRadius = UDim.new(0, 6)
    ESPTracersCorner.Parent = ESPTracersFrame

    local ESPTracersLabel = Instance.new("TextLabel")
    ESPTracersLabel.Name = "ESPTracersLabel"
    ESPTracersLabel.Size = UDim2.new(0.6, 0, 1, 0)
    ESPTracersLabel.Position = UDim2.new(0, 10, 0, 0)
    ESPTracersLabel.BackgroundTransparency = 1
    ESPTracersLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ESPTracersLabel.Text = "ESP Tracers"
    ESPTracersLabel.Font = Enum.Font.Gotham
    ESPTracersLabel.TextSize = 14
    ESPTracersLabel.TextXAlignment = Enum.TextXAlignment.Left
    ESPTracersLabel.ZIndex = 3
    ESPTracersLabel.Parent = ESPTracersFrame

    local ESPTracersToggle = Instance.new("TextButton")
    ESPTracersToggle.Name = "ESPTracersToggle"
    ESPTracersToggle.Size = UDim2.new(0.3, 0, 0, 30)
    ESPTracersToggle.Position = UDim2.new(0.7, 0, 0.125, 0)
    ESPTracersToggle.BackgroundColor3 = espTracersEnabled and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(100, 0, 0)
    ESPTracersToggle.BackgroundTransparency = 0.2
    ESPTracersToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    ESPTracersToggle.Text = espTracersEnabled and "ON" or "OFF"
    ESPTracersToggle.Font = Enum.Font.Gotham
    ESPTracersToggle.TextSize = 12
    ESPTracersToggle.ZIndex = 3
    ESPTracersToggle.Parent = ESPTracersFrame

    -- ESP Box
    local ESPBoxFrame = Instance.new("Frame")
    ESPBoxFrame.Name = "ESPBoxFrame"
    ESPBoxFrame.Size = UDim2.new(1, 0, 0, 40)
    ESPBoxFrame.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
    ESPBoxFrame.BackgroundTransparency = 0.3
    ESPBoxFrame.BorderSizePixel = 0
    ESPBoxFrame.ZIndex = 2
    ESPBoxFrame.LayoutOrder = 2
    ESPBoxFrame.Parent = gunTabContents["Visual"]

    local ESPBoxCorner = Instance.new("UICorner")
    ESPBoxCorner.CornerRadius = UDim.new(0, 6)
    ESPBoxCorner.Parent = ESPBoxFrame

    local ESPBoxLabel = Instance.new("TextLabel")
    ESPBoxLabel.Name = "ESPBoxLabel"
    ESPBoxLabel.Size = UDim2.new(0.6, 0, 1, 0)
    ESPBoxLabel.Position = UDim2.new(0, 10, 0, 0)
    ESPBoxLabel.BackgroundTransparency = 1
    ESPBoxLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ESPBoxLabel.Text = "ESP Box"
    ESPBoxLabel.Font = Enum.Font.Gotham
    ESPBoxLabel.TextSize = 14
    ESPBoxLabel.TextXAlignment = Enum.TextXAlignment.Left
    ESPBoxLabel.ZIndex = 3
    ESPBoxLabel.Parent = ESPBoxFrame

    local ESPBoxToggle = Instance.new("TextButton")
    ESPBoxToggle.Name = "ESPBoxToggle"
    ESPBoxToggle.Size = UDim2.new(0.3, 0, 0, 30)
    ESPBoxToggle.Position = UDim2.new(0.7, 0, 0.125, 0)
    ESPBoxToggle.BackgroundColor3 = espBoxEnabled and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(100, 0, 0)
    ESPBoxToggle.BackgroundTransparency = 0.2
    ESPBoxToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    ESPBoxToggle.Text = espBoxEnabled and "ON" or "OFF"
    ESPBoxToggle.Font = Enum.Font.Gotham
    ESPBoxToggle.TextSize = 12
    ESPBoxToggle.ZIndex = 3
    ESPBoxToggle.Parent = ESPBoxFrame

    -- ESP Health
    local ESPHealthFrame = Instance.new("Frame")
    ESPHealthFrame.Name = "ESPHealthFrame"
    ESPHealthFrame.Size = UDim2.new(1, 0, 0, 40)
    ESPHealthFrame.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
    ESPHealthFrame.BackgroundTransparency = 0.3
    ESPHealthFrame.BorderSizePixel = 0
    ESPHealthFrame.ZIndex = 2
    ESPHealthFrame.LayoutOrder = 3
    ESPHealthFrame.Parent = gunTabContents["Visual"]

    local ESPHealthCorner = Instance.new("UICorner")
    ESPHealthCorner.CornerRadius = UDim.new(0, 6)
    ESPHealthCorner.Parent = ESPHealthFrame

    local ESPHealthLabel = Instance.new("TextLabel")
    ESPHealthLabel.Name = "ESPHealthLabel"
    ESPHealthLabel.Size = UDim2.new(0.6, 0, 1, 0)
    ESPHealthLabel.Position = UDim2.new(0, 10, 0, 0)
    ESPHealthLabel.BackgroundTransparency = 1
    ESPHealthLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ESPHealthLabel.Text = "ESP Health"
    ESPHealthLabel.Font = Enum.Font.Gotham
    ESPHealthLabel.TextSize = 14
    ESPHealthLabel.TextXAlignment = Enum.TextXAlignment.Left
    ESPHealthLabel.ZIndex = 3
    ESPHealthLabel.Parent = ESPHealthFrame

    local ESPHealthToggle = Instance.new("TextButton")
    ESPHealthToggle.Name = "ESPHealthToggle"
    ESPHealthToggle.Size = UDim2.new(0.3, 0, 0, 30)
    ESPHealthToggle.Position = UDim2.new(0.7, 0, 0.125, 0)
    ESPHealthToggle.BackgroundColor3 = espHealthEnabled and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(100, 0, 0)
    ESPHealthToggle.BackgroundTransparency = 0.2
    ESPHealthToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    ESPHealthToggle.Text = espHealthEnabled and "ON" or "OFF"
    ESPHealthToggle.Font = Enum.Font.Gotham
    ESPHealthToggle.TextSize = 12
    ESPHealthToggle.ZIndex = 3
    ESPHealthToggle.Parent = ESPHealthFrame

    -- ESP Distance
    local ESPDistanceFrame = Instance.new("Frame")
    ESPDistanceFrame.Name = "ESPDistanceFrame"
    ESPDistanceFrame.Size = UDim2.new(1, 0, 0, 40)
    ESPDistanceFrame.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
    ESPDistanceFrame.BackgroundTransparency = 0.3
    ESPDistanceFrame.BorderSizePixel = 0
    ESPDistanceFrame.ZIndex = 2
    ESPDistanceFrame.LayoutOrder = 4
    ESPDistanceFrame.Parent = gunTabContents["Visual"]

    local ESPDistanceCorner = Instance.new("UICorner")
    ESPDistanceCorner.CornerRadius = UDim.new(0, 6)
    ESPDistanceCorner.Parent = ESPDistanceFrame

    local ESPDistanceLabel = Instance.new("TextLabel")
    ESPDistanceLabel.Name = "ESPDistanceLabel"
    ESPDistanceLabel.Size = UDim2.new(0.6, 0, 1, 0)
    ESPDistanceLabel.Position = UDim2.new(0, 10, 0, 0)
    ESPDistanceLabel.BackgroundTransparency = 1
    ESPDistanceLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ESPDistanceLabel.Text = "ESP Distance"
    ESPDistanceLabel.Font = Enum.Font.Gotham
    ESPDistanceLabel.TextSize = 14
    ESPDistanceLabel.TextXAlignment = Enum.TextXAlignment.Left
    ESPDistanceLabel.ZIndex = 3
    ESPDistanceLabel.Parent = ESPDistanceFrame

    local ESPDistanceToggle = Instance.new("TextButton")
    ESPDistanceToggle.Name = "ESPDistanceToggle"
    ESPDistanceToggle.Size = UDim2.new(0.3, 0, 0, 30)
    ESPDistanceToggle.Position = UDim2.new(0.7, 0, 0.125, 0)
    ESPDistanceToggle.BackgroundColor3 = espDistanceEnabled and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(100, 0, 0)
    ESPDistanceToggle.BackgroundTransparency = 0.2
    ESPDistanceToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    ESPDistanceToggle.Text = espDistanceEnabled and "ON" or "OFF"
    ESPDistanceToggle.Font = Enum.Font.Gotham
    ESPDistanceToggle.TextSize = 12
    ESPDistanceToggle.ZIndex = 3
    ESPDistanceToggle.Parent = ESPDistanceFrame

    -- ESP Count
    local ESPCountFrame = Instance.new("Frame")
    ESPCountFrame.Name = "ESPCountFrame"
    ESPCountFrame.Size = UDim2.new(1, 0, 0, 40)
    ESPCountFrame.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
    ESPCountFrame.BackgroundTransparency = 0.3
    ESPCountFrame.BorderSizePixel = 0
    ESPCountFrame.ZIndex = 2
    ESPCountFrame.LayoutOrder = 5
    ESPCountFrame.Parent = gunTabContents["Visual"]

    local ESPCountCorner = Instance.new("UICorner")
    ESPCountCorner.CornerRadius = UDim.new(0, 6)
    ESPCountCorner.Parent = ESPCountFrame

    local ESPCountLabel = Instance.new("TextLabel")
    ESPCountLabel.Name = "ESPCountLabel"
    ESPCountLabel.Size = UDim2.new(0.6, 0, 1, 0)
    ESPCountLabel.Position = UDim2.new(0, 10, 0, 0)
    ESPCountLabel.BackgroundTransparency = 1
    ESPCountLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ESPCountLabel.Text = "ESP Count"
    ESPCountLabel.Font = Enum.Font.Gotham
    ESPCountLabel.TextSize = 14
    ESPCountLabel.TextXAlignment = Enum.TextXAlignment.Left
    ESPCountLabel.ZIndex = 3
    ESPCountLabel.Parent = ESPCountFrame

    local ESPCountToggle = Instance.new("TextButton")
    ESPCountToggle.Name = "ESPCountToggle"
    ESPCountToggle.Size = UDim2.new(0.3, 0, 0, 30)
    ESPCountToggle.Position = UDim2.new(0.7, 0, 0.125, 0)
    ESPCountToggle.BackgroundColor3 = espCountEnabled and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(100, 0, 0)
    ESPCountToggle.BackgroundTransparency = 0.2
    ESPCountToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    ESPCountToggle.Text = espCountEnabled and "ON" or "OFF"
    ESPCountToggle.Font = Enum.Font.Gotham
    ESPCountToggle.TextSize = 12
    ESPCountToggle.ZIndex = 3
    ESPCountToggle.Parent = ESPCountFrame

    -- AimBot Tab
    local AimBotFrame = Instance.new("Frame")
    AimBotFrame.Name = "AimBotFrame"
    AimBotFrame.Size = UDim2.new(1, 0, 0, 40)
    AimBotFrame.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
    AimBotFrame.BackgroundTransparency = 0.3
    AimBotFrame.BorderSizePixel = 0
    AimBotFrame.ZIndex = 2
    AimBotFrame.LayoutOrder = 1
    AimBotFrame.Parent = gunTabContents["AimBot"]

    local AimBotCorner = Instance.new("UICorner")
    AimBotCorner.CornerRadius = UDim.new(0, 6)
    AimBotCorner.Parent = AimBotFrame

    local AimBotLabel = Instance.new("TextLabel")
    AimBotLabel.Name = "AimBotLabel"
    AimBotLabel.Size = UDim2.new(0.6, 0, 1, 0)
    AimBotLabel.Position = UDim2.new(0, 10, 0, 0)
    AimBotLabel.BackgroundTransparency = 1
    AimBotLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    AimBotLabel.Text = "AimBot"
    AimBotLabel.Font = Enum.Font.Gotham
    AimBotLabel.TextSize = 14
    AimBotLabel.TextXAlignment = Enum.TextXAlignment.Left
    AimBotLabel.ZIndex = 3
    AimBotLabel.Parent = AimBotFrame

    local AimBotToggle = Instance.new("TextButton")
    AimBotToggle.Name = "AimBotToggle"
    AimBotToggle.Size = UDim2.new(0.3, 0, 0, 30)
    AimBotToggle.Position = UDim2.new(0.7, 0, 0.125, 0)
    AimBotToggle.BackgroundColor3 = aimBotEnabled and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(100, 0, 0)
    AimBotToggle.BackgroundTransparency = 0.2
    AimBotToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    AimBotToggle.Text = aimBotEnabled and "ON" or "OFF"
    AimBotToggle.Font = Enum.Font.Gotham
    AimBotToggle.TextSize = 12
    AimBotToggle.ZIndex = 3
    AimBotToggle.Parent = AimBotFrame

    -- AimBot FOV Slider
    local AimBotFOVFrame = Instance.new("Frame")
    AimBotFOVFrame.Name = "AimBotFOVFrame"
    AimBotFOVFrame.Size = UDim2.new(1, 0, 0, 60)
    AimBotFOVFrame.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
    AimBotFOVFrame.BackgroundTransparency = 0.3
    AimBotFOVFrame.BorderSizePixel = 0
    AimBotFOVFrame.Visible = aimBotEnabled
    AimBotFOVFrame.ZIndex = 2
    AimBotFOVFrame.LayoutOrder = 2
    AimBotFOVFrame.Parent = gunTabContents["AimBot"]

    local AimBotFOVCorner = Instance.new("UICorner")
    AimBotFOVCorner.CornerRadius = UDim.new(0, 6)
    AimBotFOVCorner.Parent = AimBotFOVFrame

    local AimBotFOVLabel = Instance.new("TextLabel")
    AimBotFOVLabel.Name = "AimBotFOVLabel"
    AimBotFOVLabel.Size = UDim2.new(1, 0, 0, 30)
    AimBotFOVLabel.Position = UDim2.new(0, 0, 0, 0)
    AimBotFOVLabel.BackgroundTransparency = 1
    AimBotFOVLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    AimBotFOVLabel.Text = "AimBot FOV: " .. aimBotFOV
    AimBotFOVLabel.Font = Enum.Font.Gotham
    AimBotFOVLabel.TextSize = 12
    AimBotFOVLabel.ZIndex = 3
    AimBotFOVLabel.Parent = AimBotFOVFrame

    -- Nights Menu Content
    -- Main Tab
    local KillAuraToggle = CreateToggle(nightsTabContents["Main"], "Kill Aura", function(v)
        ActiveKillAura = v
    end, ActiveKillAura)

    CreateSlider(nightsTabContents["Main"], "Kill Distance", 10, 100, DistanceForKillAura, function(v)
        DistanceForKillAura = v
    end)

    local AutoChopToggle = CreateToggle(nightsTabContents["Main"], "Auto Chop", function(v)
        ActiveAutoChopTree = v
    end, ActiveAutoChopTree)

    CreateSlider(nightsTabContents["Main"], "Chop Distance", 10, 100, DistanceForAutoChopTree, function(v)
        DistanceForAutoChopTree = v
    end)

    -- Bring Tab
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

    -- Подменю для ресурсов
    local ResourcesButton = CreateButton(nightsTabContents["Bring"], "Resources", function()
        -- Открываем подменю ресурсов
        for _, child in pairs(nightsTabContents["Bring"]:GetChildren()) do
            if child.Name == "ResourcesSubMenu" then
                child.Visible = not child.Visible
            end
        end
    end)

    local ResourcesSubMenu = Instance.new("Frame")
    ResourcesSubMenu.Name = "ResourcesSubMenu"
    ResourcesSubMenu.Size = UDim2.new(1, 0, 0, 0)
    ResourcesSubMenu.BackgroundTransparency = 1
    ResourcesSubMenu.Visible = false
    ResourcesSubMenu.LayoutOrder = 10
    ResourcesSubMenu.Parent = nightsTabContents["Bring"]

    local ResourcesLayout = Instance.new("UIListLayout")
    ResourcesLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ResourcesLayout.Padding = UDim.new(0, 5)
    ResourcesLayout.Parent = ResourcesSubMenu

    local resourcesItems = {"Coal", "Fuel Can", "Oil Barrel"}
    for _, itemName in pairs(resourcesItems) do
        CreateButton(ResourcesSubMenu, "Bring " .. itemName, function()
            BringItems(itemName)
        end)
    end

    -- Подменю для металлов
    local MetalsButton = CreateButton(nightsTabContents["Bring"], "Metals", function()
        for _, child in pairs(nightsTabContents["Bring"]:GetChildren()) do
            if child.Name == "MetalsSubMenu" then
                child.Visible = not child.Visible
            end
        end
    end)

    local MetalsSubMenu = Instance.new("Frame")
    MetalsSubMenu.Name = "MetalsSubMenu"
    MetalsSubMenu.Size = UDim2.new(1, 0, 0, 0)
    MetalsSubMenu.BackgroundTransparency = 1
    MetalsSubMenu.Visible = false
    MetalsSubMenu.LayoutOrder = 11
    MetalsSubMenu.Parent = nightsTabContents["Bring"]

    local MetalsLayout = Instance.new("UIListLayout")
    MetalsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    MetalsLayout.Padding = UDim.new(0, 5)
    MetalsLayout.Parent = MetalsSubMenu

    local metalsItems = {"Scrap Metal", "Bolt", "Sheet Metal", "UFO Scrap"}
    for _, itemName in pairs(metalsItems) do
        CreateButton(MetalsSubMenu, "Bring " .. itemName, function()
            BringItems(itemName)
        end)
    end

    -- Подменю для электроники
    local ElectronicsButton = CreateButton(nightsTabContents["Bring"], "Electronics", function()
        for _, child in pairs(nightsTabContents["Bring"]:GetChildren()) do
            if child.Name == "ElectronicsSubMenu" then
                child.Visible = not child.Visible
            end
        end
    end)

    local ElectronicsSubMenu = Instance.new("Frame")
    ElectronicsSubMenu.Name = "ElectronicsSubMenu"
    ElectronicsSubMenu.Size = UDim2.new(1, 0, 0, 0)
    ElectronicsSubMenu.BackgroundTransparency = 1
    ElectronicsSubMenu.Visible = false
    ElectronicsSubMenu.LayoutOrder = 12
    ElectronicsSubMenu.Parent = nightsTabContents["Bring"]

    local ElectronicsLayout = Instance.new("UIListLayout")
    ElectronicsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ElectronicsLayout.Padding = UDim.new(0, 5)
    ElectronicsLayout.Parent = ElectronicsSubMenu

    local electronicsItems = {"Broken Microwave", "Old Radio"}
    for _, itemName in pairs(electronicsItems) do
        CreateButton(ElectronicsSubMenu, "Bring " .. itemName, function()
            BringItems(itemName)
        end)
    end

    -- Подменю для еды и медицины
    local FoodMedButton = CreateButton(nightsTabContents["Bring"], "Food & Medical", function()
        for _, child in pairs(nightsTabContents["Bring"]:GetChildren()) do
            if child.Name == "FoodMedSubMenu" then
                child.Visible = not child.Visible
            end
        end
    end)

    local FoodMedSubMenu = Instance.new("Frame")
    FoodMedSubMenu.Name = "FoodMedSubMenu"
    FoodMedSubMenu.Size = UDim2.new(1, 0, 0, 0)
    FoodMedSubMenu.BackgroundTransparency = 1
    FoodMedSubMenu.Visible = false
    FoodMedSubMenu.LayoutOrder = 13
    FoodMedSubMenu.Parent = nightsTabContents["Bring"]

    local FoodMedLayout = Instance.new("UIListLayout")
    FoodMedLayout.SortOrder = Enum.SortOrder.LayoutOrder
    FoodMedLayout.Padding = UDim.new(0, 5)
    FoodMedLayout.Parent = FoodMedSubMenu

    local foodMedItems = {"Carrot", "Bandage"}
    for _, itemName in pairs(foodMedItems) do
        CreateButton(FoodMedSubMenu, "Bring " .. itemName, function()
            BringItems(itemName)
        end)
    end

    -- Обработчики для Gun Menu
    -- Speed Hack
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

    -- Speed Slider
    local speedSliderConnection
    SpeedHackSlider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
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
        end
    end)

    SpeedHackSlider.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            if speedSliderConnection then
                speedSliderConnection:Disconnect()
                speedSliderConnection = nil
            end
        end
    end)

    -- Jump Hack
    JumpHackToggle.MouseButton1Click:Connect(function()
        jumpHackEnabled = not jumpHackEnabled
        toggleButton(JumpHackToggle, jumpHackEnabled)
    end)

    -- Infinite Jump
    UserInputService.JumpRequest:Connect(function()
        if jumpHackEnabled and player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)

    -- NoClip
    NoClipToggle.MouseButton1Click:Connect(function()
        noclipEnabled = not noclipEnabled
        toggleButton(NoClipToggle, noclipEnabled)
        
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
    end)

    -- ESP Tracers Toggle
    ESPTracersToggle.MouseButton1Click:Connect(function()
        espTracersEnabled = not espTracersEnabled
        toggleButton(ESPTracersToggle, espTracersEnabled)
    end)

    -- ESP Box Toggle
    ESPBoxToggle.MouseButton1Click:Connect(function()
        espBoxEnabled = not espBoxEnabled
        toggleButton(ESPBoxToggle, espBoxEnabled)
    end)

    -- ESP Health Toggle
    ESPHealthToggle.MouseButton1Click:Connect(function()
        espHealthEnabled = not espHealthEnabled
        toggleButton(ESPHealthToggle, espHealthEnabled)
    end)

    -- ESP Distance Toggle
    ESPDistanceToggle.MouseButton1Click:Connect(function()
        espDistanceEnabled = not espDistanceEnabled
        toggleButton(ESPDistanceToggle, espDistanceEnabled)
    end)

    -- ESP Count Toggle
    ESPCountToggle.MouseButton1Click:Connect(function()
        espCountEnabled = not espCountEnabled
        toggleButton(ESPCountToggle, espCountEnabled)
        
        if espCountEnabled then
            if not espCountText then
                espCountText = Drawing.new("Text")
                espCountText.Size = 20
                espCountText.Center = true
                espCountText.Outline = true
                espCountText.Color = Color3.fromRGB(255, 0, 0)
                espCountText.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, 100)
            end
            espCountText.Visible = true
        else
            if espCountText then
                espCountText.Visible = false
            end
        end
    end)

    -- Initialize ESP for existing players
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        createESP(otherPlayer)
    end

    -- ESP for new players
    Players.PlayerAdded:Connect(function(newPlayer)
        createESP(newPlayer)
    end)

    -- Remove ESP when player leaves
    Players.PlayerRemoving:Connect(function(leftPlayer)
        cleanupESP(leftPlayer)
    end)

    -- Update ESP Count continuously
    RunService.Heartbeat:Connect(updateESPCount)

    -- Update ESP Count position when screen size changes
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        if espCountText then
            espCountText.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, 100)
        end
    end)

    -- AimBot
    AimBotToggle.MouseButton1Click:Connect(function()
        aimBotEnabled = not aimBotEnabled
        toggleButton(AimBotToggle, aimBotEnabled)
        AimBotFOVFrame.Visible = aimBotEnabled
        
        if fovCircle then
            fovCircle.Visible = aimBotEnabled
        else
            createFOVCircle()
            fovCircle.Visible = aimBotEnabled
        end
    end)

    -- AimBot FOV Slider
    local aimbotSliderConnection
    AimBotFOVFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            aimbotSliderConnection = RunService.Heartbeat:Connect(function()
                local mouseLocation = UserInputService:GetMouseLocation()
                local relativeX = math.clamp((mouseLocation.X - AimBotFOVFrame.AbsolutePosition.X) / AimBotFOVFrame.AbsoluteSize.X, 0, 1)
                aimBotFOV = math.floor(10 + (relativeX * 190))
                AimBotFOVLabel.Text = "AimBot FOV: " .. aimBotFOV
                updateFOVCircle()
            end)
        end
    end)

    AimBotFOVFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            if aimbotSliderConnection then
                aimbotSliderConnection:Disconnect()
                aimbotSliderConnection = nil
            end
        end
    end)

    -- AimBot Logic with FOV
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

    -- Mode Switching
    GunButton.MouseButton1Click:Connect(function()
        currentMenu = "Gun"
        GunMenu.Visible = true
        NightsMenu.Visible = false
        GunButton.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
        NightsButton.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
    end)

    NightsButton.MouseButton1Click:Connect(function()
        currentMenu = "Nights"
        GunMenu.Visible = false
        NightsMenu.Visible = true
        GunButton.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
        NightsButton.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
    end)

    -- Auto-resize for mobile
    local function updateSize()
        local viewportSize = workspace.CurrentCamera.ViewportSize
        MainFrame.Size = UDim2.new(0, math.min(300, viewportSize.X - 20), 0, math.min(450, viewportSize.Y - 20))
        
        updateFOVCircle()
        
        if espCountText then
            espCountText.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, 100)
        end
    end

    updateSize()
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateSize)
    
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