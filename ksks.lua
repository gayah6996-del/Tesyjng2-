-- Roblox Script Menu by SFXCL
-- Telegram: SCRIPTTYTA

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Основные переменные
local menuOpen = false
local dragging = false
local dragInput, dragStart, startPos

-- Создание основного GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SFXCL_Menu"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Функция для создания кнопки
local function createButton(name, text, size, position, parent)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Text = text
    button.Size = size
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.AutoButtonColor = false
    button.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button
    
    return button
end

-- Функция для создания фрейма
local function createFrame(name, size, position, parent, visible)
    local frame = Instance.new("Frame")
    frame.Name = name
    frame.Size = size
    frame.Position = position
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BorderSizePixel = 0
    frame.Visible = visible or false
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    return frame
end

-- Функция для создания текстовой метки
local function createLabel(name, text, size, position, parent)
    local label = Instance.new("TextLabel")
    label.Name = name
    label.Text = text
    label.Size = size
    label.Position = position
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.Parent = parent
    
    return label
end

-- Создание кнопки открытия меню
local openButton = createButton("OpenButton", "☰", UDim2.new(0, 40, 0, 40), UDim2.new(0, 10, 0, 10), screenGui)
openButton.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
openButton.TextSize = 18

-- Создание основного меню
local mainFrame = createFrame("MainFrame", UDim2.new(0, 350, 0, 400), UDim2.new(0.5, -175, 0.5, -200), screenGui, false)

-- Заголовок меню
local titleBar = createFrame("TitleBar", UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, 0), mainFrame, true)
titleBar.BackgroundColor3 = Color3.fromRGB(0, 100, 255)

local titleLabel = createLabel("TitleLabel", "SFXCL Script Menu", UDim2.new(0.8, 0, 1, 0), UDim2.new(0.1, 0, 0, 0), titleBar)
titleLabel.TextSize = 16
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Кнопка закрытия
local closeButton = createButton("CloseButton", "X", UDim2.new(0, 30, 0, 30), UDim2.new(1, -30, 0, 0), titleBar)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)

-- Вкладки
local tabsFrame = createFrame("TabsFrame", UDim2.new(1, -20, 0, 30), UDim2.new(0, 10, 0, 40), mainFrame, true)

local infoTab = createButton("InfoTab", "Information", UDim2.new(0.24, 0, 1, 0), UDim2.new(0, 0, 0, 0), tabsFrame)
local espTab = createButton("ESPTab", "ESP", UDim2.new(0.24, 0, 1, 0), UDim2.new(0.25, 0, 0, 0), tabsFrame)
local aimTab = createButton("AimTab", "AimBot", UDim2.new(0.24, 0, 1, 0), UDim2.new(0.5, 0, 0, 0), tabsFrame)
local moreTab = createButton("MoreTab", "More", UDim2.new(0.24, 0, 1, 0), UDim2.new(0.75, 0, 0, 0), tabsFrame)

-- Контент фреймы
local contentFrame = createFrame("ContentFrame", UDim2.new(1, -20, 1, -80), UDim2.new(0, 10, 0, 80), mainFrame, true)

-- Information Tab
local infoContent = createFrame("InfoContent", UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), contentFrame, true)

createLabel("VersionLabel", "Version: 1.0", UDim2.new(1, -20, 0, 30), UDim2.new(0, 10, 0, 20), infoContent)
createLabel("OwnerLabel", "Owner: SFXCL", UDim2.new(1, -20, 0, 30), UDim2.new(0, 10, 0, 60), infoContent)
createLabel("TelegramLabel", "Telegram: SCRIPTTYTA", UDim2.new(1, -20, 0, 30), UDim2.new(0, 10, 0, 100), infoContent)

-- ESP Tab
local espContent = createFrame("ESPContent", UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), contentFrame, false)

local espTracersBtn = createButton("ESPTracers", "ESP TRACERS: OFF", UDim2.new(1, -20, 0, 30), UDim2.new(0, 10, 0, 20), espContent)
local espBoxBtn = createButton("ESPBox", "ESP BOX: OFF", UDim2.new(1, -20, 0, 30), UDim2.new(0, 10, 0, 60), espContent)
local espLineBtn = createButton("ESPLine", "ESP LINE: OFF", UDim2.new(1, -20, 0, 30), UDim2.new(0, 10, 0, 100), espContent)
local espHealthBtn = createButton("ESPHealth", "ESP HEALTH: OFF", UDim2.new(1, -20, 0, 30), UDim2.new(0, 10, 0, 140), espContent)
local espCountBtn = createButton("ESPCount", "ESP COUNT: OFF", UDim2.new(1, -20, 0, 30), UDim2.new(0, 10, 0, 180), espContent)

-- AimBot Tab
local aimContent = createFrame("AimContent", UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), contentFrame, false)

local aimBotBtn = createButton("AimBotBtn", "AIMBOT: OFF", UDim2.new(1, -20, 0, 30), UDim2.new(0, 10, 0, 20), aimContent)

-- FOV Circle для AimBot
local fovCircle = Instance.new("Frame")
fovCircle.Name = "FOVCircle"
fovCircle.Size = UDim2.new(0, 100, 0, 100)
fovCircle.Position = UDim2.new(0.5, -50, 0.5, -50)
fovCircle.BackgroundTransparency = 0.7
fovCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
fovCircle.BorderSizePixel = 0
fovCircle.Visible = false
fovCircle.Parent = screenGui

local fovCorner = Instance.new("UICorner")
fovCorner.CornerRadius = UDim.new(1, 0)
fovCorner.Parent = fovCircle

local fovSizeLabel = createLabel("FOVSizeLabel", "FOV Size: 100", UDim2.new(1, -20, 0, 30), UDim2.new(0, 10, 0, 60), aimContent)
local fovSlider = Instance.new("Frame")
fovSlider.Name = "FOVSlider"
fovSlider.Size = UDim2.new(1, -20, 0, 20)
fovSlider.Position = UDim2.new(0, 10, 0, 100)
fovSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
fovSlider.BorderSizePixel = 0
fovSlider.Parent = aimContent

local fovSliderCorner = Instance.new("UICorner")
fovSliderCorner.CornerRadius = UDim.new(0, 4)
fovSliderCorner.Parent = fovSlider

local fovSliderFill = Instance.new("Frame")
fovSliderFill.Name = "FOVSliderFill"
fovSliderFill.Size = UDim2.new(0.5, 0, 1, 0)
fovSliderFill.Position = UDim2.new(0, 0, 0, 0)
fovSliderFill.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
fovSliderFill.BorderSizePixel = 0
fovSliderFill.Parent = fovSlider

local fovSliderCorner2 = Instance.new("UICorner")
fovSliderCorner2.CornerRadius = UDim.new(0, 4)
fovSliderCorner2.Parent = fovSliderFill

-- More Tab
local moreContent = createFrame("MoreContent", UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), contentFrame, false)

local speedHackBtn = createButton("SpeedHackBtn", "SPEED HACK: OFF", UDim2.new(1, -20, 0, 30), UDim2.new(0, 10, 0, 20), moreContent)
local infJumpBtn = createButton("InfJumpBtn", "INFINITY JUMP: OFF", UDim2.new(1, -20, 0, 30), UDim2.new(0, 10, 0, 60), moreContent)
local antiAFKBtn = createButton("AntiAFKBtn", "ANTI AFK: OFF", UDim2.new(1, -20, 0, 30), UDim2.new(0, 10, 0, 100), moreContent)

local speedLabel = createLabel("SpeedLabel", "Speed: 16", UDim2.new(1, -20, 0, 30), UDim2.new(0, 10, 0, 150), moreContent)
local speedSlider = Instance.new("Frame")
speedSlider.Name = "SpeedSlider"
speedSlider.Size = UDim2.new(1, -20, 0, 20)
speedSlider.Position = UDim2.new(0, 10, 0, 190)
speedSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
speedSlider.BorderSizePixel = 0
speedSlider.Parent = moreContent

local speedSliderCorner = Instance.new("UICorner")
speedSliderCorner.CornerRadius = UDim.new(0, 4)
speedSliderCorner.Parent = speedSlider

local speedSliderFill = Instance.new("Frame")
speedSliderFill.Name = "SpeedSliderFill"
speedSliderFill.Size = UDim2.new(0.2, 0, 1, 0)
speedSliderFill.Position = UDim2.new(0, 0, 0, 0)
speedSliderFill.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
speedSliderFill.BorderSizePixel = 0
speedSliderFill.Parent = speedSlider

local speedSliderCorner2 = Instance.new("UICorner")
speedSliderCorner2.CornerRadius = UDim.new(0, 4)
speedSliderCorner2.Parent = speedSliderFill

-- Переменные для функций
local espTracersEnabled = false
local espBoxEnabled = false
local espLineEnabled = false
local espHealthEnabled = false
local espCountEnabled = false
local aimBotEnabled = false
local speedHackEnabled = false
local infJumpEnabled = false
local antiAFKEnabled = false

local currentWalkSpeed = 16
local fovSize = 100
local espObjects = {}
local antiAFKConnection = nil

-- Функции переключения вкладок
local function showTab(tabName)
    infoContent.Visible = false
    espContent.Visible = false
    aimContent.Visible = false
    moreContent.Visible = false
    
    if tabName == "info" then
        infoContent.Visible = true
    elseif tabName == "esp" then
        espContent.Visible = true
    elseif tabName == "aim" then
        aimContent.Visible = true
    elseif tabName == "more" then
        moreContent.Visible = true
    end
end

-- Функция для перетаскивания меню
local function updateInput(input)
    if dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

titleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        updateInput(input)
    end
end)

-- Функции ESP (упрощенные версии)
local function updateESP()
    -- Здесь будет код для обновления ESP
    -- Это сложная функция, требующая дополнительной реализации
end

-- Функция AimBot (упрощенная версия)
local function updateAimBot()
    if not aimBotEnabled then return end
    
    local character = player.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    -- Упрощенная логика AimBot
    -- В реальной реализации здесь будет сложный код для определения целей
end

-- Функции для кнопок
infoTab.MouseButton1Click:Connect(function()
    showTab("info")
end)

espTab.MouseButton1Click:Connect(function()
    showTab("esp")
end)

aimTab.MouseButton1Click:Connect(function()
    showTab("aim")
end)

moreTab.MouseButton1Click:Connect(function()
    showTab("more")
end)

-- Кнопка открытия/закрытия меню
openButton.MouseButton1Click:Connect(function()
    menuOpen = not menuOpen
    mainFrame.Visible = menuOpen
end)

closeButton.MouseButton1Click:Connect(function()
    menuOpen = false
    mainFrame.Visible = false
end)

-- ESP функции
espTracersBtn.MouseButton1Click:Connect(function()
    espTracersEnabled = not espTracersEnabled
    espTracersBtn.Text = "ESP TRACERS: " .. (espTracersEnabled and "ON" or "OFF")
    updateESP()
end)

espBoxBtn.MouseButton1Click:Connect(function()
    espBoxEnabled = not espBoxEnabled
    espBoxBtn.Text = "ESP BOX: " .. (espBoxEnabled and "ON" or "OFF")
    updateESP()
end)

espLineBtn.MouseButton1Click:Connect(function()
    espLineEnabled = not espLineEnabled
    espLineBtn.Text = "ESP LINE: " .. (espLineEnabled and "ON" or "OFF")
    updateESP()
end)

espHealthBtn.MouseButton1Click:Connect(function()
    espHealthEnabled = not espHealthEnabled
    espHealthBtn.Text = "ESP HEALTH: " .. (espHealthEnabled and "ON" or "OFF")
    updateESP()
end)

espCountBtn.MouseButton1Click:Connect(function()
    espCountEnabled = not espCountEnabled
    espCountBtn.Text = "ESP COUNT: " .. (espCountEnabled and "ON" or "OFF")
    updateESP()
end)

-- AimBot функции
aimBotBtn.MouseButton1Click:Connect(function()
    aimBotEnabled = not aimBotEnabled
    aimBotBtn.Text = "AIMBOT: " .. (aimBotEnabled and "ON" or "OFF")
    fovCircle.Visible = aimBotEnabled
end)

-- Обработка слайдера FOV
fovSlider.MouseButton1Down:Connect(function()
    local connection
    connection = RunService.RenderStepped:Connect(function()
        local mousePos = UserInputService:GetMouseLocation()
        local sliderPos = fovSlider.AbsolutePosition
        local sliderSize = fovSlider.AbsoluteSize
        
        local relativeX = math.clamp((mousePos.X - sliderPos.X) / sliderSize.X, 0, 1)
        fovSliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
        
        fovSize = math.floor(50 + relativeX * 150) -- от 50 до 200
        fovSizeLabel.Text = "FOV Size: " .. fovSize
        fovCircle.Size = UDim2.new(0, fovSize, 0, fovSize)
        fovCircle.Position = UDim2.new(0.5, -fovSize/2, 0.5, -fovSize/2)
        
        if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
            connection:Disconnect()
        end
    end)
end)

-- More функции
speedHackBtn.MouseButton1Click:Connect(function()
    speedHackEnabled = not speedHackEnabled
    speedHackBtn.Text = "SPEED HACK: " .. (speedHackEnabled and "ON" or "OFF")
    
    if speedHackEnabled then
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = currentWalkSpeed
            end
        end
    else
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 16
            end
        end
    end
end)

infJumpBtn.MouseButton1Click:Connect(function()
    infJumpEnabled = not infJumpEnabled
    infJumpBtn.Text = "INFINITY JUMP: " .. (infJumpEnabled and "ON" or "OFF")
    
    if infJumpEnabled then
        local connection
        connection = UserInputService.JumpRequest:Connect(function()
            local character = player.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end)
    else
        -- Отключение бесконечного прыжка
        -- В реальной реализации нужно сохранять connection и отключать его
    end
end)

antiAFKBtn.MouseButton1Click:Connect(function()
    antiAFKEnabled = not antiAFKEnabled
    antiAFKBtn.Text = "ANTI AFK: " .. (antiAFKEnabled and "ON" or "OFF")
    
    if antiAFKEnabled then
        antiAFKConnection = RunService.Heartbeat:Connect(function()
            wait(30) -- Ждем 30 секунд
            local character = player.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end)
    else
        if antiAFKConnection then
            antiAFKConnection:Disconnect()
            antiAFKConnection = nil
        end
    end
end)

-- Обработка слайдера скорости
speedSlider.MouseButton1Down:Connect(function()
    local connection
    connection = RunService.RenderStepped:Connect(function()
        local mousePos = UserInputService:GetMouseLocation()
        local sliderPos = speedSlider.AbsolutePosition
        local sliderSize = speedSlider.AbsoluteSize
        
        local relativeX = math.clamp((mousePos.X - sliderPos.X) / sliderSize.X, 0, 1)
        speedSliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
        
        currentWalkSpeed = math.floor(16 + relativeX * 50) -- от 16 до 66
        speedLabel.Text = "Speed: " .. currentWalkSpeed
        
        if speedHackEnabled then
            local character = player.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = currentWalkSpeed
                end
            end
        end
        
        if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
            connection:Disconnect()
        end
    end)
end)

-- Основной цикл обновления
RunService.Heartbeat:Connect(function()
    updateAimBot()
end)

-- Обработка смерти игрока
player.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid").Died:Connect(function()
        -- Функции не отключаются при смерти
        if speedHackEnabled then
            wait(3) -- Ждем респавн
            local newHumanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if newHumanoid then
                newHumanoid.WalkSpeed = currentWalkSpeed
            end
        end
    end)
end)

-- Инициализация
showTab("info")

print("SFXCL Script Menu loaded successfully!")
print("Version: 1.0")
print("Owner: SFXCL")
print("Telegram: SCRIPTTYTA")