--// 99 Nights in the Forest Script with Rayfield GUI //--

-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Window Setup
local Window = Rayfield:CreateWindow({
    Name = "99 Nights",
    LoadingTitle = "99 Nights Script",
    LoadingSubtitle = "by Rayfield",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "99NightsSettings"
    },
    Discord = {
        Enabled = false,
        Invite = "",
        RememberJoins = true
    },
    KeySystem = false,
})

-- Variables
local teleportTargets = {
    "Alien", "Alien Chest", "Alien Shelf", "Alpha Wolf", "Alpha Wolf Pelt", "Anvil Base", "Apple", "Bandage", "Bear", "Berry",
    "Bolt", "Broken Fan", "Broken Microwave", "Bunny", "Bunny Foot", "Cake", "Carrot", "Chair Set", "Chest", "Chilli",
    "Coal", "Coin Stack", "Crossbow Cultist", "Cultist", "Cultist Gem", "Deer", "Fuel Canister", "Giant Sack", "Good Axe", "Iron Body",
    "Item Chest", "Item Chest2", "Item Chest3", "Item Chest4", "Item Chest6", "Laser Fence Blueprint", "Laser Sword", "Leather Body", "Log", "Lost Child",
    "Lost Child2", "Lost Child3", "Lost Child4", "Medkit", "Meat? Sandwich", "Morsel", "Old Car Engine", "Old Flashlight", "Old Radio", "Oil Barrel",
    "Raygun", "Revolver", "Revolver Ammo", "Rifle", "Rifle Ammo", "Riot Shield", "Sapling", "Seed Box", "Sheet Metal", "Spear",
    "Steak", "Stronghold Diamond Chest", "Tyre", "UFO Component", "UFO Junk", "Washing Machine", "Wolf", "Wolf Corpse", "Wolf Pelt"
}
local AimbotTargets = {"Alien", "Alpha Wolf", "Wolf", "Crossbow Cultist", "Cultist", "Bunny", "Bear", "Polar Bear"}
local espEnabled = false
local npcESPEnabled = false
local ignoreDistanceFrom = Vector3.new(0, 0, 0)
local minDistance = 50
local AutoTreeFarmEnabled = false

-- Mobile touch detection
local isMobile = UserInputService.TouchEnabled

-- Touch controls for mobile
local touchControls = {
    flyForward = false,
    flyBackward = false,
    flyLeft = false,
    flyRight = false,
    flyUp = false,
    flyDown = false
}

-- Create mobile control buttons if on mobile
if isMobile then
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MobileControls"
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    -- Fly controls container
    local flyContainer = Instance.new("Frame")
    flyContainer.Name = "FlyControls"
    flyContainer.Size = UDim2.new(0, 200, 0, 150)
    flyContainer.Position = UDim2.new(0, 10, 0.5, -75)
    flyContainer.BackgroundTransparency = 0.7
    flyContainer.BackgroundColor3 = Color3.new(0, 0, 0)
    flyContainer.Visible = false
    flyContainer.Parent = screenGui
    
    -- Forward button
    local forwardBtn = Instance.new("TextButton")
    forwardBtn.Name = "Forward"
    forwardBtn.Size = UDim2.new(0, 50, 0, 30)
    forwardBtn.Position = UDim2.new(0.5, -25, 0, 5)
    forwardBtn.Text = "W"
    forwardBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    forwardBtn.Parent = flyContainer
    
    -- Backward button
    local backwardBtn = Instance.new("TextButton")
    backwardBtn.Name = "Backward"
    backwardBtn.Size = UDim2.new(0, 50, 0, 30)
    backwardBtn.Position = UDim2.new(0.5, -25, 0.5, 15)
    backwardBtn.Text = "S"
    backwardBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    backwardBtn.Parent = flyContainer
    
    -- Left button
    local leftBtn = Instance.new("TextButton")
    leftBtn.Name = "Left"
    leftBtn.Size = UDim2.new(0, 50, 0, 30)
    leftBtn.Position = UDim2.new(0, 5, 0.5, 15)
    leftBtn.Text = "A"
    leftBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    leftBtn.Parent = flyContainer
    
    -- Right button
    local rightBtn = Instance.new("TextButton")
    rightBtn.Name = "Right"
    rightBtn.Size = UDim2.new(0, 50, 0, 30)
    rightBtn.Position = UDim2.new(1, -55, 0.5, 15)
    rightBtn.Text = "D"
    rightBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    rightBtn.Parent = flyContainer
    
    -- Up button
    local upBtn = Instance.new("TextButton")
    upBtn.Name = "Up"
    upBtn.Size = UDim2.new(0, 50, 0, 30)
    upBtn.Position = UDim2.new(0, 5, 0, 5)
    upBtn.Text = "Up"
    upBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    upBtn.Parent = flyContainer
    
    -- Down button
    local downBtn = Instance.new("TextButton")
    downBtn.Name = "Down"
    downBtn.Size = UDim2.new(0, 50, 0, 30)
    downBtn.Position = UDim2.new(1, -55, 0, 5)
    downBtn.Text = "Down"
    downBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    downBtn.Parent = flyContainer
    
    -- Connect mobile fly controls
    local function setupMobileButton(button, controlName)
        button.MouseButton1Down:Connect(function()
            touchControls[controlName] = true
        end)
        
        button.MouseButton1Up:Connect(function()
            touchControls[controlName] = false
        end)
        
        button.TouchTap:Connect(function()
            touchControls[controlName] = true
            wait(0.1)
            touchControls[controlName] = false
        end)
    end
    
    setupMobileButton(forwardBtn, "flyForward")
    setupMobileButton(backwardBtn, "flyBackward")
    setupMobileButton(leftBtn, "flyLeft")
    setupMobileButton(rightBtn, "flyRight")
    setupMobileButton(upBtn, "flyUp")
    setupMobileButton(downBtn, "flyDown")
end

-- Click simulation
local VirtualInputManager = game:GetService("VirtualInputManager")
function mouse1click()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
end

-- Mobile tap simulation
function mobileTap()
    if isMobile then
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
    end
end

-- Aimbot FOV Circle
local AimbotEnabled = false
local FOVRadius = 100
local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(128, 255, 0)
FOVCircle.Thickness = 1
FOVCircle.Radius = FOVRadius
FOVCircle.Transparency = 0.5
FOVCircle.Filled = false
FOVCircle.Visible = false

RunService.RenderStepped:Connect(function()
    if AimbotEnabled then
        local mousePos = UserInputService:GetMouseLocation()
        FOVCircle.Position = Vector2.new(mousePos.X, mousePos.Y)
        FOVCircle.Visible = true
    else
        FOVCircle.Visible = false
    end
end)

-- Mobile aimbot activation
local mobileAimbotActive = false
if isMobile then
    -- Add mobile aimbot toggle button
    local aimbotBtn = Instance.new("TextButton")
    aimbotBtn.Name = "MobileAimbot"
    aimbotBtn.Size = UDim2.new(0, 80, 0, 40)
    aimbotBtn.Position = UDim2.new(1, -90, 0.5, -20)
    aimbotBtn.Text = "Aimbot"
    aimbotBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    aimbotBtn.BackgroundTransparency = 0.3
    aimbotBtn.Parent = screenGui
    
    aimbotBtn.MouseButton1Down:Connect(function()
        mobileAimbotActive = true
    end)
    
    aimbotBtn.MouseButton1Up:Connect(function()
        mobileAimbotActive = false
    end)
    
    aimbotBtn.TouchTap:Connect(function()
        mobileAimbotActive = true
        wait(0.1)
        mobileAimbotActive = false
    end)
end

-- ESP Function
local function createESP(item)
    local adorneePart
    if item:IsA("Model") then
        if item:FindFirstChildWhichIsA("Humanoid") then return end
        adorneePart = item:FindFirstChildWhichIsA("BasePart")
    elseif item:IsA("BasePart") then
        adorneePart = item
    else
        return
    end

    if not adorneePart then return end

    local distance = (adorneePart.Position - ignoreDistanceFrom).Magnitude
    if distance < minDistance then return end

    if not item:FindFirstChild("ESP_Billboard") then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESP_Billboard"
        billboard.Adornee = adorneePart
        billboard.Size = UDim2.new(0, 50, 0, 20)
        billboard.AlwaysOnTop = true
        billboard.StudsOffset = Vector3.new(0, 2, 0)

        local label = Instance.new("TextLabel", billboard)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.Text = item.Name
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextStrokeTransparency = 0
        label.TextScaled = true
        billboard.Parent = item
    end

    if not item:FindFirstChild("ESP_Highlight") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESP_Highlight"
        highlight.FillColor = Color3.fromRGB(255, 85, 0)
        highlight.OutlineColor = Color3.fromRGB(0, 100, 0)
        highlight.FillTransparency = 0.25
        highlight.OutlineTransparency = 0
        highlight.Adornee = item:IsA("Model") and item or adorneePart
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = item
    end
end

local function toggleESP(state)
    espEnabled = state
    for _, item in pairs(workspace:GetDescendants()) do
        if table.find(teleportTargets, item.Name) then
            if espEnabled then
                createESP(item)
            else
                if item:FindFirstChild("ESP_Billboard") then item.ESP_Billboard:Destroy() end
                if item:FindFirstChild("ESP_Highlight") then item.ESP_Highlight:Destroy() end
            end
        end
    end
end

workspace.DescendantAdded:Connect(function(desc)
    if espEnabled and table.find(teleportTargets, desc.Name) then
        task.wait(0.1)
        createESP(desc)
    end
end)

-- ESP for NPCs
local npcBoxes = {}

local function createNPCESP(npc)
    if not npc:IsA("Model") or npc:FindFirstChild("HumanoidRootPart") == nil then return end

    local root = npc:FindFirstChild("HumanoidRootPart")
    if npcBoxes[npc] then return end

    local box = Drawing.new("Square")
    box.Thickness = 2
    box.Transparency = 1
    box.Color = Color3.fromRGB(255, 85, 0)
    box.Filled = false
    box.Visible = true

    local nameText = Drawing.new("Text")
    nameText.Text = npc.Name
    nameText.Color = Color3.fromRGB(255, 255, 255)
    nameText.Size = 16
    nameText.Center = true
    nameText.Outline = true
    nameText.Visible = true

    npcBoxes[npc] = {box = box, name = nameText}

    -- Cleanup on remove
    npc.AncestryChanged:Connect(function(_, parent)
        if not parent and npcBoxes[npc] then
            npcBoxes[npc].box:Remove()
            npcBoxes[npc].name:Remove()
            npcBoxes[npc] = nil
        end
    end)
end

local function toggleNPCESP(state)
    npcESPEnabled = state
    if not state then
        for npc, visuals in pairs(npcBoxes) do
            if visuals.box then visuals.box:Remove() end
            if visuals.name then visuals.name:Remove() end
        end
        npcBoxes = {}
    else
        -- Show NPC ESP for already existing NPCs
        for _, obj in ipairs(workspace:GetDescendants()) do
            if table.find(AimbotTargets, obj.Name) and obj:IsA("Model") then
                createNPCESP(obj)
            end
        end
    end
end

workspace.DescendantAdded:Connect(function(desc)
    if table.find(AimbotTargets, desc.Name) and desc:IsA("Model") then
        task.wait(0.1)
        if npcESPEnabled then
            createNPCESP(desc)
        end
    end
end)

-- Auto Tree Farm Logic with timeout
local badTrees = {}

task.spawn(function()
    while true do
        if AutoTreeFarmEnabled then
            local trees = {}
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj.Name == "Trunk" and obj.Parent and obj.Parent.Name == "Small Tree" then
                    local distance = (obj.Position - ignoreDistanceFrom).Magnitude
                    if distance > minDistance and not badTrees[obj:GetFullName()] then
                        table.insert(trees, obj)
                    end
                end
            end

            table.sort(trees, function(a, b)
                return (a.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <
                       (b.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            end)

            for _, trunk in ipairs(trees) do
                if not AutoTreeFarmEnabled then break end
                LocalPlayer.Character:PivotTo(trunk.CFrame + Vector3.new(0, 3, 0))
                task.wait(0.2)
                local startTime = tick()
                while AutoTreeFarmEnabled and trunk and trunk.Parent and trunk.Parent.Name == "Small Tree" do
                    if isMobile then
                        mobileTap()
                    else
                        mouse1click()
                    end
                    task.wait(0.2)
                    if tick() - startTime > 12 then
                        badTrees[trunk:GetFullName()] = true
                        break
                    end
                end
                task.wait(0.3)
            end
        end
        task.wait(1.5)
    end
end)

-- Optimized Aimbot Logic
local lastAimbotCheck = 0
local aimbotCheckInterval = 0.02 -- Faster reaction time
local smoothness = 0.2 -- Smooth camera interpolation

RunService.RenderStepped:Connect(function()
    local aimbotActive = AimbotEnabled and (UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) or mobileAimbotActive)
    
    if not aimbotActive then
        FOVCircle.Visible = false
        return
    end

    local currentTime = tick()
    if currentTime - lastAimbotCheck < aimbotCheckInterval then return end
    lastAimbotCheck = currentTime

    local mousePos = UserInputService:GetMouseLocation()
    local closestTarget, shortestDistance = nil, math.huge

    for _, obj in ipairs(workspace:GetDescendants()) do
        if table.find(AimbotTargets, obj.Name) and obj:IsA("Model") then
            local head = obj:FindFirstChild("Head")
            if head then
                local screenPos, onScreen = camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if dist < shortestDistance and dist <= FOVRadius then
                        shortestDistance = dist
                        closestTarget = head
                    end
                end
            end
        end
    end

    if closestTarget then
        local currentCF = camera.CFrame
        local targetCF = CFrame.new(camera.CFrame.Position, closestTarget.Position)
        camera.CFrame = currentCF:Lerp(targetCF, smoothness) -- Smoothly rotate camera
        FOVCircle.Position = Vector2.new(mousePos.X, mousePos.Y)
        FOVCircle.Visible = true
    else
        FOVCircle.Visible = false
    end
end)

-- Fly Logic
local flying, flyConnection = false, nil
local speed = 60

local function startFlying()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local bodyGyro = Instance.new("BodyGyro", hrp)
    local bodyVelocity = Instance.new("BodyVelocity", hrp)
    bodyGyro.P = 9e4
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.CFrame = hrp.CFrame
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)

    flyConnection = RunService.RenderStepped:Connect(function()
        local moveVec = Vector3.zero
        local camCF = camera.CFrame
        
        if isMobile then
            -- Mobile controls
            if touchControls.flyForward then moveVec += camCF.LookVector end
            if touchControls.flyBackward then moveVec -= camCF.LookVector end
            if touchControls.flyLeft then moveVec -= camCF.RightVector end
            if touchControls.flyRight then moveVec += camCF.RightVector end
            if touchControls.flyUp then moveVec += camCF.UpVector end
            if touchControls.flyDown then moveVec -= camCF.UpVector end
        else
            -- PC controls
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVec += camCF.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVec -= camCF.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVec -= camCF.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVec += camCF.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVec += camCF.UpVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveVec -= camCF.UpVector end
        end
        
        bodyVelocity.Velocity = moveVec.Magnitude > 0 and moveVec.Unit * speed or Vector3.zero
        bodyGyro.CFrame = camCF
    end)
end

local function stopFlying()
    if flyConnection then flyConnection:Disconnect() end
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        for _, v in pairs(hrp:GetChildren()) do
            if v:IsA("BodyGyro") or v:IsA("BodyVelocity") then v:Destroy() end
        end
    end
end

local function toggleFly(state)
    flying = state
    if isMobile and screenGui then
        local flyControls = screenGui:FindFirstChild("FlyControls")
        if flyControls then
            flyControls.Visible = state
        end
    end
    if flying then startFlying() else stopFlying() end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Q and not isMobile then
        toggleFly(not flying)
    end
end)

RunService.RenderStepped:Connect(function()
    for npc, visuals in pairs(npcBoxes) do
        local box = visuals.box
        local name = visuals.name

        if npc and npc:FindFirstChild("HumanoidRootPart") then
            local hrp = npc.HumanoidRootPart
            local size = Vector2.new(60, 80)
            local screenPos, onScreen = camera:WorldToViewportPoint(hrp.Position)

            if onScreen then
                box.Position = Vector2.new(screenPos.X - size.X / 2, screenPos.Y - size.Y / 2)
                box.Size = size
                box.Visible = true

                name.Position = Vector2.new(screenPos.X, screenPos.Y - size.Y / 2 - 15)
                name.Visible = true
            else
                box.Visible = false
                name.Visible = false
            end
        else
            box:Remove()
            name:Remove()
            npcBoxes[npc] = nil
        end
    end
end)

-- GUI Tabs
local HomeTab = Window:CreateTab("🏠Home🏠", 4483362458)

HomeTab:CreateButton({
    Name = "Teleport to Campfire",
    Callback = function()
        LocalPlayer.Character:PivotTo(CFrame.new(0, 10, 0))
    end
})

HomeTab:CreateButton({
    Name = "Teleport to Grinder",
    Callback = function()
        LocalPlayer.Character:PivotTo(CFrame.new(16.1,4,-4.6))
    end
})

HomeTab:CreateToggle({
    Name = "Item ESP",
    CurrentValue = false,
    Callback = toggleESP
})

HomeTab:CreateToggle({
    Name = "NPC ESP",
    CurrentValue = false,
    Callback = function(value)
        toggleNPCESP(value)
        Rayfield:Notify({
            Title = "NPC ESP",
            Content = value and "NPC ESP Enabled" or "NPC ESP Disabled",
            Duration = 4,
            Image = 4483362458,
        })
    end
})

HomeTab:CreateToggle({
    Name = "Auto Tree Farm (Small Tree)",
    CurrentValue = false,
    Callback = function(value)
        AutoTreeFarmEnabled = value
    end
})

HomeTab:CreateToggle({
    Name = "Aimbot (Right Click)",
    CurrentValue = false,
    Callback = function(value)
        AimbotEnabled = value
        Rayfield:Notify({
            Title = "Aimbot",
            Content = value and "Enabled - Hold Right Click to aim." or "Disabled.",
            Duration = 4,
            Image = 4483362458,
        })
    end
})

HomeTab:CreateToggle({
    Name = "Fly (WASD + Space + Shift)",
    CurrentValue = false,
    Callback = function(value)
        toggleFly(value)
        Rayfield:Notify({
            Title = "Fly",
            Content = value and "Fly Enabled" or "Fly Disabled",
            Duration = 4,
            Image = 4483362458,
        })
    end
})

-- Teleport Tab - MODIFIED: Items teleport to player instead of player to items
local TeleTab = Window:CreateTab("🧲Teleport🧲", 4483362458)
for _, itemName in ipairs(teleportTargets) do
    TeleTab:CreateButton({
        Name = "Teleport " .. itemName .. " to Me",
        Callback = function()
            local itemsFound = 0
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj.Name == itemName and obj:IsA("Model") then
                    local cf = nil
                    if pcall(function() cf = obj:GetPivot() end) then
                        -- success
                    else
                        local part = obj:FindFirstChildWhichIsA("BasePart")
                        if part then cf = part.CFrame end
                    end
                    if cf then
                        local dist = (cf.Position - ignoreDistanceFrom).Magnitude
                        if dist >= minDistance then
                            -- Teleport item to player instead of player to item
                            local playerPos = LocalPlayer.Character.HumanoidRootPart.Position
                            local offset = Vector3.new(math.random(-5, 5), 0, math.random(-5, 5))
                            obj:PivotTo(CFrame.new(playerPos + offset))
                            itemsFound = itemsFound + 1
                        end
                    end
                end
            end
            if itemsFound > 0 then
                Rayfield:Notify({
                    Title = "Teleport Successful",
                    Content = "Teleported " .. itemsFound .. " " .. itemName .. " to your location",
                    Duration = 5,
                    Image = 4483362458,
                })
            else
                Rayfield:Notify({
                    Title = "Item Not Found",
                    Content = itemName .. " not found or too close to origin.",
                    Duration = 5,
                    Image = 4483362458,
                })
            end
        end
    })
end