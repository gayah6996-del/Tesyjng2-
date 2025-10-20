-- SANSTRO Menu for Mobile with Rayfield
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
local espTracersEnabled = false
local espBoxEnabled = false
local espHealthEnabled = false
local espDistanceEnabled = false
local espCountEnabled = false
local aimBotEnabled = false
local currentSpeed = 16
local aimBotFOV = 50

-- 99 Nights переменные
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

-- Загрузка Rayfield
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

-- Создание основного окна
local Window = Rayfield:CreateWindow({
   Name = "SANSTRO Menu",
   LoadingTitle = "SANSTRO Menu Loading...",
   LoadingSubtitle = "by SANSTRO",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "SANSTRO",
      FileName = "Config"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = false,
})

-- Gun Game Tab
local GunGameTab = Window:CreateTab("Gun Game", "rbxassetid://4483345998")

-- Movement Section
local MovementSection = GunGameTab:CreateSection("Movement")

local SpeedToggle = MovementSection:CreateToggle({
    Name = "Speed Hack",
    CurrentValue = false,
    Callback = function(Value)
        speedHackEnabled = Value
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            if Value then
                player.Character.Humanoid.WalkSpeed = currentSpeed
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
    CurrentValue = 16,
    Callback = function(Value)
        currentSpeed = Value
        if speedHackEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = Value
        end
    end,
})

local JumpToggle = MovementSection:CreateToggle({
    Name = "Jump Hack",
    CurrentValue = false,
    Callback = function(Value)
        jumpHackEnabled = Value
    end,
})

local NoClipToggle = MovementSection:CreateToggle({
    Name = "NoClip",
    CurrentValue = false,
    Callback = function(Value)
        noclipEnabled = Value
        if Value then
            if noclipConnection then noclipConnection:Disconnect() end
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
        end
    end,
})

-- Visual Section
local VisualSection = GunGameTab:CreateSection("Visual")

local TracerToggle = VisualSection:CreateToggle({
    Name = "ESP Tracers",
    CurrentValue = false,
    Callback = function(Value)
        espTracersEnabled = Value
        if not Value then
            for _, espData in pairs(espObjects) do
                if espData.tracer then
                    espData.tracer.Visible = false
                end
            end
        end
    end,
})

local BoxToggle = VisualSection:CreateToggle({
    Name = "ESP Box",
    CurrentValue = false,
    Callback = function(Value)
        espBoxEnabled = Value
        if not Value then
            for _, espData in pairs(espObjects) do
                if espData.box then
                    espData.box.Visible = false
                end
            end
        end
    end,
})

local HealthToggle = VisualSection:CreateToggle({
    Name = "ESP Health",
    CurrentValue = false,
    Callback = function(Value)
        espHealthEnabled = Value
        if not Value then
            for _, espData in pairs(espObjects) do
                if espData.health then
                    espData.health.Visible = false
                end
            end
        end
    end,
})

local DistanceToggle = VisualSection:CreateToggle({
    Name = "ESP Distance",
    CurrentValue = false,
    Callback = function(Value)
        espDistanceEnabled = Value
        if not Value then
            for _, espData in pairs(espObjects) do
                if espData.distance then
                    espData.distance.Visible = false
                end
            end
        end
    end,
})

local CountToggle = VisualSection:CreateToggle({
    Name = "ESP Count",
    CurrentValue = false,
    Callback = function(Value)
        espCountEnabled = Value
        if Value then
            if not espCountText then
                espCountText = Drawing.new("Text")
                espCountText.Size = 16
                espCountText.Center = true
                espCountText.Outline = true
                espCountText.Color = Color3.fromRGB(255, 0, 0)
                espCountText.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, 80)
            end
            espCountText.Visible = true
        elseif espCountText then
            espCountText.Visible = false
        end
    end,
})

-- AimBot Section
local AimBotSection = GunGameTab:CreateSection("AimBot")

local AimBotToggle = AimBotSection:CreateToggle({
    Name = "AimBot",
    CurrentValue = false,
    Callback = function(Value)
        aimBotEnabled = Value
        if Value then
            if not fovCircle then
                fovCircle = Drawing.new("Circle")
                fovCircle.Visible = true
                fovCircle.Color = Color3.fromRGB(255, 0, 0)
                fovCircle.Thickness = 1
                fovCircle.Filled = false
                fovCircle.Radius = aimBotFOV
                fovCircle.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)
            else
                fovCircle.Visible = true
            end
        elseif fovCircle then
            fovCircle.Visible = false
        end
    end,
})

local FOVSlider = AimBotSection:CreateSlider({
    Name = "AimBot FOV",
    Range = {10, 200},
    Increment = 1,
    Suffix = "radius",
    CurrentValue = 50,
    Callback = function(Value)
        aimBotFOV = Value
        if fovCircle then
            fovCircle.Radius = Value
        end
    end,
})

-- 99 Nights Tab
local NightsTab = Window:CreateTab("99 Nights", "rbxassetid://4483345998")

-- Main Features Section
local MainSection = NightsTab:CreateSection("Main Features")

local KillAuraToggle = MainSection:CreateToggle({
    Name = "Kill Aura",
    CurrentValue = false,
    Callback = function(Value)
        ActiveKillAura = Value
    end,
})

local KillDistanceSlider = MainSection:CreateSlider({
    Name = "Kill Distance",
    Range = {10, 150},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = 25,
    Callback = function(Value)
        DistanceForKillAura = Value
    end,
})

local AutoChopToggle = MainSection:CreateToggle({
    Name = "Auto Chop",
    CurrentValue = false,
    Callback = function(Value)
        ActiveAutoChopTree = Value
    end,
})

local ChopDistanceSlider = MainSection:CreateSlider({
    Name = "Chop Distance",
    Range = {10, 150},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = 25,
    Callback = function(Value)
        DistanceForAutoChopTree = Value
    end,
})

-- Bring Items Section
local BringSection = NightsTab:CreateSection("Bring Items")

local BringCountSlider = BringSection:CreateSlider({
    Name = "Bring Count",
    Range = {1, 20},
    Increment = 1,
    Suffix = "items",
    CurrentValue = 5,
    Callback = function(Value)
        BringCount = Value
    end,
})

local BringSpeedSlider = BringSection:CreateSlider({
    Name = "Bring Speed",
    Range = {50, 500},
    Increment = 10,
    Suffix = "ms",
    CurrentValue = 200,
    Callback = function(Value)
        BringDelay = Value
    end,
})

local TeleportButton = BringSection:CreateButton({
    Name = "Teleport to Campfire",
    Callback = function()
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(CampfirePosition)
        end
    end,
})

-- Resources Section
local ResourcesSection = NightsTab:CreateSection("Resources")

local resourcesItems = {"Logs", "Coal", "Chair", "Fuel Canister", "Oil Barrel"}
for _, itemName in pairs(resourcesItems) do
    ResourcesSection:CreateButton({
        Name = "Bring " .. itemName,
        Callback = function()
            -- Bring Items функция
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
        end,
    })
end

-- Metals Section
local MetalsSection = NightsTab:CreateSection("Metals")

local metalsItems = {"Bolt", "Sheet Metal", "Old Radio", "Scrap Metal", "UFO Scrap", "Broken Microwave"}
for _, itemName in pairs(metalsItems) do
    MetalsSection:CreateButton({
        Name = "Bring " .. itemName,
        Callback = function()
            -- Bring Items функция
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
        end,
    })
end

-- Food & Medical Section
local FoodMedSection = NightsTab:CreateSection("Food & Medical")

local foodMedItems = {"Carrot", "Pumpkin", "Morsel", "Steak", "MedKit", "Bandage"}
for _, itemName in pairs(foodMedItems) do
    FoodMedSection:CreateButton({
        Name = "Bring " .. itemName,
        Callback = function()
            -- Bring Items функция
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
        end,
    })
end

-- Weapons Section
local WeaponsSection = NightsTab:CreateSection("Weapons")

local weaponsItems = {"Rifle", "Rifle Ammo", "Revolver", "Revolver Ammo"}
for _, itemName in pairs(weaponsItems) do
    WeaponsSection:CreateButton({
        Name = "Bring " .. itemName,
        Callback = function()
            -- Bring Items функция
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
        end,
    })
end

-- Axes Section
local AxeSection = NightsTab:CreateSection("Axes")

local axeItems = {"Good Axe", "Strong Axe", "Chainsaw"}
for _, itemName in pairs(axeItems) do
    AxeSection:CreateButton({
        Name = "Bring " .. itemName,
        Callback = function()
            -- Bring Items функция
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
        end,
    })
end

-- ESP Functions
local function createESP(otherPlayer)
    if otherPlayer == player then return end
    
    espObjects[otherPlayer] = {
        tracer = Drawing.new("Line"),
        box = Drawing.new("Square"),
        health = Drawing.new("Text"),
        distance = Drawing.new("Text")
    }
    
    espObjects[otherPlayer].tracer.Thickness = 1
    espObjects[otherPlayer].tracer.Color = Color3.fromRGB(255, 0, 0)
    
    espObjects[otherPlayer].box.Thickness = 1
    espObjects[otherPlayer].box.Color = Color3.fromRGB(255, 0, 0)
    espObjects[otherPlayer].box.Filled = false
    
    espObjects[otherPlayer].health.Size = 14
    espObjects[otherPlayer].health.Center = true
    espObjects[otherPlayer].health.Outline = true
    espObjects[otherPlayer].health.Color = Color3.fromRGB(255, 0, 0)
    
    espObjects[otherPlayer].distance.Size = 14
    espObjects[otherPlayer].distance.Center = true
    espObjects[otherPlayer].distance.Outline = true
    espObjects[otherPlayer].distance.Color = Color3.fromRGB(255, 0, 0)
    
    espConnections[otherPlayer] = RunService.Heartbeat:Connect(function()
        if not otherPlayer.Character or not otherPlayer.Character:FindFirstChild("HumanoidRootPart") or not otherPlayer.Character:FindFirstChild("Humanoid") then
            espObjects[otherPlayer].tracer.Visible = false
            espObjects[otherPlayer].box.Visible = false
            espObjects[otherPlayer].health.Visible = false
            espObjects[otherPlayer].distance.Visible = false
            return
        end
        
        local rootPart = otherPlayer.Character.HumanoidRootPart
        local humanoid = otherPlayer.Character.Humanoid
        local head = otherPlayer.Character:FindFirstChild("Head")
        
        if not head or humanoid.Health <= 0 then
            espObjects[otherPlayer].tracer.Visible = false
            espObjects[otherPlayer].box.Visible = false
            espObjects[otherPlayer].health.Visible = false
            espObjects[otherPlayer].distance.Visible = false
            return
        end
        
        local vector, onScreen = workspace.CurrentCamera:WorldToViewportPoint(rootPart.Position)
        
        if onScreen then
            -- Tracer
            if espTracersEnabled then
                local screenCenter = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y)
                espObjects[otherPlayer].tracer.From = screenCenter
                espObjects[otherPlayer].tracer.To = Vector2.new(vector.X, vector.Y)
                espObjects[otherPlayer].tracer.Visible = true
            else
                espObjects[otherPlayer].tracer.Visible = false
            end
            
            -- Box ESP
            if espBoxEnabled then
                local headPos = workspace.CurrentCamera:WorldToViewportPoint(head.Position)
                local size = Vector2.new(2000 / vector.Z, 3000 / vector.Z)
                local position = Vector2.new(headPos.X - size.X / 2, headPos.Y - size.Y / 2)
                
                espObjects[otherPlayer].box.Size = size
                espObjects[otherPlayer].box.Position = position
                espObjects[otherPlayer].box.Visible = true
            else
                espObjects[otherPlayer].box.Visible = false
            end
            
            -- Health ESP
            if espHealthEnabled then
                local headPos = workspace.CurrentCamera:WorldToViewportPoint(head.Position)
                espObjects[otherPlayer].health.Position = Vector2.new(headPos.X, headPos.Y - 40)
                espObjects[otherPlayer].health.Text = "HP: " .. math.floor(humanoid.Health)
                espObjects[otherPlayer].health.Visible = true
            else
                espObjects[otherPlayer].health.Visible = false
            end
            
            -- Distance ESP
            if espDistanceEnabled then
                local headPos = workspace.CurrentCamera:WorldToViewportPoint(head.Position)
                local distance = (player.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
                espObjects[otherPlayer].distance.Position = Vector2.new(headPos.X, headPos.Y - 60)
                espObjects[otherPlayer].distance.Text = "Dist: " .. math.floor(distance)
                espObjects[otherPlayer].distance.Visible = true
            else
                espObjects[otherPlayer].distance.Visible = false
            end
        else
            espObjects[otherPlayer].tracer.Visible = false
            espObjects[otherPlayer].box.Visible = false
            espObjects[otherPlayer].health.Visible = false
            espObjects[otherPlayer].distance.Visible = false
        end
    end)
end

-- Initialize ESP
for _, otherPlayer in pairs(Players:GetPlayers()) do
    if otherPlayer ~= player then
        createESP(otherPlayer)
    end
end

Players.PlayerAdded:Connect(function(newPlayer)
    createESP(newPlayer)
end)

Players.PlayerRemoving:Connect(function(leftPlayer)
    if espObjects[leftPlayer] then
        espObjects[leftPlayer].tracer:Remove()
        espObjects[leftPlayer].box:Remove()
        espObjects[leftPlayer].health:Remove()
        espObjects[leftPlayer].distance:Remove()
        espObjects[leftPlayer] = nil
    end
    if espConnections[leftPlayer] then
        espConnections[leftPlayer]:Disconnect()
        espConnections[leftPlayer] = nil
    end
end)

-- ESP Count Update
RunService.Heartbeat:Connect(function()
    if espCountEnabled and espCountText then
        local aliveCount = 0
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("Humanoid") and otherPlayer.Character.Humanoid.Health > 0 then
                aliveCount = aliveCount + 1
            end
        end
        espCountText.Text = "Players: " .. aliveCount
    end
end)

-- Jump Hack
UserInputService.JumpRequest:Connect(function()
    if jumpHackEnabled and player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

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

-- AimBot functionality
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

local function isInFOV(targetPosition)
    local camera = workspace.CurrentCamera
    local screenPoint, onScreen = camera:WorldToViewportPoint(targetPosition)
    
    if not onScreen then return false end
    
    local center = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    local targetPoint = Vector2.new(screenPoint.X, screenPoint.Y)
    local distance = (targetPoint - center).Magnitude
    
    return distance <= aimBotFOV
end

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

Rayfield:LoadConfiguration()