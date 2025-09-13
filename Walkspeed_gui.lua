-- // Hitbox Expander Script (Obsidian) с Rainbow и автообновлением

-- // By Cheater26k & ChatGPT

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

local RunService = game:GetService("RunService")

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua"))()

-- Создаём окно

local Window = Library:CreateWindow({

Title = "by @SFXCL 99 nights",

Center = true,

AutoShow = true,

})

-- ======================================================

-- Hitbox Tab

-- ======================================================

local HitboxTab = Window:AddTab("Survival 99 Nights", "target", "Script by @SFXCL")

local HitboxBox = HitboxTab:AddLeftGroupbox("Hitbox Settings", "Adjust player hitboxes")

local hitboxEnabled = false

local hitboxSize = Vector3.new(5,5,5)

local hitboxTransparency = 0.7

local hitboxColor = Color3.fromRGB(255,0,0)

local rainbowMode = false

local hitboxObjects = {}

-- Функция применения хитбокса

local function applyHitbox(player)

if player == LocalPlayer then return end

if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then

local hrp = player.Character.HumanoidRootPart

if hitboxEnabled then

hrp.Size = hitboxSize

hrp.Transparency = hitboxTransparency

hrp.Color = hitboxColor

hrp.Material = Enum.Material.Neon

hrp.CanCollide = false

else

hrp.Size = Vector3.new(2,2,1)

hrp.Transparency = 1

hrp.Material = Enum.Material.Plastic

hrp.Color = Color3.fromRGB(255,255,255)

end

hitboxObjects[player] = hrp

end

end

-- Автоприменение на новых игроках

local function setupPlayer(plr)

plr.CharacterAdded:Connect(function()

task.wait(0.5)

applyHitbox(plr)

end)

end

for _, plr in pairs(Players:GetPlayers()) do

setupPlayer(plr)

end

Players.PlayerAdded:Connect(setupPlayer)

-- ======================================================

-- UI Elements Hitbox

-- ======================================================

HitboxBox:AddToggle("EnableHitbox", {

Text = "Enable Infinite Jump",

Default = false,

-- Основной код обработки прыжков остается прежним
game:GetService("UserInputService").JumpRequest:Connect(function()
    if infiniteJumpEnabled then
        game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

}

-- ======================================================

-- Hitbox Color Tab

-- ======================================================

local ColorTab = Window:AddTab("Hitbox Color", "palette", "Select preset hitbox colors")

local ColorBox = ColorTab:AddLeftGroupbox("Hitbox Colors", "Choose a color for all hitboxes")

local colors = {

Red = Color3.fromRGB(255,0,0),

Blue = Color3.fromRGB(0,0,255),

Green = Color3.fromRGB(0,255,0),

Yellow = Color3.fromRGB(255,255,0),

Purple = Color3.fromRGB(128,0,128),

Pink = Color3.fromRGB(255,105,180)

}

for name, color in pairs(colors) do

ColorBox:AddButton(name, function()

hitboxColor = color

for _, plr in pairs(Players:GetPlayers()) do

applyHitbox(plr)

end

end)

end

-- Rainbow Mode

ColorBox:AddToggle("RainbowHitbox", {

Text = "Rainbow Mode",

Default = false,

Callback = function(state)

rainbowMode = state

end

})

-- Rainbow updater

RunService.RenderStepped:Connect(function()

if rainbowMode then

local t = tick()

local color = Color3.fromHSV((t%5)/5, 1, 1)

for _, hrp in pairs(hitboxObjects) do

if hrp and hrp.Parent then

hrp.Color = color

end

end

end

end)

-- ======================================================

-- Credits Tab

-- ======================================================

local CreditTab = Window:AddTab("Credits", "star", "Credits")

local CreditBox = CreditTab:AddLeftGroupbox("Credits", "Information")

CreditBox:AddLabel("Script Survival 99 of nights, by @SFXCL")