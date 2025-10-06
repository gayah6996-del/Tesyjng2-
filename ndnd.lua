-- Создание основного GUI
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GameMenu"
ScreenGui.Parent = PlayerGui

-- Кнопка показа меню (всегда видна)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 60, 0, 60)
ToggleButton.Position = UDim2.new(0, 10, 0, 10)
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Text = "📱"
ToggleButton.TextSize = 20
ToggleButton.ZIndex = 10
ToggleButton.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 10)
ToggleCorner.Parent = ToggleButton

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

-- Заголовок для перемещения
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.Text = "Game Menu"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

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

local UICorner2 = Instance.new("UICorner")
UICorner2.CornerRadius = UDim.new(0, 6)
UICorner2.Parent = CloseButton

-- Кнопки вкладок
local TabsFrame = Instance.new("Frame")
TabsFrame.Size = UDim2.new(1, 0, 0, 30)
TabsFrame.Position = UDim2.new(0, 0, 0, 35)
TabsFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TabsFrame.BorderSizePixel = 0
TabsFrame.Parent = MainFrame

local InfoTabButton = Instance.new("TextButton")
InfoTabButton.Size = UDim2.new(0.25, 0, 1, 0)
InfoTabButton.Position = UDim2.new(0, 0, 0, 0)
InfoTabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
InfoTabButton.Text = "Info"
InfoTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
InfoTabButton.TextSize = 12
InfoTabButton.Font = Enum.Font.GothamBold
InfoTabButton.Parent = TabsFrame

local GameTabButton = Instance.new("TextButton")
GameTabButton.Size = UDim2.new(0.25, 0, 1, 0)
GameTabButton.Position = UDim2.new(0.25, 0, 0, 0)
GameTabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
GameTabButton.Text = "Game"
GameTabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
GameTabButton.TextSize = 12
GameTabButton.Font = Enum.Font.GothamBold
GameTabButton.Parent = TabsFrame

local ItemsTabButton = Instance.new("TextButton")
ItemsTabButton.Size = UDim2.new(0.25, 0, 1, 0)
ItemsTabButton.Position = UDim2.new(0.5, 0, 0, 0)
ItemsTabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ItemsTabButton.Text = "Items"
ItemsTabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
ItemsTabButton.TextSize = 12
ItemsTabButton.Font = Enum.Font.GothamBold
ItemsTabButton.Parent = TabsFrame

local TeleportTabButton = Instance.new("TextButton")
TeleportTabButton.Size = UDim2.new(0.25, 0, 1, 0)
TeleportTabButton.Position = UDim2.new(0.75, 0, 0, 0)
TeleportTabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TeleportTabButton.Text = "TP"
TeleportTabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
TeleportTabButton.TextSize = 12
TeleportTabButton.Font = Enum.Font.GothamBold
TeleportTabButton.Parent = TabsFrame

-- Content frames
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -10, 1, -75)
ContentFrame.Position = UDim2.new(0, 5, 0, 70)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Info Tab Content
local InfoTab = Instance.new("ScrollingFrame")
InfoTab.Size = UDim2.new(1, 0, 1, 0)
InfoTab.BackgroundTransparency = 1
InfoTab.BorderSizePixel = 0
InfoTab.ScrollBarThickness = 6
InfoTab.Visible = true
InfoTab.Parent = ContentFrame

local InfoListLayout = Instance.new("UIListLayout")
InfoListLayout.Padding = UDim.new(0, 8)
InfoListLayout.Parent = InfoTab

-- Game Tab Content
local GameTab = Instance.new("ScrollingFrame")
GameTab.Size = UDim2.new(1, 0, 1, 0)
GameTab.BackgroundTransparency = 1
GameTab.BorderSizePixel = 0
GameTab.ScrollBarThickness = 6
GameTab.Visible = false
GameTab.Parent = ContentFrame

local GameListLayout = Instance.new("UIListLayout")
GameListLayout.Padding = UDim.new(0, 8)
GameListLayout.Parent = GameTab

-- Items Tab Content
local ItemsTab = Instance.new("ScrollingFrame")
ItemsTab.Size = UDim2.new(1, 0, 1, 0)
ItemsTab.BackgroundTransparency = 1
ItemsTab.BorderSizePixel = 0
ItemsTab.ScrollBarThickness = 6
ItemsTab.Visible = false
ItemsTab.Parent = ContentFrame

local ItemsListLayout = Instance.new("UIListLayout")
ItemsListLayout.Padding = UDim.new(0, 8)
ItemsListLayout.Parent = ItemsTab

-- Teleport Tab Content
local TeleportTab = Instance.new("ScrollingFrame")
TeleportTab.Size = UDim2.new(1, 0, 1, 0)
TeleportTab.BackgroundTransparency = 1
TeleportTab.BorderSizePixel = 0
TeleportTab.ScrollBarThickness = 6
TeleportTab.Visible = false
TeleportTab.Parent = ContentFrame

local TeleportListLayout = Instance.new("UIListLayout")
TeleportListLayout.Padding = UDim.new(0, 8)
TeleportListLayout.Parent = TeleportTab

-- Переменные для функций
local ActiveKillAura = false
local ActiveAutoChopTree = false
local DistanceForKillAura = 25
local DistanceForAutoChopTree = 25

-- Функция DragItem из оригинального скрипта
local function DragItem(Item)
    task.spawn(function()
        for _, tool in pairs(game:GetService("Players").LocalPlayer.Inventory:GetChildren()) do
            if tool:isA("Model") and tool:GetAttribute("NumberItems") and tool:GetAttribute("Capacity") and tool:GetAttribute("NumberItems") < tool:GetAttribute("Capacity") then
                task.spawn(function()
                    local args = {
                        tool,
                        Item
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("RequestBagStoreItem"):InvokeServer(unpack(args))
                    wait(0.1)
                end)
            end
            wait(0.25)
        end
    end)
end

-- Функция создания элементов UI
local function CreateSection(parent, title)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, 0, 0, 0)
    section.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    section.BorderSizePixel = 0
    section.Parent = parent
    
    local sectionCorner = Instance.new("UICorner")
    sectionCorner.CornerRadius = UDim.new(0, 6)
    sectionCorner.Parent = section
    
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
    content.Parent = section
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 5)
    contentLayout.Parent = content
    
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
        sliderText.Text = text .. ": " .. math.floor(value * 10) / 10
        callback(value)
    end
    
    -- Обработка для мобильного устройства
    sliderButton.MouseButton1Down:Connect(function()
        isDragging = true
    end)
    
    sliderButton.MouseButton1Up:Connect(function()
        isDragging = false
    end)
    
    sliderButton.MouseLeave:Connect(function()
        isDragging = false
    end)
    
    local function onTouchInput(input)
        if isDragging and input.UserInputType == Enum.UserInputType.Touch then
            local relativeX = input.Position.X - sliderBar.AbsolutePosition.X
            local normalized = math.clamp(relativeX / sliderBar.AbsoluteSize.X, 0, 1)
            local value = min + normalized * (max - min)
            updateSlider(value)
        end
    end
    
    UserInputService.InputChanged:Connect(onTouchInput)
    
    updateSlider(defaultValue)
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
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = button
    
    button.MouseButton1Click:Connect(callback)
    
    return button
end

-- Создание элементов Info tab
local infoSection, infoContent = CreateSection(InfoTab, "📋 Script Information")
CreateLabel(infoContent, "99 Nights In The Forest\nMobile Script Menu\n\nVersion: 0.31\n\nFunctions from original Game tab\n\nTap the title bar to move the menu")

local controlsSection, controlsContent = CreateSection(InfoTab, "🎮 Controls")
CreateLabel(controlsContent, "- Tap 📱 button to show/hide menu\n- Drag title bar to move menu\n- Toggle switches to enable features\n- Adjust sliders for distance settings")

local noteSection, noteContent = CreateSection(InfoTab, "💡 Important Note")
CreateLabel(noteContent, "For Auto Chop Tree and Kill Aura to work, you MUST equip any axe (Old Axe, Good Axe, Strong Axe, or Chainsaw)!")

-- Создание элементов Game tab
local killAuraSection, killAuraContent = CreateSection(GameTab, "⚔️ Kill Aura")
CreateSlider(killAuraContent, "Distance", 25, 10000, 25, function(value)
    DistanceForKillAura = value
end)

local killAuraToggle = CreateToggle(killAuraContent, "Kill Aura", function(value)
    ActiveKillAura = value
end)

local autoChopSection, autoChopContent = CreateSection(GameTab, "🪓 Auto Chop Tree")
CreateSlider(autoChopContent, "Distance", 0, 1000, 25, function(value)
    DistanceForAutoChopTree = value
end)

local autoChopToggle = CreateToggle(autoChopContent, "Auto Chop Tree", function(value)
    ActiveAutoChopTree = value
end)

-- Создание элементов Items tab
local itemsSection, itemsContent = CreateSection(ItemsTab, "🎒 Item Teleporter")
CreateLabel(itemsContent, "Select items to teleport to your inventory")

-- Создание мини-меню для выбора предметов
local selectedItems = {}

local function CreateItemToggle(parent, itemName)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, 0, 0, 25)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = parent
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(1, 0, 1, 0)
    toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    toggleButton.Text = ""
    toggleButton.Parent = toggleFrame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 4)
    toggleCorner.Parent = toggleButton
    
    local toggleText = Instance.new("TextLabel")
    toggleText.Size = UDim2.new(0.8, 0, 1, 0)
    toggleText.Position = UDim2.new(0, 8, 0, 0)
    toggleText.BackgroundTransparency = 1
    toggleText.Text = itemName
    toggleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleText.TextSize = 12
    toggleText.TextXAlignment = Enum.TextXAlignment.Left
    toggleText.Font = Enum.Font.Gotham
    toggleText.Parent = toggleButton
    
    local toggleStatus = Instance.new("Frame")
    toggleStatus.Size = UDim2.new(0, 15, 0, 15)
    toggleStatus.Position = UDim2.new(1, -20, 0.5, -7.5)
    toggleStatus.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    toggleStatus.Parent = toggleButton
    
    local toggleStatusCorner = Instance.new("UICorner")
    toggleStatusCorner.CornerRadius = UDim.new(0, 7)
    toggleStatusCorner.Parent = toggleStatus
    
    local isToggled = false
    
    local function updateToggle()
        if isToggled then
            toggleStatus.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
            selectedItems[itemName] = true
        else
            toggleStatus.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            selectedItems[itemName] = nil
        end
    end
    
    toggleButton.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        updateToggle()
    end)
    
    updateToggle()
end

-- Список предметов для телепортации
local itemsList = {
    "Tyre", 
    "Sheet Metal", 
    "Broken Fan", 
    "Bolt", 
    "Old Radio", 
    "UFO Junk", 
    "UFO Scrap", 
    "Broken Microwave"
}

-- Создание тогглов для каждого предмета
for _, itemName in ipairs(itemsList) do
    CreateItemToggle(itemsContent, itemName)
end

-- Кнопка телепортации выбранных предметов
CreateButton(itemsContent, "🚀 Teleport Selected Items", function()
    for _, Obj in pairs(game.workspace.Items:GetChildren()) do
        if Obj:isA("Model") and Obj.PrimaryPart and selectedItems[Obj.Name] then
            DragItem(Obj)
            wait(0.05)
        end
    end
end)

-- Кнопка телепортации всех скрапов
CreateButton(itemsContent, "🔄 Teleport All Scraps", function()
    for _, Obj in pairs(game.workspace.Items:GetChildren()) do
        if (Obj.Name == "Tyre" or Obj.Name == "Sheet Metal" or Obj.Name == "Broken Fan" or Obj.Name == "Bolt" or Obj.Name == "Old Radio" or Obj.Name == "UFO Junk" or Obj.Name == "UFO Scrap" or Obj.Name == "Broken Microwave") and Obj:isA("Model") and Obj.PrimaryPart then 
            DragItem(Obj)
            wait(0.05)
        end
    end
end)

-- Создание элементов Teleport tab
local teleportSection, teleportContent = CreateSection(TeleportTab, "🧲 Teleport to Objects")
CreateLabel(teleportContent, "Teleport to different locations and objects in the game")

-- Список целей для телепортации
local teleportTargets = {
    "Campfire",
    "Workshop", 
    "Cave",
    "Lake",
    "Radio Tower",
    "Abandoned House",
    "Pelt Trader",
    "Lost Child",
    "Lost Child2", 
    "Lost Child3",
    "Lost Child4"
}

-- Настройки телепортации
local ignoreDistanceFrom = Vector3.new(0, 0, 0)
local minDistance = 10

-- Функция телепортации
local function TeleportToObject(itemName)
    local closest, shortest = nil, math.huge
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name == itemName and obj:IsA("Model") then
            local cf = nil
            if pcall(function() cf = obj:GetPivot() end) then
                -- success
            else
                local part = obj:FindFirstChildWhichIsA("BasePart")
                if part then cf = part.CFrame end
            end
            if cf then
                local dist = (cf.Position - ignoreDistanceFrom).Magnitude
                if dist >= minDistance and dist < shortest then
                    closest = obj
                    shortest = dist
                end
            end
        end
    end
    if closest then
        local cf = nil
        if pcall(function() cf = closest:GetPivot() end) then
            -- success
        else
            local part = closest:FindFirstChildWhichIsA("BasePart")
            if part then cf = part.CFrame end
        end
        if cf then
            game.Players.LocalPlayer.Character:PivotTo(cf + Vector3.new(0, 5, 0))
            print("Teleported to " .. itemName)
        else
            print("Teleport Failed: Could not find a valid position to teleport.")
        end
    else
        print("Item Not Found: " .. itemName .. " not found or too close to origin.")
    end
end

-- Создание кнопок телепортации для каждой цели
for _, itemName in ipairs(teleportTargets) do
    CreateButton(teleportContent, "📍 " .. itemName, function()
        TeleportToObject(itemName)
    end)
end

-- Функции из оригинального скрипта
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

-- Обновление размеров секций после добавления контента
game:GetService("RunService").Heartbeat:Connect(function()
    for _, tab in pairs({InfoTab, GameTab, ItemsTab, TeleportTab}) do
        for _, section in pairs(tab:GetChildren()) do
            if section:IsA("Frame") and section:FindFirstChildWhichIsA("Frame") then
                local content = section:FindFirstChildWhichIsA("Frame")
                if content and content:FindFirstChildOfClass("UIListLayout") then
                    section.Size = UDim2.new(1, 0, 0, 25 + content.UIListLayout.AbsoluteContentSize.Y)
                end
            end
        end
        
        tab.CanvasSize = UDim2.new(0, 0, 0, tab.UIListLayout.AbsoluteContentSize.Y + 10)
    end
end)

-- Функционал переключения вкладок
local function switchToTab(tabName)
    InfoTabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    GameTabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    ItemsTabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TeleportTabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    
    InfoTabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    GameTabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    ItemsTabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    TeleportTabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    
    InfoTab.Visible = false
    GameTab.Visible = false
    ItemsTab.Visible = false
    TeleportTab.Visible = false
    
    if tabName == "Info" then
        InfoTabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        InfoTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        InfoTab.Visible = true
    elseif tabName == "Game" then
        GameTabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        GameTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        GameTab.Visible = true
    elseif tabName == "Items" then
        ItemsTabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        ItemsTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        ItemsTab.Visible = true
    elseif tabName == "Teleport" then
        TeleportTabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        TeleportTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TeleportTab.Visible = true
    end
end

InfoTabButton.MouseButton1Click:Connect(function()
    switchToTab("Info")
end)

GameTabButton.MouseButton1Click:Connect(function()
    switchToTab("Game")
end)

ItemsTabButton.MouseButton1Click:Connect(function()
    switchToTab("Items")
end)

TeleportTabButton.MouseButton1Click:Connect(function()
    switchToTab("Teleport")
end)

-- Система перемещения меню для мобильных устройств
local dragging = false
local dragStartPos = nil
local menuStartPos = nil

local function startDragging(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStartPos = Vector2.new(input.Position.X, input.Position.Y)
        menuStartPos = UDim2.new(MainFrame.Position.X.Scale, MainFrame.Position.X.Offset, MainFrame.Position.Y.Scale, MainFrame.Position.Y.Offset)
    end
end

local function stopDragging()
    dragging = false
    dragStartPos = nil
    menuStartPos = nil
end

local function updateDrag(input)
    if dragging and dragStartPos and menuStartPos then
        local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStartPos
        local newX = menuStartPos.X.Offset + delta.X
        local newY = menuStartPos.Y.Offset + delta.Y
        
        -- Ограничение, чтобы меню не выходило за экран
        local screenSize = PlayerGui.AbsoluteSize
        newX = math.clamp(newX, 0, screenSize.X - MainFrame.AbsoluteSize.X)
        newY = math.clamp(newY, 0, screenSize.Y - MainFrame.AbsoluteSize.Y)
        
        MainFrame.Position = UDim2.new(0, newX, 0, newY)
    end
end

-- Обработчики для перемещения
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

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        updateDrag(input)
    end
end)

-- Закрытие меню
CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- Переключение видимости меню
ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- По умолчанию открываем вкладку Info
switchToTab("Info")

print("Mobile Game menu with Teleport tab loaded! Tap the button to open/close. Drag the title to move.")