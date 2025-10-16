local a=game;local b=a.CoreGui;if b:FindFirstChild("MobileCheatMenu")then b.MobileCheatMenu:Destroy()end;local c=a:GetService("Players")local d=a:GetService("UserInputService")local e=a:GetService("RunService")local f=c.LocalPlayer;local g=Instance.new("ScreenGui")g.Name="MobileCheatMenu"g.ResetOnSpawn=false;g.Parent=b;local function h(i,j)local k=Instance.new("UICorner")k.CornerRadius=UDim.new(0,j or 8)k.Parent=i end;local l=Instance.new("Frame")l.Size=UDim2.new(0,400,0,500)l.AnchorPoint=Vector2.new(0.5,0.5)l.Position=UDim2.new(0.5,0,0.5,0)l.BackgroundColor3=Color3.fromRGB(20,20,20)l.BorderSizePixel=0;l.Parent=g;h(l,12)local m=Instance.new("TextLabel")m.Size=UDim2.new(1,-50,0,25)m.Position=UDim2.new(0,15,0,10)m.BackgroundTransparency=1;m.Text="ASTRALCHEAT v2.0 | 99 NIGHTS"m.Font=Enum.Font.GothamBold;m.TextSize=16;m.TextColor3=Color3.fromRGB(220,220,220)m.TextXAlignment=Enum.TextXAlignment.Left;m.Parent=l;local n=Instance.new("TextButton")n.Size=UDim2.new(0,30,0,30)n.Position=UDim2.new(1,-40,0,10)n.BackgroundColor3=Color3.fromRGB(220,60,60)n.Text="X"n.Font=Enum.Font.GothamBold;n.TextSize=18;n.TextColor3=Color3.fromRGB(255,255,255)n.Parent=l;h(n,6)local o=Instance.new("TextButton")o.Size=UDim2.new(0,42,0,42)o.Position=UDim2.new(1,-50,0,20)o.BackgroundColor3=Color3.fromRGB(40,40,40)o.Text="Open"o.Font=Enum.Font.GothamBold;o.TextSize=14;o.TextColor3=Color3.fromRGB(220,220,220)o.Visible=false;o.Parent=g;h(o,8)local p=Instance.new("Frame")p.Size=UDim2.new(1,-30,0,30)p.Position=UDim2.new(0,15,0,45)p.BackgroundTransparency=1;p.Parent=l;local q=Instance.new("UIListLayout")q.FillDirection=Enum.FillDirection.Horizontal;q.Padding=UDim.new(0,6)q.Parent=p;

-- Настройки для 99 Nights
local SETTINGS_FILE = "astralcheat_settings.txt"
local Settings = {
    ActiveKillAura = false,
    ActiveAutoChopTree = false,
    DistanceForKillAura = 25,
    DistanceForAutoChopTree = 25,
    BringCount = 2,
    BringDelay = 600,
    TeleportTarget = "Костёр"
}

-- Загрузка и сохранение настроек
local function SaveSettings()
    local success, err = pcall(function()
        local data = game:GetService("HttpService"):JSONEncode(Settings)
        writefile(SETTINGS_FILE, data)
    end)
end

local function LoadSettings()
    local success, err = pcall(function()
        if isfile(SETTINGS_FILE) then
            local data = readfile(SETTINGS_FILE)
            local loadedSettings = game:GetService("HttpService"):JSONDecode(data)
            for key, value in pairs(loadedSettings) do
                if Settings[key] ~= nil then
                    Settings[key] = value
                end
            end
            return true
        end
        return false
    end)
    return success
end

LoadSettings()

-- Создание вкладок из ndnd.lua
local r = {
    {name="Info", defaultActive=true},
    {name="Main", defaultActive=false},
    {name="Bring", defaultActive=false}
}

local s = {}
local t = {}

for u, v in ipairs(r) do
    local w = Instance.new("TextButton")
    w.Size = UDim2.new(0.33, -4, 1, 0)
    w.BackgroundColor3 = v.defaultActive and Color3.fromRGB(60,60,60) or Color3.fromRGB(40,40,40)
    w.Text = v.name
    w.Font = Enum.Font.GothamBold
    w.TextSize = 12
    w.TextColor3 = v.defaultActive and Color3.fromRGB(220,220,220) or Color3.fromRGB(150,150,150)
    w.Parent = p
    h(w, 6)
    
    local x = Instance.new("ScrollingFrame")
    x.Size = UDim2.new(1, -30, 1, -90)
    x.Position = UDim2.new(0, 15, 0, 85)
    x.BackgroundTransparency = 1
    x.ScrollBarThickness = 6
    x.ScrollBarImageColor3 = Color3.fromRGB(100,100,100)
    x.AutomaticCanvasSize = Enum.AutomaticSize.Y
    x.VerticalScrollBarInset = Enum.ScrollBarInset.Always
    x.Visible = v.defaultActive
    x.Parent = l
    
    local y = Instance.new("UIListLayout")
    y.SortOrder = Enum.SortOrder.LayoutOrder
    y.Padding = UDim.new(0, 8)
    y.Parent = x
    
    s[v.name] = w
    t[v.name] = x
end

-- Функция переключения вкладок
local function z(A)
    for B, C in pairs(t) do
        C.Visible = false
    end
    for B, D in pairs(s) do
        D.BackgroundColor3 = Color3.fromRGB(40,40,40)
        D.TextColor3 = Color3.fromRGB(150,150,150)
    end
    t[A].Visible = true
    s[A].BackgroundColor3 = Color3.fromRGB(60,60,60)
    s[A].TextColor3 = Color3.fromRGB(220,220,220)
end

for B, D in pairs(s) do
    D.MouseButton1Click:Connect(function()
        z(B)
    end)
end

-- Функции создания UI элементов из ndnd.lua
local function CreateSection(parent, title)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, 0, 0, 0)
    section.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    section.BorderSizePixel = 0
    section.AutomaticSize = Enum.AutomaticSize.Y
    section.Parent = parent
    h(section, 6)
    
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
    h(toggleButton, 4)
    
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
    h(toggleStatus, 10)
    
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
    h(sliderBar, 7)
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((defaultValue - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    sliderFill.Parent = sliderBar
    h(sliderFill, 7)
    
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
    
    d.InputChanged:Connect(onInputChanged)
    
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
    h(button, 6)
    
    button.MouseButton1Click:Connect(callback)
    
    return button
end

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
    h(textBox, 6)
    
    textBox.FocusLost:Connect(function()
        local value = tonumber(textBox.Text)
        if value then
            callback(value)
            SaveSettings()
        else
            textBox.Text = tostring(defaultValue)
        end
    end)
    
    return textBox
end

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
    h(dropdownButton, 6)
    
    local selectedOption = defaultOption or options[1]
    
    dropdownButton.MouseButton1Click:Connect(function()
        local currentIndex = 1
        for i, option in ipairs(options) do
            if option == selectedOption then
                currentIndex = i
                break
            end
        end
        
        local nextIndex = (currentIndex % #options) + 1
        selectedOption = options[nextIndex]
        dropdownButton.Text = selectedOption
        
        if callback then
            callback(selectedOption)
            SaveSettings()
        end
    end)
    
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

-- Переменные для функций 99 Nights
local ActiveKillAura = Settings.ActiveKillAura
local ActiveAutoChopTree = Settings.ActiveAutoChopTree
local DistanceForKillAura = Settings.DistanceForKillAura
local DistanceForAutoChopTree = Settings.DistanceForAutoChopTree
local BringCount = Settings.BringCount
local BringDelay = Settings.BringDelay
local TeleportTarget = Settings.TeleportTarget

local CampfirePosition = Vector3.new(0, 10, 0)

local function GetTargetPosition()
    if TeleportTarget == "Игрок" then
        local character = f.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            return character.HumanoidRootPart.Position
        else
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

-- Создание содержимого вкладок

-- Info Tab
local infoSection, infoContent = CreateSection(t["Info"], "📋 Script Information")
CreateLabel(infoContent, "99 Nights in the forest\n\nVersion: 2.0\n\nTelegram Channel: SCRIPTTYTA\n\nTelegram Owner: @SFXCL")

-- Main Tab
local killAuraSection, killAuraContent = CreateSection(t["Main"], "Автоубийство")
local killAuraSlider = CreateSlider(killAuraContent, "Дистанция", 25, 300, Settings.DistanceForKillAura, function(value)
    DistanceForKillAura = value
    Settings.DistanceForKillAura = value
end)

local killAuraToggle = CreateToggle(killAuraContent, "Kill Aura", function(value)
    ActiveKillAura = value
    Settings.ActiveKillAura = value
end)

local autoChopSection, autoChopContent = CreateSection(t["Main"], "АвтоРубка")
local autoChopSlider = CreateSlider(autoChopContent, "Дистанция", 0, 200, Settings.DistanceForAutoChopTree, function(value)
    DistanceForAutoChopTree = value
    Settings.DistanceForAutoChopTree = value
end)

local autoChopToggle = CreateToggle(autoChopContent, "Auto Tree", function(value)
    ActiveAutoChopTree = value
    Settings.ActiveAutoChopTree = value
end)

-- Bring Tab
local bringSettingsSection, bringSettingsContent = CreateSection(t["Bring"], "Настройки телепорта")

CreateTextBox(bringSettingsContent, "Макс число (1-200):", Settings.BringCount, function(value)
    if value >= 1 and value <= 200 then
        BringCount = math.floor(value)
        Settings.BringCount = BringCount
    end
end)

local bringDelaySlider = CreateSlider(bringSettingsContent, "Скорость телепорта вещей(МилиСек)", 600, 0, Settings.BringDelay, function(value)
    BringDelay = math.floor(value)
    Settings.BringDelay = BringDelay
end)

local teleportTargetSection, teleportTargetContent = CreateSection(t["Bring"], "Цель телепортации")
local teleportTargetDropdown = CreateDropdown(teleportTargetContent, {"Игрок", "Костёр"}, Settings.TeleportTarget, function(selected)
    TeleportTarget = selected
    Settings.TeleportTarget = selected
end)

local teleportSection, teleportContent = CreateSection(t["Bring"], "Телепорт")
CreateButton(teleportContent, "Телепорт к костру", function()
    local character = f.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = CFrame.new(CampfirePosition)
    end
end)

-- Bring Items Section
local bringItemsSection, bringItemsContent = CreateSection(t["Bring"], "Телепорт заправки")
local bringItemsDropdown = CreateDropdown(bringItemsContent, {"Дерево", "Уголь", "Канистра", "Топливная бочка"}, "Дерево")

CreateButton(bringItemsContent, "Телепорт выбранных", function()
    local selectedItem = bringItemsDropdown.GetValue()
    local targetPos = GetTargetPosition()
    
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
        
        local teleported = 0
        for i = 1, math.min(BringCount, #logs) do
            local log = logs[i]
            log.CFrame = CFrame.new(targetPos.X, targetPos.Y + 5, targetPos.Z) + Vector3.new(math.random(-5,5), 0, math.random(-5,5))
            log.Anchored = false
            log.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            teleported = teleported + 1
            
            if BringDelay > 0 then
                wait(BringDelay / 1000)
            end
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
            fuel.CFrame = CFrame.new(targetPos) + Vector3.new(math.random(-2,2), 0.5, math.random(-2,2))
            fuel.Anchored = false
            fuel.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            teleported = teleported + 1
            
            if BringDelay > 0 then
                wait(BringDelay / 1000)
            end
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
            barrel.CFrame = CFrame.new(targetPos) + Vector3.new(math.random(-2,2), 0.5, math.random(-2,2))
            barrel.Anchored = false
            barrel.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            teleported = teleported + 1
            
            if BringDelay > 0 then
                wait(BringDelay / 1000)
            end
        end
    end
end)

-- Применяем сохраненные настройки
if killAuraToggle and Settings.ActiveKillAura then
    killAuraToggle.Set(true)
end

if autoChopToggle and Settings.ActiveAutoChopTree then
    autoChopToggle.Set(true)
end

-- Обработчики кнопок закрытия/открытия
n.MouseButton1Click:Connect(function()
    l.Visible = false
    o.Visible = true
end)

o.MouseButton1Click:Connect(function()
    l.Visible = true
    o.Visible = false
end)

print("ASTRALCHEAT 99 Nights loaded successfully!")