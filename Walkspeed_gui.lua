local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local LocalPlayer = Players.LocalPlayer

if CoreGui:FindFirstChild("TRASHNEVERDIE_GUI") then
    CoreGui.TRASHNEVERDIE_GUI:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "TRASHNEVERDIE_GUI"
gui.Parent = CoreGui
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

local clickSound = Instance.new("Sound", SoundService)
clickSound.SoundId = "rbxassetid://9118823105"
clickSound.Volume = 1
local function playClick() clickSound:Play() end

local function addCorner(obj, r)
    local c = Instance.new("UICorner", obj)
    c.CornerRadius = UDim.new(0, r)
end

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 400, 0, 350)
main.Position = UDim2.new(0.5, -150, 0.5, -140)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.BackgroundTransparency = 0.1
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
addCorner(main, 12)

local title = Instance.new("TextLabel", main)
title.Name = "TitleLabel"
title.Size = UDim2.new(1, -40, 0, 40)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "TRASHNEVERDIE MENU"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextScaled = true
title.Font = Enum.Font.GothamBold

local minimize = Instance.new("TextButton", main)
minimize.Size = UDim2.new(0, 30, 0, 30)
minimize.Position = UDim2.new(1, -35, 0, 5)
minimize.BackgroundTransparency = 1
minimize.Text = "-"
minimize.TextColor3 = Color3.new(1, 1, 1)
minimize.Font = Enum.Font.GothamBold
minimize.TextScaled = true
addCorner(minimize, 6)

-- Переключающая кнопка
local toggleBtn = Instance.new("TextButton", main)
toggleBtn.Size = UDim2.new(0, 30, 0, 30)
toggleBtn.Position = UDim2.new(1, -65, 0, 5)
toggleBtn.BackgroundTransparency = 1
toggleBtn.Text = "◉" -- символ, обозначающий кнопку переключателя
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextScaled = true
addCorner(toggleBtn, 6)

-- Обработчик события клика для переключающей кнопки
toggleBtn.MouseButton1Click:Connect(function()
    playClick()
    main.Visible = not main.Visible -- меняем состояние видимости окна
end)

local toggled, funcs, btns = {}, {}, {}
local minimizedState = false
local names = {"GOD MODE", "SPEEDHACK", "NOCLIP", "INFINITY JUMP", "ESP"}

for i, name in ipairs(names) do
    local btn = Instance.new("TextButton", main)
    btn.Size = UDim2.new(1, -20, 0, 35)
    btn.Position = UDim2.new(0, 10, 0, 45 + (i - 1) * 42)
    btn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    btn.Text = name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    addCorner(btn, 8)
    toggled[name] = false
    btn.MouseButton1Click:Connect(function()
        playClick()
        toggled[name] = not toggled[name]
        btn.BackgroundColor3 = toggled[name] and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        if funcs[name] then funcs[name](toggled[name]) end
    end)
    btns[name] = btn
end

minimize.MouseButton1Click:Connect(function()
    playClick()
    minimizedState = not minimizedState
    for _, b in pairs(btns) do b.Visible = not minimizedState end
    main.Size = minimizedState and UDim2.new(0, 300, 0, 40) or UDim2.new(0, 300, 0, 280)
end)

funcs["GOD MODE"] = function(s)
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.MaxHealth = math.huge
        hum.Health = math.huge
        if s then
            hum.HealthChanged:Connect(function()
                hum.Health = hum.MaxHealth
            end)
        end
    end
end

local antiFallConn
funcs["SPEEDHACK"] = function(s)
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = s and 100 or 16
        if s then
            antiFallConn = RunService.Stepped:Connect(function()
                hum:ChangeState(Enum.HumanoidStateType.Seated)
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end)
        elseif antiFallConn then
            antiFallConn:Disconnect()
        end
    end
end

local noclipConn
funcs["NOCLIP"] = function(s)
    if s then
        noclipConn = RunService.Stepped:Connect(function()
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    elseif noclipConn then
        noclipConn:Disconnect()
    end
end