-- SANSTRO 99 Nights Menu with Rayfield
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer

-- 99 Nights переменные
local ActiveKillAura = false
local ActiveAutoChopTree = false
local DistanceForKillAura = 25
local DistanceForAutoChopTree = 25
local BringCount = 5
local BringDelay = 200
local CampfirePosition = Vector3.new(0, 10, 0)

-- Загрузка Rayfield
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

-- Создание основного окна
local Window = Rayfield:CreateWindow({
   Name = "SANSTRO 99 Nights",
   LoadingTitle = "SANSTRO Menu Loading...",
   LoadingSubtitle = "99 Nights Cheat Menu",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "SANSTRO_99Nights",
      FileName = "Config"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = false,
})

-- Main Tab
local MainTab = Window:CreateTab("Main Features", "rbxassetid://4483345998")

-- Combat Section
local CombatSection = MainTab:CreateSection("Combat")

local KillAuraToggle = CombatSection:CreateToggle({
    Name = "Kill Aura",
    CurrentValue = false,
    Callback = function(Value)
        ActiveKillAura = Value
    end,
})

local KillDistanceSlider = CombatSection:CreateSlider({
    Name = "Kill Distance",
    Range = {10, 150},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = 25,
    Callback = function(Value)
        DistanceForKillAura = Value
    end,
})

-- Farming Section
local FarmingSection = MainTab:CreateSection("Farming")

local AutoChopToggle = FarmingSection:CreateToggle({
    Name = "Auto Chop Trees",
    CurrentValue = false,
    Callback = function(Value)
        ActiveAutoChopTree = Value
    end,
})

local ChopDistanceSlider = FarmingSection:CreateSlider({
    Name = "Chop Distance",
    Range = {10, 150},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = 25,
    Callback = function(Value)
        DistanceForAutoChopTree = Value
    end,
})

-- Items Tab
local ItemsTab = Window:CreateTab("Items", "rbxassetid://4483345998")

-- Bring Settings Section
local BringSettingsSection = ItemsTab:CreateSection("Bring Settings")

local BringCountSlider = BringSettingsSection:CreateSlider({
    Name = "Bring Count",
    Range = {1, 20},
    Increment = 1,
    Suffix = "items",
    CurrentValue = 5,
    Callback = function(Value)
        BringCount = Value
    end,
})

local BringSpeedSlider = BringSettingsSection:CreateSlider({
    Name = "Bring Speed",
    Range = {50, 500},
    Increment = 10,
    Suffix = "ms",
    CurrentValue = 200,
    Callback = function(Value)
        BringDelay = Value
    end,
})

local TeleportButton = BringSettingsSection:CreateButton({
    Name = "Teleport to Campfire",
    Callback = function()
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(CampfirePosition)
        end
    end,
})

-- Resources Section
local ResourcesSection = ItemsTab:CreateSection("Resources")

local resourcesItems = {"Logs", "Coal", "Chair", "Fuel Canister", "Oil Barrel"}
for _, itemName in pairs(resourcesItems) do
    ResourcesSection:CreateButton({
        Name = "Bring " .. itemName,
        Callback = function()
            BringItems(itemName)
        end,
    })
end

-- Metals Section
local MetalsSection = ItemsTab:CreateSection("Metals")

local metalsItems = {"Bolt", "Sheet Metal", "Old Radio", "Scrap Metal", "UFO Scrap", "Broken Microwave"}
for _, itemName in pairs(metalsItems) do
    MetalsSection:CreateButton({
        Name = "Bring " .. itemName,
        Callback = function()
            BringItems(itemName)
        end,
    })
end

-- Food & Medical Section
local FoodMedSection = ItemsTab:CreateSection("Food & Medical")

local foodMedItems = {"Carrot", "Pumpkin", "Morsel", "Steak", "MedKit", "Bandage"}
for _, itemName in pairs(foodMedItems) do
    FoodMedSection:CreateButton({
        Name = "Bring " .. itemName,
        Callback = function()
            BringItems(itemName)
        end,
    })
end

-- Weapons Section
local WeaponsSection = ItemsTab:CreateSection("Weapons")

local weaponsItems = {"Rifle", "Rifle Ammo", "Revolver", "Revolver Ammo"}
for _, itemName in pairs(weaponsItems) do
    WeaponsSection:CreateButton({
        Name = "Bring " .. itemName,
        Callback = function()
            BringItems(itemName)
        end,
    })
end

-- Axes Section
local AxeSection = ItemsTab:CreateSection("Axes")

local axeItems = {"Good Axe", "Strong Axe", "Chainsaw"}
for _, itemName in pairs(axeItems) do
    AxeSection:CreateButton({
        Name = "Bring " .. itemName,
        Callback = function()
            BringItems(itemName)
        end,
    })
end

-- Player Tab
local PlayerTab = Window:CreateTab("Player", "rbxassetid://4483345998")

-- Movement Section
local MovementSection = PlayerTab:CreateSection("Movement")

local SpeedToggle = MovementSection:CreateToggle({
    Name = "Speed Hack",
    CurrentValue = false,
    Callback = function(Value)
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            if Value then
                player.Character.Humanoid.WalkSpeed = 50
            else
                player.Character.Humanoid.WalkSpeed = 16
            end
        end
    end,
})

local SpeedSlider = MovementSection:CreateSlider({
    Name = "Speed Value",
    Range = {16, 100},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = 50,
    Callback = function(Value)
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = Value
        end
    end,
})

local JumpToggle = MovementSection:CreateToggle({
    Name = "Jump Hack",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.JumpPower = 100
            end
        else
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.JumpPower = 50
            end
        end
    end,
})

local NoClipToggle = MovementSection:CreateToggle({
    Name = "NoClip",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            noclipConnection = RunService.Stepped:Connect(function()
                if player.Character then
                    for _, part in pairs(player.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            if noclipConnection then
                noclipConnection:Disconnect()
            end
        end
    end,
})

-- Bring Items функция
function BringItems(itemName)
    local targetPos = CampfirePosition
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
        
        if BringDelay > 0 then
            wait(BringDelay / 1000)
        end
    end
end

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

-- Jump Hack
UserInputService.JumpRequest:Connect(function()
    if JumpToggle.CurrentValue and player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Notify that menu loaded
Rayfield:Notify({
   Title = "SANSTRO Menu Loaded",
   Content = "99 Nights cheat menu is ready!",
   Duration = 3,
   Image = "rbxassetid://4483345998",
})

-- Load configuration
Rayfield:LoadConfiguration()