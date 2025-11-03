-- Rayfield Interface Script
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Создание основного окна
local Window = Rayfield:CreateWindow({
    Name = "SANSTRO MENU",
    LoadingTitle = "Загрузка SANSTRO MENU...",
    LoadingSubtitle = "by Script Developer",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "SANSTRO_MENU"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false,
})

-- Создание вкладок
local ESPTab = Window:CreateTab("ESP", 4483362458)
local AimbotTab = Window:CreateTab("Aimbot", 4483362458)
local MoreTab = Window:CreateTab("More", 4483362458)

-- Переменные для ESP
local ESP = {
    Tracers = false,
    Box = false,
    Health = false,
    Name = false
}

local espObjects = {}

-- Функция для создания ESP
function createESP(player)
    if player == game.Players.LocalPlayer then return end
    
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local head = character:FindFirstChild("Head")
    
    if not humanoid or not head then return end
    
    -- Очистка старых ESP объектов
    if espObjects[player] then
        for _, obj in pairs(espObjects[player]) do
            if obj then
                obj:Remove()
            end
        end
    end
    
    espObjects[player] = {}
    
    -- ESP Tracers
    if ESP.Tracers then
        local tracer = Drawing.new("Line")
        tracer.Visible = false
        tracer.Color = Color3.fromRGB(255, 0, 0)
        tracer.Thickness = 1
        tracer.Transparency = 1
        table.insert(espObjects[player], tracer)
    end
    
    -- ESP Box
    if ESP.Box then
        local box = Drawing.new("Square")
        box.Visible = false
        box.Color = Color3.fromRGB(255, 0, 0)
        box.Thickness = 1
        box.Filled = false
        table.insert(espObjects[player], box)
    end
    
    -- ESP Health
    if ESP.Health then
        local healthText = Drawing.new("Text")
        healthText.Visible = false
        healthText.Color = Color3.fromRGB(0, 255, 0) -- Зеленый цвет
        healthText.Size = 13
        healthText.Center = true
        healthText.Outline = true
        table.insert(espObjects[player], healthText)
    end
    
    -- ESP Name
    if ESP.Name then
        local nameText = Drawing.new("Text")
        nameText.Visible = false
        nameText.Color = Color3.fromRGB(255, 0, 0)
        nameText.Size = 13
        nameText.Center = true
        nameText.Outline = true
        table.insert(espObjects[player], nameText)
    end
end

-- Функция обновления ESP
function updateESP()
    for player, objects in pairs(espObjects) do
        local character = player.Character
        local humanoid = character and character:FindFirstChild("Humanoid")
        local head = character and character:FindFirstChild("Head")
        
        -- Проверка жив ли игрок
        if character and humanoid and head and humanoid.Health > 0 then
            local vector, onScreen = workspace.CurrentCamera:WorldToViewportPoint(head.Position)
            
            if onScreen then
                local index = 1
                
                -- Обновление Tracers
                if ESP.Tracers and objects[index] then
                    objects[index].From = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y)
                    objects[index].To = Vector2.new(vector.X, vector.Y)
                    objects[index].Visible = true
                    index = index + 1
                end
                
                -- Обновление Box
                if ESP.Box and objects[index] then
                    local scale = 1 / (vector.Z * math.tan(math.rad(workspace.CurrentCamera.FieldOfView * 0.5)) * 2) * 100
                    local width, height = math.floor(40 * scale), math.floor(55 * scale)
                    objects[index].Position = Vector2.new(math.floor(vector.X - width * 0.5), math.floor(vector.Y - height * 0.5))
                    objects[index].Size = Vector2.new(width, height)
                    objects[index].Visible = true
                    index = index + 1
                end
                
                -- Обновление Health
                if ESP.Health and objects[index] then
                    objects[index].Position = Vector2.new(math.floor(vector.X), math.floor(vector.Y + 30))
                    objects[index].Text = "HP: " .. math.floor(humanoid.Health)
                    objects[index].Visible = true
                    index = index + 1
                end
                
                -- Обновление Name
                if ESP.Name and objects[index] then
                    objects[index].Position = Vector2.new(math.floor(vector.X), math.floor(vector.Y - 30))
                    objects[index].Text = player.Name
                    objects[index].Visible = true
                end
            else
                -- Скрыть ESP если игрок не на экране
                for _, obj in pairs(objects) do
                    if obj then
                        obj.Visible = false
                    end
                end
            end
        else
            -- Удалить ESP если игрок умер или не существует
            for _, obj in pairs(objects) do
                if obj then
                    obj.Visible = false
                    obj:Remove()
                end
            end
            espObjects[player] = nil
        end
    end
end

-- Переменные для Aimbot
local Aimbot = {
    Enabled = false,
    FOV = 50,
    TargetPart = "Head" -- По умолчанию цель - голова
}

local circle = Drawing.new("Circle")
circle.Visible = false
circle.Color = Color3.fromRGB(255, 0, 0)
circle.Thickness = 1
circle.NumSides = 100
circle.Radius = Aimbot.FOV
circle.Filled = false
circle.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)

-- Функция для Aimbot
function aimbot()
    if not Aimbot.Enabled then return end
    
    local closestPlayer = nil
    local closestDistance = Aimbot.FOV

    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            local character = player.Character
            local humanoid = character and character:FindFirstChild("Humanoid")
            local targetPart = character and character:FindFirstChild(Aimbot.TargetPart)
            
            -- Проверка что игрок жив и существует
            if character and humanoid and targetPart and humanoid.Health > 0 then
                local vector, onScreen = workspace.CurrentCamera:WorldToViewportPoint(targetPart.Position)
                
                if onScreen then
                    local distance = (Vector2.new(vector.X, vector.Y) - circle.Position).Magnitude
                    
                    if distance < closestDistance then
                        -- Проверка на видимость (не через стены)
                        local raycastParams = RaycastParams.new()
                        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                        raycastParams.FilterDescendantsInstances = {game.Players.LocalPlayer.Character}
                        
                        local raycastResult = workspace:Raycast(
                            workspace.CurrentCamera.CFrame.Position, 
                            (targetPart.Position - workspace.CurrentCamera.CFrame.Position).Unit * 1000, 
                            raycastParams
                        )
                        
                        if raycastResult and raycastResult.Instance:IsDescendantOf(character) then
                            closestPlayer = player
                            closestDistance = distance
                        end
                    end
                end
            end
        end
    end
    
    if closestPlayer and closestPlayer.Character then
        local targetPart = closestPlayer.Character:FindFirstChild(Aimbot.TargetPart)
        if targetPart then
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, targetPart.Position)
        end
    end
end

-- Переменные для More раздела
local SpeedHack = {
    Enabled = false,
    Speed = 16
}

local InfinityJump = false
local AntiAFK = false
local NoClip = false
local NoRecoil = false

-- Функция для SpeedHack
function updateSpeedHack()
    if SpeedHack.Enabled then
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.WalkSpeed = SpeedHack.Speed
        end
    else
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.WalkSpeed = 16 -- Стандартная скорость
        end
    end
end

-- Функция для Infinity Jump
game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfinityJump and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
        game.Players.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Функция для AntiAFK
if AntiAFK then
    local VirtualUser = game:GetService("VirtualUser")
    game.Players.LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end

-- Функция для NoClip
local noclipConnection
function updateNoClip()
    if NoClip then
        local character = game.Players.LocalPlayer.Character
        if character then
            -- Отключаем коллизию для всех частей персонажа
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
            
            -- Постоянное обновление NoClip
            if noclipConnection then
                noclipConnection:Disconnect()
            end
            
            noclipConnection = game:GetService("RunService").Stepped:Connect(function()
                if character then
                    for _, part in pairs(character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                else
                    noclipConnection:Disconnect()
                end
            end)
        end
    else
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        
        -- Восстанавливаем коллизию
        local character = game.Players.LocalPlayer.Character
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

-- Функция для NoRecoil
function updateNoRecoil()
    if NoRecoil then
        -- Отключаем отдачу для всех инструментов и оружия
        for _, tool in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
            if tool:IsA("Tool") then
                -- Ищем модульные скрипты, которые могут управлять отдачей
                for _, script in pairs(tool:GetDescendants()) do
                    if script:IsA("ModuleScript") then
                        -- Можно добавить специфичную логику для разных игр
                    end
                end
            end
        end
    end
end

-- Создание элементов вкладки ESP
ESPTab:CreateSection("ESP Настройки")

ESPTab:CreateToggle({
    Name = "ESP Tracers",
    CurrentValue = false,
    Flag = "ESP_Tracers",
    Callback = function(Value)
        ESP.Tracers = Value
        if not Value then
            for player, objects in pairs(espObjects) do
                if objects[1] then
                    objects[1].Visible = false
                end
            end
        else
            -- Пересоздать ESP для всех игроков при включении
            for _, player in pairs(game.Players:GetPlayers()) do
                createESP(player)
            end
        end
    end,
})

ESPTab:CreateToggle({
    Name = "ESP Box",
    CurrentValue = false,
    Flag = "ESP_Box",
    Callback = function(Value)
        ESP.Box = Value
        if not Value then
            for player, objects in pairs(espObjects) do
                if objects[2] then
                    objects[2].Visible = false
                end
            end
        else
            for _, player in pairs(game.Players:GetPlayers()) do
                createESP(player)
            end
        end
    end,
})

ESPTab:CreateToggle({
    Name = "ESP Health",
    CurrentValue = false,
    Flag = "ESP_Health",
    Callback = function(Value)
        ESP.Health = Value
        if not Value then
            for player, objects in pairs(espObjects) do
                if objects[3] then
                    objects[3].Visible = false
                end
            end
        else
            for _, player in pairs(game.Players:GetPlayers()) do
                createESP(player)
            end
        end
    end,
})

ESPTab:CreateToggle({
    Name = "ESP Name",
    CurrentValue = false,
    Flag = "ESP_Name",
    Callback = function(Value)
        ESP.Name = Value
        if not Value then
            for player, objects in pairs(espObjects) do
                if objects[4] then
                    objects[4].Visible = false
                end
            end
        else
            for _, player in pairs(game.Players:GetPlayers()) do
                createESP(player)
            end
        end
    end,
})

-- Создание элементов вкладки Aimbot
AimbotTab:CreateSection("Aimbot Настройки")

AimbotTab:CreateToggle({
    Name = "Aimbot",
    CurrentValue = false,
    Flag = "Aimbot_Enabled",
    Callback = function(Value)
        Aimbot.Enabled = Value
        circle.Visible = Value
    end,
})

AimbotTab:CreateSlider({
    Name = "FOV",
    Range = {10, 200},
    Increment = 5,
    Suffix = "px",
    CurrentValue = 50,
    Flag = "Aimbot_FOV",
    Callback = function(Value)
        Aimbot.FOV = Value
        circle.Radius = Value
    end,
})

-- Подменю выбора цели для Aimbot
local TargetSelection = AimbotTab:CreateSection("Выбор цели")

-- Создаем мини-меню с кнопками выбора цели
AimbotTab:CreateButton({
    Name = "Head (Голова)",
    Callback = function()
        Aimbot.TargetPart = "Head"
        Rayfield:Notify({
            Title = "Aimbot Target",
            Content = "Цель установлена: Head",
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

AimbotTab:CreateButton({
    Name = "Body (Тело)",
    Callback = function()
        Aimbot.TargetPart = "HumanoidRootPart"
        Rayfield:Notify({
            Title = "Aimbot Target",
            Content = "Цель установлена: Body",
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

-- Создание элементов вкладки More
MoreTab:CreateSection("Speed Hack")

MoreTab:CreateToggle({
    Name = "Speed Hack",
    CurrentValue = false,
    Flag = "SpeedHack_Enabled",
    Callback = function(Value)
        SpeedHack.Enabled = Value
        updateSpeedHack()
    end,
})

MoreTab:CreateSlider({
    Name = "Скорость",
    Range = {16, 100},
    Increment = 5,
    Suffix = "speed",
    CurrentValue = 16,
    Flag = "SpeedHack_Speed",
    Callback = function(Value)
        SpeedHack.Speed = Value
        updateSpeedHack()
    end,
})

MoreTab:CreateSection("Другие функции")

MoreTab:CreateToggle({
    Name = "Infinity Jump",
    CurrentValue = false,
    Flag = "InfinityJump",
    Callback = function(Value)
        InfinityJump = Value
    end,
})

MoreTab:CreateToggle({
    Name = "Anti AFK",
    CurrentValue = false,
    Flag = "AntiAFK",
    Callback = function(Value)
        AntiAFK = Value
        if Value then
            local VirtualUser = game:GetService("VirtualUser")
            game.Players.LocalPlayer.Idled:Connect(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
        end
    end,
})

MoreTab:CreateToggle({
    Name = "NoClip",
    CurrentValue = false,
    Flag = "NoClip",
    Callback = function(Value)
        NoClip = Value
        updateNoClip()
    end,
})

MoreTab:CreateToggle({
    Name = "No Recoil",
    CurrentValue = false,
    Flag = "NoRecoil",
    Callback = function(Value)
        NoRecoil = Value
        updateNoRecoil()
        if Value then
            Rayfield:Notify({
                Title = "No Recoil",
                Content = "Отдача отключена для всего оружия",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end,
})

-- Инициализация ESP для всех игроков
for _, player in pairs(game.Players:GetPlayers()) do
    createESP(player)
end

-- Обработка новых игроков
game.Players.PlayerAdded:Connect(function(player)
    createESP(player)
end)

-- Обработка вышедших игроков
game.Players.PlayerRemoving:Connect(function(player)
    if espObjects[player] then
        for _, obj in pairs(espObjects[player]) do
            if obj then
                obj:Remove()
            end
        end
        espObjects[player] = nil
    end
end)

-- Обработка смерти/возрождения игроков
game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        wait(1) -- Небольшая задержка для загрузки персонажа
        createESP(player)
    end)
end)

-- Для уже существующих игроков
for _, player in pairs(game.Players:GetPlayers()) do
    if player.Character then
        createESP(player)
    end
    player.CharacterAdded:Connect(function(character)
        wait(1)
        createESP(player)
    end)
end

-- Обновление SpeedHack при изменении персонажа
game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
    wait(1)
    updateSpeedHack()
    updateNoClip()
end)

-- Обновление NoClip при изменении персонажа
game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
    wait(1)
    if NoClip then
        updateNoClip()
    end
end)

-- Основной цикл обновления
game:GetService("RunService").RenderStepped:Connect(function()
    updateESP()
    aimbot()
end)

-- Обновление позиции круга FOV при изменении размера экрана
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
    circle.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)
end)

Rayfield:LoadConfiguration()

-- Уведомление о загрузке
Rayfield:Notify({
    Title = "SANSTRO MENU",
    Content = "Меню успешно загружено!",
    Duration = 5,
    Image = 4483362458,
})