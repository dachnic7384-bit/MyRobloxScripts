-- Flick FPS Script FIXED
-- Исправлены все баги: ESP, Aimbot, FOV Circle
-- Автор: dachnic7384-bit

if not game:IsLoaded() then
    game.Loaded:Wait()
end

print("🎯 Flick FPS Script загружается...")

-- Загрузка библиотеки GUI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Сервисы
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local Camera = Workspace.CurrentCamera

-- Настройки
local Settings = {
    ESP = {Enabled = false},
    Aimbot = {
        Enabled = false,
        FOV = 100,
        Smoothness = 0.1,
        Target = "Head",
        Keybind = Enum.KeyCode.Q
    },
    FOVCircle = {
        Enabled = false,
        Size = 100,
        Color = Color3.fromRGB(255, 255, 255)
    },
    ThirdPerson = false,
    WalkSpeed = 16
}

-- Создаем окно GUI
local Window = Rayfield:CreateWindow({
    Name = "🎯 Flick FPS Menu",
    LoadingTitle = "Загрузка...",
    LoadingSubtitle = "by dachnic7384-bit",
    ConfigurationSaving = { Enabled = true, FolderName = "FlickFPS" },
    Discord = { Enabled = false },
    KeySystem = false,
})

-- =========== ВКЛАДКА: VISUAL ===========
local VisualTab = Window:CreateTab("👁️ Visual", 4483362458)

VisualTab:CreateToggle({
    Name = "Включить ESP",
    CurrentValue = false,
    Callback = function(Value)
        Settings.ESP.Enabled = Value
        if Value then
            StartESP()
        else
            ClearESP()
        end
    end
})

-- =========== ВКЛАДКА: AIMBOT ===========
local AimbotTab = Window:CreateTab("🎯 Aimbot", 4483362458)

AimbotTab:CreateToggle({
    Name = "Включить Aimbot",
    CurrentValue = false,
    Callback = function(Value)
        Settings.Aimbot.Enabled = Value
        if Value then
            print("✅ Aimbot включен (удерживай Q)")
        else
            print("❌ Aimbot выключен")
        end
    end
})

AimbotTab:CreateSlider({
    Name = "FOV Размер",
    Range = {50, 300},
    Increment = 10,
    Suffix = "px",
    CurrentValue = 100,
    Callback = function(Value)
        Settings.Aimbot.FOV = Value
        if Settings.FOVCircle.Enabled then
            UpdateFOVCircle()
        end
    end
})

AimbotTab:CreateSlider({
    Name = "Сглаживание",
    Range = {0.05, 1},
    Increment = 0.05,
    Suffix = "",
    CurrentValue = 0.1,
    Callback = function(Value)
        Settings.Aimbot.Smoothness = Value
    end
})

-- =========== ВКЛАДКА: FOV CIRCLE ===========
local FOVTab = Window:CreateTab("⭕ FOV Circle", 4483362458)

FOVTab:CreateToggle({
    Name = "Показать FOV круг",
    CurrentValue = false,
    Callback = function(Value)
        Settings.FOVCircle.Enabled = Value
        if Value then
            CreateFOVCircle()
        else
            RemoveFOVCircle()
        end
    end
})

FOVTab:CreateColorPicker({
    Name = "Цвет круга",
    Color = Color3.fromRGB(255, 255, 255),
    Callback = function(Color)
        Settings.FOVCircle.Color = Color
        UpdateFOVCircle()
    end
})

-- =========== ВКЛАДКА: MISC ===========
local MiscTab = Window:CreateTab("⚡ Misc", 4483362458)

MiscTab:CreateToggle({
    Name = "Третье лицо",
    CurrentValue = false,
    Callback = function(Value)
        Settings.ThirdPerson = Value
        if Value then
            EnableThirdPerson()
        else
            DisableThirdPerson()
        end
    end
})

MiscTab:CreateSlider({
    Name = "Скорость ходьбы",
    Range = {16, 100},
    Increment = 1,
    Suffix = "studs/s",
    CurrentValue = 16,
    Callback = function(Value)
        Settings.WalkSpeed = Value
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end
    end
})

-- =========== ESP СИСТЕМА ===========
local ESPItems = {}

function StartESP()
    ClearESP()
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            AddESP(player)
        end
    end
    
    -- Следим за новыми игроками
    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function()
            if Settings.ESP.Enabled then
                AddESP(player)
            end
        end)
    end)
    
    -- Обновление ESP
    RunService.RenderStepped:Connect(function()
        if not Settings.ESP.Enabled then return end
        
        for player, esp in pairs(ESPItems) do
            if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local root = player.Character.HumanoidRootPart
                local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)
                
                if onScreen and esp.Box then
                    esp.Box.Visible = true
                    esp.Box.Size = Vector3.new(4, 6, 1)
                    esp.Box.CFrame = CFrame.new(root.Position)
                else
                    if esp.Box then esp.Box.Visible = false end
                end
            end
        end
    end)
end

function AddESP(player)
    if not player.Character then return end
    
    ESPItems[player] = {}
    
    -- Бокс ESP
    local box = Instance.new("BoxHandleAdornment")
    box.Name = "ESP_Box"
    box.Adornee = player.Character:WaitForChild("HumanoidRootPart")
    box.AlwaysOnTop = true
    box.ZIndex = 5
    box.Size = Vector3.new(4, 6, 1)
    box.Transparency = 0.3
    box.Color3 = Color3.fromRGB(255, 0, 0)
    box.Parent = player.Character.HumanoidRootPart
    
    ESPItems[player].Box = box
    
    -- Имя игрока
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_Name"
    billboard.Adornee = player.Character:WaitForChild("Head")
    billboard.Size = UDim2.new(0, 100, 0, 30)
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
    text.TextSize = 14
    
    billboard.Parent = player.Character.Head
    ESPItems[player].Name = billboard
end

function ClearESP()
    for player, esp in pairs(ESPItems) do
        if esp.Box then esp.Box:Destroy() end
        if esp.Name then esp.Name:Destroy() end
    end
    ESPItems = {}
end

-- =========== AIMBOT СИСТЕМА ===========
function GetClosestPlayer()
    local closestPlayer = nil
    local closestDistance = Settings.Aimbot.FOV
    
    local mousePos = UserInputService:GetMouseLocation()
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local targetPart = player.Character:FindFirstChild(Settings.Aimbot.Target)
            if not targetPart then
                targetPart = player.Character:FindFirstChild("Head") or player.Character:FindFirstChild("HumanoidRootPart")
            end
            
            if targetPart then
                local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                
                if onScreen then
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    
                    if distance < closestDistance then
                        closestPlayer = player
                        closestDistance = distance
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

function AimAtPlayer()
    if not Settings.Aimbot.Enabled then return end
    
    local targetPlayer = GetClosestPlayer()
    if not targetPlayer or not targetPlayer.Character then return end
    
    local targetPart = targetPlayer.Character:FindFirstChild(Settings.Aimbot.Target)
    if not targetPart then
        targetPart = targetPlayer.Character:FindFirstChild("Head") or targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    end
    
    if targetPart then
        local currentCFrame = Camera.CFrame
        local targetCFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
        
        -- Плавное прицеливание
        Camera.CFrame = currentCFrame:Lerp(targetCFrame, Settings.Aimbot.Smoothness)
    end
end

-- =========== FOV CIRCLE СИСТЕМА ===========
local FOVCircleFrame

function CreateFOVCircle()
    RemoveFOVCircle()
    
    FOVCircleFrame = Instance.new("ScreenGui")
    FOVCircleFrame.Name = "FOVCircle"
    FOVCircleFrame.ResetOnSpawn = false
    FOVCircleFrame.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    FOVCircleFrame.Parent = game.CoreGui
    
    local circle = Instance.new("Frame")
    circle.Name = "Circle"
    circle.AnchorPoint = Vector2.new(0.5, 0.5)
    circle.Position = UDim2.new(0.5, 0, 0.5, 0)
    circle.Size = UDim2.new(0, Settings.FOVCircle.Size, 0, Settings.FOVCircle.Size)
    circle.BackgroundTransparency = 1
    circle.Parent = FOVCircleFrame
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = circle
    
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Settings.FOVCircle.Color
    UIStroke.Thickness = 2
    UIStroke.Transparency = 0.5
    UIStroke.Parent = circle
    
    print("✅ FOV Circle создан")
end

function UpdateFOVCircle()
    if FOVCircleFrame and FOVCircleFrame:FindFirstChild("Circle") then
        local circle = FOVCircleFrame.Circle
        circle.Size = UDim2.new(0, Settings.Aimbot.FOV, 0, Settings.Aimbot.FOV)
        
        local stroke = circle:FindFirstChild("UIStroke")
        if stroke then
            stroke.Color = Settings.FOVCircle.Color
        end
    end
end

function RemoveFOVCircle()
    if FOVCircleFrame then
        FOVCircleFrame:Destroy()
        FOVCircleFrame = nil
    end
end

-- =========== ТРЕТЬЕ ЛИЦО ===========
function EnableThirdPerson()
    if LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.CameraOffset = Vector3.new(0, 0, -10)
        end
    end
end

function DisableThirdPerson()
    if LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.CameraOffset = Vector3.new(0, 0, 0)
        end
    end
end

-- =========== ОБНОВЛЕНИЕ AIMBOT ===========
RunService.RenderStepped:Connect(function()
    -- Aimbot (удерживаем Q)
    if Settings.Aimbot.Enabled and UserInputService:IsKeyDown(Settings.Aimbot.Keybind) then
        AimAtPlayer()
    end
    
    -- Обновление FOV Circle
    if Settings.FOVCircle.Enabled and FOVCircleFrame then
        local circle = FOVCircleFrame:FindFirstChild("Circle")
        if circle then
            circle.Size = UDim2.new(0, Settings.Aimbot.FOV, 0, Settings.Aimbot.FOV)
        end
    end
end)

-- =========== ГОРЯЧИЕ КЛАВИШИ ===========
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F1 then
        Settings.ESP.Enabled = not Settings.ESP.Enabled
        if Settings.ESP.Enabled then
            StartESP()
        else
            ClearESP()
        end
    elseif input.KeyCode == Enum.KeyCode.F2 then
        Settings.FOVCircle.Enabled = not Settings.FOVCircle.Enabled
        if Settings.FOVCircle.Enabled then
            CreateFOVCircle()
        else
            RemoveFOVCircle()
        end
    end
end)

-- =========== ИНИЦИАЛИЗАЦИЯ ===========
Rayfield:Notify({
    Title = "🎯 Flick FPS Script",
    Content = "Загружен!\nF1 - ESP, F2 - FOV Circle\nQ - Aimbot, RightShift - Меню",
    Duration = 6,
    Image = 4483362458
})

print("✅ Flick FPS Script загружен!")
print("🎯 Функции:")
print("  • ESP (F1)")
print("  • Aimbot (удерживай Q)")
print("  • FOV Circle (F2)")
print("  • Третье лицо")
print("  • Настройка скорости")

-- Авто-настройка скорости при запуске
spawn(function()
    wait(2)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Settings.WalkSpeed
    end
end)
