-- Основной скрипт авторубки
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local IsAutoChopping = false
local ChopConnection = nil

-- Функция для поиска деревьев в радиусе 200 метров
function FindTrees()
    local trees = {}
    local maxDistance = 200
    
    -- Ищем все части с названием "Tree", "Wood", или другими связанными с деревьями
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Part") or obj:IsA("MeshPart") then
            local name = obj.Name:lower()
            if name:find("tree") or name:find("wood") or name:find("log") then
                local distance = (character.HumanoidRootPart.Position - obj.Position).Magnitude
                if distance <= maxDistance then
                    table.insert(trees, obj)
                end
            end
        end
    end
    
    return trees
end

-- Функция проверки наличия топора в инвентаре
function HasAxe()
    local backpack = player:FindFirstChild("Backpack")
    local characterTools = character:GetChildren()
    
    -- Проверяем инструменты в инвентаре
    if backpack then
        for _, tool in pairs(backpack:GetChildren()) do
            local toolName = tool.Name:lower()
            if toolName:find("axe") or toolName:find("tool") then
                return true
            end
        end
    end
    
    -- Проверяем инструменты в руках
    for _, tool in pairs(characterTools) do
        if tool:IsA("Tool") then
            local toolName = tool.Name:lower()
            if toolName:find("axe") or toolName:find("tool") then
                return true
            end
        end
    end
    
    return false
end

-- Основная функция рубки
function AutoChop()
    if not IsAutoChopping then return end
    
    if not HasAxe() then
        print("Топор не найден! Экипируйте топор.")
        return
    end
    
    local trees = FindTrees()
    
    if #trees == 0 then
        print("Деревья не найдены в радиусе 200 метров!")
        return
    end
    
    -- Рубка ближайшего дерева
    local nearestTree = nil
    local minDistance = math.huge
    
    for _, tree in pairs(trees) do
        local distance = (character.HumanoidRootPart.Position - tree.Position).Magnitude
        if distance < minDistance then
            minDistance = distance
            nearestTree = tree
        end
    end
    
    if nearestTree then
        -- Симуляция рубки (активируем инструмент)
        local backpack = player:FindFirstChild("Backpack")
        local axe = nil
        
        -- Ищем топор в инвентаре
        if backpack then
            for _, tool in pairs(backpack:GetChildren()) do
                local toolName = tool.Name:lower()
                if toolName:find("axe") then
                    axe = tool
                    break
                end
            end
        end
        
        -- Экипируем топор если нашли
        if axe then
            axe.Parent = character
        end
        
        -- Активируем анимацию рубки
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid:EquipTool(axe)
        end
        
        -- Симуляция клика для рубки
        if axe and axe:IsA("Tool") then
            axe:Activate()
        end
        
        print("Рубим дерево: " .. nearestTree.Name)
    end
end

-- Функция для начала/остановки авторубки
function ToggleAutoChop()
    IsAutoChopping = not IsAutoChopping
    
    if IsAutoChopping then
        print("Авторубка включена!")
        -- Запускаем цикл рубки
        ChopConnection = game:GetService("RunService").Heartbeat:Connect(function()
            AutoChop()
        end)
    else
        print("Авторубка выключена!")
        if ChopConnection then
            ChopConnection:Disconnect()
            ChopConnection = nil
        end
    end
end

-- Создаем GUI меню
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local ToggleButton = Instance.new("TextButton")
local StatusLabel = Instance.new("TextLabel")

ScreenGui.Parent = player.PlayerGui

Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 200, 0, 100)
Frame.Position = UDim2.new(0, 10, 0, 10)
Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

ToggleButton.Parent = Frame
ToggleButton.Size = UDim2.new(0, 180, 0, 40)
ToggleButton.Position = UDim2.new(0, 10, 0, 10)
ToggleButton.Text = "Включить авторубку"
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.MouseButton1Click:Connect(ToggleAutoChop)

StatusLabel.Parent = Frame
StatusLabel.Size = UDim2.new(0, 180, 0, 40)
StatusLabel.Position = UDim2.new(0, 10, 0, 60)
StatusLabel.Text = "Статус: Выключено"
StatusLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Обновление статуса
while true do
    if IsAutoChopping then
        ToggleButton.Text = "Выключить авторубку"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
        StatusLabel.Text = "Статус: Включено"
    else
        ToggleButton.Text = "Включить авторубку"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
        StatusLabel.Text = "Статус: Выключено"
    end
    wait(0.1)
end