-- Bee Swarm Simple GUI
-- Автор: dachnic7384-bit

if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Загружаем main.lua сначала
loadstring(game:HttpGet("https://raw.githubusercontent.com/dachnic7384-bit/MyRobloxScripts/main/main.lua"))()

-- Загружаем Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Создаем окно
local Window = Rayfield:CreateWindow({
    Name = "🐝 Bee Swarm",
    LoadingTitle = "Загрузка...",
    ConfigurationSaving = { Enabled = false },
    Discord = { Enabled = false },
    KeySystem = false,
})

-- Вкладка авто-фарм
local MainTab = Window:CreateTab("Главная", 4439880892)

MainTab:CreateToggle({
    Name = "🌻 Авто-фарм",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            StartAutoFarm()
        else
            StopAutoFarm()
        end
    end
})

MainTab:CreateButton({
    Name = "🍯 Конвертировать",
    Callback = function()
        ConvertToHoney()
    end
})

-- Вкладка телепортов
local TeleportTab = Window:CreateTab("Телепорты", 4439880892)

TeleportTab:CreateButton({
    Name = "🌻 Подсолнухи",
    Callback = function()
        TeleportToField("Sunflower")
    end
})

TeleportTab:CreateButton({
    Name = "🍄 Грибы",
    Callback = function()
        TeleportToField("Mushroom")
    end
})

TeleportTab:CreateButton({
    Name = "🔵 Синие цветы",
    Callback = function()
        TeleportToField("Blue Flower")
    end
})

TeleportTab:CreateButton({
    Name = "🍀 Клевер",
    Callback = function()
        TeleportToField("Clover")
    end
})

TeleportTab:CreateButton({
    Name = "🕷️ Пауки",
    Callback = function()
        TeleportToField("Spider")
    end
})

-- Вкладка настроек
local SettingsTab = Window:CreateTab("Настройки", 4439880892)

SettingsTab:CreateSlider({
    Name = "🚶 Скорость",
    Range = {16, 50},
    Increment = 1,
    Suffix = "studs/s",
    CurrentValue = 16,
    Callback = function(Value)
        if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end
    end
})

-- Уведомление
Rayfield:Notify({
    Title = "🐝 Bee Swarm",
    Content = "Меню загружено!",
    Duration = 3,
})

print("✅ Меню загружено! RightShift - открыть")
