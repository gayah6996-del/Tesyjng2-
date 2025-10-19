-- SANSTRO Menu for Mobile
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

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

local ScreenGui = nil
local MainFrame = nil
local minimized = false
local fovCircle = nil
local savedPosition = UDim2.new(0, 10, 0, 10)
local savedButtonPosition = UDim2.new(0, 10, 0, 10)
local isGuiOpen = false  -- Меню изначально закрыто
local OpenCloseButton = nil

-- ESP объекты
local espObjects = {}
local espConnections = {}
local espCountText = nil
local noclipConnection = nil

-- Фоновая анимация
local backgroundAnimation = nil
local treeParts = {}
local animationConnection = nil

-- Функция создания анимированного фона с падающим деревом
local function createBackgroundAnimation()
    if backgroundAnimation then
        backgroundAnimation:Destroy()
        backgroundAnimation = nil
    end
    
    if animationConnection then
        animationConnection:Disconnect()
        animationConnection = nil
    end
    
    -- Создаем контейнер для фона
    backgroundAnimation = Instance.new("Frame")
    backgroundAnimation.Name = "BackgroundAnimation"
    backgroundAnimation.Size = UDim2.new(1, 0, 1, 0)
    backgroundAnimation.Position = UDim2.new(0, 0, 0, 0)
    backgroundAnimation.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
    backgroundAnimation.BackgroundTransparency = 0.3
    backgroundAnimation.ZIndex = 0
    backgroundAnimation.Parent = MainFrame
    
    local blurEffect = Instance.new("BlurEffect")
    blurEffect.Size = 8
    blurEffect.Parent = backgroundAnimation
    
    -- Создаем части дерева
    local function createTreePart(size, position, color, cornerRadius)
        local part = Instance.new("Frame")
        part.Size = size
        part.Position = position
        part.BackgroundColor3 = color
        part.BorderSizePixel = 0
        part.ZIndex = 1
        part.Parent = backgroundAnimation
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = cornerRadius
        corner.Parent = part
        
        return part
    end
    
    -- Ствол дерева (коричневый)
    local trunk = createTreePart(
        UDim2.new(0, 15, 0, 80),
        UDim2.new(0.5, -7, 0, -80),
        Color3.fromRGB(101, 67, 33),
        UDim.new(0, 4)
    )
    table.insert(treeParts, trunk)
    
    -- Ветви дерева (зеленые, разные формы)
    local branch1 = createTreePart(
        UDim2.new(0, 60, 0, 40),
        UDim2.new(0.5, -30, 0, -100),
        Color3.fromRGB(34, 139, 34),
        UDim.new(0, 20)
    )
    table.insert(treeParts, branch1)
    
    local branch2 = createTreePart(
        UDim2.new(0, 50, 0, 35),
        UDim2.new(0.5, -25, 0, -110),
        Color3.fromRGB(40, 150, 40),
        UDim.new(0, 18)
    )
    table.insert(treeParts, branch2)
    
    local branch3 = createTreePart(
        UDim2.new(0, 45, 0, 30),
        UDim2.new(0.5, -22, 0, -120),
        Color3.fromRGB(46, 160, 46),
        UDim.new(0, 15)
    )
    table.insert(treeParts, branch3)
    
    -- Листья (маленькие круги)
    for i = 1, 8 do
        local leaf = createTreePart(
            UDim2.new(0, math.random(8, 15), 0, math.random(8, 15)),
            UDim2.new(0.5 + (math.random(-20, 20) / 100), 0, 0, -130 + math.random(-10, 10)),
            Color3.fromRGB(50 + math.random(0, 30), 160 + math.random(0, 30), 50 + math.random(0, 30)),
            UDim.new(1, 0)
        )
        table.insert(treeParts, leaf)
    end
    
    -- Анимация падения дерева
    local function animateTree()
        local fallTime = 3 -- Время падения в секундах
        local rotationSpeed = 30 -- Скорость вращения
        
        for _, part in pairs(treeParts) do
            part.Position = UDim2.new(
                part.Position.X.Scale,
                part.Position.X.Offset,
                0,
                -100
            )
            part.Rotation = 0
        end
        
        local startTime = tick()
        
        animationConnection = RunService.Heartbeat:Connect(function()
            local elapsed = tick() - startTime
            local progress = math.min(elapsed / fallTime, 1)
            
            -- Параболическая траектория с вращением
            local yProgress = progress * 1.8 -- Ускоряем падение
            local rotation = progress * rotationSpeed
            
            for _, part in pairs(treeParts) do
                -- Добавляем немного случайности для реалистичности
                local randomOffset = (part.Name == "Leaf") and math.random(-2, 2) or 0
                
                part.Position = UDim2.new(
                    part.Position.X.Scale,
                    part.Position.X.Offset + randomOffset,
                    yProgress,
                    -100 + (yProgress * (MainFrame.AbsoluteSize.Y + 100))
                )
                part.Rotation = rotation + randomOffset * 5
            end
            
            if progress >= 1 then
                -- Перезапускаем анимацию после небольшой паузы
                wait(1.5)
                animateTree()
            end
        end)
    end
    
    -- Запускаем анимацию
    animateTree()
end

-- Функция создания FOV Circle
local function createFOVCircle()
    if fovCircle then
        fovCircle:Remove()
    end
    
    fovCircle = Drawing.new("Circle")
    fovCircle.Visible = false
    fovCircle.Color = Color3.fromRGB(255, 0, 0)
    fovCircle.Thickness = 1
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

-- Функция создания кнопки открытия/закрытия
local function createOpenCloseButton()
    if OpenCloseButton then
        OpenCloseButton:Destroy()
    end

    OpenCloseButton = Instance.new("TextButton")
    OpenCloseButton.Name = "OpenCloseButton"
    OpenCloseButton.Size = UDim2.new(0, 60, 0, 60)
    OpenCloseButton.Position = savedButtonPosition
    OpenCloseButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    OpenCloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    OpenCloseButton.Text = "≡"
    OpenCloseButton.Font = Enum.Font.GothamBold
    OpenCloseButton.TextSize = 24
    OpenCloseButton.ZIndex = 10
    OpenCloseButton.Active = true
    OpenCloseButton.Draggable = true
    OpenCloseButton.Parent = ScreenGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = OpenCloseButton

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(255, 255, 255)
    Stroke.Thickness = 2
    Stroke.Parent = OpenCloseButton

    -- Обработчик нажатия
    OpenCloseButton.MouseButton1Click:Connect(function()
        isGuiOpen = not isGuiOpen
        MainFrame.Visible = isGuiOpen
        
        if isGuiOpen then
            OpenCloseButton.Text = "≡"
            OpenCloseButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        else
            OpenCloseButton.Text = "≡"
            OpenCloseButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        end
    end)

    -- Сохраняем позицию кнопки при перетаскивании
    OpenCloseButton.DragStopped:Connect(function()
        savedButtonPosition = OpenCloseButton.Position
    end)
end

-- Функция для переключения кнопок
local function toggleButton(button, enabled)
    if enabled then
        button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        button.Text = "ON"
    else
        button.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
        button.Text = "OFF"
    end
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

-- ESP Functions
local function createESP(otherPlayer)
    if otherPlayer == player then return end
    
    cleanupESP(otherPlayer)
    
    espObjects[otherPlayer] = {
        tracer = nil,
        box = nil,
        health = nil,
        distance = nil
    }
    
    local function updateESP()
        if not espObjects[otherPlayer] then return end
        
        -- Check if player is dead or doesn't exist
        if not otherPlayer.Character or not otherPlayer.Character:FindFirstChild("HumanoidRootPart") or not otherPlayer.Character:FindFirstChild("Humanoid") then
            if espObjects[otherPlayer].tracer then espObjects[otherPlayer].tracer.Visible = false end
            if espObjects[otherPlayer].box then espObjects[otherPlayer].box.Visible = false end
            if espObjects[otherPlayer].health then espObjects[otherPlayer].health.Visible = false end
            if espObjects[otherPlayer].distance then espObjects[otherPlayer].distance.Visible = false end
            return
        end
        
        local rootPart = otherPlayer.Character.HumanoidRootPart
        local humanoid = otherPlayer.Character.Humanoid
        local head = otherPlayer.Character:FindFirstChild("Head")
        
        if not head then return end
        
        -- Check if player is dead
        if humanoid.Health <= 0 then
            if espObjects[otherPlayer].tracer then espObjects[otherPlayer].tracer.Visible = false end
            if espObjects[otherPlayer].box then espObjects[otherPlayer].box.Visible = false end
            if espObjects[otherPlayer].health then espObjects[otherPlayer].health.Visible = false end
            if espObjects[otherPlayer].distance then espObjects[otherPlayer].distance.Visible = false end
            return
        end
        
        local vector, onScreen = workspace.CurrentCamera:WorldToViewportPoint(rootPart.Position)
        
        if onScreen then
            -- Tracer
            if espTracersEnabled then
                if not espObjects[otherPlayer].tracer then
                    espObjects[otherPlayer].tracer = Drawing.new("Line")
                    espObjects[otherPlayer].tracer.Thickness = 1
                    espObjects[otherPlayer].tracer.Color = Color3.fromRGB(255, 0, 0)
                end
                
                local screenCenter = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y)
                espObjects[otherPlayer].tracer.From = screenCenter
                espObjects[otherPlayer].tracer.To = Vector2.new(vector.X, vector.Y)
                espObjects[otherPlayer].tracer.Visible = true
            elseif espObjects[otherPlayer].tracer then
                espObjects[otherPlayer].tracer.Visible = false
            end
            
            -- Box ESP
            if espBoxEnabled then
                if not espObjects[otherPlayer].box then
                    espObjects[otherPlayer].box = Drawing.new("Square")
                    espObjects[otherPlayer].box.Thickness = 1
                    espObjects[otherPlayer].box.Color = Color3.fromRGB(255, 0, 0)
                    espObjects[otherPlayer].box.Filled = false
                end
                
                local headPos = workspace.CurrentCamera:WorldToViewportPoint(head.Position)
                local rootPos = workspace.CurrentCamera:WorldToViewportPoint(rootPart.Position)
                
                local size = Vector2.new(2000 / rootPos.Z, 3000 / rootPos.Z)
                local position = Vector2.new(headPos.X - size.X / 2, headPos.Y - size.Y / 2)
                
                espObjects[otherPlayer].box.Size = size
                espObjects[otherPlayer].box.Position = position
                espObjects[otherPlayer].box.Visible = true
            elseif espObjects[otherPlayer].box then
                espObjects[otherPlayer].box.Visible = false
            end
            
            -- Health ESP
            if espHealthEnabled then
                if not espObjects[otherPlayer].health then
                    espObjects[otherPlayer].health = Drawing.new("Text")
                    espObjects[otherPlayer].health.Size = 14
                    espObjects[otherPlayer].health.Center = true
                    espObjects[otherPlayer].health.Outline = true
                    espObjects[otherPlayer].health.Color = Color3.fromRGB(255, 0, 0)
                end
                
                local headPos = workspace.CurrentCamera:WorldToViewportPoint(head.Position)
                espObjects[otherPlayer].health.Position = Vector2.new(headPos.X, headPos.Y - 40)
                espObjects[otherPlayer].health.Text = "HP: " .. math.floor(humanoid.Health)
                espObjects[otherPlayer].health.Visible = true
            elseif espObjects[otherPlayer].health then
                espObjects[otherPlayer].health.Visible = false
            end
            
            -- Distance ESP
            if espDistanceEnabled then
                if not espObjects[otherPlayer].distance then
                    espObjects[otherPlayer].distance = Drawing.new("Text")
                    espObjects[otherPlayer].distance.Size = 14
                    espObjects[otherPlayer].distance.Center = true
                    espObjects[otherPlayer].distance.Outline = true
                    espObjects[otherPlayer].distance.Color = Color3.fromRGB(255, 0, 0)
                end
                
                local headPos = workspace.CurrentCamera:WorldToViewportPoint(head.Position)
                local distance = (player.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
                espObjects[otherPlayer].distance.Position = Vector2.new(headPos.X, headPos.Y - 60)
                espObjects[otherPlayer].distance.Text = "Distance: " .. math.floor(distance)
                espObjects[otherPlayer].distance.Visible = true
            elseif espObjects[otherPlayer].distance then
                espObjects[otherPlayer].distance.Visible = false
            end
        else
            if espObjects[otherPlayer].tracer then espObjects[otherPlayer].tracer.Visible = false end
            if espObjects[otherPlayer].box then espObjects[otherPlayer].box.Visible = false end
            if espObjects[otherPlayer].health then espObjects[otherPlayer].health.Visible = false end
            if espObjects[otherPlayer].distance then espObjects[otherPlayer].distance.Visible = false end
        end
    end
    
    -- Update ESP continuously
    espConnections[otherPlayer] = RunService.Heartbeat:Connect(updateESP)
    
    -- Clean up when player leaves
    otherPlayer.AncestryChanged:Connect(function()
        if not otherPlayer.Parent then
            cleanupESP(otherPlayer)
        end
    end)
end

-- ESP Count Function
local function updateESPCount()
    if not espCountEnabled or not espCountText then return end
    
    local aliveCount = 0
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("Humanoid") and otherPlayer.Character.Humanoid.Health > 0 then
            aliveCount = aliveCount + 1
        end
    end
    
    espCountText.Text = "Players: " .. aliveCount
    espCountText.Visible = true
end

-- Improved AimBot with wall check and FOV
local function isPlayerVisible(targetPlayer)
    if not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return false
    end
    
    local targetRoot = targetPlayer.Character.HumanoidRootPart
    local camera = workspace.CurrentCamera
    local origin = camera.CFrame.Position
    
    -- Raycast to target
    local direction = (targetRoot.Position - origin).Unit
    local ray = Ray.new(origin, direction * 1000)
    
    local ignoreList = {player.Character, camera}
    local hit, hitPosition = workspace:FindPartOnRayWithIgnoreList(ray, ignoreList)
    
    if hit then
        -- Check if we hit the target player
        local hitModel = hit:FindFirstAncestorOfClass("Model")
        if hitModel and hitModel == targetPlayer.Character then
            return true
        end
    end
    
    return false
end

-- Check if target is within FOV circle
local function isInFOV(targetPosition)
    local camera = workspace.CurrentCamera
    local screenPoint, onScreen = camera:WorldToViewportPoint(targetPosition)
    
    if not onScreen then return false end
    
    local center = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    local targetPoint = Vector2.new(screenPoint.X, screenPoint.Y)
    local distance = (targetPoint - center).Magnitude
    
    return distance <= aimBotFOV
end

-- Функция создания GUI
local function createGUI()
    if ScreenGui then
        savedPosition = MainFrame.Position
        ScreenGui:Destroy()
        ScreenGui = nil
        MainFrame = nil
        OpenCloseButton = nil
    end

    -- Create GUI
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SANSTRO_GUI"
    ScreenGui.Parent = player.PlayerGui
    ScreenGui.ResetOnSpawn = false

    MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 300, 0, 400)
    MainFrame.Position = savedPosition
    MainFrame.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
    MainFrame.BackgroundTransparency = 0.3 -- Полупрозрачный фон
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Visible = isGuiOpen  -- Состояние сохраняется
    MainFrame.Parent = ScreenGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = MainFrame

    -- Создаем анимированный фон ДО других элементов
    createBackgroundAnimation()

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Position = UDim2.new(0, 0, 0, 0)
    Title.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
    Title.BackgroundTransparency = 0.2
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Text = "SANSTRO|t.me//SCRIPTYTA"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.ZIndex = 2
    Title.Parent = MainFrame

    local TabButtons = Instance.new("Frame")
    TabButtons.Name = "TabButtons"
    TabButtons.Size = UDim2.new(1, 0, 0, 40)
    TabButtons.Position = UDim2.new(0, 0, 0, 40)
    TabButtons.BackgroundTransparency = 0.2
    TabButtons.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
    TabButtons.ZIndex = 2
    TabButtons.Parent = MainFrame

    -- Movement Tab
    local MovementTab = Instance.new("TextButton")
    MovementTab.Name = "MovementTab"
    MovementTab.Size = UDim2.new(0.33, 0, 1, 0)
    MovementTab.Position = UDim2.new(0, 0, 0, 0)
    MovementTab.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
    MovementTab.BackgroundTransparency = 0.2
    MovementTab.TextColor3 = Color3.fromRGB(255, 255, 255)
    MovementTab.Text = "Movement"
    MovementTab.Font = Enum.Font.Gotham
    MovementTab.TextSize = 14
    MovementTab.ZIndex = 3
    MovementTab.Parent = TabButtons

    -- Visual Tab
    local VisualTab = Instance.new("TextButton")
    VisualTab.Name = "VisualTab"
    VisualTab.Size = UDim2.new(0.33, 0, 1, 0)
    VisualTab.Position = UDim2.new(0.33, 0, 0, 0)
    VisualTab.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
    VisualTab.BackgroundTransparency = 0.2
    VisualTab.TextColor3 = Color3.fromRGB(255, 255, 255)
    VisualTab.Text = "Visual"
    VisualTab.Font = Enum.Font.Gotham
    VisualTab.TextSize = 14
    VisualTab.ZIndex = 3
    VisualTab.Parent = TabButtons

    -- AimBot Tab
    local AimBotTab = Instance.new("TextButton")
    AimBotTab.Name = "AimBotTab"
    AimBotTab.Size = UDim2.new(0.34, 0, 1, 0)
    AimBotTab.Position = UDim2.new(0.66, 0, 0, 0)
    AimBotTab.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
    AimBotTab.BackgroundTransparency = 0.2
    AimBotTab.TextColor3 = Color3.fromRGB(255, 255, 255)
    AimBotTab.Text = "AimBot"
    AimBotTab.Font = Enum.Font.Gotham
    AimBotTab.TextSize = 14
    AimBotTab.ZIndex = 3
    AimBotTab.Parent = TabButtons

    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Size = UDim2.new(1, -20, 1, -100)
    ContentFrame.Position = UDim2.new(0, 10, 0, 90)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.ZIndex = 2
    ContentFrame.Parent = MainFrame

    local ScrollFrame = Instance.new("ScrollingFrame")
    ScrollFrame.Name = "ScrollFrame"
    ScrollFrame.Size = UDim2.new(1, 0, 1, 0)
    ScrollFrame.BackgroundTransparency = 1
    ScrollFrame.ScrollBarThickness = 4
    ScrollFrame.ZIndex = 2
    ScrollFrame.Parent = ContentFrame

    -- Movement Content
    local MovementContent = Instance.new("Frame")
    MovementContent.Name = "MovementContent"
    MovementContent.Size = UDim2.new(1, 0, 0, 300)
    MovementContent.BackgroundTransparency = 1
    MovementContent.Visible = true
    MovementContent.ZIndex = 2
    MovementContent.Parent = ScrollFrame

    -- Speed Hack
    local SpeedHackFrame = Instance.new("Frame")
    SpeedHackFrame.Name = "SpeedHackFrame"
    SpeedHackFrame.Size = UDim2.new(1, 0, 0, 80)
    SpeedHackFrame.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
    SpeedHackFrame.BackgroundTransparency = 0.3
    SpeedHackFrame.BorderSizePixel = 0
    SpeedHackFrame.ZIndex = 2
    SpeedHackFrame.Parent = MovementContent

    local SpeedHackCorner = Instance.new("UICorner")
    SpeedHackCorner.CornerRadius = UDim.new(0, 6)
    SpeedHackCorner.Parent = SpeedHackFrame

    local SpeedHackLabel = Instance.new("TextLabel")
    SpeedHackLabel.Name = "SpeedHackLabel"
    SpeedHackLabel.Size = UDim2.new(0.6, 0, 0, 30)
    SpeedHackLabel.Position = UDim2.new(0, 10, 0, 10)
    SpeedHackLabel.BackgroundTransparency = 1
    SpeedHackLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SpeedHackLabel.Text = "Speed Hack"
    SpeedHackLabel.Font = Enum.Font.Gotham
    SpeedHackLabel.TextSize = 14
    SpeedHackLabel.TextXAlignment = Enum.TextXAlignment.Left
    SpeedHackLabel.ZIndex = 3
    SpeedHackLabel.Parent = SpeedHackFrame

    local SpeedHackToggle = Instance.new("TextButton")
    SpeedHackToggle.Name = "SpeedHackToggle"
    SpeedHackToggle.Size = UDim2.new(0.3, 0, 0, 30)
    SpeedHackToggle.Position = UDim2.new(0.7, 0, 0, 10)
    SpeedHackToggle.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
    SpeedHackToggle.BackgroundTransparency = 0.2
    SpeedHackToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    SpeedHackToggle.Text = "OFF"
    SpeedHackToggle.Font = Enum.Font.Gotham
    SpeedHackToggle.TextSize = 12
    SpeedHackToggle.ZIndex = 3
    SpeedHackToggle.Parent = SpeedHackFrame

    local SpeedHackSlider = Instance.new("Frame")
    SpeedHackSlider.Name = "SpeedHackSlider"
    SpeedHackSlider.Size = UDim2.new(1, -20, 0, 30)
    SpeedHackSlider.Position = UDim2.new(0, 10, 0, 45)
    SpeedHackSlider.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
    SpeedHackSlider.BackgroundTransparency = 0.3
    SpeedHackSlider.BorderSizePixel = 0
    SpeedHackSlider.Visible = false
    SpeedHackSlider.ZIndex = 3
    SpeedHackSlider.Parent = SpeedHackFrame

    local SpeedHackSliderCorner = Instance.new("UICorner")
    SpeedHackSliderCorner.CornerRadius = UDim.new(0, 4)
    SpeedHackSliderCorner.Parent = SpeedHackSlider

    local SpeedValue = Instance.new("TextLabel")
    SpeedValue.Name = "SpeedValue"
    SpeedValue.Size = UDim2.new(1, 0, 1, 0)
    SpeedValue.BackgroundTransparency = 1
    SpeedValue.TextColor3 = Color3.fromRGB(255, 255, 255)
    SpeedValue.Text = "Speed: " .. currentSpeed
    SpeedValue.Font = Enum.Font.Gotham
    SpeedValue.TextSize = 12
    SpeedValue.ZIndex = 4
    SpeedValue.Parent = SpeedHackSlider

    -- Jump Hack
    local JumpHackFrame = Instance.new("Frame")
    JumpHackFrame.Name = "JumpHackFrame"
    JumpHackFrame.Size = UDim2.new(1, 0, 0, 40)
    JumpHackFrame.Position = UDim2.new(0, 0, 0, 90)
    JumpHackFrame.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
    JumpHackFrame.BackgroundTransparency = 0.3
    JumpHackFrame.BorderSizePixel = 0
    JumpHackFrame.ZIndex = 2
    JumpHackFrame.Parent = MovementContent

    local JumpHackCorner = Instance.new("UICorner")
    JumpHackCorner.CornerRadius = UDim.new(0, 6)
    JumpHackCorner.Parent = JumpHackFrame

    local JumpHackLabel = Instance.new("TextLabel")
    JumpHackLabel.Name = "JumpHackLabel"
    JumpHackLabel.Size = UDim2.new(0.6, 0, 1, 0)
    JumpHackLabel.Position = UDim2.new(0, 10, 0, 0)
    JumpHackLabel.BackgroundTransparency = 1
    JumpHackLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    JumpHackLabel.Text = "Jump Hack"
    JumpHackLabel.Font = Enum.Font.Gotham
    JumpHackLabel.TextSize = 14
    JumpHackLabel.TextXAlignment = Enum.TextXAlignment.Left
    JumpHackLabel.ZIndex = 3
    JumpHackLabel.Parent = JumpHackFrame

    local JumpHackToggle = Instance.new("TextButton")
    JumpHackToggle.Name = "JumpHackToggle"
    JumpHackToggle.Size = UDim2.new(0.3, 0, 0, 30)
    JumpHackToggle.Position = UDim2.new(0.7, 0, 0.125, 0)
    JumpHackToggle.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
    JumpHackToggle.BackgroundTransparency = 0.2
    JumpHackToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    JumpHackToggle.Text = "OFF"
    JumpHackToggle.Font = Enum.Font.Gotham
    JumpHackToggle.TextSize = 12
    JumpHackToggle.ZIndex = 3
    JumpHackToggle.Parent = JumpHackFrame

    -- NoClip
    local NoClipFrame = Instance.new("Frame")
    NoClipFrame.Name = "NoClipFrame"
    NoClipFrame.Size = UDim2.new(1, 0, 0, 40)
    NoClipFrame.Position = UDim2.new(0, 0, 0, 140)
    NoClipFrame.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
    NoClipFrame.BackgroundTransparency = 0.3
    NoClipFrame.BorderSizePixel = 0
    NoClipFrame.ZIndex = 2
    NoClipFrame.Parent = MovementContent

    local NoClipCorner = Instance.new("UICorner")
    NoClipCorner.CornerRadius = UDim.new(0, 6)
    NoClipCorner.Parent = NoClipFrame

    local NoClipLabel = Instance.new("TextLabel")
    NoClipLabel.Name = "NoClipLabel"
    NoClipLabel.Size = UDim2.new(0.6, 0, 1, 0)
    NoClipLabel.Position = UDim2.new(0, 10, 0, 0)
    NoClipLabel.BackgroundTransparency = 1
    NoClipLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    NoClipLabel.Text = "NoClip"
    NoClipLabel.Font = Enum.Font.Gotham
    NoClipLabel.TextSize = 14
    NoClipLabel.TextXAlignment = Enum.TextXAlignment.Left
    NoClipLabel.ZIndex = 3
    NoClipLabel.Parent = NoClipFrame

    local NoClipToggle = Instance.new("TextButton")
    NoClipToggle.Name = "NoClipToggle"
    NoClipToggle.Size = UDim2.new(0.3, 0, 0, 30)
    NoClipToggle.Position = UDim2.new(0.7, 0, 0.125, 0)
    NoClipToggle.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
    NoClipToggle.BackgroundTransparency = 0.2
    NoClipToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    NoClipToggle.Text = "OFF"
    NoClipToggle.Font = Enum.Font.Gotham
    NoClipToggle.TextSize = 12
    NoClipToggle.ZIndex = 3
    NoClipToggle.Parent = NoClipFrame

    -- Visual Content
    local VisualContent = Instance.new("Frame")
    VisualContent.Name = "VisualContent"
    VisualContent.Size = UDim2.new(1, 0, 0, 300)
    VisualContent.BackgroundTransparency = 1
    VisualContent.Visible = false
    VisualContent.ZIndex = 2
    VisualContent.Parent = ScrollFrame

    -- ESP Tracers
    local ESPTracersFrame = Instance.new("Frame")
    ESPTracersFrame.Name = "ESPTracersFrame"
    ESPTracersFrame.Size = UDim2.new(1, 0, 0, 40)
    ESPTracersFrame.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
    ESPTracersFrame.BackgroundTransparency = 0.3
    ESPTracersFrame.BorderSizePixel = 0
    ESPTracersFrame.ZIndex = 2
    ESPTracersFrame.Parent = VisualContent

    local ESPTracersCorner = Instance.new("UICorner")
    ESPTracersCorner.CornerRadius = UDim.new(0, 6)
    ESPTracersCorner.Parent = ESPTracersFrame

    local ESPTracersLabel = Instance.new("TextLabel")
    ESPTracersLabel.Name = "ESPTracersLabel"
    ESPTracersLabel.Size = UDim2.new(0.6, 0, 1, 0)
    ESPTracersLabel.Position = UDim2.new(0, 10, 0, 0)
    ESPTracersLabel.BackgroundTransparency = 1
    ESPTracersLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ESPTracersLabel.Text = "ESP Tracers"
    ESPTracersLabel.Font = Enum.Font.Gotham
    ESPTracersLabel.TextSize = 14
    ESPTracersLabel.TextXAlignment = Enum.TextXAlignment.Left
    ESPTracersLabel.ZIndex = 3
    ESPTracersLabel.Parent = ESPTracersFrame

    local ESPTracersToggle = Instance.new("TextButton")
    ESPTracersToggle.Name = "ESPTracersToggle"
    ESPTracersToggle.Size = UDim2.new(0.3, 0, 0, 30)
    ESPTracersToggle.Position = UDim2.new(0.7, 0, 0.125, 0)
    ESPTracersToggle.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
    ESPTracersToggle.BackgroundTransparency = 0.2
    ESPTracersToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    ESPTracersToggle.Text = "OFF"
    ESPTracersToggle.Font = Enum.Font.Gotham
    ESPTracersToggle.TextSize = 12
    ESPTracersToggle.ZIndex = 3
    ESPTracersToggle.Parent = ESPTracersFrame

    -- ESP Box
    local ESPBoxFrame = Instance.new("Frame")
    ESPBoxFrame.Name = "ESPBoxFrame"
    ESPBoxFrame.Size = UDim2.new(1, 0, 0, 40)
    ESPBoxFrame.Position = UDim2.new(0, 0, 0, 50)
    ESPBoxFrame.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
    ESPBoxFrame.BackgroundTransparency = 0.3
    ESPBoxFrame.BorderSizePixel = 0
    ESPBoxFrame.ZIndex = 2
    ESPBoxFrame.Parent = VisualContent

    local ESPBoxCorner = Instance.new("UICorner")
    ESPBoxCorner.CornerRadius = UDim.new(0, 6)
    ESPBoxCorner.Parent = ESPBoxFrame

    local ESPBoxLabel = Instance.new("TextLabel")
    ESPBoxLabel.Name = "ESPBoxLabel"
    ESPBoxLabel.Size = UDim2.new(0.6, 0, 1, 0)
    ESPBoxLabel.Position = UDim2.new(0, 10, 0, 0)
    ESPBoxLabel.BackgroundTransparency = 1
    ESPBoxLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ESPBoxLabel.Text = "ESP Box"
    ESPBoxLabel.Font = Enum.Font.Gotham
    ESPBoxLabel.TextSize = 14
    ESPBoxLabel.TextXAlignment = Enum.TextXAlignment.Left
    ESPBoxLabel.ZIndex = 3
    ESPBoxLabel.Parent = ESPBoxFrame

    local ESPBoxToggle = Instance.new("TextButton")
    ESPBoxToggle.Name = "ESPBoxToggle"
    ESPBoxToggle.Size = UDim2.new(0.3, 0, 0, 30)
    ESPBoxToggle.Position = UDim2.new(0.7, 0, 0.125, 0)
    ESPBoxToggle.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
    ESPBoxToggle.BackgroundTransparency = 0.2
    ESPBoxToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    ESPBoxToggle.Text = "OFF"
    ESPBoxToggle.Font = Enum.Font.Gotham
    ESPBoxToggle.TextSize = 12
    ESPBoxToggle.ZIndex = 3
    ESPBoxToggle.Parent = ESPBoxFrame

    -- ESP Health
    local ESPHealthFrame = Instance.new("Frame")
    ESPHealthFrame.Name = "ESPHealthFrame"
    ESPHealthFrame.Size = UDim2.new(1, 0, 0, 40)
    ESPHealthFrame.Position = UDim2.new(0, 0, 0, 100)
    ESPHealthFrame.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
    ESPHealthFrame.BackgroundTransparency = 0.3
    ESPHealthFrame.BorderSizePixel = 0
    ESPHealthFrame.ZIndex = 2
    ESPHealthFrame.Parent = VisualContent

    local ESPHealthCorner = Instance.new("UICorner")
    ESPHealthCorner.CornerRadius = UDim.new(0, 6)
    ESPHealthCorner.Parent = ESPHealthFrame

    local ESPHealthLabel = Instance.new("TextLabel")
    ESPHealthLabel.Name = "ESPHealthLabel"
    ESPHealthLabel.Size = UDim2.new(0.6, 0, 1, 0)
    ESPHealthLabel.Position = UDim2.new(0, 10, 0, 0)
    ESPHealthLabel.BackgroundTransparency = 1
    ESPHealthLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ESPHealthLabel.Text = "ESP Health"
    ESPHealthLabel.Font = Enum.Font.Gotham
    ESPHealthLabel.TextSize = 14
    ESPHealthLabel.TextXAlignment = Enum.TextXAlignment.Left
    ESPHealthLabel.ZIndex = 3
    ESPHealthLabel.Parent = ESPHealthFrame

    local ESPHealthToggle = Instance.new("TextButton")
    ESPHealthToggle.Name = "ESPHealthToggle"
    ESPHealthToggle.Size = UDim2.new(0.3, 0, 0, 30)
    ESPHealthToggle.Position = UDim2.new(0.7, 0, 0.125, 0)
    ESPHealthToggle.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
    ESPHealthToggle.BackgroundTransparency = 0.2
    ESPHealthToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    ESPHealthToggle.Text = "OFF"
    ESPHealthToggle.Font = Enum.Font.Gotham
    ESPHealthToggle.TextSize = 12
    ESPHealthToggle.ZIndex = 3
    ESPHealthToggle.Parent = ESPHealthFrame

    -- ESP Distance
    local ESPDistanceFrame = Instance.new("Frame")
    ESPDistanceFrame.Name = "ESPDistanceFrame"
    ESPDistanceFrame.Size = UDim2.new(1, 0, 0, 40)
    ESPDistanceFrame.Position = UDim2.new(0, 0, 0, 150)
    ESPDistanceFrame.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
    ESPDistanceFrame.BackgroundTransparency = 0.3
    ESPDistanceFrame.BorderSizePixel = 0
    ESPDistanceFrame.ZIndex = 2
    ESPDistanceFrame.Parent = VisualContent

    local ESPDistanceCorner = Instance.new("UICorner")
    ESPDistanceCorner.CornerRadius = UDim.new(0, 6)
    ESPDistanceCorner.Parent = ESPDistanceFrame

    local ESPDistanceLabel = Instance.new("TextLabel")
    ESPDistanceLabel.Name = "ESPDistanceLabel"
    ESPDistanceLabel.Size = UDim2.new(0.6, 0, 1, 0)
    ESPDistanceLabel.Position = UDim2.new(0, 10, 0, 0)
    ESPDistanceLabel.BackgroundTransparency = 1
    ESPDistanceLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ESPDistanceLabel.Text = "ESP Distance"
    ESPDistanceLabel.Font = Enum.Font.Gotham
    ESPDistanceLabel.TextSize = 14
    ESPDistanceLabel.TextXAlignment = Enum.TextXAlignment.Left
    ESPDistanceLabel.ZIndex = 3
    ESPDistanceLabel.Parent = ESPDistanceFrame

    local ESPDistanceToggle = Instance.new("TextButton")
    ESPDistanceToggle.Name = "ESPDistanceToggle"
    ESPDistanceToggle.Size = UDim2.new(0.3, 0, 0, 30)
    ESPDistanceToggle.Position = UDim2.new(0.7, 0, 0.125, 0)
    ESPDistanceToggle.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
    ESPDistanceToggle.BackgroundTransparency = 0.2
    ESPDistanceToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    ESPDistanceToggle.Text = "OFF"
    ESPDistanceToggle.Font = Enum.Font.Gotham
    ESPDistanceToggle.TextSize = 12
    ESPDistanceToggle.ZIndex = 3
    ESPDistanceToggle.Parent = ESPDistanceFrame

    -- ESP Count
    local ESPCountFrame = Instance.new("Frame")
    ESPCountFrame.Name = "ESPCountFrame"
    ESPCountFrame.Size = UDim2.new(1, 0, 0, 40)
    ESPCountFrame.Position = UDim2.new(0, 0, 0, 200)
    ESPCountFrame.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
    ESPCountFrame.BackgroundTransparency = 0.3
    ESPCountFrame.BorderSizePixel = 0
    ESPCountFrame.ZIndex = 2
    ESPCountFrame.Parent = VisualContent

    local ESPCountCorner = Instance.new("UICorner")
    ESPCountCorner.CornerRadius = UDim.new(0, 6)
    ESPCountCorner.Parent = ESPCountFrame

    local ESPCountLabel = Instance.new("TextLabel")
    ESPCountLabel.Name = "ESPCountLabel"
    ESPCountLabel.Size = UDim2.new(0.6, 0, 1, 0)
    ESPCountLabel.Position = UDim2.new(0, 10, 0, 0)
    ESPCountLabel.BackgroundTransparency = 1
    ESPCountLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ESPCountLabel.Text = "ESP Count"
    ESPCountLabel.Font = Enum.Font.Gotham
    ESPCountLabel.TextSize = 14
    ESPCountLabel.TextXAlignment = Enum.TextXAlignment.Left
    ESPCountLabel.ZIndex = 3
    ESPCountLabel.Parent = ESPCountFrame

    local ESPCountToggle = Instance.new("TextButton")
    ESPCountToggle.Name = "ESPCountToggle"
    ESPCountToggle.Size = UDim2.new(0.3, 0, 0, 30)
    ESPCountToggle.Position = UDim2.new(0.7, 0, 0.125, 0)
    ESPCountToggle.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
    ESPCountToggle.BackgroundTransparency = 0.2
    ESPCountToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    ESPCountToggle.Text = "OFF"
    ESPCountToggle.Font = Enum.Font.Gotham
    ESPCountToggle.TextSize = 12
    ESPCountToggle.ZIndex = 3
    ESPCountToggle.Parent = ESPCountFrame

    -- AimBot Content
    local AimBotContent = Instance.new("Frame")
    AimBotContent.Name = "AimBotContent"
    AimBotContent.Size = UDim2.new(1, 0, 0, 120)
    AimBotContent.BackgroundTransparency = 1
    AimBotContent.Visible = false
    AimBotContent.ZIndex = 2
    AimBotContent.Parent = ScrollFrame

    -- AimBot Toggle
    local AimBotFrame = Instance.new("Frame")
    AimBotFrame.Name = "AimBotFrame"
    AimBotFrame.Size = UDim2.new(1, 0, 0, 40)
    AimBotFrame.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
    AimBotFrame.BackgroundTransparency = 0.3
    AimBotFrame.BorderSizePixel = 0
    AimBotFrame.ZIndex = 2
    AimBotFrame.Parent = AimBotContent

    local AimBotCorner = Instance.new("UICorner")
    AimBotCorner.CornerRadius = UDim.new(0, 6)
    AimBotCorner.Parent = AimBotFrame

    local AimBotLabel = Instance.new("TextLabel")
    AimBotLabel.Name = "AimBotLabel"
    AimBotLabel.Size = UDim2.new(0.6, 0, 1, 0)
    AimBotLabel.Position = UDim2.new(0, 10, 0, 0)
    AimBotLabel.BackgroundTransparency = 1
    AimBotLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    AimBotLabel.Text = "AimBot"
    AimBotLabel.Font = Enum.Font.Gotham
    AimBotLabel.TextSize = 14
    AimBotLabel.TextXAlignment = Enum.TextXAlignment.Left
    AimBotLabel.ZIndex = 3
    AimBotLabel.Parent = AimBotFrame

    local AimBotToggle = Instance.new("TextButton")
    AimBotToggle.Name = "AimBotToggle"
    AimBotToggle.Size = UDim2.new(0.3, 0, 0, 30)
    AimBotToggle.Position = UDim2.new(0.7, 0, 0.125, 0)
    AimBotToggle.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
    AimBotToggle.BackgroundTransparency = 0.2
    AimBotToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    AimBotToggle.Text = "OFF"
    AimBotToggle.Font = Enum.Font.Gotham
    AimBotToggle.TextSize = 12
    AimBotToggle.ZIndex = 3
    AimBotToggle.Parent = AimBotFrame

    -- AimBot FOV Slider
    local AimBotFOVFrame = Instance.new("Frame")
    AimBotFOVFrame.Name = "AimBotFOVFrame"
    AimBotFOVFrame.Size = UDim2.new(1, 0, 0, 60)
    AimBotFOVFrame.Position = UDim2.new(0, 0, 0, 50)
    AimBotFOVFrame.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
    AimBotFOVFrame.BackgroundTransparency = 0.3
    AimBotFOVFrame.BorderSizePixel = 0
    AimBotFOVFrame.Visible = false
    AimBotFOVFrame.ZIndex = 2
    AimBotFOVFrame.Parent = AimBotContent

    local AimBotFOVCorner = Instance.new("UICorner")
    AimBotFOVCorner.CornerRadius = UDim.new(0, 6)
    AimBotFOVCorner.Parent = AimBotFOVFrame

    local AimBotFOVLabel = Instance.new("TextLabel")
    AimBotFOVLabel.Name = "AimBotFOVLabel"
    AimBotFOVLabel.Size = UDim2.new(1, 0, 0, 30)
    AimBotFOVLabel.Position = UDim2.new(0, 0, 0, 0)
    AimBotFOVLabel.BackgroundTransparency = 1
    AimBotFOVLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    AimBotFOVLabel.Text = "AimBot FOV: " .. aimBotFOV
    AimBotFOVLabel.Font = Enum.Font.Gotham
    AimBotFOVLabel.TextSize = 12
    AimBotFOVLabel.ZIndex = 3
    AimBotFOVLabel.Parent = AimBotFOVFrame

    -- Восстанавливаем состояния кнопок при создании GUI
    toggleButton(SpeedHackToggle, speedHackEnabled)
    SpeedHackSlider.Visible = speedHackEnabled
    
    toggleButton(JumpHackToggle, jumpHackEnabled)
    toggleButton(NoClipToggle, noclipEnabled)
    toggleButton(ESPTracersToggle, espTracersEnabled)
    toggleButton(ESPBoxToggle, espBoxEnabled)
    toggleButton(ESPHealthToggle, espHealthEnabled)
    toggleButton(ESPDistanceToggle, espDistanceEnabled)
    toggleButton(ESPCountToggle, espCountEnabled)
    toggleButton(AimBotToggle, aimBotEnabled)
    AimBotFOVFrame.Visible = aimBotEnabled

    -- Восстанавливаем ESP Count если он был включен
    if espCountEnabled and not espCountText then
        espCountText = Drawing.new("Text")
        espCountText.Size = 20
        espCountText.Center = true
        espCountText.Outline = true
        espCountText.Color = Color3.fromRGB(255, 0, 0)
        espCountText.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, 100)
        espCountText.Visible = true
    end

    -- Восстанавливаем FOV Circle если он был включен
    if aimBotEnabled then
        if not fovCircle then
            createFOVCircle()
        end
        fovCircle.Visible = true
    end

    -- Восстанавливаем скорость если она была изменена
    if speedHackEnabled then
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = currentSpeed
        end
    end

    -- Восстанавливаем NoClip если он был включен
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
    end

    -- Speed Hack
    SpeedHackToggle.MouseButton1Click:Connect(function()
        speedHackEnabled = not speedHackEnabled
        toggleButton(SpeedHackToggle, speedHackEnabled)
        SpeedHackSlider.Visible = speedHackEnabled
        
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
    end)

    -- Speed Slider
    SpeedHackSlider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            local connection
            connection = RunService.Heartbeat:Connect(function()
                local mouseLocation = UserInputService:GetMouseLocation()
                local relativeX = math.clamp((mouseLocation.X - SpeedHackSlider.AbsolutePosition.X) / SpeedHackSlider.AbsoluteSize.X, 0, 1)
                currentSpeed = math.floor(16 + (relativeX * 84)) -- 16 to 100
                SpeedValue.Text = "Speed: " .. currentSpeed .. " -"
                
                if speedHackEnabled then
                    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid.WalkSpeed = currentSpeed
                    end
                end
            end)
            
            local function disconnect()
                connection:Disconnect()
            end
            
            SpeedHackSlider.InputEnded:Connect(disconnect)
        end
    end)

    -- Jump Hack
    JumpHackToggle.MouseButton1Click:Connect(function()
        jumpHackEnabled = not jumpHackEnabled
        toggleButton(JumpHackToggle, jumpHackEnabled)
    end)

    -- Infinite Jump
    UserInputService.JumpRequest:Connect(function()
        if jumpHackEnabled and player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)

    -- NoClip
    NoClipToggle.MouseButton1Click:Connect(function()
        noclipEnabled = not noclipEnabled
        toggleButton(NoClipToggle, noclipEnabled)
        
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
            
            -- Восстанавливаем коллизию
            if player.Character then
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end)

    -- ESP Tracers Toggle
    ESPTracersToggle.MouseButton1Click:Connect(function()
        espTracersEnabled = not espTracersEnabled
        toggleButton(ESPTracersToggle, espTracersEnabled)
    end)

    -- ESP Box Toggle
    ESPBoxToggle.MouseButton1Click:Connect(function()
        espBoxEnabled = not espBoxEnabled
        toggleButton(ESPBoxToggle, espBoxEnabled)
    end)

    -- ESP Health Toggle
    ESPHealthToggle.MouseButton1Click:Connect(function()
        espHealthEnabled = not espHealthEnabled
        toggleButton(ESPHealthToggle, espHealthEnabled)
    end)

    -- ESP Distance Toggle
    ESPDistanceToggle.MouseButton1Click:Connect(function()
        espDistanceEnabled = not espDistanceEnabled
        toggleButton(ESPDistanceToggle, espDistanceEnabled)
    end)

    -- ESP Count Toggle
    ESPCountToggle.MouseButton1Click:Connect(function()
        espCountEnabled = not espCountEnabled
        toggleButton(ESPCountToggle, espCountEnabled)
        
        if espCountEnabled then
            if not espCountText then
                espCountText = Drawing.new("Text")
                espCountText.Size = 20
                espCountText.Center = true
                espCountText.Outline = true
                espCountText.Color = Color3.fromRGB(255, 0, 0)
                espCountText.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, 100)
            end
            espCountText.Visible = true
        else
            if espCountText then
                espCountText.Visible = false
            end
        end
    end)

    -- Initialize ESP for existing players
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        createESP(otherPlayer)
    end

    -- ESP for new players
    Players.PlayerAdded:Connect(function(newPlayer)
        createESP(newPlayer)
    end)

    -- Remove ESP when player leaves
    Players.PlayerRemoving:Connect(function(leftPlayer)
        cleanupESP(leftPlayer)
    end)

    -- Update ESP Count continuously
    RunService.Heartbeat:Connect(updateESPCount)

    -- Update ESP Count position when screen size changes
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        if espCountText then
            espCountText.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, 100)
        end
    end)

    -- AimBot
    AimBotToggle.MouseButton1Click:Connect(function()
        aimBotEnabled = not aimBotEnabled
        toggleButton(AimBotToggle, aimBotEnabled)
        AimBotFOVFrame.Visible = aimBotEnabled
        
        -- Show/hide FOV circle
        if fovCircle then
            fovCircle.Visible = aimBotEnabled
        else
            createFOVCircle()
            fovCircle.Visible = aimBotEnabled
        end
    end)

    -- AimBot FOV Slider
    AimBotFOVFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            local connection
            connection = RunService.Heartbeat:Connect(function()
                local mouseLocation = UserInputService:GetMouseLocation()
                local relativeX = math.clamp((mouseLocation.X - AimBotFOVFrame.AbsolutePosition.X) / AimBotFOVFrame.AbsoluteSize.X, 0, 1)
                aimBotFOV = math.floor(10 + (relativeX * 190)) -- 10 to 200
                AimBotFOVLabel.Text = "AimBot FOV: " .. aimBotFOV .. " -"
                updateFOVCircle()
            end)
            
            local function disconnect()
                connection:Disconnect()
            end
            
            AimBotFOVFrame.InputEnded:Connect(disconnect)
        end
    end)

    -- AimBot Logic with FOV
    RunService.Heartbeat:Connect(function()
        if aimBotEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local closestPlayer = nil
            local closestDistance = 1000
            
            for _, otherPlayer in pairs(Players:GetPlayers()) do
                if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") and otherPlayer.Character:FindFirstChild("Humanoid") and otherPlayer.Character.Humanoid.Health > 0 then
                    local targetRoot = otherPlayer.Character.HumanoidRootPart
                    local distance = (player.Character.HumanoidRootPart.Position - targetRoot.Position).Magnitude
                    
                    -- Check if player is in FOV and visible
                    if isInFOV(targetRoot.Position) and isPlayerVisible(otherPlayer) then
                        if distance < closestDistance then
                            closestDistance = distance
                            closestPlayer = otherPlayer
                        end
                    end
                end
            end
            
            if closestPlayer then
                workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, closestPlayer.Character.HumanoidRootPart.Position)
            end
        end
    end)

    -- Tab Switching
    MovementTab.MouseButton1Click:Connect(function()
        MovementContent.Visible = true
        VisualContent.Visible = false
        AimBotContent.Visible = false
        
        MovementTab.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
        VisualTab.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
        AimBotTab.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
    end)

    VisualTab.MouseButton1Click:Connect(function()
        MovementContent.Visible = false
        VisualContent.Visible = true
        AimBotContent.Visible = false
        
        MovementTab.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
        VisualTab.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
        AimBotTab.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
    end)

    AimBotTab.MouseButton1Click:Connect(function()
        MovementContent.Visible = false
        VisualContent.Visible = false
        AimBotContent.Visible = true
        
        MovementTab.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
        VisualTab.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
        AimBotTab.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
    end)

    -- Auto-resize for mobile
    local function updateSize()
        local viewportSize = workspace.CurrentCamera.ViewportSize
        MainFrame.Size = UDim2.new(0, math.min(300, viewportSize.X - 20), 0, math.min(400, viewportSize.Y - 20))
        
        -- Update FOV circle position
        updateFOVCircle()
        
        -- Update ESP Count position
        if espCountText then
            espCountText.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, 100)
        end
    end

    updateSize()
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateSize)
    
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
        -- Очищаем фоновую анимацию
        if backgroundAnimation then
            backgroundAnimation:Destroy()
            backgroundAnimation = nil
        end
        if animationConnection then
            animationConnection:Disconnect()
            animationConnection = nil
        end
        treeParts = {}
        
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
        -- Clean up ESP objects
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