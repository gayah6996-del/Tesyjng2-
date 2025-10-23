-- SANSTRO Menu for Mobile - 99 Nights Only
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Глобальные переменные для сохранения состояний
local speedHackEnabled = false
local jumpHackEnabled = false
local noclipEnabled = false
local currentSpeed = 16

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

local noclipConnection = nil

-- Функция для показа уведомлений
local function showNotification(text)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "SANSTRO MENU",
        Text = text,
        Duration = 3,
        Icon = "rbxassetid://4483362458"
    })
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

-- Исправленная Anti AFK функция
local function EnableAntiAFK()
    if antiAFKConnection then
        antiAFKConnection:Disconnect()
        antiAFKConnection = nil
    end
    
    -- Правильный Anti-AFK метод
    antiAFKConnection = game:GetService("Players").LocalPlayer.Idled:Connect(function()
        VirtualInputManager:SendKeyEvent(true, "F", false, game)
        wait(0.1)
        VirtualInputManager:SendKeyEvent(false, "F", false, game)
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

-- Создаем простой GUI для телефона
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SANSTRO_MENU"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

-- Основная кнопка открытия меню
local OpenButton = Instance.new("TextButton")
OpenButton.Name = "OpenButton"
OpenButton.Size = UDim2.new(0, 60, 0, 60)
OpenButton.Position = UDim2.new(0, 10, 0, 10)
OpenButton.BackgroundColor3 = Color3.fromRGB(30, 0, 60)
OpenButton.BackgroundTransparency = 0.2
OpenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenButton.Text = "☰"
OpenButton.Font = Enum.Font.GothamBold
OpenButton.TextSize = 20
OpenButton.ZIndex = 10
OpenButton.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = OpenButton

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(100, 0, 200)
Stroke.Thickness = 2
Stroke.Parent = OpenButton

-- Главное меню
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 350, 0, 500)
MainFrame.Position = UDim2.new(0, 80, 0, 10)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 0, 40)
MainFrame.BackgroundTransparency = 0.1
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(100, 0, 200)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(40, 0, 80)
Title.BackgroundTransparency = 0.1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Text = "SANSTRO MENU - 99 NIGHTS"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = Title

-- Прокручиваемая область
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Name = "ScrollFrame"
ScrollFrame.Size = UDim2.new(1, 0, 1, -50)
ScrollFrame.Position = UDim2.new(0, 0, 0, 50)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 6
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 0, 200)
ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollFrame.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Padding = UDim.new(0, 10)
Layout.Parent = ScrollFrame

-- Функция создания переключателя
local function CreateToggle(parent, text, callback, isActive)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, -20, 0, 45)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(30, 0, 60)
    toggleFrame.BackgroundTransparency = 0.1
    toggleFrame.LayoutOrder = #parent:GetChildren()
    toggleFrame.Parent = parent
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 8)
    toggleCorner.Parent = toggleFrame
    
    local toggleStroke = Instance.new("UIStroke")
    toggleStroke.Color = Color3.fromRGB(80, 0, 160)
    toggleStroke.Thickness = 1
    toggleStroke.Parent = toggleFrame
    
    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Name = "ToggleLabel"
    toggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    toggleLabel.Position = UDim2.new(0, 15, 0, 0)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleLabel.Text = text
    toggleLabel.Font = Enum.Font.GothamSemibold
    toggleLabel.TextSize = 14
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    toggleLabel.Parent = toggleFrame
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0.2, 0, 0, 30)
    toggleButton.Position = UDim2.new(0.75, 0, 0.15, 0)
    toggleButton.BackgroundColor3 = isActive and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    toggleButton.BackgroundTransparency = 0.1
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.Text = isActive and "ON" or "OFF"
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.TextSize = 12
    toggleButton.Parent = toggleFrame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = toggleButton
    
    toggleButton.MouseButton1Click:Connect(function()
        isActive = not isActive
        toggleButton.BackgroundColor3 = isActive and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        toggleButton.Text = isActive and "ON" or "OFF"
        showNotification(text .. " " .. (isActive and "ENABLED" or "DISABLED"))
        callback(isActive)
        SaveSettings()
    end)
end

-- Функция создания слайдера
local function CreateSlider(parent, text, min, max, default, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, -20, 0, 70)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(30, 0, 60)
    sliderFrame.BackgroundTransparency = 0.1
    sliderFrame.LayoutOrder = #parent:GetChildren()
    sliderFrame.Parent = parent
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 8)
    sliderCorner.Parent = sliderFrame
    
    local sliderStroke = Instance.new("UIStroke")
    sliderStroke.Color = Color3.fromRGB(80, 0, 160)
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
    sliderText.Parent = sliderFrame
    
    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new(1, -30, 0, 20)
    sliderBar.Position = UDim2.new(0, 15, 0, 35)
    sliderBar.BackgroundColor3 = Color3.fromRGB(50, 0, 100)
    sliderBar.Parent = sliderFrame
    
    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0, 8)
    barCorner.Parent = sliderBar
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(100, 0, 200)
    sliderFill.Parent = sliderBar
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 8)
    fillCorner.Parent = sliderFill
    
    local function updateSlider(value)
        local norm = math.clamp((value - min) / (max - min), 0, 1)
        sliderFill.Size = UDim2.new(norm, 0, 1, 0)
        sliderText.Text = text .. ": " .. math.floor(value)
        callback(value)
    end
    
    sliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            local connection
            connection = RunService.Heartbeat:Connect(function()
                local mouseLocation = input.Position
                local relativeX = math.clamp((mouseLocation.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
                local value = min + relativeX * (max - min)
                updateSlider(value)
            end)
            
            local function endInput()
                connection:Disconnect()
                SaveSettings()
            end
            
            input:GetPropertyChangedSignal("UserInputState"):Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    endInput()
                end
            end)
        end
    end)
    
    updateSlider(default)
end

-- Функция создания кнопки
local function CreateButton(parent, text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 45)
    button.BackgroundColor3 = Color3.fromRGB(30, 0, 60)
    button.BackgroundTransparency = 0.1
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    button.Font = Enum.Font.GothamSemibold
    button.LayoutOrder = #parent:GetChildren()
    button.Parent = parent
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = button
    
    local buttonStroke = Instance.new("UIStroke")
    buttonStroke.Color = Color3.fromRGB(80, 0, 160)
    buttonStroke.Thickness = 1
    buttonStroke.Parent = button
    
    button.MouseButton1Click:Connect(function()
        callback()
    end)
    
    return button
end

-- Создаем разделы меню

-- Основные функции
CreateToggle(ScrollFrame, "Kill Aura", function(v)
    ActiveKillAura = v
end, ActiveKillAura)

CreateSlider(ScrollFrame, "Kill Distance", 10, 150, DistanceForKillAura, function(v)
    DistanceForKillAura = v
end)

CreateToggle(ScrollFrame, "Auto Chop Trees", function(v)
    ActiveAutoChopTree = v
end, ActiveAutoChopTree)

CreateSlider(ScrollFrame, "Chop Distance", 10, 150, DistanceForAutoChopTree, function(v)
    DistanceForAutoChopTree = v
end)

-- Настройки телепортации
CreateSlider(ScrollFrame, "Bring Count", 1, 20, BringCount, function(v)
    BringCount = math.floor(v)
end)

CreateSlider(ScrollFrame, "Bring Speed", 50, 500, BringDelay, function(v)
    BringDelay = math.floor(v)
end)

-- Выбор цели телепортации
local targetFrame = Instance.new("Frame")
targetFrame.Size = UDim2.new(1, -20, 0, 50)
targetFrame.BackgroundColor3 = Color3.fromRGB(30, 0, 60)
targetFrame.BackgroundTransparency = 0.1
targetFrame.LayoutOrder = #ScrollFrame:GetChildren()
targetFrame.Parent = ScrollFrame

local targetCorner = Instance.new("UICorner")
targetCorner.CornerRadius = UDim.new(0, 8)
targetCorner.Parent = targetFrame

local targetStroke = Instance.new("UIStroke")
targetStroke.Color = Color3.fromRGB(80, 0, 160)
targetStroke.Thickness = 1
targetStroke.Parent = targetFrame

local targetLabel = Instance.new("TextLabel")
targetLabel.Size = UDim2.new(0.5, 0, 1, 0)
targetLabel.BackgroundTransparency = 1
targetLabel.Text = "Teleport Target:"
targetLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
targetLabel.TextSize = 14
targetLabel.TextXAlignment = Enum.TextXAlignment.Left
targetLabel.Position = UDim2.new(0, 15, 0, 0)
targetLabel.Font = Enum.Font.GothamSemibold
targetLabel.Parent = targetFrame

local playerButton = Instance.new("TextButton")
playerButton.Size = UDim2.new(0.2, 0, 0, 30)
playerButton.Position = UDim2.new(0.55, 0, 0.2, 0)
playerButton.BackgroundColor3 = BringTarget == "Player" and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(60, 0, 60)
playerButton.Text = "Player"
playerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
playerButton.TextSize = 12
playerButton.Font = Enum.Font.GothamBold
playerButton.Parent = targetFrame

local campfireButton = Instance.new("TextButton")
campfireButton.Size = UDim2.new(0.2, 0, 0, 30)
campfireButton.Position = UDim2.new(0.8, 0, 0.2, 0)
campfireButton.BackgroundColor3 = BringTarget == "Campfire" and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(60, 0, 60)
campfireButton.Text = "Campfire"
campfireButton.TextColor3 = Color3.fromRGB(255, 255, 255)
campfireButton.TextSize = 12
campfireButton.Font = Enum.Font.GothamBold
campfireButton.Parent = targetFrame

playerButton.MouseButton1Click:Connect(function()
    BringTarget = "Player"
    playerButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    campfireButton.BackgroundColor3 = Color3.fromRGB(60, 0, 60)
    showNotification("Teleport target: PLAYER")
    SaveSettings()
end)

campfireButton.MouseButton1Click:Connect(function()
    BringTarget = "Campfire"
    playerButton.BackgroundColor3 = Color3.fromRGB(60, 0, 60)
    campfireButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    showNotification("Teleport target: CAMPFIRE")
    SaveSettings()
end)

-- Кнопки телепорта ресурсов
CreateButton(ScrollFrame, "📦 Bring Logs", function()
    BringItems("Log")
end)

CreateButton(ScrollFrame, "⛏️ Bring Coal", function()
    BringItems("Coal")
end)

CreateButton(ScrollFrame, "🪑 Bring Chairs", function()
    BringItems("Chair")
end)

-- Топливо
CreateButton(ScrollFrame, "⛽ Bring Fuel Canister", function()
    BringItems("Fuel Canister")
end)

CreateButton(ScrollFrame, "🛢️ Bring Oil Barrel", function()
    BringItems("Oil Barrel")
end)

CreateButton(ScrollFrame, "🔋 Bring Biofuel", function()
    BringItems("Biofuel")
end)

-- Металлы
CreateButton(ScrollFrame, "🔩 Bring Bolts", function()
    BringItems("Bolt")
end)

CreateButton(ScrollFrame, "📄 Bring Sheet Metal", function()
    BringItems("Sheet Metal")
end)

CreateButton(ScrollFrame, "👽 Bring UFO Scrap", function()
    BringItems("UFO Scrap")
end)

-- Еда и медицина
CreateButton(ScrollFrame, "🥕 Bring Carrots", function()
    BringItems("Carrot")
end)

CreateButton(ScrollFrame, "🎃 Bring Pumpkins", function()
    BringItems("Pumpkin")
end)

CreateButton(ScrollFrame, "🍖 Bring Steak", function()
    BringItems("Steak")
end)

CreateButton(ScrollFrame, "💊 Bring MedKits", function()
    BringItems("MedKit")
end)

-- Оружие и инструменты
CreateButton(ScrollFrame, "🔫 Bring Rifles", function()
    BringItems("Rifle")
end)

CreateButton(ScrollFrame, "🎯 Bring Revolvers", function()
    BringItems("Revolver")
end)

CreateButton(ScrollFrame, "🪓 Bring Good Axe", function()
    BringItems("Good Axe")
end)

-- Дополнительные функции
CreateToggle(ScrollFrame, "Speed Hack", function(v)
    speedHackEnabled = v
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
end, speedHackEnabled)

CreateSlider(ScrollFrame, "Speed Value", 16, 100, currentSpeed, function(v)
    currentSpeed = math.floor(v)
    if speedHackEnabled then
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = currentSpeed
        end
    end
end)

CreateToggle(ScrollFrame, "Infinity Jump", function(v)
    jumpHackEnabled = v
end, jumpHackEnabled)

CreateToggle(ScrollFrame, "Anti AFK", function(v)
    antiAFKEnabled = v
    if antiAFKEnabled then
        EnableAntiAFK()
    else
        DisableAntiAFK()
    end
end, antiAFKEnabled)

CreateButton(ScrollFrame, "🔥 Teleport to Campfire", function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(CampfirePosition)
        showNotification("Teleported to Campfire!")
    end
end)

-- Обработчик открытия/закрытия меню
OpenButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    if MainFrame.Visible then
        OpenButton.Text = "✕"
        OpenButton.BackgroundColor3 = Color3.fromRGB(60, 0, 120)
    else
        OpenButton.Text = "☰"
        OpenButton.BackgroundColor3 = Color3.fromRGB(30, 0, 60)
    end
end)

-- NoClip функция
CreateToggle(ScrollFrame, "NoClip", function(v)
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

-- Jump Hack обработчик
UserInputService.JumpRequest:Connect(function()
    if jumpHackEnabled and player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Восстанавливаем настройки после смерти
player.CharacterAdded:Connect(function()
    wait(2)
    
    if speedHackEnabled then
        wait(1)
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = currentSpeed
        end
    end
    
    if antiAFKEnabled then
        EnableAntiAFK()
    end
end)

showNotification("SANSTRO 99 Nights Menu Loaded!")