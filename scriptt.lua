-- Загружаем Kavo UI Library
local Kavo = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = nil -- Инициализируем Window как nil до ввода пароля

-- Сервисы
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = game.Workspace.CurrentCamera
local Workspace = game:GetService("Workspace")
local GuiService = game:GetService("GuiService")

-- Таблица для хранения состояний
local Settings = {
    ESPEnabled = false,
    SpeedEnabled = false,
    SpeedValue = 50, -- Скорость по умолчанию
    ThirdPersonEnabled = false,
    ThirdPersonDistance = 10, -- Расстояние камеры
    ThirdPersonAngle = 0, -- Угол наклона камеры
    FlyEnabled = false,
    FlySpeed = 50, -- Скорость полета
    AntiAimEnabled = false,
    AntiAimType = "Spin", -- Тип Anti-Aim: "Spin", "Static", "Jitter", "Random"
    AntiAimSpeed = 1, -- Скорость вращения (Spin)
    AntiAimAngle = 90, -- Угол смещения (Static)
    AntiAimAmplitude = 30, -- Амплитуда (Jitter)
    AntiAimFrequency = 0.1, -- Частота (Random)
    AntiAimDirection = 1, -- Направление: 1 (по часовой), -1 (против)
    AutoKillEnabled = false,
    AutoKillDistance = 3, -- Расстояние телепортации
    AutoKillMinHealth = 10, -- Минимальное здоровье противника
    AimbotEnabled = false,
    AimbotFOV = 100, -- Радиус FOV
    AimbotSmoothness = 0.1, -- Чувствительность
    AimbotHitPart = "Head", -- Часть тела
    AimbotShowFOV = false, -- Показ FOV
    TriggerbotEnabled = false,
    TriggerbotDelay = 0.1, -- Задержка выстрелов
    HighJumpEnabled = false,
    JumpPower = 100, -- Высота прыжка
    ClumsyEnabled = false, -- Состояние Clumsy
    GUIEnabled = false, -- Состояние GUI
    ESPSettings = {
        NameSize = 8, -- Размер текста неймтага
        NameColor = Color3.fromRGB(255, 255, 255), -- Цвет текста
        NameTransparency = 0, -- Прозрачность
        OutlineColor = Color3.fromRGB(0, 0, 0), -- Цвет обводки
        HighlightColor = Color3.fromRGB(255, 0, 0), -- Цвет подсветки
        HighlightTransparency = 0.5, -- Прозрачность подсветки
        NameOffset = 2 -- Высота неймтага
    }
}

-- Пароль
local Password = "kot"
local PasswordEntered = false

-- Окно ввода пароля
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 100)
Frame.Position = UDim2.new(0.5, -100, 0.5, -50)
Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Frame.Parent = ScreenGui
local TextBox = Instance.new("TextBox")
TextBox.Size = UDim2.new(0.8, 0, 0.3, 0)
TextBox.Position = UDim2.new(0.1, 0, 0.2, 0)
TextBox.PlaceholderText = "Enter password"
TextBox.Text = ""
TextBox.Parent = Frame
local Button = Instance.new("TextButton")
Button.Size = UDim2.new(0.8, 0, 0.3, 0)
Button.Position = UDim2.new(0.1, 0, 0.6, 0)
Button.Text = "Submit"
Button.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.Parent = Frame
local ErrorLabel = Instance.new("TextLabel")
ErrorLabel.Size = UDim2.new(0.8, 0, 0.2, 0)
ErrorLabel.Position = UDim2.new(0.1, 0, 0.05, 0)
ErrorLabel.Text = ""
ErrorLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
ErrorLabel.BackgroundTransparency = 1
ErrorLabel.Parent = Frame

-- Обработка ввода пароля
Button.MouseButton1Click:Connect(function()
    if TextBox.Text == Password then
        PasswordEntered = true
        ScreenGui:Destroy()
        Window = Kavo.CreateLib("Big Paintball 2 Cheat", "DarkTheme")
        Settings.GUIEnabled = true
        InitializeGUI()
    else
        ErrorLabel.Text = "Incorrect password!"
    end
end)

-- Создание круга FOV
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Radius = Settings.AimbotFOV
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Thickness = 1
FOVCircle.Filled = false
FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

-- Функция для создания ESP
local function CreateESP(player)
    if player == LocalPlayer or not player.Character then return end

    local character = player.Character
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")

    if not humanoid or not rootPart then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP"
    billboard.Size = UDim2.new(0, 100, 0, 20)
    billboard.StudsOffset = Vector3.new(0, Settings.ESPSettings.NameOffset, 0)
    billboard.AlwaysOnTop = true
    billboard.Adornee = rootPart
    billboard.Parent = character

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Settings.ESPSettings.NameColor
    nameLabel.TextTransparency = Settings.ESPSettings.NameTransparency
    nameLabel.TextStrokeColor3 = Settings.ESPSettings.OutlineColor
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextSize = Settings.ESPSettings.NameSize
    nameLabel.Font = Enum.Font.Gotham
    nameLabel.Parent = billboard

    local highlight = Instance.new("Highlight")
    highlight.Name = "ESPHighlight"
    highlight.FillColor = Settings.ESPSettings.HighlightColor
    highlight.FillTransparency = Settings.ESPSettings.HighlightTransparency
    highlight.OutlineColor = Settings.ESPSettings.OutlineColor
    highlight.Adornee = character
    highlight.Parent = character
end

-- Обновление ESP
local function UpdateESP()
    if not Settings.ESPEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character then
                local esp = player.Character:FindFirstChild("ESP")
                local highlight = player.Character:FindFirstChild("ESPHighlight")
                if esp then esp:Destroy() end
                if highlight then highlight:Destroy() end
            end
        end
        return
    end

    for _, player in pairs(Players:GetPlayers()) do
        if player.Character and player ~= LocalPlayer then
            if not player.Character:FindFirstChild("ESP") then
                CreateESP(player)
            else
                local esp = player.Character:FindFirstChild("ESP")
                local highlight = player.Character:FindFirstChild("ESPHighlight")
                if esp and highlight then
                    local nameLabel = esp:FindFirstChildOfClass("TextLabel")
                    if nameLabel then
                        nameLabel.TextColor3 = Settings.ESPSettings.NameColor
                        nameLabel.TextTransparency = Settings.ESPSettings.NameTransparency
                        nameLabel.TextStrokeColor3 = Settings.ESPSettings.OutlineColor
                        nameLabel.TextSize = Settings.ESPSettings.NameSize
                    end
                    esp.StudsOffset = Vector3.new(0, Settings.ESPSettings.NameOffset, 0)
                    highlight.FillColor = Settings.ESPSettings.HighlightColor
                    highlight.FillTransparency = Settings.ESPSettings.HighlightTransparency
                    highlight.OutlineColor = Settings.ESPSettings.OutlineColor
                end
            end
        end
    end
end

-- Увеличение скорости
local function UpdateSpeed()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if Settings.SpeedEnabled then
            humanoid.WalkSpeed = Settings.SpeedValue
        else
            humanoid.WalkSpeed = 16
        end
    end
end

-- High Jump
local function UpdateHighJump()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if Settings.HighJumpEnabled then
            humanoid.JumpPower = Settings.JumpPower
        else
            humanoid.JumpPower = 50 -- Стандартная высота прыжка
        end
    end
end

-- Third Person
local function UpdateThirdPerson()
    if Settings.ThirdPersonEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        Camera.CameraType = Enum.CameraType.Scriptable
        local rootPart = LocalPlayer.Character.HumanoidRootPart
        local offset = Vector3.new(0, 2, Settings.ThirdPersonDistance)
        local rotatedOffset = CFrame.Angles(0, 0, math.rad(Settings.ThirdPersonAngle)) * CFrame.new(offset)
        local camPos = rootPart.Position + (rootPart.CFrame * rotatedOffset).Position
        Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(camPos, rootPart.Position), 0.1)
        if LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character.Humanoid.CameraOffset = Vector3.new(0, 0, 0)
        end
    else
        Camera.CameraType = Enum.CameraType.Custom
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character.Humanoid.CameraOffset = Vector3.new(0, 0, 0)
        end
    end
end

-- Fly Hack
local FlyBodyVelocity, FlyBodyGyro
local function UpdateFly()
    local character = LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    if not character or not rootPart or not humanoid then
        if FlyBodyVelocity then FlyBodyVelocity:Destroy() end
        if FlyBodyGyro then FlyBodyGyro:Destroy() end
        FlyBodyVelocity, FlyBodyGyro = nil, nil
        return
    end

    if Settings.FlyEnabled then
        humanoid.PlatformStand = true
        if not FlyBodyVelocity then
            FlyBodyVelocity = Instance.new("BodyVelocity")
            FlyBodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            FlyBodyVelocity.Parent = rootPart
        end
        if not FlyBodyGyro then
            FlyBodyGyro = Instance.new("BodyGyro")
            FlyBodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            FlyBodyGyro.Parent = rootPart
        end

        local moveDirection = Vector3.new(0, 0, 0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + Camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - Camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - Camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + Camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDirection = moveDirection + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            moveDirection = moveDirection - Vector3.new(0, 1, 0)
        end

        FlyBodyVelocity.Velocity = moveDirection * Settings.FlySpeed
        FlyBodyGyro.CFrame = Camera.CFrame
    else
        humanoid.PlatformStand = false
        if FlyBodyVelocity then FlyBodyVelocity:Destroy() end
        if FlyBodyGyro then FlyBodyGyro:Destroy() end
        FlyBodyVelocity, FlyBodyGyro = nil, nil
    end
end

-- Anti-Aim
local AntiAimAngle = 0
local LastAntiAimUpdate = 0
local function UpdateAntiAim()
    local character = LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    if not character or not rootPart or not humanoid or not Settings.AntiAimEnabled then return end

    local currentTime = tick()
    if Settings.AntiAimType == "Spin" then
        AntiAimAngle = AntiAimAngle + (Settings.AntiAimSpeed * Settings.AntiAimDirection)
        if AntiAimAngle >= 360 then AntiAimAngle = AntiAimAngle - 360 end
        rootPart.CFrame = CFrame.new(rootPart.Position) * CFrame.Angles(0, math.rad(AntiAimAngle), 0)
    elseif Settings.AntiAimType == "Static" then
        rootPart.CFrame = CFrame.new(rootPart.Position) * CFrame.Angles(0, math.rad(Settings.AntiAimAngle), 0)
    elseif Settings.AntiAimType == "Jitter" then
        AntiAimAngle = AntiAimAngle + (math.random(-Settings.AntiAimAmplitude, Settings.AntiAimAmplitude) * Settings.AntiAimDirection)
        rootPart.CFrame = CFrame.new(rootPart.Position) * CFrame.Angles(0, math.rad(AntiAimAngle), 0)
    elseif Settings.AntiAimType == "Random" and currentTime - LastAntiAimUpdate > Settings.AntiAimFrequency then
        AntiAimAngle = math.random(0, 360)
        rootPart.CFrame = CFrame.new(rootPart.Position) * CFrame.Angles(0, math.rad(AntiAimAngle), 0)
        LastAntiAimUpdate = currentTime
    end
end

-- AutoKill
local LastTeleportTime = 0
local function UpdateAutoKill()
    if not Settings.AutoKillEnabled then return end

    local character = LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if not character or not rootPart then
        warn("AutoKill: LocalPlayer character or rootPart not found")
        return
    end

    local currentTime = tick()
    if currentTime - LastTeleportTime < 0.5 then return end

    local closestPlayer, closestDistance = nil, math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and (not player.Team or player.Team ~= LocalPlayer.Team) then
            local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
            local targetHumanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if targetRoot and targetHumanoid and targetHumanoid.Health >= Settings.AutoKillMinHealth then
                local distance = (rootPart.Position - targetRoot.Position).Magnitude
                if distance < closestDistance then
                    closestPlayer = player
                    closestDistance = distance
                end
            end
        end
    end

    if closestPlayer and closestPlayer.Character then
        local targetRoot = closestPlayer.Character:FindFirstChild("HumanoidRootPart")
        if targetRoot then
            local backPosition = targetRoot.Position - (targetRoot.CFrame.LookVector * Settings.AutoKillDistance)
            local raycastParams = RaycastParams.new()
            raycastParams.FilterDescendantsInstances = {character, closestPlayer.Character}
            raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
            local raycastResult = Workspace:Raycast(rootPart.Position, backPosition - rootPart.Position, raycastParams)
            if not raycastResult then
                rootPart.CFrame = CFrame.new(backPosition + Vector3.new(0, 1, 0), targetRoot.Position)
                LastTeleportTime = currentTime
                print("AutoKill: Teleported behind " .. closestPlayer.Name)
            else
                warn("AutoKill: Obstacle detected, teleport canceled")
            end
        else
            warn("AutoKill: Target rootPart not found")
        end
    else
        warn("AutoKill: No valid target found")
    end
end

-- Aimbot
local function IsPlayerVisible(targetPart)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    local raycastResult = Workspace:Raycast(Camera.CFrame.Position, (targetPart.Position - Camera.CFrame.Position).Unit * 1000, raycastParams)
    return raycastResult and raycastResult.Instance:IsDescendantOf(targetPart.Parent)
end

local function GetClosestPlayerInFOV()
    local closestPlayer, closestDistance = nil, math.huge
    local mousePos = UserInputService:GetMouseLocation()

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and (not player.Team or player.Team ~= LocalPlayer.Team) then
            local targetHumanoid = player.Character:FindFirstChildOfClass("Humanoid")
            local targetPart = player.Character:FindFirstChild(Settings.AimbotHitPart)
            if targetHumanoid and targetPart and targetHumanoid.Health > 0 and IsPlayerVisible(targetPart) then
                local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                if onScreen then
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if distance < Settings.AimbotFOV and distance < closestDistance then
                        closestPlayer = player
                        closestDistance = distance
                    end
                end
            end
        end
    end

    return closestPlayer
end

local function UpdateAimbot()
    if not Settings.AimbotEnabled or not UserInputService:IsMouseButtonPressed(Enum.MouseButton.Left) then
        return
    end

    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end

    local closestPlayer = GetClosestPlayerInFOV()
    if closestPlayer and closestPlayer.Character then
        local targetPart = closestPlayer.Character:FindFirstChild(Settings.AimbotHitPart)
        if targetPart then
            local currentCFrame = Camera.CFrame
            local newCFrame = CFrame.new(currentCFrame.Position, targetPart.Position)
            Camera.CFrame = currentCFrame:Lerp(newCFrame, 1 - Settings.AimbotSmoothness)
            print("Aimbot: Targeting " .. closestPlayer.Name)
        end
    end
end

-- Обновление FOV круга
local function UpdateFOVCircle()
    FOVCircle.Visible = Settings.AimbotShowFOV
    FOVCircle.Radius = Settings.AimbotFOV
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
end

-- Triggerbot
local LastTriggerTime = 0
local function UpdateTriggerbot()
    if not Settings.TriggerbotEnabled then return end

    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end

    local currentTime = tick()
    if currentTime - LastTriggerTime < Settings.TriggerbotDelay then return end

    local mousePos = UserInputService:GetMouseLocation()
    local closestPlayer, closestDistance = nil, math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and (not player.Team or player.Team ~= LocalPlayer.Team) then
            local targetHumanoid = player.Character:FindFirstChildOfClass("Humanoid")
            local targetPart = player.Character:FindFirstChild(Settings.AimbotHitPart)
            if targetHumanoid and targetPart and targetHumanoid.Health > 0 and IsPlayerVisible(targetPart) then
                local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                if onScreen then
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if distance < 10 and distance < closestDistance then
                        closestPlayer = player
                        closestDistance = distance
                    end
                end
            end
        end
    end

    if closestPlayer and closestPlayer.Character then
        mouse1click()
        LastTriggerTime = currentTime
        print("Triggerbot: Fired at " .. closestPlayer.Name)
    end
end

-- Clumsy
local function ToggleClumsy(state)
    local character = LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if not character or not rootPart then return end

    Settings.ClumsyEnabled = state
    if Settings.ClumsyEnabled then
        rootPart:SetNetworkOwner(nil) -- Отключаем владение сервером
        rootPart.Anchored = true -- Замораживаем персонажа
        print("Clumsy: Enabled lag")
    else
        rootPart.Anchored = false
        rootPart:SetNetworkOwner(LocalPlayer) -- Возвращаем владение клиенту
        print("Clumsy: Disabled lag, teleported")
    end
end

-- Обработка биндов для Clumsy
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end
    if input.KeyCode == Enum.KeyCode.V then
        ToggleClumsy(true)
    elseif input.KeyCode == Enum.KeyCode.B then
        ToggleClumsy(false)
    end
end)

-- Функция для переключения GUI
local function ToggleGUI()
    if not PasswordEntered then return end
    Settings.GUIEnabled = not Settings.GUIEnabled
    if Window then
        game.CoreGui[Window.ScreenGui.Name].Enabled = Settings.GUIEnabled
    end
end

-- Обработка нажатия Right Shift
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        ToggleGUI()
    end
end)

-- Инициализация GUI после ввода пароля
function InitializeGUI()
    local Tab = Window:NewTab("Main")
    local Section = Tab:NewSection("Cheat Features")

    -- Toggle для ESP
    Section:NewToggle("ESP", "Shows players through walls", function(state)
        Settings.ESPEnabled = state
        UpdateESP()
    end)

    -- Настройка ESP
    local ESPSection = Tab:NewSection("ESP Settings")
    ESPSection:NewColorPicker("Name Color", "Set name tag color", Settings.ESPSettings.NameColor, function(color)
        Settings.ESPSettings.NameColor = color
        UpdateESP()
    end)
    ESPSection:NewSlider("Name Transparency", "Set name tag transparency", 100, 0, function(value)
        Settings.ESPSettings.NameTransparency = value / 100
        UpdateESP()
    end)
    ESPSection:NewSlider("Name Size", "Set name tag text size", 20, 6, function(value)
        Settings.ESPSettings.NameSize = value
        UpdateESP()
    end)
    ESPSection:NewSlider("Name Offset", "Set name tag height offset", 5, 1, function(value)
        Settings.ESPSettings.NameOffset = value
        UpdateESP()
    end)
    ESPSection:NewColorPicker("Highlight Color", "Set highlight color", Settings.ESPSettings.HighlightColor, function(color)
        Settings.ESPSettings.HighlightColor = color
        UpdateESP()
    end)
    ESPSection:NewSlider("Highlight Transparency", "Set highlight transparency", 100, 0, function(value)
        Settings.ESPSettings.HighlightTransparency = value / 100
        UpdateESP()
    end)
    ESPSection:NewColorPicker("Outline Color", "Set outline color", Settings.ESPSettings.OutlineColor, function(color)
        Settings.ESPSettings.OutlineColor = color
        UpdateESP()
    end)

    -- Toggle для скорости
    Section:NewToggle("Speed Hack", "Increases your speed", function(state)
        Settings.SpeedEnabled = state
        UpdateSpeed()
    end)
    Section:NewSlider("Speed Value", "Set speed value", 100, 16, function(value)
        Settings.SpeedValue = value
        UpdateSpeed()
    end)

    -- Toggle для High Jump
    Section:NewToggle("High Jump", "Increases jump height", function(state)
        Settings.HighJumpEnabled = state
        UpdateHighJump()
    end)
    Section:NewSlider("Jump Power", "Set jump power", 200, 50, function(value)
        Settings.JumpPower = value
        UpdateHighJump()
    end)

    -- Toggle для Third Person
    Section:NewToggle("Third Person", "Enables third person view", function(state)
        Settings.ThirdPersonEnabled = state
        UpdateThirdPerson()
    end)
    Section:NewSlider("Third Person Distance", "Set camera distance", 20, 5, function(value)
        Settings.ThirdPersonDistance = value
        UpdateThirdPerson()
    end)
    Section:NewSlider("Camera Angle", "Set camera tilt angle", 90, -90, function(value)
        Settings.ThirdPersonAngle = value
        UpdateThirdPerson()
    end)

    -- Toggle для Fly Hack
    Section:NewToggle("Fly Hack", "Enables flying", function(state)
        Settings.FlyEnabled = state
        UpdateFly()
    end)
    Section:NewSlider("Fly Speed", "Set fly speed", 200, 20, function(value)
        Settings.FlySpeed = value
        UpdateFly()
    end)

    -- Toggle для Anti-Aim
    Section:NewToggle("Anti-Aim", "Enables anti-aim", function(state)
        Settings.AntiAimEnabled = state
        UpdateAntiAim()
    end)

    -- Настройка Anti-Aim
    local AntiAimSection = Tab:NewSection("Anti-Aim Settings")
    AntiAimSection:NewDropdown("Anti-Aim Type", "Select anti-aim type", {"Spin", "Static", "Jitter", "Random"}, function(value)
        Settings.AntiAimType = value
        UpdateAntiAim()
    end)
    AntiAimSection:NewSlider("Spin Speed", "Set spin speed", 10, 1, function(value)
        Settings.AntiAimSpeed = value
        UpdateAntiAim()
    end)
    AntiAimSection:NewSlider("Static Angle", "Set static angle", 360, 0, function(value)
        Settings.AntiAimAngle = value
        UpdateAntiAim()
    end)
    AntiAimSection:NewSlider("Jitter Amplitude", "Set jitter amplitude", 90, 10, function(value)
        Settings.AntiAimAmplitude = value
        UpdateAntiAim()
    end)
    AntiAimSection:NewSlider("Random Frequency", "Set random update frequency", 100, 1, function(value)
        Settings.AntiAimFrequency = value / 100
        UpdateAntiAim()
    end)
    AntiAimSection:NewDropdown("Direction", "Select rotation direction", {"Clockwise", "Counter-Clockwise"}, function(value)
        Settings.AntiAimDirection = value == "Clockwise" and 1 or -1
        UpdateAntiAim()
    end)

    -- Toggle для AutoKill
    Section:NewToggle("AutoKill", "Teleports behind closest enemy", function(state)
        Settings.AutoKillEnabled = state
        UpdateAutoKill()
    end)
    local AutoKillSection = Tab:NewSection("AutoKill Settings")
    AutoKillSection:NewSlider("Teleport Distance", "Set teleport distance", 10, 1, function(value)
        Settings.AutoKillDistance = value
        UpdateAutoKill()
    end)
    AutoKillSection:NewSlider("Min Enemy Health", "Set minimum enemy health", 100, 0, function(value)
        Settings.AutoKillMinHealth = value
        UpdateAutoKill()
    end)

    -- Toggle для Aimbot
    Section:NewToggle("Aimbot", "Enables aimbot with team and visible check", function(state)
        Settings.AimbotEnabled = state
        UpdateAimbot()
    end)
    local AimbotSection = Tab:NewSection("Aimbot Settings")
    AimbotSection:NewToggle("Show FOV", "Show aimbot FOV circle", function(state)
        Settings.AimbotShowFOV = state
        UpdateFOVCircle()
    end)
    AimbotSection:NewSlider("FOV", "Set aimbot field of view", 500, 50, function(value)
        Settings.AimbotFOV = value
        UpdateFOVCircle()
        UpdateAimbot()
    end)
    AimbotSection:NewSlider("Smoothness", "Set aimbot smoothness (0-100)", 100, 0, function(value)
        Settings.AntiAimDirection = value == "Clockwise" and 1 or -1
        UpdateAntiAim()
    end)
    AntiAimSection:NewSlider("Spin Speed", "Set spin speed", 10, 1, function(value)
        Settings.AntiAimSpeed = value
        UpdateAntiAim()
    end)
    AntiAimSection:NewSlider("Static Angle", "Set static angle", 360, 0, function(value)
        Settings.AntiAimAngle = value
        UpdateAntiAim()
    end)
    AntiAimSection:NewSlider("Jitter Amplitude", "Set jitter amplitude", 90, 10, function(value)
        Settings.AntiAimAmplitude = value
        UpdateAntiAim()
    end)
    AntiAimSection:NewSlider("Random Frequency", "Set random update frequency", 100, 1, function(value)
        Settings.AntiAimFrequency = value / 100
        UpdateAntiAim()
    end)
    AntiAimSection:NewDropdown("Direction", "Select rotation direction", {"Clockwise", "Counter-Clockwise"}, function(value)
        Settings.AntiAimDirection = value == "Clockwise" and 1 or -1
        UpdateAntiAim()
    end)

    -- Toggle для AutoKill
    Section:NewToggle("AutoKill", "Teleports behind closest enemy", function(state)
        Settings.AutoKillEnabled = state
        UpdateAutoKill()
    end)

    -- Настройка AutoKill
    local AutoKillSection = Tab:NewSection("AutoKill Settings")
    AutoKillSection:NewSlider("Teleport Distance", "Set teleport distance", 10, 1, function(value)
        Settings.AutoKillDistance = value
        UpdateAutoKill()
    end)
    AutoKillSection:NewSlider("Min Enemy Health", "Set minimum enemy health", 100, 0, function(value)
        Settings.AutoKillMinHealth = value
        UpdateAutoKill()
    end)

    -- Toggle для Aimbot
    Section:NewToggle("Aimbot", "Enables aimbot with team and visible check", function(state)
        Settings.AimbotEnabled = state
        UpdateAimbot()
    end)

    -- Настройка Aimbot
    local AimbotSection = Tab:NewSection("Aimbot Settings")
    AimbotSection:NewToggle("Show FOV", "Show aimbot FOV circle", function(state)
        Settings.AimbotShowFOV = state
        UpdateFOVCircle()
    end)
    AimbotSection:NewSlider("FOV", "Set aimbot field of view", 500, 50, function(value)
        Settings.AimbotFOV = value
        UpdateFOVCircle()
        UpdateAimbot()
    end)
    AimbotSection:NewSlider("Smoothness", "Set aimbot smoothness (0-100)", 100, 0, function(value)
        Settings.AimbotSmoothness = value / 100
        UpdateAimbot()
    end)
    AimbotSection:NewDropdown("Hit Part", "Select target part", {"Head", "HumanoidRootPart"}, function(value)
        Settings.AimbotHitPart = value
        UpdateAimbot()
    end)

    -- Toggle для Triggerbot
    Section:NewToggle("Triggerbot", "Auto-shoot when aiming at enemy", function(state)
        Settings.TriggerbotEnabled = state
        UpdateTriggerbot()
    end)

    -- Настройка Triggerbot
    local TriggerbotSection = Tab:NewSection("Triggerbot Settings")
    TriggerbotSection:NewSlider("Shot Delay", "Set delay between shots (0-1)", 100, 0, function(value)
        Settings.TriggerbotDelay = value / 100
        UpdateTriggerbot()
    end)
end

-- Основной цикл обновления
RunService.RenderStepped:Connect(function()
    if not PasswordEntered then return end
    UpdateESP()
    UpdateSpeed()
    UpdateHighJump()
    UpdateThirdPerson()
    UpdateFly()
    UpdateAntiAim()
    UpdateAutoKill()
    UpdateAimbot()
    UpdateFOVCircle()
    UpdateTriggerbot()
end)

-- Обновление при добавлении/удалении игроков
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if Settings.ESPEnabled then
            CreateESP(player)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    if player.Character then
        local esp = player.Character:FindFirstChild("ESP")
        local highlight = player.Character:FindFirstChild("ESPHighlight")
        if esp then esp:Destroy() end
        if highlight then highlight:Destroy() end
    end
end)

-- Инициализация ESP для текущих игроков
for _, player in pairs(Players:GetPlayers()) do
    if player.Character then
        player.CharacterAdded:Connect(function()
            if Settings.ESPEnabled then
                CreateESP(player)
            end
        end)
    end
end

-- Очистка при отключении
game:BindToClose(function()
    FOVCircle:Remove()
end)
