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

-- Настройки для мини-меню каждой категории
local CategorySettings = {
    Resources = {
        BringTarget = "Campfire",
        BringCount = 5,
        BringDelay = 200
    },
    Metals = {
        BringTarget = "Campfire",
        BringCount = 5,
        BringDelay = 200
    },
    FoodMed = {
        BringTarget = "Campfire",
        BringCount = 5,
        BringDelay = 200
    },
    Weapons = {
        BringTarget = "Campfire",
        BringCount = 5,
        BringDelay = 200
    }
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
    CategorySettings = CategorySettings
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
        Settings.CategorySettings = CategorySettings
        
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
            
            -- Загружаем настройки категорий
            if loadedSettings.CategorySettings then
                for category, settings in pairs(loadedSettings.CategorySettings) do
                    if CategorySettings[category] then
                        CategorySettings[category] = settings
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

-- Обновленная функция Bring Items с обработкой ошибок
local function BringItems(itemName, category)
    pcall(function()
        local categorySettings = CategorySettings[category] or CategorySettings.Resources
        
        local targetPos
        if categorySettings.BringTarget == "Player" then
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                targetPos = char.HumanoidRootPart.Position
            else
                targetPos = CampfirePosition
                Rayfield:Notify({
                    Title = "⚠️ Ошибка",
                    Content = "Персонаж не найден, использую Campfire",
                    Duration = 3,
                    Image = 4483362458,
                })
            end
        else
            targetPos = CampfirePosition
        end
        
        local items = {}
        
        -- Проверяем существует ли workspace.Items
        if not workspace:FindFirstChild("Items") then
            Rayfield:Notify({
                Title = "❌ Ошибка",
                Content = "Папка Items не найдена в workspace!",
                Duration = 5,
                Image = 4483362458,
            })
            return
        end
        
        for _, item in pairs(workspace.Items:GetChildren()) do
            if item:IsA("Model") then
                local itemLower = item.Name:lower()
                local searchLower = itemName:lower()
                
                -- Более гибкий поиск
                if itemLower:find(searchLower) or itemLower == searchLower then
                    local part = item:FindFirstChildWhichIsA("BasePart")
                    if part then 
                        table.insert(items, part)
                    end
                end
            end
        end
        
        if #items == 0 then
            Rayfield:Notify({
                Title = "❌ Не найдено",
                Content = "Предметы " .. itemName .. " не найдены на карте",
                Duration = 5,
                Image = 4483362458,
            })
            return
        end
        
        local teleported = 0
        local bringCount = categorySettings.BringCount or 5
        local bringDelay = categorySettings.BringDelay or 200
        
        Rayfield:Notify({
            Title = "🔄 Телепортация",
            Content = "Начинаю телепортацию " .. math.min(bringCount, #items) .. " предметов...",
            Duration = 3,
            Image = 4483362458,
        })
        
        for i = 1, math.min(bringCount, #items) do
            local item = items[i]
            if item and item.Parent then
                -- Сохраняем оригинальные свойства
                local wasAnchored = item.Anchored
                
                -- Телепортируем
                item.CFrame = CFrame.new(
                    targetPos.X + math.random(-3,3),
                    targetPos.Y + 3,
                    targetPos.Z + math.random(-3,3)
                )
                item.Anchored = false
                item.AssemblyLinearVelocity = Vector3.new(0,0,0)
                teleported = teleported + 1
                
                -- Восстанавливаем оригинальное состояние
                wait(0.1)
                item.Anchored = wasAnchored
                
                if bringDelay > 0 then
                    wait(bringDelay / 1000)
                end
            end
        end
        
        Rayfield:Notify({
            Title = "✅ Успех",
            Content = "Телепортировано " .. teleported .. " " .. itemName .. " к " .. categorySettings.BringTarget,
            Duration = 5,
            Image = 4483362458,
        })
        
    end)
end

-- Anti AFK функция
local function EnableAntiAFK()
    if antiAFKConnection then
        antiAFKConnection:Disconnect()
        antiAFKConnection = nil
    end
    
    antiAFKConnection = RunService.Heartbeat:Connect(function()
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.Jump = true
            wait(0.1)
            player.Character.Humanoid.Jump = false
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
    Range = {10, 150},
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
    Range = {10, 150},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = DistanceForAutoChopTree,
    Flag = "ChopDistanceSlider",
    Callback = function(Value)
        DistanceForAutoChopTree = Value
        SaveSettings()
    end,
})

-- Bring Tab - Resources Section
local ResourcesSection = BringTab:CreateSection("📦 Resources")

-- Мини-меню для Resources
local ResourcesSettingsSection = BringTab:CreateSection("Resources Settings")

local ResourcesTargetDropdown = BringTab:CreateDropdown({
    Name = "Resources Target",
    Options = {"Campfire", "Player"},
    CurrentOption = CategorySettings.Resources.BringTarget,
    Flag = "ResourcesTargetDropdown",
    Callback = function(Option)
        CategorySettings.Resources.BringTarget = Option
        SaveSettings()
        Rayfield:Notify({
            Title = "Resources Target",
            Content = "Target set to: " .. Option,
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

local ResourcesCountSlider = BringTab:CreateSlider({
    Name = "Resources Count",
    Range = {1, 20},
    Increment = 1,
    Suffix = "items",
    CurrentValue = CategorySettings.Resources.BringCount,
    Flag = "ResourcesCountSlider",
    Callback = function(Value)
        CategorySettings.Resources.BringCount = Value
        SaveSettings()
    end,
})

local ResourcesSpeedSlider = BringTab:CreateSlider({
    Name = "Resources Speed",
    Range = {50, 500},
    Increment = 10,
    Suffix = "ms",
    CurrentValue = CategorySettings.Resources.BringDelay,
    Flag = "ResourcesSpeedSlider",
    Callback = function(Value)
        CategorySettings.Resources.BringDelay = Value
        SaveSettings()
    end,
})

-- Кнопки Resources
local ResourcesButtons = {
    {"Log", "📦"},
    {"Coal", "⛏️"},
    {"Chair", "🪑"},
    {"Fuel Canister", "⛽"},
    {"Oil Barrel", "🛢️"},
    {"Biofuel", "🔥"}
}

for i, itemData in ipairs(ResourcesButtons) do
    local itemName, emoji = itemData[1], itemData[2]
    BringTab:CreateButton({
        Name = emoji .. " Bring " .. itemName,
        Callback = function()
            BringItems(itemName, "Resources")
        end,
    })
end

-- Bring Tab - Metals Section
local MetalsSection = BringTab:CreateSection("🔩 Metals")

-- Мини-меню для Metals
local MetalsSettingsSection = BringTab:CreateSection("Metals Settings")

local MetalsTargetDropdown = BringTab:CreateDropdown({
    Name = "Metals Target",
    Options = {"Campfire", "Player"},
    CurrentOption = CategorySettings.Metals.BringTarget,
    Flag = "MetalsTargetDropdown",
    Callback = function(Option)
        CategorySettings.Metals.BringTarget = Option
        SaveSettings()
        Rayfield:Notify({
            Title = "Metals Target",
            Content = "Target set to: " .. Option,
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

local MetalsCountSlider = BringTab:CreateSlider({
    Name = "Metals Count",
    Range = {1, 20},
    Increment = 1,
    Suffix = "items",
    CurrentValue = CategorySettings.Metals.BringCount,
    Flag = "MetalsCountSlider",
    Callback = function(Value)
        CategorySettings.Metals.BringCount = Value
        SaveSettings()
    end,
})

local MetalsSpeedSlider = BringTab:CreateSlider({
    Name = "Metals Speed",
    Range = {50, 500},
    Increment = 10,
    Suffix = "ms",
    CurrentValue = CategorySettings.Metals.BringDelay,
    Flag = "MetalsSpeedSlider",
    Callback = function(Value)
        CategorySettings.Metals.BringDelay = Value
        SaveSettings()
    end,
})

-- Кнопки Metals
local MetalsButtons = {
    {"Bolt", "🔩"},
    {"Sheet Metal", "📄"},
    {"Old Radio", "📻"},
    {"UFO Scrap", "🛸"},
    {"Broken Microwave", "🍳"},
    {"Washing Machine", "🧼"},
    {"Old Car Engine", "🚗"},
    {"Cultist Gem", "💎"}
}

for i, itemData in ipairs(MetalsButtons) do
    local itemName, emoji = itemData[1], itemData[2]
    BringTab:CreateButton({
        Name = emoji .. " Bring " .. itemName,
        Callback = function()
            BringItems(itemName, "Metals")
        end,
    })
end

-- Bring Tab - Food & Medical Section
local FoodMedSection = BringTab:CreateSection("🥕 Food & Medical")

-- Мини-меню для Food & Medical
local FoodMedSettingsSection = BringTab:CreateSection("Food & Medical Settings")

local FoodMedTargetDropdown = BringTab:CreateDropdown({
    Name = "Food & Medical Target",
    Options = {"Campfire", "Player"},
    CurrentOption = CategorySettings.FoodMed.BringTarget,
    Flag = "FoodMedTargetDropdown",
    Callback = function(Option)
        CategorySettings.FoodMed.BringTarget = Option
        SaveSettings()
        Rayfield:Notify({
            Title = "Food & Medical Target",
            Content = "Target set to: " .. Option,
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

local FoodMedCountSlider = BringTab:CreateSlider({
    Name = "Food & Medical Count",
    Range = {1, 20},
    Increment = 1,
    Suffix = "items",
    CurrentValue = CategorySettings.FoodMed.BringCount,
    Flag = "FoodMedCountSlider",
    Callback = function(Value)
        CategorySettings.FoodMed.BringCount = Value
        SaveSettings()
    end,
})

local FoodMedSpeedSlider = BringTab:CreateSlider({
    Name = "Food & Medical Speed",
    Range = {50, 500},
    Increment = 10,
    Suffix = "ms",
    CurrentValue = CategorySettings.FoodMed.BringDelay,
    Flag = "FoodMedSpeedSlider",
    Callback = function(Value)
        CategorySettings.FoodMed.BringDelay = Value
        SaveSettings()
    end,
})

-- Кнопки Food & Medical
local FoodMedButtons = {
    {"Carrot", "🥕"},
    {"Pumpkin", "🎃"},
    {"Morsel", "🍖"},
    {"Steak", "🥩"},
    {"MedKit", "💊"},
    {"Bandage", "🩹"},
    {"Chili", "🌶️"},
    {"Apple", "🍎"},
    {"Cake", "🍰"}
}

for i, itemData in ipairs(FoodMedButtons) do
    local itemName, emoji = itemData[1], itemData[2]
    BringTab:CreateButton({
        Name = emoji .. " Bring " .. itemName,
        Callback = function()
            BringItems(itemName, "FoodMed")
        end,
    })
end

-- Bring Tab - Weapons & Tools Section
local WeaponsSection = BringTab:CreateSection("🔫 Weapons & Tools")

-- Мини-меню для Weapons & Tools
local WeaponsSettingsSection = BringTab:CreateSection("Weapons & Tools Settings")

local WeaponsTargetDropdown = BringTab:CreateDropdown({
    Name = "Weapons Target",
    Options = {"Campfire", "Player"},
    CurrentOption = CategorySettings.Weapons.BringTarget,
    Flag = "WeaponsTargetDropdown",
    Callback = function(Option)
        CategorySettings.Weapons.BringTarget = Option
        SaveSettings()
        Rayfield:Notify({
            Title = "Weapons Target",
            Content = "Target set to: " .. Option,
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

local WeaponsCountSlider = BringTab:CreateSlider({
    Name = "Weapons Count",
    Range = {1, 20},
    Increment = 1,
    Suffix = "items",
    CurrentValue = CategorySettings.Weapons.BringCount,
    Flag = "WeaponsCountSlider",
    Callback = function(Value)
        CategorySettings.Weapons.BringCount = Value
        SaveSettings()
    end,
})

local WeaponsSpeedSlider = BringTab:CreateSlider({
    Name = "Weapons Speed",
    Range = {50, 500},
    Increment = 10,
    Suffix = "ms",
    CurrentValue = CategorySettings.Weapons.BringDelay,
    Flag = "WeaponsSpeedSlider",
    Callback = function(Value)
        CategorySettings.Weapons.BringDelay = Value
        SaveSettings()
    end,
})

-- Кнопки Weapons & Tools
local WeaponsButtons = {
    {"Rifle", "🔫"},
    {"Rifle Ammo", "📦"},
    {"Revolver", "🔫"},
    {"Revolver Ammo", "📦"},
    {"Good Axe", "🪓"},
    {"Strong Axe", "🪓"},
    {"Chainsaw", "🔪"}
}

for i, itemData in ipairs(WeaponsButtons) do
    local itemName, emoji = itemData[1], itemData[2]
    BringTab:CreateButton({
        Name = emoji .. " Bring " .. itemName,
        Callback = function()
            BringItems(itemName, "Weapons")
        end,
    })
end

-- More Tab
local MovementSection = MoreTab:CreateSection("Movement")

local TeleportButton = MoreTab:CreateButton({
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
    Name = "Anti AFK",
    CurrentValue = antiAFKEnabled,
    Flag = "AntiAFKToggle",
    Callback = function(Value)
        antiAFKEnabled = Value
        if antiAFKEnabled then
            EnableAntiAFK()
            Rayfield:Notify({
                Title = "Anti AFK",
                Content = "Anti AFK Enabled",
                Duration = 3,
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

-- Debug Section
local DebugSection = MoreTab:CreateSection("Debug")

local DebugButton = MoreTab:CreateButton({
    Name = "🛠️ Проверить Items",
    Callback = function()
        if workspace:FindFirstChild("Items") then
            local itemCount = 0
            local itemNames = {}
            
            for _, item in pairs(workspace.Items:GetChildren()) do
                if item:IsA("Model") then
                    itemCount = itemCount + 1
                    table.insert(itemNames, item.Name)
                end
            end
            
            Rayfield:Notify({
                Title = "🔍 Debug Info",
                Content = "Найдено " .. itemCount .. " предметов: " .. table.concat(itemNames, ", "),
                Duration = 8,
                Image = 4483362458,
            })
        else
            Rayfield:Notify({
                Title = "❌ Debug Error",
                Content = "Папка Items не существует!",
                Duration = 5,
                Image = 4483362458,
            })
        end
    end,
})

local TestLogButton = MoreTab:CreateButton({
    Name = "🧪 Тест Log",
    Callback = function()
        BringItems("Log", "Resources")
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