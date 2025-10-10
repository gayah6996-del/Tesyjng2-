-- Crystal Hub for Roblox
-- by shinichii.

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Crystal Hub",
    LoadingTitle = "Crystal Hub",
    LoadingSubtitle = "by shinichii",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "CrystalHub",
        FileName = "Config"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false,
})

-- Auto Farm Tree Tab
local AutoFarmTab = Window:CreateTab("Auto Farm Tree", "rbxassetid://4483345998")

local AutoFarmSection = AutoFarmTab:CreateSection("Main")

local AutoClickToggle = AutoFarmTab:CreateToggle({
    Name = "Auto Click Farm",
    CurrentValue = false,
    Flag = "AutoClickToggle",
    Callback = function(Value)
        if Value then
            -- Включить автокликер
            getgenv().AutoClick = true
            while getgenv().AutoClick do
                -- Здесь код автокликера
                -- Например: кликнуть на дерево
                task.wait(0.1)
            end
        else
            -- Выключить автокликер
            getgenv().AutoClick = false
        end
    end,
})

local KillToggle = AutoFarmTab:CreateToggle({
    Name = "Kill",
    CurrentValue = false,
    Flag = "KillToggle",
    Callback = function(Value)
        if Value then
            -- Включить автоматическое убийство
            getgenv().AutoKill = true
            while getgenv().AutoKill do
                -- Здесь код автоматического убийства
                task.wait(0.1)
            end
        else
            -- Выключить автоматическое убийство
            getgenv().AutoKill = false
        end
    end,
})

-- Bring Tab
local BringTab = Window:CreateTab("Bring", "rbxassetid://4483345998")

local BringSection = BringTab:CreateSection("Bring")

local KillAuraToggle = BringTab:CreateToggle({
    Name = "Kill Aura",
    CurrentValue = false,
    Flag = "KillAuraToggle",
    Callback = function(Value)
        if Value then
            -- Включить килл-ауру
            getgenv().KillAura = true
            while getgenv().KillAura do
                -- Здесь код килл-ауры
                local radius = Rayfield.Flags["KillAuraRadius"]
                -- Использовать радиус для килл-ауры
                task.wait(0.1)
            end
        else
            -- Выключить килл-ауру
            getgenv().KillAura = false
        end
    end,
})

-- Teleport Tab
local TeleportTab = Window:CreateTab("Teleport", "rbxassetid://4483345998")

local TeleportSection = TeleportTab:CreateSection("Teleport")

local KillAuraRadius = TeleportTab:CreateSlider({
    Name = "Kill Aura Radius",
    Range = {0, 500},
    Increment = 10,
    Suffix = "studs",
    CurrentValue = 200,
    Flag = "KillAuraRadius",
    Callback = function(Value)
        -- Обновить радиус килл-ауры
        print("Kill Aura Radius set to: " .. Value)
    end,
})

-- Visual Tab
local VisualTab = Window:CreateTab("Visual", "rbxassetid://4483345998")

local VisualSection = VisualTab:CreateSection("Visual")

local InfRannaToggle = VisualTab:CreateToggle({
    Name = "Inf Ranna Kill Aura",
    CurrentValue = false,
    Flag = "InfRannaToggle",
    Callback = function(Value)
        if Value then
            -- Включить визуальный эффект
            getgenv().InfRanna = true
            while getgenv().InfRanna do
                -- Здесь код визуального эффекта килл-ауры
                task.wait(0.1)
            end
        else
            -- Выключить визуальный эффект
            getgenv().InfRanna = false
        end
    end,
})

-- Уведомление о загрузке
Rayfield:Notify({
    Title = "Crystal Hub Loaded",
    Content = "Menu successfully loaded!",
    Duration = 5,
    Image = "rbxassetid://4483345998",
})

print("Crystal Hub by shinichii. loaded successfully!")