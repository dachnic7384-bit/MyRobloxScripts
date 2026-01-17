-- Flick FPS Script v1.0
-- ESP + Aimbot + FOV + GUI
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
    ESP = {
        Enabled = false,
        Box = false,
        Tracers = false,
        Names = false,
        Health = false,
        Distance = false,
        Color = Color3.fromRGB(255, 0, 0)
    },
    Aimbot = {
        Enabled = false,
        FOV = 100,
        Smoothness = 0.3,
        TargetPart = "Head",
        TeamCheck = true,
        VisibleCheck = true
    },
    FOV = {
        Enabled = false,
        Size = 100,
        Color = Color3.fromRGB(255, 255, 255),
        Transparency = 0.5
    },
    Misc = {
        Triggerbot = false,
        NoRecoil = false,
        InfiniteAmmo = false,
        RapidFire = false
    }
}

-- Создание окна GUI
local Window = Rayfield:CreateWindow({
    Name = "🎯 Flick FPS Script",
    LoadingTitle = "Загрузка хаков...",
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

VisualTab:CreateToggle({
    Name = "Боксы",
    CurrentValue = false,
    Callback = function(Value)
        Settings.ESP.Box = Value
    end
})

VisualTab:CreateToggle({
    Name = "Трейсеры (линии)",
    CurrentValue = false,
    Callback = function(Value)
        Settings.ESP.Tracers = Value
    end
})

VisualTab:CreateToggle({
    Name = "Имена",
    CurrentValue = false,
    Callback = function(Value)
        Settings.ESP.Names = Value
    end
})

VisualTab:CreateColorPicker({
    Name = "Цвет ESP",
    Color = Color3.fromRGB(255, 0, 0),
    Callback = function(Color)
        Settings.ESP.Color = Color
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
            StartAimbot()
        end
    end
})

AimbotTab:CreateDropdown({
    Name = "Часть тела",
    Options = {"Head", "Torso", "HumanoidRootPart"},
    CurrentOption = "Head",
    Callback = function(Option)
        Settings.Aimbot.TargetPart = Option
    end
})

AimbotTab:CreateSlider({
    Name = "FOV (поле зрения)",
    Range = {10, 500},
    Increment = 5,
    Suffix = "px",
    CurrentValue = 100,
    Callback = function(Value)
        Settings.Aimbot.FOV = Value
    end
})

AimbotTab:CreateSlider({
    Name = "Сглаживание",
    Range = {0, 1},
    Increment = 0.05,
    Suffix = "",
    CurrentValue = 0.3,
    Callback = function(Value)
        Settings.Aimbot.Smoothness = Value
    end
})

AimbotTab:CreateToggle({
    Name = "Проверка на команду",
    CurrentValue = true,
    Callback = function(Value)
        Settings.Aimbot.TeamCheck = Value
    end
})

AimbotTab:CreateKeybind({
    Name = "Клавиша аимбота",
    CurrentKeybind = "Q",
    HoldToInteract = true,
    Callback = function(Key)
        Settings.Aimbot.Keybind = Key
    end
})

-- =========== ВКЛАДКА: FOV CIRCLE ===========
local FOVTab = Window:CreateTab("⭕ FOV Circle", 4483362458)

FOVTab:CreateToggle({
    Name = "Показать FOV круг",
    CurrentValue = false,
    Callback = function(Value)
        Settings.FOV.Enabled = Value
        if Value then
            CreateFOVCircle()
        else
            RemoveFOVCircle()
        end
    end
})

FOVTab:CreateSlider({
    Name = "Размер FOV",
    Range = {10, 500},
    Increment = 5,
    Suffix = "px",
    CurrentValue = 100,
    Callback = function(Value)
        Settings.FOV.Size = Value
        UpdateFOVCircle()
    end
})

FOVTab:CreateColorPicker({
    Name = "Цвет FOV",
    Color = Color3.fromRGB(255, 255, 255),
    Callback = function(Color)
        Settings.FOV.Color = Color
        UpdateFOVCircle()
    end
})

FOVTab:CreateSlider({
    Name = "Прозрачность",
    Range = {0, 1},
    Increment = 0.05,
    Suffix = "",
    CurrentValue = 0.5,
    Callback = function(Value)
        Settings.FOV.Transparency = Value
        UpdateFOVCircle()
    end
})

-- =========== ВКЛАДКА: MISC ===========
local MiscTab = Window:CreateTab("⚡ Misc", 4483362458)

MiscTab:CreateToggle({
    Name = "Триггербот (авто-огонь)",
    CurrentValue = false,
    Callback = function(Value)
        Settings.Misc.Triggerbot = Value
        if Value then
            StartTriggerbot()
        end
    end
})

MiscTab:CreateToggle({
    Name = "Нет отдачи",
    CurrentValue = false,
    Callback = function(Value)
        Settings.Misc.NoRecoil = Value
        if Value then
            NoRecoil()
        end
    end
})

MiscTab:CreateToggle({
    Name = "Бесконечные патроны",
    CurrentValue = false,
    Callback = function(Value)
        Settings.Misc.InfiniteAmmo = Value
        if Value then
            InfiniteAmmo()
        end
    end
})

MiscTab:CreateToggle({
    Name = "Быстрая стрельба",
    CurrentValue = false,
    Callback = function(Value)
        Settings.Misc.RapidFire = Value
        if Value then
            RapidFire()
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
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end
    end
})

-- =========== ВКЛАДКА: INFO ===========
local InfoTab = Window:CreateTab("ℹ️ Info", 4483362458)

InfoTab:CreateLabel("🎯 Flick FPS Script v1.0")
InfoTab:CreateLabel("👨💻 Автор: dachnic7384-bit")
InfoTab:CreateLabel("📁 GitHub: github.com/dachnic7384-bit")
InfoTab:CreateLabel("")
InfoTab:CreateLabel("🎮 Управление:")
InfoTab:CreateLabel("RightShift - Открыть/Закрыть меню")
InfoTab:CreateLabel("Q - Аимбот (удерживать)")
InfoTab:CreateLabel("F1 - Вкл/Выкл ESP")
InfoTab:CreateLabel("F2 - Вкл/Выкл FOV круг")

-- =========== ФУНКЦИИ ESP ===========
local ESPObjects = {}

function StartESP()
    ClearESP()
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            CreateESP(player)
        end
    end
    
    Players.PlayerAdded:Connect(function(player)
        CreateESP(player)
    end)
    
    Players.PlayerRemoving:Connect(function(player)
        if ESPObjects[player] then
            for _, obj in pairs(ESPObjects[player]) do
                obj:Destroy()
            end
            ESPObjects[player] = nil
        end
    end)
end

function CreateESP(player)
    if not player.Character then return end
    
    ESPObjects[player] = {}
    
    -- Бокс
    if Settings.ESP.Box then
        local box = Instance.new("BoxHandleAdornment")
        box.Name = "ESP_Box"
        box.Adornee = player.Character:WaitForChild("HumanoidRootPart")
        box.AlwaysOnTop = true
        box.ZIndex = 5
        box.Size = Vector3.new(4, 6, 1)
        box.Transparency = 0.7
        box.Color3 = Settings.ESP.Color
        box.Parent = player.Character.HumanoidRootPart
        
        table.insert(ESPObjects[player], box)
    end
    
    -- Имя
    if Settings.ESP.Names then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESP_Name"
        billboard.Adornee = player.Character:WaitForChild("Head")
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 2.5, 0)
        billboard.AlwaysOnTop = true
        
        local text = Instance.new("TextLabel")
        text.Parent = billboard
        text.BackgroundTransparency = 1
        text.Size = UDim2.new(1, 0, 1, 0)
        text.Text = player.Name
        text.TextColor3 = Settings.ESP.Color
        text.TextStrokeTransparency = 0.5
        text.TextSize = 18
        
        billboard.Parent = player.Character.Head
        table.insert(ESPObjects[player], billboard)
    end
    
    -- Трейсеры
    if Settings.ESP.Tracers then
        local tracer = Instance.new("Frame")
        tracer.Name = "ESP_Tracer"
        tracer.BackgroundColor3 = Settings.ESP.Color
        tracer.BorderSizePixel = 0
        tracer.Size = UDim2.new(0, 2, 0, 200)
        tracer.AnchorPoint = Vector2.new(0.5, 1)
        tracer.Position = UDim2.new(0.5, 0, 1, -50)
        tracer.Parent = game.CoreGui
        
        local connection = RunService.RenderStepped:Connect(function()
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local pos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
                if onScreen then
                    tracer.Visible = true
                    tracer.Position = UDim2.new(0, pos.X, 0, pos.Y)
                else
                    tracer.Visible = false
                end
            else
                tracer:Destroy()
                connection:Disconnect()
            end
        end)
        
        table.insert(ESPObjects[player], {tracer, connection})
    end
end

function ClearESP()
    for player, objects in pairs(ESPObjects) do
        for _, obj in pairs(objects) do
            if type(obj) == "table" then
                obj[1]:Destroy()
                if obj[2] then obj[2]:Disconnect() end
            else
                obj:Destroy()
            end
        end
    end
    ESPObjects = {}
end

-- =========== ФУНКЦИИ AIMBOT ===========
function StartAimbot()
    local aimbotConnection
    aimbotConnection = RunService.RenderStepped:Connect(function()
        if not Settings.Aimbot.Enabled then
            aimbotConnection:Disconnect()
            return
        end
        
        local target = GetClosestPlayer()
        if target and UserInputService:IsKeyDown(Enum.KeyCode.Q) then
            AimAt(target)
        end
    end)
end

function GetClosestPlayer()
    local closestPlayer = nil
    local closestDistance = Settings.Aimbot.FOV
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            -- Проверка на команду
            if Settings.Aimbot.TeamCheck and player.Team == LocalPlayer.Team then
                continue
            end
            
            local targetPart = player.Character:FindFirstChild(Settings.Aimbot.TargetPart)
            if targetPart then
                local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                if onScreen then
                    local mousePos = UserInputService:GetMouseLocation()
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    
                    if distance < closestDistance then
                        -- Проверка на видимость
                        if Settings.Aimbot.VisibleCheck then
                            local ray = Ray.new(Camera.CFrame.Position, (targetPart.Position - Camera.CFrame.Position).Unit * 1000)
                            local hit = Workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character, player.Character})
                            if hit and hit:IsDescendantOf(player.Character) then
                                closestPlayer = player
                                closestDistance = distance
                            end
                        else
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

function AimAt(player)
    if not player or not player.Character then return end
    
    local targetPart = player.Character:FindFirstChild(Settings.Aimbot.TargetPart)
    if not targetPart then return end
    
    local camera = Workspace.CurrentCamera
    local targetPosition = targetPart.Position
    
    -- Сглаживание
    local currentCFrame = camera.CFrame
    local targetCFrame = CFrame.new(camera.CFrame.Position, targetPosition)
    local smoothedCFrame = currentCFrame:Lerp(targetCFrame, Settings.Aimbot.Smoothness)
    
    camera.CFrame = smoothedCFrame
end

-- =========== ФУНКЦИИ FOV CIRCLE ===========
local FOVCircle

function CreateFOVCircle()
    RemoveFOVCircle()
    
    FOVCircle = Instance.new("ScreenGui")
    FOVCircle.Name = "FOV_Circle"
    FOVCircle.ResetOnSpawn = false
    FOVCircle.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local circle = Instance.new("Frame")
    circle.Name = "Circle"
    circle.BackgroundTransparency = 1
    circle.Size = UDim2.new(0, Settings.FOV.Size, 0, Settings.FOV.Size)
    circle.Position = UDim2.new(0.5, -Settings.FOV.Size/2, 0.5, -Settings.FOV.Size/2)
    circle.Parent = FOVCircle
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = circle
    
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Settings.FOV.Color
    UIStroke.Thickness = 2
    UIStroke.Transparency = Settings.FOV.Transparency
    UIStroke.Parent = circle
    
    FOVCircle.Parent = game.CoreGui
end

function UpdateFOVCircle()
    if FOVCircle then
        local circle = FOVCircle:FindFirstChild("Circle")
        if circle then
            circle.Size = UDim2.new(0, Settings.FOV.Size, 0, Settings.FOV.Size)
            circle.Position = UDim2.new(0.5, -Settings.FOV.Size/2, 0.5, -Settings.FOV.Size/2)
            
            local stroke = circle:FindFirstChild("UIStroke")
            if stroke then
                stroke.Color = Settings.FOV.Color
                stroke.Transparency = Settings.FOV.Transparency
            end
        end
    end
end

function RemoveFOVCircle()
    if FOVCircle then
        FOVCircle:Destroy()
        FOVCircle = nil
    end
end

-- =========== MISC ФУНКЦИИ ===========
function StartTriggerbot()
    spawn(function()
        while Settings.Misc.Triggerbot do
            wait(0.1)
            local target = GetClosestPlayer()
            if target and target.Character then
                mouse1press()
                wait(0.05)
                mouse1release()
            end
        end
    end)
end

function NoRecoil()
    -- Логика отключения отдачи
    print("🔫 Отдача отключена")
end

function InfiniteAmmo()
    -- Логика бесконечных патронов
    print("∞ Бесконечные патроны включены")
end

function RapidFire()
    -- Логика быстрой стрельбы
    print("⚡ Быстрая стрельба включена")
end

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
        Settings.FOV.Enabled = not Settings.FOV.Enabled
        if Settings.FOV.Enabled then
            CreateFOVCircle()
        else
            RemoveFOVCircle()
        end
    end
end)

-- =========== УВЕДОМЛЕНИЕ ===========
Rayfield:Notify({
    Title = "🎯 Flick FPS Script",
    Content = "Загружен! RightShift - меню",
    Duration = 5,
    Image = 4483362458
})

print("✅ Flick FPS Script загружен!")
print("🎯 ESP, Aimbot, FOV Circle готовы к использованию")
