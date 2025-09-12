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
ScreenGui.Name = "SFXCL CHEAT"
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

-- SFXCL Label
local SFXCLLabel = Instance.new("TextLabel")
SFXCLLabel.Size = UDim2.new(0, 120, 0, 25)
SFXCLLabel.Position = UDim2.new(0, 10, 0, 8)
SFXCLLabel.BackgroundTransparency = 1
SFXCLLabel.Text = "By @SFXCL"
SFXCLLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SFXCLLabel.TextSize = 18
SFXCLLabel.Font = Enum.Font.GothamBold
SFXCLLabel.Parent = Frame

local SFXCLGlow = Instance.new("UIGradient")
SFXCLGlow.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 0, 0))
})
SFXCLGlow.Parent = SFXCLLabel
local tweenSFXCL = TweenService:Create(SFXCLGlow, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Rotation = 360})
tweenSFXCL:Play()

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
-- Таблицы с локализованными текстовыми элементами
local SpeedMultiPlayer = CreateButton("Спидхак", 40)
local MoneyFarmButton = CreateButton("Фарм Монет", 90)
local PathViewButton = CreateButton("Path View", 140)

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
local MoneyFarmActive = false

-- Money Farm Function
local function MoneyFarm()
    while MoneyFarmActive do
        local character = LocalPlayer.Character
        local dropsFolder = Workspace:FindFirstChild("Drops")
        if character and character:FindFirstChild("HumanoidRootPart") and dropsFolder then
            for _, drop in pairs(dropsFolder:GetChildren()) do
                if drop.Name == "CashDrop" and MoneyFarmActive then
                    if drop:IsA("Model") then
                        if drop.PrimaryPart then
                            character.HumanoidRootPart.CFrame = drop.PrimaryPart.CFrame + Vector3.new(0, 3, 0)
                        else
                            local firstPart = drop:FindFirstChildWhichIsA("BasePart")
                            if firstPart then
                                character.HumanoidRootPart.CFrame = firstPart.CFrame + Vector3.new(0, 3, 0)
                            end
                        end
                    elseif drop:IsA("BasePart") then
                        character.HumanoidRootPart.CFrame = drop.CFrame + Vector3.new(0, 3, 0)
                    end
                    task.wait(0.2)
                end
            end
        else
            warn("Drops folder not found.")
        end
        task.wait(0.5)
    end
end

MoneyFarmButton.MouseButton1Click:Connect(function()
    MoneyFarmActive = not MoneyFarmActive
    MoneyFarmButton.Text = "Фарм Монет" .. (MoneyFarmActive and "Вкл" or "Выкл")
    MoneyFarmButton.BackgroundColor3 = MoneyFarmActive and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(20, 20, 20)
    if MoneyFarmActive then
        ShowNotification("Если вы ищете монеты подождите, это может занять 30 секунд")
        task.spawn(MoneyFarm)
    end
end)

-- Character respawn handling
LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    if MoneyFarmActive then
        task.spawn(function()
            local hrp = newCharacter:WaitForChild("HumanoidRootPart")
            while MoneyFarmActive and hrp.Parent do
                local dropsFolder = Workspace:FindFirstChild("Drops")
                if dropsFolder then
                    for _, drop in pairs(dropsFolder:GetChildren()) do
                        if drop.Name == "CashDrop" and MoneyFarmActive then
                            if drop:IsA("Model") then
                                if drop.PrimaryPart then
                                    hrp.CFrame = drop.PrimaryPart.CFrame + Vector3.new(0, 3, 0)
                                else
                                    local firstPart = drop:FindFirstChildWhichIsA("BasePart")
                                    if firstPart then
                                        hrp.CFrame = firstPart.CFrame + Vector3.new(0, 3, 0)
                                    end
                                end
                            elseif drop:IsA("BasePart") then
                                hrp.CFrame = drop.CFrame + Vector3.new(0, 3, 0)
                            end
                            task.wait(0.2)
                        end
                    end
                else
                    warn("Drops folder not found.")
                end
                task.wait(0.5)
            end
        end)
    end
end)

-- Path View Function
PathViewButton.MouseButton1Click:Connect(function()
    local bridge = Workspace:FindFirstChild("Bridge")
    if bridge then
        for _, v in pairs(bridge:GetChildren()) do
            if v.Name:match("RedParts") then
                v:Destroy()
                ShowNotification(v.Name .. " deleted.")
            end
        end
    else
        ShowNotification("Bridge folder not found.")
    end
    PathViewButton.Text = "Path View: Fired"
    task.spawn(function()
        task.wait(0.5)
        PathViewButton.Text = "Path View: OFF"
    end)
end)

-- Button Functions
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

MinimizeButton.MouseButton1Click:Connect(function()
    Minimized = not Minimized
    MinimizeButton.Text = Minimized and "+" or "-"
    SpeedMultiPlayer.Visible = not Minimized
    MoneyFarmButton.Visible = not Minimized
    PathViewButton.Visible = not Minimized
    Frame.Size = Minimized and UDim2.new(0, 250, 0, 40) or UDim2.new(0, 250, 0, 150)
end)
