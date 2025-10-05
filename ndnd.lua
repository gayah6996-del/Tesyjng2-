local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

-- Anti-AFK
warn("Anti-AFK running")
LocalPlayer.Idled:Connect(function()
    warn("Anti-AFK triggered")
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.Name = "EchelonCheatGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 1000

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 250, 0, 150)
Frame.Position = UDim2.new(0.5, -125, 0.5, -75)
Frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = Frame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(255, 0, 0)
UIStroke.Thickness = 2
UIStroke.Transparency = 0.5
UIStroke.Parent = Frame

-- Echelon Label
local EchelonLabel = Instance.new("TextLabel")
EchelonLabel.Size = UDim2.new(0, 120, 0, 25)
EchelonLabel.Position = UDim2.new(0, 10, 0, 8)
EchelonLabel.BackgroundTransparency = 1
EchelonLabel.Text = "Echelon"
EchelonLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
EchelonLabel.TextSize = 18
EchelonLabel.Font = Enum.Font.GothamBold
EchelonLabel.Parent = Frame

local EchelonGlow = Instance.new("UIGradient")
EchelonGlow.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 0, 0))
})
EchelonGlow.Parent = EchelonLabel
local tweenEchelon = TweenService:Create(EchelonGlow, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Rotation = 360})
tweenEchelon:Play()

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Position = UDim2.new(1, -35, 0, 8)
CloseButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = Frame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 5)
CloseCorner.Parent = CloseButton

-- Minimize Button
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 25, 0, 25)
MinimizeButton.Position = UDim2.new(1, -65, 0, 8)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(75, 0, 0)
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 14
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Parent = Frame

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 5)
MinimizeCorner.Parent = MinimizeButton

-- Tree Health Display Function
local function CreateTreeHealthDisplay(tree)
    if not tree then return end
    
    -- Create BillboardGui for health display
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "TreeHealthDisplay"
    billboard.Adornee = tree
    billboard.Size = UDim2.new(0, 100, 0, 20)
    billboard.StudsOffset = Vector3.new(0, 8, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = tree
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    frame.Parent = billboard
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 4)
    UICorner.Parent = frame
    
    local healthBar = Instance.new("Frame")
    healthBar.Name = "HealthBar"
    healthBar.Size = UDim2.new(1, 0, 1, 0)
    healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    healthBar.BorderSizePixel = 0
    healthBar.Parent = frame
    
    local healthCorner = Instance.new("UICorner")
    healthCorner.CornerRadius = UDim.new(0, 4)
    healthCorner.Parent = healthBar
    
    local healthText = Instance.new("TextLabel")
    healthText.Size = UDim2.new(1, 0, 1, 0)
    healthText.BackgroundTransparency = 1
    healthText.Text = "100%"
    healthText.TextColor3 = Color3.fromRGB(255, 255, 255)
    healthText.TextSize = 12
    healthText.Font = Enum.Font.GothamBold
    healthText.Parent = frame
    
    return billboard
end

-- Function to update tree health display
local function UpdateTreeHealth(tree, health, maxHealth)
    if not tree then return end
    
    local billboard = tree:FindFirstChild("TreeHealthDisplay")
    if not billboard then
        billboard = CreateTreeHealthDisplay(tree)
    end
    
    if billboard then
        local healthBar = billboard.Frame.HealthBar
        local healthText = billboard.Frame.TextLabel
        
        local healthPercent = health / maxHealth
        healthBar.Size = UDim2.new(healthPercent, 0, 1, 0)
        
        -- Change color based on health percentage
        if healthPercent > 0.7 then
            healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- Green
        elseif healthPercent > 0.3 then
            healthBar.BackgroundColor3 = Color3.fromRGB(255, 255, 0) -- Yellow
        else
            healthBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Red
        end
        
        healthText.Text = math.floor(healthPercent * 100) .. "%"
    end
end

-- Function to find tree health
local function GetTreeHealth(tree)
    if not tree then return 100, 100 end
    
    -- Try to find health in various possible locations
    local humanoid = tree:FindFirstChildOfClass("Humanoid")
    if humanoid then
        return humanoid.Health, humanoid.MaxHealth
    end
    
    -- Look for health values in tree model
    for _, part in pairs(tree:GetDescendants()) do
        if part:IsA("BasePart") and part:FindFirstChild("Health") then
            local healthValue = part.Health
            if typeof(healthValue) == "number" then
                return healthValue, 100 -- Assuming max health is 100
            end
        end
    end
    
    return 100, 100 -- Default values if health not found
end

-- Notification Function
local function ShowNotification(message)
    local Notification = Instance.new("TextLabel")
    Notification.Size = UDim2.new(0, 300, 0, 40)
    Notification.Position = UDim2.new(0.5, -150, 0.9, -50)
    Notification.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Notification.Text = message
    Notification.TextColor3 = Color3.fromRGB(255, 255, 255)
    Notification.TextSize = 14
    Notification.Font = Enum.Font.Gotham
    Notification.TextWrapped = true
    Notification.Parent = ScreenGui

    local NotifCorner = Instance.new("UICorner")
    NotifCorner.CornerRadius = UDim.new(0, 8)
    NotifCorner.Parent = Notification

    local NotifStroke = Instance.new("UIStroke")
    NotifStroke.Color = Color3.fromRGB(255, 0, 0)
    NotifStroke.Thickness = 1.5
    NotifStroke.Transparency = 0.5
    NotifStroke.Parent = Notification

    task.spawn(function()
        task.wait(5)
        Notification:Destroy()
    end)
end

-- Button Creation
local function CreateButton(name, yPos)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 210, 0, 40)
    Button.Position = UDim2.new(0, 20, 0, yPos)
    Button.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Button.Text = name .. ": OFF"
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 14
    Button.Font = Enum.Font.Gotham
    Button.Parent = Frame

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = Button

    local ButtonGlow = Instance.new("UIStroke")
    ButtonGlow.Color = Color3.fromRGB(255, 0, 0)
    ButtonGlow.Thickness = 1.5
    ButtonGlow.Transparency = 0.5
    ButtonGlow.Parent = Button

    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.3), {Size = UDim2.new(0, 215, 0, 42)}):Play()
        TweenService:Create(ButtonGlow, TweenInfo.new(0.3), {Transparency = 0}):Play()
    end)
    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.3), {Size = UDim2.new(0, 210, 0, 40)}):Play()
        TweenService:Create(ButtonGlow, TweenInfo.new(0.3), {Transparency = 0.5}):Play()
    end)

    return Button
end

local NOSkaButton = CreateButton("NOska", 40)
local AutoTreeButton = CreateButton("Auto Tree", 90)

-- Draggable GUI
local dragging = false
local dragInput = nil
local dragStart = nil
local startPos = nil

local function update(input)
    if dragging then
        local delta = input.Position - dragStart
        Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end

Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
    end
end)

Frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
        dragInput = nil
    end
end)

Frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Variables
local NOSkaActive = false
local AutoTreeFarmEnabled = false
local minDistance = 0
local VirtualInputManager = game:GetService('VirtualInputManager')

-- Mouse click function
local function mouse1click()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, false)
    task.wait()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, false)
end

-- DragItem function for NOska
local function DragItem(obj)
    if obj and obj.PrimaryPart then
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            -- Move the object to player's position
            obj:SetPrimaryPartCFrame(character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0))
        end
    end
end

-- NOska Function (Bring All Scraps)
local function NOskaFunction()
    while NOSkaActive do
        task.spawn(function()
            for _, Obj in pairs(game.Workspace.Items:GetChildren()) do
                if (Obj.Name == "Tyre" or Obj.Name == "Sheet Metal" or Obj.Name == "Broken Fan" or Obj.Name == "Bolt" or Obj.Name == "Old Radio" or Obj.Name == "UFO Junk" or Obj.Name == "UFO Scrap" or Obj.Name == "Broken Microwave") and Obj:IsA("Model") and Obj.PrimaryPart then 
                    DragItem(Obj)
                    task.wait(0.1) -- Small delay to prevent lag
                end 
            end
        end)
        task.wait(1) -- Check every second
    end
end

-- Auto Tree Farm Function
local badTrees = {}

task.spawn(function()
    while true do
        if AutoTreeFarmEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local ignoreDistanceFrom = LocalPlayer.Character.HumanoidRootPart.Position
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
                
                local tree = trunk.Parent
                local startTime = tick()
                
                -- Create health display for current tree
                local health, maxHealth = GetTreeHealth(tree)
                UpdateTreeHealth(tree, health, maxHealth)
                
                while AutoTreeFarmEnabled and trunk and trunk.Parent and trunk.Parent.Name == "Small Tree" do
                    mouse1click()
                    task.wait(0.2)
                    
                    -- Update tree health display
                    local currentHealth, currentMaxHealth = GetTreeHealth(tree)
                    UpdateTreeHealth(tree, currentHealth, currentMaxHealth)
                    
                    if tick() - startTime > 12 then
                        badTrees[trunk:GetFullName()] = true
                        break
                    end
                end
                
                -- Clean up health display when done with tree
                if tree and tree:FindFirstChild("TreeHealthDisplay") then
                    tree.TreeHealthDisplay:Destroy()
                end
                
                task.wait(0.3)
            end
        end
        task.wait(1.5)
    end
end)

AutoTreeButton.MouseButton1Click:Connect(function()
    AutoTreeFarmEnabled = not AutoTreeFarmEnabled
    AutoTreeButton.Text = "Auto Tree: " .. (AutoTreeFarmEnabled and "ON" or "OFF")
    AutoTreeButton.BackgroundColor3 = AutoTreeFarmEnabled and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(20, 20, 20)
    if AutoTreeFarmEnabled then
        ShowNotification("Auto Tree Farm enabled.")
    else
        ShowNotification("Auto Tree Farm disabled.")
    end
end)

-- NOska Button Functionality
NOSkaButton.MouseButton1Click:Connect(function()
    NOSkaActive = not NOSkaActive
    NOSkaButton.Text = "NOska: " .. (NOSkaActive and "ON" or "OFF")
    NOSkaButton.BackgroundColor3 = NOSkaActive and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(20, 20, 20)
    if NOSkaActive then
        ShowNotification("NOska enabled - collecting all scraps.")
        task.spawn(NOskaFunction)
    else
        ShowNotification("NOska disabled.")
    end
end)

-- Button Functions
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

MinimizeButton.MouseButton1Click:Connect(function()
    local Minimized = not (Frame.Size == UDim2.new(0, 250, 0, 40))
    MinimizeButton.Text = Minimized and "+" or "-"
    NOSkaButton.Visible = not Minimized
    AutoTreeButton.Visible = not Minimized
    Frame.Size = Minimized and UDim2.new(0, 250, 0, 40) or UDim2.new(0, 250, 0, 150)
end)