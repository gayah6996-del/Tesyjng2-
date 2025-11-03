-- SANSTRO MM2 Script
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
local CloseButton = Instance.new("TextButton")
local HideButton = Instance.new("TextButton")
local OpenButton = Instance.new("TextButton")
local ScrollFrame = Instance.new("ScrollingFrame")
local FarmSection = Instance.new("Frame")
local FarmTitle = Instance.new("TextLabel")
local AutoFarmToggle = Instance.new("TextButton")
local SpeedSlider = Instance.new("Frame")
local SpeedTitle = Instance.new("TextLabel")
local SpeedValue = Instance.new("TextLabel")
local Slider = Instance.new("Frame")
local SliderButton = Instance.new("TextButton")

-- Настройки
local autoFarmEnabled = false
local farmSpeed = 1
local menuHidden = false
local connection

-- Создание GUI
ScreenGui.Name = "SANSTROMM2"
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Главный фрейм
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 350, 0, 400)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(75, 0, 130) -- Темно-фиолетовый
MainFrame.BorderColor3 = Color3.fromRGB(148, 0, 211) -- Фиолетовый
MainFrame.BorderSizePixel = 3
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Верхняя панель
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(106, 13, 173) -- Фиолетовый хеллоуин
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

-- Заголовок
Title.Name = "Title"
Title.Size = UDim2.new(0.6, 0, 1, 0)
Title.Position = UDim2.new(0.02, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "SANSTRO MM2"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.TextStrokeTransparency = 0.8
Title.Parent = TopBar

-- Кнопка закрытия
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(0.9, 0, 0.12, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(220, 20, 60)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextScaled = true
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = TopBar

-- Кнопка скрытия
HideButton.Name = "HideButton"
HideButton.Size = UDim2.new(0, 30, 0, 30)
HideButton.Position = UDim2.new(0.8, 0, 0.12, 0)
HideButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
HideButton.BorderSizePixel = 0
HideButton.Text = "_"
HideButton.TextColor3 = Color3.fromRGB(255, 255, 255)
HideButton.TextScaled = true
HideButton.Font = Enum.Font.GothamBold
HideButton.Parent = TopBar

-- Кнопка открытия (изначально скрыта)
OpenButton.Name = "OpenButton"
OpenButton.Size = UDim2.new(0, 60, 0, 60)
OpenButton.Position = UDim2.new(0, 10, 0, 10)
OpenButton.BackgroundColor3 = Color3.fromRGB(106, 13, 173)
OpenButton.BorderColor3 = Color3.fromRGB(148, 0, 211)
OpenButton.BorderSizePixel = 2
OpenButton.Text = "MENU"
OpenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenButton.TextScaled = true
OpenButton.Font = Enum.Font.GothamBold
OpenButton.Visible = false
OpenButton.Parent = ScreenGui

-- Скролл фрейм
ScrollFrame.Name = "ScrollFrame"
ScrollFrame.Size = UDim2.new(1, -10, 1, -50)
ScrollFrame.Position = UDim2.new(0, 5, 0, 45)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 5
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 300)
ScrollFrame.Parent = MainFrame

-- Секция Farm Candies
FarmSection.Name = "FarmSection"
FarmSection.Size = UDim2.new(1, -10, 0, 200)
FarmSection.Position = UDim2.new(0, 5, 0, 5)
FarmSection.BackgroundColor3 = Color3.fromRGB(65, 0, 110)
FarmSection.BorderColor3 = Color3.fromRGB(148, 0, 211)
FarmSection.BorderSizePixel = 2
FarmSection.Parent = ScrollFrame

FarmTitle.Name = "FarmTitle"
FarmTitle.Size = UDim2.new(1, 0, 0, 40)
FarmTitle.BackgroundColor3 = Color3.fromRGB(106, 13, 173)
FarmTitle.BorderSizePixel = 0
FarmTitle.Text = "Farm Candies"
FarmTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
FarmTitle.TextScaled = true
FarmTitle.Font = Enum.Font.GothamBold
FarmTitle.Parent = FarmSection

-- Кнопка AutoFarm
AutoFarmToggle.Name = "AutoFarmToggle"
AutoFarmToggle.Size = UDim2.new(0.9, 0, 0, 50)
AutoFarmToggle.Position = UDim2.new(0.05, 0, 0.25, 0)
AutoFarmToggle.BackgroundColor3 = Color3.fromRGB(220, 20, 60)
AutoFarmToggle.BorderSizePixel = 0
AutoFarmToggle.Text = "AutoFarm Candies: OFF"
AutoFarmToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoFarmToggle.TextScaled = true
AutoFarmToggle.Font = Enum.Font.GothamBold
AutoFarmToggle.Parent = FarmSection

-- Слайдер скорости
SpeedSlider.Name = "SpeedSlider"
SpeedSlider.Size = UDim2.new(0.9, 0, 0, 80)
SpeedSlider.Position = UDim2.new(0.05, 0, 0.55, 0)
SpeedSlider.BackgroundColor3 = Color3.fromRGB(65, 0, 110)
SpeedSlider.BorderSizePixel = 0
SpeedSlider.Parent = FarmSection

SpeedTitle.Name = "SpeedTitle"
SpeedTitle.Size = UDim2.new(1, 0, 0, 30)
SpeedTitle.BackgroundTransparency = 1
SpeedTitle.Text = "Farm Speed:"
SpeedTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedTitle.TextScaled = true
SpeedTitle.Font = Enum.Font.Gotham
SpeedTitle.Parent = SpeedSlider

SpeedValue.Name = "SpeedValue"
SpeedValue.Size = UDim2.new(0.3, 0, 0, 30)
SpeedValue.Position = UDim2.new(0.7, 0, 0, 0)
SpeedValue.BackgroundTransparency = 1
SpeedValue.Text = "1"
SpeedValue.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedValue.TextScaled = true
SpeedValue.Font = Enum.Font.GothamBold
SpeedValue.Parent = SpeedSlider

Slider.Name = "Slider"
Slider.Size = UDim2.new(1, 0, 0, 20)
Slider.Position = UDim2.new(0, 0, 0.5, 0)
Slider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Slider.BorderSizePixel = 0
Slider.Parent = SpeedSlider

SliderButton.Name = "SliderButton"
SliderButton.Size = UDim2.new(0, 30, 0, 30)
SliderButton.Position = UDim2.new(0, -15, 0.25, -15)
SliderButton.BackgroundColor3 = Color3.fromRGB(148, 0, 211)
SliderButton.BorderSizePixel = 0
SliderButton.Text = ""
SliderButton.ZIndex = 2
SliderButton.Parent = Slider

-- Функции
local function findCandies()
    local candies = {}
    
    -- Поиск конфет в workspace
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name:lower():find("candy") or obj.Name:lower():find("coin") then
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
            humanoidRootPart.CFrame = candy.CFrame
            
            -- Небольшая задержка для сбора
            wait(0.1)
        end
    end
end

local function autoFarm()
    if autoFarmEnabled and character and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0 then
        local candies = findCandies()
        
        for _, candy in pairs(candies) do
            if not autoFarmEnabled then break end
            collectCandy(candy)
            wait(1 / farmSpeed) -- Задержка в зависимости от скорости
        end
    end
end

-- Обработчики событий
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
        AutoFarmToggle.Text = "AutoFarm Candies: ON"
        
        -- Запуск автофарма
        if connection then
            connection:Disconnect()
        end
        connection = RunService.Heartbeat:Connect(autoFarm)
    else
        AutoFarmToggle.BackgroundColor3 = Color3.fromRGB(220, 20, 60)
        AutoFarmToggle.Text = "AutoFarm Candies: OFF"
        
        if connection then
            connection:Disconnect()
        end
    end
end)

-- Слайдер скорости
local sliding = false
SliderButton.MouseButton1Down:Connect(function()
    sliding = true
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        sliding = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
        local sliderAbsolutePosition = Slider.AbsolutePosition.X
        local sliderAbsoluteSize = Slider.AbsoluteSize.X
        local mouseX = input.Position.X
        
        local relativeX = math.clamp(mouseX - sliderAbsolutePosition, 0, sliderAbsoluteSize)
        local percentage = relativeX / sliderAbsoluteSize
        
        farmSpeed = math.floor(percentage * 10) + 1 -- Скорость от 1 до 11
        SpeedValue.Text = tostring(farmSpeed)
        
        SliderButton.Position = UDim2.new(percentage, -15, 0.25, -15)
    end
end)

-- Обработка смерти игрока
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    
    -- Автоматическое возобновление автофарма после смерти
    if autoFarmEnabled then
        wait(3) -- Ждем respawn
        if connection then
            connection:Disconnect()
        end
        connection = RunService.Heartbeat:Connect(autoFarm)
    end
end)

-- Хеллоуинские украшения
local function addHalloweenDecorations()
    -- Тыква в углу
    local pumpkin = Instance.new("ImageLabel")
    pumpkin.Size = UDim2.new(0, 40, 0, 40)
    pumpkin.Position = UDim2.new(0.85, 0, 0.85, 0)
    pumpkin.BackgroundTransparency = 1
    pumpkin.Image = "rbxassetid://11144551645" -- Замените на ID текстуры тыквы
    pumpkin.Parent = MainFrame
    
    -- Паутина
    local web = Instance.new("ImageLabel")
    web.Size = UDim2.new(0, 60, 0, 60)
    web.Position = UDim2.new(0.02, 0, 0.02, 0)
    web.BackgroundTransparency = 1
    web.Image = "rbxassetid://11144551645" -- Замените на ID текстуры паутины
    web.Parent = MainFrame
end

addHalloweenDecorations()

print("SANSTRO MM2 Menu loaded! Use the menu to farm candies.")