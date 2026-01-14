-- Дополнительные функции для MyRobloxScripts

local Features = {}

-- Авто-фарм очков
function Features:AutoFarm(enabled)
    if enabled then
        print("💰 Авто-фарм включен")
        spawn(function()
            while Features.AutoFarmEnabled do
                wait(1)
                -- Логика фарма
                print("Фармлю очки...")
            end
        end)
    else
        print("💰 Авто-фарм выключен")
    end
    Features.AutoFarmEnabled = enabled
end

-- Авто-кликер
function Features:AutoClicker(enabled)
    if enabled then
        print("🖱️ Авто-кликер включен")
        spawn(function()
            while Features.AutoClickerEnabled do
                wait(0.5)
                -- Имитация клика
                mouse1click()
            end
        end)
    else
        print("🖱️ Авто-кликер выключен")
    end
    Features.AutoClickerEnabled = enabled
end

-- Телепорт к игроку
function Features:TeleportToPlayer(playerName)
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    
    for _, player in pairs(Players:GetPlayers()) do
        if string.lower(player.Name) == string.lower(playerName) then
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character:MoveTo(player.Character.HumanoidRootPart.Position)
                return "✅ Телепорт к " .. player.Name
            end
        end
    end
    return "❌ Игрок не найден"
end

-- Информация о сервере
function Features:ServerInfo()
    local Players = game:GetService("Players")
    local Lighting = game:GetService("Lighting")
    
    print("=== ИНФОРМАЦИЯ О СЕРВЕРЕ ===")
    print("👥 Игроков: " .. #Players:GetPlayers() .. "/" .. Players.MaxPlayers)
    print("🕒 Время на сервере: " .. Lighting:GetMinutesAfterMidnight() .. " минут")
    print("📍 Место: " .. game.PlaceId)
    print("🎮 Игра: " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name)
    print("==========================")
end

-- Быстрые телепорты
function Features:QuickTeleports()
    local teleports = {
        ["Спавн"] = Vector3.new(0, 5, 0),
        ["Центр карты"] = Vector3.new(100, 50, 100),
        ["Секретная зона"] = Vector3.new(-200, 25, -200)
    }
    
    return teleports
end

return Features
