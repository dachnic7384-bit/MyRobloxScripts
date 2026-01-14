-- MyRobloxScripts v1.0
-- Репозиторий: https://github.com/dachnic7384-bit/MyRobloxScripts

print("🎮 MyRobloxScripts загружен!")
print("📁 Репозиторий: github.com/dachnic7384-bit/MyRobloxScripts")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Основные функции
local MyScript = {}

-- Функция приветствия
function MyScript:Hello()
    game.StarterGui:SetCore("SendNotification", {
        Title = "MyRobloxScripts",
        Text = "Скрипт успешно загружен!",
        Duration = 3,
        Icon = "rbxassetid://4483362458"
    })
    return "✅ Скрипт активирован!"
end

-- Функция информации об игроках
function MyScript:PlayerList()
    print("=== СПИСОК ИГРОКОВ ===")
    for _, player in pairs(Players:GetPlayers()) do
        print("👤 " .. player.Name .. 
              " | ID: " .. player.UserId ..
              " | Аккаунт создан: " .. player.AccountAge .. " дней назад")
    end
    print("=====================")
end

-- Простой ESP (подсветка игроков)
function MyScript:SimpleESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local highlight = Instance.new("Highlight")
            highlight.Name = "MyScript_Highlight"
            highlight.Parent = player.Character
            highlight.FillColor = Color3.fromRGB(0, 255, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
            highlight.FillTransparency = 0.5
        end
    end
    return "✅ ESP включен!"
end

-- Удаление ESP
function MyScript:RemoveESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            local highlight = player.Character:FindFirstChild("MyScript_Highlight")
            if highlight then
                highlight:Destroy()
            end
        end
    end
    return "❌ ESP отключен!"
end

-- Изменение скорости ходьбы
function MyScript:SetWalkspeed(speed)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = speed
        return "🚶 Скорость ходьбы: " .. speed
    end
    return "❌ Не удалось изменить скорость"
end

-- Авто-кликер (пример)
function MyScript:AutoClicker(enabled)
    if enabled then
        print("🖱️ Авто-кликер включен")
        -- Здесь будет логика авто-кликера
        return "✅ Авто-кликер включен"
    else
        print("🖱️ Авто-кликер выключен")
        return "❌ Авто-кликер выключен"
    end
end

-- Инициализация
MyScript:Hello()
MyScript:SetWalkspeed(25)

-- Возвращаем объект скрипта
return MyScript
