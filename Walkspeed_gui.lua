local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")local userInputService = game:GetService("UserInputService")-- Укажите здесь местоположение костра
local campfirePosition = Vector3.new(0, 0, 0) -- Замените на реальные координаты костра

-- Создаем GUI
local screenGui = Instance.new("ScreenGui")local openChestsButton = Instance.new("TextButton")screenGui.Parent = playerGui

-- Настройки кнопки открытия сундуков
openChestsButton.Size = UDim2.new(0, 200, 0, 50)openChestsButton.Position = UDim2.new(0.5, -100, 0.5, -75)openChestsButton.Text ="Open All Chests"openChestsButton.Parent = screenGui

-- Функция для открытия всех сундуков
local function openAllChests()    for_, chest in pairs(workspace:GetChildren()) do
        if chest:IsA("Model") and chest:FindFirstChild("Open") then
            -- Предполагаем, что у сундука есть объект"Open", который нужно вызвать
            local openFunction = chest:FindFirstChild("Open")            if openFunction:IsA("RemoteEvent") then
                openFunction:Fire() -- Вызов функции открытия сундука
            end
            
            wait(0.5) -- Небольшая задержка, чтобы не перегружать игру
            
            for_, item in pairs(chest:GetChildren()) do
                if item:IsA("BasePart") then
                    -- Перемещаем содержимое на костер
                    local newItem = item:Clone()                    newItem.Position = campfirePosition + Vector3.new(0, 2, 0) -- Поднимаем над костром
                    newItem.Parent = workspace
                    item:Destroy() -- Удаляем оригинал из сундука
                end
            end
        end
    end
end

-- Привязываем функцию к нажатию кнопки
openChestsButton.MouseButton1Click:Connect(function()    openAllChests() -- Вызываем функцию открытия сундуков
end)