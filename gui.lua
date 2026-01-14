-- GUI Quest Auto-Farmer v4.0
-- Автор: dachnic7384-bit

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "🐝 Quest Auto-Farmer v4.0",
    LoadingTitle = "Загрузка автономного фармера...",
    LoadingSubtitle = "Только ходьба! Без телепортов!",
    ConfigurationSaving = { Enabled = true, FolderName = "QuestFarmer" },
    Discord = { Enabled = false },
    KeySystem = false,
})

-- Загружаем основной скрипт
local QuestFarmer = loadstring(game:HttpGet("https://raw.githubusercontent.com/dachnic7384-bit/MyRobloxScripts/main/main.lua"))()

-- Вкладка ОСНОВНОЕ
local MainTab = Window:CreateTab("🎯 Основное", 4439880892)

local isRunning = false
local farmerToggle = MainTab:CreateToggle({
    Name = "▶️ Авто-квест фармер",
    CurrentValue = false,
    Callback = function(Value)
        isRunning = Value
        if Value then
            QuestFarmer:StartQuestFarmer()
        else
            QuestFarmer:StopQuestFarmer()
        end
    end
})

MainTab:CreateButton({
    Name = "📊 Показать статус",
    Callback = function()
        QuestFarmer:GetStatus()
        Rayfield:Notify({
            Title = "Статус",
            Content = "Информация в консоли (F9)",
            Duration = 3
        })
    end
})

MainTab:CreateButton({
    Name = "📜 Взять новый квест",
    Callback = function()
        QuestFarmer:TakeNewQuest()
        Rayfield:Notify({
            Title = "Квест",
            Content = "Иду брать новый квест...",
            Duration = 3
        })
    end
})

MainTab:CreateButton({
    Name = "🍯 Конвертировать в мёд",
    Callback = function()
        QuestFarmer:ConvertToHoney()
        Rayfield:Notify({
            Title = "Конвертация",
            Content = "Конвертирую пыльцу в мёд...",
            Duration = 3
        })
    end
})

-- Вкладка НАСТРОЙКИ
local SettingsTab = Window:CreateTab("⚙️ Настройки", 4439880892)

SettingsTab:CreateLabel("🔧 Автоматические действия:")
SettingsTab:CreateLabel("- Авто-поиск цветов для квеста")
SettingsTab:CreateLabel("- Авто-ходьба по полю")
SettingsTab:CreateLabel("- Авто-конвертация при полном инвентаре")
SettingsTab:CreateLabel("- Авто-взятие нового квеста")
SettingsTab:CreateLabel("")
SettingsTab:CreateLabel("🚫 Ограничения:")
SettingsTab:CreateLabel("- ТОЛЬКО ходьба (без телепортов)")
SettingsTab:CreateLabel("- Максимальная скорость 16 studs/s")
SettingsTab:CreateLabel("- Медленные и плавные движения")
SettingsTab:CreateLabel("- Похоже на реального игрока")

SettingsTab:CreateSlider({
    Name = "⏱️ Скорость ходьбы",
    Range = {12, 20},
    Increment = 1,
    Suffix = "studs/s",
    CurrentValue = 16,
    Callback = function(Value)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end
    end
})

-- Вкладка ИНФОРМАЦИЯ
local InfoTab = Window:CreateTab("ℹ️ Информация", 4439880892)

InfoTab:CreateLabel("🐝 Quest Auto-Farmer v4.0")
InfoTab:CreateLabel("Особенности:")
InfoTab:CreateLabel("✅ Только нормальная ходьба")
InfoTab:CreateLabel("✅ Авто-отслеживание квестов")
InfoTab:CreateLabel("✅ Авто-смена полей под квест")
InfoTab:CreateLabel("✅ Авто-конвертация при заполнении")
InfoTab:CreateLabel("✅ Безопасный режим (без телепортов)")
InfoTab:CreateLabel("")
InfoTab:CreateLabel("🎮 Горячие клавиши:")
InfoTab:CreateLabel("F1 - Вкл/выкл фармер")
InfoTab:CreateLabel("F2 - Показать статус")
InfoTab:CreateLabel("F3 - Взять квест")
InfoTab:CreateLabel("RightShift - Меню")

-- Вкладка СТАТИСТИКА
local StatsTab = Window:CreateTab("📈 Статистика", 4439880892)

local statsLabels = {}

-- Функция обновления статистики
local function updateStats()
    local stats = LocalPlayer:FindFirstChild("Stats")
    if stats then
        local honey = stats:FindFirstChild("Honey")
        local pollen = stats:FindFirstChild("Pollen")
        local tokens = stats:FindFirstChild("Tokens")
        
        if honey then
            if not statsLabels.Honey then
                statsLabels.Honey = StatsTab:CreateLabel("🍯 Мёд: " .. honey.Value)
            else
                -- Обновляем существующую метку
                statsLabels.Honey:Set("🍯 Мёд: " .. honey.Value)
            end
        end
        
        if pollen then
            if not statsLabels.Pollen then
                statsLabels.Pollen = StatsTab:CreateLabel("🌻 Пыльца: " .. pollen.Value)
            else
                statsLabels.Pollen:Set("🌻 Пыльца: " .. pollen.Value)
            end
        end
        
        if tokens then
            if not statsLabels.Tokens then
                statsLabels.Tokens = StatsTab:CreateLabel("🎯 Токены: " .. tokens.Value)
            else
                statsLabels.Tokens:Set("🎯 Токены: " .. tokens.Value)
            end
        end
    end
    
    -- Статистика фармера
    local status = QuestFarmer:GetStatus()
    if not statsLabels.Quests then
        statsLabels.Quests = StatsTab:CreateLabel("✅ Квестов выполнено: " .. (status.QuestsCompleted or 0))
    else
        statsLabels.Quests:Set("✅ Квестов выполнено: " .. (status.QuestsCompleted or 0))
    end
end

StatsTab:CreateButton({
    Name = "🔄 Обновить статистику",
    Callback = function()
        updateStats()
    end
})

-- Горячие клавиши
local UIS = game:GetService("UserInputService")

UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F1 then
        farmerToggle:Set(not farmerToggle.CurrentValue)
        
    elseif input.KeyCode == Enum.KeyCode.F2 then
        QuestFarmer:GetStatus()
        
    elseif input.KeyCode == Enum.KeyCode.F3 then
        QuestFarmer:TakeNewQuest()
    end
end)

-- Авто-обновление статистики
spawn(function()
    while true do
        task.wait(5)
        updateStats()
    end
end)

-- Уведомление
Rayfield:Notify({
    Title = "🐝 Quest Auto-Farmer v4.0",
    Content = "Загружен!\nТолько ходьба, без телепортов!\nF1 - включить",
    Duration = 6,
    Image = 4439880892
})

print("✅ Quest Auto-Farmer v4.0 готов!")
print("🎯 Фармит квесты, ходит пешком, конвертирует автоматически!")

return Window
