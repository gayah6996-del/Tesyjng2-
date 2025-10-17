-- Roblox ESP Menu Script (LocalScript)
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "ESPMenu"
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 380)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -190)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = gui

-- Corner
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "ESP MENU"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = titleBar

-- Content Area
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, 0, 1, -35)
contentFrame.Position = UDim2.new(0, 0, 0, 35)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 15)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.Parent = contentFrame

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    contentFrame.Size = UDim2.new(1, 0, 0, layout.AbsoluteContentSize.Y + 50)
end)

-- Function to create section
function createSection(options, sectionName)
    local sectionFrame = Instance.new("Frame")
    sectionFrame.Size = UDim2.new(0.9, 0, 0, 0)
    sectionFrame.BackgroundTransparency = 1
    sectionFrame.AutomaticSize = Enum.AutomaticSize.Y
    sectionFrame.Parent = contentFrame
    
    local sectionLayout = Instance.new("UIListLayout")
    sectionLayout.Padding = UDim.new(0, 8)
    sectionLayout.Parent = sectionFrame
    
    -- Section Title
    if sectionName then
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 25)
        title.BackgroundTransparency = 1
        title.Text = sectionName
        title.TextColor3 = Color3.fromRGB(200, 200, 200)
        title.Font = Enum.Font.GothamSemibold
        title.TextSize = 14
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = sectionFrame
    end
    
    -- Create options
    for _, option in pairs(options) do
        local optionFrame = Instance.new("Frame")
        optionFrame.Size = UDim2.new(1, 0, 0, 25)
        optionFrame.BackgroundTransparency = 1
        optionFrame.Parent = sectionFrame
        
        local optionLabel = Instance.new("TextLabel")
        optionLabel.Size = UDim2.new(0.7, 0, 1, 0)
        optionLabel.BackgroundTransparency = 1
        optionLabel.Text = option
        optionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        optionLabel.Font = Enum.Font.Gotham
        optionLabel.TextSize = 16
        optionLabel.TextXAlignment = Enum.TextXAlignment.Left
        optionLabel.Parent = optionFrame
        
        if option == "CLICK!" then
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(0.25, 0, 0.8, 0)
            button.Position = UDim2.new(0.72, 0, 0.1, 0)
            button.BackgroundColor3 = Color3.fromRGB(70, 140, 200)
            button.Text = "CLICK!"
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
            button.Font = Enum.Font.GothamBold
            button.TextSize = 12
            button.Parent = optionFrame
            
            local buttonCorner = Instance.new("UICorner")
            buttonCorner.CornerRadius = UDim.new(0, 4)
            buttonCorner.Parent = button
            
            -- Button click handlers
            button.MouseButton1Click:Connect(function()
                if sectionName == "VISUALCK" then
                    activateVisualCK()
                elseif sectionName == "NANE ESP" then
                    activateNameESP()
                elseif sectionName == "ROLE ESP" then
                    activateRoleESP()
                end
            end)
        end
    end
end

-- Create sections exactly like in the image
createSection({"VISUALCK", "HILIGHT ESP", "CLICK!"}, "VISUALCK")
createSection({"NANE ESP", "TELEPORT", "XRAY ( X KEY )", "CLICK!"}, "NANE ESP")
createSection({"ROLE ESP", "KEYBINDECK", "BLURT MURDERMUM", "CLICK!"}, "ROLE ESP")

-- Function implementations (placeholder)
function activateVisualCK()
    print("VisualCK activated!")
    -- Add your VisualCK functionality here
end

function activateNameESP()
    print("Name ESP activated!")
    -- Add your Name ESP functionality here
end

function activateRoleESP()
    print("Role ESP activated!")
    -- Add your Role ESP functionality here
end

-- Draggable functionality
local dragging = false
local dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and (input == dragInput or input.UserInputType == Enum.UserInputType.Touch) then
        update(input)
    end
end)

-- Close button (hidden but accessible via script)
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -30, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 14
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = closeButton

closeButton.MouseButton1Click:Connect(function()
    gui:Destroy()
end)