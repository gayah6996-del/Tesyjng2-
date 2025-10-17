-- SimpleSpy GUI код остается без изменений
if _G.SimpleSpyExecuted and type(_G.SimpleSpyShutdown) == "function" then
	print(pcall(_G.SimpleSpyShutdown))
end

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local Highlight = loadstring(game:HttpGet("https://github.com/exxtremestuffs/SimpleSpySource/raw/master/highlight.lua"))()

-- ... (весь код SimpleSpy GUI остается без изменений)
-- Вся функциональность SimpleSpy остается

-- Теперь добавляем ВСЕ функции из ndnd.lua:

-- Функция показа уведомлений
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

-- Переменные для функций (будут обновляться из настроек)
local ActiveKillAura = Settings.ActiveKillAura
local ActiveAutoChopTree = Settings.ActiveAutoChopTree
local DistanceForKillAura = Settings.DistanceForKillAura
local DistanceForAutoChopTree = Settings.DistanceForAutoChopTree

-- Новые переменные для телепортации предметов (будут обновляться из настроек)
local BringCount = Settings.BringCount
local BringDelay = Settings.BringDelay

-- Новая переменная для выбора цели телепортации (будет обновляться из настроек)
local TeleportTarget = Settings.TeleportTarget

-- Функция создания toggle элементов
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

-- Функция создания слайдеров
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
        SaveSettings()
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
            SaveSettings()
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
    dropdownList.Parent = ScreenGui
    
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
                SaveSettings()
            end
        end)
    end
    
    -- Закрывать выпадающий список при клике вне его
    local function onInputBegan(input)
        if isOpen then
            local touchPos = input.Position
            local listAbsolutePos = dropdownList.AbsolutePosition
            local listAbsoluteSize = dropdownList.AbsoluteSize
            
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

-- Функция для получения целевой позиции телепортации
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
wait(1)
ApplySavedSettings()

print("All ASTRALCHEAT functions loaded successfully!")