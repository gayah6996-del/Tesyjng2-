-- 99 Nights In The Forest - Fixed Custom UI Script
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Состояния функций
local ActiveEspItems, ActiveDistanceEsp, ActiveEspEnemy, ActiveEspChildren, ActiveEspPeltTrader = false, false, false, false, false
local ActivateFly, AlrActivatedFlyPC, ActiveNoCooldownPrompt, ActiveNoFog = false, false, false, false
local ActiveAutoChopTree, ActiveKillAura, ActivateInfiniteJump, ActiveNoclip = false, false, false, false
local DistanceForKillAura = 25
local DistanceForAutoChopTree = 25
local ValueSpeed = 16
local iyflyspeed = 1
local OldSpeed = 16

-- Основные переменные для UI
local MainGUI
local TabButtons = {}
local CurrentTab = "Info"

-- Функция перетаскивания предметов
local function DragItem(Item)
    task.spawn(function()
        for _, tool in pairs(LocalPlayer.Inventory:GetChildren()) do
            if tool:IsA("Model") and tool:GetAttribute("NumberItems") and tool:GetAttribute("Capacity") and tool:GetAttribute("NumberItems") < tool:GetAttribute("Capacity") then
                task.spawn(function()
                    local args = {tool, Item}
                    game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("RequestBagStoreItem"):InvokeServer(unpack(args))
                    wait(0.1)
                end)
            end
            wait(0.25)
        end
    end)
end

-- Функция получения информации о сервере
local function getServerInfo()
    local playerCount = #Players:GetPlayers()
    local maxPlayers = Players.MaxPlayers
    local isStudio = RunService:IsStudio()
    
    return {
        PlaceId = game.PlaceId,
        JobId = game.JobId,
        IsStudio = isStudio,
        CurrentPlayers = playerCount,
        MaxPlayers = maxPlayers
    }
end

-- Система полета
local IYMouse = LocalPlayer:GetMouse()
local FLYING = false
local QEfly = true
local vehicleflyspeed = 1
local flyKeyDown, flyKeyUp

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
                    BV.Velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (CONTROL.F + CONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(CONTROL.L + CONTROL.R, (CONTROL.F + CONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
                    lCONTROL = {F = CONTROL.F, B = CONTROL.B, L = CONTROL.L, R = CONTROL.R}
                elseif (CONTROL.L + CONTROL.R) == 0 and (CONTROL.F + CONTROL.B) == 0 and (CONTROL.Q + CONTROL.E) == 0 and SPEED ~= 0 then
                    BV.Velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (lCONTROL.F + lCONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(lCONTROL.L + lCONTROL.R, (lCONTROL.F + lCONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
                else
                    BV.Velocity = Vector3.new(0, 0, 0)
                end
                BG.CFrame = workspace.CurrentCamera.CoordinateFrame
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
        if KEY:lower() == 'w' then CONTROL.F = (vfly and vehicleflyspeed or iyflyspeed)
        elseif KEY:lower() == 's' then CONTROL.B = - (vfly and vehicleflyspeed or iyflyspeed)
        elseif KEY:lower() == 'a' then CONTROL.L = - (vfly and vehicleflyspeed or iyflyspeed)
        elseif KEY:lower() == 'd' then CONTROL.R = (vfly and vehicleflyspeed or iyflyspeed)
        elseif QEfly and KEY:lower() == 'e' then CONTROL.Q = (vfly and vehicleflyspeed or iyflyspeed)*2
        elseif QEfly and KEY:lower() == 'q' then CONTROL.E = -(vfly and vehicleflyspeed or iyflyspeed)*2
        end
        pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Track end)
    end)
    
    flyKeyUp = IYMouse.KeyUp:Connect(function(KEY)
        if KEY:lower() == 'w' then CONTROL.F = 0
        elseif KEY:lower() == 's' then CONTROL.B = 0
        elseif KEY:lower() == 'a' then CONTROL.L = 0
        elseif KEY:lower() == 'd' then CONTROL.R = 0
        elseif KEY:lower() == 'e' then CONTROL.Q = 0
        elseif KEY:lower() == 'q' then CONTROL.E = 0
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
    pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Custom end)
end

-- ESP система
local function CreateEsp(Char, Color, Text, Parent)
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
    billboard.StudsOffset = Vector3.new(0, 3, 0)
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
        local Camera = workspace.CurrentCamera
        while highlight and billboard and Parent and Parent.Parent do
            local cameraPosition = Camera and Camera.CFrame.Position
            if cameraPosition and Parent and Parent:IsA("BasePart") then
                local distance = (cameraPosition - Parent.Position).Magnitude
                task.spawn(function()
                    if ActiveDistanceEsp then
                        label.Text = Text.." ("..math.floor(distance + 0.5).." m)"
                    else
                        label.Text = Text
                    end
                end)
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

-- Функция для копирования в буфер обмена
local function copyToClipboard(text)
    if setclipboard then
        setclipboard(text)
    else
        warn("setclipboard is not supported in this environment.")
    end
end

-- Создание основного GUI
local function CreateMainGUI()
    -- Создаем основной ScreenGui
    MainGUI = Instance.new("ScreenGui")
    MainGUI.Name = "Custom99NightsGUI"
    MainGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    MainGUI.Parent = LocalPlayer:WaitForChild("PlayerGui")

    -- Основное окно
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 500, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = MainGUI

    -- Заголовок окна
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 30)
    TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Size = UDim2.new(1, -60, 1, 0)
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = "99 Nights In The Forest - Custom UI"
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 14
    TitleLabel.Parent = TitleBar

    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -30, 0, 0)
    CloseButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    CloseButton.BorderSizePixel = 0
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 14
    CloseButton.Parent = TitleBar

    CloseButton.MouseButton1Click:Connect(function()
        MainGUI:Destroy()
    end)

    -- Панель вкладок
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(0, 120, 1, -30)
    TabContainer.Position = UDim2.new(0, 0, 0, 30)
    TabContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TabContainer.BorderSizePixel = 0
    TabContainer.Parent = MainFrame

    -- Контейнер содержимого
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -120, 1, -30)
    ContentContainer.Position = UDim2.new(0, 120, 0, 30)
    ContentContainer.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    ContentContainer.BorderSizePixel = 0
    ContentContainer.Parent = MainFrame

    -- Создаем вкладки
    local Tabs = {"Info", "Player", "Esp", "Game", "Bring Item", "Discord", "Settings"}
    
    for i, tabName in ipairs(Tabs) do
        -- Кнопка вкладки
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName .. "TabButton"
        TabButton.Size = UDim2.new(1, 0, 0, 40)
        TabButton.Position = UDim2.new(0, 0, 0, (i-1) * 40)
        TabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        TabButton.BorderSizePixel = 0
        TabButton.Text = tabName
        TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabButton.Font = Enum.Font.Gotham
        TabButton.TextSize = 12
        TabButton.Parent = TabContainer
        
        -- Контент вкладки
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = tabName .. "Content"
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.Position = UDim2.new(0, 0, 0, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 6
        TabContent.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
        TabContent.Visible = false
        TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabContent.Parent = ContentContainer
        
        TabButtons[tabName] = {Button = TabButton, Content = TabContent}
        
        TabButton.MouseButton1Click:Connect(function()
            CurrentTab = tabName
            for name, tab in pairs(TabButtons) do
                if name == tabName then
                    tab.Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                    tab.Content.Visible = true
                else
                    tab.Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                    tab.Content.Visible = false
                end
            end
        end)
    end

    -- Активируем первую вкладку
    TabButtons["Info"].Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    TabButtons["Info"].Content.Visible = true

    -- Делаем окно перетаскиваемым
    local dragging = false
    local dragInput, dragStart, startPos

    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    return MainFrame
end

-- Функция для создания элементов UI
local function CreateButton(parent, text, callback)
    local Button = Instance.new("TextButton")
    Button.Name = text .. "Button"
    Button.Size = UDim2.new(0.9, 0, 0, 35)
    Button.Position = UDim2.new(0.05, 0, 0, #parent:GetChildren() * 40)
    Button.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
    Button.BorderSizePixel = 0
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.Gotham
    Button.TextSize = 12
    Button.Parent = parent
    
    Button.MouseButton1Click:Connect(callback)
    
    return Button
end

local function CreateToggle(parent, text, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = text .. "Toggle"
    ToggleFrame.Size = UDim2.new(0.9, 0, 0, 30)
    ToggleFrame.Position = UDim2.new(0.05, 0, 0, #parent:GetChildren() * 35)
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.Parent = parent
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "ToggleButton"
    ToggleButton.Size = UDim2.new(0, 20, 0, 20)
    ToggleButton.Position = UDim2.new(0, 0, 0.5, -10)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Text = ""
    ToggleButton.Parent = ToggleFrame
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Name = "ToggleLabel"
    ToggleLabel.Size = UDim2.new(1, -25, 1, 0)
    ToggleLabel.Position = UDim2.new(0, 25, 0, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Text = text
    ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.Font = Enum.Font.Gotham
    ToggleLabel.TextSize = 12
    ToggleLabel.Parent = ToggleFrame
    
    local isToggled = false
    
    local function updateToggle()
        if isToggled then
            ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        else
            ToggleButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        end
        callback(isToggled)
    end
    
    ToggleButton.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        updateToggle()
    end)
    
    return {Frame = ToggleFrame, SetValue = function(value) isToggled = value updateToggle() end}
end

local function CreateSlider(parent, text, min, max, defaultValue, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = text .. "Slider"
    SliderFrame.Size = UDim2.new(0.9, 0, 0, 50)
    SliderFrame.Position = UDim2.new(0.05, 0, 0, #parent:GetChildren() * 55)
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.Parent = parent
    
    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Name = "SliderLabel"
    SliderLabel.Size = UDim2.new(1, 0, 0, 20)
    SliderLabel.Position = UDim2.new(0, 0, 0, 0)
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Text = text .. ": " .. defaultValue
    SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    SliderLabel.Font = Enum.Font.Gotham
    SliderLabel.TextSize = 12
    SliderLabel.Parent = SliderFrame
    
    local SliderTrack = Instance.new("Frame")
    SliderTrack.Name = "SliderTrack"
    SliderTrack.Size = UDim2.new(1, 0, 0, 5)
    SliderTrack.Position = UDim2.new(0, 0, 0, 25)
    SliderTrack.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    SliderTrack.BorderSizePixel = 0
    SliderTrack.Parent = SliderFrame
    
    local SliderThumb = Instance.new("TextButton")
    SliderThumb.Name = "SliderThumb"
    SliderThumb.Size = UDim2.new(0, 15, 0, 15)
    SliderThumb.Position = UDim2.new((defaultValue - min) / (max - min), -7, 0, 20)
    SliderThumb.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    SliderThumb.BorderSizePixel = 0
    SliderThumb.Text = ""
    SliderThumb.Parent = SliderFrame
    
    local isDragging = false
    
    local function updateSlider(value)
        local normalized = math.clamp((value - min) / (max - min), 0, 1)
        SliderThumb.Position = UDim2.new(normalized, -7, 0, 20)
        SliderLabel.Text = text .. ": " .. value
        callback(value)
    end
    
    SliderThumb.MouseButton1Down:Connect(function()
        isDragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
        end
    end)
    
    SliderTrack.MouseButton1Down:Connect(function(x, y)
        local relativeX = x - SliderTrack.AbsolutePosition.X
        local normalized = math.clamp(relativeX / SliderTrack.AbsoluteSize.X, 0, 1)
        local value = min + normalized * (max - min)
        updateSlider(math.floor(value))
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local relativeX = input.Position.X - SliderTrack.AbsolutePosition.X
            local normalized = math.clamp(relativeX / SliderTrack.AbsoluteSize.X, 0, 1)
            local value = min + normalized * (max - min)
            updateSlider(math.floor(value))
        end
    end)
    
    updateSlider(defaultValue)
    
    return {Frame = SliderFrame, SetValue = updateSlider}
end

local function CreateLabel(parent, text)
    local Label = Instance.new("TextLabel")
    Label.Name = text .. "Label"
    Label.Size = UDim2.new(0.9, 0, 0, 30)
    Label.Position = UDim2.new(0.05, 0, 0, #parent:GetChildren() * 35)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 12
    Label.Parent = parent
    
    return Label
end

local function CreateInput(parent, text, placeholder, callback)
    local InputFrame = Instance.new("Frame")
    InputFrame.Name = text .. "Input"
    InputFrame.Size = UDim2.new(0.9, 0, 0, 40)
    InputFrame.Position = UDim2.new(0.05, 0, 0, #parent:GetChildren() * 45)
    InputFrame.BackgroundTransparency = 1
    InputFrame.Parent = parent
    
    local InputBox = Instance.new("TextBox")
    InputBox.Name = "InputBox"
    InputBox.Size = UDim2.new(1, 0, 0, 30)
    InputBox.Position = UDim2.new(0, 0, 0, 10)
    InputBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    InputBox.BorderSizePixel = 0
    InputBox.PlaceholderText = placeholder
    InputBox.Text = ""
    InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    InputBox.Font = Enum.Font.Gotham
    InputBox.TextSize = 12
    InputBox.Parent = InputFrame
    
    InputBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            callback(InputBox.Text)
        end
    end)
    
    return InputFrame
end

-- Создаем UI и наполняем вкладки
local MainFrame = CreateMainGUI()

-- Вкладка Info
local InfoContent = TabButtons["Info"].Content
local InfoLabel = CreateLabel(InfoContent, "Server Information:")
InfoLabel.TextSize = 14
InfoLabel.Font = Enum.Font.GothamBold

local ServerInfoLabel = CreateLabel(InfoContent, "Loading server info...")

-- Обновление информации о сервере
task.spawn(function()
    while MainGUI and MainGUI.Parent do
        wait(1)
        local info = getServerInfo()
        ServerInfoLabel.Text = string.format(
            "PlaceId: %s\nJobId: %s\nIsStudio: %s\nPlayers: %d/%d",
            info.PlaceId, info.JobId, tostring(info.IsStudio), info.CurrentPlayers, info.MaxPlayers
        )
    end
end)

-- Вкладка Player
local PlayerContent = TabButtons["Player"].Content

-- Noclip
local noclipLoop
local NoclipToggle = CreateToggle(PlayerContent, "Noclip", function(value)
    ActiveNoclip = value
    if noclipLoop then
        noclipLoop:Disconnect()
        noclipLoop = nil
    end
    
    if value then
        noclipLoop = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end)

-- Infinite Jump
local infiniteJumpConnection
local InfiniteJumpToggle = CreateToggle(PlayerContent, "Infinite Jump", function(value)
    ActivateInfiniteJump = value
    if infiniteJumpConnection then
        infiniteJumpConnection:Disconnect()
        infiniteJumpConnection = nil
    end
    
    if value then
        infiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
            if ActivateInfiniteJump then
                LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
            end
        end)
    end
end)

-- Speed
local speedLoop
local SpeedSlider = CreateSlider(PlayerContent, "Walk Speed", 0, 500, 16, function(value)
    ValueSpeed = value
    if speedLoop then
        LocalPlayer.Character.Humanoid.WalkSpeed = ValueSpeed
    end
end)

local SpeedToggle = CreateToggle(PlayerContent, "Modify Walk Speed", function(value)
    if value then
        OldSpeed = LocalPlayer.Character.Humanoid.WalkSpeed
        LocalPlayer.Character.Humanoid.WalkSpeed = ValueSpeed
        speedLoop = RunService.Heartbeat:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = ValueSpeed
            end
        end)
    else
        if speedLoop then
            speedLoop:Disconnect()
            speedLoop = nil
        end
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = OldSpeed
        end
    end
end)

-- Fly
local FlySpeedSlider = CreateSlider(PlayerContent, "Fly Speed", 1, 10, 1, function(value)
    iyflyspeed = value
end)

local FlyToggle = CreateToggle(PlayerContent, "Fly", function(value)
    ActivateFly = value
    if not FLYING and ActivateFly then
        if not AlrActivatedFlyPC then 
            AlrActivatedFlyPC = true
        end
        NOFLY()
        wait()
        sFLY()
    elseif FLYING and not ActivateFly then
        NOFLY()
    end
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.F and ActivateFly then
        if not FLYING then
            NOFLY()
            wait()
            sFLY()
        else
            NOFLY()
        end
    end
end)

-- Instant Prompt
local NoCooldownToggle = CreateToggle(PlayerContent, "Instant Prompt", function(value)
    ActiveNoCooldownPrompt = value
    if ActiveNoCooldownPrompt then
        for _, asset in pairs(workspace:GetDescendants()) do  
            if asset:IsA("ProximityPrompt") and asset.HoldDuration ~= 0 then 
                asset:SetAttribute("HoldDurationOld", asset.HoldDuration)
                asset.HoldDuration = 0
            end 
        end  
    else 
        for _, asset in pairs(workspace:GetDescendants()) do  
            if asset:IsA("ProximityPrompt") and asset:GetAttribute("HoldDurationOld") then 
                asset.HoldDuration = asset:GetAttribute("HoldDurationOld")
            end 
        end  
    end
end)

-- No Fog
local NoFogToggle = CreateToggle(PlayerContent, "No Fog", function(value)
    ActiveNoFog = value
    if ActiveNoFog then
        for _, part in pairs(workspace.Map.Boundaries:GetChildren()) do 
            if part:IsA("Part") then
                part:Destroy()
            end
        end
    end
end)

-- Teleport to Campfire
local TeleportCampfire = CreateButton(PlayerContent, "Teleport to Campfire", function()
    if workspace.Map.Campground.MainFire and workspace.Map.Campground.MainFire.PrimaryPart then
        LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = workspace.Map.Campground.MainFire.PrimaryPart.CFrame + Vector3.new(0,10,0)
    end
end)

-- Вкладка ESP
local EspContent = TabButtons["Esp"].Content

-- Items ESP
local itemsEspLoop
local ItemsEspToggle = CreateToggle(EspContent, "Items ESP", function(value)
    ActiveEspItems = value
    if itemsEspLoop then
        itemsEspLoop:Disconnect()
        itemsEspLoop = nil
    end
    
    if value then
        itemsEspLoop = RunService.Heartbeat:Connect(function()
            for _, obj in pairs(workspace.Items:GetChildren()) do 
                if obj:IsA("Model") and obj.PrimaryPart and not obj:FindFirstChildOfClass("Highlight") and not obj.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
                    CreateEsp(obj, Color3.fromRGB(255,255,0), obj.Name, obj.PrimaryPart) 
                end 
            end
        end)
    else
        for _, obj in pairs(workspace.Items:GetChildren()) do 
            if obj:IsA("Model") and obj.PrimaryPart and obj:FindFirstChildOfClass("Highlight") and obj.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
                KeepEsp(obj, obj.PrimaryPart)
            end 
        end
    end
end)

-- Enemy ESP
local enemyEspLoop
local EnemyEspToggle = CreateToggle(EspContent, "Enemy ESP", function(value)
    ActiveEspEnemy = value
    if enemyEspLoop then
        enemyEspLoop:Disconnect()
        enemyEspLoop = nil
    end
    
    if value then
        enemyEspLoop = RunService.Heartbeat:Connect(function()
            for _, obj in pairs(workspace.Characters:GetChildren()) do 
                if obj:IsA("Model") and obj.PrimaryPart and 
                   (obj.Name ~= "Lost Child" and obj.Name ~= "Lost Child2" and obj.Name ~= "Lost Child3" and obj.Name ~= "Lost Child4" and obj.Name ~= "Pelt Trader") and 
                   not obj:FindFirstChildOfClass("Highlight") and not obj.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
                    CreateEsp(obj, Color3.fromRGB(255,0,0), obj.Name, obj.PrimaryPart) 
                end 
            end
        end)
    else
        for _, obj in pairs(workspace.Characters:GetChildren()) do 
            if obj:IsA("Model") and obj.PrimaryPart and 
               (obj.Name ~= "Lost Child" and obj.Name ~= "Lost Child2" and obj.Name ~= "Lost Child3" and obj.Name ~= "Lost Child4" and obj.Name ~= "Pelt Trader") and 
               obj:FindFirstChildOfClass("Highlight") and obj.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
                KeepEsp(obj, obj.PrimaryPart)
            end 
        end
    end
end)

-- Children ESP
local childrenEspLoop
local ChildrenEspToggle = CreateToggle(EspContent, "Children ESP", function(value)
    ActiveEspChildren = value
    if childrenEspLoop then
        childrenEspLoop:Disconnect()
        childrenEspLoop = nil
    end
    
    if value then
        childrenEspLoop = RunService.Heartbeat:Connect(function()
            for _, obj in pairs(workspace.Characters:GetChildren()) do 
                if obj:IsA("Model") and obj.PrimaryPart and 
                   (obj.Name == "Lost Child" or obj.Name == "Lost Child2" or obj.Name == "Lost Child3" or obj.Name == "Lost Child4") and 
                   not obj:FindFirstChildOfClass("Highlight") and not obj.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
                    CreateEsp(obj, Color3.fromRGB(0,255,0), obj.Name, obj.PrimaryPart) 
                end 
            end
        end)
    else
        for _, obj in pairs(workspace.Characters:GetChildren()) do 
            if obj:IsA("Model") and obj.PrimaryPart and 
               (obj.Name == "Lost Child" or obj.Name == "Lost Child2" or obj.Name == "Lost Child3" or obj.Name == "Lost Child4") and 
               obj:FindFirstChildOfClass("Highlight") and obj.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
                KeepEsp(obj, obj.PrimaryPart)
            end 
        end
    end
end)

-- Pelt Trader ESP
local peltEspLoop
local PeltTraderEspToggle = CreateToggle(EspContent, "Pelt Trader ESP", function(value)
    ActiveEspPeltTrader = value
    if peltEspLoop then
        peltEspLoop:Disconnect()
        peltEspLoop = nil
    end
    
    if value then
        peltEspLoop = RunService.Heartbeat:Connect(function()
            for _, obj in pairs(workspace.Characters:GetChildren()) do 
                if obj:IsA("Model") and obj.PrimaryPart and obj.Name == "Pelt Trader" and 
                   not obj:FindFirstChildOfClass("Highlight") and not obj.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
                    CreateEsp(obj, Color3.fromRGB(0,255,255), obj.Name, obj.PrimaryPart) 
                end 
            end
        end)
    else
        for _, obj in pairs(workspace.Characters:GetChildren()) do 
            if obj:IsA("Model") and obj.PrimaryPart and obj.Name == "Pelt Trader" and 
               obj:FindFirstChildOfClass("Highlight") and obj.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
                KeepEsp(obj, obj.PrimaryPart)
            end 
        end
    end
end)

-- Вкладка Game
local GameContent = TabButtons["Game"].Content

CreateLabel(GameContent, "Note: For Auto Chop Tree and Kill Aura, equip any axe")

-- Kill Aura
local killAuraLoop
local KillAuraDistance = CreateSlider(GameContent, "Kill Aura Distance", 25, 10000, 25, function(value)
    DistanceForKillAura = value
end)

local KillAuraToggle = CreateToggle(GameContent, "Kill Aura", function(value)
    ActiveKillAura = value
    if killAuraLoop then
        killAuraLoop:Disconnect()
        killAuraLoop = nil
    end
    
    if value then
        killAuraLoop = RunService.Heartbeat:Connect(function()
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local hrp = character.HumanoidRootPart
                local weapon = (LocalPlayer.Inventory:FindFirstChild("Old Axe") or 
                               LocalPlayer.Inventory:FindFirstChild("Good Axe") or 
                               LocalPlayer.Inventory:FindFirstChild("Strong Axe") or 
                               LocalPlayer.Inventory:FindFirstChild("Chainsaw"))

                for _, enemy in pairs(workspace.Characters:GetChildren()) do
                    if enemy:IsA("Model") and enemy.PrimaryPart then
                        local distance = (enemy.PrimaryPart.Position - hrp.Position).Magnitude
                        if distance <= DistanceForKillAura and weapon then
                            game:GetService("ReplicatedStorage").RemoteEvents.ToolDamageObject:InvokeServer(enemy, weapon, 999, hrp.CFrame)
                        end
                    end
                end
            end
        end)
    end
end)

-- Auto Chop Tree
local chopTreeLoop
local ChopDistance = CreateSlider(GameContent, "Auto Chop Distance", 0, 1000, 25, function(value)
    DistanceForAutoChopTree = value
end)

local AutoChopToggle = CreateToggle(GameContent, "Auto Chop Tree", function(value)
    ActiveAutoChopTree = value
    if chopTreeLoop then
        chopTreeLoop:Disconnect()
        chopTreeLoop = nil
    end
    
    if value then
        chopTreeLoop = RunService.Heartbeat:Connect(function()
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local hrp = character.HumanoidRootPart
                local weapon = (LocalPlayer.Inventory:FindFirstChild("Old Axe") or 
                               LocalPlayer.Inventory:FindFirstChild("Good Axe") or 
                               LocalPlayer.Inventory:FindFirstChild("Strong Axe") or 
                               LocalPlayer.Inventory:FindFirstChild("Chainsaw"))

                -- Check Foliage
                for _, tree in pairs(workspace.Map.Foliage:GetChildren()) do
                    if tree:IsA("Model") and (tree.Name == "Small Tree" or tree.Name == "TreeBig1" or tree.Name == "TreeBig2") and tree.PrimaryPart then
                        local distance = (tree.PrimaryPart.Position - hrp.Position).Magnitude
                        if distance <= DistanceForAutoChopTree and weapon then
                            game:GetService("ReplicatedStorage").RemoteEvents.ToolDamageObject:InvokeServer(tree, weapon, 999, hrp.CFrame)
                        end
                    end
                end
                
                -- Check Landmarks
                for _, tree in pairs(workspace.Map.Landmarks:GetChildren()) do
                    if tree:IsA("Model") and (tree.Name == "Small Tree" or tree.Name == "TreeBig1" or tree.Name == "TreeBig2") and tree.PrimaryPart then
                        local distance = (tree.PrimaryPart.Position - hrp.Position).Magnitude
                        if distance <= DistanceForAutoChopTree and weapon then
                            game:GetService("ReplicatedStorage").RemoteEvents.ToolDamageObject:InvokeServer(tree, weapon, 999, hrp.CFrame)
                        end
                    end
                end
            end
        end)
    end
end)

-- Вкладка Bring Item
local BringContent = TabButtons["Bring Item"].Content

local function CreateBringButton(text, filter)
    return CreateButton(BringContent, text, function()
        for _, obj in pairs(workspace.Items:GetChildren()) do
            if obj:IsA("Model") and obj.PrimaryPart then
                if type(filter) == "function" then
                    if filter(obj.Name) then
                        DragItem(obj)
                    end
                elseif obj.Name == filter then
                    DragItem(obj)
                end
            end
        end
    end)
end

CreateBringButton("Bring All Items", function(name) return true end)
CreateBringButton("Bring All Logs", "Log")
CreateBringButton("Bring All Coal", "Coal")
CreateBringButton("Bring All Fuel Canister", "Fuel Canister")
CreateBringButton("Bring All Carrot", "Carrot")
CreateBringButton("Bring All Fuel", function(name) 
    return name == "Log" or name == "Fuel Canister" or name == "Coal" or name == "Oil Barrel" 
end)
CreateBringButton("Bring All Scraps", function(name)
    return name == "Tyre" or name == "Sheet Metal" or name == "Broken Fan" or name == "Bolt" or 
           name == "Old Radio" or name == "UFO Junk" or name == "UFO Scrap" or name == "Broken Microwave"
end)
CreateBringButton("Bring All Ammo", function(name)
    return name == "Rifle Ammo" or name == "Revolver Ammo"
end)
CreateBringButton("Bring All Children", function()
    for _, obj in pairs(workspace.Characters:GetChildren()) do
        if (obj.Name == "Lost Child" or obj.Name == "Lost Child2" or obj.Name == "Lost Child3" or obj.Name == "Lost Child4") and obj:IsA("Model") and obj.PrimaryPart then
            DragItem(obj)
        end
    end
end)
CreateBringButton("Bring All Foods", function(name)
    return name == "Cake" or name == "Carrot" or name == "Morsel" or name == "Meat? Sandwich"
end)
CreateBringButton("Bring All Bandage", "Bandage")
CreateBringButton("Bring All Medkit", "MedKit")
CreateBringButton("Bring All Old Radio", "Old Radio")
CreateBringButton("Bring All Tyre", "Tyre")
CreateBringButton("Bring All Broken Fan", "Broken Fan")
CreateBringButton("Bring All Bolt", "Bolt")
CreateBringButton("Bring All Sheet Metal", "Sheet Metal")
CreateBringButton("Bring All Seed Box", "Seed Box")
CreateBringButton("Bring All Chair", "Chair")

-- Кастомный поиск предметов
local customItemInput = CreateInput(BringContent, "Custom Item", "Enter item name", function(text)
    for _, obj in pairs(workspace.Items:GetChildren()) do
        if obj:IsA("Model") and obj.PrimaryPart and obj.Name == text then
            DragItem(obj)
        end
    end
end)

-- Вкладка Discord
local DiscordContent = TabButtons["Discord"].Content

CreateButton(DiscordContent, "Copy Discord Link", function()
    copyToClipboard("https://discord.gg/E2TqYRsRP4")
end)

-- Вкладка Settings
local SettingsContent = TabButtons["Settings"].Content

local DistanceEspToggle = CreateToggle(SettingsContent, "Show Distance on ESP", function(value)
    ActiveDistanceEsp = value
end)

CreateButton(SettingsContent, "Unload Cheat", function()
    MainGUI:Destroy()
end)

print("99 Nights In The Forest - Fixed Custom UI loaded successfully!")