-- Создание основного GUI
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GameMenu"
ScreenGui.Parent = PlayerGui

-- Создаем улучшенную систему уведомлений
local NotificationFrame = Instance.new("Frame")
NotificationFrame.Size = UDim2.new(0, 250, 0, 60)
NotificationFrame.Position = UDim2.new(1, -260, 1, -70)
NotificationFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
NotificationFrame.BorderSizePixel = 0
NotificationFrame.Visible = false
NotificationFrame.ZIndex = 100
NotificationFrame.Parent = ScreenGui

local NotificationCorner = Instance.new("UICorner")
NotificationCorner.CornerRadius = UDim.new(0, 8)
NotificationCorner.Parent = NotificationFrame

local NotificationLabel = Instance.new("TextLabel")
NotificationLabel.Size = UDim2.new(1, -20, 1, -20)
NotificationLabel.Position = UDim2.new(0, 10, 0, 10)
NotificationLabel.BackgroundTransparency = 1
NotificationLabel.Text = "Bandage None"
NotificationLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
NotificationLabel.TextSize = 16
NotificationLabel.Font = Enum.Font.GothamBold
NotificationLabel.TextWrapped = true
NotificationLabel.Parent = NotificationFrame

-- Улучшенная функция уведомлений
local function ShowNotification(message, duration)
    duration = duration or 3
    
    -- Обновляем текст
    NotificationLabel.Text = message
    
    -- Показываем уведомление
    NotificationFrame.Visible = true
    
    -- Используем spawn чтобы не блокировать основной поток
    spawn(function()
        -- Ждем указанное время
        wait(duration)
        
        -- Скрываем уведомление
        NotificationFrame.Visible = false
    end)
end

-- Кнопка показа меню (всегда видна)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 60, 0, 60)
ToggleButton.Position = UDim2.new(0, 10, 0, 10)
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Text = "≡"
ToggleButton.TextSize = 30
ToggleButton.ZIndex = 10
ToggleButton.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 10)
ToggleCorner.Parent = ToggleButton

-- Основное окно меню
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 400)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Заголовок для перемещения
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.Text = "ASTRALCHEAT"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Кнопка закрытия в заголовке
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 2)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 16
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = Title

local UICorner2 = Instance.new("UICorner")
UICorner2.CornerRadius = UDim.new(0, 6)
UICorner2.Parent = CloseButton

-- Кнопки вкладок
local TabsFrame = Instance.new("Frame")
TabsFrame.Size = UDim2.new(1, 0, 0, 30)
TabsFrame.Position = UDim2.new(0, 0, 0, 35)
TabsFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TabsFrame.BorderSizePixel = 0
TabsFrame.Parent = MainFrame

local InfoTabButton = Instance.new("TextButton")
InfoTabButton.Size = UDim2.new(0.33, 0, 1, 0)
InfoTabButton.Position = UDim2.new(0, 0, 0, 0)
InfoTabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
InfoTabButton.Text = "Info"
InfoTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
InfoTabButton.TextSize = 14
InfoTabButton.Font = Enum.Font.GothamBold
InfoTabButton.Parent = TabsFrame

local GameTabButton = Instance.new("TextButton")
GameTabButton.Size = UDim2.new(0.33, 0, 1, 0)
GameTabButton.Position = UDim2.new(0.33, 0, 0, 0)
GameTabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
GameTabButton.Text = "Game"
GameTabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
GameTabButton.TextSize = 14
GameTabButton.Font = Enum.Font.GothamBold
GameTabButton.Parent = TabsFrame

local KeksTabButton = Instance.new("TextButton")
KeksTabButton.Size = UDim2.new(0.34, 0, 1, 0)
KeksTabButton.Position = UDim2.new(0.66, 0, 0, 0)
KeksTabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
KeksTabButton.Text = "Keks"
KeksTabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
KeksTabButton.TextSize = 14
KeksTabButton.Font = Enum.Font.GothamBold
KeksTabButton.Parent = TabsFrame

-- Content frames
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -10, 1, -75)
ContentFrame.Position = UDim2.new(0, 5, 0, 70)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Info Tab Content
local InfoTab = Instance.new("ScrollingFrame")
InfoTab.Size = UDim2.new(1, 0, 1, 0)
InfoTab.BackgroundTransparency = 1
InfoTab.BorderSizePixel = 0
InfoTab.ScrollBarThickness = 6
InfoTab.Visible = true
InfoTab.Parent = ContentFrame

local InfoListLayout = Instance.new("UIListLayout")
InfoListLayout.Padding = UDim.new(0, 8)
InfoListLayout.Parent = InfoTab

-- Game Tab Content
local GameTab = Instance.new("ScrollingFrame")
GameTab.Size = UDim2.new(1, 0, 1, 0)
GameTab.BackgroundTransparency = 1
GameTab.BorderSizePixel = 0
GameTab.ScrollBarThickness = 6
GameTab.Visible = false
GameTab.Parent = ContentFrame

local GameListLayout = Instance.new("UIListLayout")
GameListLayout.Padding = UDim.new(0, 8)
GameListLayout.Parent = GameTab

-- Keks Tab Content
local KeksTab = Instance.new("ScrollingFrame")
KeksTab.Size = UDim2.new(1, 0, 1, 0)
KeksTab.BackgroundTransparency = 1
KeksTab.BorderSizePixel = 0
KeksTab.ScrollBarThickness = 6
KeksTab.Visible = false
KeksTab.Parent = ContentFrame

local KeksListLayout = Instance.new("UIListLayout")
KeksListLayout.Padding = UDim.new(0, 8)
KeksListLayout.Parent = KeksTab

-- Переменные для функций
local ActiveKillAura = false
local ActiveAutoChopTree = false
local DistanceForKillAura = 25
local DistanceForAutoChopTree = 25

-- Функция создания элементов UI
local function CreateSection(parent, title)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, 0, 0, 0)
    section.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    section.BorderSizePixel = 0
    section.Parent = parent
    
    local sectionCorner = Instance.new("UICorner")
    sectionCorner.CornerRadius = UDim.new(0, 6)
    sectionCorner.Parent = section
    
    local sectionTitle = Instance.new("TextLabel")
    sectionTitle.Size = UDim2.new(1, -10, 0, 25)
    sectionTitle.Position = UDim2.new(0, 5, 0, 0)
    sectionTitle.BackgroundTransparency = 1
    sectionTitle.Text = title
    sectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    sectionTitle.TextSize = 14
    sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    sectionTitle.Font = Enum.Font.GothamBold
    sectionTitle.Parent = section
    
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -10, 0, 0)
    content.Position = UDim2.new(0, 5, 0, 25)
    content.BackgroundTransparency = 1
    content.Parent = section
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 5)
    contentLayout.Parent = content
    
    return section, content
end

local function CreateToggle(parent, text, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, 0, 0, 30)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = parent
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(1, 0, 1, 0)
    toggleButton.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
    toggleButton.Text = ""
    toggleButton.Parent = toggleFrame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 4)
    toggleCorner.Parent = toggleButton
    
    local toggleText = Instance.new("TextLabel")
    toggleText.Size = UDim2.new(0.7, 0, 1, 0)
    toggleText.Position = UDim2.new(0, 8, 0, 0)
    toggleText.BackgroundTransparency = 1
    toggleText.Text = text
    toggleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleText.TextSize = 12
    toggleText.TextXAlignment = Enum.TextXAlignment.Left
    toggleText.Font = Enum.Font.Gotham
    toggleText.Parent = toggleButton
    
    local toggleStatus = Instance.new("Frame")
    toggleStatus.Size = UDim2.new(0, 20, 0, 20)
    toggleStatus.Position = UDim2.new(1, -25, 0.5, -10)
    toggleStatus.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    toggleStatus.Parent = toggleButton
    
    local toggleStatusCorner = Instance.new("UICorner")
    toggleStatusCorner.CornerRadius = UDim.new(0, 10)
    toggleStatusCorner.Parent = toggleStatus
    
    local isToggled = false
    
    local function updateToggle()
        if isToggled then
            toggleStatus.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        else
            toggleStatus.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        end
    end
    
    toggleButton.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        updateToggle()
        callback(isToggled)
    end)
    
    updateToggle()
    
    return {
        Set = function(value)
            isToggled = value
            updateToggle()
            callback(value)
        end
    }
end

local function CreateSlider(parent, text, min, max, defaultValue, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, 0, 0, 50)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = parent
    
    local sliderText = Instance.new("TextLabel")
    sliderText.Size = UDim2.new(1, 0, 0, 20)
    sliderText.BackgroundTransparency = 1
    sliderText.Text = text .. ": " .. defaultValue
    sliderText.TextColor3 = Color3.fromRGB(255, 255, 255)
    sliderText.TextSize = 12
    sliderText.TextXAlignment = Enum.TextXAlignment.Left
    sliderText.Font = Enum.Font.Gotham
    sliderText.Parent = sliderFrame
    
    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new(1, 0, 0, 15)
    sliderBar.Position = UDim2.new(0, 0, 0, 20)
    sliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    sliderBar.Parent = sliderFrame
    
    local sliderBarCorner = Instance.new("UICorner")
    sliderBarCorner.CornerRadius = UDim.new(0, 7)
    sliderBarCorner.Parent = sliderBar
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((defaultValue - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    sliderFill.Parent = sliderBar
    
    local sliderFillCorner = Instance.new("UICorner")
    sliderFillCorner.CornerRadius = UDim.new(0, 7)
    sliderFillCorner.Parent = sliderFill
    
    local sliderButton = Instance.new("TextButton")
    sliderButton.Size = UDim2.new(1, 0, 1, 0)
    sliderButton.BackgroundTransparency = 1
    sliderButton.Text = ""
    sliderButton.Parent = sliderBar
    
    local isDragging = false
    
    local function updateSlider(value)
        local normalized = math.clamp((value - min) / (max - min), 0, 1)
        sliderFill.Size = UDim2.new(normalized, 0, 1, 0)
        sliderText.Text = text .. ": " .. math.floor(value * 10) / 10
        callback(value)
    end
    
    -- Обработка для мобильного устройства
    sliderButton.MouseButton1Down:Connect(function()
        isDragging = true
    end)
    
    sliderButton.MouseButton1Up:Connect(function()
        isDragging = false
    end)
    
    sliderButton.MouseLeave:Connect(function()
        isDragging = false
    end)
    
    local function onTouchInput(input)
        if isDragging and input.UserInputType == Enum.UserInputType.Touch then
            local relativeX = input.Position.X - sliderBar.AbsolutePosition.X
            local normalized = math.clamp(relativeX / sliderBar.AbsoluteSize.X, 0, 1)
            local value = min + normalized * (max - min)
            updateSlider(value)
        end
    end
    
    UserInputService.InputChanged:Connect(onTouchInput)
    
    updateSlider(defaultValue)
end

local function CreateLabel(parent, text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 12
    label.TextWrapped = true
    label.Font = Enum.Font.Gotham
    label.Parent = parent
    label.AutomaticSize = Enum.AutomaticSize.Y
    return label
end

local function CreateButton(parent, text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 35)
    button.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    button.Font = Enum.Font.Gotham
    button.Parent = parent
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = button
    
    button.MouseButton1Click:Connect(callback)
    
    return button
end

-- Создание элементов Info tab
local infoSection, infoContent = CreateSection(InfoTab, "📋 Script Information")
CreateLabel(infoContent, "99 Nights In The Forest\nMobile Script Menu\n\nVersion: 0.31\n\nFunctions from original Game tab\n\nTap the title bar to move the menu")

local controlsSection, controlsContent = CreateSection(InfoTab, "🎮 Controls")
CreateLabel(controlsContent, "- Tap ≡ button to show/hide menu\n- Drag title bar to move menu\n- Toggle switches to enable features\n- Adjust sliders for distance settings")

local noteSection, noteContent = CreateSection(InfoTab, "💡 Important Note")
CreateLabel(noteContent, "For Auto Tree and Kill Aura to work, you MUST equip any axe (Old Axe, Good Axe, Strong Axe, or Chainsaw)!")

-- Создание элементов Game tab
local killAuraSection, killAuraContent = CreateSection(GameTab, "⚔️ Kill Aura")
CreateSlider(killAuraContent, "Distance", 25, 10000, 25, function(value)
    DistanceForKillAura = value
end)

local killAuraToggle = CreateToggle(killAuraContent, "Kill Aura", function(value)
    ActiveKillAura = value
end)

local autoChopSection, autoChopContent = CreateSection(GameTab, "🪓 Auto Tree")
CreateSlider(autoChopContent, "Distance", 0, 1000, 25, function(value)
    DistanceForAutoChopTree = value
end)

local autoChopToggle = CreateToggle(autoChopContent, "Auto Tree", function(value)
    ActiveAutoChopTree = value
end)

-- Создание элементов Keks tab
local teleportSection, teleportContent = CreateSection(KeksTab, "🚀 Teleport")
CreateButton(teleportContent, "Teleport to Base", function()
    -- Телепорт на базу (координаты нужно уточнить)
    local character = Player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        -- Замените эти координаты на реальные координаты базы
        character.HumanoidRootPart.CFrame = CFrame.new(0, 10, 0)
        ShowNotification("Teleported to base!", 3)
    end
end)

local itemSection, itemContent = CreateSection(KeksTab, "🎒 Items")
CreateButton(itemContent, "Find Bandages", function()
    -- Поиск бандажей
    local character = Player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then 
        ShowNotification("Character not found!", 3)
        return 
    end
    
    local bandages = {}
    
    -- Ищем бандажи в рабочем пространстве
    for _, item in pairs(workspace:GetDescendants()) do
        if item.Name == "Bandage" and item:IsA("Part") then
            table.insert(bandages, item)
        end
    end
    
    if #bandages > 0 then
        -- Телепортируемся к первому найденному бандажу
        character.HumanoidRootPart.CFrame = bandages[1].CFrame + Vector3.new(0, 3, 0)
        ShowNotification("Found " .. #bandages .. " bandages!", 3)
        print("Found " .. #bandages .. " bandages! Teleported to the first one.")
    else
        -- Показываем уведомление "Bandage None"
        ShowNotification("Bandage None", 3)
        print("No bandages found in the map.")
    end
end)

-- НОВАЯ КНОПКА: All fuel
CreateButton(itemContent, "All fuel", function()
    -- Притягивание всех канистр с топливом
    local character = Player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then 
        ShowNotification("Character not found!", 3)
        return 
    end
    
    local root = character.HumanoidRootPart
    local fuelCanisters = {}
    
    -- Ищем канистры с топливом в рабочем пространстве
    for _, item in pairs(workspace:GetDescendants()) do
        if item:IsA("Model") and item.Name:lower():find("fuel canister") then
            local main = item:FindFirstChildWhichIsA("BasePart")
            if main then
                table.insert(fuelCanisters, {model = item, main = main})
            end
        end
    end
    
    -- Также проверяем папку Items, если она существует
    if workspace:FindFirstChild("Items") then
        for _, item in pairs(workspace.Items:GetChildren()) do
            if item:IsA("Model") and item.Name:lower():find("fuel canister") then
                local main = item:FindFirstChildWhichIsA("BasePart")
                if main then
                    table.insert(fuelCanisters, {model = item, main = main})
                end
            end
        end
    end
    
    if #fuelCanisters > 0 then
        -- Перемещаем все канистры к игроку
        for _, fuel in pairs(fuelCanisters) do
            fuel.main.CFrame = root.CFrame * CFrame.new(math.random(-5,5), 0, math.random(-5,5))
        end
        ShowNotification("Brought " .. #fuelCanisters .. " fuel canisters!", 3)
        print("Brought " .. #fuelCanisters .. " fuel canisters to your location.")
    else
        ShowNotification("No fuel canisters found!", 3)
        print("No fuel canisters found in the map.")
    end
end)

-- Функции из оригинального скрипта
-- Kill Aura функция
task.spawn(function()
    while true do
        if ActiveKillAura then 
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local hrp = character:WaitForChild("HumanoidRootPart")
            local weapon = (player.Inventory:FindFirstChild("Old Axe") or player.Inventory:FindFirstChild("Good Axe") or player.Inventory:FindFirstChild("Strong Axe") or player.Inventory:FindFirstChild("Chainsaw"))

            for _, bunny in pairs(workspace.Characters:GetChildren()) do
                if bunny:IsA("Model") and bunny.PrimaryPart then
                    local distance = (bunny.PrimaryPart.Position - hrp.Position).Magnitude
                    if distance <= DistanceForKillAura then
                        task.spawn(function()	
                            local result = game:GetService("ReplicatedStorage").RemoteEvents.ToolDamageObject:InvokeServer(bunny, weapon, 999, hrp.CFrame)
                        end)	
                    end
                end
            end
        end
        wait(0.01)
    end
end)

-- Auto Chop Tree функция
task.spawn(function()
    while true do
        if ActiveAutoChopTree then 
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local hrp = character:WaitForChild("HumanoidRootPart")
            local weapon = (player.Inventory:FindFirstChild("Old Axe") or player.Inventory:FindFirstChild("Good Axe") or player.Inventory:FindFirstChild("Strong Axe") or player.Inventory:FindFirstChild("Chainsaw"))
            
            for _, bunny in pairs(workspace.Map.Foliage:GetChildren()) do
                if bunny:IsA("Model") and (bunny.Name == "Small Tree" or bunny.Name == "TreeBig1" or bunny.Name == "TreeBig2")  and bunny.PrimaryPart then
                    local distance = (bunny.PrimaryPart.Position - hrp.Position).Magnitude
                    if distance <= DistanceForAutoChopTree then
                        task.spawn(function()		
                            local result = game:GetService("ReplicatedStorage").RemoteEvents.ToolDamageObject:InvokeServer(bunny, weapon, 999, hrp.CFrame)
                        end)		
                    end
                end
            end 
            
            for _, bunny in pairs(workspace.Map.Landmarks:GetChildren()) do
                if bunny:IsA("Model") and (bunny.Name == "Small Tree" or bunny.Name == "TreeBig1" or bunny.Name == "TreeBig2")  and bunny.PrimaryPart then
                    local distance = (bunny.PrimaryPart.Position - hrp.Position).Magnitude
                    if distance <= DistanceForAutoChopTree then
                        task.spawn(function()	
                            local result = game:GetService("ReplicatedStorage").RemoteEvents.ToolDamageObject:InvokeServer(bunny, weapon, 999, hrp.CFrame)
                        end)			
                    end
                end
            end
        end
        wait(0.01)
    end
end)

-- Обновление размеров секций после добавления контента
game:GetService("RunService").Heartbeat:Connect(function()
    for _, tab in pairs({InfoTab, GameTab, KeksTab}) do
        for _, section in pairs(tab:GetChildren()) do
            if section:IsA("Frame") and section:FindFirstChildWhichIsA("Frame") then
                local content = section:FindFirstChildWhichIsA("Frame")
                if content and content:FindFirstChildOfClass("UIListLayout") then
                    section.Size = UDim2.new(1, 0, 0, 25 + content.UIListLayout.AbsoluteContentSize.Y)
                end
            end
        end
        
        tab.CanvasSize = UDim2.new(0, 0, 0, tab.UIListLayout.AbsoluteContentSize.Y + 10)
    end
end)

-- Функционал переключения вкладок
local function switchToTab(tabName)
    InfoTabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    GameTabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    KeksTabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    
    InfoTabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    GameTabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    KeksTabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    
    InfoTab.Visible = false
    GameTab.Visible = false
    KeksTab.Visible = false
    
    if tabName == "Info" then
        InfoTabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        InfoTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        InfoTab.Visible = true
    elseif tabName == "Game" then
        GameTabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        GameTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        GameTab.Visible = true
    elseif tabName == "Keks" then
        KeksTabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        KeksTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        KeksTab.Visible = true
    end
end

InfoTabButton.MouseButton1Click:Connect(function()
    switchToTab("Info")
end)

GameTabButton.MouseButton1Click:Connect(function()
    switchToTab("Game")
end)

KeksTabButton.MouseButton1Click:Connect(function()
    switchToTab("Keks")
end)

-- Система перемещения меню для мобильных устройств
local dragging = false
local dragStartPos = nil
local menuStartPos = nil

local function startDragging(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStartPos = Vector2.new(input.Position.X, input.Position.Y)
        menuStartPos = UDim2.new(MainFrame.Position.X.Scale, MainFrame.Position.X.Offset, MainFrame.Position.Y.Scale, MainFrame.Position.Y.Offset)
    end
end

local function stopDragging()
    dragging = false
    dragStartPos = nil
    menuStartPos = nil
end

local function updateDrag(input)
    if dragging and dragStartPos and menuStartPos then
        local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStartPos
        local newX = menuStartPos.X.Offset + delta.X
        local newY = menuStartPos.Y.Offset + delta.Y
        
        -- Ограничение, чтобы меню не выходило за экран
        local screenSize = PlayerGui.AbsoluteSize
        newX = math.clamp(newX, 0, screenSize.X - MainFrame.AbsoluteSize.X)
        newY = math.clamp(newY, 0, screenSize.Y - MainFrame.AbsoluteSize.Y)
        
        MainFrame.Position = UDim2.new(0, newX, 0, newY)
    end
end

-- Обработчики для перемещения
Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        startDragging(input)
    end
end)

Title.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        stopDragging()
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        updateDrag(input)
    end
end)

-- Закрытие меню
CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- Переключение видимости меню
ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- По умолчанию открываем вкладку Info
switchToTab("Info")

print("Mobile ASTRALCHEAT with 3 tabs and notifications loaded! Tap the ≡ button to open/close. Drag the title to move.")