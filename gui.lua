-- GUI Bee Swarm PRO v3.0
-- Автор: dachnic7384-bit

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "🐝 Bee Swarm PRO v3.0",
    LoadingTitle = "Загрузка умного авто-фарма...",
    LoadingSubtitle = "by dachnic7384-bit",
    ConfigurationSaving = { Enabled = true, FolderName = "BeeSwarmPRO" },
    Discord = { Enabled = false },
    KeySystem = false,
})

-- Загружаем основной скрипт
local BeeSwarm = loadstring(game:HttpGet("https://raw.githubusercontent.com/dachnic7384-bit/MyRobloxScripts/main/main.lua"))()

-- Вкладка АВТО-ФАРМ
local FarmTab = Window:CreateTab("🌻 Авто-Фарм", 4439880892)

-- Выбор поля
local fieldNames = {
    "Sunflower", "Mushroom", "Blue Flower", "Clover", "Spider",
    "Bamboo", "Pineapple", "Strawberry", "Cactus", "Pumpkin"
}

local selectedField = "Sunflower"
local fieldDropdown = FarmTab:CreateDropdown({
    Name = "🌍 Выберите поле",
    Options = fieldNames,
    CurrentOption = "Sunflower",
    Callback = function(Option)
        selectedField = Option
        local result = BeeSwarm:SetField(Option)
        Rayfield:Notify({
            Title = "Поле изменено",
            Content = result,
            Duration = 3
        })
    end
})

-- Тумблеры
local autoFarmToggle = FarmTab:CreateToggle({
    Name = "🌻 Умный авто-фарм",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            BeeSwarm:SetField(selectedField)
            BeeSwarm:StartSmartAutoFarm()
        else
            BeeSwarm:StopSmartAutoFarm()
        end
    end
})

local autoQuestToggle = FarmTab:CreateToggle({
    Name = "📜 Авто-квесты (каждые 10с)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            BeeSwarm:StartAutoQuests()
        else
            BeeSwarm:StopAutoQuests()
        end
    end
})

local autoConvertToggle = FarmTab:CreateToggle({
    Name = "🍯 Авто-конвертация (каждые 8с)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            BeeSwarm:StartAutoConvert()
        end
    end
})

-- Групповые кнопки
FarmTab:CreateButton({
    Name = "▶️ Запустить ВСЁ",
    Callback = function()
        autoFarmToggle:Set(true)
        autoQuestToggle:Set(true)
        autoConvertToggle:Set(true)
        Rayfield:Notify({
            Title = "Авто-фарм",
            Content = "Все функции запущены!",
            Duration = 3
        })
    end
})

FarmTab:CreateButton({
    Name = "⏹️ Остановить ВСЁ",
    Callback = function()
        autoFarmToggle:Set(false)
        autoQuestToggle:Set(false)
        autoConvertToggle:Set(false)
        Rayfield:Notify({
            Title = "Авто-фарм",
            Content = "Все функции остановлены!",
            Duration = 3
        })
    end
})

-- Вкладка ВИЗУАЛ
local VisualTab = Window:CreateTab("🎨 Визуал", 4439880892)

VisualTab:CreateToggle({
    Name = "📍 Подсветка поля",
    CurrentValue = true,
    Callback = function(Value)
        if Value then
            BeeSwarm:CreateVisuals()
        else
            BeeSwarm:RemoveVisuals()
        end
    end
})

VisualTab:CreateColorPicker({
    Name = "🌈 Цвет подсветки",
    Color = Color3.fromRGB(255, 255, 0),
    Callback = function(Color)
        -- Здесь будет логика изменения цвета
    end
})

VisualTab:CreateToggle({
    Name = "👁️ ESP пчел (в разработке)",
    CurrentValue = false,
    Callback = function(Value)
        Rayfield:Notify({
            Title = "ESP пчел",
            Content = "Функция в разработке",
            Duration = 3
        })
    end
})

-- Вкладка ОПТИМИЗАЦИЯ
local OptimizeTab = Window:CreateTab("⚡ Оптимизация", 4439880892)

OptimizeTab:CreateToggle({
    Name = "⚡ Оптимизация игры",
    CurrentValue = false,
    Callback = function(Value)
        BeeSwarm:OptimizeGame(Value)
        if Value then
            Rayfield:Notify({
                Title = "Оптимизация",
                Content = "Включена (без белого экрана)",
                Duration = 3
            })
        else
            Rayfield:Notify({
                Title = "Оптимизация",
                Content = "Выключена",
                Duration = 3
            })
        end
    end
})

OptimizeTab:CreateSlider({
    Name = "🎯 Дистанция рендера",
    Range = {100, 1000},
    Increment = 50,
    Suffix = "studs",
    CurrentValue = 500,
    Callback = function(Value)
        game:GetService("Lighting").FogEnd = Value
    end
})

OptimizeTab:CreateButton({
    Name = "🔄 Убрать лаги",
    Callback = function()
        -- Чистим мусор
        for _, v in pairs(Workspace:GetChildren()) do
            if v.Name == "FieldVisual" then
                v:Destroy()
            end
        end
        Rayfield:Notify({
            Title = "Оптимизация",
            Content = "Временные объекты удалены",
            Duration = 3
        })
    end
})

-- Вкладка ИНФО
local InfoTab = Window:CreateTab("ℹ️ Информация", 4439880892)

InfoTab:CreateButton({
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

InfoTab:CreateLabel("🎮 Управление:")
InfoTab:CreateLabel("F1 - Вкл/Выкл авто-фарм")
InfoTab:CreateLabel("F2 - Сменить поле (цикл)")
InfoTab:CreateLabel("F3 - Вкл/Выкл оптимизацию")
InfoTab:CreateLabel("RightShift - Меню")
InfoTab:CreateLabel("")
InfoTab:CreateLabel("🐝 Особенности v3.0:")
InfoTab:CreateLabel("- Умный поиск цветов на поле")
InfoTab:CreateLabel("- Автоматические квесты")
InfoTab:CreateLabel("- Подсветка активного поля")
InfoTab:CreateLabel("- Безопасная оптимизация")
InfoTab:CreateLabel("- Точные координаты полей")

-- Горячие клавиши
local UIS = game:GetService("UserInputService")
local fieldIndex = 1

UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F1 then
        autoFarmToggle:Set(not autoFarmToggle.CurrentValue)
        
    elseif input.KeyCode == Enum.KeyCode.F2 then
        fieldIndex = fieldIndex + 1
        if fieldIndex > #fieldNames then fieldIndex = 1 end
        selectedField = fieldNames[fieldIndex]
        fieldDropdown:Set(selectedField)
        
    elseif input.KeyCode == Enum.KeyCode.F3 then
        local optimizeToggle = OptimizeTab:FindFirstChild("Оптимизация игры")
        if optimizeToggle then
            optimizeToggle:Set(not optimizeToggle.CurrentValue)
        end
    end
end)

-- Функция обновления GUI
local function updateGUI()
    -- Здесь можно обновлять информацию
end

-- Уведомление
Rayfield:Notify({
    Title = "🐝 Bee Swarm PRO v3.0",
    Content = "Загружен! F1 - авто-фарм, F2 - сменить поле",
    Duration = 5,
    Image = 4439880892
})

print("✅ Bee Swarm PRO v3.0 готов к работе!")

-- Запускаем обновление GUI
spawn(function()
    while true do
        task.wait(5)
        updateGUI()
    end
end)

return Window
