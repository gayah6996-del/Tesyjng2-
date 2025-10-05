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
Frame.Size = UDim2.new(0, 280, 0, 200)
Frame.Position = UDim2.new(0.5, -140, 0.1, 0)
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
        
        if healthPercent > 0.7 then
            healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        elseif healthPercent > 0.3 then
            healthBar.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
        else
            healthBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        end
        
        healthText.Text = math.floor(healthPercent * 100) .. "%"
    end
end

-- Function to find tree health
local function GetTreeHealth(tree)
    if not tree then return 100, 100 end
    
    local humanoid = tree:FindFirstChildOfClass("Humanoid")
    if humanoid then
        return humanoid.Health, humanoid.MaxHealth
    end
    
    for _, part in pairs(tree:GetDescendants()) do
        if part:IsA("BasePart") and part:FindFirstChild("Health") then
            local healthValue = part.Health
            if typeof(healthValue) == "number" then
                return healthValue, 100
            end
        end
    end
    
    return 100, 100
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
local function CreateButton(name, yPos, parent)
    parent = parent or Frame
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 240, 0, 35)
    Button.Position = UDim2.new(0, 20, 0, yPos)
    Button.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Button.Text = name
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 14
    Button.Font = Enum.Font.Gotham
    Button.Parent = parent

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = Button

    local ButtonGlow = Instance.new("UIStroke")
    ButtonGlow.Color = Color3.fromRGB(255, 0, 0)
    ButtonGlow.Thickness = 1.5
    ButtonGlow.Transparency = 0.5
    ButtonGlow.Parent = Button

    Button.MouseEnter:Connect(function()
        TweenService:Create(ButtonGlow, TweenInfo.new(0.3), {Transparency = 0}):Play()
    end)
    Button.MouseLeave:Connect(function()
        TweenService:Create(ButtonGlow, TweenInfo.new(0.3), {Transparency = 0.5}):Play()
    end)

    return Button
end

-- Item Selection Menu
local ItemSelectionFrame = Instance.new("Frame")
ItemSelectionFrame.Size = UDim2.new(0, 280, 0, 350)
ItemSelectionFrame.Position = UDim2.new(0.5, -140, 0.5, -175)
ItemSelectionFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
ItemSelectionFrame.BorderSizePixel = 0
ItemSelectionFrame.Visible = false
ItemSelectionFrame.Parent = ScreenGui

local ItemSelectionCorner = Instance.new("UICorner")
ItemSelectionCorner.CornerRadius = UDim.new(0, 12)
ItemSelectionCorner.Parent = ItemSelectionFrame

local ItemSelectionStroke = Instance.new("UIStroke")
ItemSelectionStroke.Color = Color3.fromRGB(255, 0, 0)
ItemSelectionStroke.Thickness = 2
ItemSelectionStroke.Transparency = 0.5
ItemSelectionStroke.Parent = ItemSelectionFrame

-- Close Button for Item Selection
local ItemSelectionCloseButton = Instance.new("TextButton")
ItemSelectionCloseButton.Size = UDim2.new(0, 25, 0, 25)
ItemSelectionCloseButton.Position = UDim2.new(1, -35, 0, 8)
ItemSelectionCloseButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
ItemSelectionCloseButton.Text = "X"
ItemSelectionCloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ItemSelectionCloseButton.TextSize = 14
ItemSelectionCloseButton.Font = Enum.Font.GothamBold
ItemSelectionCloseButton.Parent = ItemSelectionFrame

local ItemSelectionCloseCorner = Instance.new("UICorner")
ItemSelectionCloseCorner.CornerRadius = UDim.new(0, 5)
ItemSelectionCloseCorner.Parent = ItemSelectionCloseButton

ItemSelectionCloseButton.MouseButton1Click:Connect(function()
    ItemSelectionFrame.Visible = false
end)

local ItemSelectionTitle = Instance.new("TextLabel")
ItemSelectionTitle.Size = UDim2.new(0, 200, 0, 30)
ItemSelectionTitle.Position = UDim2.new(0, 40, 0, 10)
ItemSelectionTitle.BackgroundTransparency = 1
ItemSelectionTitle.Text = "Select Items to Collect"
ItemSelectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
ItemSelectionTitle.TextSize = 16
ItemSelectionTitle.Font = Enum.Font.GothamBold
ItemSelectionTitle.Parent = ItemSelectionFrame

-- Available items
local availableItems = {
    "Tyre",
    "Sheet Metal",
    "Broken Fan",
    "Bolt",
    "Old Radio",
    "UFO Junk",
    "UFO Scrap",
    "Broken Microwave"
}

local selectedItems = {}
local itemCheckboxes = {}

-- Create checkboxes for items
for i, itemName in ipairs(availableItems) do
    local yPos = 40 + (i-1) * 35
    
    local checkbox = Instance.new("TextButton")
    checkbox.Size = UDim2.new(0, 25, 0, 25)
    checkbox.Position = UDim2.new(0, 20, 0, yPos)
    checkbox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    checkbox.Text = ""
    checkbox.TextColor3 = Color3.fromRGB(255, 255, 255)
    checkbox.TextSize = 14
    checkbox.Font = Enum.Font.GothamBold
    checkbox.Parent = ItemSelectionFrame
    
    local checkboxCorner = Instance.new("UICorner")
    checkboxCorner.CornerRadius = UDim.new(0, 4)
    checkboxCorner.Parent = checkbox
    
    local checkboxStroke = Instance.new("UIStroke")
    checkboxStroke.Color = Color3.fromRGB(255, 0, 0)
    checkboxStroke.Thickness = 1
    checkboxStroke.Transparency = 0.5
    checkboxStroke.Parent = checkbox
    
    local itemLabel = Instance.new("TextLabel")
    itemLabel.Size = UDim2.new(0, 180, 0, 25)
    itemLabel.Position = UDim2.new(0, 55, 0, yPos)
    itemLabel.BackgroundTransparency = 1
    itemLabel.Text = itemName
    itemLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    itemLabel.TextSize = 14
    itemLabel.Font = Enum.Font.Gotham
    itemLabel.TextXAlignment = Enum.TextXAlignment.Left
    itemLabel.Parent = ItemSelectionFrame
    
    checkbox.MouseButton1Click:Connect(function()
        selectedItems[itemName] = not selectedItems[itemName]
        if selectedItems[itemName] then
            checkbox.Text = "✓"
            checkbox.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        else
            checkbox.Text = ""
            checkbox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        end
    end)
    
    itemCheckboxes[itemName] = checkbox
end

-- Start Collection Button
local StartCollectionButton = CreateButton("Start Collection", 290, ItemSelectionFrame)
StartCollectionButton.Size = UDim2.new(0, 240, 0, 35)
StartCollectionButton.Position = UDim2.new(0, 20, 0, 310)

-- Main buttons
local CollectItemsButton = CreateButton("Collect Items", 40)

-- Draggable GUI for main frame
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
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
        
        -- Capture the input for smoother dragging
        input:Capture()
    end
end)

Frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

Frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

-- Draggable GUI for item selection frame
local itemSelectionDragging = false
local itemSelectionDragInput = nil
local itemSelectionDragStart = nil
local itemSelectionStartPos = nil

local function updateItemSelection(input)
    if itemSelectionDragging then
        local delta = input.Position - itemSelectionDragStart
        ItemSelectionFrame.Position = UDim2.new(itemSelectionStartPos.X.Scale, itemSelectionStartPos.X.Offset + delta.X, itemSelectionStartPos.Y.Scale, itemSelectionStartPos.Y.Offset + delta.Y)
    end
end

ItemSelectionFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        itemSelectionDragging = true
        itemSelectionDragStart = input.Position
        itemSelectionStartPos = ItemSelectionFrame.Position
        input:Capture()
    end
end)

ItemSelectionFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        itemSelectionDragging = false
    end
end)

ItemSelectionFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        itemSelectionDragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        update(input)
    elseif itemSelectionDragging and input == itemSelectionDragInput then
        updateItemSelection(input)
    end
end)

-- Variables
local CollectItemsActive = false

-- DragItem function
local function DragItem(obj)
    if obj and obj.PrimaryPart then
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            obj:SetPrimaryPartCFrame(character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0))
        end
    end
end

-- Collection Function
local function CollectionFunction()
    while CollectItemsActive do
        for _, Obj in pairs(Workspace.Items:GetChildren()) do
            if not CollectItemsActive then break end
            if selectedItems[Obj.Name] and Obj:IsA("Model") and Obj.PrimaryPart then 
                DragItem(Obj)
                task.wait(0.2)
            end 
        end
        task.wait(1)
    end
end

-- Button Functions
CollectItemsButton.MouseButton1Click:Connect(function()
    ItemSelectionFrame.Visible = true
end)

StartCollectionButton.MouseButton1Click:Connect(function()
    -- Check if any items are selected
    local hasSelected = false
    for _, selected in pairs(selectedItems) do
        if selected then
            hasSelected = true
            break
        end
    end
    
    if not hasSelected then
        ShowNotification("Please select at least one item!")
        return
    end
    
    CollectItemsActive = true
    CollectItemsButton.Text = "Collect Items: ON"
    CollectItemsButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    ItemSelectionFrame.Visible = false
    
    -- Show which items are selected
    local selectedList = ""
    for itemName, selected in pairs(selectedItems) do
        if selected then
            selectedList = selectedList .. itemName .. ", "
        end
    end
    selectedList = selectedList:sub(1, -3) -- Remove last comma
    
    ShowNotification("Collecting: " .. selectedList)
    task.spawn(CollectionFunction)
end)

-- Close and Minimize Functions
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

MinimizeButton.MouseButton1Click:Connect(function()
    local Minimized = not (Frame.Size == UDim2.new(0, 280, 0, 40))
    MinimizeButton.Text = Minimized and "+" or "-"
    CollectItemsButton.Visible = not Minimized
    Frame.Size = Minimized and UDim2.new(0, 280, 0, 40) or UDim2.new(0, 280, 0, 200)
end)

-- Initial notification
ShowNotification("Echelon GUI Loaded!")