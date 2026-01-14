-- Bee Swarm GUI - Простое меню
-- Автор: dachnic7384-bit

if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Загружаем Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Загружаем основной скрипт
local AutoFarm = loadstring(game:HttpGet("https://raw.githubusercontent.com/dachnic7384-bit/MyRobloxScripts/main/main.lua"))()

-- Создаем окно
local Window = Rayfield:CreateWindow({
    Name = "🐝 Bee Swarm Auto-Farm",
    LoadingTitle = "Загрузка...",
    LoadingSubtitle = "Макрос версия",
    ConfigurationSaving = { Enabled = true, FolderName = "BeeSwarm" },
    Discord = { Enabled = false },
    KeySystem = false,
})

-- =========== ВКЛАДКА: АВТО-ФАРМ ===========
local FarmTab = Window:CreateTab("🌻 Авто-Фарм", 4439880892)

-- Тумблер авто-фарма
local farmToggle = FarmTab:CreateToggle({
    Name = "▶️ Запустить авто-фарм",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            AutoFarm:StartAutoFarm()
        else
            AutoFarm:StopAutoFarm()
        end
    end
})

-- Тумблер авто-конвертации
FarmTab:CreateToggle({
    Name = "🍯 Авто-конвертация",
    CurrentValue = false,
    Callback = function(Value)
        AutoFarm.AutoConvert = Value
    end
})

-- Кнопка конвертации
FarmTab:CreateButton({
    Name = "🍯 Конвертировать сейчас",
    Callback = function()
        AutoFarm:ConvertToHoney()
    end
})

-- Кнопка статуса
FarmTab:CreateButton({
    Name = "📊 Показать статус",
    Callback = function()
        AutoFarm:GetStatus()
    end
})

-- =========== ВКЛАДКА: ТЕЛЕПОРТЫ ===========
local TeleportTab = Window:CreateTab("📍 Телепорты", 4439880892)

-- Список полей
local fields = {"Sunflower", "Mushroom", "Blue Flower", "Clover", "Spider"}

for _, field in pairs(fields) do
    TeleportTab:CreateButton({
        Name = "➡️ " .. field,
        Callback = function()
            AutoFarm:SetField(field)
        end
    })
end

-- =========== ВКЛАДКА: НАСТРОЙКИ ===========
local SettingsTab = Window:CreateTab("⚙️ Настройки", 4439880892)

-- Скорость ходьбы
SettingsTab:CreateSlider({
    Name = "🚶 Скорость ходьбы",
    Range = {16, 50},
    Increment = 1,
    Suffix = "studs/s",
    CurrentValue = 16,
    Callback = function(Value)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end
    end
})

-- Сила прыжка
SettingsTab:CreateSlider({
    Name = "🏃‍♂️ Сила прыжка",
    Range = {50, 150},
    Increment = 10,
    Suffix = "power",
    CurrentValue = 50,
    Callback = function(Value)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = Value
        end
    end
})

-- =========== ВКЛАДКА: ИНФО ===========
local InfoTab = Window:CreateTab("ℹ️ Информация", 4439880892)

InfoTab:CreateLabel("🐝 Bee Swarm Auto-Farm v5.0")
InfoTab:CreateLabel("Автор: dachnic7384-bit")
InfoTab:CreateLabel("GitHub: github.com/dachnic7384-bit")
InfoTab:CreateLabel("")
InfoTab:CreateLabel("🎮 Управление:")
InfoTab:CreateLabel("RightShift - меню")
InfoTab:CreateLabel("F1 - вкл/выкл авто-фарм")
InfoTab:CreateLabel("F2 - сменить поле")

-- =========== ГОРЯЧИЕ КЛАВИШИ ===========
local UIS = game:GetService("UserInputService")
local fieldIndex = 1

UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F1 then
        farmToggle:Set(not farmToggle.CurrentValue)
    elseif input.KeyCode == Enum.KeyCode.F2 then
        fieldIndex = fieldIndex + 1
        if fieldIndex > #fields then fieldIndex = 1 end
        AutoFarm:SetField(fields[fieldIndex])
    end
end)

-- =========== УВЕДОМЛЕНИЕ ===========
Rayfield:Notify({
    Title = "🐝 Auto-Farm v5.0",
    Content = "Загружен! F1 - вкл/выкл",
    Duration = 5,
    Image = 4439880892
})

print("✅ Auto-Farm готов! F1 - включить")

return Window
