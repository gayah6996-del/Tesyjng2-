local a=game;local b=a.CoreGui;if b:FindFirstChild("MobileCheatMenu")then b.MobileCheatMenu:Destroy()end;local c=a:GetService("Players")local d=a:GetService("UserInputService")local e=a:GetService("RunService")local f=c.LocalPlayer;local g=Instance.new("ScreenGui")g.Name="MobileCheatMenu"g.ResetOnSpawn=false;g.Parent=b;local function h(i,j)local k=Instance.new("UICorner")k.CornerRadius=UDim.new(0,j or 6)k.Parent=i end;local l=Instance.new("Frame")l.Size=UDim2.new(0,300,0,350)l.AnchorPoint=Vector2.new(0.5,0.5)l.Position=UDim2.new(0.5,0,0.5,0)l.BackgroundColor3=Color3.fromRGB(25,25,25)l.BorderSizePixel=0;l.Parent=g;h(l,10)local m=Instance.new("TextLabel")m.Size=UDim2.new(1,-40,0,20)m.Position=UDim2.new(0,10,0,5)m.BackgroundTransparency=1;m.Text="99 NIGHTS CHEAT"m.Font=Enum.Font.GothamBold;m.TextSize=14;m.TextColor3=Color3.fromRGB(220,220,220)m.TextXAlignment=Enum.TextXAlignment.Left;m.Parent=l;local n=Instance.new("TextButton")n.Size=UDim2.new(0,25,0,25)n.Position=UDim2.new(1,-30,0,5)n.BackgroundColor3=Color3.fromRGB(220,60,60)n.Text="X"n.Font=Enum.Font.GothamBold;n.TextSize=14;n.TextColor3=Color3.fromRGB(255,255,255)n.Parent=l;h(n,5)local o=Instance.new("TextButton")o.Size=UDim2.new(0,50,0,50)o.Position=UDim2.new(0,10,0,50)o.BackgroundColor3=Color3.fromRGB(40,40,40)o.Text="📱"o.Font=Enum.Font.GothamBold;o.TextSize=18;o.TextColor3=Color3.fromRGB(220,220,220)o.Visible=false;o.Parent=g;h(o,8)local p=Instance.new("Frame")p.Size=UDim2.new(1,-20,0,25)p.Position=UDim2.new(0,10,0,30)p.BackgroundTransparency=1;p.Parent=l;local q=Instance.new("UIListLayout")q.FillDirection=Enum.FillDirection.Horizontal;q.Padding=UDim.new(0,4)q.Parent=p;local r={{name="Main",defaultActive=true},{name="Bring",defaultActive=false}}local s={}local t={}for u,v in ipairs(r)do local w=Instance.new("TextButton")w.Size=UDim2.new(0.5,-2,1,0)w.BackgroundColor3=v.defaultActive and Color3.fromRGB(60,60,60)or Color3.fromRGB(40,40,40)w.Text=v.name;w.Font=Enum.Font.GothamBold;w.TextSize=11;w.TextColor3=v.defaultActive and Color3.fromRGB(220,220,220)or Color3.fromRGB(150,150,150)w.Parent=p;h(w,4)local x=Instance.new("ScrollingFrame")x.Size=UDim2.new(1,-20,1,-65)x.Position=UDim2.new(0,10,0,60)x.BackgroundTransparency=1;x.ScrollBarThickness=4;x.ScrollBarImageColor3=Color3.fromRGB(100,100,100)x.AutomaticCanvasSize=Enum.AutomaticSize.Y;x.VerticalScrollBarInset=Enum.ScrollBarInset.Always;x.Visible=v.defaultActive;x.Parent=l;local y=Instance.new("UIListLayout")y.SortOrder=Enum.SortOrder.LayoutOrder;y.Padding=UDim.new(0,6)y.Parent=x;s[v.name]=w;t[v.name]=x end;local function z(A)for B,C in pairs(t)do C.Visible=false end;for B,D in pairs(s)do D.BackgroundColor3=Color3.fromRGB(40,40,40)D.TextColor3=Color3.fromRGB(150,150,150)end;t[A].Visible=true;s[A].BackgroundColor3=Color3.fromRGB(60,60,60)s[A].TextColor3=Color3.fromRGB(220,220,220)end;for B,D in pairs(s)do D.MouseButton1Click:Connect(function()z(B)end)end;

-- Настройки
local SETTINGS_FILE = "astralcheat_settings.txt"
local Settings = {
    ActiveKillAura = false,
    ActiveAutoChopTree = false,
    DistanceForKillAura = 25,
    DistanceForAutoChopTree = 25,
    BringCount = 5,
    BringDelay = 200
}

local function SaveSettings()
    pcall(function()
        local data = game:GetService("HttpService"):JSONEncode(Settings)
        writefile(SETTINGS_FILE, data)
    end)
end

local function LoadSettings()
    pcall(function()
        if isfile(SETTINGS_FILE) then
            local data = readfile(SETTINGS_FILE)
            local loadedSettings = game:GetService("HttpService"):JSONDecode(data)
            for key, value in pairs(loadedSettings) do
                if Settings[key] ~= nil then Settings[key] = value end
            end
        end
    end)
end

LoadSettings()

-- Функции для UI
local function CreateToggle(parent, text, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, 0, 0, 25)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = parent
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(1, 0, 1, 0)
    toggleButton.BackgroundColor3 = Color3.fromRGB(45,45,45)
    toggleButton.Text = text .. ": OFF"
    toggleButton.TextColor3 = Color3.fromRGB(220,220,220)
    toggleButton.Font = Enum.Font.Gotham
    toggleButton.TextSize = 12
    toggleButton.Parent = toggleFrame
    h(toggleButton, 4)
    
    local isActive = false
    
    toggleButton.MouseButton1Click:Connect(function()
        isActive = not isActive
        toggleButton.Text = text .. (isActive and ": ON" or ": OFF")
        toggleButton.BackgroundColor3 = isActive and Color3.fromRGB(80,80,80) or Color3.fromRGB(45,45,45)
        callback(isActive)
        SaveSettings()
    end)
    
    return {Set = function(v) isActive = v end}
end

local function CreateSlider(parent, text, min, max, default, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, 0, 0, 40)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = parent
    
    local sliderText = Instance.new("TextLabel")
    sliderText.Size = UDim2.new(1, 0, 0, 15)
    sliderText.BackgroundTransparency = 1
    sliderText.Text = text .. ": " .. default
    sliderText.TextColor3 = Color3.fromRGB(220,220,220)
    sliderText.TextSize = 11
    sliderText.TextXAlignment = Enum.TextXAlignment.Left
    sliderText.Font = Enum.Font.Gotham
    sliderText.Parent = sliderFrame
    
    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new(1, 0, 0, 12)
    sliderBar.Position = UDim2.new(0, 0, 0, 20)
    sliderBar.BackgroundColor3 = Color3.fromRGB(50,50,50)
    sliderBar.Parent = sliderFrame
    h(sliderBar, 6)
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    sliderFill.Parent = sliderBar
    h(sliderFill, 6)
    
    local isDragging = false
    
    local function updateSlider(value)
        local norm = math.clamp((value - min) / (max - min), 0, 1)
        sliderFill.Size = UDim2.new(norm, 0, 1, 0)
        sliderText.Text = text .. ": " .. math.floor(value)
        callback(value)
    end
    
    sliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
        end
    end)
    
    sliderBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
            SaveSettings()
        end
    end)
    
    sliderBar.InputChanged:Connect(function(input)
        if isDragging and input.UserInputType == Enum.UserInputType.Touch then
            local pos = input.Position.X - sliderBar.AbsolutePosition.X
            local norm = math.clamp(pos / sliderBar.AbsoluteSize.X, 0, 1)
            local value = min + norm * (max - min)
            updateSlider(value)
        end
    end)
    
    updateSlider(default)
end

local function CreateButton(parent, text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 30)
    button.BackgroundColor3 = Color3.fromRGB(50,50,50)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(220,220,220)
    button.TextSize = 12
    button.Font = Enum.Font.Gotham
    button.Parent = parent
    h(button, 5)
    
    button.MouseButton1Click:Connect(callback)
end

-- Переменные для функций
local ActiveKillAura = Settings.ActiveKillAura
local ActiveAutoChopTree = Settings.ActiveAutoChopTree
local DistanceForKillAura = Settings.DistanceForKillAura
local DistanceForAutoChopTree = Settings.DistanceForAutoChopTree
local BringCount = Settings.BringCount
local BringDelay = Settings.BringDelay

-- Kill Aura
local killToggle = CreateToggle(t["Main"], "Kill Aura", function(v)
    ActiveKillAura = v
    Settings.ActiveKillAura = v
end)

CreateSlider(t["Main"], "Kill Distance", 10, 50, Settings.DistanceForKillAura, function(v)
    DistanceForKillAura = v
    Settings.DistanceForKillAura = v
end)

-- Auto Chop
local chopToggle = CreateToggle(t["Main"], "Auto Chop", function(v)
    ActiveAutoChopTree = v
    Settings.ActiveAutoChopTree = v
end)

CreateSlider(t["Main"], "Chop Distance", 10, 50, Settings.DistanceForAutoChopTree, function(v)
    DistanceForAutoChopTree = v
    Settings.DistanceForAutoChopTree = v
end)

-- Bring Items
CreateSlider(t["Bring"], "Bring Count", 1, 20, Settings.BringCount, function(v)
    BringCount = math.floor(v)
    Settings.BringCount = BringCount
end)

CreateSlider(t["Bring"], "Bring Speed", 50, 500, Settings.BringDelay, function(v)
    BringDelay = math.floor(v)
    Settings.BringDelay = BringDelay
end)

local CampfirePosition = Vector3.new(0, 10, 0)

CreateButton(t["Bring"], "Teleport to Campfire", function()
    local char = f.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(CampfirePosition)
    end
end)

-- Bring Items Buttons
local itemsToBring = {
    "Wood",
    "Coal", 
    "Fuel Can",
    "Oil Barrel",
    "Scrap Metal",
    "Carrot",
    "Bandage",
    "Rifle Ammo"
}

for _, itemName in pairs(itemsToBring) do
    CreateButton(t["Bring"], "Bring " .. itemName, function()
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

-- Функции геймплея
task.spawn(function()
    while true do
        if ActiveKillAura then 
            local char = f.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local weapon = f.Inventory:FindFirstChild("Old Axe") or f.Inventory:FindFirstChild("Good Axe") or f.Inventory:FindFirstChild("Strong Axe")
            
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
        wait(0.1)
    end
end)

task.spawn(function()
    while true do
        if ActiveAutoChopTree then 
            local char = f.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local weapon = f.Inventory:FindFirstChild("Old Axe") or f.Inventory:FindFirstChild("Good Axe") or f.Inventory:FindFirstChild("Strong Axe")
            
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
        wait(0.1)
    end
end)

-- Применить сохраненные настройки
if Settings.ActiveKillAura then killToggle.Set(true) end
if Settings.ActiveAutoChopTree then chopToggle.Set(true) end

-- Обработчики кнопок
n.MouseButton1Click:Connect(function()
    l.Visible = false
    o.Visible = true
end)

o.MouseButton1Click:Connect(function()
    l.Visible = true
    o.Visible = false
end)

print("99 NIGHTS MOBILE CHEAT LOADED!")