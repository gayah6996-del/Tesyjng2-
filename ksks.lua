-- SANSTRO Menu for Mobile - Rayfield Version
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

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

-- Переменная для цели телепортации предметов
local BringTarget = "Campfire" -- "Campfire" или "Player"

-- Новые переменные для функций в разделе More
local antiAFKEnabled = false
local antiAFKConnection = nil

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
    antiAFKEnabled = false
}

-- ESP объекты
local espObjects = {}
local espConnections = {}
local espCountText = nil
local noclipConnection = nil
local fovCircle = nil

-- Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Функция для показа уведомлений
local function showNotification(text)
    Rayfield:Notify({
        Title = "SANSTRO Menu",
        Content = text,
        Duration = 3,
        Image = 4483362458
    })
end

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
    fovCircle.Color = Color3.fromRGB(170, 0, 170)
    fovCircle.Thickness = 2
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
        
        -- Check if player is dead or doesn't exist
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
        
        -- Check if player is dead
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
                    espObjects[otherPlayer].tracer.Color = Color3.fromRGB(170, 0, 170)
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
                    espObjects[otherPlayer].box.Color = Color3.fromRGB(170, 0, 170)
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
                    espObjects[otherPlayer].health.Color = Color3.fromRGB(170, 0, 170)
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
                    espObjects[otherPlayer].distance.Color = Color3.fromRGB(170, 0, 170)
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
    
    -- Update ESP continuously
    espConnections[otherPlayer] = RunService.Heartbeat:Connect(updateESP)
    
    -- Clean up when player leaves
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
    
    -- Raycast to target
    local direction = (targetRoot.Position - origin).Unit
    local ray = Ray.new(origin, direction * 1000)
    
    local ignoreList = {player.Character, camera}
    local hit, hitPosition = workspace:FindPartOnRayWithIgnoreList(ray, ignoreList)
    
    if hit then
        -- Check if we hit the target player
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

-- Обновленная функция Bring Items с поддержкой выбора цели
local function BringItems(itemName)
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
    
    -- Показываем уведомление о количестве телепортированных предметов
    showNotification("Teleported " .. teleported .. " " .. itemName .. "(s)")
end

-- Исправленная Anti AFK функция
local function EnableAntiAFK()
    if antiAFKConnection then
        antiAFKConnection:Disconnect()
        antiAFKConnection = nil
    end
    
    -- Правильный Anti-AFK метод
    antiAFKConnection = game:GetService("Players").LocalPlayer.Idled:Connect(function()
        VirtualInputManager:SendKeyEvent(true, "F", false, game)
        wait(0.1)
        VirtualInputManager:SendKeyEvent(false, "F", false, game)
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

-- Создаем Rayfield Window
local Window = Rayfield:CreateWindow({
    Name = "SANSTRO MENU | 99 Nights & GunGame",
    LoadingTitle = "SANSTRO Menu",
    LoadingSubtitle = "by SANSTRO",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "SANSTRO_Menu",
        FileName = "Settings.json"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false,
    KeySettings = {
        Title = "SANSTRO Menu",
        Subtitle = "Key System",
        Note = "No key required",
        FileName = "SANSTROKey",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"SANSTRO"}
    }
})

-- Создаем вкладки
local GunGameTab = Window:CreateTab("🎮 GunGame", 4483362458)
local NightsTab = Window:CreateTab("🌙 99 Nights", 4483362458)
local PlayerTab = Window:CreateTab("👤 Player", 4483362458)

-- GunGame Tab Content
local MovementSection = GunGameTab:CreateSection("Movement")
local SpeedHackToggle = MovementSection:CreateToggle({
    Name = "Speed Hack",
    CurrentValue = speedHackEnabled,
    Flag = "SpeedHack",
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
        SaveSettings()
    end,
})

local SpeedSlider = MovementSection:CreateSlider({
    Name = "Speed Value",
    Range = {16, 100},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = currentSpeed,
    Flag = "SpeedValue",
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

local JumpHackToggle = MovementSection:CreateToggle({
    Name = "Infinity Jump",
    CurrentValue = jumpHackEnabled,
    Flag = "JumpHack",
    Callback = function(Value)
        jumpHackEnabled = Value
        SaveSettings()
    end,
})

local NoClipToggle = MovementSection:CreateToggle({
    Name = "NoClip",
    CurrentValue = noclipEnabled,
    Flag = "NoClip",
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

-- Visual Section
local VisualSection = GunGameTab:CreateSection("Visual ESP")
local ESPTracersToggle = VisualSection:CreateToggle({
    Name = "ESP Tracers",
    CurrentValue = espTracersEnabled,
    Flag = "ESPTracers",
    Callback = function(Value)
        espTracersEnabled = Value
    end,
})

local ESPBoxToggle = VisualSection:CreateToggle({
    Name = "ESP Box",
    CurrentValue = espBoxEnabled,
    Flag = "ESPBox",
    Callback = function(Value)
        espBoxEnabled = Value
    end,
})

local ESPHealthToggle = VisualSection:CreateToggle({
    Name = "ESP Health",
    CurrentValue = espHealthEnabled,
    Flag = "ESPHealth",
    Callback = function(Value)
        espHealthEnabled = Value
    end,
})

local ESPDistanceToggle = VisualSection:CreateToggle({
    Name = "ESP Distance",
    CurrentValue = espDistanceEnabled,
    Flag = "ESPDistance",
    Callback = function(Value)
        espDistanceEnabled = Value
    end,
})

local ESPCountToggle = VisualSection:CreateToggle({
    Name = "ESP Player Count",
    CurrentValue = espCountEnabled,
    Flag = "ESPCount",
    Callback = function(Value)
        espCountEnabled = Value
        
        if espCountEnabled then
            if not espCountText then
                espCountText = Drawing.new("Text")
                espCountText.Size = 16
                espCountText.Center = true
                espCountText.Outline = true
                espCountText.Color = Color3.fromRGB(170, 0, 170)
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

-- AimBot Section
local AimBotSection = GunGameTab:CreateSection("AimBot")
local AimBotToggle = AimBotSection:CreateToggle({
    Name = "AimBot",
    CurrentValue = aimBotEnabled,
    Flag = "AimBot",
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

local AimBotFOVSlider = AimBotSection:CreateSlider({
    Name = "AimBot FOV",
    Range = {10, 200},
    Increment = 1,
    Suffix = "px",
    CurrentValue = aimBotFOV,
    Flag = "AimBotFOV",
    Callback = function(Value)
        aimBotFOV = Value
        updateFOVCircle()
    end,
})

-- 99 Nights Tab Content
local MainSection = NightsTab:CreateSection("Main Features")
local KillAuraToggle = MainSection:CreateToggle({
    Name = "Kill Aura",
    CurrentValue = ActiveKillAura,
    Flag = "KillAura",
    Callback = function(Value)
        ActiveKillAura = Value
        SaveSettings()
    end,
})

local KillDistanceSlider = MainSection:CreateSlider({
    Name = "Kill Aura Distance",
    Range = {10, 150},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = DistanceForKillAura,
    Flag = "KillDistance",
    Callback = function(Value)
        DistanceForKillAura = Value
        SaveSettings()
    end,
})

local AutoChopToggle = MainSection:CreateToggle({
    Name = "Auto Chop Trees",
    CurrentValue = ActiveAutoChopTree,
    Flag = "AutoChop",
    Callback = function(Value)
        ActiveAutoChopTree = Value
        SaveSettings()
    end,
})

local ChopDistanceSlider = MainSection:CreateSlider({
    Name = "Chop Distance",
    Range = {10, 150},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = DistanceForAutoChopTree,
    Flag = "ChopDistance",
    Callback = function(Value)
        DistanceForAutoChopTree = Value
        SaveSettings()
    end,
})

-- Bring Items Section
local BringSection = NightsTab:CreateSection("Bring Items Settings")
local BringCountSlider = BringSection:CreateSlider({
    Name = "Bring Count",
    Range = {1, 20},
    Increment = 1,
    Suffix = "items",
    CurrentValue = BringCount,
    Flag = "BringCount",
    Callback = function(Value)
        BringCount = Value
        SaveSettings()
    end,
})

local BringSpeedSlider = BringSection:CreateSlider({
    Name = "Bring Speed",
    Range = {50, 500},
    Increment = 10,
    Suffix = "ms",
    CurrentValue = BringDelay,
    Flag = "BringSpeed",
    Callback = function(Value)
        BringDelay = Value
        SaveSettings()
    end,
})

local TeleportTargetDropdown = BringSection:CreateDropdown({
    Name = "Teleport Target",
    Options = {"Campfire", "Player"},
    CurrentOption = BringTarget,
    Flag = "TeleportTarget",
    Callback = function(Option)
        BringTarget = Option
        showNotification("Teleport target: " .. Option)
        SaveSettings()
    end,
})

-- Resources Section
local ResourcesSection = NightsTab:CreateSection("Resources")
local ResourcesButton = ResourcesSection:CreateButton({
    Name = "Bring Logs",
    Callback = function()
        BringItems("Log")
    end,
})

local CoalButton = ResourcesSection:CreateButton({
    Name = "Bring Coal",
    Callback = function()
        BringItems("Coal")
    end,
})

local ChairButton = ResourcesSection:CreateButton({
    Name = "Bring Chairs",
    Callback = function()
        BringItems("Chair")
    end,
})

-- Fuel Section (ИСПРАВЛЕННЫЙ)
local FuelSection = NightsTab:CreateSection("Fuel & Energy")
local FuelCanisterButton = FuelSection:CreateButton({
    Name = "Bring Fuel Canister",
    Callback = function()
        BringItems("Fuel Canister")
    end,
})

local OilBarrelButton = FuelSection:CreateButton({
    Name = "Bring Oil Barrel",
    Callback = function()
        BringItems("Oil Barrel")
    end,
})

local BiofuelButton = FuelSection:CreateButton({
    Name = "Bring Biofuel",
    Callback = function()
        BringItems("Biofuel")
    end,
})

-- Metals Section
local MetalsSection = NightsTab:CreateSection("Metals & Parts")
local BoltButton = MetalsSection:CreateButton({
    Name = "Bring Bolts",
    Callback = function()
        BringItems("Bolt")
    end,
})

local SheetMetalButton = MetalsSection:CreateButton({
    Name = "Bring Sheet Metal",
    Callback = function()
        BringItems("Sheet Metal")
    end,
})

local UFOButton = MetalsSection:CreateButton({
    Name = "Bring UFO Scrap",
    Callback = function()
        BringItems("UFO Scrap")
    end,
})

-- Food & Medical Section
local FoodSection = NightsTab:CreateSection("Food & Medical")
local CarrotButton = FoodSection:CreateButton({
    Name = "Bring Carrots",
    Callback = function()
        BringItems("Carrot")
    end,
})

local PumpkinButton = FoodSection:CreateButton({
    Name = "Bring Pumpkins",
    Callback = function()
        BringItems("Pumpkin")
    end,
})

local MedKitButton = FoodSection:CreateButton({
    Name = "Bring MedKits",
    Callback = function()
        BringItems("MedKit")
    end,
})

-- Weapons Section
local WeaponsSection = NightsTab:CreateSection("Weapons & Tools")
local RifleButton = WeaponsSection:CreateButton({
    Name = "Bring Rifles",
    Callback = function()
        BringItems("Rifle")
    end,
})

local RevolverButton = WeaponsSection:CreateButton({
    Name = "Bring Revolvers",
    Callback = function()
        BringItems("Revolver")
    end,
})

local AmmoButton = WeaponsSection:CreateButton({
    Name = "Bring Rifle Ammo",
    Callback = function()
        BringItems("Rifle Ammo")
    end,
})

-- Player Tab Content
local PlayerSection = PlayerTab:CreateSection("Player Features")
local TeleportCampfireButton = PlayerSection:CreateButton({
    Name = "Teleport to Campfire",
    Callback = function()
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(CampfirePosition)
            showNotification("Teleported to Campfire!")
        else
            showNotification("Character not found!")
        end
    end,
})

-- Исправленный Anti-AFK
local AntiAFKToggle = PlayerSection:CreateToggle({
    Name = "Anti AFK",
    CurrentValue = antiAFKEnabled,
    Flag = "AntiAFK",
    Callback = function(Value)
        antiAFKEnabled = Value
        if antiAFKEnabled then
            EnableAntiAFK()
            showNotification("Anti-AFK Enabled")
        else
            DisableAntiAFK()
            showNotification("Anti-AFK Disabled")
        end
        SaveSettings()
    end,
})

-- Initialize ESP for existing players
for _, otherPlayer in pairs(Players:GetPlayers()) do
    createESP(otherPlayer)
end

Players.PlayerAdded:Connect(function(newPlayer)
    createESP(newPlayer)
end)

Players.PlayerRemoving:Connect(function(leftPlayer)
    cleanupESP(leftPlayer)
end)

-- ESP Count Update
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

-- Jump Hack
UserInputService.JumpRequest:Connect(function()
    if jumpHackEnabled and player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Create FOV Circle
createFOVCircle()

-- Восстанавливаем GUI после смерти
player.CharacterAdded:Connect(function()
    wait(2)
    
    -- Восстанавливаем настройки SpeedHack после смерти
    if speedHackEnabled then
        wait(1)
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = currentSpeed
        end
    end
end)

showNotification("SANSTRO Menu Loaded!")