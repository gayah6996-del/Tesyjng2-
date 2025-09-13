local player = game.Players.LocalPlayer
local currentHumanoid = nil
-- === НАСТРОЙКИ ИНФО-ОКНА ===
local TELEGRAM_HANDLE = "https://t.me/SFXCL"
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

local function updateHumanoid()
    local character = player.Character or player.CharacterAdded:Wait()
    currentHumanoid = character:WaitForChild("Humanoid")
end

local function createGui()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = game.CoreGui

        local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 150)
    frame.Position = UDim2.new(0.5, -150, 0.5, -75)
    frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    frame.Parent = screenGui
    frame.Active = true
    frame.Draggable = true


        local walkSpeedLabel = Instance.new("TextLabel")
    walkSpeedLabel.Text = "WalkSpeed:"
    walkSpeedLabel.Size = UDim2.new(0, 100, 0, 50)
    walkSpeedLabel.Position = UDim2.new(0, 10, 0, 10)
    walkSpeedLabel.TextColor3 = Color3.new(1, 1, 1)
    walkSpeedLabel.BackgroundTransparency = 1
    walkSpeedLabel.Parent = frame


    local walkSpeedBox = Instance.new("TextBox")
    walkSpeedBox.PlaceholderText = tostring(currentHumanoid.WalkSpeed)
    walkSpeedBox.Size = UDim2.new(0, 100, 0, 50)
    walkSpeedBox.Position = UDim2.new(0, 110, 0, 10)
    walkSpeedBox.TextColor3 = Color3.new(1, 1, 1)
    walkSpeedBox.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    walkSpeedBox.Parent = frame


    local jumpPowerLabel = Instance.new("TextLabel")
    jumpPowerLabel.Text = "JumpPower:"
    jumpPowerLabel.Size = UDim2.new(0, 100, 0, 50)
    jumpPowerLabel.Position = UDim2.new(0, 10, 0, 70)
    jumpPowerLabel.TextColor3 = Color3.new(1, 1, 1)
    jumpPowerLabel.BackgroundTransparency = 1
    jumpPowerLabel.Parent = frame

      local jumpPowerBox = Instance.new("TextBox")
    jumpPowerBox.PlaceholderText = tostring(currentHumanoid.JumpPower)
    jumpPowerBox.Size = UDim2.new(0, 100, 0, 50)
    jumpPowerBox.Position = UDim2.new(0, 110, 0, 70)
    jumpPowerBox.TextColor3 = Color3.new(1, 1, 1)
    jumpPowerBox.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    jumpPowerBox.Parent = frame


    walkSpeedBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local newWalkSpeed = tonumber(walkSpeedBox.Text)
            if newWalkSpeed then
                currentHumanoid.WalkSpeed = newWalkSpeed
            end
        end
    end)


    jumpPowerBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local newJumpPower = tonumber(jumpPowerBox.Text)
            if newJumpPower then
                currentHumanoid.JumpPower = newJumpPower
            end
        end
    end)
end

    local sosoLabel = Instance.new("TextLabel")
    sosoLabel.Text = "https://t.me/itzperson"
    sosoLabel.Size = UDim2.new(0, 100, 0, 50)
    sosoLabel.Position = UDim2.new(0, 10, 0, 70)
    sosoLabel.TextColor3 = Color3.new(1, 1, 1)
    sosoLabel.BackgroundTransparency = 1
    sosoLabel.Parent = frame


local function onCharacterAdded(character)
    updateHumanoid()
end


player.CharacterAdded:Connect(onCharacterAdded)

if player.Character then
    updateHumanoid()
    createGui()
end