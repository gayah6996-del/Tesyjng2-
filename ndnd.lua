-- Создание основного GUI
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GameMenu"
ScreenGui.Parent = PlayerGui

-- Создаем систему уведомлений
local NotificationFrame = Instance.new("Frame")
NotificationFrame.Size = UDim2.new(0, 200, 0, 50)
NotificationFrame.Position = UDim2.new(1, -210, 1, -60)
NotificationFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
NotificationFrame.BorderSizePixel = 0
NotificationFrame.Visible = false
NotificationFrame.ZIndex = 20
NotificationFrame.Parent = ScreenGui

local NotificationCorner = Instance.new("UICorner")
NotificationCorner.CornerRadius = UDim.new(0, 8)
NotificationCorner.Parent = NotificationFrame

local NotificationLabel = Instance.new("TextLabel")
NotificationLabel.Size = UDim2.new(1, -10, 1, -10)
NotificationLabel.Position = UDim2.new(0, 5, 0, 5)
NotificationLabel.BackgroundTransparency = 1
NotificationLabel.Text = "Notification"
NotificationLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
NotificationLabel.TextSize = 14
NotificationLabel.Font = Enum.Font.GothamBold
NotificationLabel.Parent = NotificationFrame

local function ShowNotification(message, duration)
    duration = duration or 3
    NotificationLabel.Text = message
    NotificationFrame.Visible = true
    
    -- Анимация появления
    NotificationFrame.Position = UDim2.new(1, -210, 1, -60)
    
    wait(duration)
    
    -- Анимация исчезновения
    NotificationFrame.Visible = false
end

-- Кнопка показа меню (всегда видна)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 60, 0, 60)
ToggleButton.Position = UDim2.new(0, 10, 0, 10)
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Text = "VEX OP"
ToggleButton.TextSize = 12
ToggleButton.ZIndex = 10
ToggleButton.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 10)
ToggleCorner.Parent = ToggleButton

-- Переменные для перемещения кнопки VEX OP
local ToggleDragging = false
local ToggleDragStartPos = nil
local ToggleStartPos = nil

-- Функции для перемещения кнопки VEX OP
local function startToggleDragging(input)
    ToggleDragging = true
    ToggleDragStartPos = Vector2.new(input.Position.X, input.Position.Y)
    ToggleStartPos = UDim2.new(ToggleButton.Position.X.Scale, ToggleButton.Position.X.Offset, ToggleButton.Position.Y.Scale, ToggleButton.Position.Y.Offset)
    
    -- Визуальная обратная связь
    ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
end

local function stopToggleDragging()
    ToggleDragging = false
    ToggleDragStartPos = nil
    ToggleStartPos = nil
    ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
end

local function updateToggleDrag(input)
    if ToggleDragging and ToggleDragStartPos and ToggleStartPos then
        local delta = Vector2.new(input.Position.X, input.Position.Y) - ToggleDragStartPos
        local newX = ToggleStartPos.X.Offset + delta.X
        local newY = ToggleStartPos.Y.Offset + delta.Y
        
        -- Ограничение, чтобы кнопка не выходила за экран
        local screenSize = PlayerGui.AbsoluteSize
        newX = math.clamp(newX, 0, screenSize.X - ToggleButton.AbsoluteSize.X)
        newY = math.clamp(newY, 0, screenSize.Y - ToggleButton.AbsoluteSize.Y)
        
        ToggleButton.Position = UDim2.new(0, newX, 0, newY)
    end
end

-- Обработчики для перемещения кнопки VEX OP
ToggleButton.InputBegan:Connect(function(input)
    startToggleDragging(input)
end)

ToggleButton.InputEnded:Connect(function(input)
    stopToggleDragging()
end)

UserInputService.InputChanged:Connect(function(input)
    if ToggleDragging then
        updateToggleDrag(input)
    elseif Dragging then
        updateDrag(input)
    elseif Resizing then
        updateResize(input)
    end
end)

-- Основное окно меню
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 450)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Элемент для изменения размера (правый нижний угол)
local ResizeHandle = Instance.new("Frame")
ResizeHandle.Size = UDim2.new(0, 30, 0, 30)
ResizeHandle.Position = UDim2.new(1, -30, 1, -30)
ResizeHandle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ResizeHandle.BorderSizePixel = 0
ResizeHandle.ZIndex = 5
ResizeHandle.Active = true
ResizeHandle.Parent = MainFrame

local ResizeCorner = Instance.new("UICorner")
ResizeCorner.CornerRadius = UDim.new(0, 4)
ResizeCorner.Parent = ResizeHandle

-- Заголовок для перемещения
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.Text = "VEX OP - 99 Nights in the Forest"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.Active = true
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = Title

-- Кнопка сворачивания в заголовке
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(1, -70, 0, 5)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 16
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Parent = Title

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 6)
MinimizeCorner.Parent = MinimizeButton

-- Кнопка закрытия в заголовке
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 16
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = Title

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

-- Кнопки вкладок
local TabsFrame = Instance.new("Frame")
TabsFrame.Size = UDim2.new(1, 0, 0, 35)
TabsFrame.Position = UDim2.new(0, 0, 0, 40)
TabsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TabsFrame.BorderSizePixel = 0
TabsFrame.Parent = MainFrame

-- Создаем 7 вкладок как на скриншоте
local tabNames = {"Main", "Auto", "Bring", "Combat", "Player", "Esp", "Teleport"}
local tabButtons = {}
local tabFrames = {}

for i, tabName in ipairs(tabNames) do
    -- Создаем кнопку вкладки
    local tabButton = Instance.new("TextButton")
    tabButton.Size = UDim2.new(1/7, 0, 1, 0)
    tabButton.Position = UDim2.new((i-1)/7, 0, 0, 0)
    tabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    tabButton.Text = tabName
    tabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    tabButton.TextSize = 12
    tabButton.Font = Enum.Font.GothamBold
    tabButton.Parent = TabsFrame
    
    -- Создаем фрейм для контента вкладки
    local tabFrame = Instance.new("Frame")
    tabFrame.Size = UDim2.new(1, 0, 0, 0)
    tabFrame.BackgroundTransparency = 1
    tabFrame.BorderSizePixel = 0
    tabFrame.AutomaticSize = Enum.AutomaticSize.Y
    tabFrame.Visible = false
    tabFrame.Parent = MainFrame
    
    local tabListLayout = Instance.new("UIListLayout")
    tabListLayout.Padding = UDim.new(0, 8)
    tabListLayout.Parent = tabFrame
    
    tabButtons[tabName] = tabButton
    tabFrames[tabName] = tabFrame
end

-- Основной контейнер с прокруткой
local ScrollContainer = Instance.new("ScrollingFrame")
ScrollContainer.Size = UDim2.new(1, -10, 1, -85)
ScrollContainer.Position = UDim2.new(0, 5, 0, 80)
ScrollContainer.BackgroundTransparency = 1
ScrollContainer.BorderSizePixel = 0
ScrollContainer.ScrollBarThickness = 8
ScrollContainer.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
ScrollContainer.VerticalScrollBarInset = Enum.ScrollBarInset.Always
ScrollContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollContainer.Parent = MainFrame

-- Content frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 0, 0)
ContentFrame.BackgroundTransparency = 1
ContentFrame.AutomaticSize = Enum.AutomaticSize.Y
ContentFrame.Parent = ScrollContainer

-- Помещаем все вкладки в ContentFrame
for _, tabFrame in pairs(tabFrames) do
    tabFrame.Parent = ContentFrame
end

-- Переменные для сохранения позиции прокрутки
local LastScrollPositions = {}
local CurrentTab = "Main"

-- Переменные для функций
local ActiveKillAura = false
local ActiveAutoChopTree = false
local DistanceForKillAura = 25
local DistanceForAutoChopTree = 25

-- Переменные для изменения размера
local Resizing = false
local ResizeStart = nil
local StartSize = nil

-- Переменные для перемещения меню
local Dragging = false
local DragStartPos = nil
local MenuStartPos = nil

-- Координаты костра
local CampfirePosition = Vector3.new(0, 10, 0)

-- Новые переменные для телепортации предметов
local BringCount = 2
local BringDelay = 600

-- Функция создания элементов UI
local function CreateSection(parent, title)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, 0, 0, 0)
    section.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    section.BorderSizePixel = 0
    section.AutomaticSize = Enum.AutomaticSize.Y
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
    content.AutomaticSize = Enum.AutomaticSize.Y
    content.Parent = section
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 5)
    contentLayout.Parent = content
    
    -- Автоматическое обновление размера секции
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        section.Size = UDim2.new(1, 0, 0, 25 + contentLayout.AbsoluteContentSize.Y)
    end)
    
    return section, content
end

local function CreateToggle(parent, text, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, 0, 0, 30)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = parent
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(1, 0, 1, 0)
    toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
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
    toggleStatus.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    toggleStatus.Parent = toggleButton
    
    local toggleStatusCorner = Instance.new("UICorner")
    toggleStatusCorner.CornerRadius = UDim.new(0, 10)
    toggleStatusCorner.Parent = toggleStatus
    
    local isToggled = false
    
    local function updateToggle()
        if isToggled then
            toggleStatus.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
        else
            toggleStatus.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
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
    sliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    sliderBar.Parent = sliderFrame
    
    local sliderBarCorner = Instance.new("UICorner")
    sliderBarCorner.CornerRadius = UDim.new(0, 7)
    sliderBarCorner.Parent = sliderBar
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((defaultValue - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
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
        sliderText.Text = text .. ": " .. math.floor(value)
        callback(value)
    end
    
    sliderButton.InputBegan:Connect(function(input)
        isDragging = true
    end)
    
    sliderButton.InputEnded:Connect(function(input)
        isDragging = false
    end)
    
    local function onInputChanged(input)
        if isDragging then
            local relativeX = input.Position.X - sliderBar.AbsolutePosition.X
            local normalized = math.clamp(relativeX / sliderBar.AbsoluteSize.X, 0, 1)
            local value = min + normalized * (max - min)
            updateSlider(value)
        end
    end
    
    UserInputService.InputChanged:Connect(onInputChanged)
    
    updateSlider(defaultValue)
    
    return sliderFrame
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
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
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

-- Функция для создания текстового поля ввода
local function CreateTextBox(parent, text, defaultValue, callback)
    local textBoxFrame = Instance.new("Frame")
    textBoxFrame.Size = UDim2.new(1, 0, 0, 40)
    textBoxFrame.BackgroundTransparency = 1
    textBoxFrame.Parent = parent
    
    local textBoxLabel = Instance.new("TextLabel")
    textBoxLabel.Size = UDim2.new(0.5, -5, 0, 20)
    textBoxLabel.Position = UDim2.new(0, 0, 0, 0)
    textBoxLabel.BackgroundTransparency = 1
    textBoxLabel.Text = text
    textBoxLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBoxLabel.TextSize = 12
    textBoxLabel.TextXAlignment = Enum.TextXAlignment.Left
    textBoxLabel.Font = Enum.Font.Gotham
    textBoxLabel.Parent = textBoxFrame
    
    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0.5, -5, 0, 30)
    textBox.Position = UDim2.new(0.5, 5, 0, 0)
    textBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.Text = tostring(defaultValue)
    textBox.TextSize = 14
    textBox.Font = Enum.Font.Gotham
    textBox.Parent = textBoxFrame
    
    local textBoxCorner = Instance.new("UICorner")
    textBoxCorner.CornerRadius = UDim.new(0, 6)
    textBoxCorner.Parent = textBox
    
    textBox.FocusLost:Connect(function()
        local value = tonumber(textBox.Text)
        if value then
            callback(value)
        else
            textBox.Text = tostring(defaultValue)
            ShowNotification("Please enter a valid number!", 2)
        end
    end)
    
    return textBox
end

-- Создание элементов для вкладки Main
local mainSection, mainContent = CreateSection(tabFrames.Main, "Main Functions")
CreateLabel(mainContent, "Welcome to VEX OP - 99 Nights in the Forest\n\nUse the tabs above to access different features:")

CreateButton(mainContent, "Auto Features", function()
    ShowNotification("Switching to Auto tab...", 2)
    switchToTab("Auto")
end)

CreateButton(mainContent, "Bring Items", function()
    ShowNotification("Switching to Bring tab...", 2)
    switchToTab("Bring")
end)

CreateButton(mainContent, "Combat Features", function()
    ShowNotification("Switching to Combat tab...", 2)
    switchToTab("Combat")
end)

-- Создание элементов для вкладки Auto
local autoSection, autoContent = CreateSection(tabFrames.Auto, "Auto Features")
CreateLabel(autoContent, "Automated gameplay features")

local autoTreeSection, autoTreeContent = CreateSection(autoContent, "🪓 Auto Tree")
CreateSlider(autoTreeContent, "Distance", 0, 1000, 25, function(value)
    DistanceForAutoChopTree = value
end)

local autoChopToggle = CreateToggle(autoTreeContent, "Auto Tree", function(value)
    ActiveAutoChopTree = value
end)

-- Создание элементов для вкладки Bring
local bringSection, bringContent = CreateSection(tabFrames.Bring, "Bring Items")
CreateLabel(bringContent, "Bring Medical Items\nPlease unlock first zone before trying to Bring!")

local medicalSection, medicalContent = CreateSection(bringContent, "Medical Items")
CreateButton(medicalContent, "Bring Bandages", function()
    ShowNotification("Bringing Bandages...", 2)
end)

CreateButton(medicalContent, "Bring Medkits", function()
    ShowNotification("Bringing Medkits...", 2)
end)

local equipmentSection, equipmentContent = CreateSection(bringContent, "Equipment")
CreateLabel(equipmentContent, "Select Equipment Items\nChoose items to bring")

CreateButton(equipmentContent, "Bring Equipment Items", function()
    ShowNotification("Bring Equipment Items\nPlease unlock first zone before trying to Bring!", 2)
end)

-- Создание элементов для вкладки Combat
local combatSection, combatContent = CreateSection(tabFrames.Combat, "Combat Features")
CreateLabel(combatContent, "Combat and enemy interaction features")

local killAuraSection, killAuraContent = CreateSection(combatContent, "⚔️ Kill Aura")
CreateSlider(killAuraContent, "Distance", 25, 10000, 25, function(value)
    DistanceForKillAura = value
end)

local killAuraToggle = CreateToggle(killAuraContent, "Kill Aura", function(value)
    ActiveKillAura = value
end)

-- Создание элементов для вкладки Player
local playerSection, playerContent = CreateSection(tabFrames.Player, "Player Features")
CreateLabel(playerContent, "Player-related functions and utilities")

CreateButton(playerContent, "Jump", function()
    local character = Player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    
    if not humanoid then 
        ShowNotification("Character not found!", 2)
        return
    end
    
    humanoid.Jump = true
    ShowNotification("Character jumped!", 1)
end)

-- Создание элементов для вкладки Esp
local espSection, espContent = CreateSection(tabFrames.Esp, "ESP Features")
CreateLabel(espContent, "Visual enhancement features\n\nESP functionality will be added in future updates")

CreateButton(espContent, "Toggle Item ESP", function()
    ShowNotification("Item ESP feature coming soon!", 2)
end)

CreateButton(espContent, "Toggle Player ESP", function()
    ShowNotification("Player ESP feature coming soon!", 2)
end)

-- Создание элементов для вкладки Teleport
local teleportSection, teleportContent = CreateSection(tabFrames.Teleport, "Teleport Features")
CreateLabel(teleportContent, "Teleportation and movement features")

CreateButton(teleportContent, "Teleport to Base", function()
    local character = Player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = CFrame.new(CampfirePosition)
        ShowNotification("Teleported to campfire!", 2)
    else
        ShowNotification("Character not found!", 2)
    end
end)

-- Функционал переключения вкладок
local function switchToTab(tabName)
    -- Сбрасываем все вкладки
    for name, button in pairs(tabButtons) do
        button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        button.TextColor3 = Color3.fromRGB(200, 200, 200)
        tabFrames[name].Visible = false
    end
    
    -- Устанавливаем активную вкладку
    tabButtons[tabName].BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    tabButtons[tabName].TextColor3 = Color3.fromRGB(255, 255, 255)
    tabFrames[tabName].Visible = true
    CurrentTab = tabName
end

-- Подключаем обработчики для вкладок
for tabName, button in pairs(tabButtons) do
    button.MouseButton1Click:Connect(function()
        switchToTab(tabName)
    end)
end

-- Инициализируем позиции прокрутки
for _, tabName in ipairs(tabNames) do
    LastScrollPositions[tabName] = Vector2.new(0, 0)
end

-- Система перемещения меню
local function startDragging(input)
    Dragging = true
    DragStartPos = Vector2.new(input.Position.X, input.Position.Y)
    MenuStartPos = UDim2.new(MainFrame.Position.X.Scale, MainFrame.Position.X.Offset, MainFrame.Position.Y.Scale, MainFrame.Position.Y.Offset)
    
    Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
end

local function stopDragging()
    Dragging = false
    DragStartPos = nil
    MenuStartPos = nil
    Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
end

local function updateDrag(input)
    if Dragging and DragStartPos and MenuStartPos then
        local delta = Vector2.new(input.Position.X, input.Position.Y) - DragStartPos
        local newX = MenuStartPos.X.Offset + delta.X
        local newY = MenuStartPos.Y.Offset + delta.Y
        
        local screenSize = PlayerGui.AbsoluteSize
        newX = math.clamp(newX, 0, screenSize.X - MainFrame.AbsoluteSize.X)
        newY = math.clamp(newY, 0, screenSize.Y - MainFrame.AbsoluteSize.Y)
        
        MainFrame.Position = UDim2.new(0, newX, 0, newY)
    end
end

-- Система изменения размера меню
local function startResize(input)
    Resizing = true
    ResizeStart = Vector2.new(input.Position.X, input.Position.Y)
    StartSize = UDim2.new(MainFrame.Size.X.Scale, MainFrame.Size.X.Offset, MainFrame.Size.Y.Scale, MainFrame.Size.Y.Offset)
    
    ResizeHandle.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
end

local function stopResize()
    Resizing = false
    ResizeStart = nil
    StartSize = nil
    ResizeHandle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
end

local function updateResize(input)
    if Resizing and ResizeStart and StartSize then
        local delta = Vector2.new(input.Position.X, input.Position.Y) - ResizeStart
        
        local minWidth = 300
        local minHeight = 350
        
        local newWidth = math.max(minWidth, StartSize.X.Offset + delta.X)
        local newHeight = math.max(minHeight, StartSize.Y.Offset + delta.Y)
        
        MainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
    end
end

-- Обработчики для перемещения меню
Title.InputBegan:Connect(function(input)
    startDragging(input)
end)

Title.InputEnded:Connect(function(input)
    stopDragging()
end)

-- Обработчики для изменения размера
ResizeHandle.InputBegan:Connect(function(input)
    startResize(input)
end)

ResizeHandle.InputEnded:Connect(function(input)
    stopResize()
end)

-- Закрытие меню полностью
CloseButton.MouseButton1Click:Connect(function()
    LastScrollPositions[CurrentTab] = ScrollContainer.CanvasPosition
    MainFrame.Visible = false
    ToggleButton.Visible = false
    ShowNotification("Menu closed completely", 2)
end)

-- Сворачивание меню
MinimizeButton.MouseButton1Click:Connect(function()
    LastScrollPositions[CurrentTab] = ScrollContainer.CanvasPosition
    MainFrame.Visible = false
    ShowNotification("Menu minimized", 2)
end)

-- Переключение видимости меню
ToggleButton.MouseButton1Click:Connect(function()
    if MainFrame.Visible then
        LastScrollPositions[CurrentTab] = ScrollContainer.CanvasPosition
        MainFrame.Visible = false
    else
        ScrollContainer.CanvasPosition = LastScrollPositions[CurrentTab]
        MainFrame.Visible = true
        ToggleButton.Visible = true
    end
end)

-- Сохраняем позицию прокрутки при изменении
ScrollContainer:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
    if MainFrame.Visible then
        LastScrollPositions[CurrentTab] = ScrollContainer.CanvasPosition
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

-- По умолчанию открываем вкладку Main
switchToTab("Main")

print("VEX OP - 99 Nights in the Forest menu loaded! Drag the VEX OP button to move it.")