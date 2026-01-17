-- Flick FPS WORKING SCRIPT
-- ESP + Aimbot + FOV + Menu
-- Автор: dachnic7384-bit

if not game:IsLoaded() then
    game.Loaded:Wait()
end

print("🔥 Flick FPS Script загружен")

-- Сервисы
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- НАСТРОЙКИ
local Settings = {
    ESP = true,
    Aimbot = true,
    FOV = true,
    FOV_Size = 150,
    AimKey = "Q",
    AimPart = "Head"
}

-- =========== ESP ===========
local function CreateESP(player)
    if player == LocalPlayer then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP"
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineTransparency = 0
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_Name"
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    
    local text = Instance.new("TextLabel")
    text.Parent = billboard
    text.BackgroundTransparency = 1
    text.Size = UDim2.new(1, 0, 1, 0)
    text.Text = player.Name
    text.TextColor3 = Color3.fromRGB(255, 255, 255)
    text.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    text.TextStrokeTransparency = 0
    text.TextSize = 16
    
    player.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        highlight.Adornee = char
        highlight.Parent = char
        billboard.Adornee = char:WaitForChild("Head")
        billboard.Parent = char.Head
    end)
    
    if player.Character then
        highlight.Adornee = player.Character
        highlight.Parent = player.Character
        if player.Character:FindFirstChild("Head") then
            billboard.Adornee = player.Character.Head
            billboard.Parent = player.Character.Head
        end
    end
end

-- Включаем ESP для всех игроков
for _, player in pairs(Players:GetPlayers()) do
    CreateESP(player)
end

Players.PlayerAdded:Connect(CreateESP)

-- =========== AIMBOT ===========
local function GetClosestPlayer()
    local closest = nil
    local closestDist = Settings.FOV_Size
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local target = player.Character:FindFirstChild(Settings.AimPart)
            if not target then
                target = player.Character:FindFirstChild("Head") or player.Character:FindFirstChild("HumanoidRootPart")
            end
            
            if target then
                local screenPos, onScreen = Camera:WorldToViewportPoint(target.Position)
                if onScreen then
                    local mousePos = Vector2.new(Mouse.X, Mouse.Y)
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    
                    if dist < closestDist then
                        closest = player
                        closestDist = dist
                    end
                end
            end
        end
    end
    
    return closest
end

-- =========== FOV CIRCLE ===========
local FOVCircle = Instance.new("ScreenGui")
FOVCircle.Name = "FOV_Circle"
FOVCircle.ResetOnSpawn = false
FOVCircle.Parent = game.CoreGui

local circle = Instance.new("Frame")
circle.Name = "Circle"
circle.AnchorPoint = Vector2.new(0.5, 0.5)
circle.Position = UDim2.new(0.5, 0, 0.5, 0)
circle.Size = UDim2.new(0, Settings.FOV_Size, 0, Settings.FOV_Size)
circle.BackgroundTransparency = 1
circle.Parent = FOVCircle

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1, 0)
corner.Parent = circle

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(255, 255, 255)
stroke.Thickness = 2
stroke.Transparency = 0.3
stroke.Parent = circle

-- =========== МЕНЮ ===========
local Menu = Instance.new("ScreenGui")
Menu.Name = "FlickFPS_Menu"
Menu.ResetOnSpawn = false
Menu.Parent = game.CoreGui

-- Фон меню
local MainFrame = Instance.new("Frame")
MainFrame.Name = "Main"
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Parent = Menu
MainFrame.Active = true
MainFrame.Draggable = true

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Text = "🎯 FLICK FPS MENU"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.Parent = MainFrame

-- Функция создания кнопок
local yPos = 50
local function CreateButton(text, callback)
    local button = Instance.new("TextButton")
    button.Text = text
    button.Size = UDim2.new(0.9, 0, 0, 40)
    button.Position = UDim2.new(0.05, 0, 0, yPos)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.Gotham
    button.TextSize = 16
    button.Parent = MainFrame
    
    button.MouseButton1Click:Connect(callback)
    
    yPos = yPos + 50
    return button
end

-- Кнопка ESP
local espButton = CreateButton("ESP: ВКЛ", function()
    Settings.ESP = not Settings.ESP
    espButton.Text = "ESP: " .. (Settings.ESP and "ВКЛ" or "ВЫКЛ")
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local esp = player.Character and player.Character:FindFirstChild("ESP")
            if esp then
                esp.Enabled = Settings.ESP
            end
        end
    end
end)

-- Кнопка Aimbot
local aimButton = CreateButton("Aimbot: ВКЛ", function()
    Settings.Aimbot = not Settings.Aimbot
    aimButton.Text = "Aimbot: " .. (Settings.Aimbot and "ВКЛ" or "ВЫКЛ")
end)

-- Кнопка FOV
local fovButton = CreateButton("FOV Circle: ВКЛ", function()
    Settings.FOV = not Settings.FOV
    fovButton.Text = "FOV Circle: " .. (Settings.FOV and "ВКЛ" or "ВЫКЛ")
    FOVCircle.Enabled = Settings.FOV
end)

-- Кнопка размера FOV
local fovSizeButton = CreateButton("FOV Size: " .. Settings.FOV_Size, function()
    Settings.FOV_Size = Settings.FOV_Size + 50
    if Settings.FOV_Size > 300 then Settings.FOV_Size = 100 end
    fovSizeButton.Text = "FOV Size: " .. Settings.FOV_Size
    circle.Size = UDim2.new(0, Settings.FOV_Size, 0, Settings.FOV_Size)
end)

-- Кнопка закрытия
CreateButton("ЗАКРЫТЬ МЕНЮ", function()
    Menu.Enabled = false
end)

-- =========== ОБНОВЛЕНИЕ ===========
RunService.RenderStepped:Connect(function()
    -- Aimbot
    if Settings.Aimbot and UserInputService:IsKeyDown(Enum.KeyCode[Settings.AimKey]) then
        local targetPlayer = GetClosestPlayer()
        if targetPlayer and targetPlayer.Character then
            local target = targetPlayer.Character:FindFirstChild(Settings.AimPart)
            if not target then
                target = targetPlayer.Character:FindFirstChild("Head") or targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            end
            
            if target then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
            end
        end
    end
    
    -- Обновление FOV круга
    if Settings.FOV then
        circle.Size = UDim2.new(0, Settings.FOV_Size, 0, Settings.FOV_Size)
    end
end)

-- =========== ГОРЯЧИЕ КЛАВИШИ ===========
UserInputService.InputBegan:Connect(function(input)
    -- Открыть/закрыть меню (Insert)
    if input.KeyCode == Enum.KeyCode.Insert then
        Menu.Enabled = not Menu.Enabled
    end
    
    -- ESP (F1)
    if input.KeyCode == Enum.KeyCode.F1 then
        Settings.ESP = not Settings.ESP
        espButton.Text = "ESP: " .. (Settings.ESP and "ВКЛ" or "ВЫКЛ")
    end
    
    -- Aimbot (F2)
    if input.KeyCode == Enum.KeyCode.F2 then
        Settings.Aimbot = not Settings.Aimbot
        aimButton.Text = "Aimbot: " .. (Settings.Aimbot and "ВКЛ" or "ВЫКЛ")
    end
end)

-- =========== УВЕДОМЛЕНИЕ ===========
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "🎯 Flick FPS Script",
    Text = "Загружен!\nInsert - Меню\nF1 - ESP, F2 - Aimbot\nQ - Аимбот (удерживать)",
    Duration = 8,
})

print("✅ Скрипт готов к использованию!")
print("🎮 Управление:")
print("  Insert - Открыть/закрыть меню")
print("  F1 - Вкл/выкл ESP")
print("  F2 - Вкл/выкл Aimbot")
print("  Q - Активировать аимбот")
