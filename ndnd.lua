-- VEX OP - 99 Nights in the Forest

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "VEX OP - 99 Nights in the Forest",
    LoadingTitle = "VEX OP",
    LoadingSubtitle = "by VEX HUB",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "VEX OP",
        FileName = "99 Nights"
    }
})

-- Main Tab
local MainTab = Window:CreateTab("Main", "rbxassetid://4483345998")

local AutoSection = MainTab:CreateSection("Auto")
local BringSection = MainTab:CreateSection("Bring")
local CombatSection = MainTab:CreateSection("Combat")
local PlayerSection = MainTab:CreateSection("Player")
local EspSection = MainTab:CreateSection("Esp")
local TeleportSection = MainTab:CreateSection("Teleport")

-- Medical Items Tab
local MedicalTab = Window:CreateTab("Medical Items", "rbxassetid://4483345998")
MedicalTab:CreateSection("Bring Medical Items")
MedicalTab:CreateLabel("Please unlock first zone before trying to Bring!")

-- Equipment Tab
local EquipmentTab = Window:CreateTab("Equipment", "rbxassetid://4483345998")

local SelectEquipmentSection = EquipmentTab:CreateSection("Select Equipment Items")
EquipmentTab:CreateLabel("Choose items to bring")

local BringEquipmentSection = EquipmentTab:CreateSection("Bring Equipment Items")
EquipmentTab:CreateLabel("Please unlock first zone before trying to Bring!")

-- Пример добавления функциональных элементов (замените на свои функции)
AutoSection:CreateToggle({
    Name = "Авто-ферма",
    CurrentValue = false,
    Flag = "AutoFarm",
    Callback = function(Value)
        -- Ваш код здесь
    end,
})

BringSection:CreateButton({
    Name = "Принести предметы",
    Callback = function()
        -- Ваш код здесь
    end,
})

CombatSection:CreateToggle({
    Name = "Бесконечные патроны",
    CurrentValue = false,
    Flag = "InfAmmo",
    Callback = function(Value)
        -- Ваш код здесь
    end,
})

PlayerSection:CreateSlider({
    Name = "Скорость персонажа",
    Range = {16, 200},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = 16,
    Flag = "WalkSpeed",
    Callback = function(Value)
        -- Ваш код здесь
    end,
})

EspSection:CreateToggle({
    Name = "ESP игроков",
    CurrentValue = false,
    Flag = "PlayerESP",
    Callback = function(Value)
        -- Ваш код здесь
    end,
})

TeleportSection:CreateDropdown({
    Name = "Локации для телепорта",
    Options = {"Зона 1", "Зона 2", "Зона 3"},
    CurrentOption = "Зона 1",
    Flag = "TeleportLocation",
    Callback = function(Option)
        -- Ваш код здесь
    end,
})

Rayfield:LoadConfiguration()