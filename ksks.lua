-- SANSTRO MM2 Halloween Script
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Переменные для меню
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TopBar = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local CloseButton = Instance.new("ImageButton")
local HideButton = Instance.new("ImageButton")
local OpenButton = Instance.new("ImageButton")
local ScrollFrame = Instance.new("ScrollingFrame")
local FarmSection = Instance.new("Frame")
local FarmTitle = Instance.new("TextLabel")
local AutoFarmToggle = Instance.new("TextButton")
local SpeedSection = Instance.new("Frame")
local SpeedTitle = Instance.new("TextLabel")
local SpeedValue = Instance.new("TextLabel")
local SpeedSlider = Instance.new("Frame")
local SliderTrack = Instance.new("Frame")
local SliderButton = Instance.new("TextButton")

-- Настройки
local autoFarmEnabled = false
local farmSpeed = 1
local menuHidden = false
local connection
local sliding = false

-- Хеллоуинские цвета
local HALLOWEEN_COLORS = {
    DARK_PURPLE = Color3.fromRGB(47, 0, 82),
    PURPLE = Color3.fromRGB(106, 13, 173),
    LIGHT_PURPLE = Color3.fromRGB(148, 0, 211),
    ORANGE = Color3.fromRGB(255, 140, 0),
    GREEN = Color3.fromRGB(50, 205, 50),
    RED = Color3.fromRGB(220, 20, 60),
    GOLD = Color3.fromRGB(255, 215, 0)
}

-- Создание GUI
ScreenGui.Name = "SANSTROMM2_HALLOWEEN"
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Главный фрейм с хеллоуинским стилем
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 400, 0, 500)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
MainFrame.BackgroundColor3 = HALLOWEEN_COLORS.DARK_PURPLE
MainFrame.BorderColor3 = HALLOWEEN_COLORS.ORANGE
MainFrame.BorderSizePixel = 3
MainFrame.BackgroundTransparency = 0.1
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Добавляем градиент для фона
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, HALLOWEEN_COLORS.DARK_PURPLE),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 0, 45))
})
gradient.Rotation = 45
gradient.Parent = MainFrame

-- Верхняя панель с паутиной
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 50)
TopBar.BackgroundColor3 = HALLOWEEN_COLORS.PURPLE
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

-- Заголовок с хеллоуинским шрифтом
Title.Name = "Title"
Title.Size = UDim2.new(0.6, 0, 1, 0)
Title.Position = UDim2.new(0.05, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "SANSTRO MM2"
Title.TextColor3 = HALLOWEEN_COLORS.GOLD
Title.TextScaled = true
Title.Font = Enum.Font.Horror
Title.TextStrokeColor3 = HALLOWEEN_COLORS.DARK_PURPLE
Title.TextStrokeTransparency = 0.3
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Кнопка закрытия (тыква)
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 35, 0, 35)
CloseButton.Position = UDim2.new(0.9, 0, 0.15, 0)
CloseButton.BackgroundColor3 = HALLOWEEN_COLORS.ORANGE
CloseButton.BorderSizePixel = 0
CloseButton.Image = "rbxassetid://11144551645" -- Тыква
CloseButton.Parent = TopBar

-- Кнопка скрытия (призрак)
HideButton.Name = "HideButton"
HideButton.Size = UDim2.new(0, 35, 0, 35)
HideButton.Position = UDim2.new(0.8, 0, 0.15, 0)
HideButton.BackgroundColor3 = HALLOWEEN_COLORS.LIGHT_PURPLE
HideButton.BorderSizePixel = 0
HideButton.Image = "rbxassetid://11144543917" -- Призрак
HideButton.Parent = TopBar

-- Кнопка открытия (летучая мышь)
OpenButton.Name = "OpenButton"
OpenButton.Size = UDim2.new(0, 70, 0, 70)
OpenButton.Position = UDim2.new(0, 20, 0, 20)
OpenButton.BackgroundColor3 = HALLOWEEN_COLORS.PURPLE
OpenButton.BorderColor3 = HALLOWEEN_COLORS.ORANGE
OpenButton.BorderSizePixel = 2
OpenButton.Image = "rbxassetid://11144547184" -- Летучая мышь
OpenButton.Visible = false
OpenButton.Parent = ScreenGui

-- Скролл фрейм
ScrollFrame.Name = "ScrollFrame"
ScrollFrame.Size = UDim2.new(1, -20, 1, -70)
ScrollFrame.Position = UDim2.new(0, 10, 0, 60)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 8
ScrollFrame.ScrollBarImageColor3 = HALLOWEEN_COLORS.ORANGE
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 400)
ScrollFrame.Parent = MainFrame

-- Секция Farm Candies
FarmSection.Name = "FarmSection"
FarmSection.Size = UDim2.new(1, -10, 0, 250)
FarmSection.Position = UDim2.new(0, 5, 0, 10)
FarmSection.BackgroundColor3 = HALLOWEEN_COLORS.PURPLE
FarmSection.BackgroundTransparency = 0.2
FarmSection.BorderColor3 = HALLOWEEN_COLORS.ORANGE
FarmSection.BorderSizePixel = 2
FarmSection.Parent = ScrollFrame

FarmTitle.Name = "FarmTitle"
FarmTitle.Size = UDim2.new(1, 0, 0, 50)
FarmTitle.BackgroundColor3 = HALLOWEEN_COLORS.DARK_PURPLE
FarmTitle.BorderSizePixel = 0
FarmTitle.Text = "🎃 Farm Candies 🎃"
FarmTitle.TextColor3 = HALLOWEEN_COLORS.GOLD
FarmTitle.TextScaled = true
FarmTitle.Font = Enum.Font.Horror
FarmTitle.Parent = FarmSection

-- Кнопка AutoFarm
AutoFarmToggle.Name = "AutoFarmToggle"
AutoFarmToggle.Size = UDim2.new(0.9, 0, 0, 60)
AutoFarmToggle.Position = UDim2.new(0.05, 0, 0.25, 0)
AutoFarmToggle.BackgroundColor3 = HALLOWEEN_COLORS.RED
AutoFarmToggle.BorderColor3 = HALLOWEEN_COLORS.ORANGE
AutoFarmToggle.BorderSizePixel = 2
AutoFarmToggle.Text = "🔴 AutoFarm Candies: OFF"
AutoFarmToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoFarmToggle.TextScaled = true
AutoFarmToggle.Font = Enum.Font.GothamBold
AutoFarmToggle.TextStrokeTransparency = 0.8
AutoFarmToggle.Parent = FarmSection

-- Секция скорости
SpeedSection.Name = "SpeedSection"
SpeedSection.Size = UDim2.new(0.9, 0, 0, 100)
SpeedSection.Position = UDim2.new(0.05, 0, 0.6, 0)
SpeedSection.BackgroundColor3 = HALLOWEEN_COLORS.DARK_PURPLE
SpeedSection.BackgroundTransparency = 0.3
SpeedSection.BorderColor3 = HALLOWEEN_COLORS.LIGHT_PURPLE
SpeedSection.BorderSizePixel = 2
SpeedSection.Parent = FarmSection

SpeedTitle.Name = "SpeedTitle"
SpeedTitle.Size = UDim2.new(1, 0, 0, 30)
SpeedTitle.BackgroundTransparency = 1
SpeedTitle.Text = "🍬 Farm Speed:"
SpeedTitle.TextColor3 = HALLOWEEN_COLORS.GOLD
SpeedTitle.TextScaled = true
SpeedTitle.Font = Enum.Font.GothamBold
SpeedTitle.Parent = SpeedSection

SpeedValue.Name = "SpeedValue"
SpeedValue.Size = UDim2.new(0.3, 0, 0, 30)
SpeedValue.Position = UDim2.new(0.65, 0, 0, 0)
SpeedValue.BackgroundTransparency = 1
SpeedValue.Text = "1"
SpeedValue.TextColor3 = HALLOWEEN_COLORS.ORANGE
SpeedValue.TextScaled = true
SpeedValue.Font = Enum.Font.GothamBold
SpeedValue.Parent = SpeedSection

-- Слайдер скорости (исправленный для телефона)
SpeedSlider.Name = "SpeedSlider"
SpeedSlider.Size = UDim2.new(0.9, 0, 0, 40)
SpeedSlider.Position = UDim2.new(0.05, 0, 0.4, 0)
SpeedSlider.BackgroundTransparency = 1
SpeedSlider.Parent = SpeedSection

SliderTrack.Name = "SliderTrack"
SliderTrack.Size = UDim2.new(1, 0, 0, 15)
SliderTrack.Position = UDim2.new(0, 0, 0.5, 0)
SliderTrack.BackgroundColor3 = HALLOWEEN_COLORS.DARK_PURPLE
SliderTrack.BorderColor3 = HALLOWEEN_COLORS.ORANGE
SliderTrack.BorderSizePixel = 2
SliderTrack.Parent = SpeedSlider

SliderButton.Name = "SliderButton"
SliderButton.Size = UDim2.new(0, 25, 0, 25)
SliderButton.Position = UDim2.new(0, -12, 0, -5)
SliderButton.BackgroundColor3 = HALLOWEEN_COLORS.ORANGE
SliderButton.BorderColor3 = HALLOWEEN_COLORS.GOLD
SliderButton.BorderSizePixel = 2
SliderButton.Text = ""
SliderButton.ZIndex = 3
SliderButton.Parent = SliderTrack

-- Функции
local function findCandies()
    local candies = {}
    
    -- Поиск конфет в workspace
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name:lower():find("candy") or obj.Name:lower():find("coin") or obj.Name:lower():find("reward") then
            if obj:IsA("Part") or obj:IsA("MeshPart") then
                table.insert(candies, obj)
            end
        end
    end
    
    return candies
end

local function collectCandy(candy)
    if candy and candy.Parent then
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            -- Телепортация к конфете
            humanoidRootPart.CFrame = candy.CFrame + Vector3.new(0, 3, 0)
            wait(0.2)
        end
    end
end

local function autoFarm()
    if autoFarmEnabled and character and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0 then
        local candies = findCandies()
        
        for _, candy in pairs(candies) do
            if not autoFarmEnabled then break end
            if candy and candy.Parent then
                collectCandy(candy)
                wait(1.5 / farmSpeed)
            end
        end
    end
end

-- Функции для слайдера (работают на телефоне)
local function updateSlider(positionX)
    local trackAbsolutePosition = SliderTrack.AbsolutePosition.X
    local trackAbsoluteSize = SliderTrack.AbsoluteSize.X
    local relativeX = math.clamp(positionX - trackAbsolutePosition, 0, trackAbsoluteSize)
    local percentage = relativeX / trackAbsoluteSize
    
    farmSpeed = math.floor(percentage * 9) + 1 -- Скорость от 1 до 10
    SpeedValue.Text = tostring(farmSpeed)
    
    SliderButton.Position = UDim2.new(percentage, -12, 0, -5)
end

-- Обработчики для слайдера (мобильная версия)
SliderButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        sliding = true
    end
end)

SliderButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        sliding = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if sliding and input.UserInputType == Enum.UserInputType.Touch then
        updateSlider(input.Position.X)
    end
end)

-- Также добавляем обработку клика по треку
SliderTrack.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        updateSlider(input.Position.X)
    end
end)

-- Обработчики событий кнопок
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
        AutoFarmToggle.BackgroundColor3 = HALLOWEEN_COLORS.GREEN
        AutoFarmToggle.Text = "🟢 AutoFarm Candies: ON"
        
        -- Запуск автофарма
        if connection then
            connection:Disconnect()
        end
        connection = RunService.Heartbeat:Connect(autoFarm)
    else
        AutoFarmToggle.BackgroundColor3 = HALLOWEEN_COLORS.RED
        AutoFarmToggle.Text = "🔴 AutoFarm Candies: OFF"
        
        if connection then
            connection:Disconnect()
        end
    end
end)

-- Хеллоуинские украшения
local function addHalloweenDecorations()
    -- Паутина в углах
    local web1 = Instance.new("ImageLabel")
    web1.Size = UDim2.new(0, 80, 0, 80)
    web1.Position = UDim2.new(0, -20, 0, -20)
    web1.BackgroundTransparency = 1
    web1.Image = "rbxassetid://11144543917"
    web1.ImageColor3 = HALLOWEEN_COLORS.LIGHT_PURPLE
    web1.ImageTransparency = 0.3
    web1.ZIndex = 0
    web1.Parent = MainFrame
    
    local web2 = Instance.new("ImageLabel")
    web2.Size = UDim2.new(0, 80, 0, 80)
    web2.Position = UDim2.new(1, -60, 1, -60)
    web2.BackgroundTransparency = 1
    web2.Image = "rbxassetid://11144543917"
    web2.ImageColor3 = HALLOWEEN_COLORS.LIGHT_PURPLE
    web2.ImageTransparency = 0.3
    web2.ZIndex = 0
    web2.Parent = MainFrame
    
    -- Анимированные свечи
    local candle = Instance.new("Frame")
    candle.Size = UDim2.new(0, 20, 0, 30)
    candle.Position = UDim2.new(0.02, 0, 0.9, 0)
    candle.BackgroundColor3 = Color3.fromRGB(139, 69, 19)
    candle.BorderSizePixel = 0
    candle.Parent = MainFrame
    
    local flame = Instance.new("Frame")
    flame.Size = UDim2.new(0, 8, 0, 12)
    flame.Position = UDim2.new(0.3, 0, -0.4, 0)
    flame.BackgroundColor3 = HALLOWEEN_COLORS.ORANGE
    flame.BorderSizePixel = 0
    flame.Parent = candle
end

-- Обработка смерти игрока
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    
    -- Автоматическое возобновление автофарма после смерти
    if autoFarmEnabled then
        wait(3)
        if connection then
            connection:Disconnect()
        end
        connection = RunService.Heartbeat:Connect(autoFarm)
    end
end)

-- Инициализация
addHalloweenDecorations()
updateSlider(SliderTrack.AbsolutePosition.X + 20) -- Установка начальной позиции

print("🎃 SANSTRO MM2 Halloween Menu loaded! 🎃")
print("Use the menu to farm candies with spooky style!")