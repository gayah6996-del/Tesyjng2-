-- SANSTRO MM2 Halloween Script FIXED
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Создаем основной GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SANSTROMM2_HALLOWEEN"
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Главный фрейм
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 400, 0, 500)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(47, 0, 82)
MainFrame.BorderColor3 = Color3.fromRGB(255, 140, 0)
MainFrame.BorderSizePixel = 3
MainFrame.BackgroundTransparency = 0.1
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Верхняя панель
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 50)
TopBar.BackgroundColor3 = Color3.fromRGB(106, 13, 173)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0.6, 0, 1, 0)
Title.Position = UDim2.new(0.05, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "SANSTRO MM2"
Title.TextColor3 = Color3.fromRGB(255, 215, 0)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
Title.TextStrokeTransparency = 0.3
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Кнопка закрытия
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 35, 0, 35)
CloseButton.Position = UDim2.new(0.9, 0, 0.15, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(220, 20, 60)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextScaled = true
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = TopBar

-- Кнопка скрытия
local HideButton = Instance.new("TextButton")
HideButton.Name = "HideButton"
HideButton.Size = UDim2.new(0, 35, 0, 35)
HideButton.Position = UDim2.new(0.8, 0, 0.15, 0)
HideButton.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
HideButton.BorderSizePixel = 0
HideButton.Text = "_"
HideButton.TextColor3 = Color3.fromRGB(255, 255, 255)
HideButton.TextScaled = true
HideButton.Font = Enum.Font.GothamBold
HideButton.Parent = TopBar

-- Кнопка открытия
local OpenButton = Instance.new("TextButton")
OpenButton.Name = "OpenButton"
OpenButton.Size = UDim2.new(0, 70, 0, 70)
OpenButton.Position = UDim2.new(0, 20, 0, 20)
OpenButton.BackgroundColor3 = Color3.fromRGB(106, 13, 173)
OpenButton.BorderColor3 = Color3.fromRGB(255, 140, 0)
OpenButton.BorderSizePixel = 2
OpenButton.Text = "MENU"
OpenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenButton.TextScaled = true
OpenButton.Font = Enum.Font.GothamBold
OpenButton.Visible = false
OpenButton.Parent = ScreenGui

-- Основной контейнер для контента
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -20, 1, -70)
ContentFrame.Position = UDim2.new(0, 10, 0, 60)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Секция Farm Candies
local FarmSection = Instance.new("Frame")
FarmSection.Name = "FarmSection"
FarmSection.Size = UDim2.new(1, 0, 0, 250)
FarmSection.Position = UDim2.new(0, 0, 0, 10)
FarmSection.BackgroundColor3 = Color3.fromRGB(65, 0, 110)
FarmSection.BorderColor3 = Color3.fromRGB(148, 0, 211)
FarmSection.BorderSizePixel = 2
FarmSection.Parent = ContentFrame

local FarmTitle = Instance.new("TextLabel")
FarmTitle.Name = "FarmTitle"
FarmTitle.Size = UDim2.new(1, 0, 0, 40)
FarmTitle.BackgroundColor3 = Color3.fromRGB(106, 13, 173)
FarmTitle.BorderSizePixel = 0
FarmTitle.Text = "🎃 Farm Candies 🎃"
FarmTitle.TextColor3 = Color3.fromRGB(255, 215, 0)
FarmTitle.TextScaled = true
FarmTitle.Font = Enum.Font.GothamBold
FarmTitle.Parent = FarmSection

-- Кнопка AutoFarm
local AutoFarmToggle = Instance.new("TextButton")
AutoFarmToggle.Name = "AutoFarmToggle"
AutoFarmToggle.Size = UDim2.new(0.9, 0, 0, 50)
AutoFarmToggle.Position = UDim2.new(0.05, 0, 0.2, 0)
AutoFarmToggle.BackgroundColor3 = Color3.fromRGB(220, 20, 60)
AutoFarmToggle.BorderSizePixel = 0
AutoFarmToggle.Text = "🔴 AutoFarm Candies: OFF"
AutoFarmToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoFarmToggle.TextScaled = true
AutoFarmToggle.Font = Enum.Font.GothamBold
AutoFarmToggle.Parent = FarmSection

-- Секция скорости
local SpeedSection = Instance.new("Frame")
SpeedSection.Name = "SpeedSection"
SpeedSection.Size = UDim2.new(0.9, 0, 0, 80)
SpeedSection.Position = UDim2.new(0.05, 0, 0.45, 0)
SpeedSection.BackgroundColor3 = Color3.fromRGB(47, 0, 82)
SpeedSection.BorderColor3 = Color3.fromRGB(148, 0, 211)
SpeedSection.BorderSizePixel = 2
SpeedSection.Parent = FarmSection

local SpeedTitle = Instance.new("TextLabel")
SpeedTitle.Name = "SpeedTitle"
SpeedTitle.Size = UDim2.new(1, 0, 0, 25)
SpeedTitle.BackgroundTransparency = 1
SpeedTitle.Text = "🍬 Farm Speed:"
SpeedTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedTitle.TextScaled = true
SpeedTitle.Font = Enum.Font.GothamBold
SpeedTitle.Parent = SpeedSection

local SpeedValue = Instance.new("TextLabel")
SpeedValue.Name = "SpeedValue"
SpeedValue.Size = UDim2.new(0.3, 0, 0, 25)
SpeedValue.Position = UDim2.new(0.7, 0, 0, 0)
SpeedValue.BackgroundTransparency = 1
SpeedValue.Text = "5"
SpeedValue.TextColor3 = Color3.fromRGB(255, 140, 0)
SpeedValue.TextScaled = true
SpeedValue.Font = Enum.Font.GothamBold
SpeedValue.Parent = SpeedSection

-- Слайдер
local SliderTrack = Instance.new("Frame")
SliderTrack.Name = "SliderTrack"
SliderTrack.Size = UDim2.new(0.9, 0, 0, 15)
SliderTrack.Position = UDim2.new(0.05, 0, 0.5, 0)
SliderTrack.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SliderTrack.BorderSizePixel = 0
SliderTrack.Parent = SpeedSection

local SliderButton = Instance.new("TextButton")
SliderButton.Name = "SliderButton"
SliderButton.Size = UDim2.new(0, 25, 0, 25)
SliderButton.Position = UDim2.new(0.4, -12, 0, -5) -- Начальная позиция для скорости 5
SliderButton.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
SliderButton.BorderSizePixel = 0
SliderButton.Text = ""
SliderButton.ZIndex = 2
SliderButton.Parent = SliderTrack

-- Счетчик конфет
local CandyCounter = Instance.new("TextLabel")
CandyCounter.Name = "CandyCounter"
CandyCounter.Size = UDim2.new(0.9, 0, 0, 30)
CandyCounter.Position = UDim2.new(0.05, 0, 0.85, 0)
CandyCounter.BackgroundTransparency = 1
CandyCounter.Text = "🍭 Candies: 0"
CandyCounter.TextColor3 = Color3.fromRGB(255, 215, 0)
CandyCounter.TextScaled = true
CandyCounter.Font = Enum.Font.GothamBold
CandyCounter.TextXAlignment = Enum.TextXAlignment.Left
CandyCounter.Parent = FarmSection

-- Переменные
local autoFarmEnabled = false
local farmSpeed = 5 -- Начальная скорость 5
local menuHidden = false
local connection
local sliding = false
local collectedCandies = {}
local isCollecting = false -- Флаг чтобы не собирать несколько конфет одновременно

-- Функция для подсчета конфет
local function countCandies()
    local count = 0
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if (obj.Name:lower():find("candy") or obj.Name:lower():find("coin") or obj.Name:lower():find("reward")) and not collectedCandies[obj] then
            if obj:IsA("Part") or obj:IsA("MeshPart") then
                count = count + 1
            end
        end
    end
    
    return count
end

-- Функция для обновления счетчика
local function updateCandyCounter()
    local candyCount = countCandies()
    CandyCounter.Text = "🍭 Candies: " .. tostring(candyCount)
end

-- Функция для поиска БЛИЖАЙШЕЙ конфеты
local function findNearestCandy()
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return nil end
    
    local nearestCandy = nil
    local shortestDistance = math.huge
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if (obj.Name:lower():find("candy") or obj.Name:lower():find("coin") or obj.Name:lower():find("reward")) and not collectedCandies[obj] then
            if obj:IsA("Part") or obj:IsA("MeshPart") then
                local distance = (humanoidRootPart.Position - obj.Position).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    nearestCandy = obj
                end
            end
        end
    end
    
    return nearestCandy
end

-- Функция сбора конфеты (ФИКСИРОВАННОЕ ВРЕМЯ 500ms)
local function collectCandy(candy)
    if isCollecting then return false end -- Уже собираем другую конфету
    if candy and candy.Parent and not collectedCandies[candy] then
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            isCollecting = true -- Начинаем сбор
            
            -- Отмечаем конфету как собранную
            collectedCandies[candy] = true
            
            -- ТЕЛЕПОРТАЦИЯ к конфете (мгновенно)
            humanoidRootPart.CFrame = CFrame.new(candy.Position + Vector3.new(0, 3, 0))
            
            -- ФИКСИРОВАННАЯ ЗАДЕРЖКА 500 МИЛЛИСЕКУНД
            wait(0.5)
            
            -- Пытаемся "собрать" конфету
            if candy.Parent then
                pcall(function()
                    candy:Destroy()
                end)
            end
            
            isCollecting = false -- Завершили сбор
            return true
        end
    end
    isCollecting = false
    return false
end

-- Основная функция автофарма
local function autoFarm()
    if not autoFarmEnabled then return end
    if not character or not character:FindFirstChild("Humanoid") or character.Humanoid.Health <= 0 then return end
    if isCollecting then return end -- Не прерываем текущий сбор
    
    local candy = findNearestCandy()
    
    if candy then
        local success = collectCandy(candy)
        if success then
            -- Успешно собрали конфету за 500ms, ждем перед поиском следующей
            local waitTime = (1 / farmSpeed) - 0.5 -- Вычитаем время сбора
            if waitTime > 0 then
                wait(waitTime)
            end
        else
            -- Не удалось собрать, ждем немного и продолжаем
            wait(0.2)
        end
    else
        -- Нет конфет для сбора, ждем и проверяем снова
        wait(1)
        
        -- Очищаем таблицу собранных конфет если все собрано
        if countCandies() == 0 then
            collectedCandies = {}
            wait(2)
        end
    end
end

-- Функции слайдера
local function updateSlider(positionX)
    local trackAbsolutePosition = SliderTrack.AbsolutePosition.X
    local trackAbsoluteSize = SliderTrack.AbsoluteSize.X
    local relativeX = math.clamp(positionX - trackAbsolutePosition, 0, trackAbsoluteSize)
    local percentage = relativeX / trackAbsoluteSize
    
    farmSpeed = math.floor(percentage * 9) + 1
    SpeedValue.Text = tostring(farmSpeed)
    
    SliderButton.Position = UDim2.new(percentage, -12, 0, -5)
end

-- Обработчики слайдера
SliderButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        sliding = true
    end
end)

SliderButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        sliding = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if sliding and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        updateSlider(input.Position.X)
    end
end)

-- Обработчики кнопок
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    if connection then
        connection:Disconnect()
    end
end)

HideButton.MouseButton1Click:Connect(function()
    menuHidden = true
    MainFrame.Visible = false
    OpenButton.Visible = true
end)

OpenButton.MouseButton1Click:Connect(function()
    menuHidden = false
    MainFrame.Visible = true
    OpenButton.Visible = false
end)

AutoFarmToggle.MouseButton1Click:Connect(function()
    autoFarmEnabled = not autoFarmEnabled
    
    if autoFarmEnabled then
        AutoFarmToggle.BackgroundColor3 = Color3.fromRGB(50, 205, 50)
        AutoFarmToggle.Text = "🟢 AutoFarm Candies: ON"
        
        -- Очищаем историю собранных конфет при запуске
        collectedCandies = {}
        isCollecting = false
        
        if connection then
            connection:Disconnect()
        end
        connection = RunService.Heartbeat:Connect(function()
            autoFarm()
        end)
    else
        AutoFarmToggle.BackgroundColor3 = Color3.fromRGB(220, 20, 60)
        AutoFarmToggle.Text = "🔴 AutoFarm Candies: OFF"
        
        if connection then
            connection:Disconnect()
        end
    end
end)

-- Обработка смерти
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    wait(3) -- Ждем респавн
    
    -- Очищаем историю собранных конфет после смерти
    collectedCandies = {}
    isCollecting = false
    
    if autoFarmEnabled then
        if connection then
            connection:Disconnect()
        end
        connection = RunService.Heartbeat:Connect(function()
            autoFarm()
        end)
    end
end)

-- Автоматическое обновление счетчика конфет
local candyUpdateConnection
candyUpdateConnection = RunService.Heartbeat:Connect(function()
    updateCandyCounter()
end)

print("✅ SANSTRO MM2 Menu loaded successfully!")
print("🎃 Halloween theme activated!")
print("📱 Working on mobile!")
print("🍭 Candy counter added!")
print("⏱️ Fixed collection time: 500ms per candy")
print("⚡ Speed controls delay BETWEEN candies")