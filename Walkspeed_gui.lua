-- TRASHNEVERDIE GUI
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
main.Size = UDim2.new(0, 450, 0, 450)
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
title.Text = "by @SFXCL"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextScaled = true
title.Font = Enum.Font.GothamBold

local minimize = Instance.new("TextButton", main)
minimize.Size = UDim2.new(0, 30, 0, 30)
minimize.Position = UDim2.new(1, -35, 0, 5)
minimize.BackgroundTransparency = 1
minimize.Text = "X"
minimize.TextColor3 = Color3.new(1, 1, 1)
minimize.Font = Enum.Font.GothamBold
minimize.TextScaled = true
addCorner(minimize, 6)

local toggled, funcs, btns = {}, {}, {}
local minimizedState = false
local names = {"GOD MODE", "INFINITY JUMP", "ESP", "SPEEDHACK", "NOCLIP", "KISGARA"} -- Полный список кнопок

for i, name in ipairs(names) do
    local btn = Instance.new("TextButton", main)
    btn.Size = UDim2.new(1, -20, 0, 35)
    btn.Position = UDim2.new(0, 10, 0, 60 + (i - 1) * 42)
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

-- Функционал God Mode
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

-- Функционал Infinity Jump
funcs["INFINITY JUMP"] = function(s)
    if s then
        _G.JC = UserInputService.JumpRequest:Connect(function()
            local h = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if h then h:ChangeState("Jumping") end
        end)
    elseif _G.JC then
        _G.JC:Disconnect()
    end
end

-- Функционал ESP
funcs["ESP"] = function(s)
    if not s then return end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            coroutine.wrap(function()
                local char = plr.Character or plr.CharacterAdded:Wait()
                local head = char:WaitForChild("Head")
                local torso = char:FindFirstChild("HumanoidRootPart")
                local nameT = Drawing.new("Text")
                nameT.Center = true
                nameT.Outline = true
                nameT.Size = 14
                nameT.Font = 2
                local distT = Drawing.new("Text")
                distT.Center = true
                distT.Outline = true
                distT.Size = 13
                distT.Color = Color3.new(1, 0, 0)
                local bone = Drawing.new("Skeleton")
                bone.Color = Color3.new(1, 1, 1)
                bone.Thickness = 2
                RunService.RenderStepped:Connect(function()
                    if not head:IsDescendantOf(workspace) then return end
                    local cam = workspace.CurrentCamera
                    local pos, vis = cam:WorldToViewportPoint(head.Position)
                    local dist = (LocalPlayer.Character.Head.Position - head.Position).Magnitude
                    if vis and dist <= 250 then
                        nameT.Visible = true
                        distT.Visible = true
                        bone.Visible = true
                        nameT.Text = plr.Name
                        distT.Text = string.format("Distance: %d", dist)
                        nameT.Position = Vector2.new(pos.X, pos.Y - 20)
                        distT.Position = Vector2.new(pos.X, pos.Y)
                        nameT.Color = Color3.fromHSV(tick() % 5 / 1, 0, 0)
                        local h2 = cam:WorldToViewportPoint(head.Position)
                        local t2 = cam:WorldToViewportPoint(torso.Position)
                        bone.From = Vector2.new(t2.X, t2.Y)
                        bone.To = Vector2.new(h2.X, h2.Y)
                    else
                        nameT.Visible = false
                        distT.Visible = false
                        bone.Visible = false
                    end
                end)
            end)()
        end
    end
end

-- Функционал Speedhack
funcs["SPEEDHACK"] = function(s)
    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = s and 30 or 16 -- Изменяем скорость ходьбы
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

-- Функционал Kisgara
funcs["KISGARA"] = function(s)
        local fire = Workspace:FindFirstChild("Fire") -- Adjust to actual fire name
        if fire and fire.PrimaryPart then
            for _, obj in pairs(Workspace.Items:GetChildren()) do
                if obj:IsA("Model") and (obj.Name == "Petrol" or obj.Name == "Gas Can" or obj.Name == "Coal" or obj.Name == "Log" or obj.Name:match("Corpse")) and obj.PrimaryPart then
                    obj.PrimaryPart.CFrame = fire.PrimaryPart.CFrame
                    DragItem(obj)
                end
            end
        end
    end