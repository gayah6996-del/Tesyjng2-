-- 99 Nights Menu with Rayfield UI
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer

-- Глобальные переменные
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
local BringTarget = "Campfire"
local antiAFKEnabled = false
local antiAFKConnection = nil
local currentSpeed = 16
local lastJumpTime = 0

-- Выбранные предметы
local SelectedItems = {
    ["Log"] = false, ["Coal"] = false, ["Chair"] = false, ["Fuel Canister"] = false, ["Oil Barrel"] = false, ["Biofuel"] = false,
    ["Bolt"] = false, ["Sheet Metal"] = false, ["Old Radio"] = false, ["UFO Scrap"] = false, ["Broken Microwave"] = false,
    ["Washing Machine"] = false, ["Old Car Engine"] = false, ["Cultist Gem"] = false,
    ["Carrot"] = false, ["Pumpkin"] = false, ["Morsel"] = false, ["Steak"] = false, ["MedKit"] = false, ["Bandage"] = false,
    ["Chili"] = false, ["Apple"] = false, ["Cake"] = false,
    ["Rifle"] = false, ["Rifle Ammo"] = false, ["Revolver"] = false, ["Revolver Ammo"] = false,
    ["Good Axe"] = false, ["Strong Axe"] = false, ["Chainsaw"] = false
}

-- Загрузка Rayfield
local success, Rayfield = pcall(function()
    return loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

if not success then
    warn("Failed to load Rayfield UI Library")
    return
end

-- Создание окна
local Window = Rayfield:CreateWindow({
    Name = "SANSTRO MENU",
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

-- Функции
local function SaveSettings()
    -- Простая функция сохранения (можно добавить позже)
end

local function LoadSettings()
    -- Простая функция загрузки (можно добавить позже)
end

-- Kill Aura функция
local function RunKillAura()
    while ActiveKillAura and task.wait(0.1) do
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
    end
end

-- Auto Chop функция
local function RunAutoChop()
    while ActiveAutoChopTree and task.wait(0.1) do
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
    end
end

-- Функция телепорта для категории
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
    
    for _, itemName in ipairs(categoryItems) do
        if SelectedItems[itemName] then
            local items = {}
            
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
                    task.wait(BringDelay / 1000)
                end
            end
            
            if teleported > 0 then
                itemCounts[itemName] = teleported
            end
        end
    end
    
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

-- Anti AFK функция
local function EnableAntiAFK()
    if antiAFKConnection then
        antiAFKConnection:Disconnect()
    end
    
    lastJumpTime = tick()
    
    antiAFKConnection = RunService.Heartbeat:Connect(function()
        if antiAFKEnabled then
            local currentTime = tick()
            if currentTime - lastJumpTime >= 30 then
                local character = player.Character
                if character and character:FindFirstChild("Humanoid") then
                    character.Humanoid.Jump = true
                    lastJumpTime = currentTime
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
    while task.wait(1) do
        if ActiveKillAura then
            RunKillAura()
        end
    end
end)

task.spawn(function()
    while task.wait(1) do
        if ActiveAutoChopTree then
            RunAutoChop()
        end
    end
end)

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
    end,
})

local AutoChopToggle = MainTab:CreateToggle({
    Name = "Auto Chop Trees",
    CurrentValue = ActiveAutoChopTree,
    Flag = "AutoChopToggle",
    Callback = function(Value)
        ActiveAutoChopTree = Value
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
    end,
})

-- Bring Tab Settings
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
        Rayfield:Notify({
            Title = "Teleport Target",
            Content = "Target set to: " .. Option,
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

-- Resources Mini Menu
local ResourcesSection = BringTab:CreateSection("📦 Resources")

local ResourcesItems = {"Log", "Coal", "Chair", "Fuel Canister", "Oil Barrel", "Biofuel"}

-- Тогглы для Resources
for i, itemName in ipairs(ResourcesItems) do
    BringTab:CreateToggle({
        Name = "📦 " .. itemName,
        CurrentValue = SelectedItems[itemName],
        Flag = "Select" .. itemName,
        Callback = function(Value)
            SelectedItems[itemName] = Value
        end,
    })
end

-- Кнопка телепорта для Resources
BringTab:CreateButton({
    Name = "🚀 BRING RESOURCES",
    Callback = function()
        BringCategoryItems(ResourcesItems)
    end,
})

-- Metals Mini Menu
local MetalsSection = BringTab:CreateSection("🔩 Metals")

local MetalsItems = {"Bolt", "Sheet Metal", "Old Radio", "UFO Scrap", "Broken Microwave", "Washing Machine", "Old Car Engine", "Cultist Gem"}

-- Тогглы для Metals
for i, itemName in ipairs(MetalsItems) do
    BringTab:CreateToggle({
        Name = "🔩 " .. itemName,
        CurrentValue = SelectedItems[itemName],
        Flag = "Select" .. itemName,
        Callback = function(Value)
            SelectedItems[itemName] = Value
        end,
    })
end

-- Кнопка телепорта для Metals
BringTab:CreateButton({
    Name = "🚀 BRING METALS",
    Callback = function()
        BringCategoryItems(MetalsItems)
    end,
})

-- Food & Medical Mini Menu
local FoodMedSection = BringTab:CreateSection("🍎 Food & Medical")

local FoodMedItems = {"Carrot", "Pumpkin", "Morsel", "Steak", "MedKit", "Bandage", "Chili", "Apple", "Cake"}

-- Тогглы для Food & Medical
for i, itemName in ipairs(FoodMedItems) do
    BringTab:CreateToggle({
        Name = "🍎 " .. itemName,
        CurrentValue = SelectedItems[itemName],
        Flag = "Select" .. itemName,
        Callback = function(Value)
            SelectedItems[itemName] = Value
        end,
    })
end

-- Кнопка телепорта для Food & Medical
BringTab:CreateButton({
    Name = "🚀 BRING FOOD & MEDICAL",
    Callback = function()
        BringCategoryItems(FoodMedItems)
    end,
})

-- Weapons & Tools Mini Menu
local WeaponsSection = BringTab:CreateSection("🔫 Weapons & Tools")

local WeaponsItems = {"Rifle", "Rifle Ammo", "Revolver", "Revolver Ammo", "Good Axe", "Strong Axe", "Chainsaw"}

-- Тогглы для Weapons & Tools
for i, itemName in ipairs(WeaponsItems) do
    BringTab:CreateToggle({
        Name = "🔫 " .. itemName,
        CurrentValue = SelectedItems[itemName],
        Flag = "Select" .. itemName,
        Callback = function(Value)
            SelectedItems[itemName] = Value
        end,
    })
end

-- Кнопка телепорта для Weapons & Tools
BringTab:CreateButton({
    Name = "🚀 BRING WEAPONS & TOOLS",
    Callback = function()
        BringCategoryItems(WeaponsItems)
    end,
})

-- More Tab
local MovementSection = MoreTab:CreateSection("Movement")

MoreTab:CreateButton({
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
    end,
})

local InfinityJumpToggle = MoreTab:CreateToggle({
    Name = "Infinity Jump",
    CurrentValue = jumpHackEnabled,
    Flag = "InfinityJumpToggle",
    Callback = function(Value)
        jumpHackEnabled = Value
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
        else
            Rayfield:Notify({
                Title = "NoClip",
                Content = "NoClip Disabled",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end,
})

-- Уведомление о загрузке
Rayfield:Notify({
    Title = "SANSTRO MENU",
    Content = "Menu loaded successfully!",
    Duration = 5,
    Image = 4483362458,
})

print("SANSTRO Menu loaded successfully!")