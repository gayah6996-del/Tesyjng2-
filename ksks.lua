-- 99 Nights Menu with Rayfield UI
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Глобальные переменные для сохранения состояний
local speedHackEnabled = false
local jumpHackEnabled = false
local noclipEnabled = false
local ActiveKillAura = false
local ActiveAutoChopTree = false
local DistanceForKillAura = 25
local DistanceForAutoChopTree = 25
local BringCount = 5
local BringDelay = 200
local CampfirePosition = Vector3.new(0, 10, 0)
local BringTarget = "Campfire" -- "Campfire" или "Player"
local antiAFKEnabled = false
local antiAFKConnection = nil
local currentSpeed = 16
local lastJumpTime = 0

-- Выбранные предметы для телепорта
local SelectedItems = {
    ["Log"] = false,
    ["Coal"] = false,
    ["Chair"] = false,
    ["Fuel Canister"] = false,
    ["Oil Barrel"] = false,
    ["Biofuel"] = false,
    ["Bolt"] = false,
    ["Sheet Metal"] = false,
    ["Old Radio"] = false,
    ["UFO Scrap"] = false,
    ["Broken Microwave"] = false,
    ["Washing Machine"] = false,
    ["Old Car Engine"] = false,
    ["Cultist Gem"] = false,
    ["Carrot"] = false,
    ["Pumpkin"] = false,
    ["Morsel"] = false,
    ["Steak"] = false,
    ["MedKit"] = false,
    ["Bandage"] = false,
    ["Chili"] = false,
    ["Apple"] = false,
    ["Cake"] = false,
    ["Rifle"] = false,
    ["Rifle Ammo"] = false,
    ["Revolver"] = false,
    ["Revolver Ammo"] = false,
    ["Good Axe"] = false,
    ["Strong Axe"] = false,
    ["Chainsaw"] = false
}

-- Настройки файла
local SETTINGS_FILE = "astralcheat_settings.txt"
local Settings = {
    ActiveKillAura = false,
    ActiveAutoChopTree = false,
    DistanceForKillAura = 25,
    DistanceForAutoChopTree = 25,
    BringCount = 5,
    BringDelay = 200,
    BringTarget = "Campfire",
    speedHackEnabled = false,
    jumpHackEnabled = false,
    currentSpeed = 16,
    antiAFKEnabled = false,
    SelectedItems = SelectedItems
}

-- Загрузка Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Создание окна
local Window = Rayfield:CreateWindow({
   Name = "SANSTRO|t.me/SCRIPTTYTA",
   LoadingTitle = "SANSTRO Menu",
   LoadingSubtitle = "by SANSTRO",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "SANSTRO_Config",
      FileName = "99Nights"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = false,
})

-- Функции сохранения настроек
local function SaveSettings()
    pcall(function()
        Settings.ActiveKillAura = ActiveKillAura
        Settings.ActiveAutoChopTree = ActiveAutoChopTree
        Settings.DistanceForKillAura = DistanceForKillAura
        Settings.DistanceForAutoChopTree = DistanceForAutoChopTree
        Settings.BringCount = BringCount
        Settings.BringDelay = BringDelay
        Settings.BringTarget = BringTarget
        Settings.speedHackEnabled = speedHackEnabled
        Settings.jumpHackEnabled = jumpHackEnabled
        Settings.currentSpeed = currentSpeed
        Settings.antiAFKEnabled = antiAFKEnabled
        Settings.SelectedItems = SelectedItems
        
        local data = HttpService:JSONEncode(Settings)
        writefile(SETTINGS_FILE, data)
    end)
end

local function LoadSettings()
    pcall(function()
        if isfile(SETTINGS_FILE) then
            local data = readfile(SETTINGS_FILE)
            local loadedSettings = HttpService:JSONDecode(data)
            for key, value in pairs(loadedSettings) do
                if Settings[key] ~= nil then 
                    Settings[key] = value 
                end
            end
            
            -- Применяем загруженные настройки
            ActiveKillAura = Settings.ActiveKillAura
            ActiveAutoChopTree = Settings.ActiveAutoChopTree
            DistanceForKillAura = Settings.DistanceForKillAura
            DistanceForAutoChopTree = Settings.DistanceForAutoChopTree
            BringCount = Settings.BringCount
            BringDelay = Settings.BringDelay
            BringTarget = Settings.BringTarget or "Campfire"
            speedHackEnabled = Settings.speedHackEnabled or false
            jumpHackEnabled = Settings.jumpHackEnabled or false
            currentSpeed = Settings.currentSpeed or 16
            antiAFKEnabled = Settings.antiAFKEnabled or false
            
            -- Загружаем выбранные предметы
            if Settings.SelectedItems then
                for itemName, isSelected in pairs(Settings.SelectedItems) do
                    if SelectedItems[itemName] ~= nil then
                        SelectedItems[itemName] = isSelected
                    end
                end
            end
        end
    end)
end

-- Загружаем настройки при запуске
LoadSettings()

-- Функции из второго скрипта
-- Kill Aura функция
local function RunKillAura()
    while ActiveKillAura do
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local weapon = player.Inventory:FindFirstChild("Old Axe") or player.Inventory:FindFirstChild("Good Axe") or player.Inventory:FindFirstChild("Strong Axe") or player.Inventory:FindFirstChild("Chainsaw")
        
        if hrp and weapon then
            for _, enemy in pairs(workspace.Characters:GetChildren()) do
                if enemy:IsA("Model") and enemy.PrimaryPart then
                    local dist = (enemy.PrimaryPart.Position - hrp.Position).Magnitude
                    if dist <= DistanceForKillAura then
                        game:GetService("ReplicatedStorage").RemoteEvents.ToolDamageObject:InvokeServer(enemy, weapon, 999, hrp.CFrame)
                    end
                end
            end
        end
        wait(0.1)
    end
end

-- Auto Chop функция
local function RunAutoChop()
    while ActiveAutoChopTree do
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local weapon = player.Inventory:FindFirstChild("Old Axe") or player.Inventory:FindFirstChild("Good Axe") or player.Inventory:FindFirstChild("Strong Axe") or player.Inventory:FindFirstChild("Chainsaw")
        
        if hrp and weapon then
            for _, tree in pairs(workspace.Map.Foliage:GetChildren()) do
                if tree:IsA("Model") and (tree.Name == "Small Tree" or tree.Name == "TreeBig1" or tree.Name == "TreeBig2") and tree.PrimaryPart then
                    local dist = (tree.PrimaryPart.Position - hrp.Position).Magnitude
                    if dist <= DistanceForAutoChopTree then
                        game:GetService("ReplicatedStorage").RemoteEvents.ToolDamageObject:InvokeServer(tree, weapon, 999, hrp.CFrame)
                    end
                end
            end
        end
        wait(0.1)
    end
end

-- Функция телепорта для конкретной категории
local function BringCategoryItems(categoryItems)
    local targetPos
    if BringTarget == "Player" then
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            targetPos = char.HumanoidRootPart.Position
        else
            targetPos = CampfirePosition
        end
    else
        targetPos = CampfirePosition
    end
    
    local totalTeleported = 0
    local itemCounts = {}
    
    -- Перебираем предметы из категории
    for _, itemName in ipairs(categoryItems) do
        if SelectedItems[itemName] then
            local items = {}
            
            -- Ищем предметы в workspace
            for _, item in pairs(workspace.Items:GetChildren()) do
                if item:IsA("Model") then
                    local itemLower = item.Name:lower()
                    local searchLower = itemName:lower()
                    
                    if itemLower:find(searchLower) then
                        local part = item:FindFirstChildWhichIsA("BasePart")
                        if part then table.insert(items, part) end
                    end
                end
            end
            
            -- Телепортируем найденные предметы
            local teleported = 0
            for i = 1, math.min(BringCount, #items) do
                local item = items[i]
                item.CFrame = CFrame.new(
                    targetPos.X + math.random(-3,3),
                    targetPos.Y + 3,
                    targetPos.Z + math.random(-3,3)
                )
                item.Anchored = false
                item.AssemblyLinearVelocity = Vector3.new(0,0,0)
                teleported = teleported + 1
                totalTeleported = totalTeleported + 1
                
                if BringDelay > 0 then
                    wait(BringDelay / 1000)
                end
            end
            
            if teleported > 0 then
                itemCounts[itemName] = teleported
            end
        end
    end
    
    -- Формируем сообщение о результатах
    if totalTeleported > 0 then
        local message = "Teleported: "
        local first = true
        for itemName, count in pairs(itemCounts) do
            if not first then
                message = message .. ", "
            end
            message = message .. count .. " " .. itemName
            first = false
        end
        message = message .. " (Total: " .. totalTeleported .. " items)"
        
        Rayfield:Notify({
            Title = "Bring Items",
            Content = message,
            Duration = 6,
            Image = 4483362458,
        })
    else
        Rayfield:Notify({
            Title = "Bring Items",
            Content = "No items found or selected!",
            Duration = 3,
            Image = 4483362458,
        })
    end
end

-- Исправленная Anti AFK функция для мобильных устройств (прыжок каждые 30 секунд)
local function EnableAntiAFK()
    if antiAFKConnection then
        antiAFKConnection:Disconnect()
        antiAFKConnection = nil
    end
    
    lastJumpTime = tick()
    
    antiAFKConnection = RunService.Heartbeat:Connect(function()
        if antiAFKEnabled then
            local currentTime = tick()
            -- Проверяем, прошло ли 30 секунд с последнего прыжка
            if currentTime - lastJumpTime >= 30 then
                local character = player.Character
                if character and character:FindFirstChild("Humanoid") then
                    local humanoid = character.Humanoid
                    -- Выполняем прыжок
                    humanoid.Jump = true
                    lastJumpTime = currentTime
                    
                    -- Уведомление в консоль для отладки
                    print("[AntiAFK] Player jumped at " .. os.date("%X"))
                end
            end
        end
    end)
end

local function DisableAntiAFK()
    if antiAFKConnection then
        antiAFKConnection:Disconnect()
        antiAFKConnection = nil
    end
end

-- Запускаем функции геймплея
task.spawn(function()
    while true do
        if ActiveKillAura then
            RunKillAura()
        end
        wait(1)
    end
end)

task.spawn(function()
    while true do
        if ActiveAutoChopTree then
            RunAutoChop()
        end
        wait(1)
    end
end)

-- Применяем настройки SpeedHack при загрузке
if speedHackEnabled then
    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = currentSpeed
    end
end

-- Применяем настройки AntiAFK при загрузке
if antiAFKEnabled then
    EnableAntiAFK()
end

-- Создание вкладок
local MainTab = Window:CreateTab("Main", 4483362458)
local BringTab = Window:CreateTab("Bring Items", 4483362458)
local MoreTab = Window:CreateTab("More", 4483362458)

-- Main Tab
local CombatSection = MainTab:CreateSection("Combat")

local KillAuraToggle = MainTab:CreateToggle({
    Name = "Kill Aura",
    CurrentValue = ActiveKillAura,
    Flag = "KillAuraToggle",
    Callback = function(Value)
        ActiveKillAura = Value
        SaveSettings()
        if Value then
            Rayfield:Notify({
                Title = "Kill Aura",
                Content = "Kill Aura Enabled",
                Duration = 3,
                Image = 4483362458,
            })
        else
            Rayfield:Notify({
                Title = "Kill Aura",
                Content = "Kill Aura Disabled",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end,
})

local KillDistanceSlider = MainTab:CreateSlider({
    Name = "Kill Aura Distance",
    Range = {10, 200},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = DistanceForKillAura,
    Flag = "KillDistanceSlider",
    Callback = function(Value)
        DistanceForKillAura = Value
        SaveSettings()
    end,
})

local AutoChopToggle = MainTab:CreateToggle({
    Name = "Auto Chop Trees",
    CurrentValue = ActiveAutoChopTree,
    Flag = "AutoChopToggle",
    Callback = function(Value)
        ActiveAutoChopTree = Value
        SaveSettings()
        if Value then
            Rayfield:Notify({
                Title = "Auto Chop",
                Content = "Auto Chop Enabled",
                Duration = 3,
                Image = 4483362458,
            })
        else
            Rayfield:Notify({
                Title = "Auto Chop",
                Content = "Auto Chop Disabled",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end,
})

local ChopDistanceSlider = MainTab:CreateSlider({
    Name = "Chop Distance",
    Range = {10, 200},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = DistanceForAutoChopTree,
    Flag = "ChopDistanceSlider",
    Callback = function(Value)
        DistanceForAutoChopTree = Value
        SaveSettings()
    end,
})

-- Bring Tab - Обновленная структура с мини-меню и тогглами
local SettingsSection = BringTab:CreateSection("Bring Settings")

local BringCountSlider = BringTab:CreateSlider({
    Name = "Bring Count",
    Range = {1, 50},
    Increment = 1,
    Suffix = "items",
    CurrentValue = BringCount,
    Flag = "BringCountSlider",
    Callback = function(Value)
        BringCount = Value
        SaveSettings()
    end,
})

local BringSpeedSlider = BringTab:CreateSlider({
    Name = "Bring Speed",
    Range = {0, 1000},
    Increment = 10,
    Suffix = "ms",
    CurrentValue = BringDelay,
    Flag = "BringSpeedSlider",
    Callback = function(Value)
        BringDelay = Value
        SaveSettings()
    end,
})

local TargetSection = BringTab:CreateSection("Teleport Target")

local TargetDropdown = BringTab:CreateDropdown({
    Name = "Teleport Target",
    Options = {"Campfire", "Player"},
    CurrentOption = BringTarget,
    Flag = "TargetDropdown",
    Callback = function(Option)
        BringTarget = Option
        SaveSettings()
        Rayfield:Notify({
            Title = "Teleport Target",
            Content = "Target set to: " .. Option,
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

-- Resources Mini Menu
local ResourcesSection = BringTab:CreateSection("📦 Resources Mini Menu")

local ResourcesItems = {"Log", "Coal", "Chair", "Fuel Canister", "Oil Barrel", "Biofuel"}

-- Выпадающее меню для быстрого выбора
local ResourcesDropdown = BringTab:CreateDropdown({
    Name = "Quick Select Resources",
    Options = ResourcesItems,
    CurrentOption = "Select Items",
    Flag = "ResourcesDropdown",
    Callback = function(Option)
        SelectedItems[Option] = not SelectedItems[Option]
        SaveSettings()
        Rayfield:Notify({
            Title = "Resources",
            Content = Option .. " " .. (SelectedItems[Option] and "selected" : "deselected"),
            Duration = 2,
            Image = 4483362458,
        })
    end,
})

-- Тогглы для каждого предмета
for i, itemName in ipairs(ResourcesItems) do
    BringTab:CreateToggle({
        Name = "📦 " .. itemName,
        CurrentValue = SelectedItems[itemName],
        Flag = "Select" .. itemName,
        Callback = function(Value)
            SelectedItems[itemName] = Value
            SaveSettings()
        end,
    })
end

-- Кнопка телепорта для Resources
local ResourcesTeleportButton = BringTab:CreateButton({
    Name = "🚀 BRING RESOURCES",
    Callback = function()
        BringCategoryItems(ResourcesItems)
    end,
})

-- Metals Mini Menu
local MetalsSection = BringTab:CreateSection("🔩 Metals Mini Menu")

local MetalsItems = {"Bolt", "Sheet Metal", "Old Radio", "UFO Scrap", "Broken Microwave", "Washing Machine", "Old Car Engine", "Cultist Gem"}

-- Выпадающее меню для быстрого выбора
local MetalsDropdown = BringTab:CreateDropdown({
    Name = "Quick Select Metals",
    Options = MetalsItems,
    CurrentOption = "Select Items",
    Flag = "MetalsDropdown",
    Callback = function(Option)
        SelectedItems[Option] = not SelectedItems[Option]
        SaveSettings()
        Rayfield:Notify({
            Title = "Metals",
            Content = Option .. " " .. (SelectedItems[Option] and "selected" : "deselected"),
            Duration = 2,
            Image = 4483362458,
        })
    end,
})

-- Тогглы для каждого предмета
for i, itemName in ipairs(MetalsItems) do
    BringTab:CreateToggle({
        Name = "🔩 " .. itemName,
        CurrentValue = SelectedItems[itemName],
        Flag = "Select" .. itemName,
        Callback = function(Value)
            SelectedItems[itemName] = Value
            SaveSettings()
        end,
    })
end

-- Кнопка телепорта для Metals
local MetalsTeleportButton = BringTab:CreateButton({
    Name = "🚀 BRING METALS",
    Callback = function()
        BringCategoryItems(MetalsItems)
    end,
})

-- Food & Medical Mini Menu
local FoodMedSection = BringTab:CreateSection("🍎 Food & Medical Mini Menu")

local FoodMedItems = {"Carrot", "Pumpkin", "Morsel", "Steak", "MedKit", "Bandage", "Chili", "Apple", "Cake"}

-- Выпадающее меню для быстрого выбора
local FoodMedDropdown = BringTab:CreateDropdown({
    Name = "Quick Select Food & Medical",
    Options = FoodMedItems,
    CurrentOption = "Select Items",
    Flag = "FoodMedDropdown",
    Callback = function(Option)
        SelectedItems[Option] = not SelectedItems[Option]
        SaveSettings()
        Rayfield:Notify({
            Title = "Food & Medical",
            Content = Option .. " " .. (SelectedItems[Option] and "selected" : "deselected"),
            Duration = 2,
            Image = 4483362458,
        })
    end,
})

-- Тогглы для каждого предмета
for i, itemName in ipairs(FoodMedItems) do
    BringTab:CreateToggle({
        Name = "🍎 " .. itemName,
        CurrentValue = SelectedItems[itemName],
        Flag = "Select" .. itemName,
        Callback = function(Value)
            SelectedItems[itemName] = Value
            SaveSettings()
        end,
    })
end

-- Кнопка телепорта для Food & Medical
local FoodMedTeleportButton = BringTab:CreateButton({
    Name = "🚀 BRING FOOD & MEDICAL",
    Callback = function()
        BringCategoryItems(FoodMedItems)
    end,
})

-- Weapons & Tools Mini Menu
local WeaponsSection = BringTab:CreateSection("🔫 Weapons & Tools Mini Menu")

local WeaponsItems = {"Rifle", "Rifle Ammo", "Revolver", "Revolver Ammo", "Good Axe", "Strong Axe", "Chainsaw"}

-- Выпадающее меню для быстрого выбора
local WeaponsDropdown = BringTab:CreateDropdown({
    Name = "Quick Select Weapons & Tools",
    Options = WeaponsItems,
    CurrentOption = "Select Items",
    Flag = "WeaponsDropdown",
    Callback = function(Option)
        SelectedItems[Option] = not SelectedItems[Option]
        SaveSettings()
        Rayfield:Notify({
            Title = "Weapons & Tools",
            Content = Option .. " " .. (SelectedItems[Option] and "selected" : "deselected"),
            Duration = 2,
            Image = 4483362458,
        })
    end,
})

-- Тогглы для каждого предмета
for i, itemName in ipairs(WeaponsItems) do
    BringTab:CreateToggle({
        Name = "🔫 " .. itemName,
        CurrentValue = SelectedItems[itemName],
        Flag = "Select" .. itemName,
        Callback = function(Value)
            SelectedItems[itemName] = Value
            SaveSettings()
        end,
    })
end

-- Кнопка телепорта для Weapons & Tools
local WeaponsTeleportButton = BringTab:CreateButton({
    Name = "🚀 BRING WEAPONS & TOOLS",
    Callback = function()
        BringCategoryItems(WeaponsItems)
    end,
})

-- More Tab
local MovementSection = MoreTab:CreateSection("Movement")

local TeleportToCampfireButton = MoreTab:CreateButton({
    Name = "🔥 Teleport to Campfire",
    Callback = function()
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(CampfirePosition)
            Rayfield:Notify({
                Title = "Teleport",
                Content = "Teleported to Campfire",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end,
})

local SpeedHackToggle = MoreTab:CreateToggle({
    Name = "Speed Hack",
    CurrentValue = speedHackEnabled,
    Flag = "SpeedHackToggle",
    Callback = function(Value)
        speedHackEnabled = Value
        
        if speedHackEnabled then
            local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = currentSpeed
            end
            Rayfield:Notify({
                Title = "Speed Hack",
                Content = "Speed Hack Enabled",
                Duration = 3,
                Image = 4483362458,
            })
        else
            local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 16
            end
            Rayfield:Notify({
                Title = "Speed Hack",
                Content = "Speed Hack Disabled",
                Duration = 3,
                Image = 4483362458,
            })
        end
        SaveSettings()
    end,
})

local SpeedSlider = MoreTab:CreateSlider({
    Name = "Speed Value",
    Range = {16, 100},
    Increment = 1,
    Suffix = "speed",
    CurrentValue = currentSpeed,
    Flag = "SpeedSlider",
    Callback = function(Value)
        currentSpeed = Value
        if speedHackEnabled then
            local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = currentSpeed
            end
        end
        SaveSettings()
    end,
})

local InfinityJumpToggle = MoreTab:CreateToggle({
    Name = "Infinity Jump",
    CurrentValue = jumpHackEnabled,
    Flag = "InfinityJumpToggle",
    Callback = function(Value)
        jumpHackEnabled = Value
        SaveSettings()
        if Value then
            Rayfield:Notify({
                Title = "Infinity Jump",
                Content = "Infinity Jump Enabled",
                Duration = 3,
                Image = 4483362458,
            })
        else
            Rayfield:Notify({
                Title = "Infinity Jump",
                Content = "Infinity Jump Disabled",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end,
})

local UtilitySection = MoreTab:CreateSection("Utility")

local AntiAFKToggle = MoreTab:CreateToggle({
    Name = "🔄 Anti AFK (Jump every 30s)",
    CurrentValue = antiAFKEnabled,
    Flag = "AntiAFKToggle",
    Callback = function(Value)
        antiAFKEnabled = Value
        if antiAFKEnabled then
            EnableAntiAFK()
            Rayfield:Notify({
                Title = "Anti AFK",
                Content = "Anti AFK Enabled - Jumping every 30 seconds",
                Duration = 5,
                Image = 4483362458,
            })
        else
            DisableAntiAFK()
            Rayfield:Notify({
                Title = "Anti AFK",
                Content = "Anti AFK Disabled",
                Duration = 3,
                Image = 4483362458,
            })
        end
        SaveSettings()
    end,
})

local NoClipToggle = MoreTab:CreateToggle({
    Name = "NoClip",
    CurrentValue = noclipEnabled,
    Flag = "NoClipToggle",
    Callback = function(Value)
        noclipEnabled = Value
        
        if noclipEnabled then
            Rayfield:Notify({
                Title = "NoClip",
                Content = "NoClip Enabled",
                Duration = 3,
                Image = 4483362458,
            })
            
            -- NoClip логика
            local noclipConnection
            noclipConnection = RunService.Stepped:Connect(function()
                if player.Character and noclipEnabled then
                    for _, part in pairs(player.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                elseif not noclipEnabled and noclipConnection then
                    noclipConnection:Disconnect()
                end
            end)
        else
            Rayfield:Notify({
                Title = "NoClip",
                Content = "NoClip Disabled",
                Duration = 3,
                Image = 4483362458,
            })
            
            if player.Character then
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end,
})

-- Обработчик прыжка для Infinity Jump
UserInputService.JumpRequest:Connect(function()
    if jumpHackEnabled and player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Восстанавливаем настройки после смерти
player.CharacterAdded:Connect(function()
    wait(2)
    
    -- Восстанавливаем SpeedHack после смерти
    if speedHackEnabled then
        wait(1)
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = currentSpeed
        end
    end
    
    -- Восстанавливаем AntiAFK после смерти
    if antiAFKEnabled then
        EnableAntiAFK()
    end
end)

Rayfield:Notify({
    Title = "SANSTRO MENU",
    Content = "Menu loaded successfully!",
    Duration = 5,
    Image = 4483362458,
})