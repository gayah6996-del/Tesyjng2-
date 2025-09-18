local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
 
local Window = Fluent:CreateWindow({
    Title = "ASTRALCHEAT | V1 ",
    SubTitle = "by @SFXCL",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Amethyst",
    MinimizeKey = Enum.KeyCode.RightControl -- Used when theres no MinimizeKeybind
})
 
--Fluent provides Lucide Icons https://lucide.dev/icons/ for the tabs, icons are optional
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "menu" }),
    Universal = Window:AddTab({ Title = "Universal", Icon = "globe" }),
	jumpeverysec = Window:AddTab({ Title = "Tower Of Hell", Icon = "gamepad" }),
	v1v1pistol = Window:AddTab({ Title = "99 Nights in the forest", Icon = "gamepad" }),
	c3008 = Window:AddTab({ Title = "Steal a brainrot", Icon = "gamepad" }),
	Abilitywars = Window:AddTab({ Title = "Murder Mystery 2", Icon = "gamepad" }),
	Ageofheroes = Window:AddTab({ Title = "Evade", Icon = "gamepad" }),
}
 
local Options = Fluent.Options
 
do
    Fluent:Notify({
        Title = "Welcome!",
        Content = "Welcome to the ASTRALCHEAT",
        SubContent = "V. 1.0", -- Optional
        Duration = 5 -- Set to nil to make the notification not disappear
    })
 
 
 
    Tabs.Main:AddParagraph({
        Title = "By @SFXCL",
        Content = "Welcome to the ASTRALCHEAT.\nJoin our Telegram for more!"
    })
 
    Tabs.Main:AddButton({
        Title = "Server invite",
        Description = "Copy our Telegram server invite",
        Callback = function()
            setclipboard("t.me//SFXCL")
        end
    })
 
    Tabs.Universal:AddButton({
        Title = "Запустить",
        Description = "Телеграм @SFXCL",
        Callback = function()
            local Camera = workspace.CurrentCamera
            local Players = game:GetService("Players")
            local RunService = game:GetService("RunService")
            local UserInputService = game:GetService("UserInputService")
            local TweenService = game:GetService("TweenService")
            local LocalPlayer = Players.LocalPlayer
            local Holding = false
 
            _G.AimbotEnabled = true
            _G.TeamCheck = false -- If set to true then the script would only lock your aim at enemy team members.
            _G.AimPart = "Head" -- Where the aimbot script would lock at.
            _G.Sensitivity = 0 -- How many seconds it takes for the aimbot script to officially lock onto the target's aimpart.
 
            _G.CircleSides = 64 -- How many sides the FOV circle would have.
            _G.CircleColor = Color3.fromRGB(255, 255, 255) -- (RGB) Color that the FOV circle would appear as.
            _G.CircleTransparency = 0.7 -- Transparency of the circle.
            _G.CircleRadius = 80 -- The radius of the circle / FOV.
            _G.CircleFilled = false -- Determines whether or not the circle is filled.
            _G.CircleVisible = true -- Determines whether or not the circle is visible.
            _G.CircleThickness = 0 -- The thickness of the circle.
 
            local FOVCircle = Drawing.new("Circle")
            FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
            FOVCircle.Radius = _G.CircleRadius
            FOVCircle.Filled = _G.CircleFilled
            FOVCircle.Color = _G.CircleColor
            FOVCircle.Visible = _G.CircleVisible
            FOVCircle.Radius = _G.CircleRadius
            FOVCircle.Transparency = _G.CircleTransparency
            FOVCircle.NumSides = _G.CircleSides
            FOVCircle.Thickness = _G.CircleThickness
 
            local function GetClosestPlayer()
                local MaximumDistance = _G.CircleRadius
                local Target = nil
 
                for _, v in next, Players:GetPlayers() do
                    if v.Name ~= LocalPlayer.Name then
                        if _G.TeamCheck == true then
                            if v.Team ~= LocalPlayer.Team then
                                if v.Character ~= nil then
                                    if v.Character:FindFirstChild("HumanoidRootPart") ~= nil then
                                        if v.Character:FindFirstChild("Humanoid") ~= nil and v.Character:FindFirstChild("Humanoid").Health ~= 0 then
                                            local ScreenPoint = Camera:WorldToScreenPoint(v.Character:WaitForChild("HumanoidRootPart", math.huge).Position)
                                            local VectorDistance = (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(ScreenPoint.X, ScreenPoint.Y)).Magnitude
 
                                            if VectorDistance < MaximumDistance then
                                                Target = v
                                            end
                                        end
                                    end
                                end
                            end
                        else
                            if v.Character ~= nil then
                                if v.Character:FindFirstChild("HumanoidRootPart") ~= nil then
                                    if v.Character:FindFirstChild("Humanoid") ~= nil and v.Character:FindFirstChild("Humanoid").Health ~= 0 then
                                        local ScreenPoint = Camera:WorldToScreenPoint(v.Character:WaitForChild("HumanoidRootPart", math.huge).Position)
                                        local VectorDistance = (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(ScreenPoint.X, ScreenPoint.Y)).Magnitude
 
                                        if VectorDistance < MaximumDistance then
                                            Target = v
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
 
                return Target
            end
 
            UserInputService.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton2 then
                    Holding = true
                end
            end)
 
            UserInputService.InputEnded:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton2 then
                    Holding = false
                end
            end)
 
            RunService.RenderStepped:Connect(function()
                FOVCircle.Position = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
                FOVCircle.Radius = _G.CircleRadius
                FOVCircle.Filled = _G.CircleFilled
                FOVCircle.Color = _G.CircleColor
                FOVCircle.Visible = _G.CircleVisible
                FOVCircle.Radius = _G.CircleRadius
                FOVCircle.Transparency = _G.CircleTransparency
                FOVCircle.NumSides = _G.CircleSides
                FOVCircle.Thickness = _G.CircleThickness
 
                if Holding == true and _G.AimbotEnabled == true then
                    TweenService:Create(Camera, TweenInfo.new(_G.Sensitivity, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = CFrame.new(Camera.CFrame.Position, GetClosestPlayer().Character[_G.AimPart].Position)}):Play()
                end
            end)
        end
    })
 
   Tabs.v1v1pistol:AddButton({
        Title = "Запустить",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/VapeVoidware/VWExtra/main/NightsInTheForest.lua", true))()
        end
    })
 
    Tabs.jumpeverysec:AddButton({
        Title = "Запустить",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/gayah6996-del/Tesyjng2-/refs/heads/main/Tower%20Of%20Hell.lua'))()
        end
    })
 
    Tabs.c3008:AddButton({
        Title = "Запустить",
        Description = "Телеграм @SFXCL",
        Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/Estevansit0/KJJK/refs/heads/main/PusarX-loader.lua"))()
        end
    })
 
    Tabs.Abilitywars:AddButton({
        Title = "Запустить",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/gayah6996-del/Tesyjng2-/refs/heads/main/Murder%20Mystery%202%20Roblox%20Script.lua"))()
        end
    })
 
    Tabs.Ageofheroes:AddButton({
        Title = "Запустить",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/gayah6996-del/Tesyjng2-/refs/heads/main/Evade.lua"))()
        end
    })
 
    Tabs.Aimblox:AddButton({
        Title = "GUI",
        Description = "Телеграм @SFXCL",
        Callback = function()
            print("Soon")
        end
    })
 
    Tabs.Animefightersim:AddButton({
        Title = "DeadTired Hub",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet(('https://raw.githubusercontent.com/pspboy08/dollhouse/main/AFSGUI.lua')))()
        end
    })
 
    Tabs.Animespeedrace:AddButton({
        Title = "Apple Hub",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet(("https://raw.githubusercontent.com/AppleScript001/Anime_Speed_Race_GUI/main/README.md"),true))()
        end
    })
 
    Tabs.Antlife:AddButton({
        Title = "AntHaxx Hub",
        Description = "Телеграм @SFXCL",
        Callback = function()
            getgenv().AntHaxxLite = true loadstring(game:HttpGet('https://raw.githubusercontent.com/TestAccount69420xd/7632755652/main/943242049'))()
        end
    })
 
    Tabs.Arsenal:AddButton({
        Title = "Thunder Client",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/b95e8fecdf824e41f4a030044b055add.lua"))()
        end
    })
 
    Tabs.Arsenal:AddButton({
        Title = "Arsenal X",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/helldevelopment/RobloxScripts/main/SanityLoader.lua"))()
        end
    })
 
    Tabs.Arsenal:AddButton({
        Title = "OP",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/AFGCLIENT/Snyware/main/Loader'))()
        end
    })
 
    Tabs.Attackontitan:AddButton({
        Title = "Handles Hub",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:GetObjects("rbxassetid://14713089094")[1].Source)()
        end
    })
 
    Tabs.Basketballlegends:AddButton({
        Title = "Auto Green",
        Description = "Телеграм @SFXCL",
        Callback = function()
            _G.OBFHUBFREE = "2kmembersgang"
        loadstring(game:HttpGet("https://raw.githubusercontent.com/obfhub/free/main/basketmball"))()
        end
    })
 
    Tabs.Beaduck:AddButton({
        Title = "ArceusX Hub",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Bac0nHck/Scripts/main/BeADuck"))("t.me/arceusxscripts")
        end
    })
 
    Tabs.Benpcordie:AddButton({
        Title = "ArceusX Hub",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Bac0nHck/Scripts/main/BeNpcOrDie"))("t.me/arceusxscripts")
        end
    })
 
    Tabs.Beattherobloxian:AddButton({
        Title = "OP hub",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet("https://scriptblox.com/raw/NEW-WORLD-Beat-the-Robloxian!-Beta-Destroy-Thy-NPCs-9559"))()
        end
    })
 
    Tabs.BedWars:AddButton({
        Title = "AFG Hub",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/AFGCLIENT/Snyware/main/Loader"))()
        end
    })
 
    Tabs.BedWars:AddButton({
        Title = "Flame X",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/FlamingDrey/Flame-X-v2/main/Flame%20X%20Bedwars%20V2"))()
        end
    })
 
    Tabs.Bettermusic:AddButton({
        Title = "ArceusX Hub",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Bac0nHck/Scripts/main/BetterMusic"))("t.me/arceusxscripts")
        end
    })
 
    Tabs.BladeBall:AddButton({
        Title = "Auto Parry",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet("https://gist.githubusercontent.com/MoonDevRed/40e7751aa410b4e12523f8c33d3ed2b0/raw/446621b0f9af44e6957dbe94c5fa3363cd2062bf/Auto%20Parry"))()
        end
    })
 
    Tabs.BladeBall:AddButton({
        Title = "EMINx Hub",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/EminenceXLua/Blade-your-Balls/main/BladeBallLoader.lua"))()
        end
    })
 
    Tabs.BladeBall:AddButton({
        Title = "Auto parry with visualizer",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet("https://scriptblox.com/raw/UPD-Blade-Ball-op-autoparry-with-visualizer-8652"))()
        end
    })
 
    Tabs.BladeBall:AddButton({
        Title = "FFJ1 Hub",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/FFJ1/Roblox-Exploits/main/scripts/Loader.lua"))()
        end
    })
 
    Tabs.BladeBall:AddButton({
        Title = "Visual Hub",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/a5945467f3b9388503ca653c0ea49cba.lua"))()
        end
    })
 
    Tabs.Bladeslayer:AddButton({
        Title = "Dkzin Hub",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Christian2703/Main/main/Mainscript", true))()
        end
    })
 
    Tabs.Bloxhunt:AddButton({
        Title = "Infinite Token",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet("https://bloxxyserverfiles.netlify.app/InfiniteMoney"))()
        end
    })
 
    Tabs.Bloxburg:AddButton({
        Title = "Whimper Hub",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet('https://whimper.xyz/kitty'))()
        end
    })
 
    Tabs.Bloxfruit:AddButton({
        Title = "Annie Hub",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/1st-Mars/Annie/main/1st.lua'))()
        end
    })
 
    Tabs.Bloxfruit:AddButton({
        Title = "Matsune Hub",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Yatsuraa/Yuri/main/Winterhub_V2.lua"))()
        end
    })
 
    Tabs.Bloxfruit:AddButton({
        Title = "Min Gaming Hub",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet"https://raw.githubusercontent.com/Basicallyy/Basicallyy/main/MinGamingV4.lua")()
        end
    })
 
    Tabs.Blockdiggingsim:AddButton({
        Title = "ArceusX Hub",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Bac0nHck/Scripts/main/Block%20Digging%20Simulator"))()
        end
    })
 
    Tabs.Boxingleague:AddButton({
        Title = "Private Hub",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/SethProYT/boxing-league-script/main/script"))()
        end
    })
 
    Tabs.Breakin2:AddButton({
        Title = "Free gamepass",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/RScriptz/RobloxScripts/main/BreakIn2.lua"))()
        end
    })
 
    Tabs.Breakingpoint:AddButton({
        Title = "Buster Hub",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/ColdStep2/Breaking-Point-Funny-Squid-Hax/main/Breaking%20Point%20Funny%20Squid%20Hax",true))();
        end
    })
 
    Tabs.BrimsRNG:AddButton({
        Title = "Every aura",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet("https://scriptblox.com/raw/Bims-RNG-1-Million-Visits-Event-Get-Every-Aura-14612"))()
        end
    })
 
    Tabs.Brookhaven:AddButton({
        Title = "R4D Hub",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/M1ZZ001/BrookhavenR4D/main/Brookhaven%20R4D%20Script'))()
        end
    })
 
    Tabs.Buildaboatfortreasure:AddButton({
        Title = "Auto win",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet(("https://pastebin.com/raw/mT10xnt7"), true))()
        end
    })
 
    Tabs.Buildabunkertosurvivezombies:AddButton({
        Title = "AFG Hub",
        Description = "Телеграм @SFXCL",
        Callback = function()
            while true do 
                wait()
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("FinishMinigame"):FireServer()
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("FinishMinigame"):FireServer()
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("FinishMinigame"):FireServer()
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("FinishMinigame"):FireServer()
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("FinishMinigame"):FireServer()
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("FinishMinigame"):FireServer()
            end
        end
    })
 
    Tabs.Calishotout:AddButton({
        Title = "Autocut",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet(("https://gus.exploiter.info/p/raw/nh9zrifnfd"),true))()
        end
    })
 
    Tabs.CardRNG:AddButton({
        Title = "Tatsumaki Hub",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Tatsumaki49/main/main/CardRNG"))();
        end
    })
 
    Tabs.Cardealershiptycoon:AddButton({
        Title = "Auto farm",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet(('https://pastefy.app/Q9YwUEpV/raw'),true))()
        end
    })
 
    Tabs.Clickermadness:AddButton({
        Title = "Super autoclick",
        Description = "Телеграм @SFXCL",
        Callback = function()
            game:GetService("RunService").Stepped:Connect(function()
            game:GetService("ReplicatedStorage").Aero.AeroRemoteServices.ClickService.Click:FireServer(1)
        end)
        end
    })
 
    Tabs.Combatwarriors:AddButton({
        Title = "OP Hub",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/IsaaaKK/cwhb/main/cw.txt"))()
        end
    })
 
    Tabs.Combatwarriors:AddButton({
        Title = "Bird Hub",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet('https://pastebin.com/raw/pexrijZn'))()
        end
    })
 
    Tabs.Combatwarriors:AddButton({
        Title = "Aimbot",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet("https://pastebin.com/raw/a4xrM2Ne"))()
        end
    })
 
    Tabs.Combatwarriors:AddButton({
        Title = "Flare Hub",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/1f0yt/community/master/flare"))()
        end
    })
 
    Tabs.Counterblox:AddButton({
        Title = "AFG Hub",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/AFGCLIENT/Snyware/main/Loader'))()
        end
    })
 
    Tabs.Counterblox:AddButton({
        Title = "Solaris",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/toasty-dev/pissblox/main/solaris_bootstrapper.lua",true))()
        end
    })
 
    Tabs.Criminality:AddButton({
        Title = "Fenware",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet("https://scriptblox.com/raw/SUMMER-Criminality-Alternative-all-OP-features-4305"))()
        end
    })
 
    Tabs.Criminality:AddButton({
        Title = "Aimbot & ESP",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet('https://pastebin.com/raw/taKWxmZe'))()
        end
    })
 
    Tabs.Damtycoon:AddButton({
        Title = "Infinite Cash",
        Description = "Телеграм @SFXCL",
        Callback = function()
            local args = {
            [1] = -9e17,
            [2] = "drive40k"
        }
 
        game:GetService("ReplicatedStorage").TaxCouncilor:FireServer(unpack(args))
        end
    })
 
    Tabs.DaHood:AddButton({
        Title = "Dahood Hubs",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/YoungMetrosz/dahood-script-hub/main/Dahood%20script%20hub"))()
        end
    })
 
    Tabs.Doomspirebrickbattle:AddButton({
        Title = "Bring all",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/offperms/doomspire/main/script4eagl", true))()
        end
    })
 
    Tabs.Deacyingwinter:AddButton({
        Title = "op",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet("https://scriptblox.com/raw/Decaying-Winter-DW-OP-Script-6859"))()
        end
    })
 
    Tabs.Demonfall:AddButton({
        Title = "LeadMarker Hub",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet("https://scriptblox.com/raw/Demonfall-2.65-Demon-Fall-Script-6131"))()
        end
    })
 
    Tabs.Demonfall:AddButton({
        Title = "L4BIB Hub",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet("https://scriptblox.com/raw/Demonfall-Demon-Fall-Solara-Supported-14677"))()
        end
    })
 
    Tabs.Doors:AddButton({
        Title = "FFJ Hub",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet('https://rawscripts.net/raw/DOORS-FFJ-Hub-11365'))()
        end
    })
 
    Tabs.Doors:AddButton({
        Title = "Bob Hub",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGetAsync("https://pastebin.com/raw/R8QMbhzv"))()()
        end
    })
 
    Tabs.Driveworld:AddButton({
        Title = "Mercury Hub",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet("https://scriptblox.com/raw/Drive-World-Auto-farm-make-8M-or-6m-in-1-hour-6960"))()
        end
    })
 
    Tabs.Drivingempire:AddButton({
        Title = "Soon",
        Description = "Телеграм @SFXCL",
        Callback = function()
             --Vars
 
        LocalPlayer = game:GetService("Players").LocalPlayer
 
        Camera = workspace.CurrentCamera
 
        VirtualUser = game:GetService("VirtualUser")
 
        MarketplaceService = game:GetService("MarketplaceService")
 
 
 
        --Get Current Vehicle
 
        function GetCurrentVehicle()
 
            return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") and LocalPlayer.Character.Humanoid.SeatPart and LocalPlayer.Character.Humanoid.SeatPart.Parent
 
        end
 
 
 
        --Regular TP
 
        function TP(cframe)
 
            GetCurrentVehicle():SetPrimaryPartCFrame(cframe)
 
        end
 
 
 
        --Velocity TP
 
        function VelocityTP(cframe)
 
            TeleportSpeed = math.random(600, 600)
 
            Car = GetCurrentVehicle()
 
            local BodyGyro = Instance.new("BodyGyro", Car.PrimaryPart)
 
            BodyGyro.P = 5000
 
            BodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
 
            BodyGyro.CFrame = Car.PrimaryPart.CFrame
 
            local BodyVelocity = Instance.new("BodyVelocity", Car.PrimaryPart)
 
            BodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
 
            BodyVelocity.Velocity = CFrame.new(Car.PrimaryPart.Position, cframe.p).LookVector * TeleportSpeed
 
            wait((Car.PrimaryPart.Position - cframe.p).Magnitude / TeleportSpeed)
 
            BodyVelocity.Velocity = Vector3.new()
 
            wait(0.1)
 
            BodyVelocity:Destroy()
 
            BodyGyro:Destroy()
 
        end
 
 
 
        --Auto Farm
 
        StartPosition = CFrame.new(Vector3.new(4940.19775, 66.0195084, -1933.99927, 0.343969434, -0.00796990748, -0.938947022, 0.00281227613, 0.999968231, -0.00745762791, 0.938976645, -7.53822824e-05, 0.343980938), Vector3.new())
 
        EndPosition = CFrame.new(Vector3.new(1827.3407, 66.0150146, -658.946655, -0.366112858, 0.00818905979, 0.930534422, 0.00240773871, 0.999966264, -0.00785277691, -0.930567324, -0.000634518801, -0.366120219), Vector3.new())
 
        AutoFarmFunc = coroutine.create(function()
 
            while wait() do
 
                if not AutoFarm then
 
                    AutoFarmRunning = false
 
                    coroutine.yield()
 
                end
 
                AutoFarmRunning = true
 
                pcall(function()
 
                    if not GetCurrentVehicle() and tick() - (LastNotif or 0) > 5 then
 
                        LastNotif = tick()
 
                    else
 
                        TP(StartPosition + (TouchTheRoad and Vector3.new(0,0,0) or Vector3.new(0, 0, 0)))
 
                        VelocityTP(EndPosition + (TouchTheRoad and Vector3.new() or Vector3.new(0, 0, 0)))
 
                        TP(EndPosition + (TouchTheRoad and Vector3.new() or Vector3.new(0, 0, 0)))
 
                        VelocityTP(StartPosition + (TouchTheRoad and Vector3.new() or Vector3.new(0, 0, 0)))
 
                    end
 
                end)
 
            end
 
        end)
 
 
 
        --Anti AFK
 
        AntiAFK = true
 
        LocalPlayer.Idled:Connect(function()
 
            VirtualUser:CaptureController()
 
            VirtualUser:ClickButton2(Vector2.new(), Camera.CFrame)
 
        end)
 
 
 
        local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Simak90/pfsetcetc/main/fluxed.lua"))() -- UI Library
 
                local win = lib:Window("MaxHub", "Signed By JMaxeyy", Color3.fromRGB(255, 0, 0), _G.closeBind) -- done mess with
 
 
 
                ---------Spins--------------------------------
 
                local Visual = win:Tab("Farm Section", "http://www.roblox.com/asset/?id=6023426915")
 
                Visual:Label("Farms")
 
                Visual:Line()
 
 
 
                Visual:Toggle("Auto Farm", "Activates farm. Get in car to start",false, function(value)
 
                    AutoFarm = value
 
                        if value and not AutoFarmRunning then
 
                            coroutine.resume(AutoFarmFunc)
 
                        end
 
                end)
 
                Visual:Toggle("TouchTheRoad", "doesnt work for some cars",false, function(value)
 
                    TouchTheRoad = value
 
                end)
 
                Visual:Toggle("AntiAFK", "simulates keypressing",false, function(value)
 
                    AntiAFK = value
 
                end)
        end
    })
 
    Tabs.Dungeonquest:AddButton({
        Title = "HoHo Hub",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/acsu123/HOHO_H/main/Loading_UI'))()
        end
    })
 
    Tabs.Dustytrip:AddButton({
        Title = "Handles Hub",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/LOLking123456/dusty/main/trip"))()
        end
    })
 
    Tabs.Eatslimestogrowhuge:AddButton({
        Title = "Free award spin",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet("https://scriptblox.com/raw/Eat-Slimes-to-Grow-HUGE-SpinSizeGui-FREE-AWARD-BY-CHAT-GPT-xDDD-14723"))()
        end
    })
 
    Tabs.Epicminigames:AddButton({
        Title = "OP",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/SlamminPig/rblxgames/main/Epic%20Minigames/EpicMinigamesGUI"))()
        end
    })
 
    Tabs.Evade:AddButton({
        Title = "Tbao Hub",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/tbao143/thaibao/main/TbaoHubEvade"))()
        end
    })
 
    Tabs.FF2:AddButton({
        Title = "Clouted Hub",
        Description = "Be careful with inf jump or speed boost",
        Callback = function()
            loadstring(game:HttpGet("https://scriptblox.com/raw/Football-Fusion-2-ALL-IN-ONE-FF-SCRIPT-6398"))()
        end
    })
 
    Tabs.Fightinaschool:AddButton({
        Title = "Запустить",
        Description = "Мой телеграмм, @SFXCL",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/VapeVoidware/VWExtra/main/NightsInTheForest.lua"))()
        end
    })
 
    Tabs.Findtheauras:AddButton({
        Title = "Soon...",
        Description = "Телеграм @SFXCL",
        Callback = function()
            print("I SAID SOON!!!")
        end
    })
 
    Tabs.Findtheflag:AddButton({
        Title = "Soon...",
        Description = "Телеграм @SFXCL",
        Callback = function()
            print("I SAID SOON!!!")
        end
    })
 
    Tabs.Fleethefacility:AddButton({
        Title = "Mercury Hub",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet("https://pastebin.com/raw/1GEWA6th"))()
        end
    })
 
    Tabs.Flingthingsandpeople:AddButton({
        Title = "OP",
        Description = "Key: TryHardV3",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/BlizTBr/scripts/main/FTAP.lua"))()
        end
    })
 
    Tabs.Frontlines:AddButton({
        Title = "Hitbox & ESP",
        Description = "Телеграм @SFXCL",
        Callback = function()
            -- Set hitbox size, transparency level, and notification status
local size = Vector3.new(15, 15, 15)
local trans = 0.85
local notifications = false
 
-- Store the time when the code starts executing
local start = os.clock()
 
-- Send a notification saying that the script is loading
game.StarterGui:SetCore("SendNotification", {
   Title = "gimme ur cheats johann",
   Text = "pls gimme ur cheats now johann.",
   Icon = "",
   Duration = 5
})
 
-- Load the ESP library and turn it on
local esp = loadstring(game:HttpGet("https://raw.githubusercontent.com/andrewc0de/Roblox/main/Dependencies/ESP.lua"))()
esp:Toggle(true)
 
-- Configure ESP settings
esp.Boxes = true
esp.Names = false
esp.Tracers = false
esp.Players = false
 
-- Add an object listener to the workspace to detect enemy models
esp:AddObjectListener(workspace, {
   Name = "soldier_model",
   Type = "Model",
   Color = Color3.fromRGB(255, 0, 4),
 
   -- Specify the primary part of the model as the HumanoidRootPart
   PrimaryPart = function(obj)
       local root
       repeat
           root = obj:FindFirstChild("HumanoidRootPart")
           task.wait()
       until root
       return root
   end,
 
   -- Use a validator function to ensure that models do not have the "friendly_marker" child
   Validator = function(obj)
       task.wait(1)
       if obj:FindFirstChild("friendly_marker") then
           return false
       end
       return true
   end,
 
   -- Set a custom name to use for the enemy models
   CustomName = "?",
 
   -- Enable the ESP for enemy models
   IsEnabled = "enemy"
})
 
-- Enable the ESP for enemy models
esp.enemy = true
 
-- Wait for the game to load fully before applying hitboxes
task.wait(1)
 
-- Apply hitboxes to all existing enemy models in the workspace
for _, v in pairs(workspace:GetDescendants()) do
   if v.Name == "soldier_model" and v:IsA("Model") and not v:FindFirstChild("friendly_marker") then
       local pos = v:FindFirstChild("HumanoidRootPart").Position
       for _, bp in pairs(workspace:GetChildren()) do
           if bp:IsA("BasePart") then
               local distance = (bp.Position - pos).Magnitude
               if distance <= 5 then
                   bp.Transparency = trans
                   bp.Size = size
               end
           end
       end
   end
end
 
-- Function to handle when a new descendant is added to the workspace
local function handleDescendantAdded(descendant)
   task.wait(1)
 
   -- If the new descendant is an enemy model and notifications are enabled, send a notification
   if descendant.Name == "soldier_model" and descendant:IsA("Model") and not descendant:FindFirstChild("friendly_marker") then
       if notifications then
           game.StarterGui:SetCore("SendNotification", {
               Title = "gimme ur script now johann",
               Text = "[Warning] New Enemy Spawned! Applied hitboxes.",
               Icon = "",
               Duration = 3
           })
       end
 
       -- Apply hitboxes to the new enemy model
       local pos = descendant:FindFirstChild("HumanoidRootPart").Position
       for _, bp in pairs(workspace:GetChildren()) do
           if bp:IsA("BasePart") then
               local distance = (bp.Position - pos).Magnitude
               if distance <= 5 then
                   bp.Transparency = trans
                   bp.Size = size
               end
           end
       end
   end
end
 
-- Connect the handleDescendantAdded function to the DescendantAdded event of the workspace
task.spawn(function()
   game.Workspace.DescendantAdded:Connect(handleDescendantAdded)
end)
 
-- Store the time when the code finishes executing
local finish = os.clock()
 
-- Calculate how long the code took to run and determine a rating for the loading speed
local time = finish - start
local rating
if time < 3 then
   rating = "fast"
elseif time < 5 then
   rating = "acceptable"
else
   rating = "slow"
end
 
-- Send a notification showing how long the code took to run and its rating
game.StarterGui:SetCore("SendNotification", {
   Title = "Script",
   Text = string.format("Script loaded in %.2f seconds (%s loading)", time, rating),
   Icon = "",
   Duration = 5
})
        end
    })
 
    Tabs.Fruitarena:AddButton({
        Title = "Kill all",
        Description = "Spawn as any character to make it work",
        Callback = function()
            while true do
    local player = game.Players.LocalPlayer
    for i,v in ipairs(game.Players:GetPlayers()) do
        if v.Name ~= player.Name then
            local JK = v.Character
            if JK then
                local args = {
                [1] = {
                ["\31"] = {
                [1] = JK,
                [2] = "Player",
                [3] = CFrame.new(53.118247985839844, 2053.923583984375, -5.949551582336426) * CFrame.Angles(-3.141592502593994, -1.2932220697402954, -3.141592502593994)
                }
                },
                [2] = {}
                }
                game:GetService("ReplicatedStorage").RedEvent:FireServer(unpack(args))
            end
        end
    end
    wait(0.1)
end
        end
    })
 
    Tabs.Fruitswarriors:AddButton({
        Title = "LeadMarker Hub",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/LeadMarker/opensrc/main/FruitWarriors/FruitWarriors.lua'))()
        end
    })
 
    Tabs.FudgeRNG:AddButton({
        Title = "Quick roll & auto roll",
        Description = "Press once, if u spam it will get you banned",
        Callback = function()
            while true do
game:GetService("ReplicatedStorage"):WaitForChild("remotes"):WaitForChild("spin"):FireServer()
wait(1)
end
        end
    })
 
    Tabs.Ganguponpeoplesim:AddButton({
        Title = "Autofarm",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/7hbl/gang-up-on-ppl-sim/main/gang%20up%20on%20ppl "))();
        end
    })
 
    Tabs.Gethitbyacarsim:AddButton({
        Title = "Soon",
        Description = "Телеграм @SFXCL",
        Callback = function()
            print("I SAID SOON!!!")
        end
    })
 
    Tabs.Godswill:AddButton({
        Title = "Soon",
        Description = "Телеграм @SFXCL",
        Callback = function()
            print("I SAID SOON!!!")
        end
    })
 
    Tabs.Trackandfieldinfinite:AddButton({
        Title = "54 Hub",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/GuizzyisbackV2LOL/Track-Field/main/free.lua"))()
        end
    })
 
    Tabs.Treasurehuntsim:AddButton({
        Title = "Auto Farm/Rebirth",
        Description = "Телеграм @SFXCL",
        Callback = function()
            local TresureBreakSimulator = Instance.new("ScreenGui")
            local BG = Instance.new("Frame")
            local Line = Instance.new("Frame")
            local ToolBoxBG = Instance.new("Frame")
            local ToolBox = Instance.new("TextBox")
            local AutoFarm = Instance.new("TextButton")
            local AutoRebirth = Instance.new("TextButton")
            local Top = Instance.new("TextLabel")
 
            --Toggle
            local Farm = false
            local Rebirth = false
 
            --ButtonToggle
            local Click1 = false
            local Click2 = false
 
            TresureBreakSimulator.Name = "TresureBreakSimulator"
            TresureBreakSimulator.Parent = game.CoreGui
            TresureBreakSimulator.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            BG.Name = "BG"
            BG.Parent = TresureBreakSimulator
            BG.BackgroundColor3 = Color3.new(1, 0.823529, 0.54902)
            BG.BackgroundTransparency = 0.20000000298023
            BG.BorderColor3 = Color3.new(0, 0, 0)
            BG.BorderSizePixel = 5
            BG.Position = UDim2.new(0.604587197, 0, 0.30796814, 0)
            BG.Size = UDim2.new(0, 250, 0, 150)
            BG.Active = true
            BG.Selectable = true
            BG.Draggable = true
            Line.Name = "Line"
            Line.Parent = BG
            Line.BackgroundColor3 = Color3.new(0, 0, 0)
            Line.BorderSizePixel = 0
            Line.Position = UDim2.new(0, 0, 0, 72)
            Line.Size = UDim2.new(0, 250, 0, 5)
            ToolBoxBG.Name = "ToolBoxBG"
            ToolBoxBG.Parent = BG
            ToolBoxBG.BackgroundColor3 = Color3.new(1, 0.823529, 0.54902)
            ToolBoxBG.BackgroundTransparency = 0.20000000298023
            ToolBoxBG.BorderColor3 = Color3.new(0, 0, 0)
            ToolBoxBG.BorderSizePixel = 5
            ToolBoxBG.Position = UDim2.new(0, 25, 1, 5)
            ToolBoxBG.Size = UDim2.new(0, 200, 0, 50)
            ToolBox.Name = "ToolBox"
            ToolBox.Parent = ToolBoxBG
            ToolBox.BackgroundColor3 = Color3.new(0.490196, 0.490196, 0.490196)
            ToolBox.BorderColor3 = Color3.new(0.0980392, 0.0980392, 0.0980392)
            ToolBox.BorderSizePixel = 0
            ToolBox.Size = UDim2.new(0, 200, 0, 50)
            ToolBox.Font = Enum.Font.GothamBold
            ToolBox.PlaceholderColor3 = Color3.new(0, 0, 0)
            ToolBox.PlaceholderText = "Tool Name"
            ToolBox.Text = game.Players.LocalPlayer.Backpack:FindFirstChildOfClass("Tool").Name
            ToolBox.TextColor3 = Color3.new(0, 0, 0)
            ToolBox.TextSize = 35
            ToolBox.TextWrapped = true
            AutoFarm.Name = "AutoFarm"
            AutoFarm.Parent = BG
            AutoFarm.BackgroundColor3 = Color3.new(0.882353, 0.882353, 0.882353)
            AutoFarm.BorderColor3 = Color3.new(1, 0, 0)
            AutoFarm.BorderSizePixel = 5
            AutoFarm.Position = UDim2.new(0, 25, 0, 5)
            AutoFarm.Size = UDim2.new(0, 200, 0, 62)
            AutoFarm.Font = Enum.Font.GothamBold
            AutoFarm.Text = "Auto Farm"
            AutoFarm.TextColor3 = Color3.new(1, 0, 0)
            AutoFarm.TextScaled = true
            AutoFarm.TextSize = 14
            AutoFarm.TextWrapped = true
            AutoFarm.MouseButton1Click:Connect(function()
                if Click1 then
                    Click1 = false
                    Farm = false
                    AutoFarm.TextColor3 = Color3.new(1,0,0)
                    AutoFarm.BorderColor3 = Color3.new(1,0,0)
                else
                    if game.Players.LocalPlayer.Character:FindFirstChild(ToolBox.Text) then
                        print('Already EquipTool')
                    else
                        game.Players.LocalPlayer.Character.Humanoid:EquipTool(game.Players.LocalPlayer.Backpack[ToolBox.Text])
                    end
                    Click1 = true
                    Farm = true
                    AutoFarm.TextColor3 = Color3.new(0,1,0)
                    AutoFarm.BorderColor3 = Color3.new(0,1,0)
                end
            end)
            AutoRebirth.Name = "AutoRebirth"
            AutoRebirth.Parent = BG
            AutoRebirth.BackgroundColor3 = Color3.new(0.882353, 0.882353, 0.882353)
            AutoRebirth.BorderColor3 = Color3.new(1, 0, 0)
            AutoRebirth.BorderSizePixel = 5
            AutoRebirth.Position = UDim2.new(0, 25, 0, 82)
            AutoRebirth.Size = UDim2.new(0, 200, 0, 62)
            AutoRebirth.Font = Enum.Font.GothamBold
            AutoRebirth.Text = "Auto Rebirth"
            AutoRebirth.TextColor3 = Color3.new(1, 0, 0)
            AutoRebirth.TextScaled = true
            AutoRebirth.TextSize = 14
            AutoRebirth.TextWrapped = true
            AutoRebirth.MouseButton1Click:Connect(function()
                if Click1 then
                    Click1 = false
                    Rebirth = false
                    AutoRebirth.TextColor3 = Color3.new(1,0,0)
                    AutoRebirth.BorderColor3 = Color3.new(1,0,0)
                else
                    Click1 = true
                    Rebirth = true
                    AutoRebirth.TextColor3 = Color3.new(0,1,0)
                    AutoRebirth.BorderColor3 = Color3.new(0,1,0)
                end
            end)
            Top.Name = "Top"
            Top.Parent = BG
            Top.Active = true
            Top.BackgroundColor3 = Color3.new(1, 0.823529, 0.54902)
            Top.BorderColor3 = Color3.new(0, 0, 0)
            Top.BorderSizePixel = 5
            Top.Position = UDim2.new(0, 25, 0, -30)
            Top.Selectable = true
            Top.Size = UDim2.new(0, 200, 0, 25)
            Top.Font = Enum.Font.GothamBold
            Top.Text = "Treasure Break Simulator"
            Top.TextColor3 = Color3.new(0, 0, 0)
            Top.TextScaled = true
            Top.TextSize = 14
            Top.TextWrapped = true
 
            local Character = game.Workspace:WaitForChild(game.Players.LocalPlayer.Name)
 
            function Sell()
                local OldPos = Character.HumanoidRootPart.CFrame
                Character.HumanoidRootPart.CFrame = CFrame.new(3, 10, -160)
                game.ReplicatedStorage.Events.AreaSell:FireServer()
                wait(0.1)
                Character.HumanoidRootPart.CFrame = OldPos
            end
 
            local function RE()
                while true do
                    wait(1)
                    if Rebirth == true then
                        local a = game.Players.LocalPlayer.PlayerGui.Gui.Buttons.Coins.Amount.Text:gsub(',','')
                        local b = game.Players.LocalPlayer.PlayerGui.Gui.Rebirth.Needed.Coins.Amount.Text:gsub(',','')
                        print(tonumber(a))
                        print(tonumber(b))
                        if tonumber(a) > tonumber(b) then 
                            warn('Calculation Complete!')
                            game.ReplicatedStorage.Events.Rebirth:FireServer()
                            ToolBox.Text = "Bucket"
                            repeat wait(.1) until game.Players.LocalPlayer.PlayerGui.Gui.Popups.GiveReward.Visible == true
                            game.Players.LocalPlayer.PlayerGui.Gui.Popups.GiveReward.Visible = false
                            wait()
                        end
                    end
                end
            end
 
            spawn(RE)
 
            while true do
                wait()
                if Farm then
                    local Sand = nil
                    local SandName = ""
                    for i,v in pairs (game.Workspace.SandBlocks:GetChildren()) do
                        if not Farm then 
                            Sell()
                            break 
                        end
                        if v:FindFirstChild("Chest") then
                            if v.CFrame.X > -40 and v.CFrame.X < 20 and v.CFrame.Z < -175 and v.CFrame.Z > -235 then
                                local Next = false
                                if v == nil then
                                    Next = false
                                else
                                    Next = true
                                    Sand = v
                                    SandName = v.Name
                                end
                                if Next == true then
                                    local Success,Problem = pcall(function()
                                    if game.Players[game.Players.LocalPlayer.Name].PlayerGui.Gui.Popups.BackpackFull.Visible == true then Sell() end
                                        Sand.CanCollide = false
                                        local Coins = game.Players.LocalPlayer.PlayerGui.Gui.Buttons.Coins.Amount.Text
                                        repeat
                                            if game.Players[game.Players.LocalPlayer.Name].PlayerGui.Gui.Popups.BackpackFull.Visible == true then Sell() end
                                            if not Farm then 
                                                wait(.1)
                                                Character.HumanoidRootPart.CFrame = CFrame.new(3, 10, -160)
                                                wait(1)
                                                break 
                                            end
                                            Character.HumanoidRootPart.Anchored = true
                                            wait()
                                            Character.HumanoidRootPart.CFrame = Sand.CFrame
                                            wait()
                                            Character.HumanoidRootPart.Anchored = false
                                            Character:WaitForChild(ToolBox.Text)['RemoteClick']:FireServer(game.Workspace.SandBlocks[SandName])
                                            wait()
                                        until game.Players.LocalPlayer.PlayerGui.Gui.Buttons.Coins.Amount.Text ~= Coins
                                        Next = false
                                    end)
                                    if Success then
                                        print('Worked')
                                    else
                                        warn(Problem)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    })
 
    Tabs.TPSstreetsoccer:AddButton({
        Title = "Byte Hub",
        Description = "Key: ByteHubIsForever",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/DamThien332/TPS-Script/main/Main-ByteHub.lua"))()
        end
    })
 
    Tabs.Typesoul:AddButton({
        Title = "Mercury Hub",
        Description = "Телеграм @SFXCL",
        Callback = function()
            --//Variables
            local Settings = {
            Farms = {
            MobFarm = false,
            Selectedmob = "Frisker",
            Position = 6,
            TweenSpeed = 100,
            Autoequip = false,
            },
            Teleports = {
            Selectednpc = "",
            },
            Autoquest = {
            Toggle = false,
            Questboard = "MissionBoard 12",
            Position = 6,
            },
            Shikaifight = {
            Toggle = false,
            Position = 6,
            },
            Adjfarm = {
            Toggle = false,
            Position = -8.7,
            },
            Closest = {
            Toggle = false,
            Position = -8,
            Distance = 150,
            },
            Notifier = false,
            Minigame = false,
            Obby = false,
            }
 
            local attackremote = game:GetService("ReplicatedStorage").Remotes.ServerCombatHandler
            local mobTable = { "Fishbone", "Frisker", "LostSoul", "Jackal", "Shinigami", "Menos", "Bawabawa", "Jidanbo" }
            local RunService = game:GetService("RunService")
            local NextFrame = RunService.Heartbeat
            local Players = game:GetService("Players")
            local Player = Players.LocalPlayer
            local ForceStop = false
            local npcTable = {}
            local player = game.Players.LocalPlayer
            local questTable = { "nothing" }
            local name = player.Name
            local modtable = {
            15293648, --iqcs
            30370774, --Rakutsu
            83254134, --s9d
            80916772, -- Jaleox
            23977275, -- Tsumoe
            82280601, -- Lipopss
            83254134, -- s9d
            1506296146, -- okhwan
            606256561, -- Abaddonisu
            18577857, -- DripMonger
            4061168, -- Castalysts
            1159863871, -- enraiton
            432360403, -- sinfuldms
            10712932, -- Yreol
            20660983, -- H3mzz
            83338597, -- LeafyRei
            54066348, -- PioClean
            25329898, -- Joochun
            8925483, -- K1LLUAA
            1161914,
            3427072680, -- haniyura
            57431326, -- Khaotxc
            77857290, -- 4Data
            4192362393, -- mitakamora
            300780145, -- invictal
            232346707, -- Drakos
            59903508, --cartier361
            400349, -- streak
            194177872,
            36989055, -- Minst_r
            36710249, -- MassRelays
            30370774,
            }
 
 
            --Settings--
            --Declarations--
 
 
            --// Script Functions
            local function Tween(Target, angle)
            ForceStop = false
            if typeof(Target) == "Instance" and Target:IsA("BasePart") then
            Target = Target.Position
            end
            if typeof(Target) == "CFrame" then
            Target = Target.p
            end
 
            local HRP = (Player.Character and Player.Character:FindFirstChild("HumanoidRootPart"))
            if not HRP then
            return
            end
 
            local StartingPosition = HRP.Position
            local PositionDelta = (Target - StartingPosition)
            local StartTime = tick()
            local TotalDuration = (StartingPosition - Target).magnitude / Settings.Farms.TweenSpeed
 
            repeat
            NextFrame:Wait()
            local Delta = tick() - StartTime
            local Progress = math.min(Delta / TotalDuration, 1) 
 
            local MappedPosition = StartingPosition + (PositionDelta * Progress)
            HRP.Velocity = Vector3.new() 
            HRP.CFrame = CFrame.new(MappedPosition)
            until (HRP.Position - Target).magnitude <= Settings.Farms.TweenSpeed / 2 or ForceStop
            if ForceStop then
            ForceStop = false
            return
            end --
            HRP.Anchored = false
            HRP.CFrame = CFrame.new(Target) * CFrame.Angles(math.rad(angle), 0, 0)
            end
 
            for i, v in pairs(workspace.NPCs:GetDescendants()) do
            if v:IsA("Model") and not table.find(npcTable, v.Name) then
            table.insert(npcTable, v.Name)
            end
            end
 
            for i, v in pairs(workspace.NPCs.MissionNPC:GetChildren()) do
            if v:IsA("Model") and not table.find(questTable, v.Name) then
            table.insert(questTable, v.Name)
            end
            end
 
            local function tweentonpc()
            for i, v in pairs(workspace.NPCs:GetDescendants()) do
            if v:IsA("Model") and v.Name == Settings.Teleports.Selectednpc then
            Tween(v:GetPivot().Position, 0)
            end
            end
            end
 
            local function stoptween()
            ForceStop = true
            end
 
            local findmob = function()
            local MaxDistance = math.huge
            local find = nil
            for i, v in pairs(workspace.Entities:GetChildren()) do
            if
            string.find(v.Name, Settings.Farms.Selectedmob)
            and v:FindFirstChild("HumanoidRootPart")
            and v.Humanoid.Health > 0
            then
            local magnitude = (player.Character:GetPivot().Position - v:GetPivot().Position).Magnitude
            if magnitude < MaxDistance then
            MaxDistance = magnitude
            find = v
            end
            else
            print("No mob found")
            end
            end
            return find
            end
 
 
 
            local function MobFarm()
            if Settings.Farms.MobFarm then
            if Settings.Farms.Position >= 0 then
            local mob = findmob()
            Tween(mob:GetPivot().Position + Vector3.new(0, Settings.Farms.Position, 0), -90)
            if (mob:GetPivot().Position - player.Character:GetPivot().Position).magnitude <= 15 then
            Tween(mob:GetPivot().Position + Vector3.new(0, Settings.Farms.Position, 0), -90)
            attackremote:FireServer("LightAttack")
            end
            else
            local mob = findmob()
            Tween(mob:GetPivot().Position + Vector3.new(0, Settings.Farms.Position, 0), 90)
            if (mob:GetPivot().Position - player.Character:GetPivot().Position).magnitude <= 15 then
            Tween(mob:GetPivot().Position + Vector3.new(0, Settings.Farms.Position, 0), 90)
            attackremote:FireServer("LightAttack")
            end
            end
            end
            end
 
            local near = function()
            if not Settings.Autoquest.Toggle then
            return
            end
            if player.PlayerGui.QueueUI.Enabled == true then
            local distance = math.huge
            local z = nil
            for i, v in pairs(workspace.Entities:GetChildren()) do
            if string.find(v.Name, "Fishbone") or string.find(v.Name, "Frisker") then
            if v.Humanoid.Health > 0 and v:FindFirstChild("Highlight") then
            local magnitude = (player.Character:GetPivot().Position - v:GetPivot().Position).Magnitude
            if magnitude < distance then
            distance = magnitude
            z = v
            end
            end
            end
            end
            return z
            end
            end
 
            local questboard = function()
            if not Settings.Autoquest.Toggle then
            return
            end
            if player.PlayerGui.MissionsUI.Queueing.Visible == false and player.PlayerGui.QueueUI.Enabled == false then
            local distance = math.huge
            local quest
            for i, v in pairs(workspace.NPCs.MissionNPC:GetChildren()) do
            if string.find(v.Name, "MissionBoard") then
            local magnitude = (player.Character:GetPivot().Position - v:GetPivot().Position).Magnitude
            if magnitude < distance then
            distance = magnitude
            quest = v
            end
            end
            end
            return quest
            end
            end
 
            --player.PlayerGui.MissionsUI.Queueing.Visible == false
 
            local function autoquest()
            if not Settings.Autoquest.Toggle then
            return
            end
            player.Character.Humanoid:ChangeState("FreeFall")
            if player.PlayerGui.QueueUI.Enabled == true then
            local dummy = near()
            if Settings.Autoquest.Position >= 0 then
            Tween(dummy:GetPivot().Position + Vector3.new(0, Settings.Autoquest.Position, 0), -90)
            if (player.Character:GetPivot().Position - dummy:GetPivot().Position).Magnitude < 25 then
            Tween(dummy:GetPivot().Position + Vector3.new(0, Settings.Autoquest.Position, 0), -90)
            attackremote:FireServer("LightAttack")
            end
            else
            Tween(dummy:GetPivot().Position + Vector3.new(0, Settings.Autoquest.Position, 0), 90)
            if (player.Character:GetPivot().Position - dummy:GetPivot().Position).Magnitude < 25 then
            Tween(dummy:GetPivot().Position + Vector3.new(0, Settings.Autoquest.Position, 0), 90)
            attackremote:FireServer("LightAttack")
            end
            end
            elseif player.PlayerGui.QueueUI.Enabled == false then
            if player.PlayerGui.MissionsUI.Queueing.Visible == false then
            local quest = questboard()
            local magnitude = (player.Character:GetPivot().Position - quest:GetPivot().Position).Magnitude
            Tween(quest:GetPivot().Position + Vector3.new(0, -8, 0), 0)
            if magnitude < 15 then
            Tween(quest:GetPivot().Position + Vector3.new(0, -8, 0), 0)
            task.wait()
            fireclickdetector(quest.Board.Union.ClickDetector)
            task.wait()
            player[quest.Name]:FireServer("Yes")
            end
            end
            end
            end
 
            local function streamermode() -- hides your user on the party list
            player.PlayerGui.MissionsUI.MainFrame.ScrollingFrame[name].PlayerName.Text = "Asteria on top"
            end
 
            local function destroykillbricks()
            for i, v in pairs(workspace.DeathBricks:GetChildren()) do
            v:Destroy()
            end
            end
            local function instantreset()
            player.Character.Head:Destroy()
            end
 
            local function chatlogger()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/mac2115/Cool-private/main/ESP", true))()
            end
 
            local function Teleport()
            if game.PlaceId == 14071822972 then
            for i, v in
            pairs(game:GetService("ReplicatedStorage").Requests.RequestServerList:InvokeServer("Wandenreich City"))
            do
            if v.JobID ~= game.JobId then
            wait()
            player.Character.CharacterHandler.Remotes.ServerListTeleport:FireServer("Wandenreich City", v.JobID)
            break
            end
            end
            elseif game.PlaceId == 14070029709 then
            for i, v in pairs(game:GetService("ReplicatedStorage").Requests.RequestServerList:InvokeServer("Soul Society")) do
            if v.JobID ~= game.JobId then
            wait()
            player.Character.CharacterHandler.Remotes.ServerListTeleport:FireServer("Soul Society", v.JobID)
            break
            end
            end
            elseif game.PlaceId == 14069122388 then
            for i, v in pairs(game:GetService("ReplicatedStorage").Requests.RequestServerList:InvokeServer("Hueco Mundo")) do
            if v.JobID ~= game.JobId then
            wait()
            player.Character.CharacterHandler.Remotes.ServerListTeleport:FireServer("Hueco Mundo", v.JobID)
            break
            end
            end
            elseif game.PlaceId == 14069678431 then
            for i, v in pairs(game:GetService("ReplicatedStorage").Requests.RequestServerList:InvokeServer("Karakura Town")) do
            if v.JobID ~= game.JobId then
            wait()
            player.Character.CharacterHandler.Remotes.ServerListTeleport:FireServer("Karakura Town", v.JobID)
            break
            end
            end
            elseif game.PlaceId == 14069866342 then
            for i, v in pairs(game:GetService("ReplicatedStorage").Requests.RequestServerList:InvokeServer("Las Noches")) do
            if v.JobID ~= game.JobId then
            wait()
            player.Character.CharacterHandler.Remotes.ServerListTeleport:FireServer("Las Noches", v.JobID)
            break
            end
            end
            elseif game.PlaceId == 14069956183 then
            for i, v in
            pairs(game:GetService("ReplicatedStorage").Requests.RequestServerList:InvokeServer("Rukon District"))
            do
            if v.JobID ~= game.JobId then
            wait()
            player.Character.CharacterHandler.Remotes.ServerListTeleport:FireServer("Rukon District", v.JobID)
            break
            end
            end
            end
            end
 
 
            local function autoequip()
            spawn(function()
            if not Settings.Farms.Autoequip then
            return
            end
            if player.Character:FindFirstChild("Zanpakuto") then
            player.Character.CharacterHandler.Remotes.Weapon:FireServer("UnsheatheWeapon")
            else
            return
            end
            end)
            end
 
            local function farmclosest()
            if not Settings.Closest.Toggle then
            return
            end
            local distance = Settings.Closest.Distance
            for i, v in pairs(workspace.Entities:GetChildren()) do
            if v.Humanoid.Health > 0 and v ~= player.Character then
            local magnitude = (player.Character:GetPivot().Position - v:GetPivot().Position).magnitude
            if magnitude <= distance then
            player.Character.Humanoid:ChangeState("FreeFall")
            if Settings.Closest.Position >= 0 then
            Tween(v:GetPivot().Position + Vector3.new(0, Settings.Closest.Position, 0), -90)
            attackremote:FireServer("LightAttack")
            else
            Tween(v:GetPivot().Position + Vector3.new(0, Settings.Closest.Position, 0), 90)
            attackremote:FireServer("LightAttack")
            end
            end
            end
            end
            end
 
 
            local adju = function()
            if not Settings.Adjfarm.Toggle then
            return
            end
            local distance = math.huge
            local q
            for i, v in pairs(workspace.Entities:GetChildren()) do
            if string.find(v.Name, "Jackal") and v:FindFirstChild("HumanoidRootPart") then
            local magnitude = (player.Character:GetPivot().Position - v:GetPivot().Position).Magnitude
            if magnitude < distance then
            distance = magnitude
            q = v
            end
            end
            end
            return q
            end
 
 
            local function adjufarm()
            if not Settings.Adjfarm.Toggle then
            return
            end
            local v = adju()
            if v == nil then
            Teleport()
            else
            player.Character.Humanoid:ChangeState("FreeFall")
            if v.Humanoid.Health > 0 then
            if Settings.Adjfarm.Position >= 0 then
            Tween(v:GetPivot().Position + Vector3.new(0, Settings.Adjfarm.Position, 0), -90)
            if (player.Character:GetPivot().Position - v:GetPivot().Position).Magnitude < 25 then
            Tween(v:GetPivot().Position + Vector3.new(0, Settings.Adjfarm.Position, 0), -90)
            attackremote:FireServer("LightAttack")
            end
            else
            Tween(v:GetPivot().Position + Vector3.new(0, Settings.Autoquest.Position, 0), 90)
            if (player.Character:GetPivot().Position - v:GetPivot().Position).Magnitude < 25 then
            Tween(v:GetPivot().Position + Vector3.new(0, Settings.Adjfarm.Position, 0), 90)
            attackremote:FireServer("LightAttack")
            end
            end
            elseif v.Humanoid.Health == 0 then
            Teleport()
            end
            end
            end
 
            local function shikaichecker() end
 
            local function obby()
            if not Settings.Obby then
            return
            end
            for i, v in pairs(workspace.PartialRes.PartialResObby:GetChildren()) do
            if v.Name == "PartialObject" then
            local magnitude = (player.Character:GetPivot().Position - v:GetPivot().Position).magnitude
            Tween(v:GetPivot().Position, 0)
            if magnitude <= 15 then
            Tween(v:GetPivot().Position, 0)
            fireclickdetector(v.ClickDetector)
            end
            end
            end
            end
 
            local function minigame()
            if not Settings.Minigame then
            return
            end
            if player.PlayerGui:FindFirstChild("Division11Minigame") then
            for i, v in pairs(player.PlayerGui.Division11Minigame.Frame:GetChildren()) do
            if string.find(v.Name, "HollowImage") and v:FindFirstChild("UISizeConstraint") then
            v.UISizeConstraint.MaxSize = Vector2.new(1000, 1000)
            v.UISizeConstraint.MinSize = Vector2.new(1000, 1000)
            end
            end
            else
            fireclickdetector(workspace.NPCs.DivisionDuties["Division Duties 12"].Board.Click.ClickDetector)
            player:FindFirstChild("Division Duties 12"):FireServer("Yes")
            end
            end
 
 
 
 
 
 
 
 
 
            --//UI
            loadstring(game:HttpGet("https://raw.githubusercontent.com/deeeity/mercury-lib/master/src.lua"))()
            local Mercury = loadstring(game:HttpGet("https://raw.githubusercontent.com/deeeity/mercury-lib/master/src.lua"))()
            local GUI = Mercury:Create({
            Name = "Asteria",
            Size = UDim2.fromOffset(600, 400),
            Theme = Mercury.Themes.Dark,
            Link = "Asteria/TypeSoul",
            })
            local Tab = GUI:Tab({
            Name = "Main",
            Icon = "rbxassetid://8569322835",
            })
 
            Tab:Toggle({
            Name = "MobFarm",
            StartingState = false,
            Description = nil,
            Callback = function(state)
            Settings.Farms.MobFarm = state
            end,
            })
 
            local MyDropdown = Tab:Dropdown({
            Name = "Mob selector",
            StartingText = "Select...",
            Description = nil,
            Items = mobTable,
            Callback = function(item)
            Settings.Farms.Selectedmob = item
            end,
            })
 
            Tab:Slider({
            Name = "Farm position",
            Default = 6,
            Min = -25,
            Max = 25,
            Callback = function(val)
            Settings.Farms.Position = val
            end,
            })
 
            Tab:Slider({
            Name = "TweenSpeed",
            Default = 80,
            Min = 0,
            Max = 250,
            Callback = function(val)
            Settings.Farms.TweenSpeed = val
            end,
            })
 
            Tab:Toggle({
            Name = "Autoequip",
            StartingState = false,
            Description = nil,
            Callback = function(state)
            Settings.Farms.Autoequip = state
            end,
            })
 
            Tab:Toggle({
            Name = "Autoquest",
            StartingState = false,
            Description = nil,
            Callback = function(state)
            Settings.Autoquest.Toggle = state
            end,
            })
 
            Tab:Slider({
            Name = "Farm position",
            Default = 6,
            Min = -25,
            Max = 25,
            Callback = function(val)
            Settings.Autoquest.Position = val
            end,
            })
 
            Tab:Toggle({
            Name = "Adju farm",
            StartingState = false,
            Description = nil,
            Callback = function(state)
            Settings.Adjfarm.Toggle = state
            end,
            })
 
            Tab:Slider({
            Name = "Farm position",
            Default = 6,
            Min = -25,
            Max = 25,
            Callback = function(val)
            Settings.Adjfarm.Position = val
            end,
            })
 
            Tab:Toggle({
            Name = "Farm closest",
            StartingState = false,
            Description = nil,
            Callback = function(state)
            Settings.Closest.Toggle = state
            end,
            })
 
            Tab:Slider({
            Name = "Farm position",
            Default = 6,
            Min = -25,
            Max = 25,
            Callback = function(val)
            Settings.Closest.Position = val
            end,
            })
 
            Tab:Slider({
            Name = "Range",
            Default = 50,
            Min = 0,
            Max = 250,
            Callback = function(val)
            Settings.Closest.range = val
            end,
            })
 
            local Tab = GUI:Tab({
            Name = "Misc",
            Icon = "rbxassetid://8569322835",
            })
 
            Tab:Toggle({
            Name = "Minigame simplifier",
            StartingState = false,
            Description = nil,
            Callback = function(state)
            Settings.Minigame = state
            end,
            })
 
            Tab:Toggle({
            Name = "Complete res obby",
            StartingState = false,
            Description = nil,
            Callback = function(state)
            Settings.Obby = state
            end,
            })
 
            Tab:Button({
            Name = "Serverhop",
            Description = nil,
            Callback = function()
            Teleport()
            end,
            })
 
            Tab:Button({
            Name = "Chatlogger",
            Description = nil,
            Callback = function()
            chatlogger()
            end,
            })
 
            Tab:Button({
            Name = "Streamer mode",
            Description = nil,
            Callback = function()
            streamermode()
            end,
            })
 
            Tab:Button({
            Name = "Instant reset",
            Description = nil,
            Callback = function()
            instantreset()
            end,
            })
 
            Tab:Button({
            Name = "Destroy killbricks",
            Description = nil,
            Callback = function()
            destroykillbricks()
            end,
            })
 
            local MyDropdown = Tab:Dropdown({
            Name = "Tween to npc",
            StartingText = "Select...",
            Description = nil,
            Items = mobTable,
            Callback = function(item)
            Settings.Teleports.Selectednpc = item
            tweentonpc()
            end,
            })
 
            Tab:Button({
            Name = "Stop tween",
            Description = nil,
            Callback = function()
            stoptween()
            end,
            })
 
            local Tab = GUI:Tab({
            Name = "Visuals",
            Icon = "rbxassetid://8569322835",
            })
 
            Tab:Toggle({
            Name = "Esp toggle",
            StartingState = false,
            Description = nil,
            Callback = function(state)
            ESP.Enabled = state
            end,
            })
 
            Tab:Toggle({
            Name = "Teammates",
            StartingState = false,
            Description = nil,
            Callback = function(state)
            ESP.TeamMates = state
            end,
            })
 
            Tab:Toggle({
            Name = "Names",
            StartingState = false,
            Description = nil,
            Callback = function(state)
            ESP.Names = state
            end,
            })
            Tab:Toggle({
            Name = "Boxes",
            StartingState = false,
            Description = nil,
            Callback = function(state)
            ESP.Boxes = state
            end,
            })
 
            Tab:ColorPicker({
            Style = Mercury.ColorPickerStyles.Legacy,
            Callback = function(color)
            ESP.Color = color
            end,
            })
 
            --//configs
 
            --//Loops
 
            local function notifier()
            if not Settings.Notifier then
            return
            end
 
            for i, v in pairs(game.Players:GetChildren()) do
            if table.find(modtable, v.UserId) then
            player:Kick("An Admin has joined your server")
            end
            end
            end
 
            game:GetService("RunService").Heartbeat:connect(function()
            autoquest()
            MobFarm()
            adjufarm()
            autoequip()
            farmclosest()
            notifier()
            obby()
            minigame()
            end)
        end
    })
 
    Tabs.TycoonRNG:AddButton({
        Title = "Autofarm",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/jjp2iky/scripts/main/TycoonRNG"))()
        end
    })
 
    Tabs.Ultrathegame:AddButton({
        Title = "Omni Hub",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet(("https://pastefy.app/fj0lEGpS/raw")))()
        end
    })
 
    Tabs.Undergroundwar2:AddButton({
        Title = "Killaura",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/sunsworn1020903/sunsworn1020903/main/KillAura"))()
        end
    })
 
    Tabs.Untitledtaggame:AddButton({
        Title = "Ranxware Hub",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Zer0ids/Qwerty/main/UntitledTag/NewScript.lua"))()
        end
    })
 
    Tabs.Vehiclelegends:AddButton({
        Title = "Autofarm",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Marco8642/science/main/Vehicle%20legends"))()
        end
    })
 
    Tabs.Wackywizard:AddButton({
        Title = "Candy Hub",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet("https://scriptblox.com/raw/Wacky-Wizards-GHOST-Candy-Farm-6499"))()
        end
    })
 
    Tabs.Wartycoon:AddButton({
        Title = "Awaken Hub",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Awakenchan/Misc-Release/main/WarTycoon"))()
        end
    })
 
    Tabs.Warriorssim:AddButton({
        Title = "Dkzin Hub",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Christian2703/Main/main/Mainscript", true))()
        end
    })
 
    Tabs.Westbound:AddButton({
        Title = "Stupid Hub",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet("https://scriptblox.com/raw/Westbound-Speed-and-Aimbot-and-ESP-and-Teleports-and-More-6503"))()
        end
    })
 
    Tabs.Wordle:AddButton({
        Title = "Autofarm",
        Description = "Just a simple autofarm",
        Callback = function()
            while wait(0.1) do
            local args = {
                [1] = true,
                [2] = "Classic"
            }
 
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("GameFinalOutcome"):FireServer(unpack(args))
            end
        end
    })
 
    Tabs.YBA:AddButton({
        Title = "W.O.W Hub",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/caydenthekile/scriptsv2/main/yba"))()
        end
    })
 
    Tabs.YBA:AddButton({
        Title = "YBA Gui",
        Description = "Best one",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Vuffi2007/YBA-Teleport-to-Items-GUI/main/YBA-Teleport-to-Items-GUI.lua"))()
        end
    })
 
    Tabs.Zombieattack:AddButton({
        Title = "Autofarm",
        Description = "Телеграм @SFXCL",
        Callback = function()
            loadstring(game:HttpGet(('https://raw.githubusercontent.com/RTrade/Voidz/main/Games.lua'),true))()
        end
    })
 
    Input:OnChanged(function()
        print("Input updated:", Input.Value)
    end)
end
 
 
-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- InterfaceManager (Allows you to have a interface managment system)
 
-- Hand the library over to our managers
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
 
-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()
 
-- You can add indexes of elements the save manager should ignore
SaveManager:SetIgnoreIndexes({})
 
-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")
 
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)
 
Window:SelectTab(1)
 
Fluent:Notify({
    Title = "Fluent",
    Content = "Exploit Central has loaded.",
    Duration = 8
})
 
-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()
 
 
 