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
NotificationLabel.Text = "Bandage None"
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
ToggleButton.Size = UDim2.new(0, 70, 0, 70)
ToggleButton.Position = UDim2.new(0, 10, 0, 10)
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Text = "ASTRAL"
ToggleButton.TextSize = 9
ToggleButton.ZIndex = 10
ToggleButton.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 10)
ToggleCorner.Parent = ToggleButton

-- Основное окно меню (УВЕЛИЧЕННЫЙ РАЗМЕР)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 650)  -- Увеличен размер
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -325)  -- Обновлена позиция для центрирования
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

-- Основной контейнер с прокруткой (УВЕЛИЧЕННЫЙ РАЗМЕР)
local ScrollContainer = Instance.new("ScrollingFrame")
ScrollContainer.Size = UDim2.new(1, -10, 1, -75)
ScrollContainer.Position = UDim2.new(0, 5, 0, 70)
ScrollContainer.BackgroundTransparency = 1
ScrollContainer.BorderSizePixel = 0
ScrollContainer.ScrollBarThickness = 8
ScrollContainer.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
ScrollContainer.VerticalScrollBarInset = Enum.ScrollBarInset.Always
ScrollContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollContainer.Parent = MainFrame

-- Content frames
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 0, 0)
ContentFrame.BackgroundTransparency = 1
ContentFrame.AutomaticSize = Enum.AutomaticSize.Y
ContentFrame.Parent = ScrollContainer

-- Info Tab Content
local InfoTab = Instance.new("Frame")
InfoTab.Size = UDim2.new(1, 0, 0, 0)
InfoTab.BackgroundTransparency = 1
InfoTab.BorderSizePixel = 0
InfoTab.AutomaticSize = Enum.AutomaticSize.Y
InfoTab.Visible = true
InfoTab.Parent = ContentFrame

local InfoListLayout = Instance.new("UIListLayout")
InfoListLayout.Padding = UDim.new(0, 8)
InfoListLayout.Parent = InfoTab

-- Game Tab Content
local GameTab = Instance.new("Frame")
GameTab.Size = UDim2.new(1, 0, 0, 0)
GameTab.BackgroundTransparency = 1
GameTab.BorderSizePixel = 0
GameTab.AutomaticSize = Enum.AutomaticSize.Y
GameTab.Visible = false
GameTab.Parent = ContentFrame

local GameListLayout = Instance.new("UIListLayout")
GameListLayout.Padding = UDim.new(0, 8)
GameListLayout.Parent = GameTab

-- Keks Tab Content
local KeksTab = Instance.new("Frame")
KeksTab.Size = UDim2.new(1, 0, 0, 0)
KeksTab.BackgroundTransparency = 1
KeksTab.BorderSizePixel = 0
KeksTab.AutomaticSize = Enum.AutomaticSize.Y
KeksTab.Visible = false
KeksTab.Parent = ContentFrame

local KeksListLayout = Instance.new("UIListLayout")
KeksListLayout.Padding = UDim.new(0, 8)
KeksListLayout.Parent = KeksTab

-- Переменные для сохранения позиции прокрутки
local LastScrollPositions = {
    Info = Vector2.new(0, 0),
    Game = Vector2.new(0, 0),
    Keks = Vector2.new(0, 0)
}
local CurrentTab = "Info"

-- Переменные для функций
local ActiveKillAura = false
local ActiveAutoChopTree = false
local DistanceForKillAura = 25
local DistanceForAutoChopTree = 25
local UpingHeight = 50
local IsUping = false
local UpingConnection = nil
local BodyVelocity = nil

-- Функция создания элементов UI
local function CreateSection(parent, title)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, 0, 0, 0)
    section.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
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

-- Функция для создания выпадающего списка
local function CreateDropdown(parent, options, defaultOption, callback)
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Size = UDim2.new(1, 0, 0, 35)
    dropdownFrame.BackgroundTransparency = 1
    dropdownFrame.Parent = parent
    
    local dropdownButton = Instance.new("TextButton")
    dropdownButton.Size = UDim2.new(1, 0, 1, 0)
    dropdownButton.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
    dropdownButton.Text = defaultOption or options[1]
    dropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdownButton.TextSize = 14
    dropdownButton.Font = Enum.Font.Gotham
    dropdownButton.Parent = dropdownFrame
    
    local dropdownCorner = Instance.new("UICorner")
    dropdownCorner.CornerRadius = UDim.new(0, 6)
    dropdownCorner.Parent = dropdownButton
    
    local dropdownList = Instance.new("ScrollingFrame")
    dropdownList.Size = UDim2.new(1, 0, 0, 0)
    dropdownList.Position = UDim2.new(0, 0, 1, 5)
    dropdownList.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    dropdownList.BorderSizePixel = 0
    dropdownList.ScrollBarThickness = 6
    dropdownList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    dropdownList.Visible = false
    dropdownList.ZIndex = 5
    dropdownList.Parent = ScreenGui  -- Делаем дочерним элементом ScreenGui чтобы был поверх всего
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Parent = dropdownList
    
    local isOpen = false
    local selectedOption = defaultOption or options[1]
    
    local function updateDropdownPosition()
        if dropdownButton:IsDescendantOf(game) then
            local buttonAbsolutePos = dropdownButton.AbsolutePosition
            local buttonAbsoluteSize = dropdownButton.AbsoluteSize
            
            dropdownList.Position = UDim2.new(0, buttonAbsolutePos.X, 0, buttonAbsolutePos.Y + buttonAbsoluteSize.Y + 5)
            dropdownList.Size = UDim2.new(0, buttonAbsoluteSize.X, 0, math.min(#options * 35, 140))
        end
    end
    
    local function toggleDropdown()
        isOpen = not isOpen
        if isOpen then
            updateDropdownPosition()
            dropdownList.Visible = true
        else
            dropdownList.Visible = false
        end
    end
    
    dropdownButton.MouseButton1Click:Connect(toggleDropdown)
    
    -- Обновляем позицию при изменении размера экрана
    game:GetService("RunService").Heartbeat:Connect(function()
        if isOpen then
            updateDropdownPosition()
        end
    end)
    
    for _, option in ipairs(options) do
        local optionButton = Instance.new("TextButton")
        optionButton.Size = UDim2.new(1, 0, 0, 35)
        optionButton.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
        optionButton.Text = option
        optionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        optionButton.TextSize = 14
        optionButton.Font = Enum.Font.Gotham
        optionButton.ZIndex = 6
        optionButton.Parent = dropdownList
        
        local optionCorner = Instance.new("UICorner")
        optionCorner.CornerRadius = UDim.new(0, 6)
        optionCorner.Parent = optionButton
        
        optionButton.MouseButton1Click:Connect(function()
            selectedOption = option
            dropdownButton.Text = option
            toggleDropdown()
            if callback then
                callback(option)
            end
        end)
    end
    
    -- Закрывать выпадающий список при клике вне его
    local function onInputBegan(input)
        if input.UserInputType == Enum.UserInputType.Touch and isOpen then
            local touchPos = input.Position
            local listAbsolutePos = dropdownList.AbsolutePosition
            local listAbsoluteSize = dropdownList.AbsoluteSize
            
            -- Проверяем, был ли клик вне выпадающего списка и кнопки
            if not (touchPos.X >= listAbsolutePos.X and touchPos.X <= listAbsolutePos.X + listAbsoluteSize.X and
                   touchPos.Y >= listAbsolutePos.Y and touchPos.Y <= listAbsolutePos.Y + listAbsoluteSize.Y) and
               not (touchPos.X >= dropdownButton.AbsolutePosition.X and touchPos.X <= dropdownButton.AbsolutePosition.X + dropdownButton.AbsoluteSize.X and
                   touchPos.Y >= dropdownButton.AbsolutePosition.Y and touchPos.Y <= dropdownButton.AbsolutePosition.Y + dropdownButton.AbsoluteSize.Y) then
                toggleDropdown()
            end
        end
    end
    
    UserInputService.InputBegan:Connect(onInputBegan)
    
    return {
        GetValue = function()
            return selectedOption
        end,
        SetValue = function(value)
            selectedOption = value
            dropdownButton.Text = value
        end
    }
end

-- Функция для включения/выключения режима полета
local function ToggleUping()
    local character = Player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    
    if not root or not humanoid then 
        ShowNotification("Character not found!", 2)
        return
    end
    
    IsUping = not IsUping
    
    if IsUping then
        -- Включаем режим полета
        if not BodyVelocity then
            BodyVelocity = Instance.new("BodyVelocity")
            BodyVelocity.Velocity = Vector3.new(0, 0, 0)
            BodyVelocity.MaxForce = Vector3.new(0, 0, 0)
        end
        
        BodyVelocity.Velocity = Vector3.new(0, UpingHeight, 0)
        BodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
        BodyVelocity.Parent = root
        
        -- Сохраняем исходную гравитацию и отключаем ее
        humanoid.PlatformStand = true
        
        UpingButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        UpingButton.Text = "Uping: ON"
        
        -- Запускаем обновление полета
        if UpingConnection then
            UpingConnection:Disconnect()
        end
        
        UpingConnection = RunService.Heartbeat:Connect(function()
            if IsUping and BodyVelocity and BodyVelocity.Parent then
                BodyVelocity.Velocity = Vector3.new(0, UpingHeight, 0)
            else
                UpingConnection:Disconnect()
            end
        end)
        
        ShowNotification("Uping activated! You can fly now.", 2)
    else
        -- Выключаем режим полета
        if BodyVelocity then
            BodyVelocity:Destroy()
            BodyVelocity = nil
        end
        
        if UpingConnection then
            UpingConnection:Disconnect()
            UpingConnection = nil
        end
        
        humanoid.PlatformStand = false
        
        UpingButton.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
        UpingButton.Text = "Uping"
        
        ShowNotification("Uping deactivated!", 2)
    end
end

-- Создание элементов Info tab
local infoSection, infoContent = CreateSection(InfoTab, "📋 Script Information")
CreateLabel(infoContent, "99 Nights In The Forest\nMobile Script Menu\n\nVersion: 0.31\n\nFunctions from original Game tab\n\nTap the title bar to move the menu")

local controlsSection, controlsContent = CreateSection(InfoTab, "🎮 Controls")
CreateLabel(controlsContent, "- Tap ASTRAL button to show/hide menu\n- Drag title bar to move menu\n- Toggle switches to enable features\n- Adjust sliders for distance settings")

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
    local character = Player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = CFrame.new(0, 10, 0)
        print("Teleported to base!")
    end
end)

-- Добавляем слайдер для высоты полета и кнопку Uping
local upingSlider = CreateSlider(teleportContent, "Uping Height", 0, 100, 50, function(value)
    UpingHeight = value
end)

UpingButton = CreateButton(teleportContent, "Uping", ToggleUping)

-- Новое мини-меню для Bring Items
local bringItemsSection, bringItemsContent = CreateSection(KeksTab, "🎒 Bring Items")

-- Создаем выпадающий список для выбора предметов
local bringOptions = {"Logs", "Coal", "Fuel Canister", "Oil Barrel"}
local bringDropdown = CreateDropdown(bringItemsContent, bringOptions, "Logs")

-- Кнопка для телепортации выбранных предметов
CreateButton(bringItemsContent, "Bring Selected", function()
    local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local selectedItem = bringDropdown.GetValue()
    
    if selectedItem == "Logs" then
        for _, item in pairs(workspace.Items:GetChildren()) do
            if item.Name:lower():find("log") and item:IsA("Model") then
                local main = item:FindFirstChildWhichIsA("BasePart")
                if main then
                    main.CFrame = root.CFrame * CFrame.new(math.random(-5,5), 0, math.random(-5,5))
                end
            end
        end
        ShowNotification("Brought: Logs", 2)
    elseif selectedItem == "Coal" then
        for _, item in pairs(workspace.Items:GetChildren()) do
            if item.Name:lower():find("coal") and item:IsA("Model") then
                local main = item:FindFirstChildWhichIsA("BasePart")
                if main then
                    main.CFrame = root.CFrame * CFrame.new(math.random(-5,5), 0, math.random(-5,5))
                end
            end
        end
        ShowNotification("Brought: Coal", 2)
    elseif selectedItem == "Fuel Canister" then
        for _, item in pairs(workspace.Items:GetChildren()) do
            if item.Name:lower():find("fuel canister") and item:IsA("Model") then
                local main = item:FindFirstChildWhichIsA("BasePart")
                if main then
                    main.CFrame = root.CFrame * CFrame.new(math.random(-5,5), 0, math.random(-5,5))
                end
            end
        end
        ShowNotification("Brought: Fuel Canister", 2)
    elseif selectedItem == "Oil Barrel" then
        for _, item in pairs(workspace.Items:GetChildren()) do
            if item.Name:lower():find("oil barrel") and item:IsA("Model") then
                local main = item:FindFirstChildWhichIsA("BasePart")
                if main then
                    main.CFrame = root.CFrame * CFrame.new(math.random(-5,5), 0, math.random(-5,5))
                end
            end
        end
        ShowNotification("Brought: Oil Barrel", 2)
    end
end)

-- Мини-меню для выбора скрапов
local scrapSection, scrapContent = CreateSection(KeksTab, "🔧 Scrap Selection")

-- Создаем выпадающий список для выбора скрапов
local scrapOptions = {"All", "tyre", "sheet metal", "broken fan", "bolt", "old radio", "ufo junk", "ufo scrap", "broken microwave"}
local scrapDropdown = CreateDropdown(scrapContent, scrapOptions, "All")

-- Кнопка для телепортации выбранного скрапа
CreateButton(scrapContent, "Tp Scraps", function()
    local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local selectedScrap = scrapDropdown.GetValue()
    local scrapNames = {
        ["tyre"] = true, 
        ["sheet metal"] = true, 
        ["broken fan"] = true, 
        ["bolt"] = true, 
        ["old radio"] = true, 
        ["ufo junk"] = true, 
        ["ufo scrap"] = true, 
        ["broken microwave"] = true,
    }
    
    for _, item in pairs(workspace.Items:GetChildren()) do
        if item:IsA("Model") then
            local itemName = item.Name:lower()
            
            if selectedScrap == "All" then
                -- Телепортировать все скрапы
                for scrapName, _ in pairs(scrapNames) do
                    if itemName:find(scrapName) then
                        local main = item:FindFirstChildWhichIsA("BasePart")
                        if main then
                            main.CFrame = root.CFrame * CFrame.new(math.random(-5,5), 0, math.random(-5,5))
                        end
                        break
                    end
                end
            else
                -- Телепортировать только выбранный скрап
                if itemName:find(selectedScrap) then
                    local main = item:FindFirstChildWhichIsA("BasePart")
                    if main then
                        main.CFrame = root.CFrame * CFrame.new(math.random(-5,5), 0, math.random(-5,5))
                    end
                end
            end
        end
    end
    
    ShowNotification("Teleported: " .. selectedScrap, 2)
end)

-- Новое мини-меню для Lost Child (игрок телепортируется к детям)
local lostChildSection, lostChildContent = CreateSection(KeksTab, "👶 Teleport to Lost Child")

-- Кнопка для Lost Child 1
CreateButton(lostChildContent, "Lost Child 1", function()
    local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    for _, item in pairs(workspace.Characters:GetChildren()) do
        if item.Name:lower():find("lost child") and item:IsA("Model") then
            local main = item:FindFirstChildWhichIsA("BasePart")
            if main then
                root.CFrame = main.CFrame + Vector3.new(0, 2, 0) -- Немного выше ребенка
                ShowNotification("Teleported to Lost Child 1", 2)
                return
            end
        end
    end
    ShowNotification("Lost Child 1 not found", 2)
end)

-- Кнопка для Lost Child 2
CreateButton(lostChildContent, "Lost Child 2", function()
    local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    for _, item in pairs(workspace.Characters:GetChildren()) do
        if item.Name:lower():find("lost child2") and item:IsA("Model") then
            local main = item:FindFirstChildWhichIsA("BasePart")
            if main then
                root.CFrame = main.CFrame + Vector3.new(0, 2, 0) -- Немного выше ребенка
                ShowNotification("Teleported to Lost Child 2", 2)
                return
            end
        end
    end
    ShowNotification("Lost Child 2 not found", 2)
end)

-- Кнопка для Lost Child 3
CreateButton(lostChildContent, "Lost Child 3", function()
    local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    for _, item in pairs(workspace.Characters:GetChildren()) do
        if item.Name:lower():find("lost child3") and item:IsA("Model") then
            local main = item:FindFirstChildWhichIsA("BasePart")
            if main then
                root.CFrame = main.CFrame + Vector3.new(0, 2, 0) -- Немного выше ребенка
                ShowNotification("Teleported to Lost Child 3", 2)
                return
            end
        end
    end
    ShowNotification("Lost Child 3 not found", 2)
end)

-- Кнопка для Lost Child 4
CreateButton(lostChildContent, "Lost Child 4", function()
    local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    for _, item in pairs(workspace.Characters:GetChildren()) do
        if item.Name:lower():find("lost child4") and item:IsA("Model") then
            local main = item:FindFirstChildWhichIsA("BasePart")
            if main then
                root.CFrame = main.CFrame + Vector3.new(0, 2, 0) -- Немного выше ребенка
                ShowNotification("Teleported to Lost Child 4", 2)
                return
            end
        end
    end
    ShowNotification("Lost Child 4 not found", 2)
end)

local BandageSection, BandageContent = CreateSection(KeksTab, "🍎 Food Selection")

-- Создаем выпадающий список для выбора еды
local BandageOptions = {"All", "Morsel", "Carrot", "Bandage", "Medkit"}
local BandageDropdown = CreateDropdown(BandageContent, BandageOptions, "All")

-- Кнопка для телепортации выбранной еды
CreateButton(BandageContent, "Tp Food", function()
    local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local selectedBandage = BandageDropdown.GetValue()
    local BandageNames = {
        ["morsel"] = "Morsel", 
        ["carrot"] = "Carrot", 
        ["bandage"] = "Bandage", 
        ["medkit"] = "Medkit", 
    }
    
    for _, item in pairs(workspace.Items:GetChildren()) do
        if item:IsA("Model") then
            local itemName = item.Name:lower()
            
            if selectedBandage == "All" then
                -- Телепортировать всю еду
                for bandageKey, bandageValue in pairs(BandageNames) do
                    if itemName:find(bandageKey) then
                        local main = item:FindFirstChildWhichIsA("BasePart")
                        if main then
                            main.CFrame = root.CFrame * CFrame.new(math.random(-5,5), 0, math.random(-5,5))
                        end
                        break
                    end
                end
            else
                -- Телепортировать только выбранную еду
                local searchTerm = selectedBandage:lower()
                if itemName:find(searchTerm) then
                    local main = item:FindFirstChildWhichIsA("BasePart")
                    if main then
                        main.CFrame = root.CFrame * CFrame.new(math.random(-5,5), 0, math.random(-5,5))
                    end
                end
            end
        end
    end
    
    ShowNotification("Teleported: " .. selectedBandage, 2)
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
        CurrentTab = "Info"
    elseif tabName == "Game" then
        GameTabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        GameTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        GameTab.Visible = true
        CurrentTab = "Game"
    elseif tabName == "Keks" then
        KeksTabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        KeksTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        KeksTab.Visible = true
        CurrentTab = "Keks"
    end
    
    -- Восстанавливаем позицию прокрутки для выбранной вкладки
    ScrollContainer.CanvasPosition = LastScrollPositions[CurrentTab]
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
    -- Сохраняем позицию прокрутки перед закрытием
    LastScrollPositions[CurrentTab] = ScrollContainer.CanvasPosition
    MainFrame.Visible = false
end)

-- Переключение видимости меню
ToggleButton.MouseButton1Click:Connect(function()
    if MainFrame.Visible then
        -- Сохраняем позицию прокрутки перед закрытием
        LastScrollPositions[CurrentTab] = ScrollContainer.CanvasPosition
    else
        -- Восстанавливаем позицию прокрутки при открытии
        ScrollContainer.CanvasPosition = LastScrollPositions[CurrentTab]
    end
    MainFrame.Visible = not MainFrame.Visible
end)

-- Сохраняем позицию прокрутки при изменении
ScrollContainer:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
    if MainFrame.Visible then
        LastScrollPositions[CurrentTab] = ScrollContainer.CanvasPosition
    end
end)

-- Функция для ограничения прокрутки в мини-меню
local function SetupScrollLimits()
    -- Ждем обновления макета
    wait(0.1)
    
    -- Получаем общий размер контента
    local contentSize = ContentFrame.AbsoluteSize.Y
    local containerSize = ScrollContainer.AbsoluteWindowSize.Y
    
    -- Устанавливаем максимальную прокрутку
    local maxScroll = math.max(0, contentSize - containerSize)
    
    -- Ограничиваем текущую позицию прокрутки
    if ScrollContainer.CanvasPosition.Y > maxScroll then
        ScrollContainer.CanvasPosition = Vector2.new(0, maxScroll)
    end
end

-- Вызываем функцию ограничения прокрутки при изменении размера контента
ContentFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(SetupScrollLimits)

-- По умолчанию открываем вкладку Info
switchToTab("Info")

-- Устанавливаем ограничения прокрутки после загрузки
wait(0.5)
SetupScrollLimits()

print("Mobile ASTRALCHEAT with flying Uping loaded! Tap the button to open/close. Drag the title to move. Scroll vertically to see all content.")