-- Получаем ссылку на локального игрока
local player = game.Players.LocalPlayer
-- Создаем кнопку ESP
local button = Instance.new("TextButton")button.Size = UDim2.new(0, 200, 0, 50)button.Position = UDim2.new(0.5, -100, 0.5, -25)button.Text ="ESP"button.BackgroundColor3 = Color3.new(1, 0, 0) -- Красный цвет
button.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("ScreenGui")local isActive = false

-- Функция для подсветки игроков
local function toggleESP()    local players = game.Players:GetPlayers()    for_, player in ipairs(players) do
        if player ~= game.Players.LocalPlayer then
            if not player.Character or not player.Character:FindFirstChild("Humanoid") then
                -- Убедимся, что персонаж существует
                return
            end
            
            -- Создаем или удаляем подсветку
            local highlight = player.Character:FindFirstChild("Highlight")            if isActive then
                if not highlight then
                    highlight = Instance.new("Highlight")                    highlight.Parent = player.Character
                    highlight.FillColor = Color3.new(0, 1, 0) -- Зеленый цвет
                    highlight.OutlineColor = Color3.new(1, 0, 0) -- Красный цвет
                end
            else
                if highlight then
                    highlight:Destroy()                end
            end
        end
    end
end

-- Функция для обработки нажатия кнопки
button.MouseButton1Click:Connect(function()    isActive = not isActive -- Переключаем состояние активности
    button.BackgroundColor3 = isActive and Color3.new(0, 1, 0) or Color3.new(1, 0, 0) -- Изменяем цвет кнопки
    toggleESP() -- Включаем/выключаем ESP
end)