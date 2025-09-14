local player = game.Players.LocalPlayer
local jumpEnabled = false
local speedEnabled = false
local flyEnabled = false
local menuOpen = false -- To keep track of the menu state

-- Create the ScreenGui
local screenGui = Instance.new("ScreenGui", player.PlayerGui)screenGui.Name ="@SFXCL"-- Create the button to open/close the menu
local toggleButton = Instance.new("TextButton", screenGui)toggleButton.Size = UDim2.new(0, 50, 0, 50)toggleButton.Position = UDim2.new(0.5, -25, 0.5, -25)toggleButton.Text ="Menu" -- Change to"Menu" for clarity
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 255) -- Blue color

-- Create the jump button
local jumpButton = Instance.new("TextButton", screenGui)jumpButton.Size = UDim2.new(0, 200, 0, 50)jumpButton.Position = UDim2.new(0.5, -100, 0.5, -30)jumpButton.Text ="Toggle Infinity Jump"jumpButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Red color
jumpButton.Visible = false -- Initially hidden

-- Create the speed button
local speedButton = Instance.new("TextButton", screenGui)speedButton.Size = UDim2.new(0, 200, 0, 50)speedButton.Position = UDim2.new(0.5, -100, 0.5, 20)speedButton.Text ="Toggle Speed Hack"speedButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Red color
speedButton.Visible = false -- Initially hidden

-- Create the fly button
local flyButton = Instance.new("TextButton", screenGui)flyButton.Size = UDim2.new(0, 200, 0, 50)flyButton.Position = UDim2.new(0.5, -100, 0.5, 70)flyButton.Text ="Toggle Fly"flyButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Red color
flyButton.Visible = false -- Initially hidden

-- Create the close button
local closeButton = Instance.new("TextButton", screenGui)closeButton.Size = UDim2.new(0, 50, 0, 50)closeButton.Position = UDim2.new(0.5, 75, 0.5, -30) -- Position it next to the jump button
closeButton.Text ="X" -- Close button
closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Red color
closeButton.Visible = false -- Initially hidden

-- Function to toggle infinite jump
local function toggleJump()    jumpEnabled = not jumpEnabled
    jumpButton.BackgroundColor3 = jumpEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0) -- Green when enabled, red when disabled
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.JumpPower = jumpEnabled and 100 or 50
    end
end

-- Function to toggle speed
local function toggleSpeed()    speedEnabled = not speedEnabled
    speedButton.BackgroundColor3 = speedEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0) -- Green when enabled, red when disabled
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = speedEnabled and 50 or 16
    end
end

-- Function to toggle flying
local function toggleFly()    flyEnabled = not flyEnabled
    flyButton.BackgroundColor3 = flyEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0) -- Green when enabled, red when disabled

    if flyEnabled then
        local character = player.Character
        local humanoid = character:FindFirstChild("Humanoid")        if humanoid then
            humanoid.PlatformStand = true -- Prevents falling
        end
        -- Enable flying
        local bodyVelocity = Instance.new("BodyVelocity")        bodyVelocity.Velocity = Vector3.new(0, 0, 0)        bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)        bodyVelocity.Parent = character.PrimaryPart
        game:GetService("RunService").RenderStepped:Connect(function()            if flyEnabled and character and character.PrimaryPart then
                local direction = Vector3.new(0, 0, 0)                if player:GetMouse().KeyDown:Wait() then
                    direction = Vector3.new(0, 1, 0) -- Adjust Y for upward movement
                end
                bodyVelocity.Velocity = direction*50 -- Adjust the multiplier for speed
            else
                bodyVelocity:Destroy()                if humanoid then
                    humanoid.PlatformStand = false
                end
            end
        end)    else
        if character and character.PrimaryPart then
            character.PrimaryPart:FindFirstChildOfClass("BodyVelocity"):Destroy()            if humanoid then
                humanoid.PlatformStand = false
            end
        end
    end
end

-- Function to open/close the menu
local function toggleMenu()    menuOpen = not menuOpen
    jumpButton.Visible = menuOpen
    speedButton.Visible = menuOpen
    flyButton.Visible = menuOpen
    closeButton.Visible = menuOpen
end

-- Function to close the menu
local function closeMenu()    menuOpen = false
    jumpButton.Visible = false
    speedButton.Visible = false
    flyButton.Visible = false
    closeButton.Visible = false
end

-- Connect button click events
toggleButton.MouseButton1Click:Connect(toggleMenu)jumpButton.MouseButton1Click:Connect(toggleJump)speedButton.MouseButton1Click:Connect(toggleSpeed)flyButton.MouseButton1Click:Connect(toggleFly)closeButton.MouseButton1Click:Connect(closeMenu)-- Enable dragging of the menu
local function dragMenu(button)    local dragging = false
    local dragInput
    local startPos = button.Position

    button.InputBegan:Connect(function(input)        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragInput = input
            startPos = button.Position

            input.Changed:Connect(function()                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)        end
    end)    button.InputChanged:Connect(function(input)        if input.UserInputType == Enum.UserInputType.MouseMovement then
            while dragging do
                local mousePos = player:GetMouse().X
                button.Position = UDim2.new(0, mousePos - button.Size.X.Offset / 2, 0, startPos.Y.Offset)                wait()            end
        end
    end)end

-- Allow dragging for the toggle button
dragMenu(toggleButton)-- Ensure the player can jump infinitely
game:GetService("RunService").RenderStepped:Connect(function()    if jumpEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
        if player.Character.Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
            player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)        end
    end
end)