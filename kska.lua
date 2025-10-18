-- SANSTRO Menu for Mobile
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Переменные для GUI
local ScreenGui = nil
local MainFrame = nil
local minimized = false

-- Функция создания GUI
local function createGUI()
    if ScreenGui then
        ScreenGui:Destroy()
    end

    -- Create GUI
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SANSTRO_GUI"
    ScreenGui.Parent = player.PlayerGui
    ScreenGui.ResetOnSpawn = false -- Чтобы GUI не пропадал после смерти

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 300, 0, 400)
    MainFrame.Position = UDim2.new(0, 10, 0, 10)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = MainFrame

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Position = UDim2.new(0, 0, 0, 0)
    Title.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Text = "SANSTRO|t.me//SCRIPTYTA"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.Parent = MainFrame

    -- Кнопка сворачивания/разворачивания
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "ToggleButton"
    ToggleButton.Size = UDim2.new(0, 30, 0, 30)
    ToggleButton.Position = UDim2.new(1, -35, 0, 5)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.Text = "-"
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.TextSize = 14
    ToggleButton.Parent = MainFrame

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 6)
    ToggleCorner.Parent = ToggleButton

    local TabButtons = Instance.new("Frame")
    TabButtons.Name = "TabButtons"
    TabButtons.Size = UDim2.new(1, 0, 0, 40)
    TabButtons.Position = UDim2.new(0, 0, 0, 40)
    TabButtons.BackgroundTransparency = 1
    TabButtons.Parent = MainFrame

    -- Movement Tab
    local MovementTab = Instance.new("TextButton")
    MovementTab.Name = "MovementTab"
    MovementTab.Size = UDim2.new(0.33, 0, 1, 0)
    MovementTab.Position = UDim2.new(0, 0, 0, 0)
    MovementTab.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    MovementTab.TextColor3 = Color3.fromRGB(255, 255, 255)
    MovementTab.Text = "Movement"
    MovementTab.Font = Enum.Font.Gotham
    MovementTab.TextSize = 14
    MovementTab.Parent = TabButtons

    -- Visual Tab
    local VisualTab = Instance.new("TextButton")
    VisualTab.Name = "VisualTab"
    VisualTab.Size = UDim2.new(0.33, 0, 1, 0)
    VisualTab.Position = UDim2.new(0.33, 0, 0, 0)
    VisualTab.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    VisualTab.TextColor3 = Color3.fromRGB(255, 255, 255)
    VisualTab.Text = "Visual"
    VisualTab.Font = Enum.Font.Gotham
    VisualTab.TextSize = 14
    VisualTab.Parent = TabButtons

    -- AimBot Tab
    local AimBotTab = Instance.new("TextButton")
    AimBotTab.Name = "AimBotTab"
    AimBotTab.Size = UDim2.new(0.34, 0, 1, 0)
    AimBotTab.Position = UDim2.new(0.66, 0, 0, 0)
    AimBotTab.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    AimBotTab.TextColor3 = Color3.fromRGB(255, 255, 255)
    AimBotTab.Text = "AimBot"
    AimBotTab.Font = Enum.Font.Gotham
    AimBotTab.TextSize = 14
    AimBotTab.Parent = TabButtons

    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Size = UDim2.new(1, -20, 1, -100)
    ContentFrame.Position = UDim2.new(0, 10, 0, 90)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Parent = MainFrame

    local ScrollFrame = Instance.new("ScrollingFrame")
    ScrollFrame.Name = "ScrollFrame"
    ScrollFrame.Size = UDim2.new(1, 0, 1, 0)
    ScrollFrame.BackgroundTransparency = 1
    ScrollFrame.ScrollBarThickness = 4
    ScrollFrame.Parent = ContentFrame

    -- Movement Content
    local MovementContent = Instance.new("Frame")
    MovementContent.Name = "MovementContent"
    MovementContent.Size = UDim2.new(1, 0, 0, 300)
    MovementContent.BackgroundTransparency = 1
    MovementContent.Visible = true
    MovementContent.Parent = ScrollFrame

    -- Speed Hack
    local SpeedHackFrame = Instance.new("Frame")
    SpeedHackFrame.Name = "SpeedHackFrame"
    SpeedHackFrame.Size = UDim2.new(1, 0, 0, 80)
    SpeedHackFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    SpeedHackFrame.BorderSizePixel = 0
    SpeedHackFrame.Parent = MovementContent

    local SpeedHackCorner = Instance.new("UICorner")
    SpeedHackCorner.CornerRadius = UDim.new(0, 6)
    SpeedHackCorner.Parent = SpeedHackFrame

    local SpeedHackLabel = Instance.new("TextLabel")
    SpeedHackLabel.Name = "SpeedHackLabel"
    SpeedHackLabel.Size = UDim2.new(0.6, 0, 0, 30)
    SpeedHackLabel.Position = UDim2.new(0, 10, 0, 10)
    SpeedHackLabel.BackgroundTransparency = 1
    SpeedHackLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SpeedHackLabel.Text = "Speed Hack"
    SpeedHackLabel.Font = Enum.Font.Gotham
    SpeedHackLabel.TextSize = 14
    SpeedHackLabel.TextXAlignment = Enum.TextXAlignment.Left
    SpeedHackLabel.Parent = SpeedHackFrame

    local SpeedHackToggle = Instance.new("TextButton")
    SpeedHackToggle.Name = "SpeedHackToggle"
    SpeedHackToggle.Size = UDim2.new(0.3, 0, 0, 30)
    SpeedHackToggle.Position = UDim2.new(0.7, 0, 0, 10)
    SpeedHackToggle.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
    SpeedHackToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    SpeedHackToggle.Text = "OFF"
    SpeedHackToggle.Font = Enum.Font.Gotham
    SpeedHackToggle.TextSize = 12
    SpeedHackToggle.Parent = SpeedHackFrame

    local SpeedHackSlider = Instance.new("Frame")
    SpeedHackSlider.Name = "SpeedHackSlider"
    SpeedHackSlider.Size = UDim2.new(1, -20, 0, 30)
    SpeedHackSlider.Position = UDim2.new(0, 10, 0, 45)
    SpeedHackSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    SpeedHackSlider.BorderSizePixel = 0
    SpeedHackSlider.Visible = false
    SpeedHackSlider.Parent = SpeedHackFrame

    local SpeedHackSliderCorner = Instance.new("UICorner")
    SpeedHackSliderCorner.CornerRadius = UDim.new(0, 4)
    SpeedHackSliderCorner.Parent = SpeedHackSlider

    local SpeedValue = Instance.new("TextLabel")
    SpeedValue.Name = "SpeedValue"
    SpeedValue.Size = UDim2.new(1, 0, 1, 0)
    SpeedValue.BackgroundTransparency = 1
    SpeedValue.TextColor3 = Color3.fromRGB(255, 255, 255)
    SpeedValue.Text = "Speed: 16"
    SpeedValue.Font = Enum.Font.Gotham
    SpeedValue.TextSize = 12
    SpeedValue.Parent = SpeedHackSlider

    -- Jump Hack
    local JumpHackFrame = Instance.new("Frame")
    JumpHackFrame.Name = "JumpHackFrame"
    JumpHackFrame.Size = UDim2.new(1, 0, 0, 40)
    JumpHackFrame.Position = UDim2.new(0, 0, 0, 90)
    JumpHackFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    JumpHackFrame.BorderSizePixel = 0
    JumpHackFrame.Parent = MovementContent

    local JumpHackCorner = Instance.new("UICorner")
    JumpHackCorner.CornerRadius = UDim.new(0, 6)
    JumpHackCorner.Parent = JumpHackFrame

    local JumpHackLabel = Instance.new("TextLabel")
    JumpHackLabel.Name = "JumpHackLabel"
    JumpHackLabel.Size = UDim2.new(0.6, 0, 1, 0)
    JumpHackLabel.Position = UDim2.new(0, 10, 0, 0)
    JumpHackLabel.BackgroundTransparency = 1
    JumpHackLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    JumpHackLabel.Text = "Jump Hack"
    JumpHackLabel.Font = Enum.Font.Gotham
    JumpHackLabel.TextSize = 14
    JumpHackLabel.TextXAlignment = Enum.TextXAlignment.Left
    JumpHackLabel.Parent = JumpHackFrame

    local JumpHackToggle = Instance.new("TextButton")
    JumpHackToggle.Name = "JumpHackToggle"
    JumpHackToggle.Size = UDim2.new(0.3, 0, 0, 30)
    JumpHackToggle.Position = UDim2.new(0.7, 0, 0.125, 0)
    JumpHackToggle.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
    JumpHackToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    JumpHackToggle.Text = "OFF"
    JumpHackToggle.Font = Enum.Font.Gotham
    JumpHackToggle.TextSize = 12
    JumpHackToggle.Parent = JumpHackFrame

    -- NoClip
    local NoClipFrame = Instance.new("Frame")
    NoClipFrame.Name = "NoClipFrame"
    NoClipFrame.Size = UDim2.new(1, 0, 0, 40)
    NoClipFrame.Position = UDim2.new(0, 0, 0, 140)
    NoClipFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    NoClipFrame.BorderSizePixel = 0
    NoClipFrame.Parent = MovementContent

    local NoClipCorner = Instance.new("UICorner")
    NoClipCorner.CornerRadius = UDim.new(0, 6)
    NoClipCorner.Parent = NoClipFrame

    local NoClipLabel = Instance.new("TextLabel")
    NoClipLabel.Name = "NoClipLabel"
    NoClipLabel.Size = UDim2.new(0.6, 0, 1, 0)
    NoClipLabel.Position = UDim2.new(0, 10, 0, 0)
    NoClipLabel.BackgroundTransparency = 1
    NoClipLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    NoClipLabel.Text = "NoClip"
    NoClipLabel.Font = Enum.Font.Gotham
    NoClipLabel.TextSize = 14
    NoClipLabel.TextXAlignment = Enum.TextXAlignment.Left
    NoClipLabel.Parent = NoClipFrame

    local NoClipToggle = Instance.new("TextButton")
    NoClipToggle.Name = "NoClipToggle"
    NoClipToggle.Size = UDim2.new(0.3, 0, 0, 30)
    NoClipToggle.Position = UDim2.new(0.7, 0, 0.125, 0)
    NoClipToggle.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
    NoClipToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    NoClipToggle.Text = "OFF"
    NoClipToggle.Font = Enum.Font.Gotham
    NoClipToggle.TextSize = 12
    NoClipToggle.Parent = NoClipFrame

    -- Visual Content
    local VisualContent = Instance.new("Frame")
    VisualContent.Name = "VisualContent"
    VisualContent.Size = UDim2.new(1, 0, 0, 200)
    VisualContent.BackgroundTransparency = 1
    VisualContent.Visible = false
    VisualContent.Parent = ScrollFrame

    -- ESP Tracers
    local ESPTracersFrame = Instance.new("Frame")
    ESPTracersFrame.Name = "ESPTracersFrame"
    ESPTracersFrame.Size = UDim2.new(1, 0, 0, 40)
    ESPTracersFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    ESPTracersFrame.BorderSizePixel = 0
    ESPTracersFrame.Parent = VisualContent

    local ESPTracersCorner = Instance.new("UICorner")
    ESPTracersCorner.CornerRadius = UDim.new(0, 6)
    ESPTracersCorner.Parent = ESPTracersFrame

    local ESPTracersLabel = Instance.new("TextLabel")
    ESPTracersLabel.Name = "ESPTracersLabel"
    ESPTracersLabel.Size = UDim2.new(0.6, 0, 1, 0)
    ESPTracersLabel.Position = UDim2.new(0, 10, 0, 0)
    ESPTracersLabel.BackgroundTransparency = 1
    ESPTracersLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ESPTracersLabel.Text = "ESP Tracers"
    ESPTracersLabel.Font = Enum.Font.Gotham
    ESPTracersLabel.TextSize = 14
    ESPTracersLabel.TextXAlignment = Enum.TextXAlignment.Left
    ESPTracersLabel.Parent = ESPTracersFrame

    local ESPTracersToggle = Instance.new("TextButton")
    ESPTracersToggle.Name = "ESPTracersToggle"
    ESPTracersToggle.Size = UDim2.new(0.3, 0, 0, 30)
    ESPTracersToggle.Position = UDim2.new(0.7, 0, 0.125, 0)
    ESPTracersToggle.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
    ESPTracersToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    ESPTracersToggle.Text = "OFF"
    ESPTracersToggle.Font = Enum.Font.Gotham
    ESPTracersToggle.TextSize = 12
    ESPTracersToggle.Parent = ESPTracersFrame

    -- ESP Box
    local ESPBoxFrame = Instance.new("Frame")
    ESPBoxFrame.Name = "ESPBoxFrame"
    ESPBoxFrame.Size = UDim2.new(1, 0, 0, 40)
    ESPBoxFrame.Position = UDim2.new(0, 0, 0, 50)
    ESPBoxFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    ESPBoxFrame.BorderSizePixel = 0
    ESPBoxFrame.Parent = VisualContent

    local ESPBoxCorner = Instance.new("UICorner")
    ESPBoxCorner.CornerRadius = UDim.new(0, 6)
    ESPBoxCorner.Parent = ESPBoxFrame

    local ESPBoxLabel = Instance.new("TextLabel")
    ESPBoxLabel.Name = "ESPBoxLabel"
    ESPBoxLabel.Size = UDim2.new(0.6, 0, 1, 0)
    ESPBoxLabel.Position = UDim2.new(0, 10, 0, 0)
    ESPBoxLabel.BackgroundTransparency = 1
    ESPBoxLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ESPBoxLabel.Text = "ESP Box"
    ESPBoxLabel.Font = Enum.Font.Gotham
    ESPBoxLabel.TextSize = 14
    ESPBoxLabel.TextXAlignment = Enum.TextXAlignment.Left
    ESPBoxLabel.Parent = ESPBoxFrame

    local ESPBoxToggle = Instance.new("TextButton")
    ESPBoxToggle.Name = "ESPBoxToggle"
    ESPBoxToggle.Size = UDim2.new(0.3, 0, 0, 30)
    ESPBoxToggle.Position = UDim2.new(0.7, 0, 0.125, 0)
    ESPBoxToggle.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
    ESPBoxToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    ESPBoxToggle.Text = "OFF"
    ESPBoxToggle.Font = Enum.Font.Gotham
    ESPBoxToggle.TextSize = 12
    ESPBoxToggle.Parent = ESPBoxFrame

    -- ESP Health
    local ESPHealthFrame = Instance.new("Frame")
    ESPHealthFrame.Name = "ESPHealthFrame"
    ESPHealthFrame.Size = UDim2.new(1, 0, 0, 40)
    ESPHealthFrame.Position = UDim2.new(0, 0, 0, 100)
    ESPHealthFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    ESPHealthFrame.BorderSizePixel = 0
    ESPHealthFrame.Parent = VisualContent

    local ESPHealthCorner = Instance.new("UICorner")
    ESPHealthCorner.CornerRadius = UDim.new(0, 6)
    ESPHealthCorner.Parent = ESPHealthFrame

    local ESPHealthLabel = Instance.new("TextLabel")
    ESPHealthLabel.Name = "ESPHealthLabel"
    ESPHealthLabel.Size = UDim2.new(0.6, 0, 1, 0)
    ESPHealthLabel.Position = UDim2.new(0, 10, 0, 0)
    ESPHealthLabel.BackgroundTransparency = 1
    ESPHealthLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ESPHealthLabel.Text = "ESP Health"
    ESPHealthLabel.Font = Enum.Font.Gotham
    ESPHealthLabel.TextSize = 14
    ESPHealthLabel.TextXAlignment = Enum.TextXAlignment.Left
    ESPHealthLabel.Parent = ESPHealthFrame

    local ESPHealthToggle = Instance.new("TextButton")
    ESPHealthToggle.Name = "ESPHealthToggle"
    ESPHealthToggle.Size = UDim2.new(0.3, 0, 0, 30)
    ESPHealthToggle.Position = UDim2.new(0.7, 0, 0.125, 0)
    ESPHealthToggle.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
    ESPHealthToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    ESPHealthToggle.Text = "OFF"
    ESPHealthToggle.Font = Enum.Font.Gotham
    ESPHealthToggle.TextSize = 12
    ESPHealthToggle.Parent = ESPHealthFrame

    -- AimBot Content
    local AimBotContent = Instance.new("Frame")
    AimBotContent.Name = "AimBotContent"
    AimBotContent.Size = UDim2.new(1, 0, 0, 120)
    AimBotContent.BackgroundTransparency = 1
    AimBotContent.Visible = false
    AimBotContent.Parent = ScrollFrame

    -- AimBot Toggle
    local AimBotFrame = Instance.new("Frame")
    AimBotFrame.Name = "AimBotFrame"
    AimBotFrame.Size = UDim2.new(1, 0, 0, 40)
    AimBotFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    AimBotFrame.BorderSizePixel = 0
    AimBotFrame.Parent = AimBotContent

    local AimBotCorner = Instance.new("UICorner")
    AimBotCorner.CornerRadius = UDim.new(0, 6)
    AimBotCorner.Parent = AimBotFrame

    local AimBotLabel = Instance.new("TextLabel")
    AimBotLabel.Name = "AimBotLabel"
    AimBotLabel.Size = UDim2.new(0.6, 0, 1, 0)
    AimBotLabel.Position = UDim2.new(0, 10, 0, 0)
    AimBotLabel.BackgroundTransparency = 1
    AimBotLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    AimBotLabel.Text = "AimBot"
    AimBotLabel.Font = Enum.Font.Gotham
    AimBotLabel.TextSize = 14
    AimBotLabel.TextXAlignment = Enum.TextXAlignment.Left
    AimBotLabel.Parent = AimBotFrame

    local AimBotToggle = Instance.new("TextButton")
    AimBotToggle.Name = "AimBotToggle"
    AimBotToggle.Size = UDim2.new(0.3, 0, 0, 30)
    AimBotToggle.Position = UDim2.new(0.7, 0, 0.125, 0)
    AimBotToggle.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
    AimBotToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    AimBotToggle.Text = "OFF"
    AimBotToggle.Font = Enum.Font.Gotham
    AimBotToggle.TextSize = 12
    AimBotToggle.Parent = AimBotFrame

    -- AimBot Radius Slider
    local AimBotRadiusFrame = Instance.new("Frame")
    AimBotRadiusFrame.Name = "AimBotRadiusFrame"
    AimBotRadiusFrame.Size = UDim2.new(1, 0, 0, 60)
    AimBotRadiusFrame.Position = UDim2.new(0, 0, 0, 50)
    AimBotRadiusFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    AimBotRadiusFrame.BorderSizePixel = 0
    AimBotRadiusFrame.Visible = false
    AimBotRadiusFrame.Parent = AimBotContent

    local AimBotRadiusCorner = Instance.new("UICorner")
    AimBotRadiusCorner.CornerRadius = UDim.new(0, 6)
    AimBotRadiusCorner.Parent = AimBotRadiusFrame

    local AimBotRadiusLabel = Instance.new("TextLabel")
    AimBotRadiusLabel.Name = "AimBotRadiusLabel"
    AimBotRadiusLabel.Size = UDim2.new(1, 0, 0, 30)
    AimBotRadiusLabel.Position = UDim2.new(0, 0, 0, 0)
    AimBotRadiusLabel.BackgroundTransparency = 1
    AimBotRadiusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    AimBotRadiusLabel.Text = "AimBot Radius: 50"
    AimBotRadiusLabel.Font = Enum.Font.Gotham
    AimBotRadiusLabel.TextSize = 12
    AimBotRadiusLabel.Parent = AimBotRadiusFrame

    -- Variables
    local speedHackEnabled = false
    local jumpHackEnabled = false
    local noclipEnabled = false
    local espTracersEnabled = false
    local espBoxEnabled = false
    local espHealthEnabled = false
    local aimBotEnabled = false

    local currentSpeed = 16
    local aimBotRadius = 50

    local espObjects = {}
    local noclipConnection

    -- Functions
    local function toggleButton(button, enabled)
        if enabled then
            button.BackgroundColor3 = Color3.fromRGB(0, 170, 127)
            button.Text = "ON"
        else
            button.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
            button.Text = "OFF"
        end
    end

    -- Speed Hack
    SpeedHackToggle.MouseButton1Click:Connect(function()
        speedHackEnabled = not speedHackEnabled
        toggleButton(SpeedHackToggle, speedHackEnabled)
        SpeedHackSlider.Visible = speedHackEnabled
        
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
    end)

    -- Speed Slider
    SpeedHackSlider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            local connection
            connection = RunService.Heartbeat:Connect(function()
                local mouseLocation = UserInputService:GetMouseLocation()
                local relativeX = math.clamp((mouseLocation.X - SpeedHackSlider.AbsolutePosition.X) / SpeedHackSlider.AbsoluteSize.X, 0, 1)
                currentSpeed = math.floor(16 + (relativeX * 84)) -- 16 to 100
                SpeedValue.Text = "Speed: " .. currentSpeed
                
                if speedHackEnabled then
                    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid.WalkSpeed = currentSpeed
                    end
                end
            end)
            
            local function disconnect()
                connection:Disconnect()
            end
            
            SpeedHackSlider.InputEnded:Connect(disconnect)
        end
    end)

    -- Jump Hack
    JumpHackToggle.MouseButton1Click:Connect(function()
        jumpHackEnabled = not jumpHackEnabled
        toggleButton(JumpHackToggle, jumpHackEnabled)
    end)

    -- Infinite Jump
    UserInputService.JumpRequest:Connect(function()
        if jumpHackEnabled and player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)

    -- NoClip
    NoClipToggle.MouseButton1Click:Connect(function()
        noclipEnabled = not noclipEnabled
        toggleButton(NoClipToggle, noclipEnabled)
        
        if noclipEnabled then
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
            end
        end
    end)

    -- ESP Functions
    local function createESP(otherPlayer)
        if otherPlayer == player then return end
        
        espObjects[otherPlayer] = {
            tracer = nil,
            box = nil,
            health = nil
        }
        
        local function updateESP()
            if not espObjects[otherPlayer] then return end
            
            if otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") and otherPlayer.Character:FindFirstChild("Humanoid") then
                local rootPart = otherPlayer.Character.HumanoidRootPart
                local humanoid = otherPlayer.Character.Humanoid
                local head = otherPlayer.Character:FindFirstChild("Head")
                
                if not head then return end
                
                local vector, onScreen = workspace.CurrentCamera:WorldToViewportPoint(rootPart.Position)
                
                if onScreen then
                    -- Tracer
                    if espTracersEnabled then
                        if not espObjects[otherPlayer].tracer then
                            espObjects[otherPlayer].tracer = Drawing.new("Line")
                            espObjects[otherPlayer].tracer.Thickness = 1
                            espObjects[otherPlayer].tracer.Color = Color3.fromRGB(255, 255, 255)
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
                            espObjects[otherPlayer].box.Color = Color3.fromRGB(255, 255, 255)
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
                            espObjects[otherPlayer].health.Color = Color3.fromRGB(255, 255, 255)
                        end
                        
                        local headPos = workspace.CurrentCamera:WorldToViewportPoint(head.Position)
                        espObjects[otherPlayer].health.Position = Vector2.new(headPos.X, headPos.Y - 40)
                        espObjects[otherPlayer].health.Text = "HP: " .. math.floor(humanoid.Health)
                        espObjects[otherPlayer].health.Visible = true
                    elseif espObjects[otherPlayer].health then
                        espObjects[otherPlayer].health.Visible = false
                    end
                else
                    if espObjects[otherPlayer].tracer then espObjects[otherPlayer].tracer.Visible = false end
                    if espObjects[otherPlayer].box then espObjects[otherPlayer].box.Visible = false end
                    if espObjects[otherPlayer].health then espObjects[otherPlayer].health.Visible = false end
                end
            else
                if espObjects[otherPlayer].tracer then espObjects[otherPlayer].tracer.Visible = false end
                if espObjects[otherPlayer].box then espObjects[otherPlayer].box.Visible = false end
                if espObjects[otherPlayer].health then espObjects[otherPlayer].health.Visible = false end
            end
        end
        
        -- Update ESP continuously
        local espConnection
        espConnection = RunService.Heartbeat:Connect(updateESP)
        
        -- Clean up when player leaves
        otherPlayer.AncestryChanged:Connect(function()
            if not otherPlayer.Parent then
                espConnection:Disconnect()
                if espObjects[otherPlayer] then
                    if espObjects[otherPlayer].tracer then espObjects[otherPlayer].tracer:Remove() end
                    if espObjects[otherPlayer].box then espObjects[otherPlayer].box:Remove() end
                    if espObjects[otherPlayer].health then espObjects[otherPlayer].health:Remove() end
                    espObjects[otherPlayer] = nil
                end
            end
        end)
    end

    -- ESP Tracers Toggle
    ESPTracersToggle.MouseButton1Click:Connect(function()
        espTracersEnabled = not espTracersEnabled
        toggleButton(ESPTracersToggle, espTracersEnabled)
    end)

    -- ESP Box Toggle
    ESPBoxToggle.MouseButton1Click:Connect(function()
        espBoxEnabled = not espBoxEnabled
        toggleButton(ESPBoxToggle, espBoxEnabled)
    end)

    -- ESP Health Toggle
    ESPHealthToggle.MouseButton1Click:Connect(function()
        espHealthEnabled = not espHealthEnabled
        toggleButton(ESPHealthToggle, espHealthEnabled)
    end)

    -- Initialize ESP for existing players
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        createESP(otherPlayer)
    end

    -- ESP for new players
    Players.PlayerAdded:Connect(function(newPlayer)
        createESP(newPlayer)
    end)

    -- Remove ESP when player leaves
    Players.PlayerRemoving:Connect(function(leftPlayer)
        if espObjects[leftPlayer] then
            if espObjects[leftPlayer].tracer then
                espObjects[leftPlayer].tracer:Remove()
            end
            if espObjects[leftPlayer].box then
                espObjects[leftPlayer].box:Remove()
            end
            if espObjects[leftPlayer].health then
                espObjects[leftPlayer].health:Remove()
            end
            espObjects[leftPlayer] = nil
        end
    end)

    -- AimBot
    AimBotToggle.MouseButton1Click:Connect(function()
        aimBotEnabled = not aimBotEnabled
        toggleButton(AimBotToggle, aimBotEnabled)
        AimBotRadiusFrame.Visible = aimBotEnabled
    end)

    -- AimBot Radius Slider
    AimBotRadiusFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            local connection
            connection = RunService.Heartbeat:Connect(function()
                local mouseLocation = UserInputService:GetMouseLocation()
                local relativeX = math.clamp((mouseLocation.X - AimBotRadiusFrame.AbsolutePosition.X) / AimBotRadiusFrame.AbsoluteSize.X, 0, 1)
                aimBotRadius = math.floor(10 + (relativeX * 190)) -- 10 to 200
                AimBotRadiusLabel.Text = "AimBot Radius: " .. aimBotRadius
            end)
            
            local function disconnect()
                connection:Disconnect()
            end
            
            AimBotRadiusFrame.InputEnded:Connect(disconnect)
        end
    end)

    -- Improved AimBot with wall check
    local function isPlayerVisible(targetPlayer)
        if not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            return false
        end
        
        local targetRoot = targetPlayer.Character.HumanoidRootPart
        local camera = workspace.CurrentCamera
        local origin = camera.CFrame.Position
        
        -- Raycast to target
        local direction = (targetRoot.Position - origin).Unit
        local ray = Ray.new(origin, direction * aimBotRadius)
        
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

    -- AimBot Logic
    RunService.Heartbeat:Connect(function()
        if aimBotEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local closestPlayer = nil
            local closestDistance = aimBotRadius
            
            for _, otherPlayer in pairs(Players:GetPlayers()) do
                if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") and otherPlayer.Character:FindFirstChild("Humanoid") and otherPlayer.Character.Humanoid.Health > 0 then
                    local distance = (player.Character.HumanoidRootPart.Position - otherPlayer.Character.HumanoidRootPart.Position).Magnitude
                    
                    if distance < closestDistance and isPlayerVisible(otherPlayer) then
                        closestDistance = distance
                        closestPlayer = otherPlayer
                    end
                end
            end
            
            if closestPlayer then
                workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, closestPlayer.Character.HumanoidRootPart.Position)
            end
        end
    end)

    -- Tab Switching
    MovementTab.MouseButton1Click:Connect(function()
        MovementContent.Visible = true
        VisualContent.Visible = false
        AimBotContent.Visible = false
        
        MovementTab.BackgroundColor3 = Color3.fromRGB(80, 80, 120)
        VisualTab.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        AimBotTab.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    end)

    VisualTab.MouseButton1Click:Connect(function()
        MovementContent.Visible = false
        VisualContent.Visible = true
        AimBotContent.Visible = false
        
        MovementTab.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        VisualTab.BackgroundColor3 = Color3.fromRGB(80, 80, 120)
        AimBotTab.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    end)

    AimBotTab.MouseButton1Click:Connect(function()
        MovementContent.Visible = false
        VisualContent.Visible = false
        AimBotContent.Visible = true
        
        MovementTab.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        VisualTab.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        AimBotTab.BackgroundColor3 = Color3.fromRGB(80, 80, 120)
    end)

    -- Toggle minimize/maximize
    ToggleButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            ContentFrame.Visible = false
            TabButtons.Visible = false
            MainFrame.Size = UDim2.new(0, 300, 0, 40)
            ToggleButton.Text = "+"
        else
            ContentFrame.Visible = true
            TabButtons.Visible = true
            MainFrame.Size = UDim2.new(0, 300, 0, 400)
            ToggleButton.Text = "-"
        end
    end)

    -- Auto-resize for mobile
    local function updateSize()
        local viewportSize = workspace.CurrentCamera.ViewportSize
        if minimized then
            MainFrame.Size = UDim2.new(0, math.min(300, viewportSize.X - 20), 0, 40)
        else
            MainFrame.Size = UDim2.new(0, math.min(300, viewportSize.X - 20), 0, math.min(400, viewportSize.Y - 20))
        end
    end

    updateSize()
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateSize)
end

-- Создаем GUI при запуске
createGUI()

-- Восстанавливаем GUI после смерти
player.CharacterAdded:Connect(function()
    wait(1) -- Небольшая задержка для загрузки персонажа
    createGUI()
end)