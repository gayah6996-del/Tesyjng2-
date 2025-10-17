local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Основной GUI
local gui = Instance.new("ScreenGui")
gui.Name = "AimbotGUI"
gui.Parent = player:WaitForChild("PlayerGui")

-- Главный фрейм меню
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = gui

-- Закругление углов
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- Тень
local shadow = Instance.new("ImageLabel")
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316045217"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.8
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 118, 118)
shadow.Parent = mainFrame
shadow.ZIndex = -1

-- Заголовок
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
title.Text = "AIMBOT"
title.TextColor3 = Color3.fromRGB(255, 50, 50)
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = title

-- Контейнер для элементов
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 1, -40)
scrollFrame.Position = UDim2.new(0, 0, 0, 40)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 4
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.Parent = scrollFrame
layout.Padding = UDim.new(0, 8)

local padding = Instance.new("UIPadding")
padding.Parent = scrollFrame
padding.PaddingLeft = UDim.new(0, 10)
padding.PaddingRight = UDim.new(0, 10)
padding.PaddingTop = UDim.new(0, 10)
padding.PaddingBottom = UDim.new(0, 10)

-- Переменные для настроек
local settings = {
    aimbot = false,
    fov = 50,
    teamCheck = false,
    killCheck = false,
    wallHack = false
}

-- FOV круг (визуализация)
local fovCircle = Instance.new("Frame")
fovCircle.Size = UDim2.new(0, settings.fov * 2, 0, settings.fov * 2)
fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
fovCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
fovCircle.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
fovCircle.BackgroundTransparency = 0.7
fovCircle.BorderSizePixel = 0
fovCircle.Visible = false
fovCircle.Parent = gui

local fovCorner = Instance.new("UICorner")
fovCorner.CornerRadius = UDim.new(1, 0)
fovCorner.Parent = fovCircle

-- Функция создания переключателей
function createToggle(name, parent, defaultValue)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 30)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 50, 0, 25)
    toggle.Position = UDim2.new(1, -50, 0.5, -12.5)
    toggle.BackgroundColor3 = defaultValue and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
    toggle.Text = defaultValue and "ON" or "OFF"
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.TextSize = 12
    toggle.Font = Enum.Font.GothamBold
    toggle.Parent = frame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = toggle

    toggle.MouseButton1Click:Connect(function()
        local newValue = not (toggle.Text == "ON")
        toggle.Text = newValue and "ON" or "OFF"
        toggle.BackgroundColor3 = newValue and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
        settings[name:gsub(" ", ""):lower()] = newValue
        
        -- Особые действия для некоторых переключателей
        if name == "AimBot" then
            fovCircle.Visible = newValue
        end
    end)

    return toggle
end

-- Функция создания слайдера
function createSlider(name, parent, minValue, maxValue, defaultValue)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 60)
    container.BackgroundTransparency = 1
    container.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = name .. ": " .. defaultValue
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, 0, 0, 25)
    sliderFrame.Position = UDim2.new(0, 0, 0, 25)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    sliderFrame.Parent = container

    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 4)
    sliderCorner.Parent = sliderFrame

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((defaultValue - minValue) / (maxValue - minValue), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    fill.BorderSizePixel = 0
    fill.Parent = sliderFrame

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 4)
    fillCorner.Parent = fill

    local sliderButton = Instance.new("TextButton")
    sliderButton.Size = UDim2.new(0, 20, 1, 4)
    sliderButton.Position = UDim2.new((defaultValue - minValue) / (maxValue - minValue), -10, 0, -2)
    sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderButton.Text = ""
    sliderButton.Parent = sliderFrame

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 4)
    buttonCorner.Parent = sliderButton

    local dragging = false

    local function updateSlider(input)
        local pos = UDim2.new(math.clamp((input.Position.X - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X, 0, 1), -10, 0, -2)
        sliderButton.Position = pos
        
        local value = math.floor(minValue + (pos.X.Scale * (maxValue - minValue)))
        label.Text = name .. ": " .. value
        fill.Size = UDim2.new(pos.X.Scale, 0, 1, 0)
        
        settings[name:gsub(" ", ""):lower()] = value
        
        -- Обновляем FOV круг
        if name == "FOV" then
            fovCircle.Size = UDim2.new(0, value * 2, 0, value * 2)
        end
    end

    sliderButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)

    sliderButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    sliderFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            updateSlider(input)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input)
        end
    end)

    return container
end

-- Создание элементов интерфейса
createToggle("AimBot", scrollFrame, false)
createSlider("FOV", scrollFrame, 10, 200, 50)
createToggle("Team Check", scrollFrame, false)
createToggle("Kill Check", scrollFrame, false)
createToggle("WallHack", scrollFrame, false)

-- Кнопка переоткрытия меню (квадратная)
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 40, 0, 40)
toggleButton.Position = UDim2.new(1, -50, 0, 10)
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
toggleButton.Text = "≡"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 20
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Parent = gui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 6)
toggleCorner.Parent = toggleButton

local toggleShadow = Instance.new("ImageLabel")
toggleShadow.Size = UDim2.new(1, 10, 1, 10)
toggleShadow.Position = UDim2.new(0, -5, 0, -5)
toggleShadow.BackgroundTransparency = 1
toggleShadow.Image = "rbxassetid://1316045217"
toggleShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
toggleShadow.ImageTransparency = 0.8
toggleShadow.ScaleType = Enum.ScaleType.Slice
toggleShadow.SliceCenter = Rect.new(10, 10, 118, 118)
toggleShadow.Parent = toggleButton
toggleShadow.ZIndex = -1

-- Функционал скрытия/показа меню
toggleButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- Обновление позиции FOV круга
RunService.RenderStepped:Connect(function()
    if settings.aimbot and fovCircle.Visible then
        fovCircle.Position = UDim2.new(0, mouse.X, 0, mouse.Y)
    end
end)

print("Aimbot Menu loaded! Use the square button to toggle menu.")