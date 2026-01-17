-- Flick FPS WORKING Script
-- ESP + Aimbot + FOV Circle
-- Автор: dachnic7384-bit

if not game:IsLoaded() then
    game.Loaded:Wait()
end

print("🎯 Flick FPS Script загружается...")

-- Сервисы
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- Настройки
local Settings = {
    ESP = false,
    Aimbot = false,
    Triggerbot = false,
    FOVCircle = false,
    FOVSize = 100,
    AimKey = "Q",
    AimSmoothness = 0.1,
    AimPart = "Head"
}

-- Простое меню (без Rayfield)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlickFPS_Menu"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- Текст информации
local InfoText = Instance.new("TextLabel")
InfoText.Name = "InfoText"
InfoText.Parent = ScreenGui
InfoText.BackgroundTransparency = 1
InfoText.Position = UDim2.new(0.02, 0, 0.02, 0)
InfoText.Size = UDim2.new(0, 250, 0, 100)
InfoText.Text = "🎯 Flick FPS Script\nF1 - ESP\nF2 - Aimbot\nF3 - Triggerbot\nF4 - FOV Circle\nRightCtrl - Меню"
InfoText.TextColor3 = Color3.fromRGB(255, 255, 255)
InfoText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
InfoText.TextStrokeTransparency = 0
InfoText.TextSize = 16
InfoText.Font = Enum.Font.GothamBold
InfoText.Visible = false

-- =========== ESP СИСТЕМА ===========
local ESPObjects = {}

function CreateESP(player)
    if player == LocalPlayer then return end
    
    ESPObjects[player] = {}
    
    -- Highlight для всего персонажа
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.FillTransparency = 0.7
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineTransparency = 0
    
    player.CharacterAdded:Connect(function(char)
        wait(1)
        if Settings.ESP then
            highlight.Adornee = char
            highlight.Parent = char
        end
    end)
    
    if player.Character then
        highlight.Adornee = player.Character
        highlight.Parent = player.Character
    end
    
    ESPObjects[player].Highlight = highlight
    
    -- Имя над головой
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_Name"
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    
    local nameText = Instance.new("TextLabel")
    nameText.Parent = billboard
    nameText.BackgroundTransparency = 1
    nameText.Size = UDim2.new(1, 0, 1, 0)
    nameText.Text = player.Name
    nameText.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameText.TextStrokeTransparency = 0
    nameText.TextSize = 18
    nameText.Font = Enum.Font.GothamBold
    
    player.CharacterAdded:Connect(function(char)
        wait(1)
        if Settings.ESP then
            billboard.Adornee = char:WaitForChild("Head")
            billboard.Parent = char.Head
        end
    end)
    
    if player.Character and player.Character:FindFirstChild("Head") then
        billboard.Adornee = player.Character.Head
        billboard.Parent = player.Character.Head
    end
    
    ESPObjects[player].Billboard = billboard
end

function StartESP()
    ClearESP()
    
    for _, player in pairs(Players:GetPlayers()) do
        CreateESP(player)
    end
    
    Players.PlayerAdded:Connect(function(player)
        CreateESP(player)
    end)
    
    print("✅ ESP включен")
end

function ClearESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if player.Character then
                local highlight = player.Character:FindFirstChild("ESP_Highlight")
                if highlight then highlight:Destroy() end
                
                local billboard = player.Character:FindFirstChildWhichIsA("BillboardGui")
                if billboard then billboard:Destroy() end
            end
        end
    end
    ESPObjects = {}
    print("❌ ESP выключен")
end

-- =========== AIMBOT СИСТЕМА ===========
function GetClosestPlayerToMouse()
    local closestPlayer = nil
    local closestDistance = Settings.FOVSize
    local mousePos = Vector2.new(Mouse.X, Mouse.Y)
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local targetPart = player.Character:FindFirstChild(Settings.AimPart)
            if not targetPart then
                targetPart = player.Character:FindFirstChild("Head") or player.Character:FindFirstChild("HumanoidRootPart")
            end
            
            if targetPart then
                local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                
                if onScreen then
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    
                    if distance < closestDistance then
                        -- Проверка на видимость
                        local origin = Camera.CFrame.Position
                        local direction = (targetPart.Position - origin).Unit * 1000
                        local raycastParams = RaycastParams.new()
                        raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, player.Character}
                        raycastParams.FilterType = Enum.RaycastFilterType.Exclude
                        
                        local raycastResult = Workspace:Raycast(origin, direction, raycastParams)
                        
                        if not raycastResult or raycastResult.Instance:IsDescendantOf(player.Character) then
                            closestPlayer = player
                            closestDistance = distance
                        end
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

function AimAtPlayer()
    if not Settings.Aimbot then return end
    
    local targetPlayer = GetClosestPlayerToMouse()
    if not targetPlayer or not targetPlayer.Character then return end
    
    local targetPart = targetPlayer.Character:FindFirstChild(Settings.AimPart)
    if not targetPart then
        targetPart = targetPlayer.Character:FindFirstChild("Head") or targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    end
    
    if targetPart then
        local currentCFrame = Camera.CFrame
        local targetPosition = targetPart.Position
        local targetCFrame = CFrame.new(currentCFrame.Position, targetPosition)
        
        -- Плавное прицеливание
        Camera.CFrame = currentCFrame:Lerp(targetCFrame, Settings.AimSmoothness)
    end
end

-- =========== TRIGGERBOT ===========
function StartTriggerbot()
    while Settings.Triggerbot do
        wait(0.1)
        
        if Settings.Triggerbot then
            local targetPlayer = GetClosestPlayerToMouse()
            if targetPlayer and targetPlayer.Character then
                mouse1press()
                wait(0.05)
                mouse1release()
            end
        end
    end
end

-- =========== FOV CIRCLE ===========
local FOVCircle

function CreateFOVCircle()
    RemoveFOVCircle()
    
    FOVCircle = Instance.new("ScreenGui")
    FOVCircle.Name = "FOV_Circle"
    FOVCircle.ResetOnSpawn = false
    FOVCircle.Parent = game.CoreGui
    
    local frame = Instance.new("Frame")
    frame.Name = "Circle"
    frame.BackgroundTransparency = 1
    frame.Size = UDim2.new(0, Settings.FOVSize, 0, Settings.FOVSize)
    frame.Position = UDim2.new(0.5, -Settings.FOVSize/2, 0.5, -Settings.FOVSize/2)
    frame.Parent = FOVCircle
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = frame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = 2
    stroke.Transparency = 0.5
    stroke.Parent = frame
    
    print("✅ FOV Circle создан")
end

function RemoveFOVCircle()
    if FOVCircle then
        FOVCircle:Destroy()
        FOVCircle = nil
    end
end

-- =========== ОБНОВЛЕНИЕ ===========
RunService.RenderStepped:Connect(function()
    -- Aimbot
    if Settings.Aimbot and UserInputService:IsKeyDown(Enum.KeyCode[Settings.AimKey]) then
        AimAtPlayer()
    end
    
    -- Обновление FOV Circle
    if Settings.FOVCircle and FOVCircle then
        local circle = FOVCircle:FindFirstChild("Circle")
        if circle then
            circle.Size = UDim2.new(0, Settings.FOVSize, 0, Settings.FOVSize)
            circle.Position = UDim2.new(0.5, -Settings.FOVSize/2, 0.5, -Settings.FOVSize/2)
        end
    end
end)

-- =========== ГОРЯЧИЕ КЛАВИШИ ===========
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F1 then
        Settings.ESP = not Settings.ESP
        if Settings.ESP then
            StartESP()
        else
            ClearESP()
        end
        
    elseif input.KeyCode == Enum.KeyCode.F2 then
        Settings.Aimbot = not Settings.Aimbot
        print(Settings.Aimbot and "✅ Aimbot включен (удерживай Q)" or "❌ Aimbot выключен")
        
    elseif input.KeyCode == Enum.KeyCode.F3 then
        Settings.Triggerbot = not Settings.Triggerbot
        if Settings.Triggerbot then
            spawn(StartTriggerbot)
            print("✅ Triggerbot включен")
        else
            print("❌ Triggerbot выключен")
        end
        
    elseif input.KeyCode == Enum.KeyCode.F4 then
        Settings.FOVCircle = not Settings.FOVCircle
        if Settings.FOVCircle then
            CreateFOVCircle()
        else
            RemoveFOVCircle()
        end
        
    elseif input.KeyCode == Enum.KeyCode.RightControl then
        InfoText.Visible = not InfoText.Visible
    end
end)

-- =========== НАСТРОЙКИ СКРИПТА ===========
local ConfigFrame = Instance.new("Frame")
ConfigFrame.Name = "Config"
ConfigFrame.Parent = ScreenGui
ConfigFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ConfigFrame.BackgroundTransparency = 0.3
ConfigFrame.Size = UDim2.new(0, 300, 0, 400)
ConfigFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
ConfigFrame.Visible = false
ConfigFrame.Active = true
ConfigFrame.Draggable = true

local Title = Instance.new("TextLabel")
Title.Parent = ConfigFrame
Title.Text = "🎯 Flick FPS Settings"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20

-- Создаем кнопки настроек
local function CreateButton(parent, text, yPos, callback)
    local button = Instance.new("TextButton")
    button.Parent = parent
    button.Text = text
    button.Size = UDim2.new(0.9, 0, 0, 40)
    button.Position = UDim2.new(0.05, 0, 0, yPos)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.Gotham
    button.TextSize = 16
    
    button.MouseButton1Click:Connect(callback)
    
    return button
end

-- Кнопки настроек
local buttonY = 50
CreateButton(ConfigFrame, "Включить ESP", buttonY, function()
    Settings.ESP = not Settings.ESP
    if Settings.ESP then
        StartESP()
    else
        ClearESP()
    end
end)

buttonY = buttonY + 50
CreateButton(ConfigFrame, "Включить Aimbot (Q)", buttonY, function()
    Settings.Aimbot = not Settings.Aimbot
end)

buttonY = buttonY + 50
CreateButton(ConfigFrame, "Включить Triggerbot", buttonY, function()
    Settings.Triggerbot = not Settings.Triggerbot
    if Settings.Triggerbot then
        spawn(StartTriggerbot)
    end
end)

buttonY = buttonY + 50
CreateButton(ConfigFrame, "Включить FOV Circle", buttonY, function()
    Settings.FOVCircle = not Settings.FOVCircle
    if Settings.FOVCircle then
        CreateFOVCircle()
    else
        RemoveFOVCircle()
    end
end)

buttonY = buttonY + 50
CreateButton(ConfigFrame, "Увеличить FOV", buttonY, function()
    Settings.FOVSize = Settings.FOVSize + 20
    if Settings.FOVSize > 300 then Settings.FOVSize = 100 end
    if Settings.FOVCircle then
        CreateFOVCircle()
    end
end)

buttonY = buttonY + 50
CreateButton(ConfigFrame, "Закрыть меню", buttonY, function()
    ConfigFrame.Visible = false
end)

-- =========== ИНИЦИАЛИЗАЦИЯ ===========
print("🎯 Flick FPS Script загружен!")
print("🔥 Горячие клавиши:")
print("  F1 - Вкл/выкл ESP")
print("  F2 - Вкл/выкл Aimbot")
print("  F3 - Вкл/выкл Triggerbot")
print("  F4 - Вкл/выкл FOV Circle")
print("  RightCtrl - Показать инфо")
print("  RightAlt - Открыть меню настроек")

-- Авто-создание ESP для уже существующих игроков
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        CreateESP(player)
    end
end

-- Кнопка для открытия меню настроек
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightAlt then
        ConfigFrame.Visible = not ConfigFrame.Visible
    end
end)

-- Уведомление
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "🎯 Flick FPS Script",
    Text = "Загружен!\nF1 - ESP, F2 - Aimbot\nF3 - Triggerbot, F4 - FOV Circle\nRightCtrl - Инфо, RightAlt - Меню",
    Duration = 8,
})

-- Авто-обновление ESP
spawn(function()
    while true do
        wait(1)
        if Settings.ESP then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local highlight = player.Character:FindFirstChild("ESP_Highlight")
                    if not highlight then
                        CreateESP(player)
                    end
                end
            end
        end
    end
end)
