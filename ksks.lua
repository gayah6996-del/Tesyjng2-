-- SANSTRO Menu for Mobile - Rayfield Style
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Цветовая схема Rayfield
local RayfieldColors = {
    Background = Color3.fromRGB(25, 25, 30),
    DarkBackground = Color3.fromRGB(20, 20, 25),
    Element = Color3.fromRGB(35, 35, 45),
    Hover = Color3.fromRGB(45, 45, 55),
    Accent = Color3.fromRGB(85, 85, 255),
    Text = Color3.fromRGB(240, 240, 240),
    SubText = Color3.fromRGB(180, 180, 180),
    Success = Color3.fromRGB(85, 255, 85),
    Error = Color3.fromRGB(255, 85, 85)
}

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

-- Анимации
local function TweenObject(object, properties, duration)
    local tweenInfo = TweenInfo.new(duration or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
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

-- Улучшенные функции для UI элементов
local function CreateRayfieldButton(parent, text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 40)
    button.Position = UDim2.new(0, 10, 0, 0)
    button.BackgroundColor3 = RayfieldColors.Element
    button.BackgroundTransparency = 0
    button.AutoButtonColor = false
    button.Text = ""
    button.ZIndex = 3
    button.Parent = parent
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = button
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = RayfieldColors.Hover
    Stroke.Thickness = 1
    Stroke.Parent = button
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = RayfieldColors.Text
    Label.TextSize = 14
    Label.Font = Enum.Font.GothamSemibold
    Label.ZIndex = 4
    Label.Parent = button
    
    -- Анимации при наведении
    button.MouseEnter:Connect(function()
        TweenObject(button, {BackgroundColor3 = RayfieldColors.Hover})
        TweenObject(Stroke, {Color = RayfieldColors.Accent})
    end)
    
    button.MouseLeave:Connect(function()
        TweenObject(button, {BackgroundColor3 = RayfieldColors.Element})
        TweenObject(Stroke, {Color = RayfieldColors.Hover})
    end)
    
    button.MouseButton1Click:Connect(function()
        TweenObject(button, {BackgroundColor3 = RayfieldColors.Accent})
        TweenObject(Stroke, {Color = RayfieldColors.Accent})
        wait(0.1)
        TweenObject(button, {BackgroundColor3 = RayfieldColors.Hover})
        callback()
    end)
    
    return button
end

local function CreateRayfieldToggle(parent, text, callback, isActive)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, -20, 0, 40)
    toggleFrame.BackgroundColor3 = RayfieldColors.Element
    toggleFrame.BackgroundTransparency = 0
    toggleFrame.BorderSizePixel = 0
    toggleFrame.ZIndex = 3
    toggleFrame.Parent = parent
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = toggleFrame
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = RayfieldColors.Hover
    Stroke.Thickness = 1
    Stroke.Parent = toggleFrame
    
    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Name = "ToggleLabel"
    toggleLabel.Size = UDim2.new(0.7, -10, 1, 0)
    toggleLabel.Position = UDim2.new(0, 10, 0, 0)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.TextColor3 = RayfieldColors.Text
    toggleLabel.Text = text
    toggleLabel.Font = Enum.Font.GothamSemibold
    toggleLabel.TextSize = 14
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    toggleLabel.ZIndex = 4
    toggleLabel.Parent = toggleFrame
    
    local toggleButton = Instance.new("Frame")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0.3, -10, 0, 20)
    toggleButton.Position = UDim2.new(0.7, 0, 0.25, 0)
    toggleButton.BackgroundColor3 = isActive and RayfieldColors.Success or RayfieldColors.Error
    toggleButton.BackgroundTransparency = 0
    toggleButton.ZIndex = 4
    toggleButton.Parent = toggleFrame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggleButton
    
    local toggleKnob = Instance.new("Frame")
    toggleKnob.Size = UDim2.new(0, 16, 0, 16)
    toggleKnob.Position = UDim2.new(isActive and 0.5 or 0, 2, 0, 2)
    toggleKnob.BackgroundColor3 = RayfieldColors.Text
    toggleKnob.ZIndex = 5
    toggleKnob.Parent = toggleButton
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = toggleKnob
    
    -- Анимации
    toggleFrame.MouseEnter:Connect(function()
        TweenObject(toggleFrame, {BackgroundColor3 = RayfieldColors.Hover})
        TweenObject(Stroke, {Color = RayfieldColors.Accent})
    end)
    
    toggleFrame.MouseLeave:Connect(function()
        TweenObject(toggleFrame, {BackgroundColor3 = RayfieldColors.Element})
        TweenObject(Stroke, {Color = RayfieldColors.Hover})
    end)
    
    toggleFrame.MouseButton1Click:Connect(function()
        isActive = not isActive
        TweenObject(toggleKnob, {Position = UDim2.new(isActive and 0.5 or 0, 2, 0, 2)})
        TweenObject(toggleButton, {BackgroundColor3 = isActive and RayfieldColors.Success or RayfieldColors.Error})
        TweenObject(toggleFrame, {BackgroundColor3 = RayfieldColors.Accent})
        wait(0.1)
        TweenObject(toggleFrame, {BackgroundColor3 = RayfieldColors.Hover})
        callback(isActive)
        SaveSettings()
    end)
    
    return {
        Set = function(value)
            isActive = value
            TweenObject(toggleKnob, {Position = UDim2.new(isActive and 0.5 or 0, 2, 0, 2)})
            TweenObject(toggleButton, {BackgroundColor3 = isActive and RayfieldColors.Success or RayfieldColors.Error})
        end
    }
end

local function CreateRayfieldSlider(parent, text, min, max, default, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, -20, 0, 60)
    sliderFrame.BackgroundColor3 = RayfieldColors.Element
    sliderFrame.BackgroundTransparency = 0
    sliderFrame.BorderSizePixel = 0
    sliderFrame.ZIndex = 3
    sliderFrame.Parent = parent
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 6)
    sliderCorner.Parent = sliderFrame
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = RayfieldColors.Hover
    Stroke.Thickness = 1
    Stroke.Parent = sliderFrame
    
    local sliderText = Instance.new("TextLabel")
    sliderText.Size = UDim2.new(1, -20, 0, 20)
    sliderText.Position = UDim2.new(0, 10, 0, 5)
    sliderText.BackgroundTransparency = 1
    sliderText.Text = text .. ": " .. default
    sliderText.TextColor3 = RayfieldColors.Text
    sliderText.TextSize = 14
    sliderText.TextXAlignment = Enum.TextXAlignment.Left
    sliderText.Font = Enum.Font.GothamSemibold
    sliderText.ZIndex = 4
    sliderText.Parent = sliderFrame
    
    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new(1, -20, 0, 6)
    sliderBar.Position = UDim2.new(0, 10, 0, 35)
    sliderBar.BackgroundColor3 = RayfieldColors.DarkBackground
    sliderBar.ZIndex = 4
    sliderBar.Parent = sliderFrame
    
    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(1, 0)
    barCorner.Parent = sliderBar
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = RayfieldColors.Accent
    sliderFill.ZIndex = 5
    sliderFill.Parent = sliderBar
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = sliderFill
    
    local sliderKnob = Instance.new("Frame")
    sliderKnob.Size = UDim2.new(0, 16, 0, 16)
    sliderKnob.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
    sliderKnob.BackgroundColor3 = RayfieldColors.Text
    sliderKnob.ZIndex = 6
    sliderKnob.Parent = sliderBar
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = sliderKnob
    
    local isDragging = false
    local connection = nil
    
    local function updateSlider(value)
        local norm = math.clamp((value - min) / (max - min), 0, 1)
        TweenObject(sliderFill, {Size = UDim2.new(norm, 0, 1, 0)})
        TweenObject(sliderKnob, {Position = UDim2.new(norm, -8, 0.5, -8)})
        sliderText.Text = text .. ": " .. math.floor(value)
        callback(value)
    end
    
    sliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = true
            TweenObject(sliderFrame, {BackgroundColor3 = RayfieldColors.Hover})
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
            TweenObject(sliderFrame, {BackgroundColor3 = RayfieldColors.Element})
            SaveSettings()
        end
    end)
    
    updateSlider(default)
end

local function CreateRayfieldTab(parent, text, icon)
    local tabButton = Instance.new("TextButton")
    tabButton.Size = UDim2.new(1, -10, 0, 45)
    tabButton.BackgroundColor3 = RayfieldColors.Element
    tabButton.BackgroundTransparency = 0
    tabButton.AutoButtonColor = false
    tabButton.Text = ""
    tabButton.ZIndex = 3
    tabButton.Parent = parent
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = tabButton
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = RayfieldColors.Hover
    Stroke.Thickness = 1
    Stroke.Parent = tabButton
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -10, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = RayfieldColors.Text
    Label.TextSize = 14
    Label.Font = Enum.Font.GothamSemibold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 4
    Label.Parent = tabButton
    
    -- Анимации при наведении
    tabButton.MouseEnter:Connect(function()
        TweenObject(tabButton, {BackgroundColor3 = RayfieldColors.Hover})
        TweenObject(Stroke, {Color = RayfieldColors.Accent})
    end)
    
    tabButton.MouseLeave:Connect(function()
        if not tabButton:GetAttribute("Active") then
            TweenObject(tabButton, {BackgroundColor3 = RayfieldColors.Element})
            TweenObject(Stroke, {Color = RayfieldColors.Hover})
        end
    end)
    
    return tabButton
end

-- Функция создания FOV Circle
local function createFOVCircle()
    if fovCircle then
        fovCircle:Remove()
    end
    
    fovCircle = Drawing.new("Circle")
    fovCircle.Visible = false
    fovCircle.Color = RayfieldColors.Accent
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

-- Функция создания кнопки открытия/закрытия в стиле Rayfield
local function createOpenCloseButton()
    if OpenCloseButton then
        OpenCloseButton:Destroy()
    end

    OpenCloseButton = Instance.new("TextButton")
    OpenCloseButton.Name = "OpenCloseButton"
    OpenCloseButton.Size = UDim2.new(0, 50, 0, 50)
    OpenCloseButton.Position = savedButtonPosition
    OpenCloseButton.BackgroundColor3 = RayfieldColors.Accent
    OpenCloseButton.TextColor3 = RayfieldColors.Text
    OpenCloseButton.Text = "☰"
    OpenCloseButton.Font = Enum.Font.GothamBold
    OpenCloseButton.TextSize = 16
    OpenCloseButton.ZIndex = 10
    OpenCloseButton.Active = true
    OpenCloseButton.Draggable = true
    OpenCloseButton.Parent = ScreenGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = OpenCloseButton

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = RayfieldColors.Text
    Stroke.Thickness = 2
    Stroke.Parent = OpenCloseButton

    -- Анимации
    OpenCloseButton.MouseEnter:Connect(function()
        TweenObject(OpenCloseButton, {BackgroundColor3 = RayfieldColors.Hover})
    end)
    
    OpenCloseButton.MouseLeave:Connect(function()
        TweenObject(OpenCloseButton, {BackgroundColor3 = RayfieldColors.Accent})
    end)

    -- Обработчик нажатия
    OpenCloseButton.MouseButton1Click:Connect(function()
        isGuiOpen = not isGuiOpen
        
        -- Закрываем/открываем текущее активное меню
        if currentActiveMenu then
            if isGuiOpen then
                currentActiveMenu.Visible = true
                TweenObject(currentActiveMenu, {Position = savedPosition})
                TweenObject(OpenCloseButton, {BackgroundColor3 = RayfieldColors.Success})
            else
                TweenObject(currentActiveMenu, {Position = UDim2.new(-1, 0, savedPosition.Y.Scale, savedPosition.Y.Offset)})
                wait(0.2)
                currentActiveMenu.Visible = false
                TweenObject(OpenCloseButton, {BackgroundColor3 = RayfieldColors.Accent})
            end
        end
        
        if isGuiOpen then
            OpenCloseButton.Text = "✕"
        else
            OpenCloseButton.Text = "☰"
        end
    end)

    -- Сохраняем позицию кнопки при перетаскивании
    OpenCloseButton.DragStopped:Connect(function()
        savedButtonPosition = OpenCloseButton.Position
    end)
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

-- ESP Functions (остаются без изменений, но можно обновить цвета)
-- ... [ESP функции остаются такими же, но можно заменить цвета на RayfieldColors.Accent] ...

-- Функции из второго скрипта (остаются без изменений)
-- ... [Kill Aura, Auto Chop, Bring Items функции остаются без изменений] ...

-- Функция создания главного меню выбора в стиле Rayfield
local function createMainMenu()
    MainMenu = Instance.new("Frame")
    MainMenu.Name = "MainMenu"
    MainMenu.Size = UDim2.new(0, 300, 0, 200)
    MainMenu.Position = savedPosition
    MainMenu.BackgroundColor3 = RayfieldColors.Background
    MainMenu.BackgroundTransparency = 0
    MainMenu.BorderSizePixel = 0
    MainMenu.Active = true
    MainMenu.Draggable = true
    MainMenu.Visible = isGuiOpen
    MainMenu.Parent = ScreenGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = MainMenu

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = RayfieldColors.Element
    Stroke.Thickness = 2
    Stroke.Parent = MainMenu

    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.Position = UDim2.new(0, 0, 0, 0)
    TitleBar.BackgroundColor3 = RayfieldColors.DarkBackground
    TitleBar.BorderSizePixel = 0
    TitleBar.ZIndex = 2
    TitleBar.Parent = MainMenu

    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 8)
    TitleCorner.Parent = TitleBar

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -40, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.TextColor3 = RayfieldColors.Text
    Title.Text = "SANSTRO HUB"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.ZIndex = 3
    Title.Parent = TitleBar

    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0, 5)
    CloseButton.BackgroundColor3 = RayfieldColors.Error
    CloseButton.TextColor3 = RayfieldColors.Text
    CloseButton.Text = "✕"
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 14
    CloseButton.ZIndex = 3
    CloseButton.Parent = TitleBar

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseButton

    CloseButton.MouseButton1Click:Connect(function()
        isGuiOpen = false
        MainMenu.Visible = false
        OpenCloseButton.Text = "☰"
        TweenObject(OpenCloseButton, {BackgroundColor3 = RayfieldColors.Accent})
    end)

    local Content = Instance.new("Frame")
    Content.Name = "Content"
    Content.Size = UDim2.new(1, 0, 1, -40)
    Content.Position = UDim2.new(0, 0, 0, 40)
    Content.BackgroundTransparency = 1
    Content.Parent = MainMenu

    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0, 10)
    ContentLayout.Parent = Content

    local GunButton = CreateRayfieldButton(Content, "🎮 GUNGAME", function()
        TweenObject(MainMenu, {Position = UDim2.new(-1, 0, savedPosition.Y.Scale, savedPosition.Y.Offset)})
        wait(0.2)
        MainMenu.Visible = false
        GunMenu.Visible = true
        TweenObject(GunMenu, {Position = savedPosition})
        currentActiveMenu = GunMenu
    end)

    local NightsButton = CreateRayfieldButton(Content, "🌙 99 NIGHTS", function()
        TweenObject(MainMenu, {Position = UDim2.new(-1, 0, savedPosition.Y.Scale, savedPosition.Y.Offset)})
        wait(0.2)
        MainMenu.Visible = false
        NightsMenu.Visible = true
        TweenObject(NightsMenu, {Position = savedPosition})
        currentActiveMenu = NightsMenu
    end)
    
    currentActiveMenu = MainMenu
end

-- Функция создания Gun Menu в стиле Rayfield
local function createGunMenu()
    GunMenu = Instance.new("Frame")
    GunMenu.Name = "GunMenu"
    GunMenu.Size = UDim2.new(0, 350, 0, 400)
    GunMenu.Position = UDim2.new(-1, 0, savedPosition.Y.Scale, savedPosition.Y.Offset)
    GunMenu.BackgroundColor3 = RayfieldColors.Background
    GunMenu.BackgroundTransparency = 0
    GunMenu.BorderSizePixel = 0
    GunMenu.Active = true
    GunMenu.Draggable = true
    GunMenu.Visible = false
    GunMenu.Parent = ScreenGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = GunMenu

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = RayfieldColors.Element
    Stroke.Thickness = 2
    Stroke.Parent = GunMenu

    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.Position = UDim2.new(0, 0, 0, 0)
    TitleBar.BackgroundColor3 = RayfieldColors.DarkBackground
    TitleBar.BorderSizePixel = 0
    TitleBar.ZIndex = 2
    TitleBar.Parent = GunMenu

    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 8)
    TitleCorner.Parent = TitleBar

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -80, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.TextColor3 = RayfieldColors.Text
    Title.Text = "GUNGAME MENU"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.ZIndex = 3
    Title.Parent = TitleBar

    local BackButton = Instance.new("TextButton")
    BackButton.Name = "BackButton"
    BackButton.Size = UDim2.new(0, 30, 0, 30)
    BackButton.Position = UDim2.new(1, -75, 0, 5)
    BackButton.BackgroundColor3 = RayfieldColors.Element
    BackButton.TextColor3 = RayfieldColors.Text
    BackButton.Text = "←"
    BackButton.Font = Enum.Font.GothamBold
    BackButton.TextSize = 14
    BackButton.ZIndex = 3
    BackButton.Parent = TitleBar

    local BackCorner = Instance.new("UICorner")
    BackCorner.CornerRadius = UDim.new(0, 6)
    BackCorner.Parent = BackButton

    BackButton.MouseButton1Click:Connect(function()
        TweenObject(GunMenu, {Position = UDim2.new(-1, 0, savedPosition.Y.Scale, savedPosition.Y.Offset)})
        wait(0.2)
        GunMenu.Visible = false
        MainMenu.Visible = true
        TweenObject(MainMenu, {Position = savedPosition})
        currentActiveMenu = MainMenu
    end)

    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0, 5)
    CloseButton.BackgroundColor3 = RayfieldColors.Error
    CloseButton.TextColor3 = RayfieldColors.Text
    CloseButton.Text = "✕"
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 14
    CloseButton.ZIndex = 3
    CloseButton.Parent = TitleBar

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseButton

    CloseButton.MouseButton1Click:Connect(function()
        isGuiOpen = false
        GunMenu.Visible = false
        OpenCloseButton.Text = "☰"
        TweenObject(OpenCloseButton, {BackgroundColor3 = RayfieldColors.Accent})
    end)

    -- Табы
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(0, 100, 1, -50)
    TabContainer.Position = UDim2.new(0, 10, 0, 45)
    TabContainer.BackgroundTransparency = 1
    TabContainer.Parent = GunMenu

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding = UDim.new(0, 5)
    TabLayout.Parent = TabContainer

    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -120, 1, -50)
    ContentContainer.Position = UDim2.new(0, 110, 0, 45)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = GunMenu

    local gunTabs = {
        {name = "Movement", icon = "🏃"},
        {name = "Visual", icon = "👁"},
        {name = "AimBot", icon = "🎯"}
    }

    local gunTabButtons = {}
    local gunTabContents = {}

    for i, tab in ipairs(gunTabs) do
        local tabButton = CreateRayfieldTab(TabContainer, tab.icon .. " " .. tab.name)
        tabButton.LayoutOrder = i
        
        local ContentFrame = Instance.new("ScrollingFrame")
        ContentFrame.Name = tab.name .. "Content"
        ContentFrame.Size = UDim2.new(1, 0, 1, 0)
        ContentFrame.BackgroundTransparency = 1
        ContentFrame.ScrollBarThickness = 4
        ContentFrame.ScrollBarImageColor3 = RayfieldColors.Accent
        ContentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        ContentFrame.VerticalScrollBarInset = Enum.ScrollBarInset.Always
        ContentFrame.Visible = i == 1
        ContentFrame.ZIndex = 2
        ContentFrame.Parent = ContentContainer

        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentLayout.Padding = UDim.new(0, 10)
        ContentLayout.Parent = ContentFrame

        gunTabButtons[tab.name] = tabButton
        gunTabContents[tab.name] = ContentFrame

        if i == 1 then
            tabButton:SetAttribute("Active", true)
            TweenObject(tabButton, {BackgroundColor3 = RayfieldColors.Accent})
        end

        tabButton.MouseButton1Click:Connect(function()
            for contentName, contentFrame in pairs(gunTabContents) do
                contentFrame.Visible = (contentName == tab.name)
            end
            
            for btnName, btn in pairs(gunTabButtons) do
                if btnName == tab.name then
                    btn:SetAttribute("Active", true)
                    TweenObject(btn, {BackgroundColor3 = RayfieldColors.Accent})
                else
                    btn:SetAttribute("Active", false)
                    TweenObject(btn, {BackgroundColor3 = RayfieldColors.Element})
                end
            end
        end)
    end

    -- Movement Tab Content
    CreateRayfieldToggle(gunTabContents["Movement"], "Speed Hack", function(v)
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

    CreateRayfieldSlider(gunTabContents["Movement"], "Speed Value", 16, 100, currentSpeed, function(v)
        currentSpeed = math.floor(v)
        if speedHackEnabled then
            local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = currentSpeed
            end
        end
    end)

    CreateRayfieldToggle(gunTabContents["Movement"], "Jump Hack", function(v)
        jumpHackEnabled = v
    end, jumpHackEnabled)

    CreateRayfieldToggle(gunTabContents["Movement"], "NoClip", function(v)
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
    CreateRayfieldToggle(gunTabContents["Visual"], "ESP Tracers", function(v)
        espTracersEnabled = v
    end, espTracersEnabled)

    CreateRayfieldToggle(gunTabContents["Visual"], "ESP Box", function(v)
        espBoxEnabled = v
    end, espBoxEnabled)

    CreateRayfieldToggle(gunTabContents["Visual"], "ESP Health", function(v)
        espHealthEnabled = v
    end, espHealthEnabled)

    CreateRayfieldToggle(gunTabContents["Visual"], "ESP Distance", function(v)
        espDistanceEnabled = v
    end, espDistanceEnabled)

    CreateRayfieldToggle(gunTabContents["Visual"], "ESP Count", function(v)
        espCountEnabled = v
        
        if espCountEnabled then
            if not espCountText then
                espCountText = Drawing.new("Text")
                espCountText.Size = 16
                espCountText.Center = true
                espCountText.Outline = true
                espCountText.Color = RayfieldColors.Accent
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
    CreateRayfieldToggle(gunTabContents["AimBot"], "AimBot", function(v)
        aimBotEnabled = v
        
        if fovCircle then
            fovCircle.Visible = aimBotEnabled
        else
            createFOVCircle()
            fovCircle.Visible = aimBotEnabled
        end
    end, aimBotEnabled)

    CreateRayfieldSlider(gunTabContents["AimBot"], "AimBot FOV", 10, 200, aimBotFOV, function(v)
        aimBotFOV = math.floor(v)
        updateFOVCircle()
    end)

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
end

-- Функция создания Nights Menu в стиле Rayfield
local function createNightsMenu()
    NightsMenu = Instance.new("Frame")
    NightsMenu.Name = "NightsMenu"
    NightsMenu.Size = UDim2.new(0, 350, 0, 400)
    NightsMenu.Position = UDim2.new(-1, 0, savedPosition.Y.Scale, savedPosition.Y.Offset)
    NightsMenu.BackgroundColor3 = RayfieldColors.Background
    NightsMenu.BackgroundTransparency = 0
    NightsMenu.BorderSizePixel = 0
    NightsMenu.Active = true
    NightsMenu.Draggable = true
    NightsMenu.Visible = false
    NightsMenu.Parent = ScreenGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = NightsMenu

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = RayfieldColors.Element
    Stroke.Thickness = 2
    Stroke.Parent = NightsMenu

    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.Position = UDim2.new(0, 0, 0, 0)
    TitleBar.BackgroundColor3 = RayfieldColors.DarkBackground
    TitleBar.BorderSizePixel = 0
    TitleBar.ZIndex = 2
    TitleBar.Parent = NightsMenu

    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 8)
    TitleCorner.Parent = TitleBar

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -80, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.TextColor3 = RayfieldColors.Text
    Title.Text = "99 NIGHTS MENU"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.ZIndex = 3
    Title.Parent = TitleBar

    local BackButton = Instance.new("TextButton")
    BackButton.Name = "BackButton"
    BackButton.Size = UDim2.new(0, 30, 0, 30)
    BackButton.Position = UDim2.new(1, -75, 0, 5)
    BackButton.BackgroundColor3 = RayfieldColors.Element
    BackButton.TextColor3 = RayfieldColors.Text
    BackButton.Text = "←"
    BackButton.Font = Enum.Font.GothamBold
    BackButton.TextSize = 14
    BackButton.ZIndex = 3
    BackButton.Parent = TitleBar

    local BackCorner = Instance.new("UICorner")
    BackCorner.CornerRadius = UDim.new(0, 6)
    BackCorner.Parent = BackButton

    BackButton.MouseButton1Click:Connect(function()
        TweenObject(NightsMenu, {Position = UDim2.new(-1, 0, savedPosition.Y.Scale, savedPosition.Y.Offset)})
        wait(0.2)
        NightsMenu.Visible = false
        MainMenu.Visible = true
        TweenObject(MainMenu, {Position = savedPosition})
        currentActiveMenu = MainMenu
    end)

    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0, 5)
    CloseButton.BackgroundColor3 = RayfieldColors.Error
    CloseButton.TextColor3 = RayfieldColors.Text
    CloseButton.Text = "✕"
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 14
    CloseButton.ZIndex = 3
    CloseButton.Parent = TitleBar

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseButton

    CloseButton.MouseButton1Click:Connect(function()
        isGuiOpen = false
        NightsMenu.Visible = false
        OpenCloseButton.Text = "☰"
        TweenObject(OpenCloseButton, {BackgroundColor3 = RayfieldColors.Accent})
    end)

    -- Табы
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(0, 100, 1, -50)
    TabContainer.Position = UDim2.new(0, 10, 0, 45)
    TabContainer.BackgroundTransparency = 1
    TabContainer.Parent = NightsMenu

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding = UDim.new(0, 5)
    TabLayout.Parent = TabContainer

    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -120, 1, -50)
    ContentContainer.Position = UDim2.new(0, 110, 0, 45)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = NightsMenu

    local nightsTabs = {
        {name = "Combat", icon = "⚔️"},
        {name = "Farming", icon = "🌲"},
        {name = "Items", icon = "📦"}
    }

    local nightsTabButtons = {}
    local nightsTabContents = {}

    for i, tab in ipairs(nightsTabs) do
        local tabButton = CreateRayfieldTab(TabContainer, tab.icon .. " " .. tab.name)
        tabButton.LayoutOrder = i
        
        local ContentFrame = Instance.new("ScrollingFrame")
        ContentFrame.Name = tab.name .. "Content"
        ContentFrame.Size = UDim2.new(1, 0, 1, 0)
        ContentFrame.BackgroundTransparency = 1
        ContentFrame.ScrollBarThickness = 4
        ContentFrame.ScrollBarImageColor3 = RayfieldColors.Accent
        ContentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        ContentFrame.VerticalScrollBarInset = Enum.ScrollBarInset.Always
        ContentFrame.Visible = i == 1
        ContentFrame.ZIndex = 2
        ContentFrame.Parent = ContentContainer

        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentLayout.Padding = UDim.new(0, 10)
        ContentLayout.Parent = ContentFrame

        nightsTabButtons[tab.name] = tabButton
        nightsTabContents[tab.name] = ContentFrame

        if i == 1 then
            tabButton:SetAttribute("Active", true)
            TweenObject(tabButton, {BackgroundColor3 = RayfieldColors.Accent})
        end

        tabButton.MouseButton1Click:Connect(function()
            for contentName, contentFrame in pairs(nightsTabContents) do
                contentFrame.Visible = (contentName == tab.name)
            end
            
            for btnName, btn in pairs(nightsTabButtons) do
                if btnName == tab.name then
                    btn:SetAttribute("Active", true)
                    TweenObject(btn, {BackgroundColor3 = RayfieldColors.Accent})
                else
                    btn:SetAttribute("Active", false)
                    TweenObject(btn, {BackgroundColor3 = RayfieldColors.Element})
                end
            end
        end)
    end

    -- Combat Tab Content
    CreateRayfieldToggle(nightsTabContents["Combat"], "Kill Aura", function(v)
        ActiveKillAura = v
    end, ActiveKillAura)

    CreateRayfieldSlider(nightsTabContents["Combat"], "Kill Distance", 10, 150, DistanceForKillAura, function(v)
        DistanceForKillAura = v
    end)

    -- Farming Tab Content
    CreateRayfieldToggle(nightsTabContents["Farming"], "Auto Chop", function(v)
        ActiveAutoChopTree = v
    end, ActiveAutoChopTree)

    CreateRayfieldSlider(nightsTabContents["Farming"], "Chop Distance", 10, 150, DistanceForAutoChopTree, function(v)
        DistanceForAutoChopTree = v
    end)

    -- Items Tab Content
    CreateRayfieldSlider(nightsTabContents["Items"], "Bring Count", 1, 20, BringCount, function(v)
        BringCount = math.floor(v)
    end)

    CreateRayfieldSlider(nightsTabContents["Items"], "Bring Speed", 50, 500, BringDelay, function(v)
        BringDelay = math.floor(v)
    end)

    CreateRayfieldButton(nightsTabContents["Items"], "Teleport to Campfire", function()
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(CampfirePosition)
        end
    end)

    -- Категории предметов
    local itemCategories = {
        {"Resources", {"Logs", "Coal", "Chair", "Fuel Canister", "Oil Barrel"}},
        {"Metals", {"Bolt", "Sheet Metal", "Old Radio", "Scrap Metal", "UFO Scrap", "Broken Microwave"}},
        {"Food & Medical", {"Carrot", "Pumpkin", "Morsel", "Steak", "MedKit", "Bandage"}},
        {"Weapons", {"Rifle", "Rifle Ammo", "Revolver", "Revolver Ammo"}},
        {"Axes", {"Good Axe", "Strong Axe", "Chainsaw"}}
    }

    for _, category in pairs(itemCategories) do
        local categoryName, items = category[1], category[2]
        
        CreateRayfieldButton(nightsTabContents["Items"], "Bring " .. categoryName, function()
            for _, itemName in pairs(items) do
                BringItems(itemName)
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