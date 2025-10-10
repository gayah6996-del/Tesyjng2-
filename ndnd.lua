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
ResizeHandle.Size = UDim2.new(0, 20, 0, 20)
ResizeHandle.Position = UDim2.new(1, -20, 1, -20)
ResizeHandle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
ResizeHandle.BorderSizePixel = 0
ResizeHandle.ZIndex = 5
ResizeHandle.Parent = MainFrame

local ResizeCorner = Instance.new("UICorner")
ResizeCorner.CornerRadius = UDim.new(0, 4)
ResizeCorner.Parent = ResizeHandle

-- Заголовок для перемещения (используем TextButton для лучшего отклика на мобильных)
local Title = Instance.new("TextButton")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.Text = "ASTRALCHEAT"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.AutoButtonColor = false -- Отключаем автоматическое изменение цвета
Title.Parent = MainFrame

-- Кнопка сворачивания в заголовке
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(1, -70, 0, 2)
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
CloseButton.Position = UDim2.new(1, -35, 0, 2)
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

-- Основной контейнер с прокруткой
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

-- Улучшенные функции перемещения для мобильных устройств
local function startToggleDragging(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        ToggleDragging = true
        ToggleDragStartPos = Vector2.new(input.Position.X, input.Position.Y)
        ToggleStartPos = UDim2.new(ToggleButton.Position.X.Scale, ToggleButton.Position.X.Offset, ToggleButton.Position.Y.Scale, ToggleButton.Position.Y.Offset)
    end
end

local function stopToggleDragging()
    ToggleDragging = false
    ToggleDragStartPos = nil
    ToggleStartPos = nil
end

local function updateToggleDrag(input)
    if ToggleDragging and ToggleDragStartPos and ToggleStartPos and input.UserInputType == Enum.UserInputType.Touch then
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

-- Улучшенные функции перемещения основного меню
local function startDragging(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStartPos = Vector2.new(input.Position.X, input.Position.Y)
        MenuStartPos = UDim2.new(MainFrame.Position.X.Scale, MainFrame.Position.X.Offset, MainFrame.Position.Y.Scale, MainFrame.Position.Y.Offset)
    end
end

local function stopDragging()
    Dragging = false
    DragStartPos = nil
    MenuStartPos = nil
end

local function updateDrag(input)
    if Dragging and DragStartPos and MenuStartPos and input.UserInputType == Enum.UserInputType.Touch then
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
    if input.UserInputType == Enum.UserInputType.Touch then
        Resizing = true
        ResizeStart = Vector2.new(input.Position.X, input.Position.Y)
        StartSize = UDim2.new(MainFrame.Size.X.Scale, MainFrame.Size.X.Offset, MainFrame.Size.Y.Scale, MainFrame.Size.Y.Offset)
    end
end

local function stopResize()
    Resizing = false
    ResizeStart = nil
    StartSize = nil
end

local function updateResize(input)
    if Resizing and ResizeStart and StartSize and input.UserInputType == Enum.UserInputType.Touch then
        local delta = Vector2.new(input.Position.X, input.Position.Y) - ResizeStart
        
        -- Минимальный размер меню
        local minWidth = 250
        local minHeight = 300
        
        local newWidth = math.max(minWidth, StartSize.X.Offset + delta.X)
        local newHeight = math.max(minHeight, StartSize.Y.Offset + delta.Y)
        
        MainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
    end
end

-- Обработчики для перемещения кнопки ASTRAL
ToggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        startToggleDragging(input)
    end
end)

ToggleButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        stopToggleDragging()
    end
end)

ToggleButton.MouseButton1Up:Connect(function()
    stopToggleDragging()
end)

-- Обработчики для перемещения меню
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

Title.MouseButton1Up:Connect(function()
    stopDragging()
end)

-- Обработчики для изменения размера
ResizeHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        startResize(input)
    end
end)

ResizeHandle.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        stopResize()
    end
end)

ResizeHandle.MouseButton1Up:Connect(function()
    stopResize()
end)

-- Обработка изменений ввода
UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        if ToggleDragging then
            updateToggleDrag(input)
        elseif Dragging then
            updateDrag(input)
        elseif Resizing then
            updateResize(input)
        end
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

-- Функция создания элементов UI (остальной код остается таким же, как в предыдущей версии)
-- ... [остальной код создания UI элементов] ...

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
        character.HumanoidRootPart.CFrame = CFrame.new(CampfirePosition)
        ShowNotification("Teleported to campfire!", 2)
    else
        ShowNotification("Character not found!", 2)
    end
end)

-- Добавляем слайдер для высоты полета и кнопку Uping
local upingSlider = CreateSlider(teleportContent, "Uping Height", 0, 100, 50, function(value)
    UpingHeight = value
end)

UpingButton = CreateButton(teleportContent, "Uping", ToggleUping)

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
            log.CFrame = CFrame.new(CampfirePosition.X, CampfirePosition.Y + 10, CampfirePosition.Z) + Vector3.new(math.random(-5,5), 0, math.random(-5,5))
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
            coal.CFrame = CFrame.new(CampfirePosition.X, CampfirePosition.Y + 10, CampfirePosition.Z) + Vector3.new(math.random(-5,5), 0, math.random(-5,5))
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
            fuel.CFrame = CFrame.new(CampfirePosition.X, CampfirePosition.Y + 10, CampfirePosition.Z) + Vector3.new(math.random(-5,5), 0, math.random(-5,5))
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
            barrel.CFrame = CFrame.new(CampfirePosition.X, CampfirePosition.Y + 10, CampfirePosition.Z) + Vector3.new(math.random(-5,5), 0, math.random(-5,5))
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

-- По умолчанию открываем вкладку Info
switchToTab("Info")

print("Mobile ASTRALCHEAT with improved mobile controls loaded!")
print("Drag the ASTRAL button to move it around the screen")
print("Drag the title bar to move the main menu")
print("Use - to minimize and ✕ to close completely")