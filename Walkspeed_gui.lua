local player = game.Players.LocalPlayer
local mouse = player:GetMouse()local infiniteJumpEnabled = false
local speedHackEnabled = false

-- Создаем GUI
local screenGui = Instance.new("ScreenGui")local jumpButton = Instance.new("TextButton")local speedButton = Instance.new("TextButton")screenGui.Parent = player:WaitForChild("PlayerGui")-- Настройки кнопки Infinite Jump
jumpButton.Size = UDim2.new(0, 200, 0, 50)jumpButton.Position = UDim2.new(0.5, -100, 0.5, -75)jumpButton.Text ="Infinite Jump: OFF"jumpButton.Parent = screenGui

-- Настройки кнопки Speed Hack
speedButton.Size = UDim2.new(0, 200, 0, 50)speedButton.Position = UDim2.new(0.5, -100, 0.5, 25)speedButton.Text ="Speed Hack: OFF"speedButton.Parent = screenGui

-- Функция для включения/выключения бесконечного прыжка
toggleInfiniteJump:Connect(function()
local function toggleInfiniteJump()    infiniteJumpEnabled = not infiniteJumpEnabled
    
    if infiniteJumpEnabled then
        jumpButton.Text ="Infinite Jump: ON"        player.Character.Humanoid.JumpPower = 50 -- Устанавливаем силу прыжка
        player.Character.Humanoid.StateChanged:Connect(function(_, newState)            if newState == Enum.HumanoidStateType.Freefall and infiniteJumpEnabled then
                player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)            end
        end)    else
        jumpButton.Text ="Infinite Jump: OFF"        -- Можно вернуть JumpPower к норме, если нужно
    end
end

-- Функция для включения/выключения Speed Hack
toggleSpeedHack.MouseButton1Click:Connect(function()
local function toggleSpeedHack()    speedHackEnabled = not speedHackEnabled

    if speedHackEnabled then
        speedButton.Text ="Speed Hack: ON"        player.Character.Humanoid.WalkSpeed = 50 -- Устанавливаем скорость
    else
        speedButton.Text ="Speed Hack: OFF"        player.Character.Humanoid.WalkSpeed = 16 -- Возвращаем скорость к норме
    end
end