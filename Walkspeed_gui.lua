local player = game.Players.LocalPlayer
local jumpEnabled = false
local speedEnabled = false
local espEnabled = false
local menuOpen = false -- To keep track of the menu state
local espObjects = {} -- Table to keep track of ESP parts

-- Create the ScreenGui
local screenGui = Instance.new("ScreenGui", player.PlayerGui)screenGui.Name ="@SFXCL"-- Create the button to open/close the menu
local toggleButton = Instance.new("TextButton", screenGui)toggleButton.Size = UDim2.new(0, 50, 0, 50)toggleButton.Position = UDim2.new(0.5, -25, 0.5, -105) -- Подняли кнопку выше
toggleButton.Text ="Menu"toggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 255) -- Blue color

-- Create the jump button
local jumpButton = Instance.new("TextButton", screenGui)jumpButton.Size = UDim2.new(0, 200, 0, 50)jumpButton.Position = UDim2.new(0.5, -100, 0.5, -30)jumpButton.Text ="Toggle Infinity Jump"jumpButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Red color
jumpButton.Visible = false -- Initially hidden

-- Create the speed button
local speedButton = Instance.new("TextButton", screenGui)speedButton.Size = UDim2.new(0, 200, 0, 50)speedButton.Position = UDim2.new(0.5, -100, 0.5, 20)speedButton.Text ="Toggle Speed Hack"speedButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Red color
speedButton.Visible = false -- Initially hidden

-- Create the ESP button
local espButton = Instance.new("TextButton", screenGui)espButton.Size = UDim2.new(0, 200, 0, 50)espButton.Position = UDim2.new(0.5, -100, 0.5, 70)espButton.Text ="Toggle ESP"espButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Red color
espButton.Visible = false -- Initially hidden

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

-- Function to toggle ESP
local function toggleESP()    espEnabled = not espEnabled
    espButton.BackgroundColor3 = espEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0) -- Green when enabled, red when disabled

    if espEnabled then
        for_, otherPlayer in pairs(game.Players:GetPlayers()) do
            if otherPlayer ~= player then
                local highlight = Instance.new("Highlight")                highlight.Adornee = otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart")                highlight.FillColor = Color3.new(1, 0, 0) -- Red color for highlights
                highlight.FillTransparency = 0.5 -- Slightly transparent
                highlight.OutlineColor = Color3.new(1, 1, 1) -- White outline
                highlight.Parent = otherPlayer.Character

                table.insert(espObjects, highlight)            end
        end
    else
        for_, espObject in pairs(espObjects) do
            espObject:Destroy()        end
        espObjects = {}    end
end

-- Function to open/close the menu
local function toggleMenu()    menuOpen = not menuOpen
    jumpButton.Visible = menuOpen
    speedButton.Visible = menuOpen
    espButton.Visible = menuOpen
    closeButton.Visible = menuOpen
end

-- Function to close the menu
local function closeMenu()    menuOpen = false
    jumpButton.Visible = false
    speedButton.Visible = false
    espButton.Visible = false
    closeButton.Visible = false
end

-- Connect button click events
toggleButton.MouseButton1Click:Connect(toggleMenu)jumpButton.MouseButton1Click:Connect(toggleJump)speedButton.MouseButton1Click:Connect(toggleSpeed)espButton.MouseButton1Click:Connect(toggleESP)closeButton.MouseButton1Click:Connect(closeMenu)-- Enable dragging of the menu
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