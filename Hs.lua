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

-- Таблицы с локализованными текстовыми элементами (Buttons with localized text elements)
local SpeedMultiPlayer = CreateButton("Спидхак", 40)
local MoneyFarmButton = CreateButton("Фарм Монет", 90)
local PathViewButton = CreateButton("Path View", 140)

-- Draggable GUI (Перетаскиваемый GUI)
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

-- Variables (Переменные)
local MoneyFarmActive = false
local speedHackActive = false -- Состояние спидхака
local speedMultiplier = 2     -- Множитель скорости

-- Money Farm Function (Функция фарма монет)
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

-- Speed Hack Function (Функция спидхака)
local function applySpeedHack(speed)
    local character = LocalPlayer.Character
    if character and character.Humanoid then
        character.Humanoid.WalkSpeed = 16 * speed -- Стандартная скорость ходьбы Roblox - 16. Умножаем на множитель.
        character.Humanoid.RunSpeed = 16 * speed   -- Скорость бега тоже меняем
        -- character.Humanoid.JumpPower = 50 * speed -- Можно и мощность прыжка увеличить, если нужно
    end
end

-- Connect to Heartbeat to keep the speed hack active
local function startSpeedHack()
    if speedHackActive then
        RunService.Heartbeat:Connect(function()
            applySpeedHack(speedMultiplier)
        end)
    end
end

-- Connect to Heartbeat to keep the speed hack active
local function stopSpeedHack()
  for _, connection in pairs(RunService.Heartbeat:GetConnections()) do
    if connection.Function == applySpeedHack then
      connection:Disconnect()
    end
  end
end


-- Button Actions (Действия для кнопок)
SpeedMultiPlayer.MouseButton1Click:Connect(function()
    speedHackActive = not speedHackActive
    if speedHackActive then
        SpeedMultiPlayer.Text = "Спидхак: ON"
        startSpeedHack()
    else
        SpeedMultiPlayer.Text = "Спидхак: OFF"
        stopSpeedHack()
    end
end)

MoneyFarmButton.MouseButton1Click:Connect(function()
    MoneyFarmActive = not MoneyFarmActive
    if MoneyFarmActive then
        MoneyFarmButton.Text = "Фарм Монет: ON"
        coroutine.wrap(MoneyFarm)() -- Запускаем фарм в сопрограмме, чтобы не блокировать основной поток.
    else
        MoneyFarmButton.Text = "Фарм Монет: OFF"
    end
end)

PathViewButton.MouseButton1Click:Connect(function()
    -- Add path view functionality here (TODO)
    print("Path View functionality not implemented yet.")
end)
