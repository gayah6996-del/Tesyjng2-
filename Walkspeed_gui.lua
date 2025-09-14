local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")local character = player.Character or player.CharacterAdded:Wait()local humanoid = character:WaitForChild("Humanoid")local infiniteJumpEnabled = false
local speedHackEnabled = false

-- Создаем GUI
local screenGui = Instance.new("ScreenGui")local jumpButton = Instance.new("TextButton")local speedButton = Instance.new("TextButton")screenGui.Parent = playerGui

-- Настройки кнопки Infinite Jump
jumpButton.Size = UDim2.new(0, 200, 0, 50)jumpButton.Position = UDim2.new(0.5, -100, 0.5, -75)jumpButton.Text ="Infinite Jump: OFF"jumpButton.Parent = screenGui

-- Настройки кнопки Speed Hack
speedButton.Size = UDim2.new(0, 200, 0, 50)speedButton.Position = UDim2.new(0.5, -100, 0.5, 25)speedButton.Text ="Speed Hack: OFF"speedButton.Parent = screenGui

-- Настройки кнопки закрытия
closeButton.Size = UDim2.new(0, 100, 0, 50)closeButton.Position = UDim2.new(0.5, -50, 0.5, 100)closeButton.Text ="Close"closeButton.Parent = screenGui

-- Привязываем функции к нажатию кнопок
jumpButton.MouseButton1Click:Connect(function()    infiniteJumpEnabled = not infiniteJumpEnabled

    if infiniteJumpEnabled then
        jumpButton.Text ="Infinite Jump: ON"        humanoid.JumpPower = 50 -- Устанавливаем силу прыжка
        humanoid.StateChanged:Connect(function(_, newState)            if newState == Enum.HumanoidStateType.Freefall and infiniteJumpEnabled then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)            end
        end)    else
        jumpButton.Text ="Infinite Jump: OFF"    end
end)speedButton.MouseButton1Click:Connect(function()    speedHackEnabled = not speedHackEnabled

    if speedHackEnabled then
        speedButton.Text ="Speed Hack: ON"        humanoid.WalkSpeed = 100 -- Устанавливаем скорость
    else
        speedButton.Text ="Speed Hack: OFF"        humanoid.WalkSpeed = 16 -- Возвращаем скорость к норме
    end
end)
userInputService.InputBegan:Connect(function(input, gameProcessed)    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Space then
        onJumpRequest()    end
end)-- Закрытие GUI
closeButton.MouseButton1Click:Connect(function()    screenGui:Destroy() -- Удаляем GUI
end)