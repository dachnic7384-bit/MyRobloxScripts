-- MyRobloxScripts v1.0
-- Автор: dachnic7384-bit
-- Репозиторий: https://github.com/dachnic7384-bit/MyRobloxScripts

print("======================================")
print("🎮 MyRobloxScripts загружен!")
print("📁 GitHub: github.com/dachnic7384-bit/MyRobloxScripts")
print("======================================")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Безопасная проверка
if not LocalPlayer then
    warn("❌ Игрок не найден!")
    return nil
end

-- Основные функции
local MyScript = {}

-- Приветствие
function MyScript:Hello()
    game.StarterGui:SetCore("SendNotification", {
        Title = "MyRobloxScripts 🎮",
        Text = "Скрипт успешно загружен!",
        Duration = 5,
        Icon = "rbxassetid://4483362458"
    })
    return "✅ MyRobloxScripts активирован!"
end

-- Информация об игроках
function MyScript:GetPlayerInfo()
    print("\n=== СПИСОК ИГРОКОВ (" .. #Players:GetPlayers() .. ") ===")
    for _, player in pairs(Players:GetPlayers()) do
        local role = "👤"
        if player == LocalPlayer then role = "🌟" end
        
        print(role .. " " .. player.Name .. 
              " | ID: " .. player.UserId ..
              " | Возраст аккаунта: " .. player.AccountAge .. " дней")
    end
    print("================================\n")
    return "✅ Список игроков показан в консоли"
end

-- ESP система
function MyScript:SimpleESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local highlight = Instance.new("Highlight")
            highlight.Name = "MyScript_Highlight_" .. player.UserId
            highlight.Parent = player.Character
            highlight.FillColor = Color3.fromRGB(0, 255, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
            highlight.FillTransparency = 0.6
            highlight.OutlineTransparency = 0
        end
    end
    return "✅ ESP включен для всех игроков"
end

function MyScript:RemoveESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            for _, obj in pairs(player.Character:GetChildren()) do
                if obj.Name:find("MyScript_Highlight") then
                    obj:Destroy()
                end
            end
        end
    end
    return "❌ ESP отключен"
end

-- Скорость ходьбы
function MyScript:SetWalkspeed(speed)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = math.clamp(speed, 16, 100)
        return "🚶 Скорость ходьбы установлена: " .. speed
    end
    return "❌ Не удалось изменить скорость"
end

-- Загрузка GUI
function MyScript:LoadGUI()
    local success, gui = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/dachnic7384-bit/MyRobloxScripts/main/gui.lua"))()
    end)
    
    if success then
        return "✅ GUI загружен!"
    else
        return "❌ Ошибка загрузки GUI"
    end
end

-- Загрузка доп. функций
function MyScript:LoadFeatures()
    local success, features = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/dachnic7384-bit/MyRobloxScripts/main/features.lua"))()
    end)
    
    if success then
        MyScript.Features = features
        return "✅ Дополнительные функции загружены!"
    else
        return "❌ Ошибка загрузки features"
    end
end

-- Автоматическая инициализация
MyScript:Hello()
MyScript:SetWalkspeed(25)

-- Возвращаем объект скрипта
return MyScript
