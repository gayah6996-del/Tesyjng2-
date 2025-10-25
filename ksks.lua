-- Voidware UI для Roblox
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Создаем основной экран
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VoidwareUI"
screenGui.Parent = playerGui

-- Основной фрейм
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 400, 0, 500)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

-- Заголовок
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 0, 60)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
titleLabel.BorderSizePixel = 0
titleLabel.Text = "Voidware"
titleLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainFrame

-- Discord ссылка
local discordLabel = Instance.new("TextLabel")
discordLabel.Name = "Discord"
discordLabel.Size = UDim2.new(1, 0, 0, 30)
discordLabel.Position = UDim2.new(0, 0, 0, 60)
discordLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
discordLabel.BorderSizePixel = 0
discordLabel.Text = "discord.gg/voidware"
discordLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
discordLabel.TextScaled = true
discordLabel.Font = Enum.Font.Gotham
discordLabel.Parent = mainFrame

-- Поиск
local searchButton = Instance.new("TextButton")
searchButton.Name = "Search"
searchButton.Size = UDim2.new(1, -20, 0, 40)
searchButton.Position = UDim2.new(0, 10, 0, 100)
searchButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
searchButton.BorderSizePixel = 0
searchButton.Text = "Поиск"
searchButton.TextColor3 = Color3.fromRGB(255, 255, 255)
searchButton.TextScaled = true
searchButton.Font = Enum.Font.Gotham
searchButton.Parent = mainFrame

-- Информация
local infoButton = Instance.new("TextButton")
infoButton.Name = "Information"
infoButton.Size = UDim2.new(1, -20, 0, 40)
infoButton.Position = UDim2.new(0, 10, 0, 150)
infoButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
infoButton.BorderSizePixel = 0
infoButton.Text = "Информация"
infoButton.TextColor3 = Color3.fromRGB(255, 255, 255)
infoButton.TextScaled = true
infoButton.Font = Enum.Font.Gotham
infoButton.Parent = mainFrame

-- Развлечения
local funButton = Instance.new("TextButton")
funButton.Name = "Fun"
funButton.Size = UDim2.new(1, -20, 0, 40)
funButton.Position = UDim2.new(0, 10, 0, 200)
funButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
funButton.BorderSizePixel = 0
funButton.Text = "Развлечения"
funButton.TextColor3 = Color3.fromRGB(255, 255, 255)
funButton.TextScaled = true
funButton.Font = Enum.Font.Gotham
funButton.Parent = mainFrame

-- Авто
local autoButton = Instance.new("TextButton")
autoButton.Name = "Auto"
autoButton.Size = UDim2.new(1, -20, 0, 40)
autoButton.Position = UDim2.new(0, 10, 0, 250)
autoButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
autoButton.BorderSizePixel = 0
autoButton.Text = "Авто"
autoButton.TextColor3 = Color3.fromRGB(255, 255, 255)
autoButton.TextScaled = true
autoButton.Font = Enum.Font.Gotham
autoButton.Parent = mainFrame

-- Принести вещи
local bringButton = Instance.new("TextButton")
bringButton.Name = "BringStuff"
bringButton.Size = UDim2.new(1, -20, 0, 40)
bringButton.Position = UDim2.new(0, 10, 0, 300)
bringButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
bringButton.BorderSizePixel = 0
bringButton.Text = "Принести вещи"
bringButton.TextColor3 = Color3.fromRGB(255, 255, 255)
bringButton.TextScaled = true
bringButton.Font = Enum.Font.Gotham
bringButton.Parent = mainFrame

-- Главное
local mainButton = Instance.new("TextButton")
mainButton.Name = "Main"
mainButton.Size = UDim2.new(1, -20, 0, 40)
mainButton.Position = UDim2.new(0, 10, 0, 350)
mainButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
mainButton.BorderSizePixel = 0
mainButton.Text = "Главное"
mainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
mainButton.TextScaled = true
mainButton.Font = Enum.Font.Gotham
mainButton.Parent = mainFrame

-- Приручение
local tamingButton = Instance.new("TextButton")
tamingButton.Name = "Taming"
tamingButton.Size = UDim2.new(1, -20, 0, 40)
tamingButton.Position = UDim2.new(0, 10, 0, 400)
tamingButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
tamingButton.BorderSizePixel = 0
tamingButton.Text = "Приручение"
tamingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
tamingButton.TextScaled = true
tamingButton.Font = Enum.Font.Gotham
tamingButton.Parent = mainFrame

-- Информация о пользователях
local userInfoFrame = Instance.new("Frame")
userInfoFrame.Name = "UserInfo"
userInfoFrame.Size = UDim2.new(1, -20, 0, 80)
userInfoFrame.Position = UDim2.new(0, 10, 0, 450)
userInfoFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
userInfoFrame.BorderSizePixel = 0
userInfoFrame.Parent = mainFrame

local memberCount = Instance.new("TextLabel")
memberCount.Name = "MemberCount"
memberCount.Size = UDim2.new(1, 0, 0.5, 0)
memberCount.Position = UDim2.new(0, 0, 0, 0)
memberCount.BackgroundTransparency = 1
memberCount.Text = "Количество участников: 75728"
memberCount.TextColor3 = Color3.fromRGB(200, 200, 255)
memberCount.TextScaled = true
memberCount.Font = Enum.Font.Gotham
memberCount.Parent = userInfoFrame

local onlineCount = Instance.new("TextLabel")
onlineCount.Name = "OnlineCount"
onlineCount.Size = UDim2.new(1, 0, 0.5, 0)
onlineCount.Position = UDim2.new(0, 0, 0.5, 0)
onlineCount.BackgroundTransparency = 1
onlineCount.Text = "Онлайн: 8684"
onlineCount.TextColor3 = Color3.fromRGB(200, 200, 255)
onlineCount.TextScaled = true
onlineCount.Font = Enum.Font.Gotham
onlineCount.Parent = userInfoFrame

-- Функция для анимации кнопок
local function animateButton(button)
    local originalSize = button.Size
    local originalColor = button.BackgroundColor3
    
    button.MouseEnter:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(60, 60, 90)
        })
        tween:Play()
    end)
    
    button.MouseLeave:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = originalColor
        })
        tween:Play()
    end)
    
    button.MouseButton1Click:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(80, 80, 120)
        })
        tween:Play()
        wait(0.1)
        tween = TweenService:Create(button, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(60, 60, 90)
        })
        tween:Play()
    end)
end

-- Применяем анимацию ко всем кнопкам
animateButton(searchButton)
animateButton(infoButton)
animateButton(funButton)
animateButton(autoButton)
animateButton(bringButton)
animateButton(mainButton)
animateButton(tamingButton)

-- Функция для открытия/закрытия UI
local uiVisible = true
local function toggleUI()
    uiVisible = not uiVisible
    mainFrame.Visible = uiVisible
end

-- Привязка клавиши (RightControl для открытия/закрытия)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.RightControl then
        toggleUI()
    end
end)

-- Сообщение в консоль
print("Voidware UI загружен!")
print("Нажмите RightControl для открытия/закрытия меню")
print("Присоединяйтесь к нашему Discord: discord.gg/voidware")

-- Добавляем обработчики событий для кнопок
searchButton.MouseButton1Click:Connect(function()
    print("Поиск активирован")
end)

infoButton.MouseButton1Click:Connect(function()
    print("Информация активирована")
end)

bringButton.MouseButton1Click:Connect(function()
    print("Функция 'Принести вещи' активирована")
end)

-- Сообщение о присоединении к Discord
discordLabel.MouseButton1Click:Connect(function()
    print("Присоединяйтесь к нашему Discord серверу: discord.gg/voidware")
end)