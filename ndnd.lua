-- Crystal Hub - Simple Version
-- by shinichii.

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Создание интерфейса
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CrystalHub"
ScreenGui.Parent = Player.PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0, 10, 0, 10)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Title.Text = "Crystal Hub - by shinichii"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Parent = MainFrame

-- Auto Farm Tree Section
local AutoFarmLabel = Instance.new("TextLabel")
AutoFarmLabel.Size = UDim2.new(1, 0, 0, 20)
AutoFarmLabel.Position = UDim2.new(0, 0, 0, 35)
AutoFarmLabel.BackgroundTransparency = 1
AutoFarmLabel.Text = "Auto Farm Tree:"
AutoFarmLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoFarmLabel.TextXAlignment = Enum.TextXAlignment.Left
AutoFarmLabel.Parent = MainFrame

local AutoClickButton = Instance.new("TextButton")
AutoClickButton.Size = UDim2.new(0.9, 0, 0, 25)
AutoClickButton.Position = UDim2.new(0.05, 0, 0, 60)
AutoClickButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
AutoClickButton.Text = "Auto Click Farm: OFF"
AutoClickButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoClickButton.Parent = MainFrame

local KillButton = Instance.new("TextButton")
KillButton.Size = UDim2.new(0.9, 0, 0, 25)
KillButton.Position = UDim2.new(0.05, 0, 0, 90)
KillButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
KillButton.Text = "Kill: OFF"
KillButton.TextColor3 = Color3.fromRGB(255, 255, 255)
KillButton.Parent = MainFrame

-- Bring Section
local BringLabel = Instance.new("TextLabel")
BringLabel.Size = UDim2.new(1, 0, 0, 20)
BringLabel.Position = UDim2.new(0, 0, 0, 130)
BringLabel.BackgroundTransparency = 1
BringLabel.Text = "Bring:"
BringLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
BringLabel.TextXAlignment = Enum.TextXAlignment.Left
BringLabel.Parent = MainFrame

local KillAuraButton = Instance.new("TextButton")
KillAuraButton.Size = UDim2.new(0.9, 0, 0, 25)
KillAuraButton.Position = UDim2.new(0.05, 0, 0, 155)
KillAuraButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
KillAuraButton.Text = "Kill Aura: OFF"
KillAuraButton.TextColor3 = Color3.fromRGB(255, 255, 255)
KillAuraButton.Parent = MainFrame

-- Teleport Section
local TeleportLabel = Instance.new("TextLabel")
TeleportLabel.Size = UDim2.new(1, 0, 0, 20)
TeleportLabel.Position = UDim2.new(0, 0, 0, 195)
TeleportLabel.BackgroundTransparency = 1
TeleportLabel.Text = "Teleport:"
TeleportLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportLabel.TextXAlignment = Enum.TextXAlignment.Left
TeleportLabel.Parent = MainFrame

local RadiusLabel = Instance.new("TextLabel")
RadiusLabel.Size = UDim2.new(1, 0, 0, 20)
RadiusLabel.Position = UDim2.new(0, 0, 0, 220)
RadiusLabel.BackgroundTransparency = 1
RadiusLabel.Text = "Kill Aura Radius: 200"
RadiusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
RadiusLabel.TextXAlignment = Enum.TextXAlignment.Left
RadiusLabel.Parent = MainFrame

-- Visual Section
local VisualLabel = Instance.new("TextLabel")
VisualLabel.Size = UDim2.new(1, 0, 0, 20)
VisualLabel.Position = UDim2.new(0, 0, 0, 260)
VisualLabel.BackgroundTransparency = 1
VisualLabel.Text = "Visual:"
VisualLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
VisualLabel.TextXAlignment = Enum.TextXAlignment.Left
VisualLabel.Parent = MainFrame

local InfRannaButton = Instance.new("TextButton")
InfRannaButton.Size = UDim2.new(0.9, 0, 0, 25)
InfRannaButton.Position = UDim2.new(0.05, 0, 0, 285)
InfRannaButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
InfRannaButton.Text = "Inf Ranna Kill Aura: OFF"
InfRannaButton.TextColor3 = Color3.fromRGB(255, 255, 255)
InfRannaButton.Parent = MainFrame

-- Функции
local AutoClick = false
AutoClickButton.MouseButton1Click:Connect(function()
    AutoClick = not AutoClick
    AutoClickButton.Text = "Auto Click Farm: " .. (AutoClick and "ON" or "OFF")
    AutoClickButton.BackgroundColor3 = AutoClick and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(80, 80, 80)
    
    while AutoClick do
        -- Код автокликера
        print("Auto Click Farm running...")
        wait(0.1)
    end
end)

local AutoKill = false
KillButton.MouseButton1Click:Connect(function()
    AutoKill = not AutoKill
    KillButton.Text = "Kill: " .. (AutoKill and "ON" or "OFF")
    KillButton.BackgroundColor3 = AutoKill and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(80, 80, 80)
    
    while AutoKill do
        -- Код автоматического убийства
        print("Auto Kill running...")
        wait(0.1)
    end
end)

local KillAura = false
KillAuraButton.MouseButton1Click:Connect(function()
    KillAura = not KillAura
    KillAuraButton.Text = "Kill Aura: " .. (KillAura and "ON" or "OFF")
    KillAuraButton.BackgroundColor3 = KillAura and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(80, 80, 80)
    
    while KillAura do
        -- Код килл-ауры
        print("Kill Aura running...")
        wait(0.1)
    end
end)

local InfRanna = false
InfRannaButton.MouseButton1Click:Connect(function()
    InfRanna = not InfRanna
    InfRannaButton.Text = "Inf Ranna Kill Aura: " .. (InfRanna and "ON" or "OFF")
    InfRannaButton.BackgroundColor3 = InfRanna and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(80, 80, 80)
    
    while InfRanna do
        -- Код визуального эффекта
        print("Inf Ranna Kill Aura running...")
        wait(0.1)
    end
end)

print("Crystal Hub by shinichii. loaded successfully!")