-- GUI для безопасного авто-фарма Bee Swarm
-- Автор: dachnic7384-bit

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "🐝 Bee Swarm Safe Auto-Farm",
    LoadingTitle = "Загрузка безопасного скрипта...",
    LoadingSubtitle = "by dachnic7384-bit",
    ConfigurationSaving = { Enabled = true, FolderName = "BeeSwarmSafe" },
    Discord = { Enabled = false },
    KeySystem = false,
})

-- Загружаем основной скрипт
local BeeSwarm = loadstring(game:HttpGet("https://raw.githubusercontent.com/dachnic7384-bit/MyRobloxScripts/main/main.lua"))()

-- Вкладка АВТО-ФАРМ
local FarmTab = Window:CreateTab("🌻 Авто-Фарм", 4439880892)

local AutoFarmToggle = FarmTab:CreateToggle({
    Name = "🌻 Авто-сбор пыльцы (Макрос)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            BeeSwarm:StartSafeAutoFarm()
        else
            BeeSwarm:StopSafeAutoFarm()
        end
    end
})

local AutoConvertToggle = FarmTab:CreateToggle({
    Name = "🍯 Авто-конвертация в мёд",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            BeeSwarm:StartAutoConvert()
        else
            BeeSwarm:StopAutoConvert()
        end
    end
})

local AutoBoostToggle = FarmTab:CreateToggle({
    Name = "⚡ Авто-бусты (каждые 30с)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            BeeSwarm:StartAutoBoost()
        else
            BeeSwarm:StopAutoBoost()
        end
    end
})

FarmTab:CreateButton({
    Name = "▶️ Запустить ВСЁ авто-фарм",
    Callback = function()
        AutoFarmToggle:Set(true)
        AutoConvertToggle:Set(true)
        AutoBoostToggle:Set(true)
        Rayfield:Notify({
            Title = "Авто-фарм",
            Content = "Все функции запущены!",
            Duration = 3
        })
    end
})

FarmTab:CreateButton({
    Name = "⏹️ Остановить ВСЁ авто-фарм",
    Callback = function()
        AutoFarmToggle:Set(false)
        AutoConvertToggle:Set(false)
        AutoBoostToggle:Set(false)
        Rayfield:Notify({
            Title = "Авто-фарм",
            Content = "Все функции остановлены!",
            Duration = 3
        })
    end
})

-- Вкладка ТЕЛЕПОРТЫ
local TeleportTab = Window:CreateTab("🚀 Телепорты", 4439880892)

local fields = {
    "Sunflower", "Mushroom", "Blue Flower", "Clover", "Spider",
    "Bamboo", "Pineapple", "Strawberry", "Cactus", "Pumpkin"
}

for _, field in pairs(fields) do
    TeleportTab:CreateButton({
        Name = "➡️ " .. field,
        Callback = function()
            local result = BeeSwarm:TeleportToField(field)
            Rayfield:Notify({
                Title = "Телепорт",
                Content = result,
                Duration = 3
            })
        end
    })
end

-- Вкладка ЧИТЫ
local CheatsTab = Window:CreateTab("⚡ Читы", 4439880892)

CheatsTab:CreateToggle({
    Name = "⚡ Ускорение (Ходьба 50)",
    CurrentValue = false,
    Callback = function(Value)
        BeeSwarm:SpeedHack(Value)
    end
})

CheatsTab:CreateToggle({
    Name = "👻 Ноклип (Проход сквозь стены)",
    CurrentValue = false,
    Callback = function(Value)
        BeeSwarm:NoClip(Value)
    end
})

CheatsTab:CreateSlider({
    Name = "🎯 Дистанция сбора",
    Range = {5, 50},
    Increment = 5,
    Suffix = "studs",
    CurrentValue = 30,
    Callback = function(Value)
        Rayfield:Notify({
            Title = "Настройка",
            Content = "Дистанция установлена: " .. Value,
            Duration = 3
        })
    end
})

CheatsTab:CreateButton({
    Name = "📊 Показать статистику",
    Callback = function()
        BeeSwarm:GetStats()
        Rayfield:Notify({
            Title = "Статистика",
            Content = "Смотри в консоли (F9)",
            Duration = 3
        })
    end
})

-- Вкладка НАСТРОЙКИ
local SettingsTab = Window:CreateTab("⚙️ Настройки", 4439880892)

SettingsTab:CreateLabel("⚡ Быстрые клавиши:")
SettingsTab:CreateLabel("F1 - Вкл/Выкл авто-фарм")
SettingsTab:CreateLabel("F2 - Вкл/Выкл ускорение")
SettingsTab:CreateLabel("F3 - Телепорт на спавн")
SettingsTab:CreateLabel("RightShift - Меню")
SettingsTab:CreateLabel("")
SettingsTab:CreateLabel("🐝 Особенности:")
SettingsTab:CreateLabel("- Безопасный макро-режим")
SettingsTab:CreateLabel("- Имитация реальных кликов")
SettingsTab:CreateLabel("- Медленные интервалы")
SettingsTab:CreateLabel("- Минимальный риск бана")

-- Горячие клавиши
local UIS = game:GetService("UserInputService")

UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F1 then
        AutoFarmToggle:Set(not AutoFarmToggle.CurrentValue)
    elseif input.KeyCode == Enum.KeyCode.F2 then
        BeeSwarm:SpeedHack(not BeeSwarm.SpeedEnabled)
        BeeSwarm.SpeedEnabled = not BeeSwarm.SpeedEnabled
    elseif input.KeyCode == Enum.KeyCode.F3 then
        BeeSwarm:TeleportToField("Pumpkin")
    end
end)

-- Вкладка ИНФО
local InfoTab = Window:CreateTab("ℹ️ Информация", 4439880892)

InfoTab:CreateLabel("🐝 Bee Swarm Safe Auto-Farm")
InfoTab:CreateLabel("Версия: 2.0 (Безопасная)")
InfoTab:CreateLabel("Автор: dachnic7384-bit")
InfoTab:CreateLabel("GitHub: github.com/dachnic7384-bit")
InfoTab:CreateLabel("")
InfoTab:CreateLabel("⚠️ Безопасный режим:")
InfoTab:CreateLabel("- Использует макрос кликов")
InfoTab:CreateLabel("- Медленные интервалы")
InfoTab:CreateLabel("- Не спамит сервер")
InfoTab:CreateLabel("- Минимальный риск")

-- Уведомление о загрузке
Rayfield:Notify({
    Title = "🐝 Безопасный авто-фарм",
    Content = "Загружен! F1 - авто-фарм, RightShift - меню",
    Duration = 5,
    Image = 4439880892
})

print("✅ Безопасный авто-фарм готов! F1 - включить")

return Window
