-- Получаем ссылку на локального игрока
local player = game.Players.LocalPlayer

-- Создаем ScreenGui
local screenGui = Instance.new("ScreenGui")screenGui.Parent = player:WaitForChild("PlayerGui")-- Создаем фрейм для меню
local menuFrame = Instance.new("Frame")menuFrame.Size = UDim2.new(0, 300, 0, 200)menuFrame.Position = UDim2.new(0.5, -150, 0.5, -100)menuFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)menuFrame.Parent = screenGui

-- Создаем кнопку
local button = Instance.new("TextButton")button.Size = UDim2.new(1, 0, 0, 50)button.Position = UDim2.new(0, 0, 0.5, -25)button.Text ="Отметить Игроков"button.BackgroundColor3 = Color3.new(1, 0, 0) -- Красный цвет
button.Parent = menuFrame

local isActive = false
local markedPlayers = {} -- Список отмеченных игроков

-- Функция для отметки игроков
local function markPlayers()    for_, otherPlayer in ipairs(game.Players:GetPlayers()) do
        if otherPlayer ~= player then -- Не отмечаем самого себя
            -- Проверяем, если игрок еще не отмечен
            if not markedPlayers[otherPlayer.Name] then
                markedPlayers[otherPlayer.Name] = true
                -- Изменяем цвет персонажа игрока на зелёный
                if otherPlayer.Character and otherPlayer.Character:FindFirstChild("Humanoid") then
                    otherPlayer.Character.Humanoid.BrickColor = BrickColor.new("Bright green")                end
            end
        end
    end
end

-- Функция для обработки нажатия кнопки
button.MouseButton1Click:Connect(function()    isActive = not isActive -- Переключаем состояние активности
    if isActive then
        button.BackgroundColor3 = Color3.new(0, 1, 0) -- Зелёный цвет
        markPlayers() -- Отмечаем игроков
    else
        button.BackgroundColor3 = Color3.new(1, 0, 0) -- Красный цвет
        markedPlayers = {} -- Сбрасываем отмеченных игроков
        -- Возвращаем цвет персонажей игроков к исходному (если это необходимо)        for_, otherPlayer in ipairs(game.Players:GetPlayers()) do
            if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("Humanoid") then
                otherPlayer.Character.Humanoid.BrickColor = BrickColor.new("Bright red") -- Вернуть цвет к красному
            end
        end
    end
end)