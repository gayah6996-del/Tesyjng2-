local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Название файла для сохранения настроек
local SETTINGS_FILE = "astralcheat_settings.txt"

-- Таблица для хранения текущих настроек
local Settings = {
    ActiveKillAura = false,
    ActiveAutoChopTree = false,
    DistanceForKillAura = 25,
    DistanceForAutoChopTree = 25,
    BringCount = 2,
    BringDelay = 600,
    TeleportTarget = "Костёр"
}

-- Функция для сохранения настроек в файл
local function SaveSettings()
    local success, err = pcall(function()
        local data = game:GetService("HttpService"):JSONEncode(Settings)
        writefile(SETTINGS_FILE, data)
    end)
    
    if not success then
        warn("Не удалось сохранить настройки: " .. tostring(err))
    else
        print("Настройки сохранены!")
    end
end

-- Функция для загрузки настроек из файла
local function LoadSettings()
    local success, err = pcall(function()
        if isfile(SETTINGS_FILE) then
            local data = readfile(SETTINGS_FILE)
            local loadedSettings = game:GetService("HttpService"):JSONDecode(data)
            
            -- Обновляем настройки из загруженных данных
            for key, value in pairs(loadedSettings) do
                if Settings[key] ~= nil then
                    Settings[key] = value
                end
            end
            return true
        end
        return false
    end)
    
    if not success then
        warn("Не удалось загрузить настройки: " .. tostring(err))
        return false
    end
    return true
end

-- Загружаем настройки при запуске
LoadSettings()

-- Создаем окно Rayfield
local Window = Rayfield:CreateWindow({
    Name = "ASTRALCHEAT BETA",
    LoadingTitle = "ASTRALCHEAT BETA",
    LoadingSubtitle = "by SCRIPTTYTA",
    ConfigurationSaving = {
        Enabled = false,
    },
    Discord = {
        Enabled = false,
    },
    KeySystem = false,
})

-- Создаем вкладки
local MainTab = Window:CreateTab("Main", 4483362458)
local BringTab = Window:CreateTab("Bring", 4483362458)
local InfoTab = Window:CreateTab("Info", 4483362458)

-- Переменные для функций
local ActiveKillAura = Settings.ActiveKillAura
local ActiveAutoChopTree = Settings.ActiveAutoChopTree
local DistanceForKillAura = Settings.DistanceForKillAura
local DistanceForAutoChopTree = Settings.DistanceForAutoChopTree
local BringCount = Settings.BringCount
local BringDelay = Settings.BringDelay
local TeleportTarget = Settings.TeleportTarget

-- Координаты костра
local CampfirePosition = Vector3.new(0, 10, 0)

-- Функция для показа уведомлений
local function ShowNotification(message, duration)
    Rayfield:Notify({
        Title = "ASTRALCHEAT",
        Content = message,
        Duration = duration or 3,
        Image = 4483362458,
    })
end

-- Функция для получения целевой позиции телепортации
local function GetTargetPosition()
    local Players = game:GetService("Players")
    local Player = Players.LocalPlayer
    
    if TeleportTarget == "Игрок" then
        local character = Player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            return character.HumanoidRootPart.Position
        else
            ShowNotification("Персонаж не найден! Использую позицию костра.", 2)
            return CampfirePosition
        end
    else
        return CampfirePosition
    end
end

-- Вкладка Main
local CombatSection = MainTab:CreateSection("Combat")
local KillAuraToggle = MainTab:CreateToggle({
    Name = "Kill Aura",
    CurrentValue = Settings.ActiveKillAura,
    Flag = "KillAuraToggle",
    Callback = function(value)
        ActiveKillAura = value
        Settings.ActiveKillAura = value
        SaveSettings()
        ShowNotification("Kill Aura: " .. (value and "ON" or "OFF"), 2)
    end,
})

local KillAuraSlider = MainTab:CreateSlider({
    Name = "Kill Aura Distance",
    Range = {25, 300},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = Settings.DistanceForKillAura,
    Flag = "KillAuraDistance",
    Callback = function(value)
        DistanceForKillAura = value
        Settings.DistanceForKillAura = value
        SaveSettings()
    end,
})

local FarmingSection = MainTab:CreateSection("Farming")
local AutoChopToggle = MainTab:CreateToggle({
    Name = "Auto Tree Chop",
    CurrentValue = Settings.ActiveAutoChopTree,
    Flag = "AutoChopToggle",
    Callback = function(value)
        ActiveAutoChopTree = value
        Settings.ActiveAutoChopTree = value
        SaveSettings()
        ShowNotification("Auto Tree Chop: " .. (value and "ON" or "OFF"), 2)
    end,
})

local AutoChopSlider = MainTab:CreateSlider({
    Name = "Auto Chop Distance",
    Range = {0, 200},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = Settings.DistanceForAutoChopTree,
    Flag = "AutoChopDistance",
    Callback = function(value)
        DistanceForAutoChopTree = value
        Settings.DistanceForAutoChopTree = value
        SaveSettings()
    end,
})

local TeleportSection = MainTab:CreateSection("Teleport")
MainTab:CreateButton({
    Name = "Teleport to Campfire",
    Callback = function()
        local Players = game:GetService("Players")
        local Player = Players.LocalPlayer
        local character = Player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = CFrame.new(CampfirePosition)
            ShowNotification("Телепортирован к костру!", 2)
        else
            ShowNotification("Персонаж не найден!", 2)
        end
    end,
})

-- Вкладка Bring
local BringSettingsSection = BringTab:CreateSection("Настройки телепорта")

local BringCountInput = BringTab:CreateInput({
    Name = "Макс число предметов (1-200)",
    PlaceholderText = tostring(Settings.BringCount),
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local value = tonumber(Text)
        if value and value >= 1 and value <= 200 then
            BringCount = math.floor(value)
            Settings.BringCount = BringCount
            SaveSettings()
            ShowNotification("Количество предметов установлено: " .. BringCount, 2)
        else
            ShowNotification("Число должно быть от 1 до 200!", 2)
        end
    end,
})

local BringDelaySlider = BringTab:CreateSlider({
    Name = "Скорость телепорта (мс)",
    Range = {0, 1000},
    Increment = 10,
    Suffix = "мс",
    CurrentValue = Settings.BringDelay,
    Flag = "BringDelay",
    Callback = function(value)
        BringDelay = math.floor(value)
        Settings.BringDelay = BringDelay
        SaveSettings()
    end,
})

local TeleportTargetSection = BringTab:CreateSection("Цель телепортации")
local TeleportTargetDropdown = BringTab:CreateDropdown({
    Name = "Цель телепортации",
    Options = {"Игрок", "Костёр"},
    CurrentOption = Settings.TeleportTarget,
    Flag = "TeleportTarget",
    Callback = function(option)
        TeleportTarget = option
        Settings.TeleportTarget = option
        SaveSettings()
        ShowNotification("Цель телепортации: " .. option, 2)
    end,
})

local ChildTeleportSection = BringTab:CreateSection("Телепорт к детям")
local ChildDropdown = BringTab:CreateDropdown({
    Name = "Выберите ребенка",
    Options = {"Дино Малыш", "Кракен малыш", "Ребенчик", "Малыш Коала"},
    CurrentOption = "Дино Малыш",
    Flag = "ChildSelect",
    Callback = function(option) end,
})

BringTab:CreateButton({
    Name = "Телепорт к выбранному ребенку",
    Callback = function()
        local Players = game:GetService("Players")
        local Player = Players.LocalPlayer
        local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
        if not root then 
            ShowNotification("Персонаж не найден!", 2)
            return 
        end
        
        local selectedChild = ChildDropdown.CurrentOption
        local childName = ""
        
        if selectedChild == "Дино Малыш" then
            childName = "lost child"
        elseif selectedChild == "Кракен малыш" then
            childName = "lost child2"
        elseif selectedChild == "Ребенчик" then
            childName = "lost child3"
        elseif selectedChild == "Малыш Коала" then
            childName = "lost child4"
        end
        
        local found = false
        for _, item in pairs(workspace.Characters:GetChildren()) do
            if item:IsA("Model") and item.PrimaryPart then
                if string.lower(item.Name):find(childName) then
                    root.CFrame = item.PrimaryPart.CFrame + Vector3.new(0, 3, 0)
                    ShowNotification("Телепортирован к " .. selectedChild, 2)
                    found = true
                    break
                end
            end
        end
        
        if not found then
            ShowNotification(selectedChild .. " не найден на карте", 2)
        end
    end,
})

local BringItemsSection = BringTab:CreateSection("Телепорт предметов")
local BringItemsDropdown = BringTab:CreateDropdown({
    Name = "Выберите предмет",
    Options = {"Дерево", "Уголь", "Канистра", "Топливная бочка"},
    CurrentOption = "Дерево",
    Flag = "BringItems",
    Callback = function(option) end,
})

BringTab:CreateButton({
    Name = "Телепорт выбранных предметов",
    Callback = function()
        local selectedItem = BringItemsDropdown.CurrentOption
        local targetPos = GetTargetPosition()
        
        local items = {}
        
        if selectedItem == "Дерево" then
            for _, item in pairs(workspace.Items:GetChildren()) do
                if item:IsA("Model") then
                    local itemName = string.lower(item.Name)
                    if itemName:find("log") then
                        local main = item:FindFirstChildWhichIsA("BasePart")
                        if main then
                            table.insert(items, main)
                        end
                    end
                end
            end
        elseif selectedItem == "Уголь" then
            for _, item in pairs(workspace.Items:GetChildren()) do
                if item:IsA("Model") then
                    local itemName = string.lower(item.Name)
                    if itemName:find("coal") then
                        local main = item:FindFirstChildWhichIsA("BasePart")
                        if main then
                            table.insert(items, main)
                        end
                    end
                end
            end
        elseif selectedItem == "Канистра" then
            for _, item in pairs(workspace.Items:GetChildren()) do
                if item:IsA("Model") then
                    local itemName = string.lower(item.Name)
                    if itemName:find("fuel") and itemName:find("canister") then
                        local main = item:FindFirstChildWhichIsA("BasePart")
                        if main then
                            table.insert(items, main)
                        end
                    end
                end
            end
        elseif selectedItem == "Топливная бочка" then
            for _, item in pairs(workspace.Items:GetChildren()) do
                if item:IsA("Model") then
                    local itemName = string.lower(item.Name)
                    if itemName:find("oil") and itemName:find("barrel") then
                        local main = item:FindFirstChildWhichIsA("BasePart")
                        if main then
                            table.insert(items, main)
                        end
                    end
                end
            end
        end
        
        if #items == 0 then
            ShowNotification("Предметы '" .. selectedItem .. "' не найдены!", 2)
            return
        end
        
        local teleported = 0
        for i = 1, math.min(BringCount, #items) do
            local item = items[i]
            if item and item.Parent then
                item.CFrame = CFrame.new(
                    targetPos.X + math.random(-3, 3), 
                    targetPos.Y + 3, 
                    targetPos.Z + math.random(-3, 3)
                )
                item.Anchored = false
                if item:FindFirstChild("AssemblyLinearVelocity") then
                    item.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                end
                teleported = teleported + 1
                
                if BringDelay > 0 then
                    wait(BringDelay / 1000)
                end
            end
        end
        
        ShowNotification("Принесено " .. teleported .. " " .. selectedItem .. " к " .. TeleportTarget, 2)
    end,
})

local ScrapSection = BringTab:CreateSection("Телепорт скрапа")
local ScrapDropdown = BringTab:CreateDropdown({
    Name = "Выберите скрап",
    Options = {"All", "sheet metal", "broken fan", "bolt", "old radio", "ufo junk", "ufo scrap", "broken microwave"},
    CurrentOption = "All",
    Flag = "ScrapSelect",
    Callback = function(option) end,
})

BringTab:CreateButton({
    Name = "Телепорт выбранного скрапа",
    Callback = function()
        local targetPos = GetTargetPosition()
        local selectedScrap = ScrapDropdown.CurrentOption
        
        local scraps = {}
        
        for _, item in pairs(workspace.Items:GetChildren()) do
            if item:IsA("Model") then
                local itemName = string.lower(item.Name)
                
                if selectedScrap == "All" then
                    if itemName:find("sheet metal") or itemName:find("broken fan") or itemName:find("bolt") or 
                       itemName:find("old radio") or itemName:find("ufo junk") or itemName:find("ufo scrap") or 
                       itemName:find("broken microwave") then
                        local main = item:FindFirstChildWhichIsA("BasePart")
                        if main then
                            table.insert(scraps, main)
                        end
                    end
                else
                    if itemName:find(selectedScrap) then
                        local main = item:FindFirstChildWhichIsA("BasePart")
                        if main then
                            table.insert(scraps, main)
                        end
                    end
                end
            end
        end
        
        if #scraps == 0 then
            ShowNotification("Скрап '" .. selectedScrap .. "' не найден!", 2)
            return
        end
        
        local teleported = 0
        for i = 1, math.min(BringCount, #scraps) do
            local scrap = scraps[i]
            if scrap and scrap.Parent then
                scrap.CFrame = CFrame.new(
                    targetPos.X + math.random(-3, 3), 
                    targetPos.Y + 3, 
                    targetPos.Z + math.random(-3, 3)
                )
                scrap.Anchored = false
                if scrap:FindFirstChild("AssemblyLinearVelocity") then
                    scrap.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                end
                teleported = teleported + 1
                
                if BringDelay > 0 then
                    wait(BringDelay / 1000)
                end
            end
        end
        
        ShowNotification("Принесено " .. teleported .. " " .. selectedScrap, 2)
    end,
})

local FoodSection = BringTab:CreateSection("Телепорт еды")
local FoodDropdown = BringTab:CreateDropdown({
    Name = "Выберите еду",
    Options = {"All", "Морсель", "Морковь", "Бандаж", "Аптечка"},
    CurrentOption = "All",
    Flag = "FoodSelect",
    Callback = function(option) end,
})

BringTab:CreateButton({
    Name = "Телепорт выбранной еды",
    Callback = function()
        local targetPos = GetTargetPosition()
        local selectedFood = FoodDropdown.CurrentOption
        
        local foods = {}
        
        for _, item in pairs(workspace.Items:GetChildren()) do
            if item:IsA("Model") then
                local itemName = string.lower(item.Name)
                
                if selectedFood == "All" then
                    if itemName:find("morsel") or itemName:find("carrot") or itemName:find("bandage") or itemName:find("medkit") then
                        local main = item:FindFirstChildWhichIsA("BasePart")
                        if main then
                            table.insert(foods, main)
                        end
                    end
                else
                    local searchTerm = ""
                    if selectedFood == "Морсель" then searchTerm = "morsel"
                    elseif selectedFood == "Морковь" then searchTerm = "carrot"
                    elseif selectedFood == "Бандаж" then searchTerm = "bandage"
                    elseif selectedFood == "Аптечка" then searchTerm = "medkit" end
                    
                    if itemName:find(searchTerm) then
                        local main = item:FindFirstChildWhichIsA("BasePart")
                        if main then
                            table.insert(foods, main)
                        end
                    end
                end
            end
        end
        
        if #foods == 0 then
            ShowNotification("Еда '" .. selectedFood .. "' не найдена!", 2)
            return
        end
        
        local teleported = 0
        for i = 1, math.min(BringCount, #foods) do
            local food = foods[i]
            if food and food.Parent then
                food.CFrame = CFrame.new(
                    targetPos.X + math.random(-3, 3), 
                    targetPos.Y + 3, 
                    targetPos.Z + math.random(-3, 3)
                )
                food.Anchored = false
                if food:FindFirstChild("AssemblyLinearVelocity") then
                    food.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                end
                teleported = teleported + 1
                
                if BringDelay > 0 then
                    wait(BringDelay / 1000)
                end
            end
        end
        
        ShowNotification("Принесено " .. teleported .. " " .. selectedFood, 2)
    end,
})

local WeaponSection = BringTab:CreateSection("Телепорт оружия")
local WeaponDropdown = BringTab:CreateDropdown({
    Name = "Выберите оружие/патроны",
    Options = {"Rifle ammo", "Rifle"},
    CurrentOption = "Rifle ammo",
    Flag = "WeaponSelect",
    Callback = function(option) end,
})

BringTab:CreateButton({
    Name = "Телепорт выбранного оружия",
    Callback = function()
        local targetPos = GetTargetPosition()
        local selectedWeapon = WeaponDropdown.CurrentOption
        
        local weapons = {}
        
        for _, item in pairs(workspace.Items:GetChildren()) do
            if item:IsA("Model") then
                local itemName = string.lower(item.Name)
                
                if selectedWeapon == "Rifle ammo" then
                    if itemName:find("rifle") and itemName:find("ammo") then
                        local main = item:FindFirstChildWhichIsA("BasePart")
                        if main then
                            table.insert(weapons, main)
                        end
                    end
                elseif selectedWeapon == "Rifle" then
                    if itemName:find("rifle") and not itemName:find("ammo") then
                        local main = item:FindFirstChildWhichIsA("BasePart")
                        if main then
                            table.insert(weapons, main)
                        end
                    end
                end
            end
        end
        
        if #weapons == 0 then
            ShowNotification("Оружие '" .. selectedWeapon .. "' не найдено!", 2)
            return
        end
        
        local teleported = 0
        for i = 1, math.min(BringCount, #weapons) do
            local weapon = weapons[i]
            if weapon and weapon.Parent then
                weapon.CFrame = CFrame.new(
                    targetPos.X + math.random(-3, 3), 
                    targetPos.Y + 3, 
                    targetPos.Z + math.random(-3, 3)
                )
                weapon.Anchored = false
                if weapon:FindFirstChild("AssemblyLinearVelocity") then
                    weapon.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                end
                teleported = teleported + 1
                
                if BringDelay > 0 then
                    wait(BringDelay / 1000)
                end
            end
        end
        
        ShowNotification("Принесено " .. teleported .. " " .. selectedWeapon, 2)
    end,
})

-- Вкладка Info
InfoTab:CreateSection("Информация о скрипте")
InfoTab:CreateParagraph({
    Title = "ASTRALCHEAT BETA",
    Content = "99 Nights in the forest\n\nВерсия: Beta\n\nTelegram Канал: SCRIPTTYTA\n\nTelegram Владелец: @SFXCL"
})

-- Функции из оригинального скрипта
task.spawn(function()
    while true do
        if ActiveKillAura then 
            local Players = game:GetService("Players")
            local player = Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local hrp = character:WaitForChild("HumanoidRootPart")
            local weapon = (player.Inventory:FindFirstChild("Old Axe") or player.Inventory:FindFirstChild("Good Axe") or player.Inventory:FindFirstChild("Strong Axe") or player.Inventory:FindFirstChild("Chainsaw"))

            for _, bunny in pairs(workspace.Characters:GetChildren()) do
                if bunny:IsA("Model") and bunny.PrimaryPart then
                    local distance = (bunny.PrimaryPart.Position - hrp.Position).Magnitude
                    if distance <= DistanceForKillAura then
                        task.spawn(function()	
                            game:GetService("ReplicatedStorage").RemoteEvents.ToolDamageObject:InvokeServer(bunny, weapon, 999, hrp.CFrame)
                        end)	
                    end
                end
            end
        end
        wait(0.01)
    end
end)

task.spawn(function()
    while true do
        if ActiveAutoChopTree then 
            local Players = game:GetService("Players")
            local player = Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local hrp = character:WaitForChild("HumanoidRootPart")
            local weapon = (player.Inventory:FindFirstChild("Old Axe") or player.Inventory:FindFirstChild("Good Axe") or player.Inventory:FindFirstChild("Strong Axe") or player.Inventory:FindFirstChild("Chainsaw"))
            
            for _, bunny in pairs(workspace.Map.Foliage:GetChildren()) do
                if bunny:IsA("Model") and (bunny.Name == "Small Tree" or bunny.Name == "TreeBig1" or bunny.Name == "TreeBig2") and bunny.PrimaryPart then
                    local distance = (bunny.PrimaryPart.Position - hrp.Position).Magnitude
                    if distance <= DistanceForAutoChopTree then
                        task.spawn(function()		
                            game:GetService("ReplicatedStorage").RemoteEvents.ToolDamageObject:InvokeServer(bunny, weapon, 999, hrp.CFrame)
                        end)		
                    end
                end
            end 
            
            for _, bunny in pairs(workspace.Map.Landmarks:GetChildren()) do
                if bunny:IsA("Model") and (bunny.Name == "Small Tree" or bunny.Name == "TreeBig1" or bunny.Name == "TreeBig2") and bunny.PrimaryPart then
                    local distance = (bunny.PrimaryPart.Position - hrp.Position).Magnitude
                    if distance <= DistanceForAutoChopTree then
                        task.spawn(function()	
                            game:GetService("ReplicatedStorage").RemoteEvents.ToolDamageObject:InvokeServer(bunny, weapon, 999, hrp.CFrame)
                        end)			
                    end
                end
            end
        end
        wait(0.01)
    end
end)

-- Загружаем Rayfield
Rayfield:LoadConfiguration()

-- Создаем кнопку для мобильных устройств
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MobileMenuButton"
ScreenGui.Parent = PlayerGui

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 60, 0, 60)
ToggleButton.Position = UDim2.new(0, 10, 0, 10)
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Text = "Show Menu"
ToggleButton.TextSize = 12
ToggleButton.ZIndex = 10
ToggleButton.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 10)
ToggleCorner.Parent = ToggleButton

ToggleButton.MouseButton1Click:Connect(function()
    Rayfield:Toggle()
end)

ShowNotification("ASTRALCHEAT загружен! Нажмите кнопку 'Show Menu'", 5)
print("ASTRALCHEAT с Rayfield загружен успешно!")