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
        Enabled = false, -- Мы используем свою систему сохранения
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
    if TeleportTarget == "Игрок" then
        local Players = game:GetService("Players")
        local Player = Players.LocalPlayer
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
            ShowNotification("Teleported to campfire!", 2)
        else
            ShowNotification("Character not found!", 2)
        end
    end,
})

-- Вкладка Bring
local BringSettingsSection = BringTab:CreateSection("Bring Settings")

local BringCountInput = BringTab:CreateInput({
    Name = "Bring Count (1-200)",
    PlaceholderText = tostring(Settings.BringCount),
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local value = tonumber(Text)
        if value and value >= 1 and value <= 200 then
            BringCount = math.floor(value)
            Settings.BringCount = BringCount
            SaveSettings()
            ShowNotification("Bring Count set to: " .. BringCount, 2)
        else
            ShowNotification("Bring Count must be between 1 and 200!", 2)
        end
    end,
})

local BringDelaySlider = BringTab:CreateSlider({
    Name = "Bring Speed (ms)",
    Range = {0, 600},
    Increment = 10,
    Suffix = "ms",
    CurrentValue = Settings.BringDelay,
    Flag = "BringDelay",
    Callback = function(value)
        BringDelay = math.floor(value)
        Settings.BringDelay = BringDelay
        SaveSettings()
    end,
})

local TeleportTargetSection = BringTab:CreateSection("Teleport Target")
local TeleportTargetDropdown = BringTab:CreateDropdown({
    Name = "Teleport Target",
    Options = {"Игрок", "Костёр"},
    CurrentOption = Settings.TeleportTarget,
    Flag = "TeleportTarget",
    Callback = function(option)
        TeleportTarget = option
        Settings.TeleportTarget = option
        SaveSettings()
        ShowNotification("Teleport target: " .. option, 2)
    end,
})

local ChildTeleportSection = BringTab:CreateSection("Teleport to Children")
local ChildDropdown = BringTab:CreateDropdown({
    Name = "Select Child",
    Options = {"Дино Малыш", "Кракен малыш", "Ребенчик", "Малыш Коала"},
    CurrentOption = "Дино Малыш",
    Flag = "ChildSelect",
    Callback = function(option)
        -- Callback for child selection
    end,
})

BringTab:CreateButton({
    Name = "Teleport to Selected Child",
    Callback = function()
        local Players = game:GetService("Players")
        local Player = Players.LocalPlayer
        local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
        if not root then 
            ShowNotification("Character not found!", 2)
            return 
        end
        
        local selectedChild = ChildDropdown.CurrentOption
        local childName = ""
        
        -- Определяем имя ребенка в зависимости от выбора
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
            if item.Name:lower():find(childName) and item:IsA("Model") then
                local main = item:FindFirstChildWhichIsA("BasePart")
                if main then
                    root.CFrame = main.CFrame + Vector3.new(0, 2, 0)
                    ShowNotification("Teleported to " .. selectedChild, 2)
                    found = true
                    break
                end
            end
        end
        
        if not found then
            ShowNotification(selectedChild .. " not found on map", 2)
        end
    end,
})

local BringItemsSection = BringTab:CreateSection("Bring Items")
local BringItemsDropdown = BringTab:CreateDropdown({
    Name = "Select Item",
    Options = {"Дерево", "Уголь", "Канистра", "Топливная бочка"},
    CurrentOption = "Дерево",
    Flag = "BringItems",
    Callback = function(option)
        -- Callback for item selection
    end,
})

BringTab:CreateButton({
    Name = "Bring Selected Items",
    Callback = function()
        local selectedItem = BringItemsDropdown.CurrentOption
        local targetPos = GetTargetPosition()
        local found = false
        
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
            
            if teleported > 0 then
                ShowNotification("Brought " .. teleported .. "/" .. #logs .. " Logs to " .. TeleportTarget .. "!", 2)
            else
                ShowNotification("No Logs found on map", 2)
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
            
            if teleported > 0 then
                ShowNotification("Brought " .. teleported .. "/" .. #coals .. " Coal to " .. TeleportTarget .. "!", 2)
            else
                ShowNotification("No Coal found on map", 2)
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
            
            if teleported > 0 then
                ShowNotification("Brought " .. teleported .. "/" .. #fuels .. " Fuel Canister to " .. TeleportTarget .. "!", 2)
            else
                ShowNotification("No Fuel Canister found on map", 2)
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
            
            if teleported > 0 then
                ShowNotification("Brought " .. teleported .. "/" .. #barrels .. " Oil Barrel to " .. TeleportTarget .. "!", 2)
            else
                ShowNotification("No Oil Barrel found on map", 2)
            end
        end
    end,
})

local ScrapSection = BringTab:CreateSection("Bring Scrap")
local ScrapDropdown = BringTab:CreateDropdown({
    Name = "Select Scrap",
    Options = {"All", "sheet metal", "broken fan", "bolt", "old radio", "ufo junk", "ufo scrap", "broken microwave"},
    CurrentOption = "All",
    Flag = "ScrapSelect",
    Callback = function(option)
        -- Callback for scrap selection
    end,
})

BringTab:CreateButton({
    Name = "Bring Selected Scrap",
    Callback = function()
        local targetPos = GetTargetPosition()
        local selectedScrap = ScrapDropdown.CurrentOption
        local scrapNames = {
            ["sheet metal"] = true, 
            ["broken fan"] = true, 
            ["bolt"] = true, 
            ["old radio"] = true, 
            ["ufo junk"] = true, 
            ["ufo scrap"] = true, 
            ["broken microwave"] = true,
        }
        
        local scraps = {}
        
        for _, item in pairs(workspace.Items:GetChildren()) do
            if item:IsA("Model") then
                local itemName = item.Name:lower()
                
                if selectedScrap == "All" then
                    for scrapName, _ in pairs(scrapNames) do
                        if itemName:find(scrapName) then
                            local main = item:FindFirstChildWhichIsA("BasePart")
                            if main then
                                table.insert(scraps, main)
                            end
                            break
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
        
        local teleported = 0
        for i = 1, math.min(BringCount, #scraps) do
            local scrap = scraps[i]
            scrap.CFrame = CFrame.new(targetPos.X, targetPos.Y + 5, targetPos.Z) + Vector3.new(math.random(-5,5), 0, math.random(-5,5))
            scrap.Anchored = false
            scrap.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            teleported = teleported + 1
            
            if BringDelay > 0 then
                wait(BringDelay / 1000)
            end
        end
        
        if teleported > 0 then
            ShowNotification("Teleported " .. teleported .. "/" .. #scraps .. " " .. selectedScrap .. " to " .. TeleportTarget, 2)
        else
            ShowNotification("No " .. selectedScrap .. " found on map", 2)
        end
    end,
})

local FoodSection = BringTab:CreateSection("Bring Food")
local FoodDropdown = BringTab:CreateDropdown({
    Name = "Select Food",
    Options = {"All", "Морсель", "Морковь", "Бандаж", "Аптечка"},
    CurrentOption = "All",
    Flag = "FoodSelect",
    Callback = function(option)
        -- Callback for food selection
    end,
})

BringTab:CreateButton({
    Name = "Bring Selected Food",
    Callback = function()
        local targetPos = GetTargetPosition()
        local selectedFood = FoodDropdown.CurrentOption
        local FoodNames = {
            ["morsel"] = "Morsel", 
            ["carrot"] = "Carrot", 
            ["bandage"] = "Bandage", 
            ["medkit"] = "Medkit", 
        }
        
        local foods = {}
        
        for _, item in pairs(workspace.Items:GetChildren()) do
            if item:IsA("Model") then
                local itemName = item.Name:lower()
                
                if selectedFood == "All" then
                    for foodKey, foodValue in pairs(FoodNames) do
                        if itemName:find(foodKey) then
                            local main = item:FindFirstChildWhichIsA("BasePart")
                            if main then
                                table.insert(foods, main)
                            end
                            break
                        end
                    end
                else
                    local searchTerm = selectedFood:lower()
                    if itemName:find(searchTerm) then
                        local main = item:FindFirstChildWhichIsA("BasePart")
                        if main then
                            table.insert(foods, main)
                        end
                    end
                end
            end
        end
        
        local teleported = 0
        for i = 1, math.min(BringCount, #foods) do
            local food = foods[i]
            food.CFrame = CFrame.new(targetPos.X, targetPos.Y + 5, targetPos.Z) + Vector3.new(math.random(-5,5), 0, math.random(-5,5))
            food.Anchored = false
            food.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            teleported = teleported + 1
            
            if BringDelay > 0 then
                wait(BringDelay / 1000)
            end
        end
        
        if teleported > 0 then
            ShowNotification("Teleported " .. teleported .. "/" .. #foods .. " " .. selectedFood .. " to " .. TeleportTarget, 2)
        else
            ShowNotification("No " .. selectedFood .. " found on map", 2)
        end
    end,
})

local WeaponSection = BringTab:CreateSection("Bring Weapons & Ammo")
local WeaponDropdown = BringTab:CreateDropdown({
    Name = "Select Weapon/Ammo",
    Options = {"Rifle ammo", "Rifle"},
    CurrentOption = "Rifle ammo",
    Flag = "WeaponSelect",
    Callback = function(option)
        -- Callback for weapon selection
    end,
})

BringTab:CreateButton({
    Name = "Bring Selected Weapons/Ammo",
    Callback = function()
        local targetPos = GetTargetPosition()
        local selectedWeapon = WeaponDropdown.CurrentOption
        local weaponNames = {
            ["rifle ammo"] = "Rifle ammo", 
            ["rifle"] = "Rifle", 
        }
        
        local weapons = {}
        
        for _, item in pairs(workspace.Items:GetChildren()) do
            if item:IsA("Model") then
                local itemName = item.Name:lower()
                
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
        
        local teleported = 0
        for i = 1, math.min(BringCount, #weapons) do
            local weapon = weapons[i]
            weapon.CFrame = CFrame.new(targetPos.X, targetPos.Y + 5, targetPos.Z) + Vector3.new(math.random(-5,5), 0, math.random(-5,5))
            weapon.Anchored = false
            weapon.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            teleported = teleported + 1
            
            if BringDelay > 0 then
                wait(BringDelay / 1000)
            end
        end
        
        if teleported > 0 then
            ShowNotification("Teleported " .. teleported .. "/" .. #weapons .. " " .. selectedWeapon .. " to " .. TeleportTarget, 2)
        else
            ShowNotification("No " .. selectedWeapon .. " found on map", 2)
        end
    end,
})

-- Вкладка Info
InfoTab:CreateSection("Script Information")
InfoTab:CreateParagraph({
    Title = "ASTRALCHEAT BETA",
    Content = "99 Nights in the forest\n\nVersion: Beta\n\nTelegram Channel: SCRIPTTYTA\n\nTelegram Owner: @SFXCL"
})

-- Функции из оригинального скрипта
-- Kill Aura функция
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
            local Players = game:GetService("Players")
            local player = Players.LocalPlayer
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

-- Загружаем Rayfield
Rayfield:LoadConfiguration()

ShowNotification("ASTRALCHEAT with Rayfield loaded successfully!", 3)
print("ASTRALCHEAT with Rayfield loaded successfully!")
print("All settings will be saved automatically!")