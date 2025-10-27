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
local isRussian = false

local ScreenGui = nil
local MainFrame = nil
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

-- Функция создания FOV Circle
local function createFOVCircle()
    if fovCircle then
        fovCircle:Remove()
    end
    
    fovCircle = Drawing.new("Circle")
    fovCircle.Visible = false
    fovCircle.Color = Color3.fromRGB(255, 255, 255)
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

-- Функция создания кнопки открытия/закрытия в стиле Rayfield
local function createOpenCloseButton()
    if OpenCloseButton then
        OpenCloseButton:Destroy()
    end

    OpenCloseButton = Instance.new("TextButton")
    OpenCloseButton.Name = "OpenCloseButton"
    OpenCloseButton.Size = UDim2.new(0, 50, 0, 50)
    OpenCloseButton.Position = savedButtonPosition
    OpenCloseButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    OpenCloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    OpenCloseButton.Text = "☰"
    OpenCloseButton.Font = Enum.Font.GothamBold
    OpenCloseButton.TextSize = 20
    OpenCloseButton.ZIndex = 10
    OpenCloseButton.Active = true
    OpenCloseButton.Draggable = true
    OpenCloseButton.Parent = ScreenGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = OpenCloseButton

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(100, 100, 255)
    Stroke.Thickness = 2
    Stroke.Parent = OpenCloseButton

    -- Эффект при наведении
    OpenCloseButton.MouseEnter:Connect(function()
        TweenService:Create(OpenCloseButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
    end)

    OpenCloseButton.MouseLeave:Connect(function()
        TweenService:Create(OpenCloseButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}):Play()
    end)

    -- Обработчик нажатия
    OpenCloseButton.MouseButton1Click:Connect(function()
        isGuiOpen = not isGuiOpen
        MainFrame.Visible = isGuiOpen
        
        if isGuiOpen then
            OpenCloseButton.Text = "✕"
            TweenService:Create(OpenCloseButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(200, 50, 50)}):Play()
        else
            OpenCloseButton.Text = "☰"
            TweenService:Create(OpenCloseButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}):Play()
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
        button.BackgroundColor3 = Color3.fromRGB(80, 180, 80)
        button.Text = isRussian and "ВКЛ" or "ON"
    else
        button.BackgroundColor3 = Color3.fromRGB(180, 80, 80)
        button.Text = isRussian and "ВЫКЛ" or "OFF"
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
                    espObjects[otherPlayer].tracer.Color = Color3.fromRGB(255, 255, 255)
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
                    espObjects[otherPlayer].box.Color = Color3.fromRGB(255, 255, 255)
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
                    espObjects[otherPlayer].health.Color = Color3.fromRGB(255, 255, 255)
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
                    espObjects[otherPlayer].distance.Color = Color3.fromRGB(255, 255, 255)
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
    
    espCountText.Text = (isRussian and "Игроки: " or "Players: ") .. aliveCount
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

-- Функция перевода интерфейса
local function updateLanguage()
    if ScreenGui then
        if isRussian then
            -- Перевод на русский
            if ScreenGui:FindFirstChild("Title") then
                ScreenGui.Title.Text = "САНСТРО|t.me//SCRIPTYTA"
            end
            
            -- Кнопки Movement
            if ScreenGui:FindFirstChild("SpeedHackLabel") then
                ScreenGui.SpeedHackLabel.Text = "Скорость"
            end
            if ScreenGui:FindFirstChild("JumpHackLabel") then
                ScreenGui.JumpHackLabel.Text = "Прыжок"
            end
            if ScreenGui:FindFirstChild("NoClipLabel") then
                ScreenGui.NoClipLabel.Text = "Сквозь стены"
            end
            
            -- Кнопки Visual
            if ScreenGui:FindFirstChild("ESPTracersLabel") then
                ScreenGui.ESPTracersLabel.Text = "Трассеры"
            end
            if ScreenGui:FindFirstChild("ESPBoxLabel") then
                ScreenGui.ESPBoxLabel.Text = "Боксы"
            end
            if ScreenGui:FindFirstChild("ESPHealthLabel") then
                ScreenGui.ESPHealthLabel.Text = "Здоровье"
            end
            if ScreenGui:FindFirstChild("ESPDistanceLabel") then
                ScreenGui.ESPDistanceLabel.Text = "Дистанция"
            end
            if ScreenGui:FindFirstChild("ESPCountLabel") then
                ScreenGui.ESPCountLabel.Text = "Счетчик"
            end
            
            -- Кнопки AimBot
            if ScreenGui:FindFirstChild("AimBotLabel") then
                ScreenGui.AimBotLabel.Text = "Прицел"
            end
            if ScreenGui:FindFirstChild("AimBotFOVLabel") then
                ScreenGui.AimBotFOVLabel.Text = "Поле зрения: " .. aimBotFOV
            end
            
            -- Обновляем текст кнопок
            toggleButton(ScreenGui.SpeedHackToggle, speedHackEnabled)
            toggleButton(ScreenGui.JumpHackToggle, jumpHackEnabled)
            toggleButton(ScreenGui.NoClipToggle, noclipEnabled)
            toggleButton(ScreenGui.ESPTracersToggle, espTracersEnabled)
            toggleButton(ScreenGui.ESPBoxToggle, espBoxEnabled)
            toggleButton(ScreenGui.ESPHealthToggle, espHealthEnabled)
            toggleButton(ScreenGui.ESPDistanceToggle, espDistanceEnabled)
            toggleButton(ScreenGui.ESPCountToggle, espCountEnabled)
            toggleButton(ScreenGui.AimBotToggle, aimBotEnabled)
            
        else
            -- Перевод на английский
            if ScreenGui:FindFirstChild("Title") then
                ScreenGui.Title.Text = "SANSTRO|t.me//SCRIPTYTA"
            end
            
            -- Кнопки Movement
            if ScreenGui:FindFirstChild("SpeedHackLabel") then
                ScreenGui.SpeedHackLabel.Text = "Speed Hack"
            end
            if ScreenGui:FindFirstChild("JumpHackLabel") then
                ScreenGui.JumpHackLabel.Text = "Jump Hack"
            end
            if ScreenGui:FindFirstChild("NoClipLabel") then
                ScreenGui.NoClipLabel.Text = "NoClip"
            end
            
            -- Кнопки Visual
            if ScreenGui:FindFirstChild("ESPTracersLabel") then
                ScreenGui.ESPTracersLabel.Text = "ESP Tracers"
            end
            if ScreenGui:FindFirstChild("ESPBoxLabel") then
                ScreenGui.ESPBoxLabel.Text = "ESP Box"
            end
            if ScreenGui:FindFirstChild("ESPHealthLabel") then
                ScreenGui.ESPHealthLabel.Text = "ESP Health"
            end
            if ScreenGui:FindFirstChild("ESPDistanceLabel") then
                ScreenGui.ESPDistanceLabel.Text = "ESP Distance"
            end
            if ScreenGui:FindFirstChild("ESPCountLabel") then
                ScreenGui.ESPCountLabel.Text = "ESP Count"
            end
            
            -- Кнопки AimBot
            if ScreenGui:FindFirstChild("AimBotLabel") then
                ScreenGui.AimBotLabel.Text = "AimBot"
            end
            if ScreenGui:FindFirstChild("AimBotFOVLabel") then
                ScreenGui.AimBotFOVLabel.Text = "AimBot FOV: " .. aimBotFOV
            end
            
            -- Обновляем текст кнопок
            toggleButton(ScreenGui.SpeedHackToggle, speedHackEnabled)
            toggleButton(ScreenGui.JumpHackToggle, jumpHackEnabled)
            toggleButton(ScreenGui.NoClipToggle, noclipEnabled)
            toggleButton(ScreenGui.ESPTracersToggle, espTracersEnabled)
            toggleButton(ScreenGui.ESPBoxToggle, espBoxEnabled)
            toggleButton(ScreenGui.ESPHealthToggle, espHealthEnabled)
            toggleButton(ScreenGui.ESPDistanceToggle, espDistanceEnabled)
            toggleButton(ScreenGui.ESPCountToggle, espCountEnabled)
            toggleButton(ScreenGui.AimBotToggle, aimBotEnabled)
        end
    end
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
    MainFrame.Size = UDim2.new(0, 280, 0, 380)
    MainFrame.Position = savedPosition
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainFrame.BackgroundTransparency = 0.1
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Visible = isGuiOpen
    MainFrame.Parent = ScreenGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = MainFrame

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(100, 100, 255)
    Stroke.Thickness = 2
    Stroke.Parent = MainFrame

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, 0, 0, 35)
    Title.Position = UDim2.new(0, 0, 0, 0)
    Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Text = "SANSTRO|t.me//SCRIPTYTA"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.ZIndex = 2
    Title.Parent = MainFrame

    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 12)
    TitleCorner.Parent = Title

    -- Language Button
    local LanguageButton = Instance.new("TextButton")
    LanguageButton.Name = "LanguageButton"
    LanguageButton.Size = UDim2.new(0, 35, 0, 35)
    LanguageButton.Position = UDim2.new(0, 10, 0, 40)
    LanguageButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    LanguageButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    LanguageButton.Text = "A"
    LanguageButton.Font = Enum.Font.GothamBold
    LanguageButton.TextSize = 16
    LanguageButton.ZIndex = 2
    LanguageButton.Parent = MainFrame

    local LanguageCorner = Instance.new("UICorner")
    LanguageCorner.CornerRadius = UDim.new(0, 8)
    LanguageCorner.Parent = LanguageButton

    local LanguageStroke = Instance.new("UIStroke")
    LanguageStroke.Color = Color3.fromRGB(100, 100, 255)
    LanguageStroke.Thickness = 2
    LanguageStroke.Parent = LanguageButton

    -- Tab Buttons
    local TabButtonsFrame = Instance.new("Frame")
    TabButtonsFrame.Name = "TabButtonsFrame"
    TabButtonsFrame.Size = UDim2.new(1, -80, 0, 35)
    TabButtonsFrame.Position = UDim2.new(0, 55, 0, 40)
    TabButtonsFrame.BackgroundTransparency = 1
    TabButtonsFrame.ZIndex = 2
    TabButtonsFrame.Parent = MainFrame

    local MovementTab = Instance.new("TextButton")
    MovementTab.Name = "MovementTab"
    MovementTab.Size = UDim2.new(0.32, 0, 1, 0)
    MovementTab.Position = UDim2.new(0, 0, 0, 0)
    MovementTab.BackgroundColor3 = Color3.fromRGB(80, 180, 80)
    MovementTab.TextColor3 = Color3.fromRGB(255, 255, 255)
    MovementTab.Text = "⚙️"
    MovementTab.Font = Enum.Font.GothamBold
    MovementTab.TextSize = 16
    MovementTab.ZIndex = 2
    MovementTab.Parent = TabButtonsFrame

    local MovementTabCorner = Instance.new("UICorner")
    MovementTabCorner.CornerRadius = UDim.new(0, 8)
    MovementTabCorner.Parent = MovementTab

    local VisualTab = Instance.new("TextButton")
    VisualTab.Name = "VisualTab"
    VisualTab.Size = UDim2.new(0.32, 0, 1, 0)
    VisualTab.Position = UDim2.new(0.34, 0, 0, 0)
    VisualTab.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    VisualTab.TextColor3 = Color3.fromRGB(255, 255, 255)
    VisualTab.Text = "👁"
    VisualTab.Font = Enum.Font.GothamBold
    VisualTab.TextSize = 16
    VisualTab.ZIndex = 2
    VisualTab.Parent = TabButtonsFrame

    local VisualTabCorner = Instance.new("UICorner")
    VisualTabCorner.CornerRadius = UDim.new(0, 8)
    VisualTabCorner.Parent = VisualTab

    local AimBotTab = Instance.new("TextButton")
    AimBotTab.Name = "AimBotTab"
    AimBotTab.Size = UDim2.new(0.32, 0, 1, 0)
    AimBotTab.Position = UDim2.new(0.68, 0, 0, 0)
    AimBotTab.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    AimBotTab.TextColor3 = Color3.fromRGB(255, 255, 255)
    AimBotTab.Text = "🎯"
    AimBotTab.Font = Enum.Font.GothamBold
    AimBotTab.TextSize = 16
    AimBotTab.ZIndex = 2
    AimBotTab.Parent = TabButtonsFrame

    local AimBotTabCorner = Instance.new("UICorner")
    AimBotTabCorner.CornerRadius = UDim.new(0, 8)
    AimBotTabCorner.Parent = AimBotTab

    -- Content Frame
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Size = UDim2.new(1, -20, 1, -100)
    ContentFrame.Position = UDim2.new(0, 10, 0, 85)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.ZIndex = 2
    ContentFrame.Parent = MainFrame

    local ScrollFrame = Instance.new("ScrollingFrame")
    ScrollFrame.Name = "ScrollFrame"
    ScrollFrame.Size = UDim2.new(1, 0, 1, 0)
    ScrollFrame.BackgroundTransparency = 1
    ScrollFrame.ScrollBarThickness = 4
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 450)
    ScrollFrame.ZIndex = 2
    ScrollFrame.Parent = ContentFrame

    -- Movement Content
    local MovementContent = Instance.new("Frame")
    MovementContent.Name = "MovementContent"
    MovementContent.Size = UDim2.new(1, 0, 0, 200)
    MovementContent.BackgroundTransparency = 1
    MovementContent.Visible = true
    MovementContent.ZIndex = 2
    MovementContent.Parent = ScrollFrame

    -- Speed Hack
    local SpeedHackFrame = Instance.new("Frame")
    SpeedHackFrame.Name = "SpeedHackFrame"
    SpeedHackFrame.Size = UDim2.new(1, 0, 0, 70)
    SpeedHackFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    SpeedHackFrame.BorderSizePixel = 0
    SpeedHackFrame.ZIndex = 2
    SpeedHackFrame.Parent = MovementContent

    local SpeedHackCorner = Instance.new("UICorner")
    SpeedHackCorner.CornerRadius = UDim.new(0, 8)
    SpeedHackCorner.Parent = SpeedHackFrame

    local SpeedHackLabel = Instance.new("TextLabel")
    SpeedHackLabel.Name = "SpeedHackLabel"
    SpeedHackLabel.Size = UDim2.new(0.6, 0, 0, 25)
    SpeedHackLabel.Position = UDim2.new(0, 10, 0, 5)
    SpeedHackLabel.BackgroundTransparency = 1
    SpeedHackLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SpeedHackLabel.Text = "Speed Hack"
    SpeedHackLabel.Font = Enum.Font.Gotham
    SpeedHackLabel.TextSize = 14
    SpeedHackLabel.TextXAlignment = Enum.TextXAlignment.Left
    SpeedHackLabel.ZIndex = 2
    SpeedHackLabel.Parent = SpeedHackFrame

    local SpeedHackToggle = Instance.new("TextButton")
    SpeedHackToggle.Name = "SpeedHackToggle"
    SpeedHackToggle.Size = UDim2.new(0.3, 0, 0, 25)
    SpeedHackToggle.Position = UDim2.new(0.7, 0, 0, 5)
    SpeedHackToggle.BackgroundColor3 = Color3.fromRGB(180, 80, 80)
    SpeedHackToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    SpeedHackToggle.Text = "OFF"
    SpeedHackToggle.Font = Enum.Font.Gotham
    SpeedHackToggle.TextSize = 12
    SpeedHackToggle.ZIndex = 2
    SpeedHackToggle.Parent = SpeedHackFrame

    local SpeedHackToggleCorner = Instance.new("UICorner")
    SpeedHackToggleCorner.CornerRadius = UDim.new(0, 6)
    SpeedHackToggleCorner.Parent = SpeedHackToggle

    local SpeedHackSlider = Instance.new("TextButton")
    SpeedHackSlider.Name = "SpeedHackSlider"
    SpeedHackSlider.Size = UDim2.new(1, -20, 0, 25)
    SpeedHackSlider.Position = UDim2.new(0, 10, 0, 35)
    SpeedHackSlider.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    SpeedHackSlider.Text = ""
    SpeedHackSlider.AutoButtonColor = false
    SpeedHackSlider.ZIndex = 2
    SpeedHackSlider.Parent = SpeedHackFrame

    local SpeedHackSliderCorner = Instance.new("UICorner")
    SpeedHackSliderCorner.CornerRadius = UDim.new(0, 6)
    SpeedHackSliderCorner.Parent = SpeedHackSlider

    local SpeedValue = Instance.new("TextLabel")
    SpeedValue.Name = "SpeedValue"
    SpeedValue.Size = UDim2.new(1, 0, 1, 0)
    SpeedValue.BackgroundTransparency = 1
    SpeedValue.TextColor3 = Color3.fromRGB(255, 255, 255)
    SpeedValue.Text = "Speed: " .. currentSpeed
    SpeedValue.Font = Enum.Font.Gotham
    SpeedValue.TextSize = 12
    SpeedValue.ZIndex = 2
    SpeedValue.Parent = SpeedHackSlider

    -- Jump Hack
    local JumpHackFrame = Instance.new("Frame")
    JumpHackFrame.Name = "JumpHackFrame"
    JumpHackFrame.Size = UDim2.new(1, 0, 0, 40)
    JumpHackFrame.Position = UDim2.new(0, 0, 0, 80)
    JumpHackFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    JumpHackFrame.BorderSizePixel = 0
    JumpHackFrame.ZIndex = 2
    JumpHackFrame.Parent = MovementContent

    local JumpHackCorner = Instance.new("UICorner")
    JumpHackCorner.CornerRadius = UDim.new(0, 8)
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
    JumpHackLabel.ZIndex = 2
    JumpHackLabel.Parent = JumpHackFrame

    local JumpHackToggle = Instance.new("TextButton")
    JumpHackToggle.Name = "JumpHackToggle"
    JumpHackToggle.Size = UDim2.new(0.3, 0, 0, 25)
    JumpHackToggle.Position = UDim2.new(0.7, 0, 0.2, 0)
    JumpHackToggle.BackgroundColor3 = Color3.fromRGB(180, 80, 80)
    JumpHackToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    JumpHackToggle.Text = "OFF"
    JumpHackToggle.Font = Enum.Font.Gotham
    JumpHackToggle.TextSize = 12
    JumpHackToggle.ZIndex = 2
    JumpHackToggle.Parent = JumpHackFrame

    local JumpHackToggleCorner = Instance.new("UICorner")
    JumpHackToggleCorner.CornerRadius = UDim.new(0, 6)
    JumpHackToggleCorner.Parent = JumpHackToggle

    -- NoClip
    local NoClipFrame = Instance.new("Frame")
    NoClipFrame.Name = "NoClipFrame"
    NoClipFrame.Size = UDim2.new(1, 0, 0, 40)
    NoClipFrame.Position = UDim2.new(0, 0, 0, 130)
    NoClipFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    NoClipFrame.BorderSizePixel = 0
    NoClipFrame.ZIndex = 2
    NoClipFrame.Parent = MovementContent

    local NoClipCorner = Instance.new("UICorner")
    NoClipCorner.CornerRadius = UDim.new(0, 8)
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
    NoClipLabel.ZIndex = 2
    NoClipLabel.Parent = NoClipFrame

    local NoClipToggle = Instance.new("TextButton")
    NoClipToggle.Name = "NoClipToggle"
    NoClipToggle.Size = UDim2.new(0.3, 0, 0, 25)
    NoClipToggle.Position = UDim2.new(0.7, 0, 0.2, 0)
    NoClipToggle.BackgroundColor3 = Color3.fromRGB(180, 80, 80)
    NoClipToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    NoClipToggle.Text = "OFF"
    NoClipToggle.Font = Enum.Font.Gotham
    NoClipToggle.TextSize = 12
    NoClipToggle.ZIndex = 2
    NoClipToggle.Parent = NoClipFrame

    local NoClipToggleCorner = Instance.new("UICorner")
    NoClipToggleCorner.CornerRadius = UDim.new(0, 6)
    NoClipToggleCorner.Parent = NoClipToggle

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
    ESPTracersFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    ESPTracersFrame.BorderSizePixel = 0
    ESPTracersFrame.ZIndex = 2
    ESPTracersFrame.Parent = VisualContent

    local ESPTracersCorner = Instance.new("UICorner")
    ESPTracersCorner.CornerRadius = UDim.new(0, 8)
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
    ESPTracersLabel.ZIndex = 2
    ESPTracersLabel.Parent = ESPTracersFrame

    local ESPTracersToggle = Instance.new("TextButton")
    ESPTracersToggle.Name = "ESPTracersToggle"
    ESPTracersToggle.Size = UDim2.new(0.3, 0, 0, 25)
    ESPTracersToggle.Position = UDim2.new(0.7, 0, 0.2, 0)
    ESPTracersToggle.BackgroundColor3 = Color3.fromRGB(180, 80, 80)
    ESPTracersToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    ESPTracersToggle.Text = "OFF"
    ESPTracersToggle.Font = Enum.Font.Gotham
    ESPTracersToggle.TextSize = 12
    ESPTracersToggle.ZIndex = 2
    ESPTracersToggle.Parent = ESPTracersFrame

    local ESPTracersToggleCorner = Instance.new("UICorner")
    ESPTracersToggleCorner.CornerRadius = UDim.new(0, 6)
    ESPTracersToggleCorner.Parent = ESPTracersToggle

    -- ESP Box
    local ESPBoxFrame = Instance.new("Frame")
    ESPBoxFrame.Name = "ESPBoxFrame"
    ESPBoxFrame.Size = UDim2.new(1, 0, 0, 40)
    ESPBoxFrame.Position = UDim2.new(0, 0, 0, 50)
    ESPBoxFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    ESPBoxFrame.BorderSizePixel = 0
    ESPBoxFrame.ZIndex = 2
    ESPBoxFrame.Parent = VisualContent

    local ESPBoxCorner = Instance.new("UICorner")
    ESPBoxCorner.CornerRadius = UDim.new(0, 8)
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
    ESPBoxLabel.ZIndex = 2
    ESPBoxLabel.Parent = ESPBoxFrame

    local ESPBoxToggle = Instance.new("TextButton")
    ESPBoxToggle.Name = "ESPBoxToggle"
    ESPBoxToggle.Size = UDim2.new(0.3, 0, 0, 25)
    ESPBoxToggle.Position = UDim2.new(0.7, 0, 0.2, 0)
    ESPBoxToggle.BackgroundColor3 = Color3.fromRGB(180, 80, 80)
    ESPBoxToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    ESPBoxToggle.Text = "OFF"
    ESPBoxToggle.Font = Enum.Font.Gotham
    ESPBoxToggle.TextSize = 12
    ESPBoxToggle.ZIndex = 2
    ESPBoxToggle.Parent = ESPBoxFrame

    local ESPBoxToggleCorner = Instance.new("UICorner")
    ESPBoxToggleCorner.CornerRadius = UDim.new(0, 6)
    ESPBoxToggleCorner.Parent = ESPBoxToggle

    -- ESP Health
    local ESPHealthFrame = Instance.new("Frame")
    ESPHealthFrame.Name = "ESPHealthFrame"
    ESPHealthFrame.Size = UDim2.new(1, 0, 0, 40)
    ESPHealthFrame.Position = UDim2.new(0, 0, 0, 100)
    ESPHealthFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    ESPHealthFrame.BorderSizePixel = 0
    ESPHealthFrame.ZIndex = 2
    ESPHealthFrame.Parent = VisualContent

    local ESPHealthCorner = Instance.new("UICorner")
    ESPHealthCorner.CornerRadius = UDim.new(0, 8)
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
    ESPHealthLabel.ZIndex = 2
    ESPHealthLabel.Parent = ESPHealthFrame

    local ESPHealthToggle = Instance.new("TextButton")
    ESPHealthToggle.Name = "ESPHealthToggle"
    ESPHealthToggle.Size = UDim2.new(0.3, 0, 0, 25)
    ESPHealthToggle.Position = UDim2.new(0.7, 0, 0.2, 0)
    ESPHealthToggle.BackgroundColor3 = Color3.fromRGB(180, 80, 80)
    ESPHealthToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    ESPHealthToggle.Text = "OFF"
    ESPHealthToggle.Font = Enum.Font.Gotham
    ESPHealthToggle.TextSize = 12
    ESPHealthToggle.ZIndex = 2
    ESPHealthToggle.Parent = ESPHealthFrame

    local ESPHealthToggleCorner = Instance.new("UICorner")
    ESPHealthToggleCorner.CornerRadius = UDim.new(0, 6)
    ESPHealthToggleCorner.Parent = ESPHealthToggle

    -- ESP Distance
    local ESPDistanceFrame = Instance.new("Frame")
    ESPDistanceFrame.Name = "ESPDistanceFrame"
    ESPDistanceFrame.Size = UDim2.new(1, 0, 0, 40)
    ESPDistanceFrame.Position = UDim2.new(0, 0, 0, 150)
    ESPDistanceFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    ESPDistanceFrame.BorderSizePixel = 0
    ESPDistanceFrame.ZIndex = 2
    ESPDistanceFrame.Parent = VisualContent

    local ESPDistanceCorner = Instance.new("UICorner")
    ESPDistanceCorner.CornerRadius = UDim.new(0, 8)
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
    ESPDistanceLabel.ZIndex = 2
    ESPDistanceLabel.Parent = ESPDistanceFrame

    local ESPDistanceToggle = Instance.new("TextButton")
    ESPDistanceToggle.Name = "ESPDistanceToggle"
    ESPDistanceToggle.Size = UDim2.new(0.3, 0, 0, 25)
    ESPDistanceToggle.Position = UDim2.new(0.7, 0, 0.2, 0)
    ESPDistanceToggle.BackgroundColor3 = Color3.fromRGB(180, 80, 80)
    ESPDistanceToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    ESPDistanceToggle.Text = "OFF"
    ESPDistanceToggle.Font = Enum.Font.Gotham
    ESPDistanceToggle.TextSize = 12
    ESPDistanceToggle.ZIndex = 2
    ESPDistanceToggle.Parent = ESPDistanceFrame

    local ESPDistanceToggleCorner = Instance.new("UICorner")
    ESPDistanceToggleCorner.CornerRadius = UDim.new(0, 6)
    ESPDistanceToggleCorner.Parent = ESPDistanceToggle

    -- ESP Count
    local ESPCountFrame = Instance.new("Frame")
    ESPCountFrame.Name = "ESPCountFrame"
    ESPCountFrame.Size = UDim2.new(1, 0, 0, 40)
    ESPCountFrame.Position = UDim2.new(0, 0, 0, 200)
    ESPCountFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    ESPCountFrame.BorderSizePixel = 0
    ESPCountFrame.ZIndex = 2
    ESPCountFrame.Parent = VisualContent

    local ESPCountCorner = Instance.new("UICorner")
    ESPCountCorner.CornerRadius = UDim.new(0, 8)
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
    ESPCountLabel.ZIndex = 2
    ESPCountLabel.Parent = ESPCountFrame

    local ESPCountToggle = Instance.new("TextButton")
    ESPCountToggle.Name = "ESPCountToggle"
    ESPCountToggle.Size = UDim2.new(0.3, 0, 0, 25)
    ESPCountToggle.Position = UDim2.new(0.7, 0, 0.2, 0)
    ESPCountToggle.BackgroundColor3 = Color3.fromRGB(180, 80, 80)
    ESPCountToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    ESPCountToggle.Text = "OFF"
    ESPCountToggle.Font = Enum.Font.Gotham
    ESPCountToggle.TextSize = 12
    ESPCountToggle.ZIndex = 2
    ESPCountToggle.Parent = ESPCountFrame

    local ESPCountToggleCorner = Instance.new("UICorner")
    ESPCountToggleCorner.CornerRadius = UDim.new(0, 6)
    ESPCountToggleCorner.Parent = ESPCountToggle

    -- AimBot Content
    local AimBotContent = Instance.new("Frame")
    AimBotContent.Name = "AimBotContent"
    AimBotContent.Size = UDim2.new(1, 0, 0, 120)
    AimBotContent.BackgroundTransparency = 1
    AimBotContent.Visible = false
    AimBotContent.ZIndex = 2
    AimBotContent.Parent = ScrollFrame

    -- AimBot
    local AimBotFrame = Instance.new("Frame")
    AimBotFrame.Name = "AimBotFrame"
    AimBotFrame.Size = UDim2.new(1, 0, 0, 40)
    AimBotFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    AimBotFrame.BorderSizePixel = 0
    AimBotFrame.ZIndex = 2
    AimBotFrame.Parent = AimBotContent

    local AimBotCorner = Instance.new("UICorner")
    AimBotCorner.CornerRadius = UDim.new(0, 8)
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
    AimBotLabel.ZIndex = 2
    AimBotLabel.Parent = AimBotFrame

    local AimBotToggle = Instance.new("TextButton")
    AimBotToggle.Name = "AimBotToggle"
    AimBotToggle.Size = UDim2.new(0.3, 0, 0, 25)
    AimBotToggle.Position = UDim2.new(0.7, 0, 0.2, 0)
    AimBotToggle.BackgroundColor3 = Color3.fromRGB(180, 80, 80)
    AimBotToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    AimBotToggle.Text = "OFF"
    AimBotToggle.Font = Enum.Font.Gotham
    AimBotToggle.TextSize = 12
    AimBotToggle.ZIndex = 2
    AimBotToggle.Parent = AimBotFrame

    local AimBotToggleCorner = Instance.new("UICorner")
    AimBotToggleCorner.CornerRadius = UDim.new(0, 6)
    AimBotToggleCorner.Parent = AimBotToggle

    -- AimBot FOV
    local AimBotFOVFrame = Instance.new("Frame")
    AimBotFOVFrame.Name = "AimBotFOVFrame"
    AimBotFOVFrame.Size = UDim2.new(1, 0, 0, 70)
    AimBotFOVFrame.Position = UDim2.new(0, 0, 0, 50)
    AimBotFOVFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    AimBotFOVFrame.BorderSizePixel = 0
    AimBotFOVFrame.ZIndex = 2
    AimBotFOVFrame.Parent = AimBotContent

    local AimBotFOVCorner = Instance.new("UICorner")
    AimBotFOVCorner.CornerRadius = UDim.new(0, 8)
    AimBotFOVCorner.Parent = AimBotFOVFrame

    local AimBotFOVLabel = Instance.new("TextLabel")
    AimBotFOVLabel.Name = "AimBotFOVLabel"
    AimBotFOVLabel.Size = UDim2.new(1, -20, 0, 25)
    AimBotFOVLabel.Position = UDim2.new(0, 10, 0, 5)
    AimBotFOVLabel.BackgroundTransparency = 1
    AimBotFOVLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    AimBotFOVLabel.Text = "AimBot FOV: " .. aimBotFOV
    AimBotFOVLabel.Font = Enum.Font.Gotham
    AimBotFOVLabel.TextSize = 14
    AimBotFOVLabel.ZIndex = 2
    AimBotFOVLabel.Parent = AimBotFOVFrame

    local AimBotFOVSlider = Instance.new("TextButton")
    AimBotFOVSlider.Name = "AimBotFOVSlider"
    AimBotFOVSlider.Size = UDim2.new(1, -20, 0, 25)
    AimBotFOVSlider.Position = UDim2.new(0, 10, 0, 35)
    AimBotFOVSlider.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    AimBotFOVSlider.Text = ""
    AimBotFOVSlider.AutoButtonColor = false
    AimBotFOVSlider.ZIndex = 2
    AimBotFOVSlider.Parent = AimBotFOVFrame

    local AimBotFOVSliderCorner = Instance.new("UICorner")
    AimBotFOVSliderCorner.CornerRadius = UDim.new(0, 6)
    AimBotFOVSliderCorner.Parent = AimBotFOVSlider

    local FOVValue = Instance.new("TextLabel")
    FOVValue.Name = "FOVValue"
    FOVValue.Size = UDim2.new(1, 0, 1, 0)
    FOVValue.BackgroundTransparency = 1
    FOVValue.TextColor3 = Color3.fromRGB(255, 255, 255)
    FOVValue.Text = "FOV: " .. aimBotFOV
    FOVValue.Font = Enum.Font.Gotham
    FOVValue.TextSize = 12
    FOVValue.ZIndex = 2
    FOVValue.Parent = AimBotFOVSlider

    -- ESP Count Text
    espCountText = Instance.new("TextLabel")
    espCountText.Name = "ESPCountText"
    espCountText.Size = UDim2.new(0, 120, 0, 25)
    espCountText.Position = UDim2.new(1, -130, 0, 10)
    espCountText.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    espCountText.BackgroundTransparency = 0.5
    espCountText.TextColor3 = Color3.fromRGB(255, 255, 255)
    espCountText.Text = "Players: 0"
    espCountText.Font = Enum.Font.Gotham
    espCountText.TextSize = 12
    espCountText.Visible = false
    espCountText.ZIndex = 10
    espCountText.Parent = ScreenGui

    local ESPCountTextCorner = Instance.new("UICorner")
    ESPCountTextCorner.CornerRadius = UDim.new(0, 6)
    ESPCountTextCorner.Parent = espCountText

    -- Обработчики событий
    LanguageButton.MouseButton1Click:Connect(function()
        isRussian = not isRussian
        updateLanguage()
    end)

    MovementTab.MouseButton1Click:Connect(function()
        MovementContent.Visible = true
        VisualContent.Visible = false
        AimBotContent.Visible = false
        
        MovementTab.BackgroundColor3 = Color3.fromRGB(80, 180, 80)
        VisualTab.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        AimBotTab.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end)

    VisualTab.MouseButton1Click:Connect(function()
        MovementContent.Visible = false
        VisualContent.Visible = true
        AimBotContent.Visible = false
        
        MovementTab.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        VisualTab.BackgroundColor3 = Color3.fromRGB(80, 180, 80)
        AimBotTab.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end)

    AimBotTab.MouseButton1Click:Connect(function()
        MovementContent.Visible = false
        VisualContent.Visible = false
        AimBotContent.Visible = true
        
        MovementTab.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        VisualTab.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        AimBotTab.BackgroundColor3 = Color3.fromRGB(80, 180, 80)
    end)

    -- Speed Hack Toggle
    SpeedHackToggle.MouseButton1Click:Connect(function()
        speedHackEnabled = not speedHackEnabled
        toggleButton(SpeedHackToggle, speedHackEnabled)
        
        if speedHackEnabled then
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = currentSpeed
            end
        else
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = 16
            end
        end
    end)

    -- Speed Slider
    local speedSliderConnection
    SpeedHackSlider.MouseButton1Down:Connect(function()
        speedSliderConnection = RunService.Heartbeat:Connect(function()
            local mousePos = UserInputService:GetMouseLocation()
            local sliderPos = SpeedHackSlider.AbsolutePosition
            local sliderSize = SpeedHackSlider.AbsoluteSize
            
            local relativeX = math.clamp((mousePos.X - sliderPos.X) / sliderSize.X, 0, 1)
            currentSpeed = math.floor(16 + (relativeX * 84)) -- 16 to 100
            SpeedValue.Text = (isRussian and "Скорость: " or "Speed: ") .. currentSpeed
            
            if speedHackEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = currentSpeed
            end
        end)
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and speedSliderConnection then
            speedSliderConnection:Disconnect()
            speedSliderConnection = nil
        end
    end)

    -- Jump Hack
    JumpHackToggle.MouseButton1Click:Connect(function()
        jumpHackEnabled = not jumpHackEnabled
        toggleButton(JumpHackToggle, jumpHackEnabled)
    end)

    UserInputService.JumpRequest:Connect(function()
        if jumpHackEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
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
        end
    end)

    -- ESP Tracers
    ESPTracersToggle.MouseButton1Click:Connect(function()
        espTracersEnabled = not espTracersEnabled
        toggleButton(ESPTracersToggle, espTracersEnabled)
    end)

    -- ESP Box
    ESPBoxToggle.MouseButton1Click:Connect(function()
        espBoxEnabled = not espBoxEnabled
        toggleButton(ESPBoxToggle, espBoxEnabled)
    end)

    -- ESP Health
    ESPHealthToggle.MouseButton1Click:Connect(function()
        espHealthEnabled = not espHealthEnabled
        toggleButton(ESPHealthToggle, espHealthEnabled)
    end)

    -- ESP Distance
    ESPDistanceToggle.MouseButton1Click:Connect(function()
        espDistanceEnabled = not espDistanceEnabled
        toggleButton(ESPDistanceToggle, espDistanceEnabled)
    end)

    -- ESP Count
    ESPCountToggle.MouseButton1Click:Connect(function()
        espCountEnabled = not espCountEnabled
        toggleButton(ESPCountToggle, espCountEnabled)
        espCountText.Visible = espCountEnabled
    end)

    -- AimBot
    AimBotToggle.MouseButton1Click:Connect(function()
        aimBotEnabled = not aimBotEnabled
        toggleButton(AimBotToggle, aimBotEnabled)
        
        if aimBotEnabled then
            if not fovCircle then
                createFOVCircle()
            end
            fovCircle.Visible = true
        else
            if fovCircle then
                fovCircle.Visible = false
            end
        end
    end)

    -- AimBot FOV Slider
    local fovSliderConnection
    AimBotFOVSlider.MouseButton1Down:Connect(function()
        fovSliderConnection = RunService.Heartbeat:Connect(function()
            local mousePos = UserInputService:GetMouseLocation()
            local sliderPos = AimBotFOVSlider.AbsolutePosition
            local sliderSize = AimBotFOVSlider.AbsoluteSize
            
            local relativeX = math.clamp((mousePos.X - sliderPos.X) / sliderSize.X, 0, 1)
            aimBotFOV = math.floor(10 + (relativeX * 190)) -- 10 to 200
            FOVValue.Text = "FOV: " .. aimBotFOV
            AimBotFOVLabel.Text = (isRussian and "Поле зрения: " or "AimBot FOV: ") .. aimBotFOV
            updateFOVCircle()
        end)
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and fovSliderConnection then
            fovSliderConnection:Disconnect()
            fovSliderConnection = nil
        end
    end)

    -- Сохраняем позицию при перетаскивании
    MainFrame.DragStopped:Connect(function()
        savedPosition = MainFrame.Position
    end)

    -- Инициализация
    createFOVCircle()
    updateLanguage()
    
    -- Обновление ESP Count
    while true do
        if espCountEnabled then
            updateESPCount()
        end
        wait(0.5)
    end
end

-- Инициализация GUI
createGUI()
createOpenCloseButton()

-- Обработка новых игроков
Players.PlayerAdded:Connect(function(newPlayer)
    createESP(newPlayer)
end)

-- Очистка при выходе игроков
Players.PlayerRemoving:Connect(function(leavingPlayer)
    cleanupESP(leavingPlayer)
end)

-- Инициализация ESP для существующих игроков
for _, otherPlayer in pairs(Players:GetPlayers()) do
    if otherPlayer ~= player then
        createESP(otherPlayer)
    end
end

-- AimBot Loop
RunService.Heartbeat:Connect(function()
    if aimBotEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local closestPlayer = nil
        local closestDistance = math.huge
        
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local rootPart = otherPlayer.Character.HumanoidRootPart
                local distance = (player.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
                
                if distance < closestDistance and isPlayerVisible(otherPlayer) and isInFOV(rootPart.Position) then
                    closestDistance = distance
                    closestPlayer = otherPlayer
                end
            end
        end
        
        if closestPlayer then
            local targetRoot = closestPlayer.Character.HumanoidRootPart
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, targetRoot.Position)
        end
    end
end)

-- Обновление FOV Circle при изменении размера экрана
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
    updateFOVCircle()
end)

print("SANSTRO Menu loaded successfully!")
print("Features: Speed Hack, Jump Hack, NoClip, ESP, AimBot")
print("Use the ☰ button to open/close the menu")