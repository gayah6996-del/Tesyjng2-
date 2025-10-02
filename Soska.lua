local button = script.Parent
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()local humanoid = character:WaitForChild("Humanoid")-- Изначальная скорость
local defaultWalkSpeed = humanoid.WalkSpeed
local increasedSpeed = 100 -- Увеличенная скорость

button.MouseButton1Click:Connect(function()    if humanoid.WalkSpeed == defaultWalkSpeed then
        humanoid.WalkSpeed = increasedSpeed
        button.Text ="Сбросить скорость" -- Изменяем текст кнопки
    else
        humanoid.WalkSpeed = defaultWalkSpeed
        button.Text ="Увеличить скорость" -- Изменяем текст кнопки обратно
    end
  end)
