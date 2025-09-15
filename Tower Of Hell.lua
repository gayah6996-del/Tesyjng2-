--Made By ImFalxe
 
local Bypass = game:GetService("Players").LocalPlayer.PlayerScripts
Bypass.Name = "Bypass"
 
Bypass:FindFirstChild("LocalScript"):Destroy()
Bypass:FindFirstChild("LocalScript2"):Destroy()
 
Bypass.Name = "PlayerScripts"
 
local ScreenGui = Instance.new("ScreenGui")
local main = Instance.new("Frame")
local EZWinHub = Instance.new("TextLabel")
local TeleportTool = Instance.new("TextButton")
local Walkonwalls = Instance.new("TextButton")
local Credits = Instance.new("TextLabel")
local close = Instance.new("TextButton")
local Misc = Instance.new("TextButton")
local Fly = Instance.new("TextButton")
local openmain = Instance.new("Frame")
local open = Instance.new("TextButton")
local Misc_2 = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local Speed = Instance.new("TextButton")
local JumpPower = Instance.new("TextButton")
local NormalSpeed = Instance.new("TextButton")
local NormalJumpPower = Instance.new("TextButton")
local close_2 = Instance.new("TextButton")
 
--Properties:
 
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
 
main.Name = "main"
main.Parent = ScreenGui
main.BackgroundColor3 = Color3.fromRGB(43, 43, 43)
main.Position = UDim2.new(0.463285387, 0, 0.336609304, 0)
main.Size = UDim2.new(0, 500, 0, 350)
main.Visible = false
main.Active = true
main.Draggable = true
 
EZWinHub.Name = "@SFXCL"
EZWinHub.Parent = main
EZWinHub.BackgroundColor3 = Color3.fromRGB(43, 43, 43)
EZWinHub.BorderColor3 = Color3.fromRGB(0, 0, 0)
EZWinHub.BorderSizePixel = 2
EZWinHub.Size = UDim2.new(0, 500, 0, 50)
EZWinHub.Font = Enum.Font.Fantasy
EZWinHub.Text = "@BY @SFXCL"
EZWinHub.TextColor3 = Color3.fromRGB(0, 0, 0)
EZWinHub.TextScaled = true
EZWinHub.TextSize = 14.000
EZWinHub.TextWrapped = true
 
TeleportTool.Name = "Teleport Tool"
TeleportTool.Parent = main
TeleportTool.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TeleportTool.BorderColor3 = Color3.fromRGB(0, 0, 0)
TeleportTool.Position = UDim2.new(0.0900000036, 0, 0.397142857, 0)
TeleportTool.Size = UDim2.new(0, 410, 0, 50)
TeleportTool.Font = Enum.Font.Fantasy
TeleportTool.Text = "Teleport Tool"
TeleportTool.TextColor3 = Color3.fromRGB(98, 98, 98)
TeleportTool.TextScaled = true
TeleportTool.TextSize = 14.000
TeleportTool.TextWrapped = true
TeleportTool.MouseButton1Down:connect(function()
local plr = game:GetService("Players").LocalPlayer
local mouse = plr:GetMouse()
 
local tool = Instance.new("Tool")
tool.RequiresHandle = false
tool.Name = "Click Teleport"
 
tool.Activated:Connect(function()
local root = plr.Character.HumanoidRootPart
local pos = mouse.Hit.Position+Vector3.new(0,2.5,0)
local offset = pos-root.Position
root.CFrame = root.CFrame+offset
end)
 
tool.Parent = plr.Backpack
end)
 
Walkonwalls.Name = "Walk on walls"
Walkonwalls.Parent = main
Walkonwalls.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Walkonwalls.BorderColor3 = Color3.fromRGB(0, 0, 0)
Walkonwalls.Position = UDim2.new(0.0900000036, 0, 0.568571448, 0)
Walkonwalls.Size = UDim2.new(0, 410, 0, 50)
Walkonwalls.Font = Enum.Font.Fantasy
Walkonwalls.Text = "Walk on walls"
Walkonwalls.TextColor3 = Color3.fromRGB(98, 98, 98)
Walkonwalls.TextScaled = true
Walkonwalls.TextSize = 14.000
Walkonwalls.TextWrapped = true
Walkonwalls.MouseButton1Down:connect(function()
getgenv()["cofiG"] = getgenv()["cofiG"] or {}
local hasToUpdate = true
local alreadyRan = cofiG.gravityController ~= nil
 
local http = game:GetService'HttpService'
local readfile,writefile,fileexists = readfile or syn_io_read,writefile or syn_io_write,isfile or readfile
 
local rawUrl,baseUrl = "https://ixss.keybase.pub/rblx/gravityController/", "https://keybase.pub/ixss/rblx/gravityController/"
 
do
    _G.req = [[
        local require = function(lol)
            lol = "https://raw.githubusercontent.com/msva/lua-htmlparser/master/src/"..lol:gsub("%.","/")..".lua";
            return loadstring(_G.req..game:HttpGet(lol))();
        end;
    ]]
 
    local require = function(lol)
        lol = "https://raw.githubusercontent.com/msva/lua-htmlparser/master/src/"..lol:gsub("%.","/")..".lua";
        return loadstring(_G.req..game:HttpGet(lol))();
    end;
 
    cofiG.htmlparser = cofiG.htmlparser or require"htmlparser"
end
 
do  -- check if exists
if fileexists'gravityController.json' then
local json = readfile'gravityController.json'
if json then
cofiG.gravityController = http:JSONDecode(json)
hasToUpdate = cofiG.gravityController.Version ~= game:HttpGet(rawUrl.."Version.txt")
end
end
game.StarterGui:SetCore("ChatMakeSystemMessage", {
Text = hasToUpdate and "Updating script..." or "Running script!";
Font = Enum.Font.Code;
Color = Color3.fromRGB(255, 60, 60);
FontSize = Enum.FontSize.Size96;   
})
end
 
 
if hasToUpdate then -- update/download
 
    function getScripts()
        local ret = {}
        local text = game:HttpGet(baseUrl, false)
 
        local root = cofiG.htmlparser.parse(text)
        local files = root:select(".file")
 
        for i,v in pairs(files) do
            if string.sub(v.attributes.href, string.len(v.attributes.href)-3) == ".lua" then
                local name = string.sub(v.attributes.href,string.len(baseUrl)+1, string.len(v.attributes.href)-4)
                local script = rawUrl..name..".lua"
                ret[name] = game:HttpGet(script)
            elseif string.sub(v.attributes.href, string.len(v.attributes.href)-3) == ".txt" then
                local name = string.sub(v.attributes.href,string.len(baseUrl)+1, string.len(v.attributes.href)-4)
                local script = rawUrl..name..".txt"
                ret[name] = game:HttpGet(script)
            end
        end
 
        return ret
    end
    cofiG.gravityController = getScripts()
    writefile('gravityController.json', http:JSONEncode(cofiG.gravityController))
    warn('Script updated!')
end
 
local a,b = pcall(loadstring(cofiG.gravityController.Loader))
 
if not a then
error('Loader ', b)
end
 
if not alreadyRan then
game.StarterGui:SetCore("ChatMakeSystemMessage", {
Text = game:HttpGet('https://ixss.keybase.pub/Watermark.txt', true)..", originally made by EgoMoose.";
Font = Enum.Font.Code;
Color = Color3.fromRGB(244, 0, 175);
FontSize = Enum.FontSize.Size96;   
})
end
end)
 
Credits.Name = "Credits"
Credits.Parent = main
Credits.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Credits.BackgroundTransparency = 1.000
Credits.Position = UDim2.new(0, 0, 0.871428549, 0)
Credits.Size = UDim2.new(0, 500, 0, 45)
Credits.Font = Enum.Font.Fantasy
Credits.Text = "Made by @SFXCL"
Credits.TextColor3 = Color3.fromRGB(0, 0, 0)
Credits.TextScaled = true
Credits.TextSize = 14.000
Credits.TextWrapped = true
 
close.Name = "close"
close.Parent = main
close.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
close.Position = UDim2.new(0.939999998, 0, 0, 0)
close.Size = UDim2.new(0, 30, 0, 20)
close.Font = Enum.Font.Fantasy
close.Text = "X"
close.TextColor3 = Color3.fromRGB(0, 0, 0)
close.TextScaled = true
close.TextSize = 14.000
close.TextWrapped = true
close.MouseButton1Down:connect(function()
main.Visible = false
openmain.Visible = true
end)
 
Misc.Name = "Misc"
Misc.Parent = main
Misc.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Misc.BorderColor3 = Color3.fromRGB(0, 0, 0)
Misc.Position = UDim2.new(0.0900000036, 0, 0.745714247, 0)
Misc.Size = UDim2.new(0, 410, 0, 50)
Misc.Font = Enum.Font.Fantasy
Misc.Text = "Misc"
Misc.TextColor3 = Color3.fromRGB(98, 98, 98)
Misc.TextScaled = true
Misc.TextSize = 14.000
Misc.TextWrapped = true
Misc.MouseButton1Down:connect(function()
Misc_2.Visible = true
end)
 
Fly.Name = "Fly"
Fly.Parent = main
Fly.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Fly.BorderColor3 = Color3.fromRGB(0, 0, 0)
Fly.Position = UDim2.new(0.0900000036, 0, 0.225714296, 0)
Fly.Size = UDim2.new(0, 410, 0, 50)
Fly.Font = Enum.Font.Fantasy
Fly.Text = "Fly (Press E)"
Fly.TextColor3 = Color3.fromRGB(98, 98, 98)
Fly.TextScaled = true
Fly.TextSize = 14.000
Fly.TextWrapped = true
Fly.MouseButton1Down:connect(function()
loadstring(game:HttpGet('https://pastebin.com/raw/q6S4AcxJ'))()
end)
 
openmain.Name = "openmain"
openmain.Parent = ScreenGui
openmain.BackgroundColor3 = Color3.fromRGB(43, 43, 43)
openmain.Position = UDim2.new(0.01358895, 0, 0.433882058, 0)
openmain.Size = UDim2.new(0, 110, 0, 35)
openmain.Active = true
openmain.Draggable = true
 
open.Name = "open"
open.Parent = openmain
open.BackgroundColor3 = Color3.fromRGB(43, 43, 43)
open.Size = UDim2.new(0, 110, 0, 35)
open.Font = Enum.Font.Fantasy
open.Text = "Open"
open.TextColor3 = Color3.fromRGB(0, 0, 0)
open.TextScaled = true
open.TextSize = 14.000
open.TextWrapped = true
open.MouseButton1Down:connect(function()
main.Visible = true
openmain.Visible = false
end)
 
Misc_2.Name = "Misc"
Misc_2.Parent = ScreenGui
Misc_2.BackgroundColor3 = Color3.fromRGB(43, 43, 43)
Misc_2.Position = UDim2.new(0.323239982, 0, 0.335380822, 0)
Misc_2.Size = UDim2.new(0, 185, 0, 351)
Misc_2.Visible = false
Misc_2.Active = true
Misc_2.Draggable = true
 
Title.Name = "Title"
Title.Parent = Misc_2
Title.BackgroundColor3 = Color3.fromRGB(43, 43, 43)
Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
Title.BorderSizePixel = 2
Title.Position = UDim2.new(0, 0, 0.00284891599, 0)
Title.Size = UDim2.new(0, 185, 0, 50)
Title.Font = Enum.Font.Fantasy
Title.Text = "Misc"
Title.TextColor3 = Color3.fromRGB(0, 0, 0)
Title.TextScaled = true
Title.TextSize = 14.000
Title.TextWrapped = true
 
Speed.Name = "Speed"
Speed.Parent = Misc_2
Speed.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Speed.BorderColor3 = Color3.fromRGB(0, 0, 0)
Speed.Position = UDim2.new(0.0900001302, 0, 0.225714266, 0)
Speed.Size = UDim2.new(0, 151, 0, 50)
Speed.Font = Enum.Font.Fantasy
Speed.Text = "Speed"
Speed.TextColor3 = Color3.fromRGB(98, 98, 98)
Speed.TextScaled = true
Speed.TextSize = 14.000
Speed.TextWrapped = true
Speed.MouseButton1Down:connect(function()
game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 50
end)
 
JumpPower.Name = "JumpPower"
JumpPower.Parent = Misc_2
JumpPower.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
JumpPower.BorderColor3 = Color3.fromRGB(0, 0, 0)
JumpPower.Position = UDim2.new(0.0900001302, 0, 0.396654427, 0)
JumpPower.Size = UDim2.new(0, 151, 0, 50)
JumpPower.Font = Enum.Font.Fantasy
JumpPower.Text = "JumpPower"
JumpPower.TextColor3 = Color3.fromRGB(98, 98, 98)
JumpPower.TextScaled = true
JumpPower.TextSize = 14.000
JumpPower.TextWrapped = true
JumpPower.MouseButton1Down:connect(function()
game.Players.LocalPlayer.Character.Humanoid.JumpPower = 150
end)
 
NormalSpeed.Name = "NormalSpeed"
NormalSpeed.Parent = Misc_2
NormalSpeed.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
NormalSpeed.BorderColor3 = Color3.fromRGB(0, 0, 0)
NormalSpeed.Position = UDim2.new(0.0900001302, 0, 0.567594588, 0)
NormalSpeed.Size = UDim2.new(0, 151, 0, 50)
NormalSpeed.Font = Enum.Font.Fantasy
NormalSpeed.Text = "Normal Speed"
NormalSpeed.TextColor3 = Color3.fromRGB(98, 98, 98)
NormalSpeed.TextScaled = true
NormalSpeed.TextSize = 14.000
NormalSpeed.TextWrapped = true
NormalSpeed.MouseButton1Down:connect(function()
game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
end)
 
NormalJumpPower.Name = "NormalJumpPower"
NormalJumpPower.Parent = Misc_2
NormalJumpPower.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
NormalJumpPower.BorderColor3 = Color3.fromRGB(0, 0, 0)
NormalJumpPower.Position = UDim2.new(0.0900001302, 0, 0.744232774, 0)
NormalJumpPower.Size = UDim2.new(0, 151, 0, 50)
NormalJumpPower.Font = Enum.Font.Fantasy
NormalJumpPower.Text = "Normal JumpPower"
NormalJumpPower.TextColor3 = Color3.fromRGB(98, 98, 98)
NormalJumpPower.TextScaled = true
NormalJumpPower.TextSize = 14.000
NormalJumpPower.TextWrapped = true
NormalJumpPower.MouseButton1Down:connect(function()
game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50
end)
 
close_2.Name = "close"
close_2.Parent = Misc_2
close_2.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
close_2.BackgroundTransparency = 1.000
close_2.Position = UDim2.new(-0.00054037571, 0, 0, 0)
close_2.Size = UDim2.new(0, 20, 0, 20)
close_2.Font = Enum.Font.Fantasy
close_2.Text = "X"
close_2.TextColor3 = Color3.fromRGB(0, 0, 0)
close_2.TextScaled = true
close_2.TextSize = 14.000
close_2.TextWrapped = true
close_2.MouseButton1Down:connect(function()
Misc_2.Visible = false
end)