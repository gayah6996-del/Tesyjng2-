local player = game.Players.LocalPlayer

local char = player.Character or player.CharacterAdded:Wait()

local hrp = char:WaitForChild("HumanoidRootPart")

local humanoid = char:WaitForChild("Humanoid")

local TweenService = game:GetService("TweenService")

local speedOn = false

local superJumpOn = false

local screenGui = Instance.new("ScreenGui")

screenGui.Name = "SimpleScriptGUI"

screenGui.ResetOnSpawn = false

screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")

frame.Size = UDim2.new(0, 200, 0, 190)

frame.Position = UDim2.new(0, 20, 0, 20)

frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

frame.BorderSizePixel = 0

frame.Parent = screenGui

frame.Active = true

frame.Draggable = true

local function createButton(text, posY)

    local btn = Instance.new("TextButton")

    btn.Size = UDim2.new(0, 180, 0, 40)

    btn.Position = UDim2.new(0, 10, 0, posY)

    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

    btn.BorderSizePixel = 0

    btn.TextColor3 = Color3.new(1, 1, 1)

    btn.Font = Enum.Font.Gotham

    btn.TextSize = 20

    btn.Text = text

    btn.Parent = frame

    return btn

end

local speedBtn = createButton("Speed OFF", 10)

local superJumpBtn = createButton("Superpulo OFF", 60)

local tpForwardBtn = createButton("Teleportar 5 studs", 110)

local function toggleSpeed()

    if speedOn then

        speedOn = false

        humanoid.WalkSpeed = 16

        speedBtn.Text = "Speed OFF"

    else

        speedOn = true

        humanoid.WalkSpeed = 100

        speedBtn.Text = "Speed ON"

    end

end

local function toggleSuperJump()

    if superJumpOn then

        superJumpOn = false

        superJumpBtn.Text = "Superpulo OFF"

    else

        superJumpOn = true

        superJumpBtn.Text = "Superpulo ON"

    end

end

local function teleportForward()

    local goal = hrp.CFrame + (hrp.CFrame.LookVector * 5)

    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = goal})

    tween:Play()

end

speedBtn.MouseButton1Click:Connect(toggleSpeed)

superJumpBtn.MouseButton1Click:Connect(toggleSuperJump)

tpForwardBtn.MouseButton1Click:Connect(teleportForward)

-- Controla o superpulo ao pular

humanoid.Jumping:Connect(function(active)

    if active and superJumpOn then

        hrp.Velocity = Vector3.new(hrp.Velocity.X, 150, hrp.Velocity.Z)

    end

end)