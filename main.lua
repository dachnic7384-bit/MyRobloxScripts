-- Bee Swarm Simulator Script v1.0
-- Автор: dachnic7384-bit
-- РЕПОЗИТОРИЙ: https://github.com/dachnic7384-bit/MyRobloxScripts

if not game:IsLoaded() then
    game.Loaded:Wait()
end

print("=========================================")
print("🐝 BEE SWARM SIMULATOR SCRIPT")
print("📁 GitHub: github.com/dachnic7384-bit/MyRobloxScripts")
print("=========================================")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- Проверка что мы в правильной игре
if game.PlaceId ~= 1537690962 then
    warn("⚠️ Этот скрипт только для Bee Swarm Simulator!")
    return nil
end

local BeeSwarmScript = {}

-- Авто-фарм пыльцы
function BeeSwarmScript:AutoFarm(enabled)
    if enabled then
        print("🌻 Авто-фарм пыльцы ВКЛЮЧЕН")
        spawn(function()
            while BeeSwarmScript.AutoFarmEnabled do
                wait(0.5)
                -- Авто-сбор пыльцы
                local flowers = Workspace.Flowers:GetChildren()
                for _, flower in pairs(flowers) do
                    if flower:FindFirstChild("Click") then
                        fireclickdetector(flower.Click)
                    end
                end
            end
        end)
    else
        print("🌻 Авто-фарм пыльцы ВЫКЛЮЧЕН")
    end
    BeeSwarmScript.AutoFarmEnabled = enabled
end

-- Авто-вывод пчел
function BeeSwarmScript:AutoConvert(enabled)
    if enabled then
        print("🍯 Авто-вывод пчел ВКЛЮЧЕН")
        spawn(function()
            while BeeSwarmScript.AutoConvertEnabled do
                wait(5)
                -- Авто-конвертация пыльцы в мёд
                local args = {
                    [1] = "Convert",
                    [2] = "All"
                }
                game:GetService("ReplicatedStorage").Events.PlayerHiveCommand:FireServer(unpack(args))
            end
        end)
    else
        print("🍯 Авто-вывод пчел ВЫКЛЮЧЕН")
    end
    BeeSwarmScript.AutoConvertEnabled = enabled
end

-- Авто-применение бустов
function BeeSwarmScript:AutoBoost(enabled)
    if enabled then
        print("⚡ Авто-бусты ВКЛЮЧЕНЫ")
        spawn(function()
            while BeeSwarmScript.AutoBoostEnabled do
                wait(30)
                -- Использование бустов
                local boosts = {"FieldBooster", "Pineapple", "Strawberry", "Blueberry"}
                for _, boost in pairs(boosts) do
                    local args = {[1] = boost}
                    pcall(function()
                        game:GetService("ReplicatedStorage").Events.UseItemFromInventory:FireServer(unpack(args))
                    end)
                end
            end
        end)
    else
        print("⚡ Авто-бусты ВЫКЛЮЧЕНЫ")
    end
    BeeSwarmScript.AutoBoostEnabled = enabled
end

-- Бесконечные способности пчел
function BeeSwarmScript:InfiniteAbilities(enabled)
    if enabled then
        print("♾️ Бесконечные способности ВКЛЮЧЕНЫ")
        local mt = getrawmetatable(game)
        local old = mt.__namecall
        setreadonly(mt, false)
        
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if method == "FireServer" and tostring(self) == "Ability" then
                -- Автоматически перезаряжаем способности
                return
            end
            return old(self, ...)
        end)
    else
        print("♾️ Бесконечные способности ВЫКЛЮЧЕНЫ")
    end
end

-- Телепорт к полям
function BeeSwarmScript:TeleportToField(fieldName)
    local fields = {
        ["Sunflower"] = Vector3.new(35, 5, 10),
        ["Mushroom"] = Vector3.new(60, 5, 60),
        ["Blue Flower"] = Vector3.new(100, 5, 30),
        ["Clover"] = Vector3.new(150, 5, 10),
        ["Spider"] = Vector3.new(-30, 5, 80)
    }
    
    if fields[fieldName] and LocalPlayer.Character then
        LocalPlayer.Character:MoveTo(fields[fieldName])
        return "✅ Телепорт на поле: " .. fieldName
    end
    return "❌ Поле не найдено"
end

-- Информация о улье
function BeeSwarmScript:GetHiveInfo()
    local hive = Workspace:FindFirstChild(LocalPlayer.Name .. "'s Hive")
    if hive then
        print("=== ИНФОРМАЦИЯ ОБ УЛЬЕ ===")
        print("👑 Владелец: " .. LocalPlayer.Name)
        print("🐝 Количество пчел: " .. #hive.Bees:GetChildren())
        print("🍯 Мёд: " .. tostring(LocalPlayer.Stats.Honey.Value))
        print("🌻 Пыльца: " .. tostring(LocalPlayer.Stats.Pollen.Value))
        print("=========================")
    end
end

-- Ускоренная игра
function BeeSwarmScript:SpeedHack(enabled)
    if enabled then
        print("⚡ Ускорение игры ВКЛЮЧЕНО")
        game:GetService("RunService"):Set3dRenderingEnabled(false)
        setfpscap(9999)
    else
        print("⚡ Ускорение игры ВЫКЛЮЧЕНО")
        game:GetService("RunService"):Set3dRenderingEnabled(true)
        setfpscap(60)
    end
end

-- Уведомление
function BeeSwarmScript:ShowNotification()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "🐝 Bee Swarm Script",
        Text = "Скрипт активирован!\nGitHub: dachnic7384-bit",
        Duration = 10,
        Icon = "rbxassetid://4439880892"
    })
end

-- Инициализация
BeeSwarmScript:ShowNotification()

return BeeSwarmScript
