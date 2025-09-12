-- Получаем необходимые сервисы и локального игрока
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Предполагаем, что твой основной фрейм называется "Frame" и находится в ScreenGui.
-- Замени "ScreenGuiName" и "FrameName" на реальные имена твоих объектов в Roblox Studio.
local ScreenGui = LocalPlayer.PlayerGui:WaitForChild("ScreenGuiName") -- Укажи имя твоего ScreenGui
local Frame = ScreenGui:WaitForChild("FrameName") -- Укажи имя твоего основного Frame

-- Переменные для GUI
local FrameWidth = Frame.Size.X.Offset
local FrameHeight = Frame.Size.Y.Offset
-- local CloseButton = Frame:WaitForChild("CloseButton") -- Если есть кнопка закрытия, добавь ее сюда

-- Фрейм, который будет содержать кнопки для переключения табов
local TabsButtonsFrame = Instance.new("Frame")
TabsButtonsFrame.Name = "TabsButtonsFrame"
TabsButtonsFrame.Size = UDim2.new(0, 250, 1, 0) -- Ширина 250, высота 100%
TabsButtonsFrame.Position = UDim2.new(0, 20, 0, 20) -- Позиция в верхнем левом углу
TabsButtonsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- Цвет фона для кнопок
TabsButtonsFrame.Parent = Frame

-- Фрейм, который будет содержать весь контент (по сути, все твои табы)
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentContentFrame.Size = UDim2.new(1, -270, 1, 0) -- Занимает оставшееся пространство
ContentFrame.Position = UDim2.new(0, 250, 0, 20) -- Располагается справа от TabsButtonsFrame
ContentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ContentFrame.Parent = Frame

-- Функция для создания кнопок табов
local function CreateTabButton(name, yPos, associatedContentFrameName)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 40) -- Занимает всю доступную ширину во фрейме кнопок, высота 40
    Button.Position = UDim2.new(0, 0, 0, yPos) -- Позиция зависит от yPos
    Button.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Button.Text = name
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 14
    Button.Font = Enum.Font.Gotham -- Убедись, что шрифт Gotham доступен в твоей игре
    Button.Parent = TabsButtonsFrame

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = Button

    local ButtonGlow = Instance.new("UIStroke")
    ButtonGlow.Color = Color3.fromRGB(255, 0, 0)
    ButtonGlow.Thickness = 1.5
    ButtonGlow.Transparency = 0.5
    ButtonGlow.Parent = Button

    -- Логика для переключения табов
    Button.MouseButton1Click:Connect(function()
        -- Скрываем все контент фреймы
        for _, contentChild in ipairs(ContentFrame:GetChildren()) do
            if contentChild:IsA("Frame") then
                contentChild.Visible = false
            end
        end

        -- Показываем нужный контент фрейм
        local targetContentFrame = ContentFrame:FindFirstChild(associatedContentFrameName)
        if targetContentFrame and targetContentFrame:IsA("Frame") then
            targetContentFrame.Visible = true
        else
            warn("Контент-фрейм '" .. associatedContentFrameName .. "' не найден!")
        end
    end)

    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.3), {Size = UDim2.new(1, 5, 0, 42)}):Play() -- Увеличиваем ширину кнопки
        TweenService:Create(ButtonGlow, TweenInfo.new(0.3), {Transparency = 0}):Play()
    end)
    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 40)}):Play() -- Возвращаем стандартную
ширину
        TweenService:Create(ButtonGlow, TweenInfo.new(0.3), {Transparency = 0.5}):Play()
    end)

    return Button
end

-- Создаем кнопки табов и ассоциируем их с будущими фреймами контента
local SpeedHackTabButton = CreateTabButton("Спидхак", 40, "SpeedHackContent")
local MoneyFarmTabButton = CreateTabButton("Фарм Монет", 90, "MoneyFarmContent")
local PathViewTabButton = CreateTabButton("Path View", 140, "PathViewContent")
local TestTabButton = CreateTabButton("Test", 190, "TestContent") -- Новая кнопка для вкладки "Test"

-- Теперь создадим фреймы для контента каждого таба
-- Фрейм для Speed Hack
local SpeedHackContent = Instance.new("Frame")
SpeedHackContent.Name = "SpeedHackContent"
SpeedHackContent.Size = UDim2.new(1, 0, 1, 0)
SpeedHackContent.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
SpeedHackContent.Visible = false
SpeedHackContent.Parent = ContentFrame

-- Здесь ты можешь добавить кнопки и другие элементы для Speed Hack
-- Пример:
local SpeedSlider = Instance.new("Frame") -- Пример для слайдера скорости
SpeedSlider.Size = UDim2.new(0.8, 0, 0, 50)
SpeedSlider.Position = UDim2.new(0.1, 0, 0.1, 0)
SpeedSlider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SpeedSlider.Parent = SpeedHackContent

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(1, 0, 1, 0)
SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedLabel.TextSize = 16
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.Text = "Скорость: 1x"
SpeedLabel.Parent = SpeedSlider

-- Фрейм для Money Farm
local MoneyFarmContent = Instance.new("Frame")
MoneyFarmContent.Name = "MoneyFarmContent"
MoneyFarmContent.Size = UDim2.new(1, 0, 1, 0)
MoneyFarmContent.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MoneyFarmContent.Visible = false
MoneyFarmContent.Parent = ContentFrame

-- Кнопка активации/деактивации Money Farm
local MoneyFarmToggle = Instance.new("TextButton")
MoneyFarmToggle.Size = UDim2.new(0, 180, 0, 35)
MoneyFarmToggle.Position = UDim2.new(0.5, -90, 0.1, 0) -- По центру
MoneyFarmToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MoneyFarmToggle.Text = "Включить Фарм Монет"
MoneyFarmToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
MoneyFarmToggle.TextSize = 14
MoneyFarmToggle.Font = Enum.Font.Gotham
MoneyFarmToggle.Parent = MoneyFarmContent

-- Фрейм для Path View
local PathViewContent = Instance.new("Frame")
PathViewContent.Name = "PathViewContent"
PathViewContent.Size = UDim2.new(1, 0, 1, 0)
PathViewContent.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
PathViewContent.Visible = false
PathViewContent.Parent = ContentFrame

-- *** НОВЫЙ ФРЕЙМ ДЛЯ ВКЛАДКИ "TEST" ***
local TestContent = Instance.new("Frame")
TestContent.Name = "TestContent" -- Имя должно совпадать с переданным в CreateTabButton
TestContent.Size = UDim2.new(1, 0, 1, 0)
TestContent.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TestContent.Visible = false -- Скрыт по умолчанию
TestContent.Parent = ContentFrame

-- Пример элементов для вкладки "Test"
local TestLabel = Instance.new("TextLabel")
TestLabel.Size = UDim2.new(0.8, 0, 0.2, 0)
TestLabel.Position = UDim2.new(0.1, 0, 0.1, 0)
TestLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TestLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TestLabel.TextSize = 20
TestLabel.Font = Enum.Font.Gotham
TestLabel.Text = "Это тестовая вкладка!"
TestLabel.Parent = TestContent

local TestButton = Instance.new("TextButton")
TestButton.Size = UDim2.new(0.6, 0, 0.2, 0)
TestButton.Position = UDim2.new(0.2, 0, 0.4, 0)
TestButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TestButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TestButton.TextSize = 16
TestButton.Font = Enum.Font.Gotham
TestButton.Text = "Нажми меня!"
TestButton.Parent = TestContent

-- Подключение действия для кнопки Test
TestButton.MouseButton1Click:Connect(function()
    print("Кнопка на тестовой вкладке была нажата!")
    -- Здесь можно добавить любое действие, которое должно происходить при нажатии
end)


-- Draggable GUI (твой код для перетаскивания)
local
dragging = false
local dragInput = nil
local dragStart = nil
local startPos = nil

local function update(input)
    if dragging then
        local delta = input.Position - dragStart
        Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end

Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        -- Проверяем, что мы не кликнули по кнопке таба или другой интерактивной элементу, который не должен двигать фрейм
        if not (input.Instance:IsA("TextButton") or input.Instance:IsA("ImageButton")) then
            dragging = true
            dragStart = input.Position
            startPos = Frame.Position
        end
    end
end)

Frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
        dragInput = nil
    end
end)

Frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Variables для логики
local MoneyFarmActive = false
local SpeedActive = false
local SpeedValue = 1 -- Нужно будет установить значение из слайдера/ввода
local PathViewActive = false

-- Money Farm Function
local function MoneyFarm()
    while MoneyFarmActive do
        local character = LocalPlayer.Character
        local dropsFolder = Workspace:FindFirstChild("Drops")
        if character and character:FindFirstChild("HumanoidRootPart") and dropsFolder then
            for _, drop in pairs(dropsFolder:GetChildren()) do
                if drop.Name == "CashDrop" and MoneyFarmActive then -- Проверяем MoneyFarmActive внутри цикла
                    if drop:IsA("Model") then
                        if drop.PrimaryPart then
                            character.HumanoidRootPart.CFrame = drop.PrimaryPart.CFrame + Vector3.new(0, 3, 0)
                        else
                            local firstPart = drop:FindFirstChildWhichIsA("BasePart")
                            if firstPart then
                                character.HumanoidRootPart.CFrame = firstPart.CFrame + Vector3.new(0, 3, 0)
                            end
                        end
                    elseif drop:IsA("BasePart") then
                        character.HumanoidRootPart.CFrame = drop.CFrame + Vector3.new(0, 3, 0)
                    end
                    task.wait(0.2)
                end
            end
        else
            warn("Drops folder not found or character not loaded.")
            task.wait(1) -- Ждем, если что-то не загрузилось
        end
        task.wait(0.5)
    end
end

-- Speed Hack Logic
local function UpdateSpeed()
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")

    if humanoid then
        if SpeedActive then
            humanoid.WalkSpeed = 16 * SpeedValue -- Скорость по умолчанию в Roblox 16
        else
            humanoid.WalkSpeed = 16 -- Сбрасываем на стандартную скорость
        end
    end
end

-- Подключение логики для Money Farm Toggle Button
MoneyFarmToggle.MouseButton1Click:Connect(function()
    MoneyFarmActive = not MoneyFarmActive
    if MoneyFarmActive then
        MoneyFarmToggle.Text = "Выключить Фарм Монет"
        MoneyFarmToggle.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- Зеленый цвет, когда активно
        coroutine.wrap(MoneyFarm)() -- Запускаем MoneyFarm в корутине, чтобы не блокировать скрипт
    else
        MoneyFarmToggle.Text = "Включить Фарм Монет"
        MoneyFarmToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40) -- Стандартный
цвет
    end
end)

-- Подключение логики для Speed Hack Tab Button
SpeedHackTabButton.MouseButton1Click:Connect(function()
    SpeedActive = not SpeedActive
    if SpeedActive then
        SpeedHackTabButton.Text = "Спидхак: ON"
        -- Здесь тебе нужно будет получить значение SpeedValue (например, из слайдера)
        -- SpeedValue = 2 -- Пример установки скорости
        UpdateSpeed()
    else
        SpeedHackTabButton.Text = "Спидхак: OFF"
        UpdateSpeed()
    end
end)

-- Подключение логики для Path View Tab Button
PathViewTabButton.MouseButton1Click:Connect(function()
    PathViewActive = not PathViewActive
    if PathViewActive then
        PathViewTabButton.Text = "Path View: ON"
        -- Здесь будет логика для Path View
    else
        PathViewTabButton.Text = "Path View: OFF"
        -- Здесь будет логика для деактивации Path View
    end
end)

-- Инициализация: показываем первый таб при запуске
-- Имитируем клик по первой кнопке таба, чтобы показать ее содержимое
if #TabsButtonsFrame:GetChildren() &gt; 0 then
    local firstTabButton = TabsButtonsFrame:GetChildren()[1]
    if firstTabButton and (firstTabButton:IsA("TextButton") or firstTabButton:IsA("ImageButton")) then
        firstTabButton:Click()
    end
end
