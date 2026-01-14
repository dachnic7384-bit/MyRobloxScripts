-- GUI для Bee Swarm Simulator
-- Автор: dachnic7384-bit

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "🐝 Bee Swarm Simulator Script",
    LoadingTitle = "Загрузка...",
    LoadingSubtitle = "by dachnic7384-bit",
    ConfigurationSaving = { Enabled = true, FolderName = "BeeSwarmConfig" },
    Discord = { Enabled = false },
    KeySystem = false,
})

-- Вкладка Авто-фарм
local FarmTab = Window:CreateTab("🌻 Авто-фарм", 4439880892)

FarmTab:CreateToggle({
    Name = "🌻 Авто-сбор пыльцы",
    CurrentValue = false,
    Callback = function(Value)
        local script = loadstring(game:HttpGet("https://raw.githubusercontent.com/dachnic7384-bit/MyRobloxScripts/main/main.lua"))()
        script:AutoFarm(Value)
    end
})

FarmTab:CreateToggle({
    Name = "🍯 Авто-вывод мёда",
    CurrentValue = false,
    Callback = function(Value)
        local script = loadstring(game:HttpGet("https://raw.githubusercontent.com/dachnic7384-bit/MyRobloxScripts/main/main.lua"))()
        script:AutoConvert(Value)
    end
})

FarmTab:CreateToggle({
    Name = "⚡ Авто-бусты",
    CurrentValue = false,
    Callback = function(Value)
        local script = loadstring(game:HttpGet("https://raw.githubusercontent.com/dachnic7384-bit/MyRobloxScripts/main/main.lua"))()
        script:AutoBoost(Value)
    end
})

FarmTab:CreateToggle({
    Name = "♾️ Бесконечные способности",
    CurrentValue = false,
    Callback = function(Value)
        local script = loadstring(game:HttpGet("https://raw.githubusercontent.com/dachnic7384-bit/MyRobloxScripts/main/main.lua"))()
        script:InfiniteAbilities(Value)
    end
})

-- Вкладка Телепорты
local TeleportTab = Window:CreateTab("🚀 Телепорты", 4439880892)

local fields = {"Sunflower", "Mushroom", "Blue Flower", "Clover", "Spider", "Bamboo", "Pineapple", "Strawberry", "Cactus"}

for _, field in pairs(fields) do
    TeleportTab:CreateButton({
        Name = "➡️ " .. field,
        Callback = function()
            local script = loadstring(game:HttpGet("https://raw.githubusercontent.com/dachnic7384-bit/MyRobloxScripts/main/main.lua"))()
            local result = script:TeleportToField(field)
            Rayfield:Notify({
                Title = "Телепорт",
                Content = result,
                Duration = 3
            })
        end
    })
end

-- Вкладка Читы
local CheatsTab = Window:CreateTab("⚡ Читы", 4439880892)

CheatsTab:CreateToggle({
    Name = "⚡ Ускорение игры (FPS)",
    CurrentValue = false,
    Callback = function(Value)
        local script = loadstring(game:HttpGet("https://raw.githubusercontent.com/dachnic7384-bit/MyRobloxScripts/main/main.lua"))()
        script:SpeedHack(Value)
    end
})

CheatsTab:CreateSlider({
    Name = "🚶 Скорость пчелы",
    Range = {16, 100},
    Increment = 1,
    Suffix = "speed",
    CurrentValue = 25,
    Callback = function(Value)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end
    end
})

CheatsTab:CreateButton({
    Name = "📊 Информация об улье",
    Callback = function()
        local script = loadstring(game:HttpGet("https://raw.githubusercontent.com/dachnic7384-bit/MyRobloxScripts/main/main.lua"))()
        script:GetHiveInfo()
        Rayfield:Notify({
            Title = "Информация",
            Content = "Проверь консоль (F9)",
            Duration = 3
        })
    end
})

-- Вкладка Инфо
local InfoTab = Window:CreateTab("ℹ️ Информация", 4439880892)

InfoTab:CreateLabel("🐝 Bee Swarm Simulator Script")
InfoTab:CreateLabel("Версия: 1.0")
InfoTab:CreateLabel("Автор: dachnic7384-bit")
InfoTab:CreateLabel("GitHub: github.com/dachnic7384-bit")
InfoTab:CreateLabel("")
InfoTab:CreateLabel("Управление:")
InfoTab:CreateLabel("RightShift - меню")
InfoTab:CreateLabel("F9 - консоль")

-- Уведомление
Rayfield:Notify({
    Title = "🐝 Bee Swarm Script",
    Content = "Меню загружено! RightShift - открыть/закрыть",
    Duration = 5,
    Image = 4439880892
})

return Window
