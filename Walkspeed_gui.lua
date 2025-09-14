local player = game.Players.LocalPlayer
local jumpEnabled = false
local speedEnabled = false
local noClipEnabled = false -- Новый параметр для NoClip
local menuOpen = false -- Для отслеживания состояния меню

-- Создаем ScreenGui
local screenGui = Instance.new("ScreenGui", player.PlayerGui)screenGui.Name ="@SFXCL"-- Создаем кнопку для открытия/закрытия меню
local toggleButton = Instance.new("TextButton", screenGui)toggleButton.Size = UDim2.new(0, 50, 0, 50)toggleButton.Position = UDim2.new(0.5, -25, 0.5, -25)toggleButton.Text ="Menu"toggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 255) -- Синий цвет

-- Создаем кнопку для прыжка
local jumpButton = Instance.new("TextButton", screenGui)jumpButton.Size = UDim2.new(0, 200, 0, 50)jumpButton.Position = UDim2.new(0.5, -100, 0.5, -30)jumpButton.Text ="Toggle Infinity Jump"jumpButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Красный цвет
jumpButton.Visible = false -- Изначально скрыта

-- Создаем кнопку для скорости
local speedButton = Instance.new("TextButton", screenGui)speedButton.Size = UDim2.new(0, 200, 0, 50)speedButton.Position = UDim2.new(0.5, -100, 0.5, 20)speedButton.Text ="Toggle Speed Hack"speedButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Красный цвет
speedButton.Visible = false -- Изначально скрыта

-- Создаем кнопку NoClip
local noClipButton = Instance.new("TextButton", screenGui)noClipButton.Size = UDim2.new(0, 200, 0, 50)noClipButton.Position = UDim2.new(0.5, -100, 0.5, 70)noClipButton.Text ="Toggle NoClip"noClipButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Красный цвет
noClipButton.Visible = false -- Изначально скрыта

-- Создаем кнопку закрытия меню
local closeButton = Instance.new("TextButton", screenGui)closeButton.Size = UDim2.new(0, 50, 0, 50)closeButton.Position = UDim2.new(0.5, 75, 0.5, -30)closeButton.Text ="X" -- Кнопка закрытия
closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Красный цвет
closeButton.Visible = false -- Изначально скрыта

-- Функция для переключения бесконечного прыжка
local function toggleJump()    jumpEnabled = not jumpEnabled
    jumpButton.BackgroundColor3 = jumpEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0) -- Зеленый, если включен; красный, если выключен
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.JumpPower = jumpEnabled and 100 or 50
    end
end

-- Функция для переключения скорости
local function toggleSpeed()    speedEnabled = not speedEnabled
    speedButton.BackgroundColor3 = speedEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = speedEnabled and 50 or 16
    end
end

-- Функция для переключения NoClip
local function toggleNoClip()    noClipEnabled = not noClipEnabled
    noClipButton.BackgroundColor3 = noClipEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)    
    local character = player.Character
    if character then
        for_, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = not noClipEnabled -- Переключаем коллизию
            end
        end
    end
end

-- Функция для открытия/закрытия меню
local function toggleMenu()    menuOpen = not menuOpen
    jumpButton.Visible = menuOpen
    speedButton.Visible = menuOpen
    noClipButton.Visible = menuOpen
    closeButton.Visible = menuOpen
end

-- Функция для закрытия меню
local function closeMenu()    menuOpen = false
    jumpButton.Visible = false
    speedButton.Visible = false
    noClipButton.Visible = false
    closeButton.Visible = false
end

-- Подключаем события нажатия кнопок
toggleButton.MouseButton1Click:Connect(toggleMenu)jumpButton.MouseButton1Click:Connect(toggleJump)speedButton.MouseButton1Click:Connect(toggleSpeed)noClipButton.MouseButton1Click:Connect(toggleNoClip)closeButton.MouseButton1Click:Connect(closeMenu)-- Функция для перетаскивания меню
local function dragMenu(button)    local dragging = false
    local dragInput
    local startPos = button.Position

    button.InputBegan:Connect(function(input)        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragInput = input
            startPos = button.Position

            input.Changed:Connect(function()                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)        end
    end)    
    button.InputChanged:Connect(function(input)        if input.UserInputType == Enum.UserInputType.MouseMovement then
            while dragging do
                local mousePos = player:GetMouse().X
                button.Position = UDim2.new(0, mousePos - button.Size.X.Offset / 2, 0, startPos.Y.Offset)                wait()            end
        end
    end)end

-- Разрешаем перетаскивание для кнопки переключения
dragMenu(toggleButton)-- Обеспечиваем, чтобы игрок мог прыгать бесконечно
game:GetService("RunService").RenderStepped:Connect(function()    if jumpEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
        if player.Character.Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
            player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)        end
    end
end)