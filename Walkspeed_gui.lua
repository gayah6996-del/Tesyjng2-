local player = game.Players.LocalPlayer
local mouse = player:GetMouse()local infiniteJumpEnabled = false

-- Создаем GUI
local screenGui = Instance.new("ScreenGui")local jumpButton = Instance.new("TextButton")screenGui.Parent = player:WaitForChild("PlayerGui")jumpButton.Size = UDim2.new(0, 200, 0, 50)jumpButton.Position = UDim2.new(0.5, -100, 0.5, -25)jumpButton.Text ="Infinite Jump"jumpButton.Parent = screenGui

-- Функция для включения/выключения бесконечного прыжка
local function toggleInfiniteJump()	infiniteJumpEnabled = not infiniteJumpEnabled
	
	if infiniteJumpEnabled then
		jumpButton.Text ="Infinite Jump: ON"		player.Character.Humanoid.JumpPower = 50 -- Устанавливаем силу прыжка
		player.Character.Humanoid.StateChanged:Connect(function(_, newState)			if newState == Enum.HumanoidStateType.Freefall and infiniteJumpEnabled then
				player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)			end
		end)	else
		jumpButton.Text ="Infinite Jump: OFF"		player.Character.Humanoid.JumpPower = 50 -- Возвращаем силу прыжка к норме, если нужно
	end
end

-- Привязываем функцию к нажатию кнопки
jumpButton.MouseButton1Click:Connect(toggleInfiniteJump)
end