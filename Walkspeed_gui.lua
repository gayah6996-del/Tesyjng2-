local player = game.Players.LocalPlayer
local mouse = player:GetMouse()local infiniteJumpEnabled = false
local speedHackEnabled = false

-- Создаем GUI
local screenGui = Instance.new("ScreenGui")local jumpButton = Instance.new("TextButton")local speedButton = Instance.new("TextButton")screenGui.Parent = player:WaitForChild("PlayerGui")-- Настройки кнопки Infinite Jump
local ChangeStateButton = Instance.new("TextButton")
ChangeStateButton.Size = UDim2.new(0, 200, 0, 50)
ChangeStateButton.Position = UDim2.new(0.5, -100, 0.5, -75)
ChangeStateButton.Text = "Infinity Jump: Off"
ChangeStateButton.Font = Enum.Font.Gotham
ChangeStateButton.TextSize = 14
ChangeStateButton.Parent = frame

ChangeStateButton.MouseButton1Click:Connect(function()
    InfiniteJumpEnabled = not InfiniteJumpEnabled -- переключаем состояние прыжка
    
    if InfiniteJumpEnabled then
        ChangeStateButton.Text = "Infinity Jump: On"
    else
        ChangeStateButton.Text = "Infinity Jump: Off"
    end
end)