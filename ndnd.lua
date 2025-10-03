--- Services
local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local players = game:GetService("Players")
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")

-- Aimbot & ESP Variables
local aimbotEnabled = false
local espEnabled = false
local fovRadius = 100
local guiName = "AimbotToggleGUI"
local guiVisible = false -- GUI изначально скрыто
local espObjects = {}
local functionsVisible = false -- Функции изначально скрыты

-- FOV Circle
local circle = Drawing.new("Circle")
circle.Color = Color3.fromRGB(255, 255, 255)
circle.Thickness = 1
circle.Filled = false
circle.Radius = fovRadius
circle.Visible = true
circle.Position = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)

-- Show Notification
local function showNotification()
    local notification = Instance.new("ScreenGui")
    notification.Name = "NotificationGUI"
    notification.ResetOnSpawn = false
    notification.Parent = player:WaitForChild("PlayerGui")

    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://6073491164"
    sound.Volume = 1
    sound.Parent = notification
    sound:Play()

    local textLabel = Instance.new("TextLabel")
    textLabel.Parent = notification
    textLabel.Size = UDim2.new(0, 250, 0, 50)
    textLabel.Position = UDim2.new(1, -260, 1, -60)
    textLabel.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    textLabel.BorderSizePixel = 0
    textLabel.Text = "Скрипт успешно запущен✅!"
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.SourceSansBold

    task.delay(3, function()
        for i = 1, 10 do
            textLabel.TextTransparency = i * 0.1
            textLabel.BackgroundTransparency = i * 0.1
            task.wait(0.05)
        end
        notification:Destroy()
    end)
end

-- Create ESP for a player
local function createESPForPlayer(p)
    local nameTag = Drawing.new("Text")
    nameTag.Size = 14
    nameTag.Color = Color3.fromRGB(255, 0, 0)
    nameTag.Center = true
    nameTag.Outline = true

    local distanceTag = Drawing.new("Text")
    distanceTag.Size = 13
    distanceTag.Color = Color3.fromRGB(255, 0, 0)
    distanceTag.Center = true
    distanceTag.Outline = true

    local box = Drawing.new("Square")
    box.Thickness = 1
    box.Color = Color3.fromRGB(255, 0, 0)
    box.Filled = false

    local tracer = Drawing.new("Line")
    tracer.Thickness = 1
    tracer.Color = Color3.fromRGB(255, 0, 0)

    espObjects[p] = {
        name = nameTag,
        distance = distanceTag,
        box = box,
        tracer = tracer
    }
end

-- Remove ESP
local function removeESPForPlayer(p)
    if espObjects[p] then
        for _, drawing in pairs(espObjects[p]) do
            drawing:Remove()
        end
        espObjects[p] = nil
    end
end

players.PlayerRemoving:Connect(removeESPForPlayer)

-- Visibility Check
local function isVisible(part)
    if not part then return false end
    local origin = camera.CFrame.Position
    local direction = (part.Position - origin)
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist
    rayParams.FilterDescendantsInstances = { player.Character or workspace }
    local result = workspace:Raycast(origin, direction, rayParams)
    if result then
        return part:IsDescendantOf(result.Instance.Parent) or result.Instance:IsDescendantOf(part.Parent)
    else
        return true
    end
end

-- Closest Player Function
local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = fovRadius

    for _, p in pairs(players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
            local head = p.Character.Head
            local screenPos, onScreen = camera:WorldToViewportPoint(head.Position)
            if onScreen then
                local distanceFromCenter = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)).Magnitude
                if distanceFromCenter < shortestDistance and isVisible(head) then
                    shortestDistance = distanceFromCenter
                    closestPlayer = p
                end
            end
        end
    end

    return closestPlayer
end

-- GUI Creation Function
local function createGUI()
    local gui = Instance.new("ScreenGui")
    gui.Name = guiName
    gui.ResetOnSpawn = false
    gui.Parent = player:WaitForChild("PlayerGui")

    -- Кнопка Show GUI (изначально видна)
    local showGuiButton = Instance.new("TextButton", gui)
    showGuiButton.Size = UDim2.new(0, 100, 0, 30)
    showGuiButton.Position = UDim2.new(0, 20, 0, 20)
    showGuiButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    showGuiButton.Text = "Show GUI"
    showGuiButton.TextColor3 = Color3.new(1, 1, 1)
    showGuiButton.TextScaled = true
    showGuiButton.BorderSizePixel = 0
    showGuiButton.Visible = true

    -- Основное меню (изначально скрыто)
    local mainFrame = Instance.new("Frame", gui)
    mainFrame.Position = UDim2.new(0.5, -100, 0.5, -115)
    mainFrame.Size = UDim2.new(0, 200, 0, 250)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.BorderSizePixel = 1
    mainFrame.BorderColor3 = Color3.fromRGB(100, 100, 100)
    mainFrame.Visible = guiVisible

    local title = Instance.new("TextLabel", mainFrame)
    title.Size = UDim2.new(1, 0, 0, 25)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    title.Text = "ASTRALCHEAT V1.0 BY @SFXCL"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.TextScaled = true
    title.Font = Enum.Font.SourceSansBold
    title.BorderSizePixel = 0

    -- Табы
    local tabsFrame = Instance.new("Frame", mainFrame)
    tabsFrame.Size = UDim2.new(1, 0, 0, 30)
    tabsFrame.Position = UDim2.new(0, 0, 0, 25)
    tabsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    tabsFrame.BorderSizePixel = 0

    local testTabButton = Instance.new("TextButton", tabsFrame)
    testTabButton.Size = UDim2.new(1, 0, 1, 0)
    testTabButton.Position = UDim2.new(0, 0, 0, 0)
    testTabButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    testTabButton.Text = "Test"
    testTabButton.TextColor3 = Color3.new(1, 1, 1)
    testTabButton.TextScaled = true
    testTabButton.BorderSizePixel = 0

    -- Контент для вкладки Test (изначально скрыт)
    local testContent = Instance.new("Frame", mainFrame)
    testContent.Size = UDim2.new(1, 0, 0, 195)
    testContent.Position = UDim2.new(0, 0, 0, 55)
    testContent.BackgroundTransparency = 1
    testContent.Visible = false
    testContent.Name = "TestContent"

    -- Аимбот кнопки в Test вкладке
    local aimbotOn = Instance.new("TextButton", testContent)
    aimbotOn.Size = UDim2.new(0.5, -5, 0.2, -5)
    aimbotOn.Position = UDim2.new(0, 5, 0, 0)
    aimbotOn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    aimbotOn.Text = "Aimbot ON"
    aimbotOn.TextColor3 = Color3.new(1, 1, 1)
    aimbotOn.TextScaled = true
    aimbotOn.BorderSizePixel = 0

    local aimbotOff = Instance.new("TextButton", testContent)
    aimbotOff.Size = UDim2.new(0.5, -5, 0.2, -5)
    aimbotOff.Position = UDim2.new(0.5, 5, 0, 0)
    aimbotOff.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    aimbotOff.Text = "Aimbot OFF ✅"
    aimbotOff.TextColor3 = Color3.new(1, 1, 1)
    aimbotOff.TextScaled = true
    aimbotOff.BorderSizePixel = 0

    -- ESP кнопки в Test вкладке
    local espOn = Instance.new("TextButton", testContent)
    espOn.Size = UDim2.new(0.5, -5, 0.2, -5)
    espOn.Position = UDim2.new(0, 5, 0.25, 0)
    espOn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    espOn.Text = "ESP ON"
    espOn.TextColor3 = Color3.new(1, 1, 1)
    espOn.TextScaled = true
    espOn.BorderSizePixel = 0

    local espOff = Instance.new("TextButton", testContent)
    espOff.Size = UDim2.new(0.5, -5, 0.2, -5)
    espOff.Position = UDim2.new(0.5, 5, 0.25, 0)
    espOff.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    espOff.Text = "ESP OFF ✅"
    espOff.TextColor3 = Color3.new(1, 1, 1)
    espOff.TextScaled = true
    espOff.BorderSizePixel = 0

    -- FOV Slider в Test вкладке
    local fovSliderFrame = Instance.new("Frame", testContent)
    fovSliderFrame.Size = UDim2.new(0.9, 0, 0, 60)
    fovSliderFrame.Position = UDim2.new(0.05, 0, 0.5, 0)
    fovSliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    fovSliderFrame.BorderSizePixel = 0

    local fovLabel = Instance.new("TextLabel", fovSliderFrame)
    fovLabel.Size = UDim2.new(1, 0, 0.3, 0)
    fovLabel.Position = UDim2.new(0, 0, 0, 0)
    fovLabel.BackgroundTransparency = 1
    fovLabel.Text = "FOV Radius: " .. fovRadius
    fovLabel.TextColor3 = Color3.new(1, 1, 1)
    fovLabel.TextScaled = true
    fovLabel.Font = Enum.Font.SourceSans

    local sliderBackground = Instance.new("TextButton", fovSliderFrame)
    sliderBackground.Size = UDim2.new(1, 0, 0.4, 0)
    sliderBackground.Position = UDim2.new(0, 0, 0.4, 0)
    sliderBackground.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    sliderBackground.BorderSizePixel = 0
    sliderBackground.Text = ""
    sliderBackground.AutoButtonColor = false

    local sliderFill = Instance.new("Frame", sliderBackground)
    sliderFill.Size = UDim2.new((fovRadius - 50) / 200, 0, 1, 0)
    sliderFill.Position = UDim2.new(0, 0, 0, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    sliderFill.BorderSizePixel = 0

    local sliderButton = Instance.new("Frame", sliderBackground)
    sliderButton.Size = UDim2.new(0, 25, 1.5, 0)
    sliderButton.Position = UDim2.new((fovRadius - 50) / 200, -12, -0.25, 0)
    sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderButton.BorderSizePixel = 1
    sliderButton.BorderColor3 = Color3.fromRGB(200, 200, 200)

    -- Кнопки + и - для точной настройки
    local minusButton = Instance.new("TextButton", fovSliderFrame)
    minusButton.Size = UDim2.new(0.2, 0, 0.25, 0)
    minusButton.Position = UDim2.new(0, 0, 0.85, 0)
    minusButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    minusButton.Text = "-"
    minusButton.TextColor3 = Color3.new(1, 1, 1)
    minusButton.TextScaled = true
    minusButton.BorderSizePixel = 0

    local plusButton = Instance.new("TextButton", fovSliderFrame)
    plusButton.Size = UDim2.new(0.2, 0, 0.25, 0)
    plusButton.Position = UDim2.new(0.8, 0, 0.85, 0)
    plusButton.BackgroundColor3 = Color3.fromRGB(80, 255, 80)
    plusButton.Text = "+"
    plusButton.TextColor3 = Color3.new(1, 1, 1)
    plusButton.TextScaled = true
    plusButton.BorderSizePixel = 0

    -- Функция обновления FOV
    local function updateFOV(value)
        fovRadius = math.floor(math.clamp(value, 50, 250))
        circle.Radius = fovRadius
        fovLabel.Text = "FOV Radius: " .. fovRadius
        
        local fillSize = (fovRadius - 50) / 200
        sliderFill.Size = UDim2.new(fillSize, 0, 1, 0)
        sliderButton.Position = UDim2.new(fillSize, -12, -0.25, 0)
    end

    -- Обработка тача для слайдера
    local isSliding = false

    local function updateSliderFromTouch(touchPosition)
        local sliderAbsPos = sliderBackground.AbsolutePosition
        local sliderAbsSize = sliderBackground.AbsoluteSize
        local touchX = touchPosition.X
        
        local relativeX = (touchX - sliderAbsPos.X) / sliderAbsSize.X
        relativeX = math.clamp(relativeX, 0, 1)
        
        local newFOV = 50 + (relativeX * 200)
        updateFOV(newFOV)
    end

    -- Обработка начала тача
    sliderBackground.MouseButton1Down:Connect(function(x, y)
        isSliding = true
        updateSliderFromTouch(Vector2.new(x, y))
    end)

    -- Обработка движения тача
    userInputService.InputChanged:Connect(function(input)
        if isSliding and input.UserInputType == Enum.UserInputType.Touch then
            updateSliderFromTouch(input.Position)
        end
    end)

    -- Обработка окончания тача
    userInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            isSliding = false
        end
    end)

    -- Кнопки + и -
    minusButton.MouseButton1Click:Connect(function()
        updateFOV(fovRadius - 10)
    end)

    plusButton.MouseButton1Click:Connect(function()
        updateFOV(fovRadius + 10)
    end)

    -- Обработчики кнопок аимбота и ESP
    aimbotOn.MouseButton1Click:Connect(function()
        aimbotEnabled = true
        aimbotOn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        aimbotOff.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        aimbotOn.Text = "Aimbot ON ✅"
        aimbotOff.Text = "Aimbot OFF"
    end)

    aimbotOff.MouseButton1Click:Connect(function()
        aimbotEnabled = false
        aimbotOn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        aimbotOff.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        aimbotOn.Text = "Aimbot ON"
        aimbotOff.Text = "Aimbot OFF ✅"
    end)

    espOn.MouseButton1Click:Connect(function()
        espEnabled = true
        espOn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        espOff.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        espOn.Text = "ESP ON ✅"
        espOff.Text = "ESP OFF"
    end)

    espOff.MouseButton1Click:Connect(function()
        espEnabled = false
        espOn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        espOff.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        espOn.Text = "ESP ON"
        espOff.Text = "ESP OFF ✅"
        -- Скрываем все ESP объекты
        for _, drawings in pairs(espObjects) do
            if drawings then
                drawings.box.Visible = false
                drawings.name.Visible = false
                drawings.distance.Visible = false
                drawings.tracer.Visible = false
            end
        end
    end)

    -- Функция переключения табов
    local function switchTab(tabName)
        if tabName == "Test" then
            testContent.Visible = true
            testTabButton.BackgroundColor3 = Color3.fromRGB(0, 80, 200)
        end
    end

    -- Обработчик таба Test
    testTabButton.MouseButton1Click:Connect(function()
        switchTab("Test")
    end)

    -- Обработчик кнопки Show/Hide GUI
    showGuiButton.MouseButton1Click:Connect(function()
        guiVisible = not guiVisible
        mainFrame.Visible = guiVisible
        showGuiButton.Text = guiVisible and "Hide GUI" or "Show GUI"
        
        -- При открытии GUI автоматически открываем вкладку Test
        if guiVisible then
            switchTab("Test")
        else
            testContent.Visible = false
        end
    end)
end

createGUI()
showNotification()

player.CharacterAdded:Connect(function()
    task.wait(1)
    if not player:WaitForChild("PlayerGui"):FindFirstChild(guiName) then
        createGUI()
    end
end)

runService.RenderStepped:Connect(function()
    circle.Position = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)

    if aimbotEnabled then
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            local headPos = target.Character.Head.Position
            camera.CFrame = CFrame.new(camera.CFrame.Position, headPos)
        end
    end

    for _, p in pairs(players:GetPlayers()) do
        if p ~= player then
            if not espObjects[p] then
                createESPForPlayer(p)
            end

            local drawings = espObjects[p]
            local char = p.Character
            if espEnabled and char and char:FindFirstChild("Head") and char:FindFirstChild("HumanoidRootPart") then
                local head = char.Head
                local hrp = char.HumanoidRootPart
                local headPos2D, onScreen1 = camera:WorldToViewportPoint(head.Position)
                local rootPos2D, onScreen2 = camera:WorldToViewportPoint(hrp.Position)

                if onScreen1 and onScreen2 and drawings then
                    local height = (headPos2D - rootPos2D).Magnitude * 2
                    local width = height / 2

                    drawings.box.Size = Vector2.new(width, height)
                    drawings.box.Position = Vector2.new(rootPos2D.X - width/2, rootPos2D.Y - height/2)
                    drawings.box.Visible = true

                    drawings.name.Text = p.Name
                    drawings.name.Position = Vector2.new(headPos2D.X, headPos2D.Y - 20)
                    drawings.name.Visible = true

                    local distance = math.floor((player.Character.HumanoidRootPart.Position - hrp.Position).Magnitude)
                    drawings.distance.Text = tostring(distance) .. "m"
                    drawings.distance.Position = Vector2.new(rootPos2D.X, rootPos2D.Y + height/2 + 5)
                    drawings.distance.Visible = true

                    drawings.tracer.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                    drawings.tracer.To = Vector2.new(rootPos2D.X, rootPos2D.Y)
                    drawings.tracer.Visible = true
                elseif drawings then
                    drawings.box.Visible = false
                    drawings.name.Visible = false
                    drawings.distance.Visible = false
                    drawings.tracer.Visible = false
                end
            elseif drawings then
                drawings.box.Visible = false
                drawings.name.Visible = false
                drawings.distance.Visible = false
                drawings.tracer.Visible = false
            end
        end
    end
end)