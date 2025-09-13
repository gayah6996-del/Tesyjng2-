local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local InfiniteJumpEnabled = true
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "WalkSpeedGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 90)
frame.Position = UDim2.new(0.5, -125, 0.5, -45) 
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.Parent = screenGui

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 40))
}
gradient.Rotation = 90
gradient.Parent = frame

local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(0, 80, 0, 30)
textBox.Position = UDim2.new(0, 10, 0, 10)
textBox.PlaceholderText = "WalkSpeed"
textBox.Text = ""
textBox.Font = Enum.Font.Gotham
textBox.TextSize = 14
textBox.Parent = frame

local applyButton = Instance.new("TextButton")
applyButton.Size = UDim2.new(0, 60, 0, 30)
applyButton.Position = UDim2.new(0, 100, 0, 10)
applyButton.Text = "Enter"
applyButton.Font = Enum.Font.Gotham
applyButton.TextSize = 14
applyButton.Parent = frame

local ChangeStateButton = Instance.new("TextButton")
ChangeStateButton.Size = UDim2.new(0, 80, 0, 30)
ChangeStateButton.Position = UDim2.new(0, 170, 0, 10)
ChangeStateButton.Text = "InfinityJump"
ChangeStateButton.Font = Enum.Font.Gotham
ChangeStateButton.TextSize = 14
ChangeStateButton.Parent = frame

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 20, 0, 20)
closeButton.Position = UDim2.new(0, 0, 0, 0)
closeButton.Text = "X"
closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 12
closeButton.Parent = frame

local reopenButton = Instance.new("TextButton")
reopenButton.Size = UDim2.new(0, 100, 0, 40)
reopenButton.Position = UDim2.new(0.5, -50, 0, -10)
reopenButton.Text = "By @SFXCL"
reopenButton.Font = Enum.Font.Gotham
reopenButton.TextSize = 19
reopenButton.Visible = false
reopenButton.Parent = screenGui

applyButton.MouseButton1Click:Connect(function()
	local speed = tonumber(textBox.Text)
	if speed and speed > 0 then
		player.Character.Humanoid.WalkSpeed = speed
	end
end)

closeButton.MouseButton1Click:Connect(function()
	frame.Visible = false
	reopenButton.Visible = true
end)

reopenButton.MouseButton1Click:Connect(function()
	frame.Visible = true
	reopenButton.Visible = false
end)

local dragging
local dragInput
local dragStart
local startPos

local function update(input)
	local delta = input.Position - dragStart
	frame.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
end

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

local infiniteJumpEnabled = false

-- Обрабатываем клик по кнопке
ChangeStateButton.MouseButton1Click:Connect(function()
    infiniteJumpEnabled = not infiniteJumpEnabled -- меняем состояние прыжка
    
    -- Можно дополнительно изменить надпись на кнопке
    if infiniteJumpEnabled then
        ChangeStateButton.Text = "Infinity Jump:Off"
    else
        ChangeStateButton.Text = "Infinity Jump:On"
    end
end)

-- Основной код обработки прыжков остается прежним
game:GetService("UserInputService").JumpRequest:Connect(function()
    if infiniteJumpEnabled then
        game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- Создание кнопки Noclip Toggle
local toggleBtn = Instance.new("TextButton")   -- Создаем новую кнопку
toggleBtn.Name = "ToggleNoclip"
toggleBtn.AutoButtonColor = true                -- Автоматическое изменение цвета при нажатии
toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- Цвет фона кнопки по умолчанию (красный)
toggleBtn.Position = UDim2.new(0, 5, 1, 5)     -- Кнопка размещается снизу текущего элемента
toggleBtn.Size = UDim2.new(1, -70, 0, 25)      -- Размер кнопки: ширина полная минус отступ справа
toggleBtn.FontSize = Enum.FontSize.Size18       -- Размер шрифта текста
toggleBtn.Text = "Noclip: OFF"                 -- Начальное состояние надписи на кнопке
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)-- Белый цвет текста
toggleBtn.Visible = true                        -- Видима по умолчанию
toggleBtn.Active = true                         -- Активна по умолчанию
toggleBtn.Parent = walkspeedSlider              -- Родителем делаем тот же фрейм, что и ползунок скорости

-- Функция обработки события клика по кнопке
toggleBtn.MouseButton1Click:Connect(function()
 local newState = not noclip                   -- Инвертируем текущее состояние ноклипа
 setNoclip(newState)                           -- Устанавливаем новое значение состояния
end)

-- Логика установки состояния ноклипа
local function setNoclip(state)
 noclip = state                                -- Обновляем глобальную переменную состояния
 if noclip then
  toggleBtn.Text = "Noclip: ON"               -- Меняем надпись и цвет кнопки
  toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
 else
  toggleBtn.Text = "Noclip: OFF"
  toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
 end
end

setNoclip(false)                               -- Изначально выключено

frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

RunService.RenderStepped:Connect(function()
	if dragging and dragInput then
		update(dragInput)
	end
end)