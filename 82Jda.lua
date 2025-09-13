local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Main Window Configuration
local Window = Rayfield:CreateWindow({
   Name = "BY @SFXCL",
   Icon = 0,
   LoadingTitle = "@SFXCL",
   LoadingSubtitle = "Survive 99 Nights in the Forest",
   Theme = "Default",
   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "MHXHub",
      FileName = "Config"
   },
   Discord = {
      Enabled = true,
      Invite = "E2TqYRsRP4",
      RememberJoins = true
   },
   KeySystem = false
})

-- Variables for Toggles
local ActiveHitbox, ActiveFly, ActiveWalkSpeed, ActiveGodMode = false, false, false, false
local ActivePlayerEsp, ActiveScrapEsp, ActiveWoodEsp, ActiveFoodEsp, ActiveMedkitEsp, ActiveForestGemEsp, ActiveCulisticGemEsp, ActiveNpcEsp, ActiveChestEsp = false, false, false, false, false, false, false, false, false
local ActiveKillAura = false
local HitboxSize = 10
local DistanceForKillAura = 25

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local IYMouse = LocalPlayer:GetMouse()
local FLYING = false
local QEfly = true
local iyflyspeed = 1
local vehicleflyspeed = 1

-- Fly Function (PC)
local function sFLY(vfly)
    repeat wait() until LocalPlayer and LocalPlayer.Character and LocalPlayer.Character:WaitForChild("HumanoidRootPart") and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    repeat wait() until IYMouse
    if flyKeyDown or flyKeyUp then flyKeyDown:Disconnect() flyKeyUp:Disconnect() end

    local T = LocalPlayer.Character:WaitForChild("HumanoidRootPart")
    local CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
    local lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
    local SPEED = 0

    local function FLY()
        FLYING = true
        local BG = Instance.new('BodyGyro')
        local BV = Instance.new('BodyVelocity')
        BG.P = 9e4
        BG.Parent = T
        BV.Parent = T
        BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        BG.CFrame = T.CFrame
        BV.Velocity = Vector3.new(0, 0, 0)
        BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        task.spawn(function()
            repeat wait()
                if not vfly and LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
                    LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = true
                end
                if CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0 then
                    SPEED = 50
                elseif not (CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0) and SPEED ~= 0 then
                    SPEED = 0
                end
                if (CONTROL.L + CONTROL.R) ~= 0 or (CONTROL.F + CONTROL.B) ~= 0 or (CONTROL.Q + CONTROL.E) ~= 0 then
                    BV.Velocity = ((Workspace.CurrentCamera.CoordinateFrame.lookVector * (CONTROL.F + CONTROL.B)) + ((Workspace.CurrentCamera.CoordinateFrame * CFrame.new(CONTROL.L + CONTROL.R, (CONTROL.F + CONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - Workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
                    lCONTROL = {F = CONTROL.F, B = CONTROL.B, L = CONTROL.L, R = CONTROL.R}
                elseif (CONTROL.L + CONTROL.R) == 0 and (CONTROL.F + CONTROL.B) == 0 and (CONTROL.Q + CONTROL.E) == 0 and SPEED ~= 0 then
                    BV.Velocity = ((Workspace.CurrentCamera.CoordinateFrame.lookVector * (lCONTROL.F + lCONTROL.B)) + ((Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lCONTROL.L + lCONTROL.R, (lCONTROL.F + lCONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - Workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
                else
                    BV.Velocity = Vector3.new(0, 0, 0)
                end
                BG.CFrame = Workspace.CurrentCamera.CoordinateFrame
            until not FLYING
            CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
            lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
            SPEED = 0
            BG:Destroy()
            BV:Destroy()
            if LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
                LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
            end
        end)
    end
    flyKeyDown = IYMouse.KeyDown:Connect(function(KEY)
        if KEY:lower() == 'w' then
            CONTROL.F = (vfly and vehicleflyspeed or iyflyspeed)
        elseif KEY:lower() == 's' then
            CONTROL.B = - (vfly and vehicleflyspeed or iyflyspeed)
        elseif KEY:lower() == 'a' then
            CONTROL.L = - (vfly and vehicleflyspeed or iyflyspeed)
        elseif KEY:lower() == 'd' then 
            CONTROL.R = (vfly and vehicleflyspeed or iyflyspeed)
        elseif QEfly and KEY:lower() == 'e' then
            CONTROL.Q = (vfly and vehicleflyspeed or iyflyspeed)*2
        elseif QEfly and KEY:lower() == 'q' then
            CONTROL.E = -(vfly and vehicleflyspeed or iyflyspeed)*2
        end
        pcall(function() Workspace.CurrentCamera.CameraType = Enum.CameraType.Track end)
    end)
    flyKeyUp = IYMouse.KeyUp:Connect(function(KEY)
        if KEY:lower() == 'w' then
            CONTROL.F = 0
        elseif KEY:lower() == 's' then
            CONTROL.B = 0
        elseif KEY:lower() == 'a' then
            CONTROL.L = 0
        elseif KEY:lower() == 'd' then
            CONTROL.R = 0
        elseif KEY:lower() == 'e' then
            CONTROL.Q = 0
        elseif KEY:lower() == 'q' then
            CONTROL.E = 0
        end
    end)
    FLY()
end

local function NOFLY()
    FLYING = false
    if flyKeyDown or flyKeyUp then flyKeyDown:Disconnect() flyKeyUp:Disconnect() end
    if LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
        LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
    end
    pcall(function() Workspace.CurrentCamera.CameraType = Enum.CameraType.Custom end)
end

-- ESP Function
local function CreateEsp(Char, Color, Text, Parent, Number)
    if not Char then return end
    if Char:FindFirstChild("ESP") and Char:FindFirstChildOfClass("Highlight") then return end
    local highlight = Char:FindFirstChildOfClass("Highlight") or Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.Adornee = Char
    highlight.FillColor = Color
    highlight.FillTransparency = 1
    highlight.OutlineColor = Color
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Enabled = true
    highlight.Parent = Char

    local billboard = Char:FindFirstChild("ESP") or Instance.new("BillboardGui")
    billboard.Name = "ESP"
    billboard.Size = UDim2.new(0, 50, 0, 25)
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, Number, 0)
    billboard.Adornee = Parent
    billboard.Enabled = true
    billboard.Parent = Parent

    local label = billboard:FindFirstChildOfClass("TextLabel") or Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = Text
    label.TextColor3 = Color
    label.TextScaled = true
    label.Parent = billboard

    task.spawn(function()
        local Camera = Workspace.CurrentCamera
        while highlight and billboard and Parent and Parent.Parent do
            local cameraPosition = Camera and Camera.CFrame.Position
            if cameraPosition and Parent and Parent:IsA("BasePart") then
                local distance = (cameraPosition - Parent.Position).Magnitude
                label.Text = Text .. " (" .. math.floor(distance + 0.5) .. " m)"
            end
            wait(0.1)
        end
    end)
end

local function KeepEsp(Char, Parent)
    if Char and Char:FindFirstChildOfClass("Highlight") and Parent:FindFirstChildOfClass("BillboardGui") then
        Char:FindFirstChildOfClass("Highlight"):Destroy()
        Parent:FindFirstChildOfClass("BillboardGui"):Destroy()
    end
end

-- Drag Item Function
local function DragItem(Item)
    game:GetService("ReplicatedStorage").RemoteEvents.RequestStartDraggingItem:FireServer(Item)
    wait(0.0001)
    game:GetService("ReplicatedStorage").RemoteEvents.StopDraggingItem:FireServer(Item)
end

-- Page 1: Player
local PlayerTab = Window:CreateTab("Player")

-- Hitbox Slider
PlayerTab:CreateSlider({
    Name = "Hitbox Size",
    Range = {5, 20},
    Increment = 1,
    CurrentValue = 10,
    Flag = "HitboxSize",
    Callback = function(Value)
        HitboxSize = Value
        ActiveHitbox = true
        task.spawn(function()
            while ActiveHitbox do
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local hrp = player.Character.HumanoidRootPart
                        hrp.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
                    end
                end
                wait(0.1)
            end
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = player.Character.HumanoidRootPart
                    hrp.Size = Vector3.new(1, 2, 1) -- Default size
                end
            end
        end)
    end
})

-- Fly Toggle
PlayerTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Flag = "FlyToggle",
    Callback = function(Value)
        ActiveFly = Value
        if Value then
            sFLY(false)
        else
            NOFLY()
        end
    end
})

-- Walk Speed Toggle
PlayerTab:CreateToggle({
    Name = "Walk Speed (150)",
    CurrentValue = false,
    Flag = "WalkSpeedToggle",
    Callback = function(Value)
        ActiveWalkSpeed = Value
        task.spawn(function()
            while ActiveWalkSpeed do
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                    LocalPlayer.Character.Humanoid.WalkSpeed = 150
                end
                wait(0.1)
            end
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 16 -- Default speed
            end
        end)
    end
})

-- God Mode Toggle
PlayerTab:CreateToggle({
    Name = "God Mode",
    CurrentValue = false,
    Flag = "GodModeToggle",
    Callback = function(Value)
        ActiveGodMode = Value
        task.spawn(function()
            while ActiveGodMode do
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                    LocalPlayer.Character.Humanoid.Health = LocalPlayer.Character.Humanoid.MaxHealth
                    -- Block jumpscare and damage (assuming RemoteEvents)
                    pcall(function()
                        game:GetService("ReplicatedStorage").RemoteEvents.DamagePlayer:FireServer(0)
                    end)
                end
                wait(0.1)
            end
        end)
    end
})

-- Page 2: ESP
local EspTab = Window:CreateTab("ESP")

-- Player ESP
EspTab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,
    Flag = "PlayerEsp",
    Callback = function(Value)
        ActivePlayerEsp = Value
        task.spawn(function()
            while ActivePlayerEsp do
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        CreateEsp(player.Character, Color3.fromRGB(0, 0, 255), player.Name, player.Character.HumanoidRootPart, 3)
                    end
                end
                wait(0.1)
            end
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    KeepEsp(player.Character, player.Character.HumanoidRootPart)
                end
            end
        end)
    end
})

-- Scrap ESP
EspTab:CreateToggle({
    Name = "Scrap ESP",
    CurrentValue = false,
    Flag = "ScrapEsp",
    Callback = function(Value)
        ActiveScrapEsp = Value
        task.spawn(function()
            while ActiveScrapEsp do
                for _, obj in pairs(Workspace.Items:GetChildren()) do
                    if obj:IsA("Model") and obj.Name:match("Scrap") and obj.PrimaryPart then
                        CreateEsp(obj, Color3.fromRGB(0, 255, 0), obj.Name .. " (Metal)", obj.PrimaryPart, 2)
                    end
                end
                wait(0.1)
            end
            for _, obj in pairs(Workspace.Items:GetChildren()) do
                if obj:IsA("Model") and obj.Name:match("Scrap") and obj.PrimaryPart then
                    KeepEsp(obj, obj.PrimaryPart)
                end
            end
        end)
    end
})

-- Wood ESP
EspTab:CreateToggle({
    Name = "Wood ESP",
    CurrentValue = false,
    Flag = "WoodEsp",
    Callback = function(Value)
        ActiveWoodEsp = Value
        task.spawn(function()
            while ActiveWoodEsp do
                for _, obj in pairs(Workspace.Items:GetChildren()) do
                    if obj:IsA("Model") and obj.Name == "Log" and obj.PrimaryPart then
                        CreateEsp(obj, Color3.fromRGB(255, 0, 0), "Wood", obj.PrimaryPart, 2)
                    end
                end
                wait(0.1)
            end
            for _, obj in pairs(Workspace.Items:GetChildren()) do
                if obj:IsA("Model") and obj.Name == "Log" and obj.PrimaryPart then
                    KeepEsp(obj, obj.PrimaryPart)
                end
            end
        end)
    end
})

-- Food ESP
EspTab:CreateToggle({
    Name = "Food ESP",
    CurrentValue = false,
    Flag = "FoodEsp",
    Callback = function(Value)
        ActiveFoodEsp = Value
        task.spawn(function()
            while ActiveFoodEsp do
                for _, obj in pairs(Workspace.Items:GetChildren()) do
                    if obj:IsA("Model") and obj.Name:match("Food") and obj.PrimaryPart then
                        CreateEsp(obj, Color3.fromRGB(128, 0, 128), obj.Name, obj.PrimaryPart, 2)
                    end
                end
                wait(0.1)
            end
            for _, obj in pairs(Workspace.Items:GetChildren()) do
                if obj:IsA("Model") and obj.Name:match("Food") and obj.PrimaryPart then
                    KeepEsp(obj, obj.PrimaryPart)
                end
            end
        end)
    end
})

-- Medkit/Bandage ESP
EspTab:CreateToggle({
    Name = "Medkit/Bandage ESP",
    CurrentValue = false,
    Flag = "MedkitEsp",
    Callback = function(Value)
        ActiveMedkitEsp = Value
        task.spawn(function()
            while ActiveMedkitEsp do
                for _, obj in pairs(Workspace.Items:GetChildren()) do
                    if obj:IsA("Model") and (obj.Name == "Medkit" or obj.Name == "Bandage") and obj.PrimaryPart then
                        CreateEsp(obj, Color3.fromRGB(255, 105, 180), obj.Name, obj.PrimaryPart, 2)
                    end
                end
                wait(0.1)
            end
            for _, obj in pairs(Workspace.Items:GetChildren()) do
                if obj:IsA("Model") and (obj.Name == "Medkit" or obj.Name == "Bandage") and obj.PrimaryPart then
                    KeepEsp(obj, obj.PrimaryPart)
                end
            end
        end)
    end
})

-- Piece of Forest ESP
EspTab:CreateToggle({
    Name = "Piece of Forest ESP",
    CurrentValue = false,
    Flag = "ForestGemEsp",
    Callback = function(Value)
        ActiveForestGemEsp = Value
        task.spawn(function()
            while ActiveForestGemEsp do
                for _, obj in pairs(Workspace.Items:GetChildren()) do
                    if obj:IsA("Model") and obj.Name == "Piece of Forest" and obj.PrimaryPart then
                        CreateEsp(obj, Color3.fromRGB(0, 255, 0), "Forest Gem", obj.PrimaryPart, 2)
                    end
                end
                wait(0.1)
            end
            for _, obj in pairs(Workspace.Items:GetChildren()) do
                if obj:IsA("Model") and obj.Name == "Piece of Forest" and obj.PrimaryPart then
                    KeepEsp(obj, obj.PrimaryPart)
                end
            end
        end)
    end
})

-- Culistic Gem ESP
EspTab:CreateToggle({
    Name = "Culistic Gem ESP",
    CurrentValue = false,
    Flag = "CulisticGemEsp",
    Callback = function(Value)
        ActiveCulisticGemEsp = Value
        task.spawn(function()
            while ActiveCulisticGemEsp do
                for _, obj in pairs(Workspace.Items:GetChildren()) do
                    if obj:IsA("Model") and obj.Name == "Culistic Gem" and obj.PrimaryPart then
                        CreateEsp(obj, Color3.fromRGB(255, 255, 255), "Culistic Gem", obj.PrimaryPart, 2)
                    end
                end
                wait(0.1)
            end
            for _, obj in pairs(Workspace.Items:GetChildren()) do
                if obj:IsA("Model") and obj.Name == "Culistic Gem" and obj.PrimaryPart then
                    KeepEsp(obj, obj.PrimaryPart)
                end
            end
        end)
    end
})

-- NPC ESP
EspTab:CreateToggle({
    Name = "NPC ESP",
    CurrentValue = false,
    Flag = "NpcEsp",
    Callback = function(Value)
        ActiveNpcEsp = Value
        task.spawn(function()
            while ActiveNpcEsp do
                for _, obj in pairs(Workspace.Characters:GetChildren()) do
                    if obj:IsA("Model") and obj.PrimaryPart then
                        CreateEsp(obj, Color3.fromRGB(255, 165, 0), obj.Name, obj.PrimaryPart, 3)
                    end
                end
                wait(0.1)
            end
            for _, obj in pairs(Workspace.Characters:GetChildren()) do
                if obj:IsA("Model") and obj.PrimaryPart then
                    KeepEsp(obj, obj.PrimaryPart)
                end
            end
        end)
    end
})

-- Chest ESP
EspTab:CreateToggle({
    Name = "Chest ESP",
    CurrentValue = false,
    Flag = "ChestEsp",
    Callback = function(Value)
        ActiveChestEsp = Value
        task.spawn(function()
            while ActiveChestEsp do
                for _, obj in pairs(Workspace:GetChildren()) do
                    if obj:IsA("Model") and obj.Name:match("Chest") and obj.PrimaryPart then
                        CreateEsp(obj, Color3.fromRGB(255, 255, 0), "Chest", obj.PrimaryPart, 2)
                    end
                end
                wait(0.1)
            end
            for _, obj in pairs(Workspace:GetChildren()) do
                if obj:IsA("Model") and obj.Name:match("Chest") and obj.PrimaryPart then
                    KeepEsp(obj, obj.PrimaryPart)
                end
            end
        end)
    end
})

-- Page 3: Weapons
local WeaponsTab = Window:CreateTab("Weapons")

-- Weapons/Armors Window
WeaponsTab:CreateButton({
    Name = "Open Weapons/Armors",
    Callback = function()
        local WeaponsWindow = Rayfield:CreateWindow({
            Name = "Weapons and Armors",
            LoadingTitle = "Select Item",
            LoadingSubtitle = "MHX HUB",
            Theme = "Default"
        })
        local items = {
            "Strong Axe", "Good Axe", "Rifle", "Shotgun", "Spear", "Alien Weapon",
            "Strong Flashlight", "Old Flashlight", "Iron Body", "Leather Body", "Alien Body"
        }
        for _, item in pairs(items) do
            WeaponsWindow:CreateButton({
                Name = item,
                Callback = function()
                    -- Assuming a RemoteEvent to give the item
                    pcall(function()
                        game:GetService("ReplicatedStorage").RemoteEvents.GiveItem:FireServer(item)
                    end)
                end
            })
        end
    end
})

-- Page 4: Explosions
local ExplosionsTab = Window:CreateTab("Explosions")

-- Kill Aura
ExplosionsTab:CreateToggle({
    Name = "Kill Aura",
    CurrentValue = false,
    Flag = "KillAura",
    Callback = function(Value)
        ActiveKillAura = Value
        task.spawn(function()
            while ActiveKillAura do
                for _, obj in pairs(Workspace.Characters:GetChildren()) do
                    if obj:IsA("Model") and obj.PrimaryPart and obj.Name ~= LocalPlayer.Name then
                        local distance = (LocalPlayer.Character.HumanoidRootPart.Position - obj.PrimaryPart.Position).Magnitude
                        if distance <= DistanceForKillAura then
                            pcall(function()
                                game:GetService("ReplicatedStorage").RemoteEvents.DamageEnemy:FireServer(obj, 1000)
                            end)
                        end
                    end
                end
                wait(0.1)
            end
        end)
    end
})

-- Break the Map
ExplosionsTab:CreateButton({
    Name = "Break the Map",
    Callback = function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0, -50, 0)) -- Teleport behind map walls
        end
    end
})

-- Kill All Enemies
ExplosionsTab:CreateButton({
    Name = "Kill All Enemies",
    Callback = function()
        for _, obj in pairs(Workspace.Characters:GetChildren()) do
            if obj:IsA("Model") and obj.PrimaryPart and obj.Name ~= LocalPlayer.Name then
                pcall(function()
                    game:GetService("ReplicatedStorage").RemoteEvents.DamageEnemy:FireServer(obj, 1000)
                end)
            end
        end
    end
})

-- Spawn All Metals to Machine
ExplosionsTab:CreateButton({
    Name = "Spawn All Metals to Machine",
    Callback = function()
        local machine = Workspace:FindFirstChild("MetalMachine") -- Adjust to actual machine name
        if machine and machine.PrimaryPart then
            for _, obj in pairs(Workspace.Items:GetChildren()) do
                if obj:IsA("Model") and obj.Name:match("Scrap") and obj.PrimaryPart then
                    obj.PrimaryPart.CFrame = machine.PrimaryPart.CFrame
                    DragItem(obj)
                end
            end
        end
    end
})

-- Spawn All Wood to Machine
ExplosionsTab:CreateButton({
    Name = "Spawn All Wood to Machine",
    Callback = function()
        local machine = Workspace:FindFirstChild("WoodMachine") -- Adjust to actual machine name
        if machine and machine.PrimaryPart then
            for _, obj in pairs(Workspace.Items:GetChildren()) do
                if obj:IsA("Model") and obj.Name == "Log" and obj.PrimaryPart then
                    obj.PrimaryPart.CFrame = machine.PrimaryPart.CFrame
                    DragItem(obj)
                end
            end
        end
    end
})

-- All Fuels to Fire
ExplosionsTab:CreateButton({
    Name = "All Fuels to Fire",
    Callback = function()
        local fire = Workspace:FindFirstChild("Fire") -- Adjust to actual fire name
        if fire and fire.PrimaryPart then
            for _, obj in pairs(Workspace.Items:GetChildren()) do
                if obj:IsA("Model") and (obj.Name == "Petrol" or obj.Name == "Gas Can" or obj.Name == "Coal" or obj.Name == "Log" or obj.Name:match("Corpse")) and obj.PrimaryPart then
                    obj.PrimaryPart.CFrame = fire.PrimaryPart.CFrame
                    DragItem(obj)
                end
            end
        end
    end
})

-- AFK Mode
ExplosionsTab:CreateButton({
    Name = "AFK Mode",
    Callback = function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0, 100, 0)) -- Spawn in air
            task.spawn(function()
                while true do
                    pcall(function()
                        game:GetService("ReplicatedStorage").RemoteEvents.EatFood:FireServer("Food") -- Auto-eat
                        game:GetService("ReplicatedStorage").RemoteEvents.AntiAfk:FireServer() -- Anti-AFK
                    end)
                    wait(60) -- Eat every minute
                end
            end)
        end
    end
})

-- Page 5: Items
local ItemsTab = Window:CreateTab("Items")

-- Spawn Woods
ItemsTab:CreateButton({
    Name = "Spawn Woods",
    Callback = function()
        for _, obj in pairs(Workspace.Items:GetChildren()) do
            if obj:IsA("Model") and obj.Name == "Log" and obj.PrimaryPart then
                obj.PrimaryPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
                DragItem(obj)
            end
        end
    end
})

-- Spawn Bandages/Medkits
ItemsTab:CreateButton({
    Name = "Spawn Bandages/Medkits",
    Callback = function()
        for _, obj in pairs(Workspace.Items:GetChildren()) do
            if obj:IsA("Model") and (obj.Name == "Medkit" or obj.Name == "Bandage") and obj.PrimaryPart then
                obj.PrimaryPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
                DragItem(obj)
            end
        end
    end
})

-- Spawn Fuels
ItemsTab:CreateButton({
    Name = "Spawn Fuels",
    Callback = function()
        for _, obj in pairs(Workspace.Items:GetChildren()) do
            if obj:IsA("Model") and (obj.Name == "Petrol" or obj.Name == "Gas Can" or obj.Name == "Coal" or obj.Name == "Log" or obj.Name:match("Corpse")) and obj.PrimaryPart then
                obj.PrimaryPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
                DragItem(obj)
            end
        end
    end
})

-- Spawn Foods
ItemsTab:CreateButton({
    Name = "Spawn Foods",
    Callback = function()
        for _, obj in pairs(Workspace.Items:GetChildren()) do
            if obj:IsA("Model") and obj.Name:match("Food") and obj.PrimaryPart then
                obj.PrimaryPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
                DragItem(obj)
            end
        end
    end
})

-- Page 6: Other
local OtherTab = Window:CreateTab("Other")

-- Skip Players/Chests Cooldown
OtherTab:CreateButton({
    Name = "Skip Players/Chests Cooldown",
    Callback = function()
        pcall(function()
            game:GetService("ReplicatedStorage").RemoteEvents.SkipCooldown:FireServer("PlayerHeal")
            game:GetService("ReplicatedStorage").RemoteEvents.SkipCooldown:FireServer("ChestOpen")
        end)
    end
})

-- Notify on Load
Rayfield:Notify({
    Title = "BY @SFXCL",
    Content = "Version 1.0 - Enjoy!",
    Duration = 5,
    Image = "rewind"
})