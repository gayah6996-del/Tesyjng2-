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
local isGuiOpen = false
local OpenCloseButton = nil

-- ESP объекты
local espObjects = {}
local espConnections = {}
local espCountText = nil
local noclipConnection = nil

-- Сохраняем состояния при смерти
local function saveStates()
    return {
        speedHackEnabled = speedHackEnabled,
        jumpHackEnabled = jumpHackEnabled,
        noclipEnabled = noclipEnabled,
        espTracersEnabled = espTracersEnabled,
        espBoxEnabled = espBoxEnabled,
        espHealthEnabled = espHealthEnabled,
        espDistanceEnabled = espDistanceEnabled,
        espCountEnabled = espCountEnabled,
        aimBotEnabled = aimBotEnabled,
        currentSpeed = currentSpeed,
        aimBotFOV = aimBotFOV
    }
end

local savedStates = saveStates()

-- Восстанавливаем состояния после смерти
local function restoreStates(states)
    speedHackEnabled = states.speedHackEnabled or false
    jumpHackEnabled = states.jumpHackEnabled or false
    noclipEnabled = states.noclipEnabled or false
    espTracersEnabled = states.espTracersEnabled or false
    espBoxEnabled = states.espBoxEnabled or false
    espHealthEnabled = states.espHealthEnabled or false
    espDistanceEnabled = states.espDistanceEnabled or false
    espCountEnabled = states.espCountEnabled or false
    aimBotEnabled = states.aimBotEnabled or false
    currentSpeed = states.currentSpeed or 16
    aimBotFOV = states.aimBotFOV or 50
end

-- Функция создания FOV Circle
local function createFOVCircle()
    if fovCircle then
        fovCircle:Remove()
    end
    
    fovCircle = Drawing.new("Circle")
    fovCircle.Visible = false
    fovCircle.Color = Color3.fromRGB(200, 100, 255)
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

-- Функция создания кнопки открытия/закрытия
local function createOpenCloseButton()
    if OpenCloseButton then
        OpenCloseButton:Destroy()
    end

    OpenCloseButton = Instance.new("TextButton")
    OpenCloseButton.Name = "OpenCloseButton"
    OpenCloseButton.Size = UDim2.new(0, 60, 0, 60)
    OpenCloseButton.Position = savedButtonPosition
    OpenCloseButton.BackgroundColor3 = Color3.fromRGB(120, 50, 200)
    OpenCloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    OpenCloseButton.Text = "≡"
    OpenCloseButton.Font = Enum.Font.GothamBold
    OpenCloseButton.TextSize = 24
    OpenCloseButton.ZIndex = 10
    OpenCloseButton.Active = true
    OpenCloseButton.Draggable = true
    OpenCloseButton.Parent = ScreenGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(1, 0)
    Corner.Parent = OpenCloseButton

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(200, 150, 255)
    Stroke.Thickness = 2
    Stroke.Parent = OpenCloseButton

    -- Обработчик нажатия
    OpenCloseButton.MouseButton1Click:Connect(function()
        isGuiOpen = not isGuiOpen
        MainFrame.Visible = isGuiOpen
        
        if isGuiOpen then
            OpenCloseButton.Text = "≡"
            OpenCloseButton.BackgroundColor3 = Color3.fromRGB(150, 70, 220)
        else
            OpenCloseButton.Text = "≡"
            OpenCloseButton.BackgroundColor3 = Color3.fromRGB(120, 50, 200)
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
        button.BackgroundColor3 = Color3.fromRGB(180, 80, 255)
        button.Text = "ON"
    else
        button.BackgroundColor3 = Color3.fromRGB(80, 30, 120)
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
                    espObjects[otherPlayer].tracer.Color = Color3.fromRGB(180, 80, 255)
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
                    espObjects[otherPlayer].box.Color = Color3.fromRGB(180, 80, 255)
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
                    espObjects[otherPlayer].health.Color = Color3.fromRGB(180, 80, 255)
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
                    espObjects[otherPlayer].distance.Color = Color3.fromRGB(180, 80, 255)
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
    
    espConnections[otherPlayer] = RunService.Heartbeat:Connect(updateESP)
    
    otherPlayer.AncestryChanged:Connect(function()
        if not otherPlayer.Parent then
            cleanupESP(otherPlayer)
        end
    end)
end

-- ESP Count Function
local function updateESPCount()
    if not espCountEnabled then return end
    
    local aliveCount = 0
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("Humanoid") and otherPlayer.Character.Humanoid.Health > 0 then
            aliveCount = aliveCount + 1
        end
    end
    
    if espCountText then
        espCountText.Text = "Players: " .. aliveCount
    end
end

-- Improved AimBot with wall check and FOV
local function isPlayerVisible(targetPlayer)
    if not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return false
    end
    
    local targetRoot = targetPlayer.Character.HumanoidRootPart
    local camera = workspace.CurrentCamera
    local origin = camera.CFrame.Position
    
    local direction = (targetRoot.Position - origin).Unit
    local ray = Ray.new(origin, direction * 1000)
    
    local ignoreList = {player.Character, camera}
    local hit, hitPosition = workspace:FindPartOnRayWithIgnoreList(ray, ignoreList)
    
    if hit then
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

-- Улучшенная функция для слайдеров на мобильных устройствах
local function createMobileSlider(sliderFrame, callback)
    local isSliding = false
    
    sliderFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            isSliding = true
            
            while isSliding do
                local touchPos
                if input.UserInputType == Enum.UserInputType.Touch then
                    touchPos = input.Position
                else
                    touchPos = UserInputService:GetMouseLocation()
                end
                
                local sliderAbsolutePos = sliderFrame.AbsolutePosition
                local sliderAbsoluteSize = sliderFrame.AbsoluteSize
                
                local relativeX = math.clamp((touchPos.X - sliderAbsolutePos.X) / sliderAbsoluteSize.X, 0, 1)
                
                callback(relativeX)
                
                RunService.Heartbeat:Wait()
            end
        end
    end)
    
    sliderFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            isSliding = false
        end
    end)
end

-- Функция создания GUI
local function createGUI()
    if ScreenGui then
        savedPosition = MainFrame.Position
        ScreenGui:Destroy()
    end

    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SANSTRO_GUI"
    ScreenGui.Parent = player.PlayerGui
    ScreenGui.ResetOnSpawn = false

    MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 300, 0, 400)
    MainFrame.Position = savedPosition
    MainFrame.BackgroundColor3 = Color3.fromRGB(50, 20, 80)
    MainFrame.BackgroundTransparency = 0.1
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Visible = isGuiOpen
    MainFrame.Parent = ScreenGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(150, 70, 220)
    MainStroke.Thickness = 2
    MainStroke.Parent = MainFrame

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Position = UDim2.new(0, 0, 0, 0)
    Title.BackgroundColor3 = Color3.fromRGB(70, 30, 110)
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Text = "SANSTRO | t.me/SCRIPTYTA"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.ZIndex = 2
    Title.Parent = MainFrame

    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 12)
    TitleCorner.Parent = Title

    local TabButtons = Instance.new("Frame")
    TabButtons.Name = "TabButtons"
    TabButtons.Size = UDim2.new(1, 0, 0, 40)
    TabButtons.Position = UDim2.new(0, 0, 0, 40)
    TabButtons.BackgroundTransparency = 1
    TabButtons.ZIndex = 2
    TabButtons.Parent = MainFrame

    -- Movement Tab
    local MovementTab = Instance.new("TextButton")
    MovementTab.Name = "MovementTab"
    MovementTab.Size = UDim2.new(0.33, 0, 1, 0)
    MovementTab.Position = UDim2.new(0, 0, 0, 0)
    MovementTab.BackgroundColor3 = Color3.fromRGB(120, 50, 200)
    MovementTab.TextColor3 = Color3.fromRGB(255, 255, 255)
    MovementTab.Text = "Movement"
    MovementTab.Font = Enum.Font.Gotham
    MovementTab.TextSize = 14
    MovementTab.ZIndex = 2
    MovementTab.Parent = TabButtons

    local MovementTabCorner = Instance.new("UICorner")
    MovementTabCorner.CornerRadius = UDim.new(0, 6)
    MovementTabCorner.Parent = MovementTab

    -- Visual Tab
    local VisualTab = Instance.new("TextButton")
    VisualTab.Name = "VisualTab"
    VisualTab.Size = UDim2.new(0.33, 0, 1, 0)
    VisualTab.Position = UDim2.new(0.33, 0, 0, 0)
    VisualTab.BackgroundColor3 = Color3.fromRGB(90, 40, 140)
    VisualTab.TextColor3 = Color3.fromRGB(255, 255, 255)
    VisualTab.Text = "Visual"
    VisualTab.Font = Enum.Font.Gotham
    VisualTab.TextSize = 14
    VisualTab.ZIndex = 2
    VisualTab.Parent = TabButtons

    local VisualTabCorner = Instance.new("UICorner")
    VisualTabCorner.CornerRadius = UDim.new(0, 6)
    VisualTabCorner.Parent = VisualTab

    -- AimBot Tab
    local AimBotTab = Instance.new("TextButton")
    AimBotTab.Name = "AimBotTab"
    AimBotTab.Size = UDim2.new(0.34, 0, 1, 0)
    AimBotTab.Position = UDim2.new(0.66, 0, 0, 0)
    AimBotTab.BackgroundColor3 = Color3.fromRGB(90, 40, 140)
    AimBotTab.TextColor3 = Color3.fromRGB(255, 255, 255)
    AimBotTab.Text = "AimBot"
    AimBotTab.Font = Enum.Font.Gotham
    AimBotTab.TextSize = 14
    AimBotTab.ZIndex = 2
    AimBotTab.Parent = TabButtons

    local AimBotTabCorner = Instance.new("UICorner")
    AimBotTabCorner.CornerRadius = UDim.new(0, 6)
    AimBotTabCorner.Parent = AimBotTab

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
    MovementContent.Size = UDim2.new(1, 0, 0, 150)
    MovementContent.BackgroundTransparency = 1
    MovementContent.Visible = true
    MovementContent.ZIndex = 2
    MovementContent.Parent = ScrollFrame

    -- Speed Hack
    local SpeedHackFrame = Instance.new("Frame")
    SpeedHackFrame.Name = "SpeedHackFrame"
    SpeedHackFrame.Size = UDim2.new(1, 0, 0, 80)
    SpeedHackFrame.BackgroundColor3 = Color3.fromRGB(70, 30, 110)
    SpeedHackFrame.BorderSizePixel = 0
    SpeedHackFrame.ZIndex = 2
    SpeedHackFrame.Parent = MovementContent

    local SpeedHackCorner = Instance.new("UICorner")
    SpeedHackCorner.CornerRadius = UDim.new(0, 8)
    SpeedHackCorner.Parent = SpeedHackFrame

    local SpeedHackStroke = Instance.new("UIStroke")
    SpeedHackStroke.Color = Color3.fromRGB(150, 70, 220)
    SpeedHackStroke.Thickness = 1
    SpeedHackStroke.Parent = SpeedHackFrame

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
    SpeedHackLabel.ZIndex = 2
    SpeedHackLabel.Parent = SpeedHackFrame

    local SpeedHackToggle = Instance.new("TextButton")
    SpeedHackToggle.Name = "SpeedHackToggle"
    SpeedHackToggle.Size = UDim2.new(0.3, 0, 0, 30)
    SpeedHackToggle.Position = UDim2.new(0.7, 0, 0, 10)
    SpeedHackToggle.BackgroundColor3 = speedHackEnabled and Color3.fromRGB(180, 80, 255) or Color3.fromRGB(80, 30, 120)
    SpeedHackToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    SpeedHackToggle.Text = speedHackEnabled and "ON" or "OFF"
    SpeedHackToggle.Font = Enum.Font.Gotham
    SpeedHackToggle.TextSize = 12
    SpeedHackToggle.ZIndex = 2
    SpeedHackToggle.Parent = SpeedHackFrame

    local SpeedHackToggleCorner = Instance.new("UICorner")
    SpeedHackToggleCorner.CornerRadius = UDim.new(0, 6)
    SpeedHackToggleCorner.Parent = SpeedHackToggle

    local SpeedHackSlider = Instance.new("TextButton")
    SpeedHackSlider.Name = "SpeedHackSlider"
    SpeedHackSlider.Size = UDim2.new(1, -20, 0, 30)
    SpeedHackSlider.Position = UDim2.new(0, 10, 0, 45)
    SpeedHackSlider.BackgroundColor3 = Color3.fromRGB(60, 20, 100)
    SpeedHackSlider.BorderSizePixel = 0
    SpeedHackSlider.Text = ""
    SpeedHackSlider.Visible = speedHackEnabled
    SpeedHackSlider.ZIndex = 2
    SpeedHackSlider.Parent = SpeedHackFrame

    local SpeedHackSliderCorner = Instance.new("UICorner")
    SpeedHackSliderCorner.CornerRadius = UDim.new(0, 6)
    SpeedHackSliderCorner.Parent = SpeedHackSlider

    local SpeedFill = Instance.new("Frame")
    SpeedFill.Name = "SpeedFill"
    SpeedFill.Size = UDim2.new((currentSpeed - 16) / 84, 0, 1, 0)
    SpeedFill.BackgroundColor3 = Color3.fromRGB(180, 80, 255)
    SpeedFill.BorderSizePixel = 0
    SpeedFill.ZIndex = 3
    SpeedFill.Parent = SpeedHackSlider

    local SpeedFillCorner = Instance.new("UICorner")
    SpeedFillCorner.CornerRadius = UDim.new(0, 6)
    SpeedFillCorner.Parent = SpeedFill

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
    JumpHackFrame.BackgroundColor3 = Color3.fromRGB(70, 30, 110)
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
    JumpHackToggle.Size = UDim2.new(0.3, 0, 0, 30)
    JumpHackToggle.Position = UDim2.new(0.7, 0, 0.125, 0)
    JumpHackToggle.BackgroundColor3 = jumpHackEnabled and Color3.fromRGB(180, 80, 255) or Color3.fromRGB(80, 30, 120)
    JumpHackToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    JumpHackToggle.Text = jumpHackEnabled and "ON" or "OFF"
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
    NoClipFrame.Position = UDim2.new(0, 0, 0, 140)
    NoClipFrame.BackgroundColor3 = Color3.fromRGB(70, 30, 110)
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
    NoClipToggle.Size = UDim2.new(0.3, 0, 0, 30)
    NoClipToggle.Position = UDim2.new(0.7, 0, 0.125, 0)
    NoClipToggle.BackgroundColor3 = noclipEnabled and Color3.fromRGB(180, 80, 255) or Color3.fromRGB(80, 30, 120)
    NoClipToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    NoClipToggle.Text = noclipEnabled and "ON" or "OFF"
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
    VisualContent.Size = UDim2.new(1, 0, 0, 250)
    VisualContent.BackgroundTransparency = 1
    VisualContent.Visible = false
    VisualContent.ZIndex = 2
    VisualContent.Parent = ScrollFrame

    -- ESP Tracers
    local ESPTracersFrame = Instance.new("Frame")
    ESPTracersFrame.Name = "ESPTracersFrame"
    ESPTracersFrame.Size = UDim2.new(1, 0, 0, 40)
    ESPTracersFrame.BackgroundColor3 = Color3.fromRGB(70, 30, 110)
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
    ESPTracersToggle.Size = UDim2.new(0.3, 0, 0, 30)
    ESPTracersToggle.Position = UDim2.new(0.7, 0, 0.125, 0)
    ESPTracersToggle.BackgroundColor3 = espTracersEnabled and Color3.fromRGB(180, 80, 255) or Color3.fromRGB(80, 30, 120)
    ESPTracersToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    ESPTracersToggle.Text = espTracersEnabled and "ON" or "OFF"
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
    ESPBoxFrame.BackgroundColor3 = Color3.fromRGB(70, 30, 110)
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
    ESPBoxToggle.Size = UDim2.new(0.3, 0, 0, 30)
    ESPBoxToggle.Position = UDim2.new(0.7, 0, 0.125, 0)
    ESPBoxToggle.BackgroundColor3 = espBoxEnabled and Color3.fromRGB(180, 80, 255) or Color3.fromRGB(80, 30, 120)
    ESPBoxToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    ESPBoxToggle.Text = espBoxEnabled and "ON" or "OFF"
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
    ESPHealthFrame.BackgroundColor3 = Color3.fromRGB(70, 30, 110)
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
    ESPHealthToggle.Size = UDim2.new(0.3, 0, 0, 30)
    ESPHealthToggle.Position = UDim2.new(0.7, 0, 0.125, 0)
    ESPHealthToggle.BackgroundColor3 = espHealthEnabled and Color3.fromRGB(180, 80, 255) or Color3.fromRGB(80, 30, 120)
    ESPHealthToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    ESPHealthToggle.Text = espHealthEnabled and "ON" or "OFF"
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
    ESPDistanceFrame.BackgroundColor3 = Color3.fromRGB(70, 30, 110)
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
    ESPDistanceToggle.Size = UDim2.new(0.3, 0, 0, 30)
    ESPDistanceToggle.Position = UDim2.new(0.7, 0, 0.125, 0)
    ESPDistanceToggle.BackgroundColor3 = espDistanceEnabled and Color3.fromRGB(180, 80, 255) or Color3.fromRGB(80, 30, 120)
    ESPDistanceToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    ESPDistanceToggle.Text = espDistanceEnabled and "ON" or "OFF"
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
    ESPCountFrame.BackgroundColor3 = Color3.fromRGB(70, 30, 110)
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
    ESPCountLabel.Text = "ESP Player Count"
    ESPCountLabel.Font = Enum.Font.Gotham
    ESPCountLabel.TextSize = 14
    ESPCountLabel.TextXAlignment = Enum.TextXAlignment.Left
    ESPCountLabel.ZIndex = 2
    ESPCountLabel.Parent = ESPCountFrame

    local ESPCountToggle = Instance.new("TextButton")
    ESPCountToggle.Name = "ESPCountToggle"
    ESPCountToggle.Size = UDim2.new(0.3, 0, 0, 30)
    ESPCountToggle.Position = UDim2.new(0.7, 0, 0.125, 0)
    ESPCountToggle.BackgroundColor3 = espCountEnabled and Color3.fromRGB(180, 80, 255) or Color3.fromRGB(80, 30, 120)
    ESPCountToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    ESPCountToggle.Text = espCountEnabled and "ON" or "OFF"
    ESPCountToggle.Font = Enum.Font.Gotham
    ESPCountToggle.TextSize = 12
    ESPCountToggle.ZIndex = 2
    ESPCountToggle.Parent = ESPCountFrame

    local ESPCountToggleCorner = Instance.new("UICorner")
    ESPCountToggleCorner.CornerRadius = UDim.new(0, 6)
    ESPCountToggleCorner.Parent = ESPCountToggle

    -- ESP Count Text
    espCountText = Instance.new("TextLabel")
    espCountText.Name = "ESPCountText"
    espCountText.Size = UDim2.new(0, 120, 0, 30)
    espCountText.Position = UDim2.new(0, 10, 0, 250)
    espCountText.BackgroundColor3 = Color3.fromRGB(70, 30, 110)
    espCountText.TextColor3 = Color3.fromRGB(255, 255, 255)
    espCountText.Text = "Players: 0"
    espCountText.Font = Enum.Font.Gotham
    espCountText.TextSize = 14
    espCountText.Visible = espCountEnabled
    espCountText.ZIndex = 2
    espCountText.Parent = VisualContent

    local ESPCountTextCorner = Instance.new("UICorner")
    ESPCountTextCorner.CornerRadius = UDim.new(0, 6)
    ESPCountTextCorner.Parent = espCountText

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
    AimBotFrame.BackgroundColor3 = Color3.fromRGB(70, 30, 110)
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
    AimBotToggle.Size = UDim2.new(0.3, 0, 0, 30)
    AimBotToggle.Position = UDim2.new(0.7, 0, 0.125, 0)
    AimBotToggle.BackgroundColor3 = aimBotEnabled and Color3.fromRGB(180, 80, 255) or Color3.fromRGB(80, 30, 120)
    AimBotToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    AimBotToggle.Text = aimBotEnabled and "ON" or "OFF"
    AimBotToggle.Font = Enum.Font.Gotham
    AimBotToggle.TextSize = 12
    AimBotToggle.ZIndex = 2
    AimBotToggle.Parent = AimBotFrame

    local AimBotToggleCorner = Instance.new("UICorner")
    AimBotToggleCorner.CornerRadius = UDim.new(0, 6)
    AimBotToggleCorner.Parent = AimBotToggle

    -- FOV Slider
    local FOVFrame = Instance.new("Frame")
    FOVFrame.Name = "FOVFrame"
    FOVFrame.Size = UDim2.new(1, 0, 0, 60)
    FOVFrame.Position = UDim2.new(0, 0, 0, 50)
    FOVFrame.BackgroundColor3 = Color3.fromRGB(70, 30, 110)
    FOVFrame.BorderSizePixel = 0
    FOVFrame.ZIndex = 2
    FOVFrame.Parent = AimBotContent

    local FOVCorner = Instance.new("UICorner")
    FOVCorner.CornerRadius = UDim.new(0, 8)
    FOVCorner.Parent = FOVFrame

    local FOVLabel = Instance.new("TextLabel")
    FOVLabel.Name = "FOVLabel"
    FOVLabel.Size = UDim2.new(1, 0, 0, 30)
    FOVLabel.Position = UDim2.new(0, 0, 0, 0)
    FOVLabel.BackgroundTransparency = 1
    FOVLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    FOVLabel.Text = "AimBot FOV: " .. aimBotFOV
    FOVLabel.Font = Enum.Font.Gotham
    FOVLabel.TextSize = 14
    FOVLabel.ZIndex = 2
    FOVLabel.Parent = FOVFrame

    local FOVSlider = Instance.new("TextButton")
    FOVSlider.Name = "FOVSlider"
    FOVSlider.Size = UDim2.new(0.9, 0, 0, 20)
    FOVSlider.Position = UDim2.new(0.05, 0, 0, 35)
    FOVSlider.BackgroundColor3 = Color3.fromRGB(60, 20, 100)
    FOVSlider.Text = ""
    FOVSlider.ZIndex = 2
    FOVSlider.Parent = FOVFrame

    local FOVSliderCorner = Instance.new("UICorner")
    FOVSliderCorner.CornerRadius = UDim.new(0, 6)
    FOVSliderCorner.Parent = FOVSlider

    local FOVFill = Instance.new("Frame")
    FOVFill.Name = "FOVFill"
    FOVFill.Size = UDim2.new((aimBotFOV - 10) / 190, 0, 1, 0)
    FOVFill.BackgroundColor3 = Color3.fromRGB(180, 80, 255)
    FOVFill.BorderSizePixel = 0
    FOVFill.ZIndex = 3
    FOVFill.Parent = FOVSlider

    local FOVFillCorner = Instance.new("UICorner")
    FOVFillCorner.CornerRadius = UDim.new(0, 6)
    FOVFillCorner.Parent = FOVFill

    -- Set up scrolling
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 200)

    -- Create Open/Close Button
    createOpenCloseButton()

    -- Mobile слайдер для скорости
    createMobileSlider(SpeedHackSlider, function(relativeX)
        currentSpeed = math.floor(16 + (relativeX * 84))
        SpeedValue.Text = "Speed: " .. currentSpeed
        SpeedFill.Size = UDim2.new(relativeX, 0, 1, 0)
        
        if speedHackEnabled and player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = currentSpeed
            end
        end
    end)

    -- Mobile слайдер для FOV
    createMobileSlider(FOVSlider, function(relativeX)
        aimBotFOV = math.floor(10 + (relativeX * 190))
        FOVLabel.Text = "AimBot FOV: " .. aimBotFOV
        FOVFill.Size = UDim2.new(relativeX, 0, 1, 0)
        updateFOVCircle()
    end)

    -- Tab Switching
    MovementTab.MouseButton1Click:Connect(function()
        MovementContent.Visible = true
        VisualContent.Visible = false
        AimBotContent.Visible = false
        MovementTab.BackgroundColor3 = Color3.fromRGB(120, 50, 200)
        VisualTab.BackgroundColor3 = Color3.fromRGB(90, 40, 140)
        AimBotTab.BackgroundColor3 = Color3.fromRGB(90, 40, 140)
    end)

    VisualTab.MouseButton1Click:Connect(function()
        MovementContent.Visible = false
        VisualContent.Visible = true
        AimBotContent.Visible = false
        MovementTab.BackgroundColor3 = Color3.fromRGB(90, 40, 140)
        VisualTab.BackgroundColor3 = Color3.fromRGB(120, 50, 200)
        AimBotTab.BackgroundColor3 = Color3.fromRGB(90, 40, 140)
    end)

    AimBotTab.MouseButton1Click:Connect(function()
        MovementContent.Visible = false
        VisualContent.Visible = false
        AimBotContent.Visible = true
        MovementTab.BackgroundColor3 = Color3.fromRGB(90, 40, 140)
        VisualTab.BackgroundColor3 = Color3.fromRGB(90, 40, 140)
        AimBotTab.BackgroundColor3 = Color3.fromRGB(120, 50, 200)
    end)

    -- Speed Hack Toggle
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

    -- Jump Hack Toggle
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

    -- NoClip Toggle
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
        elseif noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
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
        espCountText.Visible = espCountEnabled
    end)

    -- AimBot Toggle
    AimBotToggle.MouseButton1Click:Connect(function()
        aimBotEnabled = not aimBotEnabled
        toggleButton(AimBotToggle, aimBotEnabled)
        
        if aimBotEnabled then
            if not fovCircle then
                createFOVCircle()
            end
            fovCircle.Visible = true
        elseif fovCircle then
            fovCircle.Visible = false
        end
    end)

    -- AimBot Logic
    RunService.Heartbeat:Connect(function()
        if aimBotEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local closestPlayer = nil
            local closestDistance = math.huge
            
            for _, otherPlayer in pairs(Players:GetPlayers()) do
                if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") and otherPlayer.Character:FindFirstChild("Humanoid") and otherPlayer.Character.Humanoid.Health > 0 then
                    local targetRoot = otherPlayer.Character.HumanoidRootPart
                    local distance = (player.Character.HumanoidRootPart.Position - targetRoot.Position).Magnitude
                    
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

    -- Update ESP Count
    RunService.Heartbeat:Connect(function()
        updateESPCount()
    end)

    -- Initialize ESP for existing players
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player then
            createESP(otherPlayer)
        end
    end

    -- Player Added/Removed
    Players.PlayerAdded:Connect(function(otherPlayer)
        createESP(otherPlayer)
    end)

    Players.PlayerRemoving:Connect(function(otherPlayer)
        cleanupESP(otherPlayer)
    end)

    -- Сохраняем позицию при перетаскивании
    MainFrame.DragStopped:Connect(function()
        savedPosition = MainFrame.Position
    end)
end

-- Main execution
createGUI()
createFOVCircle()

-- Сохраняем состояния перед смертью
player.CharacterRemoving:Connect(function()
    savedStates = saveStates()
end)

-- Восстанавливаем GUI и состояния после смерти
player.CharacterAdded:Connect(function()
    wait(1)
    restoreStates(savedStates)
    createGUI()
    createFOVCircle()
    
    -- Восстанавливаем функции после смерти
    if speedHackEnabled and player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = currentSpeed
        end
    end
    
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
    
    if aimBotEnabled and fovCircle then
        fovCircle.Visible = true
    end
end)