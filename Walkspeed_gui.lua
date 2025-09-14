local player = game.Players.LocalPlayer
local jumpEnabled = false
local speedEnabled = false
local menuOpen = true -- To keep track of the menu state

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

-- Function to open/close the menu
local function toggleMenu()    menuOpen = not menuOpen
    jumpButton.Visible = menuOpen
    speedButton.Visible = menuOpen
end

-- Connect button click events
toggleButton.MouseButton1Click:Connect(toggleMenu)jumpButton.MouseButton1Click:Connect(toggleJump)speedButton.MouseButton1Click:Connect(toggleSpeed)-- Ensure the player can jump infinitely
game:GetService("RunService").RenderStepped:Connect(function()    if jumpEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
        if player.Character.Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
            player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)        end
    end
end)