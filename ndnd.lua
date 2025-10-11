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
ToggleButton.Text = "ASTRAL"
ToggleButton.TextSize = 7
ToggleButton.ZIndex = 10
ToggleButton.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 10)
ToggleCorner.Parent = ToggleButton

-- Переменные для перемещения кнопки ASTRAL
local ToggleDragging = false
local ToggleDragStartPos = nil
local ToggleStartPos = nil

-- Функции для перемещения кнопки ASTRAL
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

-- Обработчики для перемещения кнопки ASTRAL
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

-- Элемент для изменения размера (правый нижний угол)
local ResizeHandle = Instance.new("Frame")
ResizeHandle.Size = UDim2.new(0, 30, 0, 30)
ResizeHandle.Position = UDim2.new(1, -30, 1, -30)
ResizeHandle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
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
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.Text = "ASTRALCHEAT - Drag to Move"
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
MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 180, 0)
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
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
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
TabsFrame.Size = UDim2.new(1, 0, 0, 30)
TabsFrame.Position = UDim2.new(0, 0, 0, 40)
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
GameTabButton.Text = "Main"
GameTabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
GameTabButton.TextSize = 14
GameTabButton.Font = Enum.Font.GothamBold
GameTabButton.Parent = TabsFrame

local KeksTabButton = Instance.new("TextButton")
KeksTabButton.Size = UDim2.new(0.34, 0, 1, 0)
KeksTabButton.Position = UDim2.new(0.66, 0, 0, 0)
KeksTabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
KeksTabButton.Text = "Bring"
KeksTabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
KeksTabButton.TextSize = 14
KeksTabButton.Font = Enum.Font.GothamBold
KeksTabButton.Parent = TabsFrame

-- Основной контейнер с прокруткой
local ScrollContainer = Instance.new("ScrollingFrame")
ScrollContainer.Size = UDim2.new(1, -10, 1, -80)
ScrollContainer.Position = UDim2.new(0, 5, 0, 75)
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
local BringCount = 2  -- Количество предметов за один раз
local BringDelay = 600  -- Задержка между падением предметов в миллисекундах

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
    textBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
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
        if isOpen then
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

-- Функция для прыжка персонажа
local function JumpCharacter()
    local character = Player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    
    if not humanoid then 
        ShowNotification("Character not found!", 2)
        return
    end
    
    -- Заставляем персонажа прыгнуть
    humanoid.Jump = true
    ShowNotification("Character jumped!", 1)
end

-- Создание элементов Info tab
local infoSection, infoContent = CreateSection(InfoTab, "📋 Script Information")
CreateLabel(infoContent, "99 Nights in the forest\n\nVersion:Beta\n\nTelegram Channel:SCRIPTTYTA\n\nTelegram Owner:@SFXCL")

-- Создание элементов Game tab
local killAuraSection, killAuraContent = CreateSection(GameTab, "⚔️ Kill Aura")
CreateSlider(killAuraContent, "Distance", 25, 300, 25, function(value)
    DistanceForKillAura = value
end)

local killAuraToggle = CreateToggle(killAuraContent, "Kill Aura", function(value)
    ActiveKillAura = value
end)

local autoChopSection, autoChopContent = CreateSection(GameTab, "🪓 Auto Tree")
CreateSlider(autoChopContent, "Distance", 0, 300, 25, function(value)
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
        character.HumanoidRootPart.CFrame = CFrame.new(WorkbenchPosition)
        ShowNotification("Teleported to campfire!", 2)
    else
        ShowNotification("Character not found!", 2)
    end
end)

-- Добавляем кнопку Jump вместо Up
CreateButton(teleportContent, "Jump", JumpCharacter)

-- Новое мини-меню для Bring Items
local bringItemsSection, bringItemsContent = CreateSection(KeksTab, "🎒 Bring Items")

-- Добавляем настройки количества и скорости телепортации
CreateTextBox(bringItemsContent, "Bring Count (1-200):", BringCount, function(value)
    if value >= 1 and value <= 200 then
        BringCount = math.floor(value)
        ShowNotification("Bring Count set to: " .. BringCount, 2)
    else
        ShowNotification("Bring Count must be between 1 and 200!", 2)
    end
end)

CreateSlider(bringItemsContent, "Bring Delay (ms)", 600, 0, 600, function(value)
    BringDelay = math.floor(value)
end)

-- Создаем выпадающий список для выбора предметов
local bringOptions = {"Logs", "Coal", "Fuel Canister", "Oil Barrel"}
local bringDropdown = CreateDropdown(bringItemsContent, bringOptions, "Logs")

-- Кнопка для телепортации выбранных предметов к костру
CreateButton(bringItemsContent, "Bring Selected", function()
    local selectedItem = bringDropdown.GetValue()
    local found = false
    
    if selectedItem == "Logs" then
        local logs = {}
        for _, item in pairs(workspace.Items:GetChildren()) do
            if item.Name:lower():find("log") and item:IsA("Model") then
                local main = item:FindFirstChildWhichIsA("BasePart")
                if main then
                    table.insert(logs, main)
                end
            end
        end
        
        -- Телепортируем только указанное количество с задержкой
        local teleported = 0
        for i = 1, math.min(BringCount, #logs) do
            local log = logs[i]
            log.CFrame = CFrame.new(CampfirePosition.X, CampfirePosition.Y + 5, CampfirePosition.Z) + Vector3.new(math.random(-5,5), 0, math.random(-5,5))
            log.Anchored = false
            log.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            teleported = teleported + 1
            
            if BringDelay > 0 then
                wait(BringDelay / 1000)  -- Конвертируем миллисекунды в секунды
            end
        end
        
        if teleported > 0 then
            ShowNotification("Brought " .. teleported .. "/" .. #logs .. " Logs to campfire!", 2)
        else
            ShowNotification("No Logs found on map", 2)
        end
    elseif selectedItem == "Coal" then
        local coals = {}
        for _, item in pairs(workspace.Items:GetChildren()) do
            if item.Name:lower():find("coal") and item:IsA("Model") then
                local main = item:FindFirstChildWhichIsA("BasePart")
                if main then
                    table.insert(coals, main)
                end
            end
        end
        
        local teleported = 0
        for i = 1, math.min(BringCount, #coals) do
            local coal = coals[i]
            coal.CFrame = CFrame.new(CampfirePosition.X, CampfirePosition.Y + 5, CampfirePosition.Z) + Vector3.new(math.random(-5,5), 0, math.random(-5,5))
            coal.Anchored = false
            coal.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            teleported = teleported + 1
            
            if BringDelay > 0 then
                wait(BringDelay / 1000)
            end
        end
        
        if teleported > 0 then
            ShowNotification("Brought " .. teleported .. "/" .. #coals .. " Coal to campfire!", 2)
        else
            ShowNotification("No Coal found on map", 2)
        end
    elseif selectedItem == "Fuel Canister" then
        local fuels = {}
        for _, item in pairs(workspace.Items:GetChildren()) do
            if item.Name:lower():find("fuel canister") and item:IsA("Model") then
                local main = item:FindFirstChildWhichIsA("BasePart")
                if main then
                    table.insert(fuels, main)
                end
            end
        end
        
        local teleported = 0
        for i = 1, math.min(BringCount, #fuels) do
            local fuel = fuels[i]
            -- Топливо телепортируем прямо в костер без высоты
            fuel.CFrame = CFrame.new(CampfirePosition) + Vector3.new(math.random(-2,2), 0.5, math.random(-2,2))
            fuel.Anchored = false
            fuel.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            teleported = teleported + 1
            
            if BringDelay > 0 then
                wait(BringDelay / 1000)
            end
        end
        
        if teleported > 0 then
            ShowNotification("Brought " .. teleported .. "/" .. #fuels .. " Fuel Canister to campfire!", 2)
        else
            ShowNotification("No Fuel Canister found on map", 2)
        end
    elseif selectedItem == "Oil Barrel" then
        local barrels = {}
        for _, item in pairs(workspace.Items:GetChildren()) do
            if item.Name:lower():find("oil barrel") and item:IsA("Model") then
                local main = item:FindFirstChildWhichIsA("BasePart")
                if main then
                    table.insert(barrels, main)
                end
            end
        end
        
        local teleported = 0
        for i = 1, math.min(BringCount, #barrels) do
            local barrel = barrels[i]
            -- Бочки с маслом телепортируем прямо в костер без высоты
            barrel.CFrame = CFrame.new(CampfirePosition) + Vector3.new(math.random(-2,2), 0.5, math.random(-2,2))
            barrel.Anchored = false
            barrel.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            teleported = teleported + 1
            
            if BringDelay > 0 then
                wait(BringDelay / 1000)
            end
        end
        
        if teleported > 0 then
            ShowNotification("Brought " .. teleported .. "/" .. #barrels .. " Oil Barrel to campfire!", 2)
        else
            ShowNotification("No Oil Barrel found on map", 2)
        end
    end
end)

-- Мини-меню для выбора скрапов
local scrapSection, scrapContent = CreateSection(KeksTab, "🔧 Scrap Selection")

-- Создаем выпадающий список для выбора скрапов
local scrapOptions = {"All", "sheet metal", "broken fan", "bolt", "old radio", "ufo junk", "ufo scrap", "broken microwave"}
local scrapDropdown = CreateDropdown(scrapContent, scrapOptions, "All")

-- Кнопка для телепортации выбранного скрапа к игроку
CreateButton(scrapContent, "Tp Scraps", function()
    local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if not root then 
        ShowNotification("Character not found!", 2)
        return 
    end
    
    local selectedScrap = scrapDropdown.GetValue()
    local scrapNames = {
        ["sheet metal"] = true, 
        ["broken fan"] = true, 
        ["bolt"] = true, 
        ["old radio"] = true, 
        ["ufo junk"] = true, 
        ["ufo scrap"] = true, 
        ["broken microwave"] = true,
    }
    
    local scraps = {}
    
    for _, item in pairs(workspace.Items:GetChildren()) do
        if item:IsA("Model") then
            local itemName = item.Name:lower()
            
            if selectedScrap == "All" then
                for scrapName, _ in pairs(scrapNames) do
                    if itemName:find(scrapName) then
                        local main = item:FindFirstChildWhichIsA("BasePart")
                        if main then
                            table.insert(scraps, main)
                        end
                        break
                    end
                end
            else
                if itemName:find(selectedScrap) then
                    local main = item:FindFirstChildWhichIsA("BasePart")
                    if main then
                        table.insert(scraps, main)
                    end
                end
            end
        end
    end
    
    -- Телепортируем только указанное количество с задержкой
    local teleported = 0
    for i = 1, math.min(BringCount, #scraps) do
        local scrap = scraps[i]
        scrap.CFrame = CFrame.new(root.Position.X, root.Position.Y + 5, root.Position.Z) + Vector3.new(math.random(-5,5), 0, math.random(-5,5))
        scrap.Anchored = false
        scrap.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        teleported = teleported + 1
        
        if BringDelay > 0 then
            wait(BringDelay / 1000)
        end
    end
    
    if teleported > 0 then
        ShowNotification("Teleported " .. teleported .. "/" .. #scraps .. " " .. selectedScrap, 2)
    else
        ShowNotification("No " .. selectedScrap .. " found on map", 2)
    end
end)

-- Новое мини-меню для Lost Child (игрок телепортируется к детям)
local lostChildSection, lostChildContent = CreateSection(KeksTab, "👶 Teleport to Lost Child")

-- Кнопка для Lost Child 1
CreateButton(lostChildContent, "Lost Child 1", function()
    local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if not root then 
        ShowNotification("Character not found!", 2)
        return 
    end
    
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
    ShowNotification("Lost Child 1 not found on map", 2)
end)

-- Кнопка для Lost Child 2
CreateButton(lostChildContent, "Lost Child 2", function()
    local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if not root then 
        ShowNotification("Character not found!", 2)
        return 
    end
    
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
    ShowNotification("Lost Child 2 not found on map", 2)
end)

-- Кнопка для Lost Child 3
CreateButton(lostChildContent, "Lost Child 3", function()
    local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if not root then 
        ShowNotification("Character not found!", 2)
        return 
    end
    
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
    ShowNotification("Lost Child 3 not found on map", 2)
end)

-- Кнопка для Lost Child 4
CreateButton(lostChildContent, "Lost Child 4", function()
    local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if not root then 
        ShowNotification("Character not found!", 2)
        return 
    end
    
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
    ShowNotification("Lost Child 4 not found on map", 2)
end)

local BandageSection, BandageContent = CreateSection(KeksTab, "🍎 Food Selection")

-- Создаем выпадающий список для выбора еды
local BandageOptions = {"All", "Morsel", "Carrot", "Bandage", "Medkit"}
local BandageDropdown = CreateDropdown(BandageContent, BandageOptions, "All")

-- Кнопка для телепортации выбранной еды к игроку
CreateButton(BandageContent, "Tp Food", function()
    local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if not root then 
        ShowNotification("Character not found!", 2)
        return 
    end
    
    local selectedBandage = BandageDropdown.GetValue()
    local BandageNames = {
        ["morsel"] = "Morsel", 
        ["carrot"] = "Carrot", 
        ["bandage"] = "Bandage", 
        ["medkit"] = "Medkit", 
    }
    
    local foods = {}
    
    for _, item in pairs(workspace.Items:GetChildren()) do
        if item:IsA("Model") then
            local itemName = item.Name:lower()
            
            if selectedBandage == "All" then
                for bandageKey, bandageValue in pairs(BandageNames) do
                    if itemName:find(bandageKey) then
                        local main = item:FindFirstChildWhichIsA("BasePart")
                        if main then
                            table.insert(foods, main)
                        end
                        break
                    end
                end
            else
                local searchTerm = selectedBandage:lower()
                if itemName:find(searchTerm) then
                    local main = item:FindFirstChildWhichIsA("BasePart")
                    if main then
                        table.insert(foods, main)
                    end
                end
            end
        end
    end
    
    -- Телепортируем только указанное количество с задержкой
    local teleported = 0
    for i = 1, math.min(BringCount, #foods) do
        local food = foods[i]
        food.CFrame = CFrame.new(root.Position.X, root.Position.Y + 5, root.Position.Z) + Vector3.new(math.random(-5,5), 0, math.random(-5,5))
        food.Anchored = false
        food.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        teleported = teleported + 1
        
        if BringDelay > 0 then
            wait(BringDelay / 1000)
        end
    end
    
    if teleported > 0 then
        ShowNotification("Teleported " .. teleported .. "/" .. #foods .. " " .. selectedBandage, 2)
    else
        ShowNotification("No " .. selectedBandage .. " found on map", 2)
    end
end)

-- Ограничитель прокрутки для вкладки Keks (добавляем 10 пикселей)
local ScrollLimiter = Instance.new("Frame")
ScrollLimiter.Size = UDim2.new(1, 0, 0, 20)  -- Увеличили с 10 до 20 пикселей
ScrollLimiter.BackgroundTransparency = 1
ScrollLimiter.Parent = KeksTab

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
    elseif tabName == "Main" then
        GameTabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        GameTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        GameTab.Visible = true
        CurrentTab = "Game"
    elseif tabName == "Bring" then
        KeksTabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        KeksTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        KeksTab.Visible = true
        CurrentTab = "Keks"
        
        -- Устанавливаем ограничение прокрутки для вкладки Keks с дополнительными 10 пикселями
        wait(0.1) -- Ждем обновления макета
        local contentSize = KeksTab.AbsoluteSize.Y
        local containerSize = ScrollContainer.AbsoluteWindowSize.Y
        local maxScroll = math.max(0, contentSize - containerSize + 10)  -- Добавляем 10 пикселей
        
        -- Ограничиваем текущую позицию прокрутки
        if ScrollContainer.CanvasPosition.Y > maxScroll then
            ScrollContainer.CanvasPosition = Vector2.new(0, maxScroll)
        end
    end
    
    -- Восстанавливаем позицию прокрутки для выбранной вкладки
    ScrollContainer.CanvasPosition = LastScrollPositions[CurrentTab]
end

InfoTabButton.MouseButton1Click:Connect(function()
    switchToTab("Info")
end)

GameTabButton.MouseButton1Click:Connect(function()
    switchToTab("Main")
end)

KeksTabButton.MouseButton1Click:Connect(function()
    switchToTab("Bring")
end)

-- Система перемещения меню для мобильных устройств и PC
local function startDragging(input)
    Dragging = true
    DragStartPos = Vector2.new(input.Position.X, input.Position.Y)
    MenuStartPos = UDim2.new(MainFrame.Position.X.Scale, MainFrame.Position.X.Offset, MainFrame.Position.Y.Scale, MainFrame.Position.Y.Offset)
    
    -- Визуальная обратная связь
    Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
end

local function stopDragging()
    Dragging = false
    DragStartPos = nil
    MenuStartPos = nil
    Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
end

local function updateDrag(input)
    if Dragging and DragStartPos and MenuStartPos then
        local delta = Vector2.new(input.Position.X, input.Position.Y) - DragStartPos
        local newX = MenuStartPos.X.Offset + delta.X
        local newY = MenuStartPos.Y.Offset + delta.Y
        
        -- Ограничение, чтобы меню не выходило за экран
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
    
    -- Визуальная обратная связь
    ResizeHandle.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
end

local function stopResize()
    Resizing = false
    ResizeStart = nil
    StartSize = nil
    ResizeHandle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
end

local function updateResize(input)
    if Resizing and ResizeStart and StartSize then
        local delta = Vector2.new(input.Position.X, input.Position.Y) - ResizeStart
        
        -- Минимальный размер меню
        local minWidth = 250
        local minHeight = 300
        
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
    -- Сохраняем позицию прокрутки перед закрытием
    LastScrollPositions[CurrentTab] = ScrollContainer.CanvasPosition
    MainFrame.Visible = false
    ToggleButton.Visible = false
    ShowNotification("Menu closed completely", 2)
end)

-- Сворачивание меню
MinimizeButton.MouseButton1Click:Connect(function()
    -- Сохраняем позицию прокрутки перед сворачиванием
    LastScrollPositions[CurrentTab] = ScrollContainer.CanvasPosition
    MainFrame.Visible = false
    ShowNotification("Menu minimized", 2)
end)

-- Переключение видимости меню
ToggleButton.MouseButton1Click:Connect(function()
    if MainFrame.Visible then
        -- Сохраняем позицию прокрутки перед закрытием
        LastScrollPositions[CurrentTab] = ScrollContainer.CanvasPosition
        MainFrame.Visible = false
    else
        -- Восстанавливаем позицию прокрутки при открытии
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

-- Функция для ограничения прокрутки в мини-меню
local function SetupScrollLimits()
    -- Ждем обновления макета
    wait(0.1)
    
    -- Получаем общий размер контента
    local contentSize = ContentFrame.AbsoluteSize.Y
    local containerSize = ScrollContainer.AbsoluteWindowSize.Y
    
    -- Устанавливаем максимальную прокрутку
    local maxScroll = math.max(0, contentSize - containerSize)
    
    -- Для вкладки Keks добавляем дополнительные 10 пикселей
    if CurrentTab == "Keks" then
        maxScroll = maxScroll + 10
    end
    
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

print("Mobile ASTRALCHEAT with improved features loaded! Drag the ASTRAL button to move it. Drag the title to move the menu. Use - to minimize and ✕ to close completely.")