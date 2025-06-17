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
    HighJumpEnabled = false,
    JumpPower = 100, -- Высота прыжка
    ClumsyEnabled = false, -- Состояние Clumsy
    GUIEnabled = false, -- Состояние GUI
    NoclipEnabled = false, -- Noclip
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

-- Создание круга FOV (оставлен для совместимости, но не используется)
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Radius = 100
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

-- Noclip
local function UpdateNoclip()
    local character = LocalPlayer.Character
    if character and Settings.NoclipEnabled then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
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

-- Добавленная функция с SessionID и телепортацией
local Keybind = "F"
local SessionID = string.gsub(tostring(math.random()):sub(3), "%d", function(c)
    return string.char(96 + math.random(1, 26))
end)
print(' | Running BigPaintball2.lua made by Astro with keybind ' .. Keybind .. '! [SessionID ' .. SessionID .. ']')

local Enabled = true -- Постоянно включено после запуска
local function safeExecute(func)
    local success, errorMessage = pcall(func)
    if not success then
        warn(' | Error occurred: ' .. errorMessage .. ' [SessionID ' .. SessionID .. ']')
    end
end

local function teleportEntities(cframe, team)
    local spawnPosition = cframe * CFrame.new(0, 0, -15)

    for _, entity in ipairs(Workspace.__THINGS.__ENTITIES:GetChildren()) do
        if entity:FindFirstChild("HumanoidRootPart") then
            local humanoidRootPart = entity.HumanoidRootPart
            humanoidRootPart.CanCollide = false
            humanoidRootPart.Anchored = true
            humanoidRootPart.CFrame = spawnPosition
        elseif entity:FindFirstChild("Hitbox") then
            local directory = entity:GetAttribute("Directory")
            if not (directory == "White" and entity:GetAttribute("OwnerUID") == LocalPlayer.UserId) and
               (not team or directory ~= team.Name) then
                entity.Hitbox.CanCollide = false
                entity.Hitbox.Anchored = true
                entity.Hitbox.CFrame = spawnPosition * CFrame.new(math.random(-5, 5), 0, math.random(-5, 5))
            end
        end
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if not team or team.Name ~= player.Team.Name then
                if not player.Character:FindFirstChild("ForceField") then
                    local humanoidRootPart = player.Character.HumanoidRootPart
                    humanoidRootPart.CanCollide = false
                    humanoidRootPart.Anchored = true
                    humanoidRootPart.CFrame = spawnPosition * CFrame.new(math.random(-5, 5), 0, math.random(-5, 5))
                end
            end
        end
    end
end

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

    -- Toggle для Noclip
    Section:NewToggle("Noclip", "Walk through walls", function(state)
        Settings.NoclipEnabled = state
        UpdateNoclip()
    end)

    -- Toggle для Clumsy
    Section:NewToggle("Clumsy", "Toggle lag effect", function(state)
        ToggleClumsy(state)
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
    UpdateNoclip()

    -- Выполнение функции телепортации
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        safeExecute(function()
            local cframe = LocalPlayer.Character.HumanoidRootPart.CFrame
            local team = LocalPlayer.Team
            teleportEntities(cframe, team)
        end)
    end
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
