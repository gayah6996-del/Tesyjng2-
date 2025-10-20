-- SANSTRO Menu with Rayfield
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Загрузка Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Глобальные переменные для сохранения состояний
local speedHackEnabled = false
local jumpHackEnabled = false
local noclipEnabled = false
local espTracersEnabled = false
local espBoxEnabled = false
local espHealthEnabled = false
local espDistanceEnabled = false
local espCountEnabled = false
local aimBotEnabled = false
local currentSpeed = 16
local aimBotFOV = 50

-- Новые переменные из второго скрипта
local ActiveKillAura = false
local ActiveAutoChopTree = false
local DistanceForKillAura = 25
local DistanceForAutoChopTree = 25
local BringCount = 5
local BringDelay = 200
local CampfirePosition = Vector3.new(0, 10, 0)

-- ESP объекты
local espObjects = {}
local espConnections = {}
local espCountText = nil
local noclipConnection = nil
local fovCircle = nil

-- Функции сохранения настроек
local function SaveSettings()
    pcall(function()
        local Settings = {
            ActiveKillAura = ActiveKillAura,
            ActiveAutoChopTree = ActiveAutoChopTree,
            DistanceForKillAura = DistanceForKillAura,
            DistanceForAutoChopTree = DistanceForAutoChopTree,
            BringCount = BringCount,
            BringDelay = BringDelay
        }
        
        local data = HttpService:JSONEncode(Settings)
        writefile("astralcheat_settings.txt", data)
    end)
end

local function LoadSettings()
    pcall(function()
        if isfile("astralcheat_settings.txt") then
            local data = readfile("astralcheat_settings.txt")
            local loadedSettings = HttpService:JSONDecode(data)
            
            ActiveKillAura = loadedSettings.ActiveKillAura or false
            ActiveAutoChopTree = loadedSettings.ActiveAutoChopTree or false
            DistanceForKillAura = loadedSettings.DistanceForKillAura or 25
            DistanceForAutoChopTree = loadedSettings.DistanceForAutoChopTree or 25
            BringCount = loadedSettings.BringCount or 5
            BringDelay = loadedSettings.BringDelay or 200
        end
    end)
end

-- Загружаем настройки при запуске
LoadSettings()

-- Функция создания FOV Circle
local function createFOVCircle()
    if fovCircle then
        fovCircle:Remove()
    end
    
    fovCircle = Drawing.new("Circle")
    fovCircle.Visible = false
    fovCircle.Color = Color3.fromRGB(255, 0, 0)
    fovCircle.Thickness = 1
    fovCircle.Filled = false
    fovCircle.Radius = aimBotFOV
    fovCircle.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)
end

-- Функция обновления FOV Circle
local function updateFOVCircle()
    if fovCircle then
        fovCircle.Radius = aimBotFOV
        fovCircle.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)
    end
end

-- Функция очистки ESP
local function cleanupESP(otherPlayer)
    if espObjects[otherPlayer] then
        if espObjects[otherPlayer].tracer then
            espObjects[otherPlayer].tracer:Remove()
        end
        if espObjects[otherPlayer].box then
            espObjects[otherPlayer].box:Remove()
        end
        if espObjects[otherPlayer].health then
            espObjects[otherPlayer].health:Remove()
        end
        if espObjects[otherPlayer].distance then
            espObjects[otherPlayer].distance:Remove()
        end
        espObjects[otherPlayer] = nil
    end
    
    if espConnections[otherPlayer] then
        espConnections[otherPlayer]:Disconnect()
        espConnections[otherPlayer] = nil
    end
end

-- ESP Functions
local function createESP(otherPlayer)
    if otherPlayer == player then return end
    
    cleanupESP(otherPlayer)
    
    espObjects[otherPlayer] = {
        tracer = nil,
        box = nil,
        health = nil,
        distance = nil
    }
    
    local function updateESP()
        if not espObjects[otherPlayer] then return end
        
        if not otherPlayer.Character or not otherPlayer.Character:FindFirstChild("HumanoidRootPart") or not otherPlayer.Character:FindFirstChild("Humanoid") then
            if espObjects[otherPlayer].tracer then espObjects[otherPlayer].tracer.Visible = false end
            if espObjects[otherPlayer].box then espObjects[otherPlayer].box.Visible = false end
            if espObjects[otherPlayer].health then espObjects[otherPlayer].health.Visible = false end
            if espObjects[otherPlayer].distance then espObjects[otherPlayer].distance.Visible = false end
            return
        end
        
        local rootPart = otherPlayer.Character.HumanoidRootPart
        local humanoid = otherPlayer.Character.Humanoid
        local head = otherPlayer.Character:FindFirstChild("Head")
        
        if not head then return end
        
        if humanoid.Health <= 0 then
            if espObjects[otherPlayer].tracer then espObjects[otherPlayer].tracer.Visible = false end
            if espObjects[otherPlayer].box then espObjects[otherPlayer].box.Visible = false end
            if espObjects[otherPlayer].health then espObjects[otherPlayer].health.Visible = false end
            if espObjects[otherPlayer].distance then espObjects[otherPlayer].distance.Visible = false end
            return
        end
        
        local vector, onScreen = workspace.CurrentCamera:WorldToViewportPoint(rootPart.Position)
        
        if onScreen then
            -- Tracer
            if espTracersEnabled then
                if not espObjects[otherPlayer].tracer then
                    espObjects[otherPlayer].tracer = Drawing.new("Line")
                    espObjects[otherPlayer].tracer.Thickness = 1
                    espObjects[otherPlayer].tracer.Color = Color3.fromRGB(255, 0, 0)
                end
                
                local screenCenter = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y)
                espObjects[otherPlayer].tracer.From = screenCenter
                espObjects[otherPlayer].tracer.To = Vector2.new(vector.X, vector.Y)
                espObjects[otherPlayer].tracer.Visible = true
            elseif espObjects[otherPlayer].tracer then
                espObjects[otherPlayer].tracer.Visible = false
            end
            
            -- Box ESP
            if espBoxEnabled then
                if not espObjects[otherPlayer].box then
                    espObjects[otherPlayer].box = Drawing.new("Square")
                    espObjects[otherPlayer].box.Thickness = 1
                    espObjects[otherPlayer].box.Color = Color3.fromRGB(255, 0, 0)
                    espObjects[otherPlayer].box.Filled = false
                end
                
                local headPos = workspace.CurrentCamera:WorldToViewportPoint(head.Position)
                local rootPos = workspace.CurrentCamera:WorldToViewportPoint(rootPart.Position)
                
                local size = Vector2.new(2000 / rootPos.Z, 3000 / rootPos.Z)
                local position = Vector2.new(headPos.X - size.X / 2, headPos.Y - size.Y / 2)
                
                espObjects[otherPlayer].box.Size = size
                espObjects[otherPlayer].box.Position = position
                espObjects[otherPlayer].box.Visible = true
            elseif espObjects[otherPlayer].box then
                espObjects[otherPlayer].box.Visible = false
            end
            
            -- Health ESP
            if espHealthEnabled then
                if not espObjects[otherPlayer].health then
                    espObjects[otherPlayer].health = Drawing.new("Text")
                    espObjects[otherPlayer].health.Size = 14
                    espObjects[otherPlayer].health.Center = true
                    espObjects[otherPlayer].health.Outline = true
                    espObjects[otherPlayer].health.Color = Color3.fromRGB(255, 0, 0)
                end
                
                local headPos = workspace.CurrentCamera:WorldToViewportPoint(head.Position)
                espObjects[otherPlayer].health.Position = Vector2.new(headPos.X, headPos.Y - 40)
                espObjects[otherPlayer].health.Text = "HP: " .. math.floor(humanoid.Health)
                espObjects[otherPlayer].health.Visible = true
            elseif espObjects[otherPlayer].health then
                espObjects[otherPlayer].health.Visible = false
            end
            
            -- Distance ESP
            if espDistanceEnabled then
                if not espObjects[otherPlayer].distance then
                    espObjects[otherPlayer].distance = Drawing.new("Text")
                    espObjects[otherPlayer].distance.Size = 14
                    espObjects[otherPlayer].distance.Center = true
                    espObjects[otherPlayer].distance.Outline = true
                    espObjects[otherPlayer].distance.Color = Color3.fromRGB(255, 0, 0)
                end
                
                local headPos = workspace.CurrentCamera:WorldToViewportPoint(head.Position)
                local distance = (player.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
                espObjects[otherPlayer].distance.Position = Vector2.new(headPos.X, headPos.Y - 60)
                espObjects[otherPlayer].distance.Text = "Distance: " .. math.floor(distance)
                espObjects[otherPlayer].distance.Visible = true
            elseif espObjects[otherPlayer].distance then
                espObjects[otherPlayer].distance.Visible = false
            end
        else
            if espObjects[otherPlayer].tracer then espObjects[otherPlayer].tracer.Visible = false end
            if espObjects[otherPlayer].box then espObjects[otherPlayer].box.Visible = false end
            if espObjects[otherPlayer].health then espObjects[otherPlayer].health.Visible = false end
            if espObjects[otherPlayer].distance then espObjects[otherPlayer].distance.Visible = false end
        end
    end
    
    espConnections[otherPlayer] = RunService.Heartbeat:Connect(updateESP)
    
    otherPlayer.AncestryChanged:Connect(function()
        if not otherPlayer.Parent then
            cleanupESP(otherPlayer)
        end
    end)
end

-- ESP Count Function
local function updateESPCount()
    if not espCountEnabled or not espCountText then return end
    
    local aliveCount = 0
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("Humanoid") and otherPlayer.Character.Humanoid.Health > 0 then
            aliveCount = aliveCount + 1
        end
    end
    
    espCountText.Text = "Players: " .. aliveCount
    espCountText.Visible = true
end

-- Improved AimBot with wall check and FOV
local function isPlayerVisible(targetPlayer)
    if not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return false
    end
    
    local targetRoot = targetPlayer.Character.HumanoidRootPart
    local camera = workspace.CurrentCamera
    local origin = camera.CFrame.Position
    
    local direction = (targetRoot.Position - origin).Unit
    local ray = Ray.new(origin, direction * 1000)
    
    local ignoreList = {player.Character, camera}
    local hit, hitPosition = workspace:FindPartOnRayWithIgnoreList(ray, ignoreList)
    
    if hit then
        local hitModel = hit:FindFirstAncestorOfClass("Model")
        if hitModel and hitModel == targetPlayer.Character then
            return true
        end
    end
    
    return false
end

-- Check if target is within FOV circle
local function isInFOV(targetPosition)
    local camera = workspace.CurrentCamera
    local screenPoint, onScreen = camera:WorldToViewportPoint(targetPosition)
    
    if not onScreen then return false end
    
    local center = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    local targetPoint = Vector2.new(screenPoint.X, screenPoint.Y)
    local distance = (targetPoint - center).Magnitude
    
    return distance <= aimBotFOV
end

-- Функции из второго скрипта
-- Kill Aura функция
local function RunKillAura()
    while ActiveKillAura do
        pcall(function()
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
        end)
        wait(0.1)
    end
end

-- Auto Chop функция
local function RunAutoChop()
    while ActiveAutoChopTree do
        pcall(function()
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
        end)
        wait(0.1)
    end
end

-- Bring Items функция
local function BringItems(itemName)
    pcall(function()
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
    end)
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

-- Создание Rayfield Window
local Window = Rayfield:CreateWindow({
    Name = "SANSTRO Menu | 99 Nights",
    LoadingTitle = "SANSTRO Menu Loading...",
    LoadingSubtitle = "by SANSTRO",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "SANSTRO_Config",
        FileName = "Settings"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false,
})

-- Вкладка Movement
local MovementTab = Window:CreateTab("Movement", "rbxassetid://4483345998")

local SpeedToggle = MovementTab:CreateToggle({
    Name = "Speed Hack",
    CurrentValue = speedHackEnabled,
    Flag = "SpeedToggle",
    Callback = function(Value)
        speedHackEnabled = Value
        if speedHackEnabled then
            local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = currentSpeed
            end
        else
            local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 16
            end
        end
    end,
})

MovementTab:CreateSlider({
    Name = "Speed Value",
    Range = {16, 100},
    Increment = 1,
    Suffix = "Speed",
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

MovementTab:CreateToggle({
    Name = "Jump Hack",
    CurrentValue = jumpHackEnabled,
    Flag = "JumpToggle",
    Callback = function(Value)
        jumpHackEnabled = Value
    end,
})

MovementTab:CreateToggle({
    Name = "NoClip",
    CurrentValue = noclipEnabled,
    Flag = "NoClipToggle",
    Callback = function(Value)
        noclipEnabled = Value
        
        if noclipEnabled then
            if noclipConnection then
                noclipConnection:Disconnect()
            end
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
                noclipConnection = nil
            end
            
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

-- Вкладка Visual
local VisualTab = Window:CreateTab("Visual", "rbxassetid://4483345998")

VisualTab:CreateToggle({
    Name = "ESP Tracers",
    CurrentValue = espTracersEnabled,
    Flag = "TracersToggle",
    Callback = function(Value)
        espTracersEnabled = Value
    end,
})

VisualTab:CreateToggle({
    Name = "ESP Box",
    CurrentValue = espBoxEnabled,
    Flag = "BoxToggle",
    Callback = function(Value)
        espBoxEnabled = Value
    end,
})

VisualTab:CreateToggle({
    Name = "ESP Health",
    CurrentValue = espHealthEnabled,
    Flag = "HealthToggle",
    Callback = function(Value)
        espHealthEnabled = Value
    end,
})

VisualTab:CreateToggle({
    Name = "ESP Distance",
    CurrentValue = espDistanceEnabled,
    Flag = "DistanceToggle",
    Callback = function(Value)
        espDistanceEnabled = Value
    end,
})

VisualTab:CreateToggle({
    Name = "ESP Count",
    CurrentValue = espCountEnabled,
    Flag = "CountToggle",
    Callback = function(Value)
        espCountEnabled = Value
        
        if espCountEnabled then
            if not espCountText then
                espCountText = Drawing.new("Text")
                espCountText.Size = 16
                espCountText.Center = true
                espCountText.Outline = true
                espCountText.Color = Color3.fromRGB(255, 0, 0)
                espCountText.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, 80)
            end
            espCountText.Visible = true
        else
            if espCountText then
                espCountText.Visible = false
            end
        end
    end,
})

-- Вкладка AimBot
local AimBotTab = Window:CreateTab("AimBot", "rbxassetid://4483345998")

AimBotTab:CreateToggle({
    Name = "AimBot",
    CurrentValue = aimBotEnabled,
    Flag = "AimBotToggle",
    Callback = function(Value)
        aimBotEnabled = Value
        
        if fovCircle then
            fovCircle.Visible = aimBotEnabled
        else
            createFOVCircle()
            fovCircle.Visible = aimBotEnabled
        end
    end,
})

AimBotTab:CreateSlider({
    Name = "AimBot FOV",
    Range = {10, 200},
    Increment = 1,
    Suffix = "FOV",
    CurrentValue = aimBotFOV,
    Flag = "AimBotFOV",
    Callback = function(Value)
        aimBotFOV = math.floor(Value)
        updateFOVCircle()
    end,
})

-- Вкладка 99 Nights
local NightsTab = Window:CreateTab("99 Nights", "rbxassetid://4483345998")

NightsTab:CreateToggle({
    Name = "Kill Aura",
    CurrentValue = ActiveKillAura,
    Flag = "KillAuraToggle",
    Callback = function(Value)
        ActiveKillAura = Value
        SaveSettings()
    end,
})

NightsTab:CreateSlider({
    Name = "Kill Aura Distance",
    Range = {10, 150},
    Increment = 1,
    Suffix = "Studs",
    CurrentValue = DistanceForKillAura,
    Flag = "KillAuraDistance",
    Callback = function(Value)
        DistanceForKillAura = Value
        SaveSettings()
    end,
})

NightsTab:CreateToggle({
    Name = "Auto Chop Trees",
    CurrentValue = ActiveAutoChopTree,
    Flag = "AutoChopToggle",
    Callback = function(Value)
        ActiveAutoChopTree = Value
        SaveSettings()
    end,
})

NightsTab:CreateSlider({
    Name = "Auto Chop Distance",
    Range = {10, 150},
    Increment = 1,
    Suffix = "Studs",
    CurrentValue = DistanceForAutoChopTree,
    Flag = "AutoChopDistance",
    Callback = function(Value)
        DistanceForAutoChopTree = Value
        SaveSettings()
    end,
})

NightsTab:CreateSlider({
    Name = "Bring Items Count",
    Range = {1, 20},
    Increment = 1,
    Suffix = "Items",
    CurrentValue = BringCount,
    Flag = "BringCount",
    Callback = function(Value)
        BringCount = math.floor(Value)
        SaveSettings()
    end,
})

NightsTab:CreateSlider({
    Name = "Bring Items Delay",
    Range = {50, 500},
    Increment = 10,
    Suffix = "ms",
    CurrentValue = BringDelay,
    Flag = "BringDelay",
    Callback = function(Value)
        BringDelay = math.floor(Value)
        SaveSettings()
    end,
})

NightsTab:CreateButton({
    Name = "Teleport to Campfire",
    Callback = function()
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(CampfirePosition)
        end
    end,
})

-- Секция Bring Items
NightsTab:CreateSection("Bring Resources")

local resourcesItems = {"Logs", "Coal", "Chair", "Fuel Canister", "Oil Barrel"}
for _, itemName in pairs(resourcesItems) do
    NightsTab:CreateButton({
        Name = "Bring " .. itemName,
        Callback = function()
            BringItems(itemName)
        end,
    })
end

NightsTab:CreateSection("Bring Metals")

local metalsItems = {"Bolt", "Sheet Metal", "Old Radio", "Scrap Metal", "UFO Scrap", "Broken Microwave"}
for _, itemName in pairs(metalsItems) do
    NightsTab:CreateButton({
        Name = "Bring " .. itemName,
        Callback = function()
            BringItems(itemName)
        end,
    })
end

NightsTab:CreateSection("Bring Food & Medical")

local foodMedItems = {"Carrot", "Pumpkin", "Morsel", "Steak", "MedKit", "Bandage"}
for _, itemName in pairs(foodMedItems) do
    NightsTab:CreateButton({
        Name = "Bring " .. itemName,
        Callback = function()
            BringItems(itemName)
        end,
    })
end

NightsTab:CreateSection("Bring Weapons")

local weaponsItems = {"Rifle", "Rifle Ammo", "Revolver", "Revolver Ammo"}
for _, itemName in pairs(weaponsItems) do
    NightsTab:CreateButton({
        Name = "Bring " .. itemName,
        Callback = function()
            BringItems(itemName)
        end,
    })
end

NightsTab:CreateSection("Bring Axes")

local axeItems = {"Good Axe", "Strong Axe", "Chainsaw"}
for _, itemName in pairs(axeItems) do
    NightsTab:CreateButton({
        Name = "Bring " .. itemName,
        Callback = function()
            BringItems(itemName)
        end,
    })
end

-- Инициализация ESP для существующих игроков
for _, otherPlayer in pairs(Players:GetPlayers()) do
    createESP(otherPlayer)
end

Players.PlayerAdded:Connect(function(newPlayer)
    createESP(newPlayer)
end)

Players.PlayerRemoving:Connect(function(leftPlayer)
    cleanupESP(leftPlayer)
end)

RunService.Heartbeat:Connect(updateESPCount)

workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
    if espCountText then
        espCountText.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, 80)
    end
end)

-- AimBot Loop
RunService.Heartbeat:Connect(function()
    if aimBotEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local closestPlayer = nil
        local closestDistance = 1000
        
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") and otherPlayer.Character:FindFirstChild("Humanoid") and otherPlayer.Character.Humanoid.Health > 0 then
                local targetRoot = otherPlayer.Character.HumanoidRootPart
                local distance = (player.Character.HumanoidRootPart.Position - targetRoot.Position).Magnitude
                
                if isInFOV(targetRoot.Position) and isPlayerVisible(otherPlayer) then
                    if distance < closestDistance then
                        closestDistance = distance
                        closestPlayer = otherPlayer
                    end
                end
            end
        end
        
        if closestPlayer then
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, closestPlayer.Character.HumanoidRootPart.Position)
        end
    end
end)

-- Jump Hack обработка
UserInputService.JumpRequest:Connect(function()
    if jumpHackEnabled and player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Создаем FOV Circle при запуске
createFOVCircle()

-- Notify user
Rayfield:Notify({
    Title = "SANSTRO Menu Loaded",
    Content = "99 Nights menu successfully loaded!",
    Duration = 5,
    Image = "rbxassetid://4483345998",
})

-- Загружаем конфигурацию Rayfield
Rayfield:LoadConfiguration()

print("SANSTRO Menu for 99 Nights successfully loaded!")