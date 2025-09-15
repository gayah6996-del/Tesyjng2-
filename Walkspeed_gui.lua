-- Получаем ссылку на локального игрока
local player = game.Players.LocalPlayer

-- Создаем ScreenGui
local screenGui = Instance.new("ScreenGui")screenGui.Parent = player:WaitForChild("PlayerGui")-- Создаем фрейм для меню
local menuFrame = Instance.new("Frame")menuFrame.Size = UDim2.new(0, 300, 0, 200)menuFrame.Position = UDim2.new(0.5, -150, 0.5, -100)menuFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)menuFrame.Parent = screenGui

-- Создаем кнопку
local button = Instance.new("TextButton")button.Size = UDim2.new(1, 0, 0, 50)button.Position = UDim2.new(0, 0, 0.5, -25)button.Text ="Отметить Брейнроты"button.BackgroundColor3 = Color3.new(1, 0, 0) -- Красный цвет
button.Parent = menuFrame

local isActive = false
local markedBrainrots = {} -- Список отмеченных брейнротов

-- Функция для отметки брейнротов
local function markBrainrot()    local brainrot = game.Workspace:FindFirstChild("Brainrot") -- Предполагается, что брейнрот находится в Workspace
    if brainrot then
        -- Добавляем брейнрот в список отмеченных
        table.insert(markedBrainrots, brainrot)        
        brainrot.BrickColor = BrickColor.new("Bright green") -- Изменяем цвет брейнрота
    end
end

-- Функция для обработки нажатия кнопки
button.MouseButton1Click:Connect(function()    isActive = not isActive -- Переключаем состояние активности
    if isActive then
        button.BackgroundColor3 = Color3.new(0, 1, 0) -- Зелёный цвет
        markBrainrot() -- Отмечаем брейнрот
    else
        button.BackgroundColor3 = Color3.new(1, 0, 0) -- Красный цвет
    end
end)