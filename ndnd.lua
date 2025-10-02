-- Создаем экран GUI
local ScreenGui = Instance.new("ScreenGui")local Frame = Instance.new("Frame")local AimBotButton = Instance.new("TextButton")-- Настраиваем GUI
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")Frame.Size = UDim2.new(0.2, 0, 0.2, 0)Frame.Position = UDim2.new(0.4, 0, 0.4, 0)Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)Frame.Parent = ScreenGui

AimBotButton.Size = UDim2.new(1, 0, 1, 0)AimBotButton.Text ="Включить Аимбот"AimBotButton.Parent = Frame

local aimbotEnabled = false

-- Функция для активации аимбота
local function toggleAimBot()    aimbotEnabled = not aimbotEnabled
    if aimbotEnabled then
        AimBotButton.Text ="Выключить Аимбот"    else
        AimBotButton.Text ="Включить Аимбот"    end
end

AimBotButton.MouseButton1Click:Connect(toggleAimBot)-- Основной цикл для аимбота
game:GetService("RunService").RenderStepped:Connect(function()    if aimbotEnabled then
        local player = game.Players.LocalPlayer
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local closestPlayer = nil
            local closestDistance = math.huge
            
            for_, otherPlayer in ipairs(game.Players:GetPlayers()) do
                if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local distance = (character.HumanoidRootPart.Position - otherPlayer.Character.HumanoidRootPart.Position).magnitude
                    if distance < closestDistance then
                        closestDistance = distance
                        closestPlayer = otherPlayer
                    end
                end
            end
            
            if closestPlayer then
                -- Нацеливаемся на ближайшего игрока
                local targetPosition = closestPlayer.Character.HumanoidRootPart.Position
                character.HumanoidRootPart.CFrame = CFrame.new(targetPosition + Vector3.new(0, 1, 0)) -- добавляем небольшую высоту
            end
        end
    end
end)