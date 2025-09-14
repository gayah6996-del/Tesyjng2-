local Player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")local RunService = game:GetService("RunService")-- Создаем GUI
local ScreenGui = Instance.new("ScreenGui", Player.PlayerGui)local MainFrame = Instance.new("Frame", ScreenGui)local Tab1 = Instance.new("TextButton", MainFrame)local Tab2 = Instance.new("TextButton", MainFrame)local MainTab = Instance.new("Frame", MainFrame)local VisualTab = Instance.new("Frame", MainFrame)-- Настройки GUI
MainFrame.Size = UDim2.new(0.3, 0, 0.5, 0)MainFrame.Position = UDim2.new(0.35, 0, 0.25, 0)MainFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)Tab1.Size = UDim2.new(1, 0, 0.1, 0)Tab1.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)Tab1.Text ="Main"Tab2.Size = UDim2.new(1, 0, 0.1, 0)Tab2.Position = UDim2.new(0, 0, 0.1, 0)Tab2.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)Tab2.Text ="Visual"MainTab.Size = UDim2.new(1, 0, 0.9, 0)VisualTab.Size = UDim2.new(1, 0, 0.9, 0)VisualTab.Position = UDim2.new(0, 0, 0.1, 0)-- Обработчик переключения вкладок
Tab1.MouseButton1Click:Connect(function()    MainTab.Visible = true
    VisualTab.Visible = false
end)Tab2.MouseButton1Click:Connect(function()    MainTab.Visible = false
    VisualTab.Visible = true
end)-- Функции в Main Tab
local function enableInfinityJump()    UIS.JumpRequest:Connect(function()        if Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
            Player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")        end
    end)end

local function enableSpeedHack()    local speed = 100 -- Задайте желаемую скорость
    Player.Character.Humanoid.WalkSpeed = speed
end

local function enableNoClip()    local function noClip()        if Player.Character then
            for_, v in pairs(Player.Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end
    end

    RunService.Stepped:Connect(noClip)end

-- Кнопки для функций в Main Tab
local InfinityJumpButton = Instance.new("TextButton", MainTab)InfinityJumpButton.Size = UDim2.new(1, 0, 0.1, 0)InfinityJumpButton.Text ="Infinity Jump"InfinityJumpButton.MouseButton1Click:Connect(enableInfinityJump)local SpeedHackButton = Instance.new("TextButton", MainTab)SpeedHackButton.Size = UDim2.new(1, 0, 0.1, 0)SpeedHackButton.Position = UDim2.new(0, 0, 0.1, 0)SpeedHackButton.Text ="Speed Hack"SpeedHackButton.MouseButton1Click:Connect(enableSpeedHack)local NoClipButton = Instance.new("TextButton", MainTab)NoClipButton.Size = UDim2.new(1, 0, 0.1, 0)NoClipButton.Position = UDim2.new(0, 0, 0.2, 0)NoClipButton.Text ="No Clip"NoClipButton.MouseButton1Click:Connect(enableNoClip)-- ESP в Visual Tab
local ESPEnabled = false

local function toggleESP()    ESPEnabled = not ESPEnabled
    for_, player in pairs(game.Players:GetPlayers()) do
        if player ~= Player then
            local billboardGui = Instance.new("BillboardGui")            billboardGui.Size = UDim2.new(1, 0, 1, 0)            billboardGui.Adornee = player.Character:WaitForChild("Head")            billboardGui.AlwaysOnTop = true

            local textLabel = Instance.new("TextLabel", billboardGui)            textLabel.Text = player.Name
            textLabel.BackgroundTransparency = 1
            textLabel.TextColor3 = Color3.new(1, 1, 1)            textLabel.TextStrokeTransparency = 0
            billboardGui.Parent = player.Character:WaitForChild("Head")            -- Удаляем ESP при отключении
            RunService.RenderStepped:Connect(function()                if not ESPEnabled and billboardGui then
                    billboardGui:Destroy()                end
            end)        end
    end
end

local ESPButton = Instance.new("TextButton", VisualTab)ESPButton.Size = UDim2.new(1, 0, 0.1, 0)ESPButton.Text ="Toggle ESP"ESPButton.MouseButton1Click:Connect(toggleESP)-- Изначально устанавливаем вкладку
MainTab.Visible = true
VisualTab.Visible = false