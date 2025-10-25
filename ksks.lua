local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

-- Функция для создания GUI
local function createGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AimMenu"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player.PlayerGui

    -- Основной фрейм меню
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 300, 0, 200)
    mainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
    mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui

    -- Крестик закрытия
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 5)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.new(1, 1, 1)
    closeButton.Parent = mainFrame

    -- Кнопка открытия меню (скрыта изначально)
    local openButton = Instance.new("TextButton")
    openButton.Size = UDim2.new(0, 60, 0, 40)
    openButton.Position = UDim2.new(1, -70, 0, 10)
    openButton.BackgroundColor3 = Color3.fromRGB(60, 60, 255)
    openButton.Text = "Menu"
    openButton.TextColor3 = Color3.new(1, 1, 1)
    openButton.Visible = false
    openButton.Parent = screenGui

    -- Кнопка BulletTrack
    local trackButton = Instance.new("TextButton")
    trackButton.Size = UDim2.new(0, 200, 0, 50)
    trackButton.Position = UDim2.new(0.5, -100, 0.2, 0)
    trackButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    trackButton.Text = "BulletTrack: OFF"
    trackButton.TextColor3 = Color3.new(1, 1, 1)
    trackButton.Parent = mainFrame

    -- Слайдер для размера круга
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(0, 200, 0, 40)
    sliderFrame.Position = UDim2.new(0.5, -100, 0.6, 0)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    sliderFrame.Parent = mainFrame

    local sliderText = Instance.new("TextLabel")
    sliderText.Size = UDim2.new(1, 0, 0.5, 0)
    sliderText.BackgroundTransparency = 1
    sliderText.Text = "Circle Size: 50"
    sliderText.TextColor3 = Color3.new(1, 1, 1)
    sliderText.Parent = sliderFrame

    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new(0.7, 0, 0, 4)
    sliderBar.Position = UDim2.new(0.15, 0, 0.7, 0)
    sliderBar.BackgroundColor3 = Color3.new(1, 1, 1)
    sliderBar.Parent = sliderFrame

    local sliderHandle = Instance.new("Frame")
    sliderHandle.Size = UDim2.new(0, 20, 0, 20)
    sliderHandle.Position = UDim2.new(0.5, -10, 0.6, -10)
    sliderHandle.BackgroundColor3 = Color3.new(0, 1, 1)
    sliderHandle.Parent = sliderFrame
    local handleCorner = Instance.new("UICorner")
    handleCorner.CornerRadius = UDim.new(1, 0)
    handleCorner.Parent = sliderHandle

    -- Круг прицела (исправленный)
    local aimCircle = Instance.new("Frame")
    aimCircle.Size = UDim2.new(0, 50, 0, 50)
    aimCircle.Position = UDim2.new(0.5, -25, 0.5, -25)
    aimCircle.BackgroundTransparency = 0.3
    aimCircle.BackgroundColor3 = Color3.new(1, 1, 1)
    aimCircle.Visible = false
    aimCircle.ZIndex = 10
    
    -- Делаем ровный круг с обводкой
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = aimCircle
    
    local circleStroke = Instance.new("UIStroke")
    circleStroke.Color = Color3.new(0, 0, 0)
    circleStroke.Thickness = 2
    circleStroke.Parent = aimCircle
    
    aimCircle.Parent = screenGui

    return {
        screenGui = screenGui,
        mainFrame = mainFrame,
        openButton = openButton,
        trackButton = trackButton,
        aimCircle = aimCircle,
        sliderText = sliderText,
        sliderHandle = sliderHandle,
        sliderBar = sliderBar
    }
end

-- Создаем GUI
local gui = createGUI()

-- Переменные
local trackEnabled = false
local circleSize = 50
local connection
local targetCharacter = nil

-- Функция для получения текущего оружия
function getCurrentWeapon()
    local character = player.Character
    if not character then return nil end
    
    -- Ищем оружие в инвентаре или руках
    local backpack = player:FindFirstChild("Backpack")
    local humanoid = character:FindFirstChild("Humanoid")
    
    if humanoid and humanoid:IsA("Humanoid") then
        local equippedTool = humanoid:FindFirstChildOfClass("Tool")
        if equippedTool then
            return equippedTool
        end
    end
    
    if backpack then
        for _, tool in pairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                return tool
            end
        end
    end
    
    return nil
end

-- Функция для поиска цели в круге
function findTargetInCircle()
    local character = player.Character
    if not character then return nil end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return nil end
    
    local circleCenter = Vector2.new(
        gui.aimCircle.AbsolutePosition.X + gui.aimCircle.AbsoluteSize.X / 2,
        gui.aimCircle.AbsolutePosition.Y + gui.aimCircle.AbsoluteSize.Y / 2
    )
    local circleRadius = gui.aimCircle.AbsoluteSize.X / 2
    
    local closestTarget = nil
    local closestDistance = circleRadius
    
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local targetRoot = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
            local targetHead = otherPlayer.Character:FindFirstChild("Head")
            
            if targetRoot and targetHead then
                local headPos = targetHead.Position
                local screenPos, visible = workspace.CurrentCamera:WorldToScreenPoint(headPos)
                
                if visible then
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - circleCenter).Magnitude
                    if distance <= closestDistance then
                        closestDistance = distance
                        closestTarget = otherPlayer.Character
                    end
                end
            end
        end
    end
    
    return closestTarget
end

-- Функция для перенаправления пуль
function redirectBullets()
    if trackEnabled then
        targetCharacter = findTargetInCircle()
        
        if targetCharacter then
            local weapon = getCurrentWeapon()
            if weapon then
                -- Меняем цель оружия на найденного игрока
                local targetHead = targetCharacter:FindFirstChild("Head")
                local targetRoot = targetCharacter:FindFirstChild("HumanoidRootPart")
                
                if targetHead then
                    -- Это упрощенная реализация - в реальной игре нужно адаптировать под конкретный механизм стрельбы
                    mouse.Target = targetHead
                elseif targetRoot then
                    mouse.Target = targetRoot
                end
            end
        end
    end
end

-- Обработчики событий
gui.trackButton.MouseButton1Click:Connect(function()
    trackEnabled = not trackEnabled
    gui.aimCircle.Visible = trackEnabled
    
    if trackEnabled then
        gui.trackButton.Text = "BulletTrack: ON"
        gui.trackButton.BackgroundColor3 = Color3.fromRGB(60, 255, 60)
        
        -- Запускаем проверку целей
        if connection then
            connection:Disconnect()
        end
        connection = RunService.Heartbeat:Connect(redirectBullets)
        
    else
        gui.trackButton.Text = "BulletTrack: OFF"
        gui.trackButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        targetCharacter = nil
        
        if connection then
            connection:Disconnect()
            connection = nil
        end
    end
end)

gui.openButton.MouseButton1Click:Connect(function()
    gui.mainFrame.Visible = true
    gui.openButton.Visible = false
end)

-- Обработка слайдера
local function updateSlider(value)
    circleSize = math.floor(20 + value * 280) -- от 20 до 300
    gui.aimCircle.Size = UDim2.new(0, circleSize, 0, circleSize)
    gui.aimCircle.Position = UDim2.new(0.5, -circleSize/2, 0.5, -circleSize/2)
    gui.sliderText.Text = "Circle Size: " .. circleSize
    gui.sliderHandle.Position = UDim2.new(value, -10, 0.6, -10)
end

-- Инициализация слайдера
updateSlider(0.1) -- Начальное значение ~50

gui.sliderHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        local dragConnection
        local function updateHandlePosition()
            local mouseLocation = UserInputService:GetMouseLocation()
            local sliderAbsolutePos = gui.sliderBar.AbsolutePosition
            local sliderAbsoluteSize = gui.sliderBar.AbsoluteSize
            
            local relativeX = math.clamp(
                (mouseLocation.X - sliderAbsolutePos.X) / sliderAbsoluteSize.X, 
                0, 1
            )
            
            updateSlider(relativeX)
        end
        
        dragConnection = RunService.Heartbeat:Connect(updateHandlePosition)
        
        local function endDrag(input)
            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                if dragConnection then
                    dragConnection:Disconnect()
                end
            end
        end
        
        gui.sliderHandle.InputEnded:Connect(endDrag)
        UserInputService.InputEnded:Connect(endDrag)
    end
end)

-- Обработка смерти игрока
player.CharacterAdded:Connect(function(character)
    -- Ждем появления Humanoid
    character:WaitForChild("Humanoid")
    
    -- Пересоздаем GUI если нужно
    if not gui.screenGui or not gui.screenGui.Parent then
        gui = createGUI()
    end
end)

player.CharacterRemoving:Connect(function()
    -- Отключаем трекинг при смерти
    trackEnabled = false
    gui.aimCircle.Visible = false
    gui.trackButton.Text = "BulletTrack: OFF"
    gui.trackButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    
    if connection then
        connection:Disconnect()
        connection = nil
    end
end)

-- Закрытие меню
gui.closeButton.MouseButton1Click:Connect(function()
    gui.mainFrame.Visible = false
    gui.openButton.Visible = true
end)

print("Aim menu loaded! Circle size: 20-300px")