-- Загружаем Kavo UI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Предупреждение", "DarkTheme")

-- Создаем вкладку
local Tab = Window:NewTab("Сообщение")
local Section = Tab:NewSection("")

-- Показываем сообщение
Section:NewLabel("сосни")

-- Можно добавить черный фон в игру:
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(1, 0, 1, 0)
Frame.BackgroundColor3 = Color3.new(0, 0, 0)
Frame.BackgroundTransparency = 0

-- Добавим текст
local TextLabel = Instance.new("TextLabel", Frame)
TextLabel.Text = "Пожалуйста, сосни мне"
TextLabel.TextColor3 = Color3.new(1, 1, 1)
TextLabel.TextScaled = true
TextLabel.Size = UDim2.new(1, 0, 1, 0)
TextLabel.BackgroundTransparency = 1
