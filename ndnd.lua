-- Services
local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local players = game:GetService("Players")
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")

-- Aimbot & ESP Variables
local aimbotEnabled = false
local espEnabled = false
local teamCheckEnabled = false
local fovRadius = 100
local aimbotMaxDistance = 100
local guiName = "ASTRALCHEAT"
local guiVisible = true
local espObjects = {}
local aimbotTarget = "Head"

-- Переменные для камеры
local customCameraFOVEnabled = false
local cameraFOV = 70

-- Переменные для Infinite Jump
local infiniteJumpEnabled = false

-- Переменные для перемещения GUI
local frame = nil
local isDragging = false
local dragStart = nil
local frameStart = nil
local activeTab = "Info"

-- Language System
local currentLanguage = "English" -- Default language

-- Theme System
local currentTheme = "Dark" -- Default theme

-- Themes
local themes = {
    Dark = {
        backgroundColor = Color3.fromRGB(30, 30, 30),
        tabColor = Color3.fromRGB(40, 40, 40),
        buttonColor = Color3.fromRGB(100, 100, 100),
        activeButtonColor = Color3.fromRGB(80, 80, 80),
        textColor = Color3.new(1, 1, 1),
        borderColor = Color3.fromRGB(100, 100, 100),
        sliderBackground = Color3.fromRGB(80, 80, 80),
        titleBackground = Color3.fromRGB(50, 50, 50)
    },
    Black = {
        backgroundColor = Color3.fromRGB(0, 0, 0),
        tabColor = Color3.fromRGB(20, 20, 20),
        buttonColor = Color3.fromRGB(50, 50, 50),
        activeButtonColor = Color3.fromRGB(30, 30, 30),
        textColor = Color3.new(1, 1, 1),
        borderColor = Color3.fromRGB(80, 80, 80),
        sliderBackground = Color3.fromRGB(60, 60, 60),
        titleBackground = Color3.fromRGB(30, 30, 30)
    },
    White = {
        backgroundColor = Color3.fromRGB(240, 240, 240),
        tabColor = Color3.fromRGB(220, 220, 220),
        buttonColor = Color3.fromRGB(180, 180, 180),
        activeButtonColor = Color3.fromRGB(160, 160, 160),
        textColor = Color3.new(0, 0, 0),
        borderColor = Color3.fromRGB(150, 150, 150),
        sliderBackground = Color3.fromRGB(200, 200, 200),
        titleBackground = Color3.fromRGB(200, 200, 200)
    }
}

-- Translations
local translations = {
    English = {
        title = "ASTRALCHEAT v2.0",
        infoTab = "Info",
        espTab = "ESP",
        aimbotTab = "AimBot",
        cameraTab = "Memory",
        languageTab = "Language",
        close = "Close Menu?",
        yes = "Yes",
        no = "No",
        hideGUI = "Hide GUI",
        showGUI = "Show GUI",
        
        -- Info Tab
        infoText = "ASTRALCHEAT v2.0\n\nDeveloper: @SFXCL\n\nFeatures:\n• Aimbot with settings\n• ESP with boxes\n• FOV customization\n• Custom Camera FOV\n• Aimbot distance limit\n• Infinite Jump\nLanguage:English\nUse at your own risk!",
        
        -- ESP Tab
        espButton = "ESP: OFF",
        espOn = "ESP: ON v",
        
        -- Aimbot Tab
        aimbotButton = "Aimbot: OFF",
        aimbotOn = "Aimbot: ON v",
        targetDropdown = "Target: Head",
        fovLabel = "FOV Radius: ",
        distanceLabel = "Aimbot Distance: ",
        targetHead = "Head",
        targetBody = "Body",
        
        -- Camera Tab
        infiniteJumpButton = "Infinite Jump: OFF",
        infiniteJumpOn = "Infinite Jump: ON v",
        cameraFOVButton = "CamFOV: OFF",
        cameraFOVOn = "CamFOV: ON v",
        cameraFOVLabel = "Camera FOV: ",
        
        -- Language Tab
        languageTitle = "Select Language:",
        languageDropdown = "Language: English",
        englishButton = "English🇬🇧",
        russianButton = "Russian🇷🇺",
        chineseButton = "Chinese🇨🇳",
        currentLanguage = "Current: English",
        
        -- Theme Tab
        themeTitle = "Select Theme:",
        themeDropdown = "Theme: Dark",
        blackTheme = "Black",
        darkTheme = "Dark", 
        whiteTheme = "White",
        currentTheme = "Current: Dark"
    },
    
    Russian = {
        title = "ASTRALCHEAT v2.0",
        infoTab = "Инфо",
        espTab = "ESP",
        aimbotTab = "АимБот",
        cameraTab = "Мемори",
        languageTab = "Язык",
        close = "Закрыть меню?",
        yes = "Да",
        no = "Нет",
        hideGUI = "Скрыть GUI",
        showGUI = "Показать GUI",
        
        -- Info Tab
        infoText = "ASTRALCHEAT v2.0\n\nРазработчик: @SFXCL\n\nФункции:\n• Aimbot с настройкой\n• ESP с боксами\n• Настройка FOV\n• Кастомный FOV камеры\n• Ограничение дистанции аимбота\n• Infinite Jump\nЯзык:Русский\nИспользуйте на свой страх и риск!",
        
        -- ESP Tab
        espButton = "ESP: ВЫКЛ",
        espOn = "ESP: ВКЛ v",
        
        -- Aimbot Tab
        aimbotButton = "АимБот: ВЫКЛ",
        aimbotOn = "АимБот: ВКЛ v",
        targetDropdown = "Цель: Голова",
        fovLabel = "Радиус Круга: ",
        distanceLabel = "Дистанция аимбота: ",
        targetHead = "Голова",
        targetBody = "Тело",
        
        -- Camera Tab
        infiniteJumpButton = "Беск. Прыжок: ВЫКЛ",
        infiniteJumpOn = "Беск. Прыжок: ВКЛ v",
        cameraFOVButton = "Обзор Камеры: ВЫКЛ",
        cameraFOVOn = "Обзор Камеры: ВКЛ v",
        cameraFOVLabel = "ОбзорКамеры: ",
        
        -- Language Tab
        languageTitle = "Выберите язык:",
        languageDropdown = "Язык: Русский",
        englishButton = "Английский🇬🇧",
        russianButton = "Русский🇷🇺",
        chineseButton = "Китайский🇨🇳",
        currentLanguage = "Текущий: Русский",
        
        -- Theme Tab
        themeTitle = "Выберите тему:",
        themeDropdown = "Тема: Темная",
        blackTheme = "Черная",
        darkTheme = "Темная",
        whiteTheme = "Белая",
        currentTheme = "Текущая: Темная"
    },
    
    Chinese = {
        title = "ASTRALCHEAT v2.0",
        infoTab = "信息",
        espTab = "ESP",
        aimbotTab = "瞄准辅助",
        cameraTab = "相机",
        languageTab = "语言",
        close = "关闭菜单?",
        yes = "是",
        no = "否",
        hideGUI = "隐藏界面",
        showGUI = "显示界面",
        
        -- Info Tab
        infoText = "ASTRALCHEAT v2.0\n\n开发者: @SFXCL\n\n功能:\n• 可配置的瞄准辅助\n• 方框ESP\n• FOV自定义\n• 自定义相机FOV\n• 瞄准辅助距离限制\n• 无限跳跃\n语言:中文\n使用风险自负!",
        
        -- ESP Tab
        espButton = "ESP: 关闭",
        espOn = "ESP: 开启 v",
        
        -- Aimbot Tab
        aimbotButton = "瞄准辅助: 关闭",
        aimbotOn = "瞄准辅助: 开启 v",
        targetDropdown = "目标: 头部",
        fovLabel = "FOV半径: ",
        distanceLabel = "瞄准距离: ",
        targetHead = "头部",
        targetBody = "身体",
        
        -- Camera Tab
        infiniteJumpButton = "无限跳跃: 关闭",
        infiniteJumpOn = "无限跳跃: 开启 v",
        cameraFOVButton = "相机FOV: 关闭",
        cameraFOVOn = "相机FOV: 开启 v",
        cameraFOVLabel = "相机FOV: ",
        
        -- Language Tab
        languageTitle = "选择语言:",
        languageDropdown = "语言: 中文",
        englishButton = "英语🇬🇧",
        russianButton = "俄语🇷🇺",
        chineseButton = "中文🇨🇳",
        currentLanguage = "当前: 中文",
        
        -- Theme Tab
        themeTitle = "选择主题:",
        themeDropdown = "主题: 深色",
        blackTheme = "黑色",
        darkTheme = "深色",
        whiteTheme = "白色",
        currentTheme = "当前: 深色"
    }
}

-- FOV Circle
local circle = Drawing.new("Circle")
circle.Color = Color3.fromRGB(255, 255, 255)
circle.Thickness = 1
circle.Filled = false
circle.Radius = fovRadius
circle.Visible = true
circle.Position = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)

-- Infinite Jump Functionality
userInputService.JumpRequest:connect(function()
    if infiniteJumpEnabled then
        game:GetService"Players".LocalPlayer.Character:FindFirstChildOfClass'Humanoid':ChangeState("Jumping")
    end
end)

-- Show Notification
local function showNotification()
    local notification = Instance.new("ScreenGui")
    notification.Name = "NotificationGUI"
    notification.ResetOnSpawn = false
    notification.Parent = player:WaitForChild("PlayerGui")

    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://9125402735"
    sound.Volume = 1
    sound.Parent = notification
    sound:Play()

    local textLabel = Instance.new("TextLabel")
    textLabel.Parent = notification
    textLabel.Size = UDim2.new(0, 250, 0, 50)
    textLabel.Position = UDim2.new(1, -260, 1, -60)
    textLabel.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    textLabel.BorderSizePixel = 0
    textLabel.Text = "ASTRALCHEAT успешно запущен!"
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.SourceSansBold

    task.delay(3, function()
        for i = 1, 10 do
            textLabel.TextTransparency = i * 0.1
            textLabel.BackgroundTransparency = i * 0.1
            task.wait(0.05)
        end
        notification:Destroy()
    end)
end

-- Create ESP for a player
local function createESPForPlayer(p)
    local nameTag = Drawing.new("Text")
    nameTag.Size = 14
    nameTag.Color = Color3.fromRGB(255, 0, 0)
    nameTag.Center = true
    nameTag.Outline = true

    local distanceTag = Drawing.new("Text")
    distanceTag.Size = 13
    distanceTag.Color = Color3.fromRGB(255, 0, 0)
    distanceTag.Center = true
    distanceTag.Outline = true

    local box = Drawing.new("Square")
    box.Thickness = 1
    box.Color = Color3.fromRGB(255, 0, 0)
    box.Filled = false

    local tracer = Drawing.new("Line")
    tracer.Thickness = 1
    tracer.Color = Color3.fromRGB(255, 0, 0)

    espObjects[p] = {
        name = nameTag,
        distance = distanceTag,
        box = box,
        tracer = tracer
    }
end

-- Remove ESP
local function removeESPForPlayer(p)
    if espObjects[p] then
        for _, drawing in pairs(espObjects[p]) do
            drawing:Remove()
        end
        espObjects[p] = nil
    end
end

players.PlayerRemoving:Connect(removeESPForPlayer)

-- Visibility Check
local function isVisible(part)
    if not part then return false end
    local origin = camera.CFrame.Position
    local direction = (part.Position - origin)
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist
    rayParams.FilterDescendantsInstances = { player.Character or workspace }
    local result = workspace:Raycast(origin, direction, rayParams)
    if result then
        return part:IsDescendantOf(result.Instance.Parent) or result.Instance:IsDescendantOf(part.Parent)
    else
        return true
    end
end

-- Closest Player Function (with team check and distance check)
local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = fovRadius

    for _, p in pairs(players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
            if teamCheckEnabled and p.Team == player.Team then
                continue
            end
            
            local targetPart = p.Character:FindFirstChild(aimbotTarget)
            if not targetPart then
                targetPart = p.Character.Head
            end
            
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local distanceToPlayer = (player.Character.HumanoidRootPart.Position - targetPart.Position).Magnitude
                if distanceToPlayer > aimbotMaxDistance then
                    continue
                end
            end
            
            local screenPos, onScreen = camera:WorldToViewportPoint(targetPart.Position)
            if onScreen then
                local distanceFromCenter = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)).Magnitude
                if distanceFromCenter < shortestDistance and isVisible(targetPart) then
                    shortestDistance = distanceFromCenter
                    closestPlayer = p
                end
            end
        end
    end

    return closestPlayer
end

-- Function to update theme
local function updateTheme()
    local theme = themes[currentTheme]
    
    if frame then
        frame.BackgroundColor3 = theme.backgroundColor
        frame.BorderColor3 = theme.borderColor
    end
    
    if tabsPanel then
        tabsPanel.BackgroundColor3 = theme.tabColor
    end
    
    if mainContainer then
        mainContainer.BackgroundColor3 = theme.backgroundColor
    end
    
    if contentContainer then
        contentContainer.BackgroundColor3 = theme.backgroundColor
    end
    
    -- Update tab containers
    local containers = {infoContainer, espContainer, aimbotContainer, cameraContainer, languageContainer}
    for _, container in pairs(containers) do
        if container then
            container.BackgroundColor3 = theme.backgroundColor
        end
    end
    
    -- Update title
    if title then
        title.BackgroundColor3 = theme.titleBackground
        title.TextColor3 = theme.textColor
    end
    
    -- Update close button
    if closeButton then
        closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        closeButton.TextColor3 = theme.textColor
    end
    
    -- Update confirmation frame
    if confirmFrame then
        confirmFrame.BackgroundColor3 = theme.backgroundColor
        confirmFrame.BorderColor3 = theme.borderColor
    end
    
    if confirmText then
        confirmText.TextColor3 = theme.textColor
    end
    
    -- Update tab buttons
    local tabButtons = {infoTabButton, espTabButton, aimbotTabButton, cameraTabButton, languageTabButton}
    for _, button in pairs(tabButtons) do
        if button then
            if button.Text == activeTab or button.Text == translations[currentLanguage].infoTab and activeTab == "Info" or
               button.Text == translations[currentLanguage].espTab and activeTab == "ESP" or
               button.Text == translations[currentLanguage].aimbotTab and activeTab == "AimBot" or
               button.Text == translations[currentLanguage].cameraTab and activeTab == "Camera" or
               button.Text == translations[currentLanguage].languageTab and activeTab == "Language" then
                button.BackgroundColor3 = theme.activeButtonColor
            else
                button.BackgroundColor3 = theme.buttonColor
            end
            button.TextColor3 = theme.textColor
            button.BorderColor3 = theme.borderColor
        end
    end
    
    -- Update function buttons
    local functionButtons = {espButton, aimbotButton, targetDropdown, infiniteJumpButton, cameraFOVButton, languageDropdown, themeDropdown}
    for _, button in pairs(functionButtons) do
        if button then
            if string.find(button.Text, "ON") or string.find(button.Text, "ВКЛ") or string.find(button.Text, "开启") then
                button.BackgroundColor3 = theme.activeButtonColor
            else
                button.BackgroundColor3 = theme.buttonColor
            end
            button.TextColor3 = theme.textColor
        end
    end
    
    -- Update dropdown containers
    local dropdownContainers = {dropdownContainer, languageDropdownContainer, themeDropdownContainer}
    for _, container in pairs(dropdownContainers) do
        if container then
            container.BackgroundColor3 = theme.backgroundColor
            container.BorderColor3 = theme.borderColor
        end
    end
    
    -- Update dropdown options
    local dropdownOptions = {headButton, bodyButton, englishOption, russianOption, chineseOption, blackThemeOption, darkThemeOption, whiteThemeOption}
    for _, option in pairs(dropdownOptions) do
        if option then
            option.BackgroundColor3 = theme.buttonColor
            option.TextColor3 = theme.textColor
        end
    end
    
    -- Update sliders
    local sliderFrames = {fovSliderFrame, distanceSliderFrame, cameraFOVSliderFrame}
    for _, frame in pairs(sliderFrames) do
        if frame then
            frame.BackgroundColor3 = theme.backgroundColor
        end
    end
    
    local sliderBackgrounds = {sliderBackground, distanceSliderBackground, cameraSliderBackground}
    for _, bg in pairs(sliderBackgrounds) do
        if bg then
            bg.BackgroundColor3 = theme.sliderBackground
        end
    end
    
    -- Update text labels
    local textLabels = {fovLabel, distanceLabel, cameraFOVLabel, infoText, languageTitle, currentLanguageLabel, themeTitle, currentThemeLabel}
    for _, label in pairs(textLabels) do
        if label then
            label.TextColor3 = theme.textColor
        end
    end
    
    -- Update hide button
    if hideButton then
        hideButton.BackgroundColor3 = theme.buttonColor
        hideButton.TextColor3 = theme.textColor
    end
end

-- Function to update all GUI texts based on current language
local function updateLanguage()
    local t = translations[currentLanguage]
    
    -- Update main title
    if frame then
        frame:FindFirstChildOfClass("TextLabel").Text = t.title
    end
    
    -- Update tab buttons
    if tabsPanel then
        for _, child in pairs(tabsPanel:GetChildren()) do
            if child:IsA("TextButton") then
                if child.Name == "InfoTab" then
                    child.Text = t.infoTab
                elseif child.Name == "ESPTab" then
                    child.Text = t.espTab
                elseif child.Name == "AimBotTab" then
                    child.Text = t.aimbotTab
                elseif child.Name == "CameraTab" then
                    child.Text = t.cameraTab
                elseif child.Name == "LanguageTab" then
                    child.Text = t.languageTab
                end
            end
        end
    end
    
    -- Update close confirmation
    if confirmFrame then
        confirmFrame:FindFirstChildOfClass("TextLabel").Text = t.close
        for _, child in pairs(confirmFrame:GetChildren()) do
            if child:IsA("TextButton") then
                if child.Text == "Yes" or child.Text == "Да" or child.Text == "是" then
                    child.Text = t.yes
                elseif child.Text == "No" or child.Text == "Нет" or child.Text == "否" then
                    child.Text = t.no
                end
            end
        end
    end
    
    -- Update hide button
    if hideButton then
        hideButton.Text = guiVisible and t.hideGUI or t.showGUI
    end
    
    -- Update Info tab
    if infoContainer then
        local infoTextLabel = infoContainer:FindFirstChildOfClass("TextLabel")
        if infoTextLabel then
            infoTextLabel.Text = t.infoText
        end
    end
    
    -- Update ESP tab
    if espContainer then
        local espButton = espContainer:FindFirstChildOfClass("TextButton")
        if espButton then
            espButton.Text = espEnabled and t.espOn or t.espButton
        end
    end
    
    -- Update Aimbot tab
    if aimbotContainer then
        for _, child in pairs(aimbotContainer:GetChildren()) do
            if child:IsA("TextButton") then
                if child.Name == "AimbotButton" then
                    child.Text = aimbotEnabled and t.aimbotOn or t.aimbotButton
                elseif child.Name == "TargetDropdown" then
                    child.Text = aimbotTarget == "Head" and t.targetDropdown:gsub("Head", t.targetHead) or t.targetDropdown:gsub("Head", t.targetBody)
                end
            elseif child:IsA("TextLabel") then
                if child.Text:find("FOV Radius") or child.Text:find("Радиус Круга") or child.Text:find("FOV半径") then
                    child.Text = t.fovLabel .. fovRadius
                elseif child.Text:find("Aimbot Distance") or child.Text:find("Дистанция аимбота") or child.Text:find("瞄准距离") then
                    child.Text = t.distanceLabel .. aimbotMaxDistance .. "m"
                end
            end
        end
        
        -- Update dropdown options
        if dropdownContainer then
            for _, child in pairs(dropdownContainer:GetChildren()) do
                if child:IsA("TextButton") then
                    if child.Text == "Head" or child.Text == "Голова" or child.Text == "头部" then
                        child.Text = t.targetHead
                    elseif child.Text == "Body" or child.Text == "Тело" or child.Text == "身体" then
                        child.Text = t.targetBody
                    end
                end
            end
        end
    end
    
    -- Update Camera tab
    if cameraContainer then
        for _, child in pairs(cameraContainer:GetChildren()) do
            if child:IsA("TextButton") then
                if child.Name == "InfiniteJumpButton" then
                    child.Text = infiniteJumpEnabled and t.infiniteJumpOn or t.infiniteJumpButton
                elseif child.Name == "CameraFOVButton" then
                    child.Text = customCameraFOVEnabled and t.cameraFOVOn or t.cameraFOVButton
                end
            elseif child:IsA("TextLabel") then
                if child.Text:find("Camera FOV") or child.Text:find("FOV Камеры") or child.Text:find("相机FOV") then
                    child.Text = t.cameraFOVLabel .. cameraFOV
                end
            end
        end
    end
    
    -- Update Language tab
    if languageContainer then
        local titleLabel = languageContainer:FindFirstChild("LanguageTitle")
        if titleLabel then
            titleLabel.Text = t.languageTitle
        end
        
        local currentLabel = languageContainer:FindFirstChild("CurrentLanguage")
        if currentLabel then
            currentLabel.Text = t.currentLanguage
        end
        
        local dropdownButton = languageContainer:FindFirstChild("LanguageDropdown")
        if dropdownButton then
            dropdownButton.Text = t.languageDropdown
        end
        
        -- Update dropdown options
        if languageDropdownContainer then
            for _, child in pairs(languageDropdownContainer:GetChildren()) do
                if child:IsA("TextButton") then
                    if child.Name == "EnglishOption" then
                        child.Text = t.englishButton
                    elseif child.Name == "RussianOption" then
                        child.Text = t.russianButton
                    elseif child.Name == "ChineseOption" then
                        child.Text = t.chineseButton
                    end
                end
            end
        end
        
        -- Update Theme section
        local themeTitleLabel = languageContainer:FindFirstChild("ThemeTitle")
        if themeTitleLabel then
            themeTitleLabel.Text = t.themeTitle
        end
        
        local currentThemeLabel = languageContainer:FindFirstChild("CurrentTheme")
        if currentThemeLabel then
            currentThemeLabel.Text = t.currentTheme
        end
        
        local themeDropdownButton = languageContainer:FindFirstChild("ThemeDropdown")
        if themeDropdownButton then
            themeDropdownButton.Text = t.themeDropdown
        end
        
        -- Update theme dropdown options
        if themeDropdownContainer then
            for _, child in pairs(themeDropdownContainer:GetChildren()) do
                if child:IsA("TextButton") then
                    if child.Name == "BlackThemeOption" then
                        child.Text = t.blackTheme
                    elseif child.Name == "DarkThemeOption" then
                        child.Text = t.darkTheme
                    elseif child.Name == "WhiteThemeOption" then
                        child.Text = t.whiteTheme
                    end
                end
            end
        end
    end
end

-- GUI Creation Function
local function createGUI()
    local gui = Instance.new("ScreenGui")
    gui.Name = guiName
    gui.ResetOnSpawn = false
    gui.Parent = player:WaitForChild("PlayerGui")

    -- Основной контейнер
    frame = Instance.new("Frame", gui)
    frame.Position = UDim2.new(0.5, -175, 0.5, -150)
    frame.Size = UDim2.new(0, 350, 0, 300)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BorderSizePixel = 1
    frame.BorderColor3 = Color3.fromRGB(100, 100, 100)
    frame.Visible = guiVisible

    -- Заголовок (для перетаскивания)
    title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, 0, 0, 25)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    title.Text = "ASTRALCHEAT v2.0"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.TextScaled = true
    title.Font = Enum.Font.SourceSansBold
    title.BorderSizePixel = 0

    -- Кнопка закрытия (крестик)
    closeButton = Instance.new("TextButton", frame)
    closeButton.Size = UDim2.new(0, 25, 0, 25)
    closeButton.Position = UDim2.new(1, -25, 0, 0)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.new(1, 1, 1)
    closeButton.TextScaled = true
    closeButton.BorderSizePixel = 0
    closeButton.ZIndex = 2

    -- Контейнер для подтверждения закрытия
    confirmFrame = Instance.new("Frame", gui)
    confirmFrame.Size = UDim2.new(0, 300, 0, 120)
    confirmFrame.Position = UDim2.new(0.5, -150, 0.5, -60)
    confirmFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    confirmFrame.BorderSizePixel = 1
    confirmFrame.BorderColor3 = Color3.fromRGB(100, 100, 100)
    confirmFrame.Visible = false
    confirmFrame.ZIndex = 100

    confirmText = Instance.new("TextLabel", confirmFrame)
    confirmText.Size = UDim2.new(0.9, 0, 0.4, 0)
    confirmText.Position = UDim2.new(0.05, 0, 0.1, 0)
    confirmText.BackgroundTransparency = 1
    confirmText.Text = "Вы хотите закрыть меню?"
    confirmText.TextColor3 = Color3.new(1, 1, 1)
    confirmText.TextScaled = true
    confirmText.Font = Enum.Font.SourceSansBold
    confirmText.ZIndex = 101

    local yesButton = Instance.new("TextButton", confirmFrame)
    yesButton.Size = UDim2.new(0.4, 0, 0.3, 0)
    yesButton.Position = UDim2.new(0.05, 0, 0.55, 0)
    yesButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    yesButton.Text = "Да"
    yesButton.TextColor3 = Color3.new(1, 1, 1)
    yesButton.TextScaled = true
    yesButton.BorderSizePixel = 0
    yesButton.ZIndex = 101

    local noButton = Instance.new("TextButton", confirmFrame)
    noButton.Size = UDim2.new(0.4, 0, 0.3, 0)
    noButton.Position = UDim2.new(0.55, 0, 0.55, 0)
    noButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
    noButton.Text = "Нет"
    noButton.TextColor3 = Color3.new(1, 1, 1)
    noButton.TextScaled = true
    noButton.BorderSizePixel = 0
    noButton.ZIndex = 101

    -- Контейнер для вкладок и контента
    mainContainer = Instance.new("Frame", frame)
    mainContainer.Size = UDim2.new(1, 0, 1, -25)
    mainContainer.Position = UDim2.new(0, 0, 0, 25)
    mainContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainContainer.BorderSizePixel = 0

    -- Панель вкладок (вертикальная)
    tabsPanel = Instance.new("Frame", mainContainer)
    tabsPanel.Size = UDim2.new(0, 80, 1, 0)
    tabsPanel.Position = UDim2.new(0, 0, 0, 0)
    tabsPanel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    tabsPanel.BorderSizePixel = 0

    -- Контейнер для контента
    contentContainer = Instance.new("Frame", mainContainer)
    contentContainer.Size = UDim2.new(1, -80, 1, 0)
    contentContainer.Position = UDim2.new(0, 80, 0, 0)
    contentContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    contentContainer.BorderSizePixel = 0

    -- Вкладка Info (первая)
    infoTabButton = Instance.new("TextButton", tabsPanel)
    infoTabButton.Name = "InfoTab"
    infoTabButton.Size = UDim2.new(0.9, 0, 0, 25)
    infoTabButton.Position = UDim2.new(0.05, 0, 0.02, 0)
    infoTabButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    infoTabButton.Text = "Info"
    infoTabButton.TextColor3 = Color3.new(1, 1, 1)
    infoTabButton.TextScaled = true
    infoTabButton.BorderSizePixel = 1
    infoTabButton.BorderColor3 = Color3.fromRGB(150, 150, 150)

    -- Вкладка ESP (вторая)
    espTabButton = Instance.new("TextButton", tabsPanel)
    espTabButton.Name = "ESPTab"
    espTabButton.Size = UDim2.new(0.9, 0, 0, 25)
    espTabButton.Position = UDim2.new(0.05, 0, 0.12, 0)
    espTabButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    espTabButton.Text = "ESP"
    espTabButton.TextColor3 = Color3.new(1, 1, 1)
    espTabButton.TextScaled = true
    espTabButton.BorderSizePixel = 1
    espTabButton.BorderColor3 = Color3.fromRGB(150, 150, 150)

    -- Вкладка AimBot (третья)
    aimbotTabButton = Instance.new("TextButton", tabsPanel)
    aimbotTabButton.Name = "AimBotTab"
    aimbotTabButton.Size = UDim2.new(0.9, 0, 0, 25)
    aimbotTabButton.Position = UDim2.new(0.05, 0, 0.22, 0)
    aimbotTabButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    aimbotTabButton.Text = "AimBot"
    aimbotTabButton.TextColor3 = Color3.new(1, 1, 1)
    aimbotTabButton.TextScaled = true
    aimbotTabButton.BorderSizePixel = 1
    aimbotTabButton.BorderColor3 = Color3.fromRGB(150, 150, 150)

    -- Вкладка Camera (четвертая)
    cameraTabButton = Instance.new("TextButton", tabsPanel)
    cameraTabButton.Name = "CameraTab"
    cameraTabButton.Size = UDim2.new(0.9, 0, 0, 25)
    cameraTabButton.Position = UDim2.new(0.05, 0, 0.32, 0)
    cameraTabButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    cameraTabButton.Text = "Camera"
    cameraTabButton.TextColor3 = Color3.new(1, 1, 1)
    cameraTabButton.TextScaled = true
    cameraTabButton.BorderSizePixel = 1
    cameraTabButton.BorderColor3 = Color3.fromRGB(150, 150, 150)

    -- Вкладка Language (пятая)
    languageTabButton = Instance.new("TextButton", tabsPanel)
    languageTabButton.Name = "LanguageTab"
    languageTabButton.Size = UDim2.new(0.9, 0, 0, 25)
    languageTabButton.Position = UDim2.new(0.05, 0, 0.42, 0)
    languageTabButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    languageTabButton.Text = "Language"
    languageTabButton.TextColor3 = Color3.new(1, 1, 1)
    languageTabButton.TextScaled = true
    languageTabButton.BorderSizePixel = 1
    languageTabButton.BorderColor3 = Color3.fromRGB(150, 150, 150)

    -- Контейнеры для содержимого вкладок
    infoContainer = Instance.new("Frame", contentContainer)
    infoContainer.Size = UDim2.new(1, 0, 1, 0)
    infoContainer.Position = UDim2.new(0, 0, 0, 0)
    infoContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    infoContainer.BorderSizePixel = 0
    infoContainer.Visible = true

    espContainer = Instance.new("Frame", contentContainer)
    espContainer.Size = UDim2.new(1, 0, 1, 0)
    espContainer.Position = UDim2.new(0, 0, 0, 0)
    espContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    espContainer.BorderSizePixel = 0
    espContainer.Visible = false

    aimbotContainer = Instance.new("Frame", contentContainer)
    aimbotContainer.Size = UDim2.new(1, 0, 1, 0)
    aimbotContainer.Position = UDim2.new(0, 0, 0, 0)
    aimbotContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    aimbotContainer.BorderSizePixel = 0
    aimbotContainer.Visible = false

    cameraContainer = Instance.new("Frame", contentContainer)
    cameraContainer.Size = UDim2.new(1, 0, 1, 0)
    cameraContainer.Position = UDim2.new(0, 0, 0, 0)
    cameraContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    cameraContainer.BorderSizePixel = 0
    cameraContainer.Visible = false

    languageContainer = Instance.new("Frame", contentContainer)
    languageContainer.Size = UDim2.new(1, 0, 1, 0)
    languageContainer.Position = UDim2.new(0, 0, 0, 0)
    languageContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    languageContainer.BorderSizePixel = 0
    languageContainer.Visible = false

    -- ========== ВКЛАДКА INFO ==========
    
    infoText = Instance.new("TextLabel", infoContainer)
    infoText.Size = UDim2.new(0.9, 0, 0.8, 0)
    infoText.Position = UDim2.new(0.05, 0, 0.05, 0)
    infoText.BackgroundTransparency = 1
    infoText.Text = "ASTRALCHEAT v2.0\n\nРазработчик: @SFXCL\n\nФункции:\n• Aimbot с настройкой\n• ESP с боксами\n• Настройка FOV\n• Кастомный FOV камеры\n• Ограничение дистанции аимбота\n• Infinite Jump\n\nИспользуйте на свой страх и риск!"
    infoText.TextColor3 = Color3.new(1, 1, 1)
    infoText.TextScaled = true
    infoText.TextWrapped = true
    infoText.Font = Enum.Font.SourceSans

    -- ========== ВКЛАДКА ESP ==========
    
    -- Кнопка ESP (серая)
    espButton = Instance.new("TextButton", espContainer)
    espButton.Size = UDim2.new(0.9, 0, 0, 35)
    espButton.Position = UDim2.new(0.05, 0, 0.05, 0)
    espButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    espButton.Text = "ESP: OFF"
    espButton.TextColor3 = Color3.new(1, 1, 1)
    espButton.TextScaled = true
    espButton.BorderSizePixel = 0

    -- ========== ВКЛАДКА AIMBOT ==========
    
    -- Кнопка Aimbot (серая)
    aimbotButton = Instance.new("TextButton", aimbotContainer)
    aimbotButton.Name = "AimbotButton"
    aimbotButton.Size = UDim2.new(0.9, 0, 0, 35)
    aimbotButton.Position = UDim2.new(0.05, 0, 0.05, 0)
    aimbotButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    aimbotButton.Text = "Aimbot: OFF"
    aimbotButton.TextColor3 = Color3.new(1, 1, 1)
    aimbotButton.TextScaled = true
    aimbotButton.BorderSizePixel = 0

    -- Выпадающий список для выбора цели
    targetDropdown = Instance.new("TextButton", aimbotContainer)
    targetDropdown.Name = "TargetDropdown"
    targetDropdown.Size = UDim2.new(0.9, 0, 0, 35)
    targetDropdown.Position = UDim2.new(0.05, 0, 0.20, 0)
    targetDropdown.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    targetDropdown.Text = "Target: Head"
    targetDropdown.TextColor3 = Color3.new(1, 1, 1)
    targetDropdown.TextScaled = true
    targetDropdown.BorderSizePixel = 0

    -- Контейнер для выпадающего списка
    dropdownContainer = Instance.new("Frame", aimbotContainer)
    dropdownContainer.Size = UDim2.new(0.9, 0, 0, 70)
    dropdownContainer.Position = UDim2.new(0.05, 0, 0.20, 35)
    dropdownContainer.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    dropdownContainer.BorderSizePixel = 1
    dropdownContainer.BorderColor3 = Color3.fromRGB(100, 100, 100)
    dropdownContainer.Visible = false

    -- Кнопка выбора Head
    headButton = Instance.new("TextButton", dropdownContainer)
    headButton.Size = UDim2.new(1, 0, 0, 35)
    headButton.Position = UDim2.new(0, 0, 0, 0)
    headButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    headButton.Text = "Head"
    headButton.TextColor3 = Color3.new(1, 1, 1)
    headButton.TextScaled = true
    headButton.BorderSizePixel = 0

    -- Кнопка выбора Body
    bodyButton = Instance.new("TextButton", dropdownContainer)
    bodyButton.Size = UDim2.new(1, 0, 0, 35)
    bodyButton.Position = UDim2.new(0, 0, 0, 35)
    bodyButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    bodyButton.Text = "Body"
    bodyButton.TextColor3 = Color3.new(1, 1, 1)
    bodyButton.TextScaled = true
    bodyButton.BorderSizePixel = 0

    -- FOV Slider для аимбота (исходная позиция)
    fovSliderFrame = Instance.new("Frame", aimbotContainer)
    fovSliderFrame.Size = UDim2.new(0.9, 0, 0, 60)
    fovSliderFrame.Position = UDim2.new(0.05, 0, 0.35, 0)
    fovSliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    fovSliderFrame.BorderSizePixel = 0

    fovLabel = Instance.new("TextLabel", fovSliderFrame)
    fovLabel.Size = UDim2.new(1, 0, 0.3, 0)
    fovLabel.Position = UDim2.new(0, 0, 0, 0)
    fovLabel.BackgroundTransparency = 1
    fovLabel.Text = "FOV Radius: " .. fovRadius
    fovLabel.TextColor3 = Color3.new(1, 1, 1)
    fovLabel.TextScaled = true
    fovLabel.Font = Enum.Font.SourceSans

    sliderBackground = Instance.new("TextButton", fovSliderFrame)
    sliderBackground.Size = UDim2.new(1, 0, 0.4, 0)
    sliderBackground.Position = UDim2.new(0, 0, 0.4, 0)
    sliderBackground.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    sliderBackground.BorderSizePixel = 0
    sliderBackground.Text = ""
    sliderBackground.AutoButtonColor = false

    local sliderFill = Instance.new("Frame", sliderBackground)
    sliderFill.Size = UDim2.new((fovRadius - 50) / 200, 0, 1, 0)
    sliderFill.Position = UDim2.new(0, 0, 0, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    sliderFill.BorderSizePixel = 0

    local sliderButton = Instance.new("Frame", sliderBackground)
    sliderButton.Size = UDim2.new(0, 15, 1.5, 0)
    sliderButton.Position = UDim2.new((fovRadius - 50) / 200, -7, -0.25, 0)
    sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderButton.BorderSizePixel = 1
    sliderButton.BorderColor3 = Color3.fromRGB(200, 200, 200)

    -- Кнопки + и - для FOV
    local minusButton = Instance.new("TextButton", fovSliderFrame)
    minusButton.Size = UDim2.new(0.2, 0, 0.3, 0)
    minusButton.Position = UDim2.new(0, 0, 0.8, 10) -- Сдвинуты на 10 пикселей вниз
    minusButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    minusButton.Text = "-"
    minusButton.TextColor3 = Color3.new(1, 1, 1)
    minusButton.TextScaled = true
    minusButton.BorderSizePixel = 0

    local plusButton = Instance.new("TextButton", fovSliderFrame)
    plusButton.Size = UDim2.new(0.2, 0, 0.3, 0)
    plusButton.Position = UDim2.new(0.8, 0, 0.8, 10) -- Сдвинуты на 10 пикселей вниз
    plusButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    plusButton.Text = "+"
    plusButton.TextColor3 = Color3.new(1, 1, 1)
    plusButton.TextScaled = true
    plusButton.BorderSizePixel = 0

    -- Distance Slider для аимбота (исходная позиция)
    distanceSliderFrame = Instance.new("Frame", aimbotContainer)
    distanceSliderFrame.Size = UDim2.new(0.9, 0, 0, 60)
    distanceSliderFrame.Position = UDim2.new(0.05, 0, 0.50, 0)
    distanceSliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    distanceSliderFrame.BorderSizePixel = 0

    distanceLabel = Instance.new("TextLabel", distanceSliderFrame)
    distanceLabel.Size = UDim2.new(1, 0, 0.3, 0)
    distanceLabel.Position = UDim2.new(0, 0, 0, 0)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.Text = "Aimbot Distance: " .. aimbotMaxDistance .. "m"
    distanceLabel.TextColor3 = Color3.new(1, 1, 1)
    distanceLabel.TextScaled = true
    distanceLabel.Font = Enum.Font.SourceSans

    distanceSliderBackground = Instance.new("TextButton", distanceSliderFrame)
    distanceSliderBackground.Size = UDim2.new(1, 0, 0.4, 0)
    distanceSliderBackground.Position = UDim2.new(0, 0, 0.4, 0)
    distanceSliderBackground.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    distanceSliderBackground.BorderSizePixel = 0
    distanceSliderBackground.Text = ""
    distanceSliderBackground.AutoButtonColor = false

    local distanceSliderFill = Instance.new("Frame", distanceSliderBackground)
    distanceSliderFill.Size = UDim2.new((aimbotMaxDistance - 10) / 190, 0, 1, 0)
    distanceSliderFill.Position = UDim2.new(0, 0, 0, 0)
    distanceSliderFill.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
    distanceSliderFill.BorderSizePixel = 0

    local distanceSliderButton = Instance.new("Frame", distanceSliderBackground)
    distanceSliderButton.Size = UDim2.new(0, 15, 1.5, 0)
    distanceSliderButton.Position = UDim2.new((aimbotMaxDistance - 10) / 190, -7, -0.25, 0)
    distanceSliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    distanceSliderButton.BorderSizePixel = 1
    distanceSliderButton.BorderColor3 = Color3.fromRGB(200, 200, 200)

    -- Кнопки + и - для Distance
    local distanceMinusButton = Instance.new("TextButton", distanceSliderFrame)
    distanceMinusButton.Size = UDim2.new(0.2, 0, 0.3, 0)
    distanceMinusButton.Position = UDim2.new(0, 0, 0.8, 10) -- Сдвинуты на 10 пикселей вниз
    distanceMinusButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    distanceMinusButton.Text = "-"
    distanceMinusButton.TextColor3 = Color3.new(1, 1, 1)
    distanceMinusButton.TextScaled = true
    distanceMinusButton.BorderSizePixel = 0

    local distancePlusButton = Instance.new("TextButton", distanceSliderFrame)
    distancePlusButton.Size = UDim2.new(0.2, 0, 0.3, 0)
    distancePlusButton.Position = UDim2.new(0.8, 0, 0.8, 10) -- Сдвинуты на 10 пикселей вниз
    distancePlusButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    distancePlusButton.Text = "+"
    distancePlusButton.TextColor3 = Color3.new(1, 1, 1)
    distancePlusButton.TextScaled = true
    distancePlusButton.BorderSizePixel = 0

    -- ========== ВКЛАДКА CAMERA ==========
    
    -- Кнопка Infinite Jump (самая первая)
    infiniteJumpButton = Instance.new("TextButton", cameraContainer)
    infiniteJumpButton.Name = "InfiniteJumpButton"
    infiniteJumpButton.Size = UDim2.new(0.9, 0, 0, 35)
    infiniteJumpButton.Position = UDim2.new(0.05, 0, 0.05, 0)
    infiniteJumpButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    infiniteJumpButton.Text = "Infinite Jump: OFF"
    infiniteJumpButton.TextColor3 = Color3.new(1, 1, 1)
    infiniteJumpButton.TextScaled = true
    infiniteJumpButton.BorderSizePixel = 0

    -- Кнопка Camera FOV (после Infinite Jump)
    cameraFOVButton = Instance.new("TextButton", cameraContainer)
    cameraFOVButton.Name = "CameraFOVButton"
    cameraFOVButton.Size = UDim2.new(0.9, 0, 0, 35)
    cameraFOVButton.Position = UDim2.new(0.05, 0, 0.20, 0)
    cameraFOVButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    cameraFOVButton.Text = "CamFOV: OFF"
    cameraFOVButton.TextColor3 = Color3.new(1, 1, 1)
    cameraFOVButton.TextScaled = true
    cameraFOVButton.BorderSizePixel = 0

    -- Camera FOV Slider (после кнопки CamFOV)
    cameraFOVSliderFrame = Instance.new("Frame", cameraContainer)
    cameraFOVSliderFrame.Size = UDim2.new(0.9, 0, 0, 60)
    cameraFOVSliderFrame.Position = UDim2.new(0.05, 0, 0.35, 0)
    cameraFOVSliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    cameraFOVSliderFrame.BorderSizePixel = 0

    cameraFOVLabel = Instance.new("TextLabel", cameraFOVSliderFrame)
    cameraFOVLabel.Size = UDim2.new(1, 0, 0.3, 0)
    cameraFOVLabel.Position = UDim2.new(0, 0, 0, 0)
    cameraFOVLabel.BackgroundTransparency = 1
    cameraFOVLabel.Text = "Camera FOV: " .. cameraFOV
    cameraFOVLabel.TextColor3 = Color3.new(1, 1, 1)
    cameraFOVLabel.TextScaled = true
    cameraFOVLabel.Font = Enum.Font.SourceSans

    cameraSliderBackground = Instance.new("TextButton", cameraFOVSliderFrame)
    cameraSliderBackground.Size = UDim2.new(1, 0, 0.4, 0)
    cameraSliderBackground.Position = UDim2.new(0, 0, 0.4, 0)
    cameraSliderBackground.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    cameraSliderBackground.BorderSizePixel = 0
    cameraSliderBackground.Text = ""
    cameraSliderBackground.AutoButtonColor = false

    local cameraSliderFill = Instance.new("Frame", cameraSliderBackground)
    cameraSliderFill.Size = UDim2.new((cameraFOV - 30) / 90, 0, 1, 0) -- Изменен диапазон на 30-120
    cameraSliderFill.Position = UDim2.new(0, 0, 0, 0)
    cameraSliderFill.BackgroundColor3 = Color3.fromRGB(170, 0, 255)
    cameraSliderFill.BorderSizePixel = 0

    local cameraSliderButton = Instance.new("Frame", cameraSliderBackground)
    cameraSliderButton.Size = UDim2.new(0, 15, 1.5, 0)
    cameraSliderButton.Position = UDim2.new((cameraFOV - 30) / 90, -7, -0.25, 0) -- Изменен диапазон на 30-120
    cameraSliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    cameraSliderButton.BorderSizePixel = 1
    cameraSliderButton.BorderColor3 = Color3.fromRGB(200, 200, 200)

    -- Кнопки + и - для Camera FOV
    local cameraMinusButton = Instance.new("TextButton", cameraFOVSliderFrame)
    cameraMinusButton.Size = UDim2.new(0.2, 0, 0.3, 0)
    cameraMinusButton.Position = UDim2.new(0, 0, 0.8, 10) -- Сдвинуты на 10 пикселей вниз
    cameraMinusButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    cameraMinusButton.Text = "-"
    cameraMinusButton.TextColor3 = Color3.new(1, 1, 1)
    cameraMinusButton.TextScaled = true
    cameraMinusButton.BorderSizePixel = 0

    local cameraPlusButton = Instance.new("TextButton", cameraFOVSliderFrame)
    cameraPlusButton.Size = UDim2.new(0.2, 0, 0.3, 0)
    cameraPlusButton.Position = UDim2.new(0.8, 0, 0.8, 10) -- Сдвинуты на 10 пикселей вниз
    cameraPlusButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    cameraPlusButton.Text = "+"
    cameraPlusButton.TextColor3 = Color3.new(1, 1, 1)
    cameraPlusButton.TextScaled = true
    cameraPlusButton.BorderSizePixel = 0

    -- ========== ВКЛАДКА LANGUAGE ==========
    
    -- Заголовок
    languageTitle = Instance.new("TextLabel", languageContainer)
    languageTitle.Name = "LanguageTitle"
    languageTitle.Size = UDim2.new(0.9, 0, 0, 30)
    languageTitle.Position = UDim2.new(0.05, 0, 0.05, 0)
    languageTitle.BackgroundTransparency = 1
    languageTitle.Text = "Select Language:"
    languageTitle.TextColor3 = Color3.new(1, 1, 1)
    languageTitle.TextScaled = true
    languageTitle.Font = Enum.Font.SourceSansBold

    -- Текущий язык
    currentLanguageLabel = Instance.new("TextLabel", languageContainer)
    currentLanguageLabel.Name = "CurrentLanguage"
    currentLanguageLabel.Size = UDim2.new(0.9, 0, 0, 25)
    currentLanguageLabel.Position = UDim2.new(0.05, 0, 0.15, 0)
    currentLanguageLabel.BackgroundTransparency = 1
    currentLanguageLabel.Text = "Current: English"
    currentLanguageLabel.TextColor3 = Color3.new(1, 1, 1)
    currentLanguageLabel.TextScaled = true
    currentLanguageLabel.Font = Enum.Font.SourceSans

    -- Выпадающий список для выбора языка
    languageDropdown = Instance.new("TextButton", languageContainer)
    languageDropdown.Name = "LanguageDropdown"
    languageDropdown.Size = UDim2.new(0.9, 0, 0, 35)
    languageDropdown.Position = UDim2.new(0.05, 0, 0.30, 0)
    languageDropdown.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    languageDropdown.Text = "Language: English"
    languageDropdown.TextColor3 = Color3.new(1, 1, 1)
    languageDropdown.TextScaled = true
    languageDropdown.BorderSizePixel = 0

    -- Контейнер для выпадающего списка языков
    languageDropdownContainer = Instance.new("Frame", languageContainer)
    languageDropdownContainer.Size = UDim2.new(0.9, 0, 0, 105)
    languageDropdownContainer.Position = UDim2.new(0.05, 0, 0.30, 35)
    languageDropdownContainer.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    languageDropdownContainer.BorderSizePixel = 1
    languageDropdownContainer.BorderColor3 = Color3.fromRGB(100, 100, 100)
    languageDropdownContainer.Visible = false

    -- Кнопка выбора English
    englishOption = Instance.new("TextButton", languageDropdownContainer)
    englishOption.Name = "EnglishOption"
    englishOption.Size = UDim2.new(1, 0, 0, 35)
    englishOption.Position = UDim2.new(0, 0, 0, 0)
    englishOption.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    englishOption.Text = "English"
    englishOption.TextColor3 = Color3.new(1, 1, 1)
    englishOption.TextScaled = true
    englishOption.BorderSizePixel = 0

    -- Кнопка выбора Russian
    russianOption = Instance.new("TextButton", languageDropdownContainer)
    russianOption.Name = "RussianOption"
    russianOption.Size = UDim2.new(1, 0, 0, 35)
    russianOption.Position = UDim2.new(0, 0, 0, 35)
    russianOption.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    russianOption.Text = "Russian"
    russianOption.TextColor3 = Color3.new(1, 1, 1)
    russianOption.TextScaled = true
    russianOption.BorderSizePixel = 0

    -- Кнопка выбора Chinese
    chineseOption = Instance.new("TextButton", languageDropdownContainer)
    chineseOption.Name = "ChineseOption"
    chineseOption.Size = UDim2.new(1, 0, 0, 35)
    chineseOption.Position = UDim2.new(0, 0, 0, 70)
    chineseOption.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    chineseOption.Text = "Chinese"
    chineseOption.TextColor3 = Color3.new(1, 1, 1)
    chineseOption.TextScaled = true
    chineseOption.BorderSizePixel = 0

    -- ========== ТЕМЫ В РАЗДЕЛЕ LANGUAGE ==========
    
    -- Заголовок для тем
    themeTitle = Instance.new("TextLabel", languageContainer)
    themeTitle.Name = "ThemeTitle"
    themeTitle.Size = UDim2.new(0.9, 0, 0, 30)
    themeTitle.Position = UDim2.new(0.05, 0, 0.45, 0)
    themeTitle.BackgroundTransparency = 1
    themeTitle.Text = "Select Theme:"
    themeTitle.TextColor3 = Color3.new(1, 1, 1)
    themeTitle.TextScaled = true
    themeTitle.Font = Enum.Font.SourceSansBold

    -- Текущая тема
    currentThemeLabel = Instance.new("TextLabel", languageContainer)
    currentThemeLabel.Name = "CurrentTheme"
    currentThemeLabel.Size = UDim2.new(0.9, 0, 0, 25)
    currentThemeLabel.Position = UDim2.new(0.05, 0, 0.65, 0)
    currentThemeLabel.BackgroundTransparency = 1
    currentThemeLabel.Text = "Current: Dark"
    currentThemeLabel.TextColor3 = Color3.new(1, 1, 1)
    currentThemeLabel.TextScaled = true
    currentThemeLabel.Font = Enum.Font.SourceSans

    -- Выпадающий список для выбора темы
    themeDropdown = Instance.new("TextButton", languageContainer)
    themeDropdown.Name = "ThemeDropdown"
    themeDropdown.Size = UDim2.new(0.9, 0, 0, 35)
    themeDropdown.Position = UDim2.new(0.05, 0, 0.60, 0)
    themeDropdown.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    themeDropdown.Text = "Theme: Dark"
    themeDropdown.TextColor3 = Color3.new(1, 1, 1)
    themeDropdown.TextScaled = true
    themeDropdown.BorderSizePixel = 0

    -- Контейнер для выпадающего списка тем
    themeDropdownContainer = Instance.new("Frame", languageContainer)
    themeDropdownContainer.Size = UDim2.new(0.9, 0, 0, 105)
    themeDropdownContainer.Position = UDim2.new(0.05, 0, 0.75, 35)
    themeDropdownContainer.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    themeDropdownContainer.BorderSizePixel = 1
    themeDropdownContainer.BorderColor3 = Color3.fromRGB(100, 100, 100)
    themeDropdownContainer.Visible = false

    -- Кнопка выбора Black темы
    blackThemeOption = Instance.new("TextButton", themeDropdownContainer)
    blackThemeOption.Name = "BlackThemeOption"
    blackThemeOption.Size = UDim2.new(1, 0, 0, 35)
    blackThemeOption.Position = UDim2.new(0, 0, 0, 0)
    blackThemeOption.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    blackThemeOption.Text = "Black"
    blackThemeOption.TextColor3 = Color3.new(1, 1, 1)
    blackThemeOption.TextScaled = true
    blackThemeOption.BorderSizePixel = 0

    -- Кнопка выбора Dark темы
    darkThemeOption = Instance.new("TextButton", themeDropdownContainer)
    darkThemeOption.Name = "DarkThemeOption"
    darkThemeOption.Size = UDim2.new(1, 0, 0, 35)
    darkThemeOption.Position = UDim2.new(0, 0, 0, 35)
    darkThemeOption.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    darkThemeOption.Text = "Dark"
    darkThemeOption.TextColor3 = Color3.new(1, 1, 1)
    darkThemeOption.TextScaled = true
    darkThemeOption.BorderSizePixel = 0

    -- Кнопка выбора White темы
    whiteThemeOption = Instance.new("TextButton", themeDropdownContainer)
    whiteThemeOption.Name = "WhiteThemeOption"
    whiteThemeOption.Size = UDim2.new(1, 0, 0, 35)
    whiteThemeOption.Position = UDim2.new(0, 0, 0, 70)
    whiteThemeOption.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    whiteThemeOption.Text = "White"
    whiteThemeOption.TextColor3 = Color3.new(1, 1, 1)
    whiteThemeOption.TextScaled = true
    whiteThemeOption.BorderSizePixel = 0

    -- Кнопка Hide/Show GUI (перемещаемая)
    hideButton = Instance.new("TextButton", gui)
    hideButton.Size = UDim2.new(0, 150, 0, 40)
    hideButton.Position = UDim2.new(0.5, -75, 1, -50)
    hideButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    hideButton.Text = "Hide GUI"
    hideButton.TextColor3 = Color3.new(1, 1, 1)
    hideButton.TextScaled = true
    hideButton.BorderSizePixel = 0
    hideButton.ZIndex = 10

    -- Функция обновления FOV
    local function updateFOV(value)
        fovRadius = math.floor(math.clamp(value, 50, 250))
        circle.Radius = fovRadius
        fovLabel.Text = translations[currentLanguage].fovLabel .. fovRadius
        
        local fillSize = (fovRadius - 50) / 200
        sliderFill.Size = UDim2.new(fillSize, 0, 1, 0)
        sliderButton.Position = UDim2.new(fillSize, -7, -0.25, 0)
    end

    -- Функция обновления Camera FOV
    local function updateCameraFOV(value)
        cameraFOV = math.floor(math.clamp(value, 30, 120)) -- Максимум 120
        cameraFOVLabel.Text = translations[currentLanguage].cameraFOVLabel .. cameraFOV
        
        local fillSize = (cameraFOV - 30) / 90 -- Изменен диапазон на 30-120
        cameraSliderFill.Size = UDim2.new(fillSize, 0, 1, 0)
        cameraSliderButton.Position = UDim2.new(fillSize, -7, -0.25, 0)
        
        if customCameraFOVEnabled then
            camera.FieldOfView = cameraFOV
        end
    end

    -- Функция обновления дистанции аимбота
    local function updateAimbotDistance(value)
        aimbotMaxDistance = math.floor(math.clamp(value, 10, 200))
        distanceLabel.Text = translations[currentLanguage].distanceLabel .. aimbotMaxDistance .. "m"
        
        local fillSize = (aimbotMaxDistance - 10) / 190
        distanceSliderFill.Size = UDim2.new(fillSize, 0, 1, 0)
        distanceSliderButton.Position = UDim2.new(fillSize, -7, -0.25, 0)
    end

    -- Функция для выбора цели через выпадающий список
    local function selectTarget(target)
        local t = translations[currentLanguage]
        if target == "Head" then
            aimbotTarget = "Head"
            targetDropdown.Text = t.targetDropdown:gsub("Head", t.targetHead)
            headButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            bodyButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        else
            aimbotTarget = "HumanoidRootPart"
            targetDropdown.Text = t.targetDropdown:gsub("Body", t.targetBody)
            headButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            bodyButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        end
        dropdownContainer.Visible = false
        -- Возвращаем слайдеры в исходное положение при закрытии меню
        fovSliderFrame.Position = UDim2.new(0.05, 0, 0.35, 0)
        distanceSliderFrame.Position = UDim2.new(0.05, 0, 0.50, 0)
    end

    -- Функция для выбора языка
    local function selectLanguage(lang)
        currentLanguage = lang
        updateLanguage()
        
        -- Обновляем цвета кнопок в выпадающем списке
        englishOption.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        russianOption.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        chineseOption.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        
        if lang == "English" then
            englishOption.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        elseif lang == "Russian" then
            russianOption.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        elseif lang == "Chinese" then
            chineseOption.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        end
        
        languageDropdownContainer.Visible = false
    end

    -- Функция для выбора темы
    local function selectTheme(theme)
        currentTheme = theme
        updateTheme()
        
        -- Обновляем цвета кнопок в выпадающем списке
        blackThemeOption.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        darkThemeOption.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        whiteThemeOption.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        
        if theme == "Black" then
            blackThemeOption.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        elseif theme == "Dark" then
            darkThemeOption.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        elseif theme == "White" then
            whiteThemeOption.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        end
        
        themeDropdownContainer.Visible = false
        updateLanguage() -- Обновляем тексты для отображения текущей темы
    end

    -- Функция для открытия/закрытия выпадающего списка цели
    local function toggleTargetDropdown()
        local isOpening = not dropdownContainer.Visible
        dropdownContainer.Visible = isOpening
        
        if isOpening then
            -- Сдвигаем слайдеры вниз на 5 см при открытии меню
            fovSliderFrame.Position = UDim2.new(0.05, 0, 0.60, 0)  -- +0.25 от исходного
            distanceSliderFrame.Position = UDim2.new(0.05, 0, 0.75, 0)  -- +0.25 от исходного
        else
            -- Возвращаем слайдеры в исходное положение при закрытии меню
            fovSliderFrame.Position = UDim2.new(0.05, 0, 0.35, 0)
            distanceSliderFrame.Position = UDim2.new(0.05, 0, 0.50, 0)
        end
    end

    -- Функция для открытия/закрытия выпадающего списка языка
    local function toggleLanguageDropdown()
        languageDropdownContainer.Visible = not languageDropdownContainer.Visible
    end

    -- Функция для открытия/закрытия выпадающего списка темы
    local function toggleThemeDropdown()
        themeDropdownContainer.Visible = not themeDropdownContainer.Visible
    end

    -- Обработка для слайдеров
    local isFOVSliding = false
    local isCameraSliding = false
    local isDistanceSliding = false

    local function updateSliderFromTouch(touchPosition, sliderType)
        local sliderAbsPos, sliderAbsSize
        
        if sliderType == "fov" then
            sliderAbsPos = sliderBackground.AbsolutePosition
            sliderAbsSize = sliderBackground.AbsoluteSize
        elseif sliderType == "camera" then
            sliderAbsPos = cameraSliderBackground.AbsolutePosition
            sliderAbsSize = cameraSliderBackground.AbsoluteSize
        elseif sliderType == "distance" then
            sliderAbsPos = distanceSliderBackground.AbsolutePosition
            sliderAbsSize = distanceSliderBackground.AbsoluteSize
        end
        
        local touchX = touchPosition.X
        local relativeX = (touchX - sliderAbsPos.X) / sliderAbsSize.X
        relativeX = math.clamp(relativeX, 0, 1)
        
        if sliderType == "fov" then
            local newFOV = 50 + (relativeX * 200)
            updateFOV(newFOV)
        elseif sliderType == "camera" then
            local newCameraFOV = 30 + (relativeX * 90) -- Изменен диапазон на 30-120
            updateCameraFOV(newCameraFOV)
        elseif sliderType == "distance" then
            local newDistance = 10 + (relativeX * 190)
            updateAimbotDistance(newDistance)
        end
    end

    -- Обработка для FOV слайдера
    sliderBackground.MouseButton1Down:Connect(function(x, y)
        isFOVSliding = true
        updateSliderFromTouch(Vector2.new(x, y), "fov")
    end)

    -- Обработка для Camera FOV слайдера
    cameraSliderBackground.MouseButton1Down:Connect(function(x, y)
        isCameraSliding = true
        updateSliderFromTouch(Vector2.new(x, y), "camera")
    end)

    -- Обработка для Distance слайдера
    distanceSliderBackground.MouseButton1Down:Connect(function(x, y)
        isDistanceSliding = true
        updateSliderFromTouch(Vector2.new(x, y), "distance")
    end)

    userInputService.InputChanged:Connect(function(input)
        if isFOVSliding and input.UserInputType == Enum.UserInputType.Touch then
            updateSliderFromTouch(input.Position, "fov")
        elseif isCameraSliding and input.UserInputType == Enum.UserInputType.Touch then
            updateSliderFromTouch(input.Position, "camera")
        elseif isDistanceSliding and input.UserInputType == Enum.UserInputType.Touch then
            updateSliderFromTouch(input.Position, "distance")
        end
    end)

    userInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            isFOVSliding = false
            isCameraSliding = false
            isDistanceSliding = false
        end
    end)

    -- Кнопки + и - для FOV
    minusButton.MouseButton1Click:Connect(function()
        updateFOV(fovRadius - 10)
    end)

    plusButton.MouseButton1Click:Connect(function()
        updateFOV(fovRadius + 10)
    end)

    -- Кнопки + и - для Camera FOV
    cameraMinusButton.MouseButton1Click:Connect(function()
        updateCameraFOV(cameraFOV - 10)
    end)

    cameraPlusButton.MouseButton1Click:Connect(function()
        updateCameraFOV(cameraFOV + 10)
    end)

    -- Кнопки + и - для Distance
    distanceMinusButton.MouseButton1Click:Connect(function()
        updateAimbotDistance(aimbotMaxDistance - 10)
    end)

    distancePlusButton.MouseButton1Click:Connect(function()
        updateAimbotDistance(aimbotMaxDistance + 10)
    end)

    -- Обработчики для выпадающего списка выбора цели
    targetDropdown.MouseButton1Click:Connect(function()
        toggleTargetDropdown()
    end)

    headButton.MouseButton1Click:Connect(function()
        selectTarget("Head")
    end)

    bodyButton.MouseButton1Click:Connect(function()
        selectTarget("Body")
    end)

    -- Обработчики для выпадающего списка выбора языка
    languageDropdown.MouseButton1Click:Connect(function()
        toggleLanguageDropdown()
    end)

    englishOption.MouseButton1Click:Connect(function()
        selectLanguage("English")
    end)

    russianOption.MouseButton1Click:Connect(function()
        selectLanguage("Russian")
    end)

    chineseOption.MouseButton1Click:Connect(function()
        selectLanguage("Chinese")
    end)

    -- Обработчики для выпадающего списка выбора темы
    themeDropdown.MouseButton1Click:Connect(function()
        toggleThemeDropdown()
    end)

    blackThemeOption.MouseButton1Click:Connect(function()
        selectTheme("Black")
    end)

    darkThemeOption.MouseButton1Click:Connect(function()
        selectTheme("Dark")
    end)

    whiteThemeOption.MouseButton1Click:Connect(function()
        selectTheme("White")
    end)

    -- Обработчики для кнопки закрытия
    closeButton.MouseButton1Click:Connect(function()
        confirmFrame.Visible = true
    end)

    yesButton.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)

    noButton.MouseButton1Click:Connect(function()
        confirmFrame.Visible = false
    end)

    -- Закрытие выпадающих списков при клике вне их
    userInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            -- Закрытие выпадающего списка цели
            if dropdownContainer.Visible then
                local mousePos = input.Position
                local dropdownAbsPos = dropdownContainer.AbsolutePosition
                local dropdownAbsSize = dropdownContainer.AbsoluteSize
                local targetDropdownAbsPos = targetDropdown.AbsolutePosition
                local targetDropdownAbsSize = targetDropdown.AbsoluteSize

                if not (mousePos.X >= dropdownAbsPos.X and mousePos.X <= dropdownAbsPos.X + dropdownAbsSize.X and
                       mousePos.Y >= dropdownAbsPos.Y and mousePos.Y <= dropdownAbsPos.Y + dropdownAbsSize.Y) and
                   not (mousePos.X >= targetDropdownAbsPos.X and mousePos.X <= targetDropdownAbsPos.X + targetDropdownAbsSize.X and
                       mousePos.Y >= targetDropdownAbsPos.Y and mousePos.Y <= targetDropdownAbsPos.Y + targetDropdownAbsSize.Y) then
                    dropdownContainer.Visible = false
                    -- Возвращаем слайдеры в исходное положение при закрытии меню
                    fovSliderFrame.Position = UDim2.new(0.05, 0, 0.35, 0)
                    distanceSliderFrame.Position = UDim2.new(0.05, 0, 0.50, 0)
                end
            end
            
            -- Закрытие выпадающего списка языка
            if languageDropdownContainer.Visible then
                local mousePos = input.Position
                local dropdownAbsPos = languageDropdownContainer.AbsolutePosition
                local dropdownAbsSize = languageDropdownContainer.AbsoluteSize
                local languageDropdownAbsPos = languageDropdown.AbsolutePosition
                local languageDropdownAbsSize = languageDropdown.AbsoluteSize

                if not (mousePos.X >= dropdownAbsPos.X and mousePos.X <= dropdownAbsPos.X + dropdownAbsSize.X and
                       mousePos.Y >= dropdownAbsPos.Y and mousePos.Y <= dropdownAbsPos.Y + dropdownAbsSize.Y) and
                   not (mousePos.X >= languageDropdownAbsPos.X and mousePos.X <= languageDropdownAbsPos.X + languageDropdownAbsSize.X and
                       mousePos.Y >= languageDropdownAbsPos.Y and mousePos.Y <= languageDropdownAbsPos.Y + languageDropdownAbsSize.Y) then
                    languageDropdownContainer.Visible = false
                end
            end
            
            -- Закрытие выпадающего списка темы
            if themeDropdownContainer.Visible then
                local mousePos = input.Position
                local dropdownAbsPos = themeDropdownContainer.AbsolutePosition
                local dropdownAbsSize = themeDropdownContainer.AbsoluteSize
                local themeDropdownAbsPos = themeDropdown.AbsolutePosition
                local themeDropdownAbsSize = themeDropdown.AbsoluteSize

                if not (mousePos.X >= dropdownAbsPos.X and mousePos.X <= dropdownAbsPos.X + dropdownAbsSize.X and
                       mousePos.Y >= dropdownAbsPos.Y and mousePos.Y <= dropdownAbsPos.Y + dropdownAbsSize.Y) and
                   not (mousePos.X >= themeDropdownAbsPos.X and mousePos.X <= themeDropdownAbsPos.X + themeDropdownAbsSize.X and
                       mousePos.Y >= themeDropdownAbsPos.Y and mousePos.Y <= themeDropdownAbsPos.Y + themeDropdownAbsSize.Y) then
                    themeDropdownContainer.Visible = false
                end
            end
        end
    end)

    -- Функция переключения вкладок
    local function switchTab(tabName)
        activeTab = tabName
        
        -- Скрыть все контейнеры
        infoContainer.Visible = false
        espContainer.Visible = false
        aimbotContainer.Visible = false
        cameraContainer.Visible = false
        languageContainer.Visible = false
        
        -- Сбросить цвета всех вкладок
        infoTabButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        espTabButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        aimbotTabButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        cameraTabButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        languageTabButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        
        -- Показать выбранный контейнер и выделить вкладку
        if tabName == "Info" then
            infoContainer.Visible = true
            infoTabButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        elseif tabName == "ESP" then
            espContainer.Visible = true
            espTabButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        elseif tabName == "AimBot" then
            aimbotContainer.Visible = true
            aimbotTabButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        elseif tabName == "Camera" then
            cameraContainer.Visible = true
            cameraTabButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        elseif tabName == "Language" then
            languageContainer.Visible = true
            languageTabButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        end
        
        -- Скрыть выпадающие списки при переключении вкладок и вернуть слайдеры в исходное положение
        dropdownContainer.Visible = false
        languageDropdownContainer.Visible = false
        themeDropdownContainer.Visible = false
        fovSliderFrame.Position = UDim2.new(0.05, 0, 0.35, 0)
        distanceSliderFrame.Position = UDim2.new(0.05, 0, 0.50, 0)
    end

    -- ОБРАБОТЧИКИ КНОПОК ВКЛАДОК
    infoTabButton.MouseButton1Click:Connect(function()
        switchTab("Info")
    end)

    espTabButton.MouseButton1Click:Connect(function()
        switchTab("ESP")
    end)

    aimbotTabButton.MouseButton1Click:Connect(function()
        switchTab("AimBot")
    end)

    cameraTabButton.MouseButton1Click:Connect(function()
        switchTab("Camera")
    end)

    languageTabButton.MouseButton1Click:Connect(function()
        switchTab("Language")
    end)

    -- ОБРАБОТЧИКИ ОСНОВНЫХ КНОПОК
    hideButton.MouseButton1Click:Connect(function()
        guiVisible = not guiVisible
        frame.Visible = guiVisible
        hideButton.Text = guiVisible and translations[currentLanguage].hideGUI or translations[currentLanguage].showGUI
    end)

    -- Добавляем функционал перемещения для кнопки Hide/Show GUI
    local isHideButtonDragging = false
    local hideButtonDragStart = nil
    local hideButtonStartPos = nil

    hideButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            isHideButtonDragging = true
            hideButtonDragStart = input.Position
            hideButtonStartPos = hideButton.Position
        end
    end)

    hideButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            isHideButtonDragging = false
        end
    end)

    userInputService.InputChanged:Connect(function(input)
        if isHideButtonDragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local delta = input.Position - hideButtonDragStart
            hideButton.Position = UDim2.new(
                hideButtonStartPos.X.Scale, 
                hideButtonStartPos.X.Offset + delta.X,
                hideButtonStartPos.Y.Scale, 
                hideButtonStartPos.Y.Offset + delta.Y
            )
        end
    end)

    -- Добавляем функционал перемещения для основного меню
    local isFrameDragging = false
    local frameDragStart = nil
    local frameStartPos = nil

    title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            isFrameDragging = true
            frameDragStart = input.Position
            frameStartPos = frame.Position
        end
    end)

    title.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            isFrameDragging = false
        end
    end)

    userInputService.InputChanged:Connect(function(input)
        if isFrameDragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local delta = input.Position - frameDragStart
            frame.Position = UDim2.new(
                frameStartPos.X.Scale, 
                frameStartPos.X.Offset + delta.X,
                frameStartPos.Y.Scale, 
                frameStartPos.Y.Offset + delta.Y
            )
        end
    end)

    -- Обработчик для кнопки Infinite Jump (первая в списке)
    infiniteJumpButton.MouseButton1Click:Connect(function()
        infiniteJumpEnabled = not infiniteJumpEnabled
        if infiniteJumpEnabled then
            infiniteJumpButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            infiniteJumpButton.Text = translations[currentLanguage].infiniteJumpOn
        else
            infiniteJumpButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            infiniteJumpButton.Text = translations[currentLanguage].infiniteJumpButton
        end
    end)

    -- Обработчик для кнопки Camera FOV (вторая в списке)
    cameraFOVButton.MouseButton1Click:Connect(function()
        customCameraFOVEnabled = not customCameraFOVEnabled
        if customCameraFOVEnabled then
            cameraFOVButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            cameraFOVButton.Text = translations[currentLanguage].cameraFOVOn
            camera.FieldOfView = cameraFOV
        else
            cameraFOVButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            cameraFOVButton.Text = translations[currentLanguage].cameraFOVButton
            camera.FieldOfView = 70
        end
    end)

    aimbotButton.MouseButton1Click:Connect(function()
        aimbotEnabled = not aimbotEnabled
        if aimbotEnabled then
            aimbotButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            aimbotButton.Text = translations[currentLanguage].aimbotOn
        else
            aimbotButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            aimbotButton.Text = translations[currentLanguage].aimbotButton
        end
    end)

    espButton.MouseButton1Click:Connect(function()
        espEnabled = not espEnabled
        if espEnabled then
            espButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            espButton.Text = translations[currentLanguage].espOn
        else
            espButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            espButton.Text = translations[currentLanguage].espButton
            for _, drawings in pairs(espObjects) do
                if drawings then
                    drawings.box.Visible = false
                    drawings.name.Visible = false
                    drawings.distance.Visible = false
                    drawings.tracer.Visible = false
                end
            end
        end
    end)

    -- Инициализация вкладок
    switchTab("Info")
    
    -- Инициализация выпадающих списков
    selectTarget("Head")
    selectLanguage("English")
    selectTheme("Dark")
    
    -- Инициализация языка и темы
    updateLanguage()
    updateTheme()
end

-- Основной код
createGUI()
showNotification()

player.CharacterAdded:Connect(function()
    task.wait(1)
    if not player:WaitForChild("PlayerGui"):FindFirstChild(guiName) then
        createGUI()
    end
end)

runService.RenderStepped:Connect(function()
    circle.Position = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)

    if aimbotEnabled then
        local target = getClosestPlayer()
        if target and target.Character then
            local targetPart = target.Character:FindFirstChild(aimbotTarget)
            if not targetPart then
                targetPart = target.Character:FindFirstChild("Head")
            end
            
            if targetPart then
                local targetPos = targetPart.Position
                camera.CFrame = CFrame.new(camera.CFrame.Position, targetPos)
            end
        end
    end

    for _, p in pairs(players:GetPlayers()) do
        if p ~= player then
            if not espObjects[p] then
                createESPForPlayer(p)
            end

            local drawings = espObjects[p]
            local char = p.Character
            if espEnabled and char and char:FindFirstChild("Head") and char:FindFirstChild("HumanoidRootPart") then
                if teamCheckEnabled and p.Team == player.Team then
                    if drawings then
                        drawings.box.Visible = false
                        drawings.name.Visible = false
                        drawings.distance.Visible = false
                        drawings.tracer.Visible = false
                    end
                    continue
                end

                local head = char.Head
                local hrp = char.HumanoidRootPart
                local headPos2D, onScreen1 = camera:WorldToViewportPoint(head.Position)
                local rootPos2D, onScreen2 = camera:WorldToViewportPoint(hrp.Position)

                if onScreen1 and onScreen2 and drawings then
                    local height = (headPos2D - rootPos2D).Magnitude * 2
                    local width = height / 2

                    drawings.box.Size = Vector2.new(width, height)
                    drawings.box.Position = Vector2.new(rootPos2D.X - width/2, rootPos2D.Y - height/2)
                    drawings.box.Visible = true

                    drawings.name.Text = p.Name
                    drawings.name.Position = Vector2.new(headPos2D.X, headPos2D.Y - 20)
                    drawings.name.Visible = true

                    local distance = math.floor((player.Character.HumanoidRootPart.Position - hrp.Position).Magnitude)
                    drawings.distance.Text = tostring(distance) .. "m"
                    drawings.distance.Position = Vector2.new(rootPos2D.X, rootPos2D.Y + height/2 + 5)
                    drawings.distance.Visible = true

                    drawings.tracer.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                    drawings.tracer.To = Vector2.new(rootPos2D.X, rootPos2D.Y)
                    drawings.tracer.Visible = true
                elseif drawings then
                    drawings.box.Visible = false
                    drawings.name.Visible = false
                    drawings.distance.Visible = false
                    drawings.tracer.Visible = false
                end
            elseif drawings then
                drawings.box.Visible = false
                drawings.name.Visible = false
                drawings.distance.Visible = false
                drawings.tracer.Visible = false
            end
        end
    end
end)