getgenv().ESPToggled = false;
getgenv().autoFarmCoins = false;

ALLYCOLOR = {0, 255, 255}
SHERIFF_COLOR = {53, 179, 18}
ENEMYCOLOR =  {255, 0, 0}
TRANSPARENCY = 0.5
HEALTHBAR_ACTIVATED = true

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Robojini/Tuturial_UI_Library/main/UI_Template_1"))()

local window = library.CreateLib("By @SFXCL, Murder Mystery 2. PlaceID: "..game.PlaceId, "RJTheme3") -- Creates the window

local MainTab = window:NewTab("Main Tab")
local main_menu = MainTab:NewSection("Main")
local main_teleport_menu = MainTab:NewSection("Teleport")
local main_scripts = MainTab:NewSection("Scripts")

local GameTab = window:NewTab("Game Tab")
local game_menu = GameTab:NewSection("Main")

local TeleportTab = window:NewTab("Teleport Tab")
local teleport_menu = TeleportTab:NewSection("Game Section")
local teleport_players_menu = TeleportTab:NewSection("Players Section")

game_menu:NewButton("Kill All", "Kills All If You are a murderer", function ()
	if game.Players.LocalPlayer.Backpack:FindFirstChild("Knife") ~= nil or game.Workspace[game.Players.LocalPlayer.Name]:FindFirstChild("Knife") ~= nil then
		local players = game:GetService("Players")
		for _, player in pairs(players:GetPlayers()) do
			if player.Name ~= game.Players.LocalPlayer.Name then
				repeat wait()
					game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1)
				until
					player.Character.Humanoid.Health == 0
			end
		end
	else
		print("[ERROR] You are not murderer!!!")
	end
end)

game_menu:NewToggle("Coins Farm", "Auto Coins Farm", function (bool)
	getgenv().autoFarmCoins = bool
end)

teleport_menu:NewButton("TP To Lobby", "TP To Lobby", function ()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-108.5, 145, 0.6)
end)

teleport_menu:NewButton("TP To Map", "TP To Map", function ()
	for _, part in pairs(game.Workspace:GetDescendants()) do
		if part.Name == "Spawns" then
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = part.Spawn.CFrame
			break
		end
	end
end)

teleport_players_menu:NewButton("TP Sheriff", "TP To Sheriff", function ()
	for _, player in pairs(game:GetService("Players"):GetPlayers()) do
		if player.Backpack:FindFirstChild("Gun") ~= nil or game.Workspace[player.Name]:FindFirstChild("Knife") ~= nil then
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame
			break
		end
	end
end)
teleport_players_menu:NewButton("TP Murderer", "TP To Murderer", function ()
	for _, player in pairs(game:GetService("Players"):GetPlayers()) do
		if player.Backpack:FindFirstChild("Knife") ~= nil or game.Workspace[player.Name]:FindFirstChild("Knife") ~= nil then
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame
			break
		end
	end
end)

task.spawn(function ()
	while true do
		wait(.25)
		if getgenv().autoFarmCoins then
			for _, part in pairs(game.Workspace:GetDescendants()) do
				if getgenv().autoFarmCoins == false then
					break
				end

				if part.Name == "CoinContainer" then
					if part.Coin_Server:FindFirstChild("Coin") ~= nil then
						game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = part.Coin_Server.Coin.CFrame
					end
				end
			end
		end
	end
end)

main_menu:NewButton("ESP", "You will see all players", function()
	createFlex()
    getgenv().ESPToggled = true;
end)

main_menu:NewSlider("Player speed", "Change player`s speed", 500, 0, function (s)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
end)
main_menu:NewSlider("Player Jump Power", "Change player`s Jump Power", 500, 0, function (s)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = s
end)

speeds = 1

local speaker = game:GetService("Players").LocalPlayer

local chr = game.Players.LocalPlayer.Character
local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")

nowe = false

main_menu:NewButton("Toggle Fly", "Toggle Flying", function()
	if nowe == true then
		nowe = false

		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming,true)
		speaker.Character.Humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
	else 
		nowe = true

		for i = 1, speeds do
			spawn(function()

				local hb = game:GetService("RunService").Heartbeat	


				tpwalking = true
				local chr = game.Players.LocalPlayer.Character
				local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
				while tpwalking and hb:Wait() and chr and hum and hum.Parent do
					if hum.MoveDirection.Magnitude > 0 then
						chr:TranslateBy(hum.MoveDirection)
					end
				end

			end)
		end
		game.Players.LocalPlayer.Character.Animate.Disabled = true
		local Char = game.Players.LocalPlayer.Character
		local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")

		for i,v in next, Hum:GetPlayingAnimationTracks() do
			v:AdjustSpeed(0)
		end
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming,false)
		speaker.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
	end

	if game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R6 then
		local plr = game.Players.LocalPlayer
		local torso = plr.Character.Torso
		local flying = true
		local deb = true
		local ctrl = {f = 0, b = 0, l = 0, r = 0}
		local lastctrl = {f = 0, b = 0, l = 0, r = 0}
		local maxspeed = 50
		local speed = 0
		local bg = Instance.new("BodyGyro", torso)
		bg.P = 9e4
		bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
		bg.cframe = torso.CFrame
		local bv = Instance.new("BodyVelocity", torso)
		bv.velocity = Vector3.new(0,0.1,0)
		bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
		if nowe == true then
			plr.Character.Humanoid.PlatformStand = true
		end
		while nowe == true or game:GetService("Players").LocalPlayer.Character.Humanoid.Health == 0 do
			game:GetService("RunService").RenderStepped:Wait()

			if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
				speed = speed+.5+(speed/maxspeed)
				if speed > maxspeed then
					speed = maxspeed
				end
			elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
				speed = speed-1
				if speed < 0 then
					speed = 0
				end
			end
			if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
				bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
				lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
			elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
				bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
			else
				bv.velocity = Vector3.new(0,0,0)
			end
			--	game.Players.LocalPlayer.Character.Animate.Disabled = true
			bg.cframe = game.Workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/maxspeed),0,0)
		end
		ctrl = {f = 0, b = 0, l = 0, r = 0}
		lastctrl = {f = 0, b = 0, l = 0, r = 0}
		speed = 0
		bg:Destroy()
		bv:Destroy()
		plr.Character.Humanoid.PlatformStand = false
		game.Players.LocalPlayer.Character.Animate.Disabled = false
		tpwalking = false
	else
		local plr = game.Players.LocalPlayer
		local UpperTorso = plr.Character.UpperTorso
		local flying = true
		local deb = true
		local ctrl = {f = 0, b = 0, l = 0, r = 0}
		local lastctrl = {f = 0, b = 0, l = 0, r = 0}
		local maxspeed = 50
		local speed = 0


		local bg = Instance.new("BodyGyro", UpperTorso)
		bg.P = 9e4
		bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
		bg.cframe = UpperTorso.CFrame
		local bv = Instance.new("BodyVelocity", UpperTorso)
		bv.velocity = Vector3.new(0,0.1,0)
		bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
		if nowe == true then
			plr.Character.Humanoid.PlatformStand = true
		end
		while nowe == true or game:GetService("Players").LocalPlayer.Character.Humanoid.Health == 0 do
			wait()

			if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
				speed = speed+.5+(speed/maxspeed)
				if speed > maxspeed then
					speed = maxspeed
				end
			elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
				speed = speed-1
				if speed < 0 then
					speed = 0
				end
			end
			if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
				bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
				lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
			elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
				bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
			else
				bv.velocity = Vector3.new(0,0,0)
			end

			bg.cframe = game.Workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/maxspeed),0,0)
		end
		ctrl = {f = 0, b = 0, l = 0, r = 0}
		lastctrl = {f = 0, b = 0, l = 0, r = 0}
		speed = 0
		bg:Destroy()
		bv:Destroy()
		plr.Character.Humanoid.PlatformStand = false
		game.Players.LocalPlayer.Character.Animate.Disabled = false
		tpwalking = false
	end
end)

main_menu:NewSlider("Flying speed", "Change player`s flying speed", 100, 1, function (s)
    speeds = s
	if nowe == true then
		tpwalking = false
		for i = 1, speeds do
			spawn(function()
				local hb = game:GetService("RunService").Heartbeat

				tpwalking = true
				local chr = game.Players.LocalPlayer.Character
				local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
				while tpwalking and hb:Wait() and chr and hum and hum.Parent do
					if hum.MoveDirection.Magnitude > 0 then
						chr:TranslateBy(hum.MoveDirection)
					end
				end
			end)
		end
	end
end)

main_teleport_menu:NewButton("Teleport 10 studs forward", "Teleports player 10 studs forward", function()
    game.Players.LocalPlayer.Character.PrimaryPart.CFrame = game.Players.LocalPlayer.Character.PrimaryPart.CFrame * CFrame.new(0, 0, -10)
end)

main_teleport_menu:NewButton("Teleport 10 studs up", "Teleports player 10 studs up", function()
    game.Players.LocalPlayer.Character.PrimaryPart.CFrame = game.Players.LocalPlayer.Character.PrimaryPart.CFrame * CFrame.new(0, 10, 0)
end)

main_teleport_menu:NewButton("Teleport 10 studs down", "Teleports player 10 studs down", function()
    game.Players.LocalPlayer.Character.PrimaryPart.CFrame = game.Players.LocalPlayer.Character.PrimaryPart.CFrame * CFrame.new(0, -10, 0)
end)

main_teleport_menu:NewButton("Teleport 20 studs forward", "Teleports player 20 studs forward", function()
    game.Players.LocalPlayer.Character.PrimaryPart.CFrame = game.Players.LocalPlayer.Character.PrimaryPart.CFrame * CFrame.new(0, 0, -20)
end)

main_teleport_menu:NewButton("Teleport 20 studs up", "Teleports player 20 studs up", function()
    game.Players.LocalPlayer.Character.PrimaryPart.CFrame = game.Players.LocalPlayer.Character.PrimaryPart.CFrame * CFrame.new(0, 20, 0)
end)

main_teleport_menu:NewButton("Teleport 20 studs down", "Teleports player 20 studs down", function()
    game.Players.LocalPlayer.Character.PrimaryPart.CFrame = game.Players.LocalPlayer.Character.PrimaryPart.CFrame * CFrame.new(0, -20, 0)
end)

main_teleport_menu:NewButton("Teleport 10 studs up and forward", "Teleports player 10 studs up and forward", function()
    game.Players.LocalPlayer.Character.PrimaryPart.CFrame = game.Players.LocalPlayer.Character.PrimaryPart.CFrame * CFrame.new(0, 10, -10)
end)

main_teleport_menu:NewButton("Teleport 20 studs up and forward", "Teleports player 20 studs up and forward", function()
    game.Players.LocalPlayer.Character.PrimaryPart.CFrame = game.Players.LocalPlayer.Character.PrimaryPart.CFrame * CFrame.new(0, 20, -20)
end)

main_scripts:NewButton("Coordinates Grabber", "Execute Coordinates Grabber Gui", function()
    spawn(function ()
        loadstring(game:HttpGet("https://pastebin.com/raw/M4TtucPi", true))()
    end)
end)

main_scripts:NewButton("Dark Dex Stable", "Execute Dark Dex Stable", function()
    spawn(function ()    
        loadstring(game:HttpGet("https://raw.githubusercontent.com/loglizzy/dex-custom-icons/main/main.lua"))()
    end)
end)

main_scripts:NewButton("Simple Spy", "Execute Simply Spy", function()
    spawn(function ()
        loadstring(game:HttpGet("https://pastebin.com/raw/rqgZVWGw"))()
    end)
end)

main_scripts:NewButton("BTools", "Execute BTools", function()
    spawn(function ()
        loadstring(game:HttpGet("https://pastebin.com/raw/JpEmyNa0"))()
    end)
end)

task.spawn(function ()
	while true do
		wait()
		players = game:GetService("Players")
		if getgenv().ESPToggled then
			for _, people in pairs(players:GetChildren()) do
				wait()
				if people.Name ~= players.LocalPlayer.Name then
                    if game.Workspace:FindFirstChild(people.Name) ~= nil then
						for _, people_part in pairs(game.Workspace[people.Name]:GetChildren()) do
							wait()
							if (people_part:IsA("Part") or people_part:IsA("MeshPart")) and people_part.Name~="HumanoidRootPart" then
								surface_gui = people_part:FindFirstChild("ESPSurface")
								if surface_gui ~= nil then
									for _, surface_gui in pairs(people_part:GetChildren()) do
										wait()
										if surface_gui.Name == "ESPSurface" then
											frame = surface_gui:FindFirstChild("Frame")
											if frame ~= nil then
												for _, part in pairs(people:GetChildren()) do
													wait()
													if part.Name == "Backpack" then
														if part:FindFirstChild("Gun") ~= nil or game.Workspace[people.Name]:FindFirstChild("Gun") ~= nil then
															frame.BackgroundColor3 = Color3.new(SHERIFF_COLOR[1], SHERIFF_COLOR[2], SHERIFF_COLOR[3])
															print("sheriff found")
														elseif part:FindFirstChild("Knife") ~= nil or game.Workspace[people.Name]:FindFirstChild("Knife") ~= nil then
															frame.BackgroundColor3 = Color3.new(ENEMYCOLOR[1], ENEMYCOLOR[2], ENEMYCOLOR[3])
															print("murderer found")
														else
															if frame.BackgroundColor3 ~= Color3.new(ALLYCOLOR[1], ALLYCOLOR[2], ALLYCOLOR[3]) then
																frame.BackgroundColor3 = Color3.new(ALLYCOLOR[1], ALLYCOLOR[2], ALLYCOLOR[3])
															end
														end
													end
												end
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
end)

function createFlex()
    players = game:GetService("Players")
    faces = {"Front","Back","Bottom","Left","Right","Top"}
    currentPlayer = nil
    lplayer = players.LocalPlayer

    players.PlayerAdded:Connect(function(p)
        currentPlayer = p
        p.CharacterAdded:Connect(function(character)
            createESP(character)
        end)
    end)

    function checkPart(obj)
		if (obj:IsA("Part") or obj:IsA("MeshPart")) and obj.Name~="HumanoidRootPart" then
			return true
		end
	end

    function actualESP(obj)
        for i=0,5 do
            surface = Instance.new("SurfaceGui", obj)
			surface.Name = "ESPSurface"
            surface.Face = Enum.NormalId[faces[i+1]]
            surface.AlwaysOnTop = true
            frame = Instance.new("Frame", surface)
            frame.Size = UDim2.new(1,0,1,0)
            frame.BorderSizePixel = 0
            frame.BackgroundTransparency = TRANSPARENCY
			for _, part in pairs(currentPlayer:GetChildren()) do
				if part.Name == "Backpack" then
					if part:FindFirstChild("Gun") ~= nil then
						frame.BackgroundColor3 = Color3.new(SHERIFF_COLOR[1], SHERIFF_COLOR[2], SHERIFF_COLOR[3])
					elseif part:FindFirstChild("Knife") ~= nil then
						frame.BackgroundColor3 = Color3.new(ENEMYCOLOR[1], ENEMYCOLOR[2], ENEMYCOLOR[3])
					else
						if frame.BackgroundColor3 ~= Color3.new(ALLYCOLOR[1], ALLYCOLOR[2], ALLYCOLOR[3]) then
							frame.BackgroundColor3 = Color3.new(ALLYCOLOR[1], ALLYCOLOR[2], ALLYCOLOR[3])
						end
					end
				end
			end
        end
    end

    function createHealthbar(hrp) 
        board =Instance.new("BillboardGui",hrp)
        board.Name = "total"
        board.Size = UDim2.new(1,0,1,0)
        board.StudsOffset = Vector3.new(3,1,0)
        board.AlwaysOnTop = true

        bar = Instance.new("Frame",board)
        bar.BackgroundColor3 = Color3.new(255,0,0)
        bar.BorderSizePixel = 0
        bar.Size = UDim2.new(0.2,0,4,0)
        bar.Name = "total2"

        health = Instance.new("Frame",bar)
        health.BackgroundColor3 = Color3.new(0,255,0)
        health.BorderSizePixel = 0
        health.Size = UDim2.new(1,0,hrp.Parent.Humanoid.Health/100,0)
        hrp.Parent.Humanoid.Changed:Connect(function(property)
            hrp.total.total2.Frame.Size = UDim2.new(1,0,hrp.Parent.Humanoid.Health/100,0)
        end)
    end

    function createESP(c)
        bugfix = c:WaitForChild("Head")
        for _, v in pairs(c:GetChildren()) do
            if checkPart(v) then
                actualESP(v)
            end
        end
        if HEALTHBAR_ACTIVATED then
			root_part = c:WaitForChild("HumanoidRootPart")
			if root_part ~= nil then
            	createHealthbar(root_part)
			end
        end
    end

    for _, people in pairs(players:GetChildren()) do
        if people ~= players.LocalPlayer then
            currentPlayer = people
            createESP(people.Character)
            people.CharacterAdded:Connect(function(character)
                createESP(character)
            end)
        end
    end
end