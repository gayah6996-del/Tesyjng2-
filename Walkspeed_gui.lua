-- // TUC0HUB IS BACK? Script Hub //
-- Autor: Code GPT 🥷

-- SERVIÇOS
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- VARIÁVEIS
local KEY = "TUC0HUB IS BACK?"

-- GUI PRINCIPAL
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TUC0HUB"
ScreenGui.Parent = PlayerGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- KEY INPUT
local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.new(0, 300, 0, 150)
KeyFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
KeyFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
KeyFrame.Parent = ScreenGui

local KeyBox = Instance.new("TextBox")
KeyBox.PlaceholderText = "Digite a Key..."
KeyBox.Size = UDim2.new(1, -40, 0, 40)
KeyBox.Position = UDim2.new(0, 20, 0, 30)
KeyBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
KeyBox.TextColor3 = Color3.new(1, 1, 1)
KeyBox.TextSize = 18
KeyBox.Font = Enum.Font.SourceSans
KeyBox.Parent = KeyFrame

local Submit = Instance.new("TextButton")
Submit.Text = "Verificar"
Submit.Size = UDim2.new(1, -40, 0, 40)
Submit.Position = UDim2.new(0, 20, 0, 80)
Submit.BackgroundColor3 = Color3.fromRGB(30, 120, 255)
Submit.TextColor3 = Color3.new(1, 1, 1)
Submit.TextSize = 18
Submit.Font = Enum.Font.SourceSansBold
Submit.Parent = KeyFrame

local Status = Instance.new("TextLabel")
Status.Text = ""
Status.Size = UDim2.new(1, 0, 0, 30)
Status.Position = UDim2.new(0, 0, 1, -30)
Status.BackgroundTransparency = 1
Status.TextColor3 = Color3.new(1, 0, 0)
Status.TextSize = 14
Status.Font = Enum.Font.SourceSans
Status.Parent = KeyFrame

-- ANIMAÇÃO ELEMENTOS
local Circle = Instance.new("Frame")
Circle.Size = UDim2.new(0, 100, 0, 100)
Circle.Position = UDim2.new(0.5, -50, 0.5, -50)
Circle.BackgroundColor3 = Color3.fromRGB(50, 50, 255)
Circle.Visible = false
Circle.ClipsDescendants = true
Circle.Parent = ScreenGui
Circle.AnchorPoint = Vector2.new(0.5, 0.5)
Circle.BackgroundTransparency = 0
Circle.BorderSizePixel = 0
Circle.Name = "Circle"

CircleCorner = Instance.new("UICorner")
CircleCorner.CornerRadius = UDim.new(1, 0)
CircleCorner.Parent = Circle

local THLabel = Instance.new("TextLabel")
THLabel.Text = "TH"
THLabel.Size = UDim2.new(1, 0, 1, 0)
THLabel.BackgroundTransparency = 1
THLabel.TextColor3 = Color3.new(1, 1, 1)
THLabel.Font = Enum.Font.SourceSansBold
THLabel.TextSize = 30
THLabel.Parent = Circle

-- HUB FRAME
local HubFrame = Instance.new("Frame")
HubFrame.Size = UDim2.new(0, 500, 0, 300)
HubFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
HubFrame.Visible = false
HubFrame.Parent = ScreenGui

-- GRADIENT
local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 200, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 120))
}
Gradient.Parent = HubFrame

-- DRAG
local dragging, dragInput, dragStart, startPos

HubFrame.Active = true
HubFrame.Draggable = true

-- Minimizar botão
local MinButton = Instance.new("TextButton")
MinButton.Text = "-"
MinButton.Size = UDim2.new(0, 30, 0, 30)
MinButton.Position = UDim2.new(1, -40, 0, 10)
MinButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
MinButton.TextColor3 = Color3.new(1, 1, 1)
MinButton.Font = Enum.Font.SourceSansBold
MinButton.TextSize = 20
MinButton.Parent = HubFrame

local minimized = false

MinButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    HubFrame:FindFirstChild("MainContent").Visible = not minimized
end)

-- Barra lateral
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 100, 1, 0)
Sidebar.Position = UDim2.new(0, 0, 0, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Sidebar.Parent = HubFrame

local MainContent = Instance.new("Frame")
MainContent.Name = "MainContent"
MainContent.Size = UDim2.new(1, -100, 1, 0)
MainContent.Position = UDim2.new(0, 100, 0, 0)
MainContent.BackgroundTransparency = 1
MainContent.Parent = HubFrame

-- Botões Sidebar
local sections = {"Scripts","Player","Output","Executor","Visuals","Config"}
local sectionFrames = {}

for i, sec in ipairs(sections) do
    local Btn = Instance.new("TextButton")
    Btn.Text = sec
    Btn.Size = UDim2.new(1, 0, 0, 40)
    Btn.Position = UDim2.new(0, 0, 0, (i-1)*40)
    Btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Btn.TextColor3 = Color3.new(1, 1, 1)
    Btn.Font = Enum.Font.SourceSans
    Btn.TextSize = 14
    Btn.Parent = Sidebar

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 1, 0)
    Frame.Position = UDim2.new(0, 0, 0, 0)
    Frame.Visible = (i == 1)
    Frame.Parent = MainContent

    sectionFrames[sec] = Frame

    Btn.MouseButton1Click:Connect(function()
        for _, f in pairs(sectionFrames) do f.Visible = false end
        Frame.Visible = true
    end)
end

-- Exemplo: Scripts Section
local ExampleScriptBtn = Instance.new("TextButton")
ExampleScriptBtn.Text = "Print Hello"
ExampleScriptBtn.Size = UDim2.new(0, 150, 0, 40)
ExampleScriptBtn.Position = UDim2.new(0, 20, 0, 20)
ExampleScriptBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
ExampleScriptBtn.TextColor3 = Color3.new(1, 1, 1)
ExampleScriptBtn.Font = Enum.Font.SourceSans
ExampleScriptBtn.TextSize = 14
ExampleScriptBtn.Parent = sectionFrames["Scripts"]

ExampleScriptBtn.MouseButton1Click:Connect(function()
    print("Hello from TUC0HUB!")
end)

-- Executor Section
local ExecBox = Instance.new("TextBox")
ExecBox.PlaceholderText = "-- Digite código Lua aqui"
ExecBox.Size = UDim2.new(0, 300, 0, 200)
ExecBox.Position = UDim2.new(0, 20, 0, 20)
ExecBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ExecBox.TextColor3 = Color3.new(1, 1, 1)
ExecBox.TextSize = 14
ExecBox.Font = Enum.Font.Code
ExecBox.TextXAlignment = Enum.TextXAlignment.Left
ExecBox.TextYAlignment = Enum.TextYAlignment.Top
ExecBox.ClearTextOnFocus = false
ExecBox.MultiLine = true
ExecBox.Parent = sectionFrames["Executor"]

local ExecBtn = Instance.new("TextButton")
ExecBtn.Text = "Executar"
ExecBtn.Size = UDim2.new(0, 100, 0, 40)
ExecBtn.Position = UDim2.new(0, 20, 0, 230)
ExecBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
ExecBtn.TextColor3 = Color3.new(1, 1, 1)
ExecBtn.Font = Enum.Font.SourceSansBold
ExecBtn.TextSize = 14
ExecBtn.Parent = sectionFrames["Executor"]

ExecBtn.MouseButton1Click:Connect(function()
    local code = ExecBox.Text
    local success, result = pcall(function()
        loadstring(code)()
    end)
    if not success then
        warn(result)
    end
end)

-- SUBMIT ACTION
Submit.MouseButton1Click:Connect(function()
    if KeyBox.Text == KEY then
        KeyFrame:Destroy()
        Circle.Visible = true

        local rotate = TweenService:Create(Circle, TweenInfo.new(4, Enum.EasingStyle.Linear), {Rotation = 360})
        rotate:Play()
        rotate.Completed:Wait()

        local expandTween = TweenService:Create(Circle, TweenInfo.new(1), {
            Size = UDim2.new(0, 500, 0, 300),
            Position = UDim2.new(0.5, -250, 0.5, -150)
        })
        expandTween:Play()
        expandTween.Completed:Wait()

        HubFrame.Position = Circle.Position
        HubFrame.Visible = true
        Circle:Destroy()
    else
        Status.Text = "Key incorreta!"
    end
end)
