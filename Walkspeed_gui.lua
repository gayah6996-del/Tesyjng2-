local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local InfiniteJumpEnabled = false
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GameToolsGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 120)
frame.Position = UDim2.new(0.5, -125, 0.5, -60) 
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.Parent = screenGui

local titleLabel = Instance.new("TextLabel") -- название окна
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.Text = "Test"
titleLabel.Font = Enum.Font.Gotham
titleLabel.TextSize = 18
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.Parent = frame

local walkSpeedTextBox = Instance.new("TextBox") -- скрытое поле ввода скорости
walkSpeedTextBox.Size = UDim2.new(0, 80, 0, 30)
walkSpeedTextBox.Position = UDim2.new(0, 10, 0, 50)
walkSpeedTextBox.PlaceholderText = "Set Walk Speed"
walkSpeedTextBox.Text = ""
walkSpeedTextBox.Font = Enum.Font.Gotham
walkSpeedTextBox.TextSize = 14
walkSpeedTextBox.Visible = false -- делаем невидимым сразу
walkSpeedTextBox.Parent = frame

local jumpToggleButton = Instance.new("TextButton") -- кнопка прыжка
jumpToggleButton.Size = UDim2.new(0, 120, 0, 30)
jumpToggleButton.Position = UDim2.new(0, 100, 0, 50)
jumpToggleButton.Text = "Infinite Jump: OFF"
jumpToggleButton.Font = Enum.Font.Gotham
jumpToggleButton.TextSize = 14
jumpToggleButton.Visible = false -- делаем невидимой сразу
jumpToggleButton.Parent = frame

local closeButton = Instance.new("TextButton") -- кнопка закрытия окна
closeButton.Size = UDim2.new(0, 20, 0, 20)
closeButton.Position = UDim2.new(0, 0, 0, 0)
closeButton.Text = "X"
closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 12
closeButton.Visible = false -- делаем невидимой сразу
closeButton.Parent = frame

local reopenButton = Instance.new("TextButton") -- новая кнопка восстановления окна
reopenButton.Size = UDim2.new(0, 100, 0, 40)
reopenButton.Position = UDim2.new(0.5, -50, 0, -10)
reopenButton.Text = "@SFXCL"
reopenButton.Font = Enum.Font.Gotham
reopenButton.TextSize = 19
reopenButton.Visible = false
reopenButton.Parent = screenGui

-- Открытие элементов при клике на надпись "Test"
titleLabel.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        walkSpeedTextBox.Visible = true
        jumpToggleButton.Visible = true
        closeButton.Visible = true
    end
end)

walkSpeedTextBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local speed = tonumber(walkSpeedTextBox.Text)
        if speed and speed > 0 then
            player.Character.Humanoid.WalkSpeed = speed
        else
            warn("Invalid walk speed value!")
        end
    end
end)

jumpToggleButton.MouseButton1Click:Connect(function()
    InfiniteJumpEnabled = not InfiniteJumpEnabled
    jumpToggleButton.Text = "Infinite Jump: " .. (InfiniteJumpEnabled and "ON" or "OFF")
end)

closeButton.MouseButton1Click:Connect(function()
    frame.Visible = false
    reopenButton.Visible = true
end)

reopenButton.MouseButton1Click:Connect(function()
    frame.Visible = true
    reopenButton.Visible = false
end)

local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.JumpRequest:connect(function()
    if InfiniteJumpEnabled then
        player.Character:FindFirstChildWhichIsA("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)