local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Создание GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AimMenu"
screenGui.Parent = player.PlayerGui

-- Основной фрейм меню
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Крестик закрытия
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.Parent = mainFrame

-- Кнопка открытия меню (скрыта изначально)
local openButton = Instance.new("TextButton")
openButton.Size = UDim2.new(0, 50, 0, 50)
openButton.Position = UDim2.new(1, -60, 0, 10)
openButton.BackgroundColor3 = Color3.fromRGB(60, 60, 255)
openButton.Text = "Menu"
openButton.TextColor3 = Color3.new(1, 1, 1)
openButton.Visible = false
openButton.Parent = screenGui

-- Кнопка BulletTrack
local trackButton = Instance.new("TextButton")
trackButton.Size = UDim2.new(0, 200, 0, 50)
trackButton.Position = UDim2.new(0.5, -100, 0.2, 0)
trackButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
trackButton.Text = "BulletTrack: OFF"
trackButton.TextColor3 = Color3.new(1, 1, 1)
trackButton.Parent = mainFrame

-- Слайдер для размера круга
local sliderFrame = Instance.new("Frame")
sliderFrame.Size = UDim2.new(0, 200, 0, 30)
sliderFrame.Position = UDim2.new(0.5, -100, 0.6, 0)
sliderFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
sliderFrame.Parent = mainFrame

local sliderText = Instance.new("TextLabel")
sliderText.Size = UDim2.new(1, 0, 1, 0)
sliderText.BackgroundTransparency = 1
sliderText.Text = "Circle Size: 50"
sliderText.TextColor3 = Color3.new(1, 1, 1)
sliderText.Parent = sliderFrame

-- Круг прицела
local aimCircle = Instance.new("Frame")
aimCircle.Size = UDim2.new(0, 50, 0, 50)
aimCircle.Position = UDim2.new(0.5, -25, 0.5, -25)
aimCircle.BackgroundTransparency = 0.7
aimCircle.BackgroundColor3 = Color3.new(1, 1, 1)
aimCircle.Visible = false
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1, 0)
corner.Parent = aimCircle
aimCircle.Parent = screenGui

-- Переменные
local trackEnabled = false
local circleSize = 50
local connection

-- Функция для поиска цели в круге
function findTargetInCircle()
    local character = player.Character
    if not character then return nil end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return nil end
    
    local circleCenter = Vector2.new(
        aimCircle.AbsolutePosition.X + aimCircle.AbsoluteSize.X / 2,
        aimCircle.AbsolutePosition.Y + aimCircle.AbsoluteSize.Y / 2
    )
    local circleRadius = aimCircle.AbsoluteSize.X / 2
    
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local targetRoot = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                local targetPos = targetRoot.Position
                local screenPos, visible = workspace.CurrentCamera:WorldToScreenPoint(targetPos)
                
                if visible then
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - circleCenter).Magnitude
                    if distance <= circleRadius then
                        return otherPlayer.Character
                    end
                end
            end
        end
    end
    return nil
end

-- Функция для перенаправления пуль
function redirectBullets()
    if trackEnabled then
        local target = findTargetInCircle()
        if target then
            -- Здесь должна быть логика перенаправления пуль
            -- Это зависит от конкретного оружия в игре
            print("Target found: " .. target.Name)
        end
    end
end

-- Обработчики событий
trackButton.MouseButton1Click:Connect(function()
    trackEnabled = not trackEnabled
    aimCircle.Visible = trackEnabled
    
    if trackEnabled then
        trackButton.Text = "BulletTrack: ON"
        trackButton.BackgroundColor3 = Color3.fromRGB(60, 255, 60)
        
        -- Запускаем проверку целей
        if connection then
            connection:Disconnect()
        end
        connection = RunService.Heartbeat:Connect(redirectBullets)
        
    else
        trackButton.Text = "BulletTrack: OFF"
        trackButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        
        if connection then
            connection:Disconnect()
            connection = nil
        end
    end
end)

closeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    openButton.Visible = true
end)

openButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    openButton.Visible = false
end)

-- Обработка слайдера
sliderFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        local connection
        connection = RunService.Heartbeat:Connect(function()
            local mouseLocation = UserInputService:GetMouseLocation()
            local relativeX = math.clamp((mouseLocation.X - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X, 0, 1)
            
            circleSize = 20 + math.floor(relativeX * 100)
            aimCircle.Size = UDim2.new(0, circleSize, 0, circleSize)
            aimCircle.Position = UDim2.new(0.5, -circleSize/2, 0.5, -circleSize/2)
            sliderText.Text = "Circle Size: " .. circleSize
        end)
        
        local function endDrag()
            if connection then
                connection:Disconnect()
            end
        end
        
        sliderFrame.InputEnded:Connect(endDrag)
        UserInputService.InputEnded:Connect(endDrag)
    end
end)

print("Aim menu loaded! Use the menu button to open/close.")