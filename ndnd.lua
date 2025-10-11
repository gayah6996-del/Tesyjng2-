-- VEX OP - 99 Nights in the Forest

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "VEX OP - 99 Nights in the Forest",
    LoadingTitle = "VEX OP",
    LoadingSubtitle = "by VEX HUB",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "VEX OP",
        FileName = "99 Nights"
    }
})

-- Main Tab
local MainTab = Window:CreateTab("Main", "rbxassetid://4483345998")

-- Auto Section
local AutoSection = MainTab:CreateSection("Auto")
local AutoTreeToggle = AutoSection:CreateToggle({
    Name = "Auto Tree",
    CurrentValue = false,
    Flag = "AutoTree",
    Callback = function(Value)
        ActiveAutoChopTree = Value
    end,
})

local KillAuraToggle = AutoSection:CreateToggle({
    Name = "Kill Aura", 
    CurrentValue = false,
    Flag = "KillAura",
    Callback = function(Value)
        ActiveKillAura = Value
    end,
})

-- Bring Section
local BringSection = MainTab:CreateSection("Bring")
local BringCountSlider = BringSection:CreateSlider({
    Name = "Bring Count",
    Range = {1, 200},
    Increment = 1,
    Suffix = "items",
    CurrentValue = 2,
    Flag = "BringCount",
    Callback = function(Value)
        BringCount = Value
    end,
})

local BringDelaySlider = BringSection:CreateSlider({
    Name = "Bring Delay",
    Range = {0, 1000},
    Increment = 10,
    Suffix = "ms",
    CurrentValue = 600,
    Flag = "BringDelay", 
    Callback = function(Value)
        BringDelay = Value
    end,
})

-- Combat Section  
local CombatSection = MainTab:CreateSection("Combat")
local KillAuraDistance = CombatSection:CreateSlider({
    Name = "Kill Aura Distance",
    Range = {25, 10000},
    Increment = 25,
    Suffix = "studs",
    CurrentValue = 25,
    Flag = "KillAuraDistance",
    Callback = function(Value)
        DistanceForKillAura = Value
    end,
})

-- Player Section
local PlayerSection = MainTab:CreateSection("Player")
local JumpButton = PlayerSection:CreateButton({
    Name = "Jump",
    Callback = function()
        JumpCharacter()
    end,
})

-- ESP Section
local EspSection = MainTab:CreateSection("Esp")
local PlayerEspToggle = EspSection:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,
    Flag = "PlayerESP",
    Callback = function(Value)
        -- ESP functionality here
    end,
})

-- Teleport Section
local TeleportSection = MainTab:CreateSection("Teleport")
local TeleportBaseButton = TeleportSection:CreateButton({
    Name = "Teleport to Base",
    Callback = function()
        local character = Player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = CFrame.new(CampfirePosition)
            Rayfield:Notify({
                Title = "Teleport",
                Content = "Teleported to campfire!",
                Duration = 2,
                Image = "rbxassetid://4483345998"
            })
        end
    end,
})

-- Medical Items Tab
local MedicalTab = Window:CreateTab("Medical Items", "rbxassetid://4483345998")

MedicalTab:CreateSection("Bring Medical Items")
MedicalTab:CreateLabel("Please unlock first zone before trying to Bring!")

-- Medical Items functionality
local MedicalSection = MedicalTab:CreateSection("Medical Items Selection")
local MedicalDropdown = MedicalSection:CreateDropdown({
    Name = "Select Medical Item",
    Options = {"Bandage", "Medkit", "All Medical"},
    CurrentOption = "Bandage",
    Flag = "MedicalItem",
    Callback = function(Option)
        SelectedMedicalItem = Option
    end,
})

local BringMedicalButton = MedicalSection:CreateButton({
    Name = "Bring Medical Items",
    Callback = function()
        TeleportMedicalItems(SelectedMedicalItem)
    end,
})

-- Equipment Tab
local EquipmentTab = Window:CreateTab("Equipment", "rbxassetid://4483345998")

-- Select Equipment Section
local SelectEquipmentSection = EquipmentTab:CreateSection("Select Equipment Items")
EquipmentTab:CreateLabel("Choose items to bring")

local EquipmentDropdown = SelectEquipmentSection:CreateDropdown({
    Name = "Equipment Type",
    Options = {"Axe", "Chainsaw", "All Tools"},
    CurrentOption = "Axe", 
    Flag = "EquipmentType",
    Callback = function(Option)
        SelectedEquipment = Option
    end,
})

-- Bring Equipment Section  
local BringEquipmentSection = EquipmentTab:CreateSection("Bring Equipment Items")
EquipmentTab:CreateLabel("Please unlock first zone before trying to Bring!")

local BringEquipmentButton = BringEquipmentSection:CreateButton({
    Name = "Bring Equipment",
    Callback = function()
        TeleportEquipment(SelectedEquipment)
    end,
})

-- Original functionality variables
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local ActiveKillAura = false
local ActiveAutoChopTree = false
local DistanceForKillAura = 25
local DistanceForAutoChopTree = 25
local CampfirePosition = Vector3.new(0, 10, 0)
local BringCount = 2
local BringDelay = 600

-- Original functions
local function JumpCharacter()
    local character = Player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    
    if not humanoid then 
        Rayfield:Notify({
            Title = "Error",
            Content = "Character not found!",
            Duration = 2,
            Image = "rbxassetid://4483345998"
        })
        return
    end
    
    humanoid.Jump = true
    Rayfield:Notify({
        Title = "Jump",
        Content = "Character jumped!",
        Duration = 1,
        Image = "rbxassetid://4483345998"
    })
end

local function TeleportMedicalItems(itemType)
    local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if not root then 
        Rayfield:Notify({
            Title = "Error",
            Content = "Character not found!",
            Duration = 2,
            Image = "rbxassetid://4483345998"
        })
        return 
    end
    
    local medicalItems = {}
    
    for _, item in pairs(workspace.Items:GetChildren()) do
        if item:IsA("Model") then
            local itemName = item.Name:lower()
            
            if itemType == "All Medical" then
                if itemName:find("bandage") or itemName:find("medkit") then
                    local main = item:FindFirstChildWhichIsA("BasePart")
                    if main then
                        table.insert(medicalItems, main)
                    end
                end
            elseif itemType == "Bandage" then
                if itemName:find("bandage") then
                    local main = item:FindFirstChildWhichIsA("BasePart")
                    if main then
                        table.insert(medicalItems, main)
                    end
                end
            elseif itemType == "Medkit" then
                if itemName:find("medkit") then
                    local main = item:FindFirstChildWhichIsA("BasePart")
                    if main then
                        table.insert(medicalItems, main)
                    end
                end
            end
        end
    end
    
    local teleported = 0
    for i = 1, math.min(BringCount, #medicalItems) do
        local item = medicalItems[i]
        item.CFrame = CFrame.new(root.Position.X, root.Position.Y + 5, root.Position.Z) + Vector3.new(math.random(-5,5), 0, math.random(-5,5))
        item.Anchored = false
        item.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        teleported = teleported + 1
        
        if BringDelay > 0 then
            wait(BringDelay / 1000)
        end
    end
    
    if teleported > 0 then
        Rayfield:Notify({
            Title = "Medical Items",
            Content = "Teleported " .. teleported .. " " .. itemType .. " items!",
            Duration = 2,
            Image = "rbxassetid://4483345998"
        })
    else
        Rayfield:Notify({
            Title = "Medical Items",
            Content = "No " .. itemType .. " found!",
            Duration = 2,
            Image = "rbxassetid://4483345998"
        })
    end
end

local function TeleportEquipment(equipmentType)
    local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if not root then 
        Rayfield:Notify({
            Title = "Error",
            Content = "Character not found!",
            Duration = 2,
            Image = "rbxassetid://4483345998"
        })
        return 
    end
    
    local equipmentItems = {}
    
    for _, item in pairs(workspace.Items:GetChildren()) do
        if item:IsA("Model") then
            local itemName = item.Name:lower()
            
            if equipmentType == "All Tools" then
                if itemName:find("axe") or itemName:find("chainsaw") then
                    local main = item:FindFirstChildWhichIsA("BasePart")
                    if main then
                        table.insert(equipmentItems, main)
                    end
                end
            elseif equipmentType == "Axe" then
                if itemName:find("axe") then
                    local main = item:FindFirstChildWhichIsA("BasePart")
                    if main then
                        table.insert(equipmentItems, main)
                    end
                end
            elseif equipmentType == "Chainsaw" then
                if itemName:find("chainsaw") then
                    local main = item:FindFirstChildWhichIsA("BasePart")
                    if main then
                        table.insert(equipmentItems, main)
                    end
                end
            end
        end
    end
    
    local teleported = 0
    for i = 1, math.min(BringCount, #equipmentItems) do
        local item = equipmentItems[i]
        item.CFrame = CFrame.new(root.Position.X, root.Position.Y + 5, root.Position.Z) + Vector3.new(math.random(-5,5), 0, math.random(-5,5))
        item.Anchored = false
        item.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        teleported = teleported + 1
        
        if BringDelay > 0 then
            wait(BringDelay / 1000)
        end
    end
    
    if teleported > 0 then
        Rayfield:Notify({
            Title = "Equipment",
            Content = "Teleported " .. teleported .. " " .. equipmentType .. " items!",
            Duration = 2,
            Image = "rbxassetid://4483345998"
        })
    else
        Rayfield:Notify({
            Title = "Equipment",
            Content = "No " .. equipmentType .. " found!",
            Duration = 2,
            Image = "rbxassetid://4483345998"
        })
    end
end

-- Original game loops
task.spawn(function()
    while true do
        if ActiveKillAura then 
            local player = game.Players.LocalPlayer
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

task.spawn(function()
    while true do
        if ActiveAutoChopTree then 
            local player = game.Players.LocalPlayer
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

Rayfield:LoadConfiguration()

print("VEX OP - 99 Nights in the Forest loaded successfully!")