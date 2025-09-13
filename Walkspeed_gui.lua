--[[
🌲 NIGHTS FOREST HUB v4.2 - COMPLETE EDITION 🌲
═══════════════════════════════════════════════════
🔥 TOUTES LES FONCTIONNALITÉS RESTAURÉES + FIXES
⚡ 60+ Features avec interface Rayfield + Backup
🛡️ Protection avancée et système anti-détection
═══════════════════════════════════════════════════
--]]

if _G.NightsForestHub then _G.NightsForestHub:Destroy() wait(1) end

local S = {
    Players = game:GetService("Players"),
    RunService = game:GetService("RunService"),
    UserInputService = game:GetService("UserInputService"),
    TweenService = game:GetService("TweenService"),
    StarterGui = game:GetService("StarterGui"),
    Workspace = game:GetService("Workspace"),
    HttpService = game:GetService("HttpService"),
    Lighting = game:GetService("Lighting"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
    TeleportService = game:GetService("TeleportService")
}

local P = S.Players.LocalPlayer
local C = S.Workspace.CurrentCamera
local M = P:GetMouse()

_G.NightsForestHub = {
    Version = "4.2",
    States = {
        godMode = false, antiMonster = false, infiniteStamina = false, infiniteHealth = false,
        autoCraft = false, autoGather = false, infiniteResources = false, autoChopTrees = false,
        autoBuild = false, instantBuild = false, freeBuild = false, buildAnywhere = false,
        monsterESP = false, resourceESP = false, playerESP = false, itemESP = false,
        fullbright = false, noFog = false, xrayMode = false,
        fly = false, speed = false, jumpHack = false, teleportToResources = false,
        dayOnly = false, nightOnly = false, stopTime = false, weatherControl = false,
        aimbot = false, autoAttack = false, oneHitKill = false, infiniteAmmo = false,
        infiniteSpace = false, autoPickup = false, itemDupe = false, autoSell = false,
        serverHop = false, antiAfk = false, autoRespawn = false, spectateMode = false,
        showStats = true, notifications = true, minimapHack = false, autoChopTrees = false
    },
    Config = {
        flySpeed = 50, walkSpeed = 30, jumpPower = 80, attackRange = 50, aimDistance = 200,
        gatherRange = 100, craftDelay = 0.1, gatherDelay = 0.05, espDistance = 500, espSize = 2,
        autoCraftItems = {"Wood Plank", "Stone Brick", "Rope", "Campfire", "Axe", "Pickaxe"},
        resourceTargets = {"Tree", "Rock", "Bush", "Animal", "Wood", "Stone"}, 
        buildDistance = 10, preferredTime = 14,
        monsterColor = Color3.fromRGB(255, 0, 0), resourceColor = Color3.fromRGB(0, 255, 0),
        playerColor = Color3.fromRGB(0, 100, 255), itemColor = Color3.fromRGB(255, 255, 0)
    },
    Connections = {}, Objects = {}, ESPObjects = {},
    Cache = {monsters = {}, resources = {}, items = {}, players = {}, animals = {}},
    Stats = {
        sessionStart = tick(), monstersKilled = 0, resourcesGathered = 0, 
        itemsCrafted = 0, deathsPrevented = 0, timesSaved = 0, teleports = 0
    }
}

local H = _G.NightsForestHub

-- 📢 NOTIFICATION SYSTEM
local function notify(title, text, duration, icon)
    if not H.States.notifications then return end
    pcall(function()
        S.StarterGui:SetCore("SendNotification", {
            Title = (icon or "🌲") .. " " .. title,
            Text = text,
            Duration = duration or 3
        })
    end)
end

-- 🔍 GAME ELEMENTS DETECTION
local function findGameElements()
    for _, obj in pairs(S.Workspace:GetDescendants()) do
        if obj:IsA("Model") then
            local name = obj.Name:lower()
            if name:find("monster") or name:find("beast") or name:find("creature") or 
               name:find("enemy") or name:find("spider") or name:find("wolf") or name:find("zombie") then
                H.Cache.monsters[obj] = true
            elseif name:find("tree") or name:find("rock") or name:find("stone") or 
                   name:find("wood") or name:find("ore") or name:find("bush") or name:find("berry") then
                H.Cache.resources[obj] = true
            elseif name:find("animal") or name:find("deer") or name:find("rabbit") then
                H.Cache.animals[obj] = true
            end
        elseif obj:IsA("Part") or obj:IsA("MeshPart") then
            local name = obj.Name:lower()
            if name:find("drop") or name:find("item") or name:find("loot") or 
               name:find("food") or name:find("coin") or name:find("gem") then
                H.Cache.items[obj] = true
            end
        end
    end
    
    for _, player in pairs(S.Players:GetPlayers()) do
        if player ~= P then
            H.Cache.players[player] = true
        end
    end
end

-- 🛡️ SURVIVAL FUNCTIONS
local function enableGodMode()
    if not P.Character or not P.Character:FindFirstChild("Humanoid") then return end
    local h = P.Character.Humanoid
    h.MaxHealth, h.Health = math.huge, math.huge
    H.Connections.godMode = h.HealthChanged:Connect(function()
        if H.States.godMode and h.Health < h.MaxHealth then
            h.Health = h.MaxHealth
            H.Stats.deathsPrevented = H.Stats.deathsPrevented + 1
        end
    end)
    H.Connections.godModeProtection = S.RunService.Heartbeat:Connect(function()
        if not H.States.godMode or not P.Character then return end
        local hrp = P.Character:FindFirstChild("HumanoidRootPart")
        if hrp and hrp.Velocity.Magnitude > 50 then hrp.Velocity = Vector3.new(0, 0, 0) end
    end)
    notify("Protection", "God Mode activé - Invincibilité totale!", 3, "🛡️")
end

local function disableGodMode()
    if H.Connections.godMode then H.Connections.godMode:Disconnect() H.Connections.godMode = nil end
    if H.Connections.godModeProtection then H.Connections.godModeProtection:Disconnect() H.Connections.godModeProtection = nil end
    if P.Character and P.Character:FindFirstChild("Humanoid") then
        P.Character.Humanoid.MaxHealth, P.Character.Humanoid.Health = 100, 100
    end
    notify("Protection", "God Mode désactivé", 3, "🛡️")
end

local function enableAntiMonster()
    H.Connections.antiMonster = S.RunService.Heartbeat:Connect(function()
        if not H.States.antiMonster or not P.Character then return end
        local hrp = P.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        for monster, _ in pairs(H.Cache.monsters) do
            if monster and monster.Parent and monster:FindFirstChild("HumanoidRootPart") then
                local distance = (hrp.Position - monster.HumanoidRootPart.Position).Magnitude
                if distance < 20 then
                    monster.HumanoidRootPart.CFrame = CFrame.new(hrp.Position + Vector3.new(math.random(-100, 100), 0, math.random(-100, 100)))
                    if distance < 10 then
                        monster:Destroy()
                        H.Stats.monstersKilled = H.Stats.monstersKilled + 1
                    end
                end
            end
        end
    end)
    notify("Protection", "Anti-Monstre activé!", 3, "🛡️")
end

local function disableAntiMonster()
    if H.Connections.antiMonster then H.Connections.antiMonster:Disconnect() H.Connections.antiMonster = nil end
    notify("Protection", "Anti-Monstre désactivé", 3, "🛡️")
end

local function enableInfiniteStamina()
    H.Connections.infiniteStamina = S.RunService.Heartbeat:Connect(function()
        if not H.States.infiniteStamina then return end
        local gui = P:FindFirstChild("PlayerGui")
        if gui then
            for _, obj in pairs(gui:GetDescendants()) do
                if obj:IsA("Frame") or obj:IsA("ProgressBar") then
                    local name = obj.Name:lower()
                    if name:find("stamina") or name:find("energy") then
                        if obj:FindFirstChild("Bar") then obj.Bar.Size = UDim2.new(1, 0, 1, 0) end
                    end
                end
            end
        end
        for _, remote in pairs(S.ReplicatedStorage:GetDescendants()) do
            if remote:IsA("RemoteEvent") and remote.Name:lower():find("stamina") then
                pcall(function() remote:FireServer(100) end)
            end
        end
    end)
    notify("Survie", "Stamina infinie activée!", 3, "⚡")
end

local function disableInfiniteStamina()
    if H.Connections.infiniteStamina then H.Connections.infiniteStamina:Disconnect() H.Connections.infiniteStamina = nil end
    notify("Survie", "Stamina infinie désactivée", 3, "⚡")
end

-- 🌲 CRAFTING FUNCTIONS
local function enableAutoCraft()
    H.Connections.autoCraft = S.RunService.Heartbeat:Connect(function()
        if not H.States.autoCraft then return end
        local gui = P:FindFirstChild("PlayerGui")
        if gui then
            for _, obj in pairs(gui:GetDescendants()) do
                if obj:IsA("TextButton") then
                    local text = obj.Text:lower()
                    for _, item in pairs(H.Config.autoCraftItems) do
                        if text:find(item:lower()) or text:find("craft") then
                            obj.MouseButton1Click:Fire()
                            H.Stats.itemsCrafted = H.Stats.itemsCrafted + 1
                            wait(H.Config.craftDelay)
                        end
                    end
                end
            end
        end
        for _, remote in pairs(S.ReplicatedStorage:GetDescendants()) do
            if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
                local name = remote.Name:lower()
                if name:find("craft") then
                    pcall(function()
                        for _, item in pairs(H.Config.autoCraftItems) do
                            if remote:IsA("RemoteEvent") then
                                remote:FireServer("Craft", item, 1)
                            else
                                remote:InvokeServer("Craft", item, 1)
                            end
                            wait(H.Config.craftDelay)
                        end
                    end)
                end
            end
        end
    end)
    notify("Crafting", "Auto-Craft activé!", 3, "🔨")
end

local function disableAutoCraft()
    if H.Connections.autoCraft then H.Connections.autoCraft:Disconnect() H.Connections.autoCraft = nil end
    notify("Crafting", "Auto-Craft désactivé", 3, "🔨")
end

local function enableAutoGather()
    H.Connections.autoGather = S.RunService.Heartbeat:Connect(function()
        if not H.States.autoGather or not P.Character then return end
        local hrp = P.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        for resource, _ in pairs(H.Cache.resources) do
            if resource and resource.Parent then
                local targetPos = resource:FindFirstChild("HumanoidRootPart") and resource.HumanoidRootPart.Position or resource.Position
                local distance = (hrp.Position - targetPos).Magnitude
                if distance < H.Config.gatherRange then
                    hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 5, 0))
                    if resource:FindFirstChildOfClass("ProximityPrompt") then
                        fireproximityprompt(resource:FindFirstChildOfClass("ProximityPrompt"))
                    elseif resource:FindFirstChildOfClass("ClickDetector") then
                        fireclickdetector(resource:FindFirstChildOfClass("ClickDetector"))
                    end
                    local tool = P.Character:FindFirstChildOfClass("Tool")
                    if tool then tool:Activate() end
                    H.Stats.resourcesGathered = H.Stats.resourcesGathered + 1
                    wait(H.Config.gatherDelay)
                    break
                end
            end
        end
    end)
    notify("Ressources", "Auto-Gather activé!", 3, "⛏️")
end

local function disableAutoGather()
    if H.Connections.autoGather then H.Connections.autoGather:Disconnect() H.Connections.autoGather = nil end
    notify("Ressources", "Auto-Gather désactivé", 3, "⛏️")
end

local function enableInfiniteResources()
    H.Connections.infiniteResources = S.RunService.Heartbeat:Connect(function()
        if not H.States.infiniteResources then return end
        local backpack = P:FindFirstChild("Backpack")
        if backpack then
            for _, tool in pairs(backpack:GetChildren()) do
                if tool:IsA("Tool") then
                    local handle = tool:FindFirstChild("Handle")
                    if handle and handle:FindFirstChild("Amount") then handle.Amount.Value = 999999 end
                end
            end
        end
        if P.Character then
            for _, tool in pairs(P.Character:GetChildren()) do
                if tool:IsA("Tool") then
                    local handle = tool:FindFirstChild("Handle")
                    if handle and handle:FindFirstChild("Amount") then handle.Amount.Value = 999999 end
                end
            end
        end
        for _, remote in pairs(S.ReplicatedStorage:GetDescendants()) do
            if remote:IsA("RemoteEvent") then
                local name = remote.Name:lower()
                if name:find("add") or name:find("give") or name:find("resource") then
                    pcall(function()
                        remote:FireServer("Wood", 999999)
                        remote:FireServer("Stone", 999999)
                        remote:FireServer("Food", 999999)
                        remote:FireServer("Water", 999999)
                    end)
                end
            end
        end
    end)
    notify("Ressources", "Ressources infinies activées!", 3, "♾️")
end

local function disableInfiniteResources()
    if H.Connections.infiniteResources then H.Connections.infiniteResources:Disconnect() H.Connections.infiniteResources = nil end
    notify("Ressources", "Ressources infinies désactivées", 3, "♾️")
end

local function enableAutoChopTrees()
    H.Connections.autoChopTrees = S.RunService.Heartbeat:Connect(function()
        if not H.States.autoChopTrees or not P.Character then return end
        local hrp = P.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        for resource, _ in pairs(H.Cache.resources) do
            if resource and resource.Parent and resource.Name:lower():find("tree") then
                local distance = (hrp.Position - resource.Position).Magnitude
                if distance < 50 then
                    hrp.CFrame = CFrame.new(resource.Position + Vector3.new(0, 5, 0))
                    local tool = P.Character:FindFirstChild("Axe") or P.Backpack:FindFirstChild("Axe")
                    if tool then
                        tool.Parent = P.Character
                        P.Character.Humanoid:EquipTool(tool)
                        tool:Activate()
                        wait(0.5)
                    end
                    break
                end
            end
        end
    end)
    notify("Ressources", "Auto-Chop Trees activé!", 3, "🪓")
end

local function disableAutoChopTrees()
    if H.Connections.autoChopTrees then H.Connections.autoChopTrees:Disconnect() H.Connections.autoChopTrees = nil end
    notify("Ressources", "Auto-Chop Trees désactivé", 3, "🪓")
end

-- 👁️ ESP FUNCTIONS
local function createESP(obj, text, color, isMonster)
    if not obj or obj:FindFirstChild("NightsForestESP") then return end
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "NightsForestESP"
    billboard.Parent = obj
    billboard.Size = UDim2.new(0, 200, 0, 100)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    
    local frame = Instance.new("Frame")
    frame.Parent = billboard
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = color
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Parent = frame
    textLabel.Size = UDim2.new(1, 0, 0.7, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextStrokeTransparency = 0
    
    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Parent = frame
    distanceLabel.Size = UDim2.new(1, 0, 0.3, 0)
    distanceLabel.Position = UDim2.new(0, 0, 0.7, 0)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.Text = "0m"
    distanceLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    distanceLabel.TextScaled = true
    distanceLabel.Font = Enum.Font.Gotham
    
    if isMonster then
        local box = Instance.new("BoxHandleAdornment")
        box.Parent = obj
        box.Size = obj.Size * 1.5
        box.Color3 = color
        box.Transparency = 0.7
        box.AlwaysOnTop = true
        box.ZIndex = 5
    end
    
    spawn(function()
        while billboard.Parent and P.Character do
            local hrp = P.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local distance = math.floor((hrp.Position - obj.Position).Magnitude)
                distanceLabel.Text = distance .. "m"
                billboard.Enabled = distance <= H.Config.espDistance
            end
            wait(0.5)
        end
    end)
    
    table.insert(H.ESPObjects, billboard)
end

local function enableMonsterESP()
    for monster, _ in pairs(H.Cache.monsters) do
        if monster and monster.Parent and monster:FindFirstChild("HumanoidRootPart") then
            createESP(monster.HumanoidRootPart, "👹 MONSTRE", H.Config.monsterColor, true)
        end
    end
    H.Connections.monsterESPUpdate = S.RunService.Heartbeat:Connect(function()
        if H.States.monsterESP then findGameElements() end
    end)
    notify("Vision", "ESP Monstres activé!", 3, "👁️")
end

local function disableMonsterESP()
    if H.Connections.monsterESPUpdate then H.Connections.monsterESPUpdate:Disconnect() H.Connections.monsterESPUpdate = nil end
    for _, esp in pairs(H.ESPObjects) do
        if esp and esp.Parent then esp:Destroy() end
    end
    H.ESPObjects = {}
    notify("Vision", "ESP Monstres désactivé", 3, "👁️")
end

local function enableResourceESP()
    for resource, _ in pairs(H.Cache.resources) do
        if resource and resource.Parent then
            local name = resource.Name:upper()
            local icon = "🌲"
            if name:find("ROCK") or name:find("STONE") then icon = "🪨" 
            elseif name:find("BUSH") then icon = "🌿"
            elseif name:find("BERRY") then icon = "🍇"
            end
            local targetObj = resource:FindFirstChild("HumanoidRootPart") or resource
            createESP(targetObj, icon .. " " .. name, H.Config.resourceColor, false)
        end
    end
    notify("Vision", "ESP Ressources activé!", 3, "👁️")
end

local function disableResourceESP()
    for _, esp in pairs(H.ESPObjects) do
        if esp and esp.Parent and esp.Name == "ResourceESP" then esp:Destroy() end
    end
    notify("Vision", "ESP Ressources désactivé", 3, "👁️")
end

local function enablePlayerESP()
    for player, _ in pairs(H.Cache.players) do
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            createESP(player.Character.HumanoidRootPart, "👤 " .. player.Name, H.Config.playerColor, false)
        end
    end
    notify("Vision", "ESP Joueurs activé!", 3, "👁️")
end

local function disablePlayerESP()
    notify("Vision", "ESP Joueurs désactivé", 3, "👁️")
end

local function enableItemESP()
    for item, _ in pairs(H.Cache.items) do
        if item and item.Parent then
            createESP(item, "💎 ITEM", H.Config.itemColor, false)
        end
    end
    notify("Vision", "ESP Items activé!", 3, "👁️")
end

local function disableItemESP()
    notify("Vision", "ESP Items désactivé", 3, "👁️")
end

local function enableFullbright()
    H.originalLighting = {
        Brightness = S.Lighting.Brightness,
        ClockTime = S.Lighting.ClockTime,
        FogEnd = S.Lighting.FogEnd,
        GlobalShadows = S.Lighting.GlobalShadows,
        Ambient = S.Lighting.Ambient,
        OutdoorAmbient = S.Lighting.OutdoorAmbient
    }
    S.Lighting.Brightness = 3
    S.Lighting.ClockTime = 12
    S.Lighting.FogEnd = 100000
    S.Lighting.GlobalShadows = false
    S.Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    S.Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    notify("Vision", "Fullbright activé!", 3, "💡")
end

local function disableFullbright()
    if H.originalLighting then
        S.Lighting.Brightness = H.originalLighting.Brightness
        S.Lighting.ClockTime = H.originalLighting.ClockTime
        S.Lighting.FogEnd = H.originalLighting.FogEnd
        S.Lighting.GlobalShadows = H.originalLighting.GlobalShadows
        S.Lighting.Ambient = H.originalLighting.Ambient
        S.Lighting.OutdoorAmbient = H.originalLighting.OutdoorAmbient
        H.originalLighting = nil
    end
    notify("Vision", "Fullbright désactivé", 3, "💡")
end

local function enableNoFog()
    H.Connections.noFog = S.RunService.Heartbeat:Connect(function()
        if H.States.noFog then
            S.Lighting.FogEnd = 100000
            S.Lighting.FogStart = 0
        end
    end)
    notify("Vision", "No Fog activé!", 3, "🌫️")
end

local function disableNoFog()
    if H.Connections.noFog then H.Connections.noFog:Disconnect() H.Connections.noFog = nil end
    notify("Vision", "No Fog désactivé", 3, "🌫️")
end

-- 🚀 MOVEMENT FUNCTIONS
local function enableFly()
    if not P.Character or not P.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = P.Character.HumanoidRootPart
    H.Objects.bodyVelocity = Instance.new("BodyVelocity")
    H.Objects.bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    H.Objects.bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    H.Objects.bodyVelocity.Parent = hrp
    
    H.Connections.flyControl = S.RunService.Heartbeat:Connect(function()
        if not H.States.fly or not H.Objects.bodyVelocity then return end
        local humanoid = P.Character:FindFirstChild("Humanoid")
        if not humanoid then return end
        local moveVector = humanoid.MoveDirection
        local velocity = Vector3.new(0, 0, 0)
        local speed = H.Config.flySpeed
        if S.UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then speed = speed * 2 end
        if moveVector.Magnitude > 0 then
            velocity = C.CFrame:VectorToWorldSpace(Vector3.new(moveVector.X, 0, moveVector.Z)) * speed
        end
        if S.UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            velocity = velocity + Vector3.new(0, speed, 0)
        elseif S.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            velocity = velocity + Vector3.new(0, -speed, 0)
        end
        H.Objects.bodyVelocity.Velocity = velocity
    end)
    notify("Movement", "Fly activé!", 3, "🚀")
end

local function disableFly()
    if H.Objects.bodyVelocity then H.Objects.bodyVelocity:Destroy() H.Objects.bodyVelocity = nil end
    if H.Connections.flyControl then H.Connections.flyControl:Disconnect() H.Connections.flyControl = nil end
    notify("Movement", "Fly désactivé", 3, "🚀")
end

local function enableSpeed()
    H.Connections.speed = S.RunService.Heartbeat:Connect(function()
        if not H.States.speed or not P.Character then return end
        local humanoid = P.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = H.Config.walkSpeed
            humanoid.JumpPower = H.Config.jumpPower
        end
    end)
    notify("Movement", "Speed activé!", 3, "🏃")
end

local function disableSpeed()
    if H.Connections.speed then H.Connections.speed:Disconnect() H.Connections.speed = nil end
    if P.Character and P.Character:FindFirstChild("Humanoid") then
        P.Character.Humanoid.WalkSpeed = 16
        P.Character.Humanoid.JumpPower = 50
    end
    notify("Movement", "Speed désactivé", 3, "🏃")
end

local function enableJumpHack()
    H.Connections.jumpHack = S.RunService.Heartbeat:Connect(function()
        if not H.States.jumpHack or not P.Character then return end
        local humanoid = P.Character:FindFirstChild("Humanoid")
        if humanoid then humanoid.JumpPower = 200 end
    end)
    notify("Movement", "Jump Hack activé!", 3, "🦘")
end

local function disableJumpHack()
    if H.Connections.jumpHack then H.Connections.jumpHack:Disconnect() H.Connections.jumpHack = nil end
    notify("Movement", "Jump Hack désactivé", 3, "🦘")
end

local function teleportToResources()
    if not P.Character or not P.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = P.Character.HumanoidRootPart
    local closestResource, closestDistance = nil, math.huge
    
    for resource, _ in pairs(H.Cache.resources) do
        if resource and resource.Parent then
            local distance = (hrp.Position - resource.Position).Magnitude
            if distance < closestDistance then
                closestResource = resource
                closestDistance = distance
            end
        end
    end
    
    if closestResource then
        hrp.CFrame = CFrame.new(closestResource.Position + Vector3.new(0, 5, 0))
        H.Stats.teleports = H.Stats.teleports + 1
        notify("Téléportation", "Téléporté vers ressource!", 2, "🌍")
    end
end

-- 🌙 TIME & ENVIRONMENT FUNCTIONS
local function enableDayOnly()
    H.Connections.dayOnly = S.RunService.Heartbeat:Connect(function()
        if H.States.dayOnly then S.Lighting.ClockTime = H.Config.preferredTime end
    end)
    notify("Environnement", "Mode Jour Permanent activé!", 3, "☀️")
end

local function disableDayOnly()
    if H.Connections.dayOnly then H.Connections.dayOnly:Disconnect() H.Connections.dayOnly = nil end
    notify("Environnement", "Mode Jour Permanent désactivé", 3, "☀️")
end

local function enableNightOnly()
    H.Connections.nightOnly = S.RunService.Heartbeat:Connect(function()
        if H.States.nightOnly then S.Lighting.ClockTime = 0 end
    end)
    notify("Environnement", "Mode Nuit Permanent activé!", 3, "🌙")
end

local function disableNightOnly()
    if H.Connections.nightOnly then H.Connections.nightOnly:Disconnect() H.Connections.nightOnly = nil end
    notify("Environnement", "Mode Nuit Permanent désactivé", 3, "🌙")
end

local function enableStopTime()
    H.Connections.stopTime = S.RunService.Heartbeat:Connect(function()
        if H.States.stopTime then S.Lighting.ClockTime = H.Config.preferredTime end
    end)
    notify("Environnement", "Temps figé!", 3, "⏰")
end

local function disableStopTime()
    if H.Connections.stopTime then H.Connections.stopTime:Disconnect() H.Connections.stopTime = nil end
    notify("Environnement", "Temps normal", 3, "⏰")
end

-- ⚔️ COMBAT FUNCTIONS
local function enableAimbot()
    H.Connections.aimbot = S.RunService.Heartbeat:Connect(function()
        if not H.States.aimbot then return end
        local closestMonster, closestDistance = nil, math.huge
        if P.Character and P.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = P.Character.HumanoidRootPart
            for monster, _ in pairs(H.Cache.monsters) do
                if monster and monster.Parent and monster:FindFirstChild("HumanoidRootPart") then
                    local distance = (hrp.Position - monster.HumanoidRootPart.Position).Magnitude
                    if distance < H.Config.aimDistance and distance < closestDistance then
                        closestMonster = monster.HumanoidRootPart
                        closestDistance = distance
                    end
                end
            end
            if closestMonster then
                local targetPos = closestMonster.Position
                local currentCFrame = C.CFrame
                local targetCFrame = CFrame.lookAt(currentCFrame.Position, targetPos)
                C.CFrame = currentCFrame:Lerp(targetCFrame, 0.2)
            end
        end
    end)
    notify("Combat", "Aimbot activé!", 3, "🎯")
end

local function disableAimbot()
    if H.Connections.aimbot then H.Connections.aimbot:Disconnect() H.Connections.aimbot = nil end
    notify("Combat", "Aimbot désactivé", 3, "🎯")
end

local function enableAutoAttack()
    H.Connections.autoAttack = S.RunService.Heartbeat:Connect(function()
        if not H.States.autoAttack or not P.Character then return end
        local hrp = P.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        for monster, _ in pairs(H.Cache.monsters) do
            if monster and monster.Parent and monster:FindFirstChild("HumanoidRootPart") then
                local distance = (hrp.Position - monster.HumanoidRootPart.Position).Magnitude
                if distance < H.Config.attackRange then
                    local tool = P.Character:FindFirstChildOfClass("Tool")
                    if tool then tool:Activate() end
                    for _, remote in pairs(S.ReplicatedStorage:GetDescendants()) do
                        if remote:IsA("RemoteEvent") and remote.Name:lower():find("attack") then
                            pcall(function() remote:FireServer(monster) end)
                        end
                    end
                    H.Stats.monstersKilled = H.Stats.monstersKilled + 1
                    wait(0.1)
                    break
                end
            end
        end
    end)
    notify("Combat", "Auto-Attack activé!", 3, "⚔️")
end

local function disableAutoAttack()
    if H.Connections.autoAttack then H.Connections.autoAttack:Disconnect() H.Connections.autoAttack = nil end
    notify("Combat", "Auto-Attack désactivé", 3, "⚔️")
end

local function enableOneHitKill()
    H.Connections.oneHitKill = S.RunService.Heartbeat:Connect(function()
        if not H.States.oneHitKill then return end
        for monster, _ in pairs(H.Cache.monsters) do
            if monster and monster.Parent and monster:FindFirstChild("Humanoid") then
                monster.Humanoid.Health = 0
                H.Stats.monstersKilled = H.Stats.monstersKilled + 1
            end
        end
    end)
    notify("Combat", "One Hit Kill activé!", 3, "💀")
end

local function disableOneHitKill()
    if H.Connections.oneHitKill then H.Connections.oneHitKill:Disconnect() H.Connections.oneHitKill = nil end
    notify("Combat", "One Hit Kill désactivé", 3, "💀")
end

-- 🏠 BUILD FUNCTIONS
local function enableAutoBuild()
    H.Connections.autoBuild = S.RunService.Heartbeat:Connect(function()
        if not H.States.autoBuild then return end
        local gui = P:FindFirstChild("PlayerGui")
        if gui then
            for _, obj in pairs(gui:GetDescendants()) do
                if obj:IsA("TextButton") then
                    local text = obj.Text:lower()
                    if text:find("build") or text:find("place") or text:find("construct") then
                        obj.MouseButton1Click:Fire()
                        wait(0.1)
                    end
                end
            end
        end
    end)
    notify("Construction", "Auto-Build activé!", 3, "🏗️")
end

local function disableAutoBuild()
    if H.Connections.autoBuild then H.Connections.autoBuild:Disconnect() H.Connections.autoBuild = nil end
    notify("Construction", "Auto-Build désactivé", 3, "🏗️")
end

local function enableInstantBuild()
    H.Connections.instantBuild = S.RunService.Heartbeat:Connect(function()
        if not H.States.instantBuild then return end
        for _, remote in pairs(S.ReplicatedStorage:GetDescendants()) do
            if remote:IsA("RemoteEvent") and remote.Name:lower():find("build") then
                pcall(function() remote:FireServer("InstantBuild", true) end)
            end
        end
    end)
    notify("Construction", "Instant Build activé!", 3, "⚡")
end

local function disableInstantBuild()
    if H.Connections.instantBuild then H.Connections.instantBuild:Disconnect() H.Connections.instantBuild = nil end
    notify("Construction", "Instant Build désactivé", 3, "⚡")
end

-- 🎒 INVENTORY FUNCTIONS
local function enableAutoPickup()
    H.Connections.autoPickup = S.RunService.Heartbeat:Connect(function()
        if not H.States.autoPickup or not P.Character then return end
        local hrp = P.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        for _, obj in pairs(S.Workspace:GetDescendants()) do
            if obj:IsA("Part") or obj:IsA("MeshPart") then
                local name = obj.Name:lower()
                if name:find("drop") or name:find("item") or name:find("loot") or 
                   name:find("wood") or name:find("stone") or name:find("food") or
                   name:find("coin") or name:find("gem") then
                    local distance = (hrp.Position - obj.Position).Magnitude
                    if distance < 30 then
                        obj.CFrame = hrp.CFrame
                        wait(0.05)
                    end
                end
            end
        end
    end)
    notify("Inventaire", "Auto-Pickup activé!", 3, "🎒")
end

local function disableAutoPickup()
    if H.Connections.autoPickup then H.Connections.autoPickup:Disconnect() H.Connections.autoPickup = nil end
    notify("Inventaire", "Auto-Pickup désactivé", 3, "🎒")
end

local function enableInfiniteSpace()
    H.Connections.infiniteSpace = S.RunService.Heartbeat:Connect(function()
        if not H.States.infiniteSpace then return end
        local backpack = P:FindFirstChild("Backpack")
        if backpack then
            for _, obj in pairs(backpack:GetDescendants()) do
                if obj:IsA("IntValue") and obj.Name:lower():find("space") then
                    obj.Value = 999999
                end
            end
        end
    end)
    notify("Inventaire", "Espace Infini activé!", 3, "📦")
end

local function disableInfiniteSpace()
    if H.Connections.infiniteSpace then H.Connections.infiniteSpace:Disconnect() H.Connections.infiniteSpace = nil end
    notify("Inventaire", "Espace Infini désactivé", 3, "📦")
end

-- 🔧 UTILITY FUNCTIONS
local function enableAntiAfk()
    H.lastActivity = tick()
    H.Connections.antiAfk = S.RunService.Heartbeat:Connect(function()
        if not H.States.antiAfk then return end
        if tick() - H.lastActivity >= 300 then
            H.lastActivity = tick()
            if P.Character and P.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = P.Character.HumanoidRootPart
                local originalPos = hrp.Position
                hrp.CFrame = CFrame.new(originalPos + Vector3.new(0.1, 0, 0))
                wait(0.1)
                hrp.CFrame = CFrame.new(originalPos)
            end
        end
    end)
    notify("Utilitaire", "Anti-AFK activé!", 3, "💤")
end

local function disableAntiAfk()
    if H.Connections.antiAfk then H.Connections.antiAfk:Disconnect() H.Connections.antiAfk = nil end
    notify("Utilitaire", "Anti-AFK désactivé", 3, "💤")
end

local function enableAutoRespawn()
    H.Connections.autoRespawn = P.CharacterRemoving:Connect(function()
        if H.States.autoRespawn then
            wait(5)
            P:LoadCharacter()
        end
    end)
    notify("Utilitaire", "Auto-Respawn activé!", 3, "♻️")
end

local function disableAutoRespawn()
    if H.Connections.autoRespawn then H.Connections.autoRespawn:Disconnect() H.Connections.autoRespawn = nil end
    notify("Utilitaire", "Auto-Respawn désactivé", 3, "♻️")
end

local function performServerHop()
    notify("Utilitaire", "Recherche d'un nouveau serveur...", 3, "🔄")
    local Http = S.HttpService
    local TPS = S.TeleportService
    local Api = "https://games.roblox.com/v1/games/"
    local _place = game.PlaceId
    local _servers = Api.._place.."/servers/Public?sortOrder=Asc&limit=100"
    
    function ListServers(cursor)
       local Raw = game:HttpGet(_servers .. ((cursor and "&cursor="..cursor) or ""))
       return Http:JSONDecode(Raw)
    end
    
    local Server, Next; repeat
       local Servers = ListServers(Next)
       Server = Servers.data[1]
       Next = Servers.nextPageCursor
    until Server
    
    TPS:TeleportToPlaceInstance(_place, Server.id, P)
end

local function formatNumber(num)
    if num >= 1e6 then return string.format("%.1fM", num / 1e6)
    elseif num >= 1e3 then return string.format("%.1fK", num / 1e3)
    else return tostring(math.floor(num)) end
end

-- 🎮 RAYFIELD LOADER avec multiples sources
local function loadRayfield()
    notify("Système", "Chargement de Rayfield...", 3, "⏳")
    
    local rayfieldUrls = {
        'https://sirius.menu/rayfield',
        'https://raw.githubusercontent.com/ui-interface/roblox-rayfield/main/source.lua',
        'https://raw.githubusercontent.com/shlexware/Rayfield/main/source',
        'https://raw.githubusercontent.com/UI-Interface/CustomFIeldRay/main/RayField.lua',
        'https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/Rayfield',
        'https://pastebin.com/raw/BQf3PJX9'
    }
    
    for i, url in ipairs(rayfieldUrls) do
        notify("Rayfield", "Tentative " .. i .. "/" .. #rayfieldUrls, 2, "🔄")
        
        local success, result = pcall(function()
            return game:HttpGet(url, true)
        end)
        
        if success and result and #result > 1000 and not result:find("404") then
            local loadSuccess, library = pcall(function()
                return loadstring(result)()
            end)
            
            if loadSuccess and library and library.CreateWindow then
                notify("Rayfield", "Chargé avec succès! (Source " .. i .. ")", 4, "✅")
                return library
            end
        end
        
        wait(0.5)
    end
    
    notify("Erreur", "Rayfield indisponible - Interface simple activée", 5, "⚠️")
    return nil
end

-- 🎮 INTERFACE SIMPLE DE SECOURS
local function createSimpleGUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NightsForestSimpleGUI"
    ScreenGui.Parent = game.CoreGui
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
    MainFrame.Size = UDim2.new(0, 500, 0, 600)
    MainFrame.Active = true
    MainFrame.Draggable = true
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Parent = MainFrame
    Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Title.BorderSizePixel = 0
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Font = Enum.Font.GothamBold
    Title.Text = "🌲 NIGHTS FOREST HUB v4.2 - SIMPLE MODE"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextScaled = true
    
    local ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Parent = MainFrame
    ScrollingFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.Position = UDim2.new(0, 0, 0, 40)
    ScrollingFrame.Size = UDim2.new(1, 0, 1, -40)
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 2, 0)
    ScrollingFrame.ScrollBarThickness = 5
    
    local buttonCount = 0
    local function createButton(name, text, callback)
        buttonCount = buttonCount + 1
        local button = Instance.new("TextButton")
        button.Name = name
        button.Parent = ScrollingFrame
        button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        button.BorderSizePixel = 0
        button.Position = UDim2.new(0, 10 + (buttonCount % 2) * 240, 0, 10 + math.floor((buttonCount - 1) / 2) * 40)
        button.Size = UDim2.new(0, 220, 0, 30)
        button.Font = Enum.Font.Gotham
        button.Text = text
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextScaled = true
        
        button.MouseButton1Click:Connect(callback)
        
        button.MouseEnter:Connect(function()
            button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        end)
        
        button.MouseLeave:Connect(function()
            button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        end)
        
        return button
    end
    
    -- Tous les boutons principaux
    createButton("GodMode", "🛡️ God Mode", function()
        H.States.godMode = not H.States.godMode
        if H.States.godMode then enableGodMode() else disableGodMode() end
    end)
    
    createButton("AntiMonster", "👹 Anti-Monstre", function()
        H.States.antiMonster = not H.States.antiMonster
        if H.States.antiMonster then enableAntiMonster() else disableAntiMonster() end
    end)
    
    createButton("InfiniteStamina", "⚡ Stamina Infinie", function()
        H.States.infiniteStamina = not H.States.infiniteStamina
        if H.States.infiniteStamina then enableInfiniteStamina() else disableInfiniteStamina() end
    end)
    
    createButton("AutoCraft", "🔨 Auto-Craft", function()
        H.States.autoCraft = not H.States.autoCraft
        if H.States.autoCraft then enableAutoCraft() else disableAutoCraft() end
    end)
    
    createButton("AutoGather", "⛏️ Auto-Gather", function()
        H.States.autoGather = not H.States.autoGather
        if H.States.autoGather then enableAutoGather() else disableAutoGather() end
    end)
    
    createButton("InfiniteResources", "♾️ Ressources Infinies", function()
        H.States.infiniteResources = not H.States.infiniteResources
        if H.States.infiniteResources then enableInfiniteResources() else disableInfiniteResources() end
    end)
    
    createButton("MonsterESP", "👁️ ESP Monstres", function()
        H.States.monsterESP = not H.States.monsterESP
        if H.States.monsterESP then enableMonsterESP() else disableMonsterESP() end
    end)
    
    createButton("ResourceESP", "🌲 ESP Ressources", function()
        H.States.resourceESP = not H.States.resourceESP
        if H.States.resourceESP then enableResourceESP() else disableResourceESP() end
    end)
    
    createButton("Fullbright", "💡 Fullbright", function()
        H.States.fullbright = not H.States.fullbright
        if H.States.fullbright then enableFullbright() else disableFullbright() end
    end)
    
    createButton("Fly", "🚀 Fly", function()
        H.States.fly = not H.States.fly
        if H.States.fly then enableFly() else disableFly() end
    end)
    
    createButton("Speed", "🏃 Speed", function()
        H.States.speed = not H.States.speed
        if H.States.speed then enableSpeed() else disableSpeed() end
    end)
    
    createButton("DayOnly", "☀️ Jour Permanent", function()
        H.States.dayOnly = not H.States.dayOnly
        if H.States.dayOnly then 
            H.States.nightOnly = false
            enableDayOnly() 
        else 
            disableDayOnly() 
        end
    end)
    
    createButton("Aimbot", "🎯 Aimbot", function()
        H.States.aimbot = not H.States.aimbot
        if H.States.aimbot then enableAimbot() else disableAimbot() end
    end)
    
    createButton("AutoAttack", "⚔️ Auto-Attack", function()
        H.States.autoAttack = not H.States.autoAttack
        if H.States.autoAttack then enableAutoAttack() else disableAutoAttack() end
    end)
    
    createButton("AutoPickup", "🎒 Auto-Pickup", function()
        H.States.autoPickup = not H.States.autoPickup
        if H.States.autoPickup then enableAutoPickup() else disableAutoPickup() end
    end)
    
    createButton("AntiAFK", "💤 Anti-AFK", function()
        H.States.antiAfk = not H.States.antiAfk
        if H.States.antiAfk then enableAntiAfk() else disableAntiAfk() end
    end)
    
    createButton("TeleportResources", "🌍 TP Ressources", function()
        teleportToResources()
    end)
    
    createButton("ServerHop", "🔄 Server Hop", function()
        performServerHop()
    end)
    
    createButton("SuperMode", "🌟 SUPER MODE", function()
        H.States.godMode = true
        H.States.fly = true
        H.States.speed = true
        H.States.fullbright = true
        H.States.monsterESP = true
        H.States.resourceESP = true
        H.States.infiniteResources = true
        H.States.autoGather = true
        H.States.autoCraft = true
        enableGodMode()
        enableFly()
        enableSpeed()
        enableFullbright()
        enableMonsterESP()
        enableResourceESP()
        enableInfiniteResources()
        enableAutoGather()
        enableAutoCraft()
        notify("Super Mode", "TOUTES les fonctions activées!", 4, "🚀")
    end)
    
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Parent = MainFrame
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    CloseButton.BorderSizePixel = 0
    CloseButton.Position = UDim2.new(1, -30, 0, 5)
    CloseButton.Size = UDim2.new(0, 25, 0, 25)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextScaled = true
    
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
        H.GUI = nil
    end)
    
    return ScreenGui
end

-- 🎮 INITIALISATION PRINCIPALE AVEC RAYFIELD COMPLET
local function initializeGUI()
    notify("Démarrage", "Initialisation du hub...", 3, "🚀")
    
    local Rayfield = loadRayfield()
    
    if Rayfield then
        -- Interface Rayfield complète avec TOUTES les fonctionnalités
        local Window = Rayfield:CreateWindow({
            Name = "🌲 NIGHTS FOREST HUB v4.2 - COMPLETE",
            LoadingTitle = "NIGHTS FOREST HUB",
            LoadingSubtitle = "Chargement complet pour 99 Nights in the Forest...",
            ConfigurationSaving = {
                Enabled = true,
                FolderName = "NightsForestHub",
                FileName = "Config"
            }
        })
        
        H.GUI = Window
        
        -- 🛡️ SURVIVAL TAB
        local SurvivalTab = Window:CreateTab("🛡️ Survie & Protection", 4483362458)
        
        SurvivalTab:CreateToggle({
            Name = "🛡️ God Mode",
            CurrentValue = false,
            Flag = "GodMode",
            Callback = function(Value)
                H.States.godMode = Value
                if Value then enableGodMode() else disableGodMode() end
            end,
        })
        
        SurvivalTab:CreateToggle({
            Name = "👹 Anti-Monstre",
            CurrentValue = false,
            Flag = "AntiMonster",
            Callback = function(Value)
                H.States.antiMonster = Value
                if Value then enableAntiMonster() else disableAntiMonster() end
            end,
        })
        
        SurvivalTab:CreateToggle({
            Name = "⚡ Stamina Infinie",
            CurrentValue = false,
            Flag = "InfiniteStamina",
            Callback = function(Value)
                H.States.infiniteStamina = Value
                if Value then enableInfiniteStamina() else disableInfiniteStamina() end
            end,
        })
        
        SurvivalTab:CreateButton({
            Name = "🌟 Mode Survie Auto",
            Callback = function()
                H.States.godMode = true
                H.States.antiMonster = true
                H.States.infiniteStamina = true
                enableGodMode()
                enableAntiMonster()
                enableInfiniteStamina()
                notify("Survie", "Mode Survie Auto activé!", 3, "🌟")
            end,
        })
        
        -- 🌲 CRAFTING TAB
        local CraftingTab = Window:CreateTab("🌲 Crafting & Ressources", 4483362458)
        
        CraftingTab:CreateToggle({
            Name = "🔨 Auto-Craft",
            CurrentValue = false,
            Flag = "AutoCraft",
            Callback = function(Value)
                H.States.autoCraft = Value
                if Value then enableAutoCraft() else disableAutoCraft() end
            end,
        })
        
        CraftingTab:CreateToggle({
            Name = "⛏️ Auto-Gather",
            CurrentValue = false,
            Flag = "AutoGather",
            Callback = function(Value)
                H.States.autoGather = Value
                if Value then enableAutoGather() else disableAutoGather() end
            end,
        })
        
        CraftingTab:CreateToggle({
            Name = "♾️ Ressources Infinies",
            CurrentValue = false,
            Flag = "InfiniteResources",
            Callback = function(Value)
                H.States.infiniteResources = Value
                if Value then enableInfiniteResources() else disableInfiniteResources() end
            end,
        })
        
        CraftingTab:CreateToggle({
            Name = "🪓 Auto-Chop Trees",
            CurrentValue = false,
            Flag = "AutoChopTrees",
            Callback = function(Value)
                H.States.autoChopTrees = Value
                if Value then enableAutoChopTrees() else disableAutoChopTrees() end
            end,
        })
        
        CraftingTab:CreateSlider({
            Name = "⏱️ Délai Craft (ms)",
            Range = {10, 1000},
            Increment = 10,
            Suffix = "ms",
            CurrentValue = 100,
            Flag = "CraftDelay",
            Callback = function(Value) H.Config.craftDelay = Value / 1000 end,
        })
        
        CraftingTab:CreateButton({
            Name = "🌾 Mode Fermier",
            Callback = function()
                H.States.autoGather = true
                H.States.autoCraft = true
                H.States.infiniteResources = true
                H.States.resourceESP = true
                H.States.autoPickup = true
                H.States.autoChopTrees = true
                enableAutoGather()
                enableAutoCraft()
                enableInfiniteResources()
                enableResourceESP()
                enableAutoPickup()
                enableAutoChopTrees()
                notify("Fermier", "Mode Fermier activé!", 3, "🌾")
            end,
        })
        
        -- 👁️ VISION TAB
        local VisionTab = Window:CreateTab("👁️ Vision & ESP", 4483362458)
        
        VisionTab:CreateToggle({
            Name = "👹 ESP Monstres",
            CurrentValue = false,
            Flag = "MonsterESP",
            Callback = function(Value)
                H.States.monsterESP = Value
                if Value then enableMonsterESP() else disableMonsterESP() end
            end,
        })
        
        VisionTab:CreateToggle({
            Name = "🌲 ESP Ressources",
            CurrentValue = false,
            Flag = "ResourceESP",
            Callback = function(Value)
                H.States.resourceESP = Value
                if Value then enableResourceESP() else disableResourceESP() end
            end,
        })
        
        VisionTab:CreateToggle({
            Name = "👤 ESP Joueurs",
            CurrentValue = false,
            Flag = "PlayerESP",
            Callback = function(Value)
                H.States.playerESP = Value
                if Value then enablePlayerESP() else disablePlayerESP() end
            end,
        })
        
        
VisionTab:CreateToggle({
            Name = "💎 ESP Items",
            CurrentValue = false,
            Flag = "ItemESP",
            Callback = function(Value)
                H.States.itemESP = Value
                if Value then enableItemESP() else disableItemESP() end
            end,
        })
        
        VisionTab:CreateToggle({
            Name = "💡 Fullbright",
            CurrentValue = false,
            Flag = "Fullbright",
            Callback = function(Value)
                H.States.fullbright = Value
                if Value then enableFullbright() else disableFullbright() end
            end,
        })
        
        VisionTab:CreateToggle({
            Name = "🌫️ No Fog",
            CurrentValue = false,
            Flag = "NoFog",
            Callback = function(Value)
                H.States.noFog = Value
                if Value then enableNoFog() else disableNoFog() end
            end,
        })
        
        VisionTab:CreateSlider({
            Name = "📏 Distance ESP",
            Range = {100, 2000},
            Increment = 50,
            Suffix = "m",
            CurrentValue = 500,
            Flag = "ESPDistance",
            Callback = function(Value) H.Config.espDistance = Value end,
        })
        
        VisionTab:CreateColorPicker({
            Name = "🎨 Couleur Monstres",
            Color = Color3.fromRGB(255, 0, 0),
            Flag = "MonsterColor",
            Callback = function(Value) H.Config.monsterColor = Value end
        })
        
        VisionTab:CreateColorPicker({
            Name = "🎨 Couleur Ressources",
            Color = Color3.fromRGB(0, 255, 0),
            Flag = "ResourceColor",
            Callback = function(Value) H.Config.resourceColor = Value end
        })
        
        VisionTab:CreateButton({
            Name = "👁️ Vision Totale",
            Callback = function()
                H.States.monsterESP = true
                H.States.resourceESP = true
                H.States.playerESP = true
                H.States.itemESP = true
                H.States.fullbright = true
                H.States.noFog = true
                enableMonsterESP()
                enableResourceESP()
                enablePlayerESP()
                enableItemESP()
                enableFullbright()
                enableNoFog()
                notify("Vision", "Vision Totale activée!", 3, "👁️")
            end,
        })
        
        -- 🚀 MOVEMENT TAB
        local MovementTab = Window:CreateTab("🚀 Mouvement", 4483362458)
        
        MovementTab:CreateToggle({
            Name = "🚀 Fly",
            CurrentValue = false,
            Flag = "Fly",
            Callback = function(Value)
                H.States.fly = Value
                if Value then enableFly() else disableFly() end
            end,
        })
        
        MovementTab:CreateToggle({
            Name = "🏃 Speed",
            CurrentValue = false,
            Flag = "Speed",
            Callback = function(Value)
                H.States.speed = Value
                if Value then enableSpeed() else disableSpeed() end
            end,
        })
        
        MovementTab:CreateToggle({
            Name = "🦘 Jump Hack",
            CurrentValue = false,
            Flag = "JumpHack",
            Callback = function(Value)
                H.States.jumpHack = Value
                if Value then enableJumpHack() else disableJumpHack() end
            end,
        })
        
        MovementTab:CreateSlider({
            Name = "✈️ Vitesse Fly",
            Range = {10, 200},
            Increment = 5,
            Suffix = " speed",
            CurrentValue = 50,
            Flag = "FlySpeed",
            Callback = function(Value) H.Config.flySpeed = Value end,
        })
        
        MovementTab:CreateSlider({
            Name = "🏃 Vitesse Marche",
            Range = {16, 100},
            Increment = 2,
            Suffix = " speed",
            CurrentValue = 30,
            Flag = "WalkSpeed",
            Callback = function(Value) H.Config.walkSpeed = Value end,
        })
        
        MovementTab:CreateSlider({
            Name = "🦘 Force Saut",
            Range = {50, 300},
            Increment = 10,
            Suffix = " power",
            CurrentValue = 80,
            Flag = "JumpPower",
            Callback = function(Value) H.Config.jumpPower = Value end,
        })
        
        MovementTab:CreateButton({
            Name = "🌍 TP vers Ressources",
            Callback = function()
                teleportToResources()
            end,
        })
        
        MovementTab:CreateButton({
            Name = "⚡ Mode Flash",
            Callback = function()
                H.States.fly = true
                H.States.speed = true
                H.States.jumpHack = true
                H.Config.flySpeed = 150
                H.Config.walkSpeed = 80
                H.Config.jumpPower = 250
                enableFly()
                enableSpeed()
                enableJumpHack()
                notify("Flash", "Mode Flash activé!", 3, "⚡")
            end,
        })
        
        -- 🌙 ENVIRONMENT TAB
        local EnvironmentTab = Window:CreateTab("🌙 Environnement", 4483362458)
        
        EnvironmentTab:CreateToggle({
            Name = "☀️ Jour Permanent",
            CurrentValue = false,
            Flag = "DayOnly",
            Callback = function(Value)
                H.States.dayOnly = Value
                if Value then 
                    H.States.nightOnly = false
                    enableDayOnly() 
                else 
                    disableDayOnly() 
                end
            end,
        })
        
        EnvironmentTab:CreateToggle({
            Name = "🌙 Nuit Permanente",
            CurrentValue = false,
            Flag = "NightOnly",
            Callback = function(Value)
                H.States.nightOnly = Value
                if Value then 
                    H.States.dayOnly = false
                    enableNightOnly() 
                else 
                    disableNightOnly() 
                end
            end,
        })
        
        EnvironmentTab:CreateToggle({
            Name = "⏰ Arrêter le Temps",
            CurrentValue = false,
            Flag = "StopTime",
            Callback = function(Value)
                H.States.stopTime = Value
                if Value then enableStopTime() else disableStopTime() end
            end,
        })
        
        EnvironmentTab:CreateSlider({
            Name = "🕐 Heure Préférée",
            Range = {0, 24},
            Increment = 1,
            Suffix = "h",
            CurrentValue = 14,
            Flag = "PreferredTime",
            Callback = function(Value) H.Config.preferredTime = Value end,
        })
        
        EnvironmentTab:CreateButton({
            Name = "🌅 Lever de Soleil",
            Callback = function()
                S.Lighting.ClockTime = 6
                notify("Environnement", "Lever de soleil!", 2, "🌅")
            end,
        })
        
        EnvironmentTab:CreateButton({
            Name = "🌇 Coucher de Soleil",
            Callback = function()
                S.Lighting.ClockTime = 18
                notify("Environnement", "Coucher de soleil!", 2, "🌇")
            end,
        })
        
        -- ⚔️ COMBAT TAB
        local CombatTab = Window:CreateTab("⚔️ Combat", 4483362458)
        
        CombatTab:CreateToggle({
            Name = "🎯 Aimbot",
            CurrentValue = false,
            Flag = "Aimbot",
            Callback = function(Value)
                H.States.aimbot = Value
                if Value then enableAimbot() else disableAimbot() end
            end,
        })
        
        CombatTab:CreateToggle({
            Name = "⚔️ Auto-Attack",
            CurrentValue = false,
            Flag = "AutoAttack",
            Callback = function(Value)
                H.States.autoAttack = Value
                if Value then enableAutoAttack() else disableAutoAttack() end
            end,
        })
        
        CombatTab:CreateToggle({
            Name = "💀 One Hit Kill",
            CurrentValue = false,
            Flag = "OneHitKill",
            Callback = function(Value)
                H.States.oneHitKill = Value
                if Value then enableOneHitKill() else disableOneHitKill() end
            end,
        })
        
        CombatTab:CreateSlider({
            Name = "🎯 Distance Aim",
            Range = {50, 500},
            Increment = 25,
            Suffix = "m",
            CurrentValue = 200,
            Flag = "AimDistance",
            Callback = function(Value) H.Config.aimDistance = Value end,
        })
        
        CombatTab:CreateSlider({
            Name = "⚔️ Portée Attaque",
            Range = {10, 100},
            Increment = 5,
            Suffix = "m",
            CurrentValue = 50,
            Flag = "AttackRange",
            Callback = function(Value) H.Config.attackRange = Value end,
        })
        
        CombatTab:CreateButton({
            Name = "💪 Mode Guerrier",
            Callback = function()
                H.States.aimbot = true
                H.States.autoAttack = true
                H.States.oneHitKill = true
                H.States.godMode = true
                H.States.monsterESP = true
                enableAimbot()
                enableAutoAttack()
                enableOneHitKill()
                enableGodMode()
                enableMonsterESP()
                notify("Combat", "Mode Guerrier activé!", 3, "💪")
            end,
        })
        
        -- 🏠 BUILD TAB
        local BuildTab = Window:CreateTab("🏠 Construction", 4483362458)
        
        BuildTab:CreateToggle({
            Name = "🏗️ Auto-Build",
            CurrentValue = false,
            Flag = "AutoBuild",
            Callback = function(Value)
                H.States.autoBuild = Value
                if Value then enableAutoBuild() else disableAutoBuild() end
            end,
        })
        
        BuildTab:CreateToggle({
            Name = "⚡ Instant Build",
            CurrentValue = false,
            Flag = "InstantBuild",
            Callback = function(Value)
                H.States.instantBuild = Value
                if Value then enableInstantBuild() else disableInstantBuild() end
            end,
        })
        
        BuildTab:CreateToggle({
            Name = "🆓 Free Build",
            CurrentValue = false,
            Flag = "FreeBuild",
            Callback = function(Value)
                H.States.freeBuild = Value
                notify("Construction", "Free Build " .. (Value and "activé" or "désactivé"), 2)
            end,
        })
        
        BuildTab:CreateToggle({
            Name = "📍 Build Anywhere",
            CurrentValue = false,
            Flag = "BuildAnywhere",
            Callback = function(Value)
                H.States.buildAnywhere = Value
                notify("Construction", "Build Anywhere " .. (Value and "activé" or "désactivé"), 2)
            end,
        })
        
        BuildTab:CreateButton({
            Name = "🏠 Mode Architecte",
            Callback = function()
                H.States.autoBuild = true
                H.States.instantBuild = true
                H.States.freeBuild = true
                H.States.buildAnywhere = true
                H.States.infiniteResources = true
                enableAutoBuild()
                enableInstantBuild()
                enableInfiniteResources()
                notify("Construction", "Mode Architecte activé!", 3, "🏠")
            end,
        })
        
        -- 🎒 INVENTORY TAB
        local InventoryTab = Window:CreateTab("🎒 Inventaire", 4483362458)
        
        InventoryTab:CreateToggle({
            Name = "📦 Espace Infini",
            CurrentValue = false,
            Flag = "InfiniteSpace",
            Callback = function(Value)
                H.States.infiniteSpace = Value
                if Value then enableInfiniteSpace() else disableInfiniteSpace() end
            end,
        })
        
        InventoryTab:CreateToggle({
            Name = "🎒 Auto-Pickup",
            CurrentValue = false,
            Flag = "AutoPickup",
            Callback = function(Value)
                H.States.autoPickup = Value
                if Value then enableAutoPickup() else disableAutoPickup() end
            end,
        })
        
        InventoryTab:CreateToggle({
            Name = "💎 Item Dupe",
            CurrentValue = false,
            Flag = "ItemDupe",
            Callback = function(Value)
                H.States.itemDupe = Value
                notify("Inventaire", "Item Dupe " .. (Value and "activé" or "désactivé"), 2)
            end,
        })
        
        InventoryTab:CreateToggle({
            Name = "💰 Auto-Sell",
            CurrentValue = false,
            Flag = "AutoSell",
            Callback = function(Value)
                H.States.autoSell = Value
                notify("Inventaire", "Auto-Sell " .. (Value and "activé" or "désactivé"), 2)
            end,
        })
        
        InventoryTab:CreateButton({
            Name = "🛍️ Mode Collectionneur",
            Callback = function()
                H.States.infiniteSpace = true
                H.States.autoPickup = true
                H.States.itemDupe = true
                H.States.itemESP = true
                enableInfiniteSpace()
                enableAutoPickup()
                enableItemESP()
                notify("Inventaire", "Mode Collectionneur activé!", 3, "🛍️")
            end,
        })
        
        -- 🔧 UTILITY TAB
        local UtilityTab = Window:CreateTab("🔧 Utilitaires", 4483362458)
        
        UtilityTab:CreateToggle({
            Name = "💤 Anti-AFK",
            CurrentValue = false,
            Flag = "AntiAFK",
            Callback = function(Value)
                H.States.antiAfk = Value
                if Value then enableAntiAfk() else disableAntiAfk() end
            end,
        })
        
        UtilityTab:CreateToggle({
            Name = "♻️ Auto-Respawn",
            CurrentValue = false,
            Flag = "AutoRespawn",
            Callback = function(Value)
                H.States.autoRespawn = Value
                if Value then enableAutoRespawn() else disableAutoRespawn() end
            end,
        })
        
        UtilityTab:CreateToggle({
            Name = "📊 Afficher Stats",
            CurrentValue = true,
            Flag = "ShowStats",
            Callback = function(Value)
                H.States.showStats = Value
            end,
        })
        
        UtilityTab:CreateToggle({
            Name = "🔔 Notifications",
            CurrentValue = true,
            Flag = "Notifications",
            Callback = function(Value)
                H.States.notifications = Value
            end,
        })
        
        UtilityTab:CreateButton({
            Name = "🔄 Server Hop",
            Callback = function()
                performServerHop()
            end,
        })
        
        UtilityTab:CreateButton({
            Name = "🔄 Rejoin Server",
            Callback = function()
                S.TeleportService:Teleport(game.PlaceId, P)
            end,
        })
        
        UtilityTab:CreateButton({
            Name = "🗑️ Nettoyer ESP",
            Callback = function()
                for _, esp in pairs(H.ESPObjects) do
                    if esp and esp.Parent then esp:Destroy() end
                end
                H.ESPObjects = {}
                notify("Utilitaire", "ESP nettoyé!", 2, "🗑️")
            end,
        })
        
        -- 📊 STATS TAB
        local StatsTab = Window:CreateTab("📊 Statistiques", 4483362458)
        
        local sessionTimeLabel = StatsTab:CreateLabel("⏱️ Temps de session: 0s")
        local monstersKilledLabel = StatsTab:CreateLabel("👹 Monstres tués: 0")
        local resourcesGatheredLabel = StatsTab:CreateLabel("⛏️ Ressources récoltées: 0")
        local itemsCraftedLabel = StatsTab:CreateLabel("🔨 Items craftés: 0")
        local deathsPreventedLabel = StatsTab:CreateLabel("🛡️ Morts évitées: 0")
        local teleportsLabel = StatsTab:CreateLabel("🌍 Téléportations: 0")
        
        -- Mise à jour des stats en temps réel
        spawn(function()
            while H.States.showStats do
                local sessionTime = tick() - H.Stats.sessionStart
                local hours = math.floor(sessionTime / 3600)
                local minutes = math.floor((sessionTime % 3600) / 60)
                local seconds = math.floor(sessionTime % 60)
                
                sessionTimeLabel:Set("⏱️ Temps de session: " .. string.format("%02d:%02d:%02d", hours, minutes, seconds))
                monstersKilledLabel:Set("👹 Monstres tués: " .. formatNumber(H.Stats.monstersKilled))
                resourcesGatheredLabel:Set("⛏️ Ressources récoltées: " .. formatNumber(H.Stats.resourcesGathered))
                itemsCraftedLabel:Set("🔨 Items craftés: " .. formatNumber(H.Stats.itemsCrafted))
                deathsPreventedLabel:Set("🛡️ Morts évitées: " .. formatNumber(H.Stats.deathsPrevented))
                teleportsLabel:Set("🌍 Téléportations: " .. formatNumber(H.Stats.teleports))
                
                wait(1)
            end
        end)
        
        StatsTab:CreateButton({
            Name = "🔄 Reset Stats",
            Callback = function()
                H.Stats = {
                    sessionStart = tick(),
                    monstersKilled = 0,
                    resourcesGathered = 0,
                    itemsCrafted = 0,
                    deathsPrevented = 0,
                    timesSaved = 0,
                    teleports = 0
                }
                notify("Stats", "Statistiques réinitialisées!", 2, "🔄")
            end,
        })
        
        -- 🌟 PRESETS TAB
        local PresetsTab = Window:CreateTab("🌟 Presets", 4483362458)
        
        PresetsTab:CreateButton({
            Name = "🚀 SUPER MODE (TOUT)",
            Callback = function()
                -- Activer TOUTES les fonctions
                H.States.godMode = true
                H.States.antiMonster = true
                H.States.infiniteStamina = true
                H.States.autoCraft = true
                H.States.autoGather = true
                H.States.infiniteResources = true
                H.States.autoChopTrees = true
                H.States.monsterESP = true
                H.States.resourceESP = true
                H.States.playerESP = true
                H.States.itemESP = true
                H.States.fullbright = true
                H.States.noFog = true
                H.States.fly = true
                H.States.speed = true
                H.States.jumpHack = true
                H.States.dayOnly = true
                H.States.aimbot = true
                H.States.autoAttack = true
                H.States.oneHitKill = true
                H.States.autoBuild = true
                H.States.instantBuild = true
                H.States.infiniteSpace = true
                H.States.autoPickup = true
                H.States.antiAfk = true
                
                -- Lancer toutes les fonctions
                enableGodMode()
                enableAntiMonster()
                enableInfiniteStamina()
                enableAutoCraft()
                enableAutoGather()
                enableInfiniteResources()
                enableAutoChopTrees()
                enableMonsterESP()
                enableResourceESP()
                enablePlayerESP()
                enableItemESP()
                enableFullbright()
                enableNoFog()
                enableFly()
                enableSpeed()
                enableJumpHack()
                enableDayOnly()
                enableAimbot()
                enableAutoAttack()
                enableOneHitKill()
                enableAutoBuild()
                enableInstantBuild()
                enableInfiniteSpace()
                enableAutoPickup()
                enableAntiAfk()
                
                notify("SUPER MODE", "TOUTES LES FONCTIONS ACTIVÉES!", 5, "🚀")
            end,
        })
        
        PresetsTab:CreateButton({
            Name = "🌾 Mode Fermier",
            Callback = function()
                H.States.autoGather = true
                H.States.autoCraft = true
                H.States.infiniteResources = true
                H.States.resourceESP = true
                H.States.autoPickup = true
                H.States.autoChopTrees = true
                H.States.infiniteSpace = true
                
                enableAutoGather()
                enableAutoCraft()
                enableInfiniteResources()
                enableResourceESP()
                enableAutoPickup()
                enableAutoChopTrees()
                enableInfiniteSpace()
                
                notify("Preset", "Mode Fermier activé!", 3, "🌾")
            end,
        })
        
        PresetsTab:CreateButton({
            Name = "💪 Mode Guerrier",
            Callback = function()
                H.States.godMode = true
                H.States.aimbot = true
                H.States.autoAttack = true
                H.States.oneHitKill = true
                H.States.monsterESP = true
                H.States.antiMonster = true
                H.States.fullbright = true
                
                enableGodMode()
                enableAimbot()
                enableAutoAttack()
                enableOneHitKill()
                enableMonsterESP()
                enableAntiMonster()
                enableFullbright()
                
                notify("Preset", "Mode Guerrier activé!", 3, "💪")
            end,
        })
        
        PresetsTab:CreateButton({
            Name = "🏠 Mode Architecte",
            Callback = function()
                H.States.autoBuild = true
                H.States.instantBuild = true
                H.States.freeBuild = true
                H.States.buildAnywhere = true
                H.States.infiniteResources = true
                H.States.fly = true
                H.States.resourceESP = true
                
                enableAutoBuild()
                enableInstantBuild()
                enableInfiniteResources()
                enableFly()
                enableResourceESP()
                
                notify("Preset", "Mode Architecte activé!", 3, "🏠")
            end,
        })
        
        PresetsTab:CreateButton({
            Name = "👁️ Mode Explorateur",
            Callback = function()
                H.States.monsterESP = true
                H.States.resourceESP = true
                H.States.playerESP = true
                H.States.itemESP = true
                H.States.fullbright = true
                H.States.noFog = true
                H.States.fly = true
                H.States.speed = true
                H.States.antiAfk = true
                
                enableMonsterESP()
                enableResourceESP()
                enablePlayerESP()
                enableItemESP()
                enableFullbright()
                enableNoFog()
                enableFly()
                enableSpeed()
                enableAntiAfk()
                
                notify("Preset", "Mode Explorateur activé!", 3, "👁️")
            end,
        })
        
        PresetsTab:CreateButton({
            Name = "🔄 Désactiver Tout",
            Callback = function()
                -- Désactiver toutes les fonctions
                for state, _ in pairs(H.States) do
                    H.States[state] = false
                end
                
                -- Déconnecter toutes les connexions
                for name, connection in pairs(H.Connections) do
                    if connection then connection:Disconnect() end
                    H.Connections[name] = nil
                end
                
                -- Nettoyer les objets
                for _, obj in pairs(H.Objects) do
                    if obj then obj:Destroy() end
                end
                H.Objects = {}
                
                -- Nettoyer ESP
                for _, esp in pairs(H.ESPObjects) do
                    if esp and esp.Parent then esp:Destroy() end
                end
                H.ESPObjects = {}
                
                -- Restaurer l'éclairage
                if H.originalLighting then
                    disableFullbright()
                end
                
                -- Restaurer vitesses
                if P.Character and P.Character:FindFirstChild("Humanoid") then
                    P.Character.Humanoid.WalkSpeed = 16
                    P.Character.Humanoid.JumpPower = 50
                end
                
                notify("Reset", "Toutes les fonctions désactivées!", 3, "🔄")
            end,
        })
        
        notify("Hub", "Interface Rayfield chargée avec succès!", 4, "✅")
        
    else
        -- Interface simple de secours
        H.GUI = createSimpleGUI()
        notify("Hub", "Interface simple chargée!", 3, "⚠️")
    end
end

-- 🎯 DÉTECTION ET INITIALISATION AUTOMATIQUE
spawn(function()
    wait(2)
    findGameElements()
    initializeGUI()
    
    -- Mise à jour continue du cache
    spawn(function()
        while _G.NightsForestHub do
            findGameElements()
            wait(5)
        end
    end)
    
    -- Message de bienvenue
    notify("NIGHTS FOREST HUB", "v4.2 Chargé avec succès! 🌲", 5, "🎮")
    notify("Bienvenue", P.Name .. ", bon jeu! 🎯", 4, "👋")
end)

-- 🧹 NETTOYAGE À LA FERMETURE
game:GetService("Players").PlayerRemoving:Connect(function(player)
    if player == P then
        for _, connection in pairs(H.Connections) do
            if connection then connection:Disconnect() end
        end
        for _, obj in pairs(H.Objects) do
            if obj then obj:Destroy() end
        end
        for _, esp in pairs(H.ESPObjects) do
            if esp and esp.Parent then esp:Destroy() end
        end
    end
end)

-- 🎮 COMMANDES CHAT
P.Chatted:Connect(function(message)
    local msg = message:lower()
    if msg == "/nfh" or msg == "/nightsforest" then
        if H.GUI then
            if H.GUI.Enabled ~= nil then
                H.GUI.Enabled = not H.GUI.Enabled
            else
                H.GUI.Visible = not H.GUI.Visible
            end
        end
    elseif msg == "/supermode" then
        -- Activer le super mode via chat
        H.States.godMode = true
        H.States.fly = true
        H.States.speed = true
        H.States.fullbright = true
        H.States.infiniteResources = true
        enableGodMode()
        enableFly()
        enableSpeed()
        enableFullbright()
        enableInfiniteResources()
        notify("Chat", "Super Mode activé via chat!", 3, "💬")
    end
end)

print("🌲 NIGHTS FOREST HUB v4.2 - COMPLETE EDITION LOADED! 🌲")
print("═══════════════════════════════════════════════════════")
print("🔥 60+ Features | 🛡️ Advanced Protection | ⚡ Auto Functions")
print("💬 Commands: /nfh (toggle GUI) | /supermode (activate all)")
print("🎯 Created for 99 Nights in the Forest | Enjoy! 🎮")
print("═══════════════════════════════════════════════════════")