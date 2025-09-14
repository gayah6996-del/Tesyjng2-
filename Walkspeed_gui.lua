local player = game.Players.LocalPlayer
local mouse = player:GetMouse()local jumpEnabled = false
local speedEnabled = false
local menuOpen = false -- To keep track of menu state

-- Создание меню
local screenGui = Instance.new("ScreenGui", player.PlayerGui)screenGui.Name ="@SFXCL"-- Создание кнопки для открытия/закрытия меню
local toggleButton = Instance.new("TextButton", screenGui)toggleButton.Size = UDim2.new(0, 50, 0, 50)toggleButton.Position = UDim2.new(0.5, -25, 0.5, -25)toggleButton.Text = ""toggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 255) -- Синий цвет
toggleButton.AutoButtonColor = false
toggleButton.Shape = Enum.TextButtonShape.Round -- Сделать кнопку круглой

-- Создание кнопок для прыжка и скорости
local jumpButton = Instance.new("TextButton", screenGui)jumpButton.Size = UDim2.new(0, 200, 0, 50)jumpButton.Position = UDim2.new(0.5, -100, 0.5, -30)jumpButton.Text ="Toggle Infinity Jump"jumpButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Красный цвет

local speedButton = Instance.new("TextButton", screenGui)speedButton.Size = UDim2.new(0, 200, 0, 50)speedButton.Position = UDim2.new(0.5, -100, 0.5, 20)speedButton.Text ="Toggle Speed Hack"speedButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Красный цвет

-- Функция бесконечного прыжка
local function toggleJump()    jumpEnabled = not jumpEnabled
    jumpButton.BackgroundColor3 = jumpEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0) -- Зеленый при включенном, красный при выключенном
    player.Character.Humanoid.JumpPower = jumpEnabled and 100 or 50
end

-- Функция ускорения
local function toggleSpeed()    speedEnabled = not speedEnabled
    speedButton.BackgroundColor3 = speedEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0) -- Зеленый при включенном, красный при выключенном
    player.Character.Humanoid.WalkSpeed = speedEnabled and 100 or 16
end

-- Функция для открытия/закрытия меню
local function toggleMenu()    menuOpen = not menuOpen
    jumpButton.Visible = menuOpen
    speedButton.Visible = menuOpen
end

toggleButton.MouseButton1Click:Connect(toggleMenu)jumpButton.MouseButton1Click:Connect(toggleJump)speedButton.MouseButton1Click:Connect(toggleSpeed)-- Убедимся, что игрок может прыгать бесконечно
game:GetService("RunService").RenderStepped:Connect(function()    if jumpEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
        if player.Character.Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
            player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)        end
    end
end)