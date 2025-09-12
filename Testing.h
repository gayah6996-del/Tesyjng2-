local Close = Instance.new("TextButton")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer;
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- === НАСТРОЙКИ ИНФО-ОКНА ===
local TELEGRAM_HANDLE = "https://t.me/cheaterfun"
local INFO_TITLE = "Subscribe to my Telegram!"
local INFO_BODY  = "The latest Roblox Scripts and more!"

-- === УТИЛИТЫ ===
local function createButton(parent, text, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.9, 0, 0, 32)
	btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.SourceSansBold;
	btn.TextSize = 15;
	btn.Text = text;
	btn.Parent = parent;
	btn.MouseButton1Click:Connect(callback)
	return btn
end

local function showInfoPopup()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "InfoPopup"
	screenGui.ResetOnSpawn = false
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.Parent = game.CoreGui

	local overlay = Instance.new("TextButton")
	overlay.Name = "Overlay"
	overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	overlay.BackgroundTransparency = 0.35
	overlay.BorderSizePixel = 0
	overlay.Size = UDim2.fromScale(1, 1)
	overlay.AutoButtonColor = false
	overlay.Text = ""
	overlay.ZIndex = 1000
	overlay.Parent = screenGui

	local frame = Instance.new("Frame")
	frame.Name = "Window"
	frame.Size = UDim2.new(0, 380, 0, 210)
	frame.Position = UDim2.new(0.5, -190, 0.5, -105)
	frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	frame.BorderSizePixel = 0
	frame.ZIndex = 1001
	frame.Parent = overlay

	local corner = Instance.new("UICorner", frame)
	corner.CornerRadius = UDim.new(0, 12)

	local stroke = Instance.new("UIStroke", frame)
	stroke.Thickness = 1
	stroke.Color = Color3.fromRGB(70, 70, 70)

	local titleBar = Instance.new("Frame")
	titleBar.Name = "TitleBar"
	titleBar.Size = UDim2.new(1, 0, 0, 38)
	titleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	titleBar.BorderSizePixel = 0
	titleBar.ZIndex = 1002
	titleBar.Parent = frame
	Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 12)

	local titleLabel = Instance.new("TextLabel")
	titleLabel.BackgroundTransparency = 1
	titleLabel.Size = UDim2.fromScale(1, 1)
	titleLabel.Font = Enum.Font.SourceSansBold
	titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleLabel.TextSize = 18
	titleLabel.Text = INFO_TITLE
	titleLabel.ZIndex = 1003
	titleLabel.Parent = titleBar

	local closeBtn = Instance.new("TextButton")
	closeBtn.AnchorPoint = Vector2.new(1, 0.5)
	closeBtn.Position = UDim2.new(1, -8, 0.5, 0)
	closeBtn.Size = UDim2.new(0, 28, 0, 24)
	closeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	closeBtn.TextColor3 = Color3.new(1, 1, 1)
	closeBtn.Text = "×"
	closeBtn.Font = Enum.Font.SourceSansBold
	closeBtn.TextSize = 20
	closeBtn.AutoButtonColor = true
	closeBtn.ZIndex = 1003
	closeBtn.Parent = titleBar
	Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)

	local body = Instance.new("TextLabel")
	body.BackgroundTransparency = 1
	body.Position = UDim2.new(0, 16, 0, 52)
	body.Size = UDim2.new(1, -32, 0, 48)
	body.TextWrapped = true
	body.Font = Enum.Font.SourceSans
	body.TextSize = 17
	body.TextColor3 = Color3.fromRGB(230, 230, 230)
	body.TextXAlignment = Enum.TextXAlignment.Left
	body.TextYAlignment = Enum.TextYAlignment.Top
	body.Text = INFO_BODY
	body.ZIndex = 1002
	body.Parent = frame

	local linkLabel = Instance.new("TextLabel")
	linkLabel.BackgroundTransparency = 1
	linkLabel.Position = UDim2.new(0, 16, 0, 104)
	linkLabel.Size = UDim2.new(1, -32, 0, 22)
	linkLabel.Font = Enum.Font.SourceSansBold
	linkLabel.TextSize = 18
	linkLabel.TextColor3 = Color3.fromRGB(100, 185, 255)
	linkLabel.TextXAlignment = Enum.TextXAlignment.Left
	linkLabel.Text = TELEGRAM_HANDLE
	linkLabel.ZIndex = 1002
	linkLabel.Parent = frame

	local function makeBtn(text, pos)
		local b = Instance.new("TextButton")
		b.Size = UDim2.new(0, 160, 0, 32)
		b.Position = pos
		b.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		b.TextColor3 = Color3.fromRGB(255, 255, 255)
		b.Text = text
		b.Font = Enum.Font.SourceSansBold
		b.TextSize = 15
		b.AutoButtonColor = true
		b.ZIndex = 1002
		b.Parent = frame
		Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
		return b
	end

	local copyBtn = makeBtn("Скопировать ссылку", UDim2.new(0, 16, 0, 140))
	local okBtn   = makeBtn("Хорошо", UDim2.new(1, -16-160, 0, 178))

	do
		local dragging = false
		local dragStart, startPos
		local function update(input)
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
		titleBar.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				dragStart = input.Position
				startPos = frame.Position
				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then dragging = false end
				end)
			end
		end)
		titleBar.InputChanged:Connect(function(input)
			if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				update(input)
			end
		end)
		UserInputService.InputChanged:Connect(function(input)
			if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				update(input)
			end
		end)
	end

	local function toast(msg)
		pcall(function()
			game.StarterGui:SetCore("SendNotification", {
				Title = "Информация";
				Text = msg;
				Duration = 5;
			})
		end)
	end

	copyBtn.MouseButton1Click:Connect(function()
		local ok, _ = pcall(function()
			if typeof(setclipboard) == "function" then
				setclipboard(TELEGRAM_HANDLE)
				toast("The link has been copied to the clipboard!")
			else
				error("no_setclipboard")
			end
		end)
		if not ok then
			toast("Copy manually: " .. TELEGRAM_HANDLE)
		end
	end)

	local function close()
		if screenGui and screenGui.Parent then
			screenGui:Destroy()
		end
	end

	okBtn.MouseButton1Click:Connect(close)
	closeBtn.MouseButton1Click:Connect(close)

	overlay.MouseButton1Click:Connect(function()
		-- Закрывать только при клике вне окна
		local m = UserInputService:GetMouseLocation()
		local p = frame.AbsolutePosition
		local s = frame.AbsoluteSize
		local inside = (m.X >= p.X and m.X <= p.X + s.X and m.Y >= p.Y and m.Y <= p.Y + s.Y)
		if not inside then close() end
	end)
end

-- === ОСНОВНОЙ GUI ===
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = ""
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 280, 0, 260)
frame.Position = UDim2.new(0.5, -140, 0.5, -130)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0;
frame.Active = true;

local dragging, dragInput, dragStart, startPos;
frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true;
		dragStart = input.Position;
		startPos = frame.Position;
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)
frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if dragging and input == dragInput then
		local delta = input.Position - dragStart;
		frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
title.Text = "@SFXCL"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold;
title.TextSize = 18;

local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1, 0, 1, -30)
scroll.Position = UDim2.new(0, 0, 0, 30)
scroll.ScrollBarThickness = 4;
scroll.BackgroundTransparency = 1;

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 6)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
end)

local stealPos, lockBasePos, tpPart, infJump, infJumpDebounce;
createButton(scroll, "Save Position for Steal", function()
	stealPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position
end)
createButton(scroll, "Instant TP to Steal Position", function()
	if stealPos then
		LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(stealPos)
	end
end)
createButton(scroll, "Save Position for Lock Base", function()
	lockBasePos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position
end)
createButton(scroll, "Instant TP to Lock Base", function()
	if lockBasePos then
		LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(lockBasePos)
	end
end)

local noclipEnabled = false;
createButton(scroll, "Toggle Noclip", function()
	noclipEnabled = not noclipEnabled
end)
RunService.Stepped:Connect(function()
	if noclipEnabled and LocalPlayer.Character then
		for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)
createButton(scroll, "Speed Hack Really Fast OP", function()
	pcall(function()
		LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = 80;
		LocalPlayer.Character:WaitForChild("Humanoid"):GetPropertyChangedSignal("WalkSpeed"):Connect(function()
			pcall(function()
				LocalPlayer.Character.Humanoid.WalkSpeed = 80
			end)
		end)
	end)
end)
createButton(scroll, "Speed Hack Not As Fast", function()
	pcall(function()
		LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = 50;
		LocalPlayer.Character:WaitForChild("Humanoid"):GetPropertyChangedSignal("WalkSpeed"):Connect(function()
			pcall(function()
				LocalPlayer.Character.Humanoid.WalkSpeed = 50
			end)
		end)
	end)
end)
createButton(scroll, "Speed Hack Bypass Some Anticheats", function()
	RunService.Heartbeat:Connect(function()
		pcall(function()
			local cam = workspace.CurrentCamera;
			local move = Vector3.zero;
			local character = LocalPlayer.Character;
			local root = character and character:FindFirstChild("HumanoidRootPart")
			if not root then
				return
			end;
			local forward = Vector3.new(cam.CFrame.LookVector.X, 0, cam.CFrame.LookVector.Z).Unit;
			local right = Vector3.new(cam.CFrame.RightVector.X, 0, cam.CFrame.RightVector.Z).Unit;
			if UserInputService:IsKeyDown(Enum.KeyCode.W) then
				move += forward
			end;
			if UserInputService:IsKeyDown(Enum.KeyCode.S) then
				move -= forward
			end;
			if UserInputService:IsKeyDown(Enum.KeyCode.A) then
				move -= right
			end;
			if UserInputService:IsKeyDown(Enum.KeyCode.D) then
				move += right
			end;
			if move.Magnitude > 0 then
				root.Velocity = move.Unit * 50
			end
		end)
	end)
end)
createButton(scroll, "Infinite Jump", function()
	if infJump then
		infJump:Disconnect()
	end;
	infJumpDebounce = false;
	infJump = UserInputService.JumpRequest:Connect(function()
		if not infJumpDebounce then
			infJumpDebounce = true;
			LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
			task.wait()
			infJumpDebounce = false
		end
	end)
end)
createButton(scroll, "Break Client-Sided Damage", function()
	pcall(function()
		local player = LocalPlayer;
		local function onCharacter(char)
			local humanoid = char:WaitForChild("Humanoid")
			humanoid:GetPropertyChangedSignal("Health"):Connect(function()
				pcall(function()
					humanoid.Health = humanoid.MaxHealth
				end)
			end)
		end;
		if player.Character then
			onCharacter(player.Character)
		end;
		player.CharacterAdded:Connect(onCharacter)
	end)
end)
Close.Name = "Close"
Close.Parent = Frame
Close.BackgroundColor3 = Color3.fromRGB(76, 76, 76)
Close.BorderColor3 = Color3.fromRGB(97, 97, 97)
Close.Position = UDim2.new(0.033303082, 0, 0.570439577, 0)
Close.Size = UDim2.new(0, 579, 0, 101)
Close.Font = Enum.Font.GothamBold
Close.Text = "Close GUI"
Close.TextColor3 = Color3.fromRGB(255, 255, 255)
Close.TextSize = 2.77
Close.MouseButton1Down:connect(function()
Frame.Visible = false
   end)
end)
createButton(scroll, "Open Fly GUI", function()
	loadstring(game:HttpGet("https://pastebin.com/raw/XS9ytz61"))()
end)
local descendantAddedConn;
createButton(scroll, "Instant ProximityPrompts", function()
	for _, v in ipairs(game:GetDescendants()) do
		pcall(function()
			if typeof(v) == "Instance" and v.ClassName == "ProximityPrompt" then
				v.HoldDuration = 0
			end
		end)
	end;
	if descendantAddedConn then
		descendantAddedConn:Disconnect()
	end;
	descendantAddedConn = game.DescendantAdded:Connect(function(descendant)
		pcall(function()
			if typeof(descendant) == "Instance" and descendant.ClassName == "ProximityPrompt" then
				descendant.HoldDuration = 0
			end
		end)
	end)
end)

createButton(scroll, "Open a window with Telegram", function()
	showInfoPopup()
end)