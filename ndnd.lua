-- Создание основного GUI
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Название файла для сохранения настроек
local SETTINGS_FILE = "astralcheat_settings.txt"

-- Таблица для хранения текущих настроек
local Settings = {
    ActiveKillAura = false,
    ActiveAutoChopTree = false,
    DistanceForKillAura = 25,
    DistanceForAutoChopTree = 25,
    BringCount = 2,
    BringDelay = 600,
    TeleportTarget = "Костёр",
    MenuPosition = {X = 0.5, Y = 0.5, OffsetX = -160, OffsetY = -200},
    MenuSize = {Width = 320, Height = 400},
    ToggleButtonPosition = {X = 0, Y = 0, OffsetX = 10, OffsetY = 10}
}

-- Функция для сохранения настроек в файл
local function SaveSettings()
    local success, err = pcall(function()
        local data = game:GetService("HttpService"):JSONEncode(Settings)
        writefile(SETTINGS_FILE, data)
    end)
    
    if not success then
        warn("Не удалось сохранить настройки: " .. tostring(err))
    else
        print("Настройки сохранены!")
    end
end

-- Функция для загрузки настроек из файла
local function LoadSettings()
    local success, err = pcall(function()
        if isfile(SETTINGS_FILE) then
            local data = readfile(SETTINGS_FILE)
            local loadedSettings = game:GetService("HttpService"):JSONDecode(data)
            
            -- Обновляем настройки из загруженных данных
            for key, value in pairs(loadedSettings) do
                if Settings[key] ~= nil then
                    Settings[key] = value
                end
            end
            return true
        end
        return false
    end)
    
    if not success then
        warn("Не удалось загрузить настройки: " .. tostring(err))
        return false
    end
    return true
end

-- Загружаем настройки при запуске
LoadSettings()

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MobileCheatMenu"
ScreenGui.ResetOnSpawn = false
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
ToggleButton.Position = UDim2.new(Settings.ToggleButtonPosition.X, Settings.ToggleButtonPosition.OffsetX, Settings.ToggleButtonPosition.Y, Settings.ToggleButtonPosition.OffsetY)
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
    
    -- Сохраняем позицию кнопки
    Settings.ToggleButtonPosition = {
        X = ToggleButton.Position.X.Scale,
        Y = ToggleButton.Position.Y.Scale,
        OffsetX = ToggleButton.Position.X.Offset,
        OffsetY = ToggleButton.Position.Y.Offset
    }
    SaveSettings()
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
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        startToggleDragging(input)
    end
end)

ToggleButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        stopToggleDragging()
    end
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
MainFrame.Size = UDim2.new(0, Settings.MenuSize.Width, 0, Settings.MenuSize.Height)
MainFrame.Position = UDim2.new(Settings.MenuPosition.X, Settings.MenuPosition.OffsetX, Settings.MenuPosition.Y, Settings.MenuPosition.OffsetY)
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
Title.Text = "ASTRALCHEAT BETA"
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

-- Переменные для функций (будут обновляться из настроек)
local ActiveKillAura = Settings.ActiveKillAura
local ActiveAutoChopTree = Settings.ActiveAutoChopTree
local DistanceForKillAura = Settings.DistanceForKillAura
local DistanceForAutoChopTree = Settings.DistanceForAutoChopTree

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

-- Новые переменные для телепортации предметов (будут обновляться из настроек)
local BringCount = Settings.BringCount
local BringDelay = Settings.BringDelay

-- Новая переменная для выбора цели телепортации (будет обновляться из настроек)
local TeleportTarget = Settings.TeleportTarget

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
        SaveSettings()
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
        SaveSettings() -- Сохраняем настройки после изменения слайдера
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
    
    return {
        Update = function(value)
            updateSlider(value)
        end
    }
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
            SaveSettings() -- Сохраняем настройки после изменения текстового поля
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
                SaveSettings() -- Сохраняем настройки после изменения выпадающего списка
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

-- Функция для получения целевой позиции телепортации (ИСПРАВЛЕНА)
local function GetTargetPosition()
    if TeleportTarget == "Игрок" then
        local character = Player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            return character.HumanoidRootPart.Position
        else
            ShowNotification("Character not found! Using campfire.", 2)
            return CampfirePosition
        end
    else
        return CampfirePosition
    end
end

-- Создание элементов Info tab
local infoSection, infoContent = CreateSection(InfoTab, "📋 Script Information")
CreateLabel(infoContent, "99 Nights in the forest\n\nVersion:Beta\n\nTelegram Channel:SCRIPTTYTA\n\nTelegram Owner:@SFXCL\n")

-- Создание элементов Game tab
local killAuraSection, killAuraContent = CreateSection(GameTab, "Автоубийство")
local killAuraSlider = CreateSlider(killAuraContent, "Дистанция", 25, 300, Settings.DistanceForKillAura, function(value)
    DistanceForKillAura = value
    Settings.DistanceForKillAura = value
end)

local killAuraToggle = CreateToggle(killAuraContent, "Kill Aura", function(value)
    ActiveKillAura = value
    Settings.ActiveKillAura = value
end)

local autoChopSection, autoChopContent = CreateSection(GameTab, "АвтоРубка")
local autoChopSlider = CreateSlider(autoChopContent, "Дистанция", 0, 200, Settings.DistanceForAutoChopTree, function(value)
    DistanceForAutoChopTree = value
    Settings.DistanceForAutoChopTree = value
end)

local autoChopToggle = CreateToggle(autoChopContent, "Auto Tree", function(value)
    ActiveAutoChopTree = value
    Settings.ActiveAutoChopTree = value
end)

-- Создание элементов Keks tab
-- НАСТРОЙКИ BRING В САМОМ НАЧАЛЕ
local bringSettingsSection, bringSettingsContent = CreateSection(KeksTab, "Настройки телепорта")

-- Добавляем настройки количества и скорости телепортации В САМОЕ НАЧАЛО
CreateTextBox(bringSettingsContent, "Макс число (1-200):", Settings.BringCount, function(value)
    if value >= 1 and value <= 200 then
        BringCount = math.floor(value)
        Settings.BringCount = BringCount
        ShowNotification("Bring Count set to: " .. BringCount, 2)
    else
        ShowNotification("Bring Count must be between 1 and 200!", 2)
    end
end)

local bringDelaySlider = CreateSlider(bringSettingsContent, "Скорость телепорта вещей(МилиСек)", 600, 0, Settings.BringDelay, function(value)
    BringDelay = math.floor(value)
    Settings.BringDelay = BringDelay
end)

-- МИНИ-МЕНЮ ДЛЯ ВЫБОРА ЦЕЛИ ТЕЛЕПОРТАЦИИ (ИСПРАВЛЕНО)
local teleportTargetSection, teleportTargetContent = CreateSection(KeksTab, "Цель телепортации")

-- Создаем выпадающий список для выбора цели телепортации
local teleportTargetOptions = {"Игрок", "Костёр"}
local teleportTargetDropdown = CreateDropdown(teleportTargetContent, teleportTargetOptions, Settings.TeleportTarget, function(selected)
    TeleportTarget = selected
    Settings.TeleportTarget = selected
    ShowNotification("Цель телепортации: " .. selected, 2)
end)

local teleportSection, teleportContent = CreateSection(KeksTab, "Телепорт")
-- Переименовали кнопку с "Teleport to Base" на "Teleport Campfire"
CreateButton(teleportContent, "Телепорт к костру", function()
    local character = Player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = CFrame.new(CampfirePosition)
        ShowNotification("Teleported to campfire!", 2)
    else
        ShowNotification("Character not found!", 2)
    end
end)

-- МИНИ-МЕНЮ ДЛЯ ТЕЛЕПОРТАЦИИ К ДЕТЯМ
local childTeleportSection, childTeleportContent = CreateSection(KeksTab, "Телепорт К детям")

-- Создаем выпадающий список для выбора ребенка
local childOptions = {"Дино Малыш", "Кракен малыш", "Ребенчик", "Малыш Коала"}
local childDropdown = CreateDropdown(childTeleportContent, childOptions, "Дино Малыш")

-- Кнопка для телепортации к выбранному ребенку
CreateButton(childTeleportContent, "Teleport", function()
    local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if not root then 
        ShowNotification("Character not found!", 2)
        return 
    end
    
    local selectedChild = childDropdown.GetValue()
    local childName = ""
    
    -- Определяем имя ребенка в зависимости от выбора
    if selectedChild == "Дино Малыш" then
        childName = "lost child"
    elseif selectedChild == "Кракен малыш" then
        childName = "lost child2"
    elseif selectedChild == "Ребенчик" then
        childName = "lost child3"
    elseif selectedChild == "Малыш Коала" then
        childName = "lost child4"
    end
    
    local found = false
    for _, item in pairs(workspace.Characters:GetChildren()) do
        if item.Name:lower():find(childName) and item:IsA("Model") then
            local main = item:FindFirstChildWhichIsA("BasePart")
            if main then
                root.CFrame = main.CFrame + Vector3.new(0, 2, 0) -- Немного выше ребенка
                ShowNotification("Teleported to " .. selectedChild, 2)
                found = true
                break
            end
        end
    end
    
    if not found then
        ShowNotification(selectedChild .. " not found on map", 2)
    end
end)

-- МИНИ-МЕНЮ ДЛЯ BRING ITEMS
local bringItemsSection, bringItemsContent = CreateSection(KeksTab, " Телепорт заправки")

-- Создаем выпадающий список для выбора предметов
local bringOptions = {"Дерево", "Уголь", "Канистра", "Топливная бочка"}
local bringDropdown = CreateDropdown(bringItemsContent, bringOptions, "Дерево")

-- Кнопка для телепортации выбранных предметов к выбранной цели
CreateButton(bringItemsContent, "Телепорт выбранных", function()
    local selectedItem = bringDropdown.GetValue()
    local targetPos = GetTargetPosition()
    local found = false
    
    if selectedItem == "Дерево" then
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
            log.CFrame = CFrame.new(targetPos.X, targetPos.Y + 5, targetPos.Z) + Vector3.new(math.random(-5,5), 0, math.random(-5,5))
            log.Anchored = false
            log.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            teleported = teleported + 1
            
            if BringDelay > 0 then
                wait(BringDelay / 1000)  -- Конвертируем миллисекунды в секунды
            end
        end
        
        if teleported > 0 then
            ShowNotification("Brought " .. teleported .. "/" .. #logs .. " Logs to " .. TeleportTarget .. "!", 2)
        else
            ShowNotification("No Logs found on map", 2)
        end
    elseif selectedItem == "Уголь" then
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
            coal.CFrame = CFrame.new(targetPos.X, targetPos.Y + 5, targetPos.Z) + Vector3.new(math.random(-5,5), 0, math.random(-5,5))
            coal.Anchored = false
            coal.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            teleported = teleported + 1
            
            if BringDelay > 0 then
                wait(BringDelay / 1000)
            end
        end
        
        if teleported > 0 then
            ShowNotification("Brought " .. teleported .. "/" .. #coals .. " Coal to " .. TeleportTarget .. "!", 2)
        else
            ShowNotification("No Coal found on map", 2)
        end
    elseif selectedItem == "Канистра" then
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
            -- Топливо телепортируем прямо к цели без высоты
            fuel.CFrame = CFrame.new(targetPos) + Vector3.new(math.random(-2,2), 0.5, math.random(-2,2))
            fuel.Anchored = false
            fuel.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            teleported = teleported + 1
            
            if BringDelay > 0 then
                wait(BringDelay / 1000)
            end
        end
        
        if teleported > 0 then
            ShowNotification("Brought " .. teleported .. "/" .. #fuels .. " Fuel Canister to " .. TeleportTarget .. "!", 2)
        else
            ShowNotification("No Fuel Canister found on map", 2)
        end
    elseif selectedItem == "Топливная бочка" then
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
            -- Бочки с маслом телепортируем прямо к цели без высоты
            barrel.CFrame = CFrame.new(targetPos) + Vector3.new(math.random(-2,2), 0.5, math.random(-2,2))
            barrel.Anchored = false
            barrel.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            teleported = teleported + 1
            
            if BringDelay > 0 then
                wait(BringDelay / 1000)
            end
        end
        
        if teleported > 0 then
            ShowNotification("Brought " .. teleported .. "/" .. #barrels .. " Oil Barrel to " .. TeleportTarget .. "!", 2)
        else
            ShowNotification("No Oil Barrel found on map", 2)
        end
    end
end)

-- МИНИ-МЕНЮ ДЛЯ ВЫБОРА СКРАПОВ
local scrapSection, scrapContent = CreateSection(KeksTab, "Выбор скрапа")

-- Создаем выпадающий список для выбора скрапов
local scrapOptions = {"All", "sheet metal", "broken fan", "bolt", "old radio", "ufo junk", "ufo scrap", "broken microwave"}
local scrapDropdown = CreateDropdown(scrapContent, scrapOptions, "All")

-- Кнопка для телепортации выбранного скрапа к выбранной цели
CreateButton(scrapContent, "Телепортировать скрапы", function()
    local targetPos = GetTargetPosition()
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
        scrap.CFrame = CFrame.new(targetPos.X, targetPos.Y + 5, targetPos.Z) + Vector3.new(math.random(-5,5), 0, math.random(-5,5))
        scrap.Anchored = false
        scrap.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        teleported = teleported + 1
        
        if BringDelay > 0 then
            wait(BringDelay / 1000)
        end
    end
    
    if teleported > 0 then
        ShowNotification("Teleported " .. teleported .. "/" .. #scraps .. " " .. selectedScrap .. " to " .. TeleportTarget, 2)
    else
        ShowNotification("No " .. selectedScrap .. " found on map", 2)
    end
end)

-- МИНИ-МЕНЮ ДЛЯ ВЫБОРА ЕДЫ
local BandageSection, BandageContent = CreateSection(KeksTab, "Выбор Еды")

-- Создаем выпадающий список для выбора еды
local BandageOptions = {"All", "Морсель", "Морковь", "Бандаж", "Аптечка"}
local BandageDropdown = CreateDropdown(BandageContent, BandageOptions, "All")

-- Кнопка для телепортации выбранной еды к выбранной цели
CreateButton(BandageContent, "Телепортировать Еду", function()
    local targetPos = GetTargetPosition()
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
        food.CFrame = CFrame.new(targetPos.X, targetPos.Y + 5, targetPos.Z) + Vector3.new(math.random(-5,5), 0, math.random(-5,5))
        food.Anchored = false
        food.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        teleported = teleported + 1
        
        if BringDelay > 0 then
            wait(BringDelay / 1000)
        end
    end
    
    if teleported > 0 then
        ShowNotification("Teleported " .. teleported .. "/" .. #foods .. " " .. selectedBandage .. " to " .. TeleportTarget, 2)
    else
        ShowNotification("No " .. selectedBandage .. " found on map", 2)
    end
end)

-- НОВОЕ МИНИ-МЕНЮ ДЛЯ ВЫБОРА ОРУЖИЯ И ПАТРОНОВ
local WeaponSection, WeaponContent = CreateSection(KeksTab, "Выбор Оружия и Патронов")

-- Создаем выпадающий список для выбора оружия и патронов
local WeaponOptions = {"Rifle ammo", "Rifle"}
local WeaponDropdown = CreateDropdown(WeaponContent, WeaponOptions, "Rifle ammo")

-- Кнопка для телепортации выбранного оружия/патронов к выбранной цели
CreateButton(WeaponContent, "Телепортировать Оружие/Патроны", function()
    local targetPos = GetTargetPosition()
    local selectedWeapon = WeaponDropdown.GetValue()
    local weaponNames = {
        ["rifle ammo"] = "Rifle ammo", 
        ["rifle"] = "Rifle", 
    }
    
    local weapons = {}
    
    for _, item in pairs(workspace.Items:GetChildren()) do
        if item:IsA("Model") then
            local itemName = item.Name:lower()
            
            if selectedWeapon == "Rifle ammo" then
                if itemName:find("rifle") and itemName:find("ammo") then
                    local main = item:FindFirstChildWhichIsA("BasePart")
                    if main then
                        table.insert(weapons, main)
                    end
                end
            elseif selectedWeapon == "Rifle" then
                if itemName:find("rifle") and not itemName:find("ammo") then
                    local main = item:FindFirstChildWhichIsA("BasePart")
                    if main then
                        table.insert(weapons, main)
                    end
                end
            end
        end
    end
    
    -- Телепортируем только указанное количество с задержкой
    local teleported = 0
    for i = 1, math.min(BringCount, #weapons) do
        local weapon = weapons[i]
        weapon.CFrame = CFrame.new(targetPos.X, targetPos.Y + 5, targetPos.Z) + Vector3.new(math.random(-5,5), 0, math.random(-5,5))
        weapon.Anchored = false
        weapon.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        teleported = teleported + 1
        
        if BringDelay > 0 then
            wait(BringDelay / 1000)
        end
    end
    
    if teleported > 0 then
        ShowNotification("Teleported " .. teleported .. "/" .. #weapons .. " " .. selectedWeapon .. " to " .. TeleportTarget, 2)
    else
        ShowNotification("No " .. selectedWeapon .. " found on map", 2)
    end
end)

-- УВЕЛИЧЕННЫЙ ОГРАНИЧИТЕЛЬ ПРОКРУТКИ ДЛЯ ВКЛАДКИ KEKS
local ScrollLimiter = Instance.new("Frame")
ScrollLimiter.Size = UDim2.new(1, 0, 0, 50)  -- Увеличили с 20 до 50 пикселей
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
        
        -- Устанавливаем ограничение прокрутки для вкладки Keks с дополнительными 50 пикселями
        wait(0.1) -- Ждем обновления макета
        local contentSize = KeksTab.AbsoluteSize.Y
        local containerSize = ScrollContainer.AbsoluteWindowSize.Y
        local maxScroll = math.max(0, contentSize - containerSize + 50)  -- Увеличили с 10 до 50 пикселей
        
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
    
    -- Сохраняем позицию меню
    Settings.MenuPosition = {
        X = MainFrame.Position.X.Scale,
        Y = MainFrame.Position.Y.Scale,
        OffsetX = MainFrame.Position.X.Offset,
        OffsetY = MainFrame.Position.Y.Offset
    }
    SaveSettings()
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
    
    -- Сохраняем размер меню
    Settings.MenuSize = {
        Width = MainFrame.Size.X.Offset,
        Height = MainFrame.Size.Y.Offset
    }
    SaveSettings()
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
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        startDragging(input)
    end
end)

Title.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        stopDragging()
    end
end)

-- Обработчики для изменения размера
ResizeHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        startResize(input)
    end
end)

ResizeHandle.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        stopResize()
    end
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
    
    -- Для вкладки Keks добавляем дополнительные 50 пикселей
    if CurrentTab == "Keks" then
        maxScroll = maxScroll + 50  -- Увеличили с 10 до 50 пикселей
    end
    
    -- Ограничиваем текущую позицию прокрутки
    if ScrollContainer.CanvasPosition.Y > maxScroll then
        ScrollContainer.CanvasPosition = Vector2.new(0, maxScroll)
    end
end

-- Вызываем функцию ограничения прокрутки при изменении размера контента
ContentFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(SetupScrollLimits)

-- Функция применения сохраненных настроек к UI
local function ApplySavedSettings()
    -- Применяем настройки Kill Aura
    if killAuraToggle then
        killAuraToggle.Set(Settings.ActiveKillAura)
    end
    
    -- Применяем настройки Auto Chop Tree
    if autoChopToggle then
        autoChopToggle.Set(Settings.ActiveAutoChopTree)
    end
    
    -- Применяем настройки телепорта
    if teleportTargetDropdown then
        teleportTargetDropdown.SetValue(Settings.TeleportTarget)
    end
    
    -- Обновляем глобальные переменные
    ActiveKillAura = Settings.ActiveKillAura
    ActiveAutoChopTree = Settings.ActiveAutoChopTree
    DistanceForKillAura = Settings.DistanceForKillAura
    DistanceForAutoChopTree = Settings.DistanceForAutoChopTree
    BringCount = Settings.BringCount
    BringDelay = Settings.BringDelay
    TeleportTarget = Settings.TeleportTarget
    
    print("Saved settings applied successfully!")
end

-- Применяем сохраненные настройки после создания UI
wait(1) -- Даем время для создания всех элементов UI
ApplySavedSettings()

-- По умолчанию открываем вкладку Info
switchToTab("Info")

-- Устанавливаем ограничения прокрутки после загрузки
wait(0.5)
SetupScrollLimits()

print("Mobile ASTRALCHEAT with SAVE SYSTEM loaded successfully!")
print("All settings will be saved automatically!")