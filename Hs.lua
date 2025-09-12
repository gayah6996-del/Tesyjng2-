-- Получаем необходимые сервисы и локального игрока
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- !!! ВАЖНО: Замени "YourScreenGuiName" и "YourFrameName" на реальные имена ваших объектов !!!
local SCREEN_GUI_NAME = "YourScreenGuiName" -- Например, "MainMenuGui"
local MAIN_FRAME_NAME = "YourFrameName"   -- Например, "MenuContainer"

local ScreenGui = LocalPlayer.PlayerGui:WaitForChild(SCREEN_GUI_NAME)
local Frame = ScreenGui:WaitForChild(MAIN_FRAME_NAME)

-- Проверка, что объекты найдены
if not ScreenGui or not Frame then
    warn("Ошибка: ScreenGui или Frame не найдены. Убедитесь, что имена '" .. SCREEN_GUI_NAME .. "' и '" .. MAIN_FRAME_NAME .. "' указаны верно.")
    return -- Прерываем выполнение скрипта, если объекты не найдены
end

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
ContentFrame.Size = UDim2.new(1, -270, 1, 0) -- Занимает оставшееся пространство (100% ширины минус ширина TabsButtonsFrame, плюс небольшой отступ)
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
        TweenService:Create(Button, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0,
40)}):Play() -- Возвращаем стандартную ширину
        TweenService:Create(ButtonGlow, TweenInfo.new(0.3), {Transparency = 0.5}):Play()
    end)

    return Button
end

-- *** СОЗДАНИЕ КНОПОК ДЛЯ ТАБОВ ***
local SpeedHackTabButton = CreateTabButton("Спидхак", 40, "SpeedHackContent")
local MoneyFarmTabButton = CreateTabButton("Фарм Монет", 90, "MoneyFarmContent")
local PathViewTabButton = CreateTabButton("Path View", 140, "PathViewContent")
-- ДОБАВЛЕНА НОВАЯ КНОПКА ТАБА
local NewTab1Button = CreateTabButton("Таб 1", 190, "NewTab1Content")
local NewTab2Button = CreateTabButton("Таб 2", 240, "NewTab2Content")
local NewTab3Button = CreateTabButton("Таб 3", 290, "NewTab3Content")


-- *** СОЗДАНИЕ ФРЕЙМОВ СОДЕРЖИМОГО ДЛЯ КАЖДОГО ТАБА ***

-- Фрейм для Speed Hack (существующий)
local SpeedHackContent = Instance.new("Frame")
SpeedHackContent.Name = "SpeedHackContent"
SpeedHackContent.Size = UDim2.new(1, 0, 1, 0)
SpeedHackContent.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
SpeedHackContent.Visible = false
SpeedHackContent.Parent = ContentFrame
-- Здесь могут быть элементы для Speed Hack

-- Фрейм для Money Farm (существующий)
local MoneyFarmContent = Instance.new("Frame")
MoneyFarmContent.Name = "MoneyFarmContent"
MoneyFarmContent.Size = UDim2.new(1, 0, 1, 0)
MoneyFarmContent.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MoneyFarmContent.Visible = false
MoneyFarmContent.Parent = ContentFrame
-- Здесь могут быть элементы для Money Farm

-- Фрейм для Path View (существующий)
local PathViewContent = Instance.new("Frame")
PathViewContent.Name = "PathViewContent"
PathViewContent.Size = UDim2.new(1, 0, 1, 0)
PathViewContent.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
PathViewContent.Visible = false
PathViewContent.Parent = ContentFrame
-- Здесь могут быть элементы для Path View

-- *** НОВЫЕ ФРЕЙМЫ СОДЕРЖИМОГО ДЛЯ НОВЫХ ТАБОВ ***

-- Фрейм для Таба 1
local NewTab1Content = Instance.new("Frame")
NewTab1Content.Name = "NewTab1Content" -- Имя должно совпадать с переданным в CreateTabButton
NewTab1Content.Size = UDim2.new(1, 0, 1, 0)
NewTab1Content.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
NewTab1Content.Visible = false -- Скрыт по умолчанию
NewTab1Content.Parent = ContentFrame
-- Пример элементов для Таба 1:
local Tab1Label = Instance.new("TextLabel")
Tab1Label.Size = UDim2.new(0.8, 0, 0.2, 0)
Tab1Label.Position = UDim2.new(0.1, 0, 0.1, 0)
Tab1Label.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Tab1Label.TextColor3 = Color3.fromRGB(255, 255, 255)
Tab1Label.TextSize = 20
Tab1Label.Font = Enum.Font.Gotham
Tab1Label.Text = "Содержимое Таба 1"
Tab1Label.Parent = NewTab1Content

-- Фрейм для Таба 2
local NewTab2Content = Instance.new("Frame")
NewTab2Content.Name = "NewTab2Content"
NewTab2Content.Size = UDim2.new(1, 0, 1, 0)
NewTab2Content.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
NewTab2Content.Visible = false
NewTab2Content.Parent = ContentFrame
-- Пример элементов для Таба 2:
local Tab2Button = Instance.new("TextButton")
Tab2Button.Size = UDim2.new(0.6, 0, 0.2, 0)
Tab2Button.Position = UDim2.new(0.2, 0, 0.4, 0)
Tab2Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Tab2Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Tab2Button.TextSize = 16
Tab2Button.Font = Enum.Font.Gotham
Tab2Button.Text = "Действие Таба 2"
Tab2Button.Parent = NewTab2Content
Tab2Button.MouseButton1Click:Connect(function()
    print("Кнопка на Табе 2 была нажата!")
end)

-- Фрейм для Таба 3
local NewTab3Content = Instance.new("Frame")
NewTab3Content.Name = "NewTab3Content"
NewTab3Content.Size = UDim2.new(1, 0, 1, 0)
NewTab3Content.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
NewTab3Content.Visible = false
NewTab3Content.Parent = ContentFrame
-- Пример элементов для Таба 3:
local Tab3Label = Instance.new("TextLabel")
Tab3Label.Size = UDim2.new(0.9, 0, 0.15, 0)
Tab3Label.Position = UDim2.new(0.05, 0, 0.2, 0)
Tab3Label.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Tab3Label.TextColor3 = Color3.fromRGB(200, 200, 200)
Tab3Label.TextSize = 15
Tab3Label.Font =
Enum.Font.Arial
Tab3Label.Text = "Простой текст для Таба 3"
Tab3Label.Parent = NewTab3Content


-- Draggable GUI (ОСТАВЛЯЕМ ВАШ СУЩЕСТВУЮЩИЙ КОД ДЛЯ ПЕРЕТАСКИВАНИЯ)
local dragging = false
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

-- Variables для логики (ОСТАВЛЯЕМ СУЩЕСТВУЮЩИЕ)
local MoneyFarmActive = false
local SpeedActive = false
local SpeedValue = 1 -- Нужно будет установить значение из слайдера/ввода
local PathViewActive = false

-- Money Farm Function (ОСТАВЛЯЕМ СУЩЕСТВУЮЩУЮ)
local function MoneyFarm()
    while MoneyFarmActive do
        local character = LocalPlayer.Character
        local dropsFolder = Workspace:FindFirstChild("Drops")
        if character and character:FindFirstChild("HumanoidRootPart") and dropsFolder then
            for _, drop in pairs(dropsFolder:GetChildren()) do
                if drop.Name == "CashDrop" and MoneyFarmActive then
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
            task.wait(1)
        end
        task.wait(0.5)
    end
end

-- Speed Hack Logic (ОСТАВЛЯЕМ СУЩЕСТВУЮЩУЮ)
local function UpdateSpeed()
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")

    if humanoid then
        if SpeedActive then
            humanoid.WalkSpeed = 16 * SpeedValue
        else
            humanoid.WalkSpeed = 16
        end
    end
end

-- Подключение логики для Money Farm Toggle Button (ОСТАВЛЯЕМ СУЩЕСТВУЮЩУЮ)
MoneyFarmToggle.MouseButton1Click:Connect(function()
    MoneyFarmActive = not MoneyFarmActive
    if MoneyFarmActive then
        MoneyFarmToggle.Text = "Выключить Фарм Монет"
        MoneyFarmToggle.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        coroutine.wrap(MoneyFarm)()
    else
        MoneyFarmToggle.Text = "Включить Фарм Монет"
        MoneyFarmToggle.BackgroundColor3 = Color3.fromRGB(40, 40,
40)
    end
end)

-- Подключение логики для Speed Hack Tab Button (ОСТАВЛЯЕМ СУЩЕСТВУЮЩУЮ)
SpeedHackTabButton.MouseButton1Click:Connect(function()
    SpeedActive = not SpeedActive
    if SpeedActive then
        SpeedHackTabButton.Text = "Спидхак: ON"
        -- SpeedValue = 2 -- Установите значение для SpeedValue
        UpdateSpeed()
    else
        SpeedHackTabButton.Text = "Спидхак: OFF"
        UpdateSpeed()
    end
end)

-- Подключение логики для Path View Tab Button (ОСТАВЛЯЕМ СУЩЕСТВУЮЩУЮ)
PathViewTabButton.MouseButton1Click:Connect(function()
    PathViewActive = not PathViewActive
    if PathViewActive then
        PathViewTabButton.Text = "Path View: ON"
        -- Логика для Path View
    else
        PathViewTabButton.Text = "Path View: OFF"
        -- Логика для деактивации Path View
    end
end)

-- Инициализация: показываем первый таб при запуске
-- Убедимся, что TabsButtonsFrame существует и имеет дочерние элементы
if TabsButtonsFrame and #TabsButtonsFrame:GetChildren() &gt; 0 then
    local firstTabButton = TabsButtonsFrame:GetChildren()[1]
    if firstTabButton and (firstTabButton:IsA("TextButton") or firstTabButton:IsA("ImageButton")) then
        firstTabButton:Click()
    end
else
    warn("TabsButtonsFrame пуст или не существует. Невозможно показать первый таб.")
end
