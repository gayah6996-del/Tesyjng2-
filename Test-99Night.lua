local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("ImageLabel")
local Roundify = Instance.new("ImageLabel")
local SpeedHack = Instance.new("TextButton")
local Noclip = Instance.new("TextButton")
local Close = Instance.new("TextButton")


ScreenGui.Parent = game.CoreGui

Frame.Name = "Frame"
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(44, 44, 44)
Frame.BackgroundTransparency = 1.000
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.157811254, 0, 0.0716019422, 0)
Frame.Size = UDim2.new(0, 621, 0, 274)
Frame.Image = "rbxassetid://3570695787"
Frame.ImageColor3 = Color3.fromRGB(49, 49, 49)
Frame.ScaleType = Enum.ScaleType.Slice
Frame.SliceCenter = Rect.new(100, 100, 100, 100)
Frame.SliceScale = 0.040
Frame.Active = true
Frame.Draggable = true

Roundify.Name = "Roundify"
Roundify.Parent = Frame
Roundify.AnchorPoint = Vector2.new(0.5, 0.5)
Roundify.BackgroundColor3 = Color3.fromRGB(72, 72, 72)
Roundify.BackgroundTransparency = 1.000
Roundify.Position = UDim2.new(0.5, 0, 0.5, 0)
Roundify.Size = UDim2.new(1, 8, 1, 8)
Roundify.Image = "rbxassetid://3570695787"
Roundify.ImageColor3 = Color3.fromRGB(48, 48, 48)
Roundify.ScaleType = Enum.ScaleType.Slice
Roundify.SliceCenter = Rect.new(100, 100, 100, 100)
Roundify.SliceScale = 0.040

SpeedHack.Name = "SpeedHack"
SpeedHack.Parent = Frame
SpeedHack.BackgroundColor3 = Color3.fromRGB(76, 76, 76)
SpeedHack.BorderColor3 = Color3.fromRGB(0, 0, 0)
SpeedHack.Position = UDim2.new(0.003303082, 0, 0.0846896172, 0)
SpeedHack.Size = UDim2.new(0, 340, 0, 77)
SpeedHack.Font = Enum.Font.GothamBold
SpeedHack.Text = "Enable SpeedHack"
SpeedHack.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedHack.TextSize = 3.000
SpeedHack.MouseButton1Down:connect(function()
loadstring(game:HttpGet("https://pastebin.com/raw/a95RwWVu", true))()
end)

Noclip.Name = "NoClip"
Noclip.Parent = Frame
Noclip.BackgroundColor3 = Color3.fromRGB(76, 76, 76)
Noclip.BorderColor3 = Color3.fromRGB(0, 0, 0)
Noclip.Position = UDim2.new(0.033303082, 0, 0.0846896172, 0)
NoClip.Size = UDim2.new(0, 340, 0, 77)
Noclip.Font = Enum.Font.GothamBold
Noclip.Text = "Enable Noclip"
Noclip.TextColor3 = Color3.fromRGB(255, 255, 255)
Noclip.TextSize = 3.000
Noclip.MouseButton1Down:connect(function()
loadstring(game:HttpGet("https://pastebin.com/raw/a95RwWVu", true))()
end)

Close.Name = "Close"
Close.Parent = Frame
Close.BackgroundColor3 = Color3.fromRGB(76, 76, 76)
Close.BorderColor3 = Color3.fromRGB(97, 97, 97)
Close.Position = UDim2.new(0.033303082, 0, 0.570439577, 0)
Close.Size = UDim2.new(0, 340, 0, 77)
Close.Font = Enum.Font.GothamBold
Close.Text = "Close GUI"
Close.TextColor3 = Color3.fromRGB(255, 255, 255)
Close.TextSize = 3.000
Close.MouseButton1Down:connect(function()
Frame.Visible = true
end)