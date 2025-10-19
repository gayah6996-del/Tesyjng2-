-- 99 Nights in the Forest Script
-- Используйте на свой страх и риск!

local Player = game:GetService("Players").LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Создание GUI
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local CollectBtn = Instance.new("TextButton")
local AutoChopBtn = Instance.new("TextButton")
local ToggleBtn = Instance.new("TextButton")
local Status = Instance.new("TextLabel")

ScreenGui.Name = "ForestScriptGUI"
ScreenGui.Parent = PlayerGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Frame.Name = "MainFrame"
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0, 10, 0, 10)
Frame.Size = UDim2.new(0, 250, 0, 200)
Frame.Active = true
Frame.Draggable = true

Title.Name = "Title"
Title.Parent = Frame
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.BorderSizePixel = 0
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.GothamBold
Title.Text = "99 Forest Script v1.0"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14

CollectBtn.Name = "CollectBtn"
CollectBtn.Parent = Frame
CollectBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
CollectBtn.BorderSizePixel = 0
CollectBtn.Position = UDim2.new(0, 10, 0, 40)
CollectBtn.Size = UDim2.new(1, -20, 0, 30)
CollectBtn.Font = Enum.Font.Gotham
CollectBtn.Text = "Собрать все ресурсы"
CollectBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CollectBtn.TextSize = 12

AutoChopBtn.Name = "AutoChopBtn"
AutoChopBtn.Parent = Frame
AutoChopBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
AutoChopBtn.BorderSizePixel = 0
AutoChopBtn.Position = UDim2.new(0, 10, 0, 80)
AutoChopBtn.Size = UDim2.new(1, -20, 0, 30)
AutoChopBtn.Font = Enum.Font.Gotham
AutoChopBtn.Text = "Включить авто-рубку"
AutoChopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoChopBtn.TextSize = 12

ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Parent = Frame
ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Position = UDim2.new(0, 10, 0, 120)
ToggleBtn.Size = UDim2.new(1, -20, 0, 30)
ToggleBtn.Font = Enum.Font.Gotham
ToggleBtn.Text = "Скрыть/Показать меню"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 12

Status.Name = "Status"
Status.Parent = Frame
Status.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Status.BorderSizePixel = 0
Status.Position = UDim2.new(0, 10, 0, 160)
Status.Size = UDim2.new(1, -20, 0, 30)
Status.Font = Enum.Font.Gotham
Status.Text = "Статус: Готов"
Status.TextColor3 = Color3.fromRGB(0, 255, 0)
Status.TextSize = 12

-- Переменные
local autoChopEnabled = false
local chopConnection

-- Функция сбора ресурсов
local function collectResources()
    Status.Text = "Статус: Собираю ресурсы..."
    Status.TextColor3 = Color3.fromRGB(255, 255, 0)
    
    local resources = {
        "Bolt", "Tyre", "Sheet metal", "Broken microwave", 
        "UFO scrap", "Cultist gem", "Scrap", "Metal"
    }
    
    local character = Player.Character
    if not character then 
        Status.Text = "Статус: Нет персонажа!"
        Status.TextColor3 = Color3.fromRGB(255, 0, 0)
        return 
    end
    
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then 
        Status.Text = "Статус: Нет RootPart!"
        Status.TextColor3 = Color3.fromRGB(255, 0, 0)
        return 
    end

    local collected = 0
    for _, resourceName in pairs(resources) do
        for _, item in pairs(workspace:GetDescendants()) do
            if item:IsA("Part") and string.find(string.lower(item.Name), string.lower(resourceName)) then
                item.CFrame = root.CFrame + Vector3.new(
                    math.random(-5, 5),
                    math.random(3, 8),
                    math.random(-5, 5)
                )
                collected = collected + 1
                wait(0.05)
            end
        end
    end
    
    Status.Text = "Статус: Собрано "..collected.." объектов!"
    Status.TextColor3 = Color3.fromRGB(0, 255, 0)
end

-- Функция авто-рубки
local function startAutoChop()
    if autoChopEnabled then return end
    
    autoChopEnabled = true
    AutoChopBtn.Text = "Выключить авто-рубку"
    AutoChopBtn.BackgroundColor3 = Color3.fromRGB(80, 30, 30)
    Status.Text = "Статус: Авто-рубка включена"
    Status.TextColor3 = Color3.fromRGB(0, 255, 0)
    
    chopConnection = game:GetService("RunService").Heartbeat:Connect(function()
        local character = Player.Character
        if not character then return end
        
        local humanoid = character:FindFirstChild("Humanoid")
        local root = character:FindFirstChild("HumanoidRootPart")
        if not humanoid or not root then return end

        -- Поиск ближайшего дерева
        local closestTree = nil
        local closestDistance = 20 -- Максимальная дистанция
        
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and (string.find(string.lower(obj.Name), "tree") or string.find(string.lower(obj.Name), "wood")) then
                local trunk = obj:FindFirstChild("Trunk") or obj:FindFirstChild("Wood") or obj:FindFirstChild("Handle")
                if trunk and trunk:IsA("Part") then
                    local distance = (root.Position - trunk.Position).Magnitude
                    if distance < closestDistance then
                        closestDistance = distance
                        closestTree = trunk
                    end
                end
            end
        end
        
        -- Движение к дереву и рубка
        if closestTree then
            humanoid:MoveTo(closestTree.Position)
            
            -- Имитация атаки (может потребовать настройки под вашу игру)
            if closestDistance < 10 then
                -- Попытка срубить дерево
                closestTree.Parent:Destroy()
            end
        end
    end)
end

local function stopAutoChop()
    autoChopEnabled = false
    if chopConnection then
        chopConnection:Disconnect()
        chopConnection = nil
    end
    AutoChopBtn.Text = "Включить авто-рубку"
    AutoChopBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Status.Text = "Статус: Авто-рубка выключена"
    Status.TextColor3 = Color3.fromRGB(255, 255, 0)
end

-- Обработчики кнопок
CollectBtn.MouseButton1Click:Connect(collectResources)

AutoChopBtn.MouseButton1Click:Connect(function()
    if autoChopEnabled then
        stopAutoChop()
    else
        startAutoChop()
    end
end)

ToggleBtn.MouseButton1Click:Connect(function()
    Frame.Visible = not Frame.Visible
end)

-- Авто-сбор при запуске
wait(2)
collectResources()

-- Уведомление
print("99 Forest Script загружен!")
print("Используйте меню для управления функциями")
print("Используйте на свой страх и риск!")